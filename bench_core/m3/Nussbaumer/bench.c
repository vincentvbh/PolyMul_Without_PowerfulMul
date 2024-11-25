

#include <stdint.h>
#include <stdio.h>

#include "hal.h"

#include "ring.h"
#include "MV.h"
#include "Hom.h"

#define K 4

uint64_t oldcount, newcount;
char out[128];

#define ITERATIONS 10000

// ================

int main(void){

    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t res[ARRAY_N];

    int32_t poly1_NTT[32 * INNER_N], poly2_NTT[32 * INNER_N];
    int32_t res_NTT[32 * INNER_N];
    int32_t poly_Hom_M[32 * 7 * 8], poly_Hom_V[32 * 7 * 4];
    int32_t res_MV[32 * 7 * 4];
    int32_t acc[4][ARRAY_N];
    int32_t acc_Hom[4][32 * 7 * 4];
    int32_t poly_V[K][32 * 7 * 4];
    int32_t poly_MV[K][32 * 7 * 4];
    int32_t poly_res[K][ARRAY_N];

    hal_send_str("\n============ Nussbaumer + TMVP-TC benchmark ============\n");

    hal_send_str("\n============ Assembly benchmark ============\n");

    oldcount = hal_get_time();
    __asm_TMVP_mul_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    sprintf(out, "__asm_TMVP_mul_4x4_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TMVP_mla_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    sprintf(out, "__asm_TMVP_mla_4x4_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TC4_16_full(res, poly1);
    newcount = hal_get_time();
    sprintf(out, "__asm_TC4_16_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TC4_T_16_full(res_NTT, res_MV);
    newcount = hal_get_time();
    sprintf(out, "__asm_TC4_T_16_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iTC4_T_7x7_full(poly_Hom_M, poly2_NTT);
    newcount = hal_get_time();
    sprintf(out, "__asm_iTC4_T_7x7_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_Nussbaumer_neg256_0_1_2_3_4(poly1_NTT, poly2_NTT, poly1);
    newcount = hal_get_time();
    sprintf(out, "__asm_Nussbaumer_neg256_0_1_2_3_4 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iNussbaumer_neg256_0_1_2_3(poly1_NTT, poly2_NTT);
    newcount = hal_get_time();
    sprintf(out, "__asm_iNussbaumer_neg256_0_1_2_3 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iNussbaumer_neg256_4_last(poly1, poly1_NTT);
    newcount = hal_get_time();
    sprintf(out, "__asm_iNussbaumer_neg256_4_last cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    hal_send_str("\n============ Table 11 numbers ============\n");

    oldcount = hal_get_time();
    Hom_M(poly_Hom_M, poly2);
    newcount = hal_get_time();
    sprintf(out, "Hom_M cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    Hom_V(poly_Hom_V, poly1);
    newcount = hal_get_time();
    sprintf(out, "Hom_V cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TMVP_mul_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    sprintf(out, "BiHom cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    Hom_I(res, res_MV);
    newcount = hal_get_time();
    sprintf(out, "Hom_I cycles: %lld", newcount - oldcount);
    hal_send_str(out);

// ================

    hal_send_str("\n============ Table 14 numbers ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < K; i++){
        __asm_TMVP_mul_4x4_full((int32_t*)&poly_MV[i][0], poly_Hom_M, (int32_t*)&poly_V[i][0]);
    }
    for(size_t i = 0; i < K; i++){
        Hom_I((int32_t*)&poly_res[i][0], (int32_t*)&poly_MV[i][0]);
    }
    newcount = hal_get_time();
    sprintf(out, "Dilithium 2 c t0 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

// ================

    hal_send_str("\n============ Table 19 numbers ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < 2; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < 2; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }

    for(size_t i = 0; i < 2; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }
    newcount = hal_get_time();
    sprintf(out, "lightsaber matrix-vector product: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 3; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < 3; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }

    for(size_t i = 0; i < 3; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }
    newcount = hal_get_time();
    sprintf(out, "saber matrix-vector product: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 4; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < 4; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }
    for(size_t i = 0; i < 4; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }

    newcount = hal_get_time();
    sprintf(out, "firesaber matrix-vector product: %lld", newcount - oldcount);
    hal_send_str(out);

// ================
// IP (Enc)

    oldcount = hal_get_time();
    for(size_t i = 0; i < 2; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "lightsaber inner product (Enc): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 3; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "saber inner product (Enc): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 4; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "firesaber inner product (Enc): %lld", newcount - oldcount);
    hal_send_str(out);

// ================
// IP (Dec)

    oldcount = hal_get_time();
    for(size_t i = 0; i < 2; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "lightsaber inner product (Dec): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 3; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "saber inner product (Dec): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 4; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "firesaber inner product (Dec): %lld", newcount - oldcount);
    hal_send_str(out);

}



