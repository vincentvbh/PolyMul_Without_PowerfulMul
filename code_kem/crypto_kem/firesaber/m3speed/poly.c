#include "poly.h"
#include "cbd.h"
#include "fips202.h"
#include "pack_unpack.h"

#include "Hom.h"

#include <stdio.h>
#include <assert.h>

#include "hal.h"

char out[128];

#define h1 (1 << (SABER_EQ - SABER_EP - 1))
#define h2 ((1 << (SABER_EP - 2)) - (1 << (SABER_EP - SABER_ET - 1)) + (1 << (SABER_EQ - SABER_EP - 1)))
#define MAX(a,b) (((a)>(b))?(a):(b))

extern void __asm_poly_add(uint16_t*, uint16_t*, uint16_t*);

static inline shake128incctx shake128_absorb_seed(const uint8_t seed[SABER_SEEDBYTES]){

    shake128incctx ctx;
    shake128_inc_init(&ctx);
    shake128_inc_absorb(&ctx, seed, SABER_SEEDBYTES);
    shake128_inc_finalize(&ctx);

    return ctx;

}

void MatrixVectorMulKeyPairNTT_A( uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    int32_t s_Hom_M[32 * 7 * 8];
    int32_t A_Hom_V[32 * 7 * 4];
    int32_t acc_Hom[SABER_L * 32 * 7 * 4];

    uint16_t poly[SABER_N];
    int32_t poly_int32[SABER_N];

    uint8_t shake_out[MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES)];

    uint8_t *seed_A = pk + SABER_POLYVECCOMPRESSEDBYTES;
    uint8_t *seed_s = sk;

    size_t i, j;

    shake128incctx shake_s_ctx = shake128_absorb_seed(seed_s);
    shake128incctx shake_A_ctx = shake128_absorb_seed(seed_A);

    for (i = 0; i < SABER_L; i++) {

        shake128_inc_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(poly, shake_out);
#ifdef SABER_COMPRESS_SECRETKEY
        POLmu2BS(sk + i * SABER_POLYSECRETBYTES, poly); // sk <- s
#else
        POLq2BS(sk + i * SABER_POLYSECRETBYTES, poly);
#endif

        for(size_t k = 0; k < SABER_N; k++){
            poly_int32[k] = (int32_t)(int16_t)poly[k];
        }

        Hom_M(s_Hom_M, poly_int32);

        for (j = 0; j < SABER_L; j++) {

            shake128_inc_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);
            BS2POLq(shake_out, poly);

            for(size_t k = 0; k < SABER_N; k++){
                poly_int32[k] = (int32_t)(int16_t)poly[k];
            }

            Hom_V(A_Hom_V, poly_int32);

            if (i == 0) {
                __asm_TMVP_mul_4x4_full(acc_Hom + j * 32 * 7 * 4, s_Hom_M, A_Hom_V);
            } else {
                __asm_TMVP_mla_4x4_full(acc_Hom + j * 32 * 7 * 4, s_Hom_M, A_Hom_V);
            }

        }
    }

    shake128_inc_ctx_release(&shake_A_ctx);
    shake128_inc_ctx_release(&shake_s_ctx);

    for (i = 0; i < SABER_L; i++) {

        Hom_I(poly_int32, acc_Hom + i * 32 * 7 * 4);

        for (j = 0; j < SABER_N; j++) {
            poly[j] = (((uint16_t)poly_int32[j] + h1) >> (SABER_EQ - SABER_EP));
        }

        POLp2BS(pk + i * SABER_POLYCOMPRESSEDBYTES, poly);
    }

}

