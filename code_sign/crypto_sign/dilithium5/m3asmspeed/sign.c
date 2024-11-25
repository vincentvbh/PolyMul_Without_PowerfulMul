
#include <stdint.h>
#include <stddef.h>
#include <memory.h>

#include "fips202.h"
#include "packing.h"
#include "params.h"
#include "ntt.h"
#include "poly.h"
#include "polyvec.h"
#include "randombytes.h"
#include "sign.h"
#include "symmetric.h"
#include "rounding.h"
#include "packing.h"

#include "smallpoly.h"
#include "smallntt.h"
#include "small_pack.h"


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
int crypto_sign_keypair(uint8_t *pk, uint8_t *sk) {

    uint8_t seedbuf[2 * SEEDBYTES + CRHBYTES];
    uint8_t tr[SEEDBYTES];
    const uint8_t *rho, *rhoprime, *key;
    polyvecl s1, row;
    poly elem0, elem1;

    /* Get randomness for rho, rhoprime and key */
    randombytes(seedbuf, SEEDBYTES);
    shake256(seedbuf, 2 * SEEDBYTES + CRHBYTES, seedbuf, SEEDBYTES);
    rho = seedbuf;
    rhoprime = rho + SEEDBYTES;
    key = rhoprime + CRHBYTES;

    pack_pk_rho(pk, rho);

    /* Sample short vectors s1 and s2 */
    polyvecl_uniform_eta(&s1, rhoprime, 0);

    for(size_t i = 0; i < L; i++){
        polyeta_pack(sk + 3 * SEEDBYTES + i * POLYETA_PACKEDBYTES, &s1.vec[i]);
    }

    polyvecl_ntt(&s1);

    for(size_t i = 0; i < K; i++){

        /* Expand row */
        polyvecl_expand(&row, rho, i);

        /* Matrix-vector multiplication */
        polyvecl_pointwise_acc_montgomery(&elem1, &row, &s1);
        poly_reduce(&elem1);
        poly_invntt_tomont(&elem1);

        /* Add error vector s2 */
        poly_uniform_eta(&elem0, rhoprime, L + i);
        polyeta_pack(sk + 3 * SEEDBYTES + L * POLYETA_PACKEDBYTES + i * POLYETA_PACKEDBYTES, &elem0);
        poly_add(&elem1, &elem1, &elem0);

        /* Extract t1 and write public key */
        poly_caddq(&elem1);
        poly_power2round(&elem1, &elem0, &elem1);
        polyt0_pack(sk + 3 * SEEDBYTES + (L + K) * POLYETA_PACKEDBYTES + i * POLYT0_PACKEDBYTES, &elem0);
        polyt1_pack(pk + SEEDBYTES + i * POLYT1_PACKEDBYTES, &elem1);

    }

    /* Compute H(rho, t1) and write secret key */
    shake256(tr, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
    pack_sk_rho_tr_key(sk, rho, tr, key);

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
int crypto_sign_signature(uint8_t *sig,
        size_t *siglen,
        const uint8_t *m,
        size_t mlen,
        const uint8_t *sk) {

    unsigned int n;
    size_t k;
    uint8_t seedbuf[3 * SEEDBYTES + 2 * CRHBYTES];
    uint8_t *rho, *tr, *key, *mu, *rhoprime;
    uint16_t nonce = 0;

    polyvecl s1, y, z, row;
    polyveck s2, w1, t0, w0;
    poly h_elem;
    poly cp_small;
    poly cp_double, cp_double_extended;
    int16_t *ptr_small = (int16_t*) &cp_double;

    shake256incctx state;

    rho = seedbuf;
    tr = rho + SEEDBYTES;
    key = tr + SEEDBYTES;
    mu = key + SEEDBYTES;
    rhoprime = mu + CRHBYTES;

    unpack_sk_small_t0(rho, tr, key, &t0, &s1, &s2, sk);

    /* Compute CRH(tr, msg) */
    shake256_inc_init(&state);
    shake256_inc_absorb(&state, tr, SEEDBYTES);
    shake256_inc_absorb(&state, m, mlen);
    shake256_inc_finalize(&state);
    shake256_inc_squeeze(mu, CRHBYTES, &state);
    shake256_inc_ctx_release(&state);

    shake256(rhoprime, CRHBYTES, key, SEEDBYTES + CRHBYTES);

    polyvecl_ntt_small(&s1);
    polyveck_ntt_small(&s2);
    polyveck_double_ntt(&t0);

rej:
    /* Sample intermediate vector y */
    polyvecl_uniform_gamma1(&y, rhoprime, nonce++);

    /* Expand matrix and transform vectors */
    /* Matrix-vector multiplication */
    z = y;
    polyvecl_ntt(&z);
    for(size_t i = 0; i < K; i++){
        polyvecl_expand(&row, rho, i);
        polyvecl_pointwise_acc_montgomery(&w1.vec[i], &row, &z);
    }

    polyveck_reduce(&w1);
    polyveck_invntt_tomont(&w1);
    polyveck_caddq(&w1);

    /* Decompose w and call the random oracle */
    polyveck_decompose(&w1, &w0, &w1);
    polyveck_pack_w1(sig, &w1);

    shake256_inc_init(&state);
    shake256_inc_absorb(&state, mu, CRHBYTES);
    shake256_inc_absorb(&state, sig, K * POLYW1_PACKEDBYTES);
    shake256_inc_finalize(&state);
    shake256_inc_squeeze(sig, SEEDBYTES, &state);
    shake256_inc_ctx_release(&state);

    poly_challenge_new(&cp_double, sig);

    for(size_t i = 0; i < N; i++){
        cp_small.coeffs[i] = ptr_small[i];
    }
    poly_ntt_small(&cp_small);

    poly_double_ntt_precomp(&cp_double_extended, &cp_double);

    pack_sig_setup(sig, sig);

    /* Compute z, reject if it reveals secret */
    polyvecl_pointwise_poly_montgomery_small(&z, &cp_small, &s1);
    polyvecl_invntt_tomont_small(&z);
    polyvecl_add(&z, &z, &y);
    polyvecl_reduce(&z);
    if (polyvecl_chknorm(&z, GAMMA1 - BETA)) {
        goto rej;
    }

    pack_sig_z(sig + SEEDBYTES, &z);

    n = 0;
    k = 0;
    for(size_t i = 0; i < K; i++){
        /* Check that subtracting cs2 does not change high bits of w and low bits
        * do not reveal secret information */
        poly_pointwise_montgomery_small(&h_elem, &cp_small, &s2.vec[i]);
        poly_invntt_tomont_small(&h_elem);
        poly_sub(&w0.vec[i], &w0.vec[i], &h_elem);
        poly_reduce(&w0.vec[i]);
        if(poly_chknorm(&w0.vec[i], GAMMA2 - BETA)){
            goto rej;
        }

        /* Compute hints for w1 */
        poly_double_basemul_invntt(&h_elem, &cp_double, &cp_double_extended, &t0.vec[i]);
        poly_reduce(&h_elem);
        if(poly_chknorm(&h_elem, GAMMA2)){
            goto rej;
        }

        poly_add(&w0.vec[i], &w0.vec[i], &h_elem);
        n += poly_make_hint(&h_elem, &w0.vec[i], &w1.vec[i]);
        if(n > OMEGA){
            goto rej;
        }

        k = pack_sig_h_elem(sig + SEEDBYTES + L * POLYZ_PACKEDBYTES, &h_elem, i, k);

    }

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
int crypto_sign(uint8_t *sm,
        size_t *smlen,
        const uint8_t *m,
        size_t mlen,
        const uint8_t *sk) {
    size_t i;

    for (i = 0; i < mlen; ++i) {
        sm[CRYPTO_BYTES + mlen - 1 - i] = m[mlen - 1 - i];
    }
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
int crypto_sign_verify(const uint8_t *sig,
        size_t siglen,
        const uint8_t *m,
        size_t mlen,
        const uint8_t *pk) {

    uint8_t buf[K * POLYW1_PACKEDBYTES];
    uint8_t rho[SEEDBYTES];
    uint8_t mu[CRHBYTES];
    uint8_t c[SEEDBYTES];
    uint8_t c2[SEEDBYTES];
    poly cp;
    polyvecl z, row;
    polyveck t1, w1, h;
    shake256incctx state;

    if (siglen != CRYPTO_BYTES) {
        return -1;
    }

    unpack_pk(rho, &t1, pk);
    if (unpack_sig(c, &z, &h, sig)) {
        return -1;
    }
    if (polyvecl_chknorm(&z, GAMMA1 - BETA)) {
        return -1;
    }

    /* Compute CRH(H(rho, t1), msg) */
    shake256(mu, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
    shake256_inc_init(&state);
    shake256_inc_absorb(&state, mu, SEEDBYTES);
    shake256_inc_absorb(&state, m, mlen);
    shake256_inc_finalize(&state);
    shake256_inc_squeeze(mu, CRHBYTES, &state);
    shake256_inc_ctx_release(&state);

    /* Matrix-vector multiplication; compute Az - c2^dt1 */
    poly_challenge(&cp, c);

    polyvecl_ntt_fast(&z);
    for(size_t i = 0; i < K; i++){
        for(size_t j = 0; j < L; j++){
            poly_uniform(&row.vec[j], rho, (uint16_t)((i << 8) + j));
        }
        polyvecl_pointwise_acc_montgomery_fast(&w1.vec[i], &row, &z);
    }

    poly_ntt_fast(&cp);
    polyveck_shiftl(&t1);
    polyveck_ntt_fast(&t1);
    polyveck_pointwise_poly_montgomery_fast(&t1, &cp, &t1);

    polyveck_sub(&w1, &w1, &t1);
    polyveck_reduce(&w1);
    polyveck_invntt_tomont_fast(&w1);

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
    shake256_inc_ctx_release(&state);
    for (size_t i = 0; i < SEEDBYTES; ++i) {
        if (c[i] != c2[i]) {
            return -1;
        }
    }

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
int crypto_sign_open(uint8_t *m,
        size_t *mlen,
        const uint8_t *sm,
        size_t smlen,
        const uint8_t *pk) {
    size_t i;

    if (smlen < CRYPTO_BYTES) {
        goto badsig;
    }

    *mlen = smlen - CRYPTO_BYTES;
    if (crypto_sign_verify(sm, CRYPTO_BYTES, sm + CRYPTO_BYTES, *mlen, pk)) {
        goto badsig;
    } else {
        /* All good, copy msg, return 0 */
        for (i = 0; i < *mlen; ++i) {
            m[i] = sm[CRYPTO_BYTES + i];
        }
        return 0;
    }

badsig:
    /* Signature verification failed */
    *mlen = (size_t) -1;
    for (i = 0; i < smlen; ++i) {
        m[i] = 0;
    }

    return -1;
}
