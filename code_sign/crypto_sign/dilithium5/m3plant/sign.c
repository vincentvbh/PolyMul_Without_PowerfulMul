#include <stdint.h>
#include "params.h"
#include "sign.h"
#include "packing.h"
#include "polyvec.h"
#include "poly.h"
#include "randombytes.h"
#include "symmetric.h"
#include "smallpoly.h"

/*************************************************
 * Name:        crypto_sign_keypair
 *
 * Description: Generates public and private key.
 *
 * Arguments:   - uint8_t *pk: pointer to output public key (allocated
 *                             array of CRYPTO_PUBLICKEYBYTES bytes)
 *              - uint8_t *sk: pointer to output private key (allocated
 *                             array of CRYPTO_SECRETKEYBYTES bytes)
 *
 * Returns 0 (success)
 **************************************************/
int crypto_sign_keypair(uint8_t* pk, uint8_t* sk)
{
  unsigned int i, j;
  uint8_t seedbuf[2 * SEEDBYTES + CRHBYTES];
  uint8_t tr[SEEDBYTES];
  const uint8_t *rho, *rhoprime, *key;
  uint16_t nonce = 0;
  polyvecl s1;

  /* Get randomness for rho, rhoprime and key */
  randombytes(seedbuf, SEEDBYTES);
  shake256(seedbuf, 2 * SEEDBYTES + CRHBYTES, seedbuf, SEEDBYTES);
  rho = seedbuf;
  rhoprime = rho + SEEDBYTES;
  key = rhoprime + CRHBYTES;

  pack_sk_rho(sk, rho);
  pack_sk_key(sk, key);
  pack_pk_rho(pk, rho);

  /* Sample short vector s1 and immediately store its time-domain version */
  for (i = 0; i < L; i++) {
    poly_uniform_eta(&s1.vec[i], rhoprime, nonce++);
    pack_sk_s1(sk, &s1.vec[i], i);
    /* Move s1 to NTT domain */
    poly_ntt(&s1.vec[i]);
  }

  /* Matrix-vector multiplication */
  for (i = 0; i < K; i++) {
    poly t;
    {
      poly tmp_elem;
      /* expand part of the matrix */
      poly_uniform(&tmp_elem, rho, (i << 8) + 0);
      /* partial matrix-vector multiplication */
      poly_pointwise_montgomery(&t, &tmp_elem, &s1.vec[0]);
      for (j = 1; j < L; j++) {
        poly_uniform(&tmp_elem, rho, (i << 8) + j);
        poly_pointwise_acc_montgomery(&t, &tmp_elem, &s1.vec[j]);
      }
    }
    poly_reduce(&t);
    poly_invntt_tomont(&t);

    /* Add error vector s2 */
    {
      poly s2;
      /* Sample short vector s2 */
      poly_uniform_eta(&s2, rhoprime, nonce++);
      pack_sk_s2(sk, &s2, i);
      poly_add(&t, &t, &s2);
    }

    /* Compute t{0,1} */
    {
      poly t1, t0;
      poly_caddq(&t);
      poly_power2round(&t1, &t0, &t);
      pack_sk_t0(sk, &t0, i);
      pack_pk_t1(pk, &t1, i);
    }
  }

  /* Compute H(rho, t1) and write secret key */
  shake256(tr, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
  pack_sk_tr(sk, tr);

  return 0;
}

/*************************************************
 * Name:        crypto_sign_signature
 *
 * Description: Computes signature.
 *
 * Arguments:   - uint8_t *sig:   pointer to output signature (of length CRYPTO_BYTES)
 *              - size_t *siglen: pointer to output length of signature
 *              - uint8_t *m:     pointer to message to be signed
 *              - size_t mlen:    length of message
 *              - uint8_t *sk:    pointer to bit-packed secret key
 *
 * Returns 0 (success)
 **************************************************/
int crypto_sign_signature(
  uint8_t* sig, size_t* siglen, const uint8_t* m, size_t mlen, const uint8_t* sk)
{
  uint8_t seedbuf[3 * SEEDBYTES + 2 * CRHBYTES];
  uint8_t *rho, *tr, *key, *mu, *rhoprime;
  uint16_t nonce = 0;
  polyvecl mat, y, z;
  polyveck t0, w1, w0;
  poly cp, cp_prime;
  shake256incctx state;

  smallpoly s1_prime[L], s2_prime[K];
  smallpoly *cp_small, *cp_small_prime;
  cp_small = (smallpoly*) &cp;
  cp_small_prime = (smallpoly*) &cp_prime;

  rho = seedbuf;
  tr = rho + SEEDBYTES;
  key = tr + SEEDBYTES;
  mu = key + SEEDBYTES;
  rhoprime = mu + CRHBYTES;
  unpack_sk_new(rho, tr, key, &t0, s1_prime, s2_prime, sk);

  /* Compute CRH(tr, msg) */
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, tr, SEEDBYTES);
  shake256_inc_absorb(&state, m, mlen);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(mu, CRHBYTES, &state);

#ifdef DILITHIUM_RANDOMIZED_SIGNING
  randombytes(rhoprime, CRHBYTES);
#else
  shake256(rhoprime, CRHBYTES, key, SEEDBYTES + CRHBYTES);
#endif

  /* Expand matrix and transform vectors */
  // polyvec_matrix_expand(mat, rho);
  polyvecl_small_ntt(s1_prime);
  polyveck_small_ntt(s2_prime);
  polyveck_double_ntt(&t0);

rej:
  /* Sample intermediate vector y */
  polyvecl_uniform_gamma1(&y, rhoprime, nonce++);

  /* Matrix-vector multiplication */
  z = y;
  polyvecl_ntt(&z);
  for (int i = 0; i < K; ++i){
    for (int j = 0; j < L; ++j) {
      poly_uniform(&mat.vec[j], rho, (i << 8) + j);
    }
    polyvecl_pointwise_acc_montgomery(&w1.vec[i], &mat, &z);
  }
  
  // polyvec_matrix_pointwise_montgomery(&w1, mat, &z);
  polyveck_reduce(&w1);
  polyveck_invntt_tomont(&w1);

  /* Decompose w and call the random oracle */
  polyveck_caddq(&w1);
  polyveck_decompose(&w1, &w0, &w1);
  polyveck_pack_w1(sig, &w1);

  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, CRHBYTES);
  shake256_inc_absorb(&state, sig, K * POLYW1_PACKEDBYTES);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(sig, SEEDBYTES, &state);

  // poly_challenge(&cp, sig);
  poly_challenge_new(&cp, sig);
  poly_double_ntt_precomp(&cp_prime, &cp);

  /* Compute z, reject if it reveals secret */
  polyvecl_small_basemul_invntt(&z, cp_small, cp_small_prime, s1_prime);

  polyvecl_add(&z, &z, &y);
  polyvecl_reduce(&z);
  if (polyvecl_chknorm(&z, GAMMA1 - BETA)) {
    goto rej;
  }

  /* Write signature */
  pack_sig_z(sig, &z);
  unsigned int hint_n = 0;
  unsigned int hints_written = 0;
  /* Check that subtracting cs2 does not change high bits of w and low bits
   * do not reveal secret information */
  for (unsigned int i = 0; i < K; ++i) {
    poly* tmp = &z.vec[0];
    poly_small_basemul_invntt(tmp, cp_small, cp_small_prime, &s2_prime[i]);

    poly_sub(&w0.vec[i], &w0.vec[i], tmp);
    poly_reduce(&w0.vec[i]);
    if (poly_chknorm(&w0.vec[i], GAMMA2 - BETA))
      goto rej;

    /* Compute hints for w1 */
    poly_double_basemul_invntt(tmp, &cp, &cp_prime, &t0.vec[i]);
    poly_reduce(tmp);

    if (poly_chknorm(tmp, GAMMA2))
      goto rej;
    poly_add(&w0.vec[i], &w0.vec[i], tmp);
    hint_n += poly_make_hint(tmp, &w0.vec[i], &w1.vec[i]);
    if (hint_n > OMEGA) {
      goto rej;
    }
    pack_sig_h(sig, tmp, i, &hints_written);
  }
  pack_sig_h_zero(sig, &hints_written);
  *siglen = CRYPTO_BYTES;
  return 0;
}

