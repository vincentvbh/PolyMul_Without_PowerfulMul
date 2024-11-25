
#include <stddef.h>

#include "Hom.h"

// len should be a multiple of 4.
// asm functions are only for len = 16.
// void TMVP_TC4_negacyclic_mul(int32_t *des, int32_t *src1, int32_t *src2, size_t len){

//     int32_t src1_V_full[7][len / 4];
//     int32_t src2_Toeplitz_full[7][len / 2];
//     int32_t res_V_full[7][len / 4];

//     __asm_TC4_16((int32_t*)&src1_V_full[0][0], src1);
//     __asm_iTC4_T_7x7((int32_t*)&src2_Toeplitz_full[0][0], src2);
//     __asm_TMVP_mul_4x4((int32_t*)&res_V_full[0][0], (int32_t*)&src2_Toeplitz_full[0][0], (int32_t*)&src1_V_full[0][0]);
//     __asm_TC4_T_16(des, (int32_t*)&res_V_full[0][0]);

// }

void Hom_M(int32_t *src_Hom_M, int32_t *src){

    int32_t src_NTT[32 * INNER_N];
    int32_t buff_NTT[32 * INNER_N];

    __asm_Nussbaumer_neg256_0_1_2_3_4(src_NTT, buff_NTT, src);
    __asm_iTC4_T_7x7_full(src_Hom_M, src_NTT);

}

void Hom_V(int32_t *src_Hom_V, int32_t *src){

    int32_t src_NTT[32 * INNER_N];
    int32_t buff_NTT[32 * INNER_N];

    __asm_Nussbaumer_neg256_0_1_2_3_4(src_NTT, buff_NTT, src);
    __asm_TC4_16_full(src_Hom_V, src_NTT);

}

void Hom_I(int32_t *des, int32_t *src){

    int32_t buff_NTT[32 * INNER_N];
    int32_t des_NTT[32 * INNER_N];

    __asm_TC4_T_16_full(buff_NTT, src);
    __asm_iNussbaumer_neg256_0_1_2_3(des_NTT, buff_NTT);
    __asm_iNussbaumer_neg256_4_last(des, des_NTT);

}

