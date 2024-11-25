#include "fips202.h"
#include "packing.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "randombytes.h"
#include "sign.h"
#include "ntt.h"
#include "symmetric.h"
#include "rounding.h"
#include <stdint.h>
#include <stddef.h>

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

    polyveck t1;
    poly t, tt;

    uint8_t seedbuf[2 * SEEDBYTES + CRHBYTES];
    uint8_t tr[SEEDBYTES];
    const uint8_t *rho, *rhoprime, *key;


    /* Get randomness for rho, rhoprime and key */
    randombytes(seedbuf, SEEDBYTES);
    shake256(seedbuf, 2 * SEEDBYTES + CRHBYTES, seedbuf, SEEDBYTES);
    rho = seedbuf;
    rhoprime = rho + SEEDBYTES;
    key = rhoprime + CRHBYTES;

    /* Expand matrix */

    /* Sample short vectors s1 and s2 */

    /* Matrix-vector multiplication */

    poly_uniform_eta(&t, rhoprime, 0);
    polyeta_pack(sk + 3 * SEEDBYTES + 0 * POLYETA_PACKEDBYTES, &t);
    poly_ntt(&t);
    for(size_t i = 0; i < K; i++){
        poly_uniform(&tt, rho, (uint16_t)((i << 8) + 0));
        point_mul_on_the_fly((int32_t*)&t1.vec[i].coeffs, (int32_t*)&t.coeffs, (int32_t*)&tt.coeffs);
    }

    for(size_t j = 1; j < L; j++){
        poly_uniform_eta(&t, rhoprime, j);
        polyeta_pack(sk + 3 * SEEDBYTES + j * POLYETA_PACKEDBYTES, &t);
        poly_ntt(&t);
        for(size_t i = 0; i < K; i++){
            poly_uniform(&tt, rho, (uint16_t)((i << 8) + j));
            point_mul_on_the_fly((int32_t*)&tt.coeffs, (int32_t*)&t.coeffs, (int32_t*)&tt.coeffs);
            poly_add(&t1.vec[i], &t1.vec[i], &tt);
        }
    }

    polyveck_reduce(&t1);

    for (size_t i = 0; i < K; i++) 
    {
        invntt((int32_t*)&(t1.vec[i].coeffs));
    }

    /* Add error vector s2 */
    /* Extract t1 and write public key */

    for(size_t i = 0; i < K; i++){
        poly_uniform_eta(&t, rhoprime, L + i);
        polyeta_pack(sk + 3 * SEEDBYTES + L * POLYETA_PACKEDBYTES + i * POLYETA_PACKEDBYTES, &t);
        poly_add(&t1.vec[i], &t1.vec[i], &t);
        poly_caddq(&t1.vec[i]);
        poly_power2round(&t1.vec[i], &t, &t1.vec[i]);
        polyt0_pack(sk + 3 * SEEDBYTES + (L + K) * POLYETA_PACKEDBYTES + i * POLYT0_PACKEDBYTES, &t);
    }

    pack_pk(pk, rho, &t1);

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

    polyveck w1;
    poly cp;
    poly t, tt;
    int32_t cp_small[256];

    uint8_t seedbuf[3 * SEEDBYTES + 2 * CRHBYTES];
    uint8_t *rho, *tr, *key, *mu, *rhoprime;
    uint16_t nonce = 0;
    int discard;
    unsigned int n;

    size_t k;

    shake256incctx state;

    rho = seedbuf;
    tr = rho + SEEDBYTES;
    key = tr + SEEDBYTES;
    mu = key + SEEDBYTES;
    rhoprime = mu + CRHBYTES;

    unpack_sk_rho_tr_key(rho, tr, key, sk);

    /* Compute CRH(tr, msg) */
    shake256_inc_init(&state);
    shake256_inc_absorb(&state, tr, SEEDBYTES);
    shake256_inc_absorb(&state, m, mlen);
    shake256_inc_finalize(&state);
    shake256_inc_squeeze(mu, CRHBYTES, &state);
    shake256_inc_ctx_release(&state);

    shake256(rhoprime, CRHBYTES, key, SEEDBYTES + CRHBYTES);