/*************************************************
 * Name:        crypto_sign
 *
 * Description: Compute signed message.
 *
 * Arguments:   - uint8_t *sm: pointer to output signed message (allocated
 *                             array with CRYPTO_BYTES + mlen bytes),
 *                             can be equal to m
 *              - size_t *smlen: pointer to output length of signed
 *                               message
 *              - const uint8_t *m: pointer to message to be signed
 *              - size_t mlen: length of message
 *              - const uint8_t *sk: pointer to bit-packed secret key
 *
 * Returns 0 (success)
 **************************************************/
int crypto_sign(uint8_t* sm, size_t* smlen, const uint8_t* m, size_t mlen, const uint8_t* sk)
{
  size_t i;

  for (i = 0; i < mlen; ++i) sm[CRYPTO_BYTES + mlen - 1 - i] = m[mlen - 1 - i];
  crypto_sign_signature(sm, smlen, sm + CRYPTO_BYTES, mlen, sk);
  *smlen += mlen;
  return 0;
}

/*************************************************
 * Name:        crypto_sign_verify
 *
 * Description: Verifies signature.
 *
 * Arguments:   - uint8_t *m: pointer to input signature
 *              - size_t siglen: length of signature
 *              - const uint8_t *m: pointer to message
 *              - size_t mlen: length of message
 *              - const uint8_t *pk: pointer to bit-packed public key
 *
 * Returns 0 if signature could be verified correctly and -1 otherwise
 **************************************************/

