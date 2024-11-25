#ifndef HOM_H
#define HOM_H

#include <stdint.h>

#define INNER_N 16

void TMVP_TC4_negacyclic_mul(int32_t *des, int32_t *src1, int32_t *src2, size_t len);
void Hom_M(int32_t *src_Hom_M, int32_t *src);
void Hom_V(int32_t *src_Hom_V, int32_t *src);
void Hom_I(int32_t *des, int32_t *src);

extern
void __asm_Nussbaumer_neg256_0_1_2_3_4(int32_t*, int32_t*, int32_t*);

extern
void __asm_iNussbaumer_neg256_0_1_2_3(int32_t*, int32_t*);

extern
void __asm_iNussbaumer_neg256_4_last(int32_t*, int32_t*);

extern
void __asm_TC4_16_full(int32_t*, int32_t*);

extern
void __asm_TC4_T_16_full(int32_t*, int32_t*);

extern
void __asm_iTC4_T_7x7_full(int32_t*, int32_t*);

extern
void __asm_TMVP_mul_4x4_full(int32_t*, int32_t*, int32_t*);

extern
void __asm_TMVP_mla_4x4_full(int32_t*, int32_t*, int32_t*);

#endif