rej:
    /* Sample intermediate vector y */

    /* Expand matrix and transform vectors */
    /* Matrix-vector multiplication */

    poly_uniform_gamma1(&t, rhoprime, (uint16_t)(L * nonce + 0));
    poly_ntt(&t);
    for (size_t i = 0; i < K; i++) 
    {
        poly_uniform(&tt, rho, (uint16_t) ((i << 8) + 0));
        point_mul_on_the_fly((int32_t*)&w1.vec[i].coeffs, (int32_t*)&tt.coeffs, (int32_t*)&t.coeffs);
    }

    for(size_t j = 1; j < L; j++)
    {
        poly_uniform_gamma1(&t, rhoprime, (uint16_t)(L * nonce + j));
        poly_ntt(&t);
        for(size_t i = 0; i < K; i++){
            poly_uniform(&tt, rho, (uint16_t) ((i << 8) + j));
            point_mul_on_the_fly((int32_t*)&tt.coeffs, (int32_t*)&tt.coeffs, (int32_t*)&t.coeffs);
            poly_add(&w1.vec[i], &w1.vec[i], &tt);
        }
    }

    polyveck_reduce(&w1);
    for (size_t i = 0; i < K; i++) {
        invntt((int32_t*)&w1.vec[i].coeffs);
    }
    polyveck_caddq(&w1);

    /* Decompose w and call the random oracle */

    for(size_t i = 0; i < K; i++){
        poly_decompose_a1(&t, &w1.vec[i]);
        polyw1_pack(sig + i * POLYW1_PACKEDBYTES, &t);
    }

    shake256_inc_init(&state);
    shake256_inc_absorb(&state, mu, CRHBYTES);
    shake256_inc_absorb(&state, sig, K * POLYW1_PACKEDBYTES);
    shake256_inc_finalize(&state);
    shake256_inc_squeeze(sig, SEEDBYTES, &state);
    shake256_inc_ctx_release(&state);
    poly_challenge(&cp, sig);
    for(size_t cnt_i = 0 ; cnt_i < 256 ; cnt_i ++) cp_small[cnt_i] = cp.coeffs[cnt_i];
    ntt_small(cp_small);
    poly_ntt(&cp);

    discard = 0;

    pack_sig_setup(sig, sig);

    /* Compute z, reject if it reveals secret */

    for(size_t i = 0; i < L; i++)
    {
        polyeta_unpack(&t, sk + 3 * SEEDBYTES + i * POLYETA_PACKEDBYTES);
        ntt_small((int32_t*)&t.coeffs);        
        point_mul_small((int32_t*)&t.coeffs, cp_small, (int32_t*)&t.coeffs);
        invntt_small((int32_t*)&t.coeffs);
        for (size_t cnt_i = 0; cnt_i < 256; cnt_i++) t.coeffs[cnt_i] = fnt_freeze(t.coeffs[cnt_i]);
        poly_uniform_gamma1(&tt, rhoprime, L * nonce + i);
        poly_add(&t, &t, &tt);
        poly_reduce(&t);
        discard |= poly_chknorm(&t, GAMMA1 - BETA);
        polyz_pack(sig + SEEDBYTES + i * POLYZ_PACKEDBYTES, &t);
    }

    nonce++;

    if(discard){
        goto rej;
    }


    /* Check that subtracting cs2 does not change high bits of w and low bits
     * do not reveal secret information */

    n = 0;
    k = 0;

    for(size_t i = 0; i < K; i++)
    {
        polyeta_unpack(&tt, sk + 3 * SEEDBYTES + L * POLYETA_PACKEDBYTES + i * POLYETA_PACKEDBYTES);
        ntt_small((int32_t*)&tt.coeffs);        
        point_mul_small((int32_t*)&tt.coeffs, cp_small, (int32_t*)&tt.coeffs);
        invntt_small((int32_t*)&tt.coeffs);
        for (size_t cnt_i = 0; cnt_i < 256; cnt_i++) tt.coeffs[cnt_i] = fnt_freeze(tt.coeffs[cnt_i]);

        poly_decompose_a0(&t, &w1.vec[i]);
        poly_sub(&tt, &t, &tt);
        poly_reduce(&tt);
        if(poly_chknorm(&tt, GAMMA2 - BETA)){
            goto rej;
        }

        polyt0_unpack(&tt, sk + 3 * SEEDBYTES + (L + K) * POLYETA_PACKEDBYTES + i * POLYT0_PACKEDBYTES);
        poly_ntt(&tt);
        point_mul_on_the_fly((int32_t*)&tt.coeffs, (int32_t*)&cp.coeffs, (int32_t*)&tt.coeffs);
        invntt((int32_t*)&tt.coeffs);
        poly_reduce(&tt);
        if(poly_chknorm(&tt, GAMMA2)){
            goto rej;
        }
        poly_add(&t, &t, &tt);
        n += poly_make_hint(&t, &t, &w1.vec[i]);

        if (n > OMEGA) {
           goto rej;
        }

        for(size_t j = 0; j < N; j++){
            if(t.coeffs[j] != 0){
                sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + k++] = (uint8_t) j;
            }
        }
        sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + OMEGA + i] = (uint8_t) k;

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

    polyvecl z;
    poly cp;
    poly t, tt;

    uint8_t buf[K * POLYW1_PACKEDBYTES];
    uint8_t rho[SEEDBYTES];
    uint8_t mu[CRHBYTES];
    uint8_t c[SEEDBYTES];
    uint8_t c2[SEEDBYTES];
    shake256incctx state;
    size_t k;

    if (siglen != CRYPTO_BYTES) {
        return -1;
    }

    unpack_sig_c_z(c, &z, sig);

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
    poly_ntt(&cp);

    polyvecl_ntt(&z);

    unpack_pk_rho(rho, pk);

    k = 0;

    for(size_t i = 0; i < K; i++){
        poly_uniform(&tt, rho, (uint16_t) ((i << 8) + 0));
        point_mul_on_the_fly((int32_t*)&t.coeffs, (int32_t*)&z.vec[0].coeffs, (int32_t*)&tt.coeffs);
        for(size_t j = 1; j < L; j++){
            poly_uniform(&tt, rho, (uint16_t) ((i << 8) + j));
            point_mul_on_the_fly((int32_t*)&tt.coeffs, (int32_t*)&z.vec[j].coeffs, (int32_t*)&tt.coeffs);
            poly_add(&t, &t, &tt);
        }
        // unpack_pk_t1
        polyt1_unpack(&tt, pk + SEEDBYTES + i * POLYT1_PACKEDBYTES);
        poly_shiftl(&tt);
        poly_ntt(&tt);
        point_mul_on_the_fly((int32_t*) &tt.coeffs, (int32_t*)&tt.coeffs, (int32_t*)&cp.coeffs);

        poly_sub(&t, &t, &tt);
        poly_reduce(&t);
        invntt((int32_t*)&t.coeffs);

        poly_caddq(&t);

        /* Decode h */
        for (size_t j = 0; j < N; ++j) {
            tt.coeffs[j] = 0;
        }

        if (sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + OMEGA + i] < k ||
            sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + OMEGA + i] > OMEGA) {
            return -1;
        }

        for (size_t j = k; j < sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + OMEGA + i]; ++j) {
            /* Coefficients are ordered for strong unforgeability */
            if (j > k && sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + j] <=
                         sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + j - 1]) {
                return -1;
            }
            tt.coeffs[sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + j]] = 1;
        }

        k = sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + OMEGA + i];

        poly_use_hint(&t, &t, &tt);
        polyw1_pack(buf + i * POLYW1_PACKEDBYTES, &t);

    }

    for (size_t j = k; j < OMEGA; ++j) {
        if (sig[SEEDBYTES + L * POLYZ_PACKEDBYTES + j]) {
            return -1;
        }
    }

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