int crypto_sign_verify(const uint8_t* sig,
                       size_t siglen,
                       const uint8_t* m,
                       size_t mlen,
                       const uint8_t* pk)
{
  unsigned int i;
  uint8_t buf[K * POLYW1_PACKEDBYTES];
  uint8_t rho[SEEDBYTES];
  uint8_t mu[CRHBYTES];
  uint8_t c[SEEDBYTES];
  uint8_t c2[SEEDBYTES];
  poly cp;
  polyvecl mat, z;
  polyveck t1, w1, h;
  shake256incctx state;

  if (siglen != CRYPTO_BYTES)
    return -1;

  unpack_pk(rho, &t1, pk);
  if (unpack_sig(c, &z, &h, sig))
    return -1;
  if (polyvecl_chknorm(&z, GAMMA1 - BETA))
    return -1;

  /* Compute CRH(h(rho, t1), msg) */
  shake256(mu, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, SEEDBYTES);
  shake256_inc_absorb(&state, m, mlen);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(mu, CRHBYTES, &state);

  /* Matrix-vector multiplication; compute Az - c2^dt1 */
  poly_challenge(&cp, c);
  // polyvec_matrix_expand(mat, rho);
  polyvecl_ntt_leaktime(&z);
  for (int i = 0; i < K; ++i) {
    for (int j = 0; j < L; ++j) {
      poly_uniform(&mat.vec[j], rho, (i << 8) + j);
    }
    polyvecl_pointwise_acc_montgomery_leaktime(&w1.vec[i], &mat, &z);
  }
  
  // polyvec_matrix_pointwise_montgomery_leaktime(&w1, mat, &z);

  poly_ntt_leaktime(&cp);
  polyveck_shiftl(&t1);
  polyveck_ntt_leaktime(&t1);
  polyveck_pointwise_poly_montgomery(&t1, &cp, &t1);

  polyveck_sub(&w1, &w1, &t1);
  polyveck_reduce(&w1);
  polyveck_invntt_tomont_leaktime(&w1);

  /* Reconstruct w1 */
  polyveck_caddq(&w1);
  polyveck_use_hint(&w1, &w1, &h);
  polyveck_pack_w1(buf, &w1);

  /* Call random oracle and verify challenge */
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, CRHBYTES);
  shake256_inc_absorb(&state, buf, K * POLYW1_PACKEDBYTES);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(c2, SEEDBYTES, &state);
  for (i = 0; i < SEEDBYTES; ++i)
    if (c[i] != c2[i])
      return -1;

  return 0;
}

/*************************************************
 * Name:        crypto_sign_open
 *
 * Description: Verify signed message.
 *
 * Arguments:   - uint8_t *m: pointer to output message (allocated
 *                            array with smlen bytes), can be equal to sm
 *              - size_t *mlen: pointer to output length of message
 *              - const uint8_t *sm: pointer to signed message
 *              - size_t smlen: length of signed message
 *              - const uint8_t *pk: pointer to bit-packed public key
 *
 * Returns 0 if signed message could be verified correctly and -1 otherwise
 **************************************************/
int crypto_sign_open(uint8_t* m, size_t* mlen, const uint8_t* sm, size_t smlen, const uint8_t* pk)
{
  size_t i;

  if (smlen < CRYPTO_BYTES)
    goto badsig;

  *mlen = smlen - CRYPTO_BYTES;
  if (crypto_sign_verify(sm, CRYPTO_BYTES, sm + CRYPTO_BYTES, *mlen, pk))
    goto badsig;
  else {
    /* All good, copy msg, return 0 */
    for (i = 0; i < *mlen; ++i) m[i] = sm[CRYPTO_BYTES + i];
    return 0;
  }

badsig:
  /* Signature verification failed */
  *mlen = -1;
  for (i = 0; i < smlen; ++i) m[i] = 0;

  return -1;
}