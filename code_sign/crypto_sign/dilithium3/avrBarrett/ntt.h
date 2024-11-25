#ifndef NTT_H
#define NTT_H
#include "params.h"
#include <stdint.h>

void ntt(int32_t a[N]);

void invntt_tomont(int32_t a[N]);

void invntt(int32_t a[N]);

void ntt_small(int32_t a[N]);

void invntt_small(int32_t a[N]);

void point_mul_on_the_fly(int32_t res[N], int32_t src1[N], int32_t src2[N]);
void point_mul_pre(int32_t res[N], int32_t src1[N], int32_t src2_extended[N << 1]);

extern int32_t Barrett_mul_on_the_fly_asm(int32_t a, int32_t b);
extern int32_t Barrett_mul_pre_asm(int32_t a, int32_t b, int32_t bp);
extern void invntt_asm(int32_t a[N]);
extern void ntt_asm(int32_t a[N]);

extern __flash int16_t FNT_Q2_zetas[128] ;
extern void fnt769_ntt_asm(int32_t a[N]);
extern void fnt769_invntt_asm(int32_t a[N]);
extern int16_t fnt769_montgomery_reduce_asm(int32_t a, int32_t b);
void point_mul_small(int32_t des[N], int32_t src1[N], int32_t src2[N]);
int32_t fnt_freeze(int32_t src);
#endif