uint32_t MatrixVectorMulEncNTT_A(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare){

    int32_t s_Hom_M[SABER_L * 32 * 7 * 8];
    int32_t A_Hom_V[32 * 7 * 4];
    int32_t acc_Hom[32 * 7 * 4];

    uint16_t poly[SABER_N];
    int32_t poly_int32[SABER_N];

    uint16_t acc[SABER_N];

    uint8_t shake_out[MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES)];

    uint16_t *mp = poly;

    size_t i, j;
    uint32_t fail = 0;

    shake128incctx shake_s_ctx = shake128_absorb_seed(seed_s);

    for(i = 0; i < SABER_L; i++){
        shake128_inc_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(poly, shake_out);
        for(size_t k = 0; k < SABER_N; k++){
            poly_int32[k] = (int32_t)(int16_t)poly[k];
        }
        Hom_M(s_Hom_M + i * 32 * 7 * 8, poly_int32);
    }

    shake128_inc_ctx_release(&shake_s_ctx);

    shake128incctx shake_A_ctx = shake128_absorb_seed(seed_A);

    for (i = 0; i < SABER_L; i++) {

        for (j = 0; j < SABER_L; j++) {

            shake128_inc_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);
            BS2POLq(shake_out, poly);

            for(size_t k = 0; k < SABER_N; k++){
                poly_int32[k] = (int32_t)(int16_t)poly[k];
            }

            Hom_V(A_Hom_V, poly_int32);

            if (j == 0) {
                __asm_TMVP_mul_4x4_full(acc_Hom, s_Hom_M + j * 32 * 7 * 8, A_Hom_V);
            } else {
                __asm_TMVP_mla_4x4_full(acc_Hom, s_Hom_M + j * 32 * 7 * 8, A_Hom_V);
            }
        }

        Hom_I(poly_int32, acc_Hom);

        for (j = 0; j < SABER_N; j++) {
            acc[j] = (((uint16_t)poly_int32[j] + h1) >> (SABER_EQ - SABER_EP));
        }

        if (compare) {
            fail |= POLp2BS_cmp(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        } else {
            POLp2BS(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        }
    }

    shake128_inc_ctx_release(&shake_A_ctx);

    for(j = 0; j < SABER_L; j++){

        BS2POLp(pk + j * SABER_POLYCOMPRESSEDBYTES, poly);

        for(size_t k = 0; k < SABER_N; k++){
            poly_int32[k] = (int32_t)(int16_t)poly[k];
        }
        Hom_V(A_Hom_V, poly_int32);

        if(j == 0){
            __asm_TMVP_mul_4x4_full(acc_Hom, s_Hom_M + j * 32 * 7 * 8, A_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(acc_Hom, s_Hom_M + j * 32 * 7 * 8, A_Hom_V);
        }

    }

    Hom_I(poly_int32, acc_Hom);

    BS2POLmsg(m, mp);

    for(j = 0; j < SABER_N; j++){
        acc[j] = ((uint16_t)poly_int32[j] - (mp[j] << (SABER_EP - 1)) + h1) >> (SABER_EP - SABER_ET);
    }

    if(compare){
        fail |= POLT2BS_cmp(ct1, acc);
    }else{
        POLT2BS(ct1, acc);
    }

    return fail;

}

void InnerProdDecNTT(uint8_t m[SABER_KEYBYTES], const uint8_t ciphertext[SABER_BYTES_CCA_DEC], const uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    uint16_t poly[SABER_N];
    uint16_t buff[SABER_N];
    int32_t poly_int32[SABER_N];
    int32_t buff_int32[SABER_N];

    int32_t poly_Hom_V[32 * 7 * 4];
    int32_t buff_Hom_M[32 * 7 * 8];

    int32_t acc_Hom[32 * 7 * 4];

    size_t i;

    for (i = 0; i < SABER_L; i++) {

#ifdef SABER_COMPRESS_SECRETKEY
        BS2POLmu(sk + i * SABER_POLYSECRETBYTES, buff);
#else
        BS2POLq(sk + i * SABER_POLYSECRETBYTES, buff);
#endif
        BS2POLp(ciphertext + i * SABER_POLYCOMPRESSEDBYTES, poly);

        for(size_t k = 0; k < SABER_N; k++){
            buff_int32[k] = (int32_t)(int16_t)buff[k];
            poly_int32[k] = (int32_t)(int16_t)poly[k];
        }

        Hom_M(buff_Hom_M, buff_int32);
        Hom_V(poly_Hom_V, poly_int32);

        if(i == 0){
            __asm_TMVP_mul_4x4_full(acc_Hom, buff_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(acc_Hom, buff_Hom_M, poly_Hom_V);
        }

    }

    Hom_I(poly_int32, acc_Hom);

    BS2POLT(ciphertext + SABER_POLYVECCOMPRESSEDBYTES, buff);

    for (i = 0; i < SABER_N; i++) {
        poly[i] = ((uint16_t)poly_int32[i] + h2 - (buff[i] << (SABER_EP - SABER_ET))) >> (SABER_EP - 1);
    }

    POLmsg2BS(m, poly);

}



