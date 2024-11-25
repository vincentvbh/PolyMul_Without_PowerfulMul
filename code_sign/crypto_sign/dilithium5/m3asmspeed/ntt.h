#ifndef NTT_H
#define NTT_H
#include "params.h"
#include "NTT_params.h"
#include <stdint.h>

void ntt(int32_t a[N]);
void ntt_fast(int32_t a[N]);
void ntt_small(int32_t a[N]);

void invntt_tomont(int32_t a[N]);
void invntt_tomont_fast(int32_t a[N]);
void invntt_tomont_small(int32_t a[N]);
void invntt(int32_t a[N]);

void extend(int32_t a_extended[N << 1], int32_t a[N]);
void point_mul_pre(int32_t des[N], int32_t src1[N], int32_t src2_extended[N << 1]);
void point_montmul(int32_t c[N], const int32_t a[N], const int32_t b[N]);
void point_montmul_fast(int32_t c[N], const int32_t a[N], const int32_t b[N]);
void point_montmul_small(int32_t c[N], const int32_t a[N], const int32_t b[N]);

extern void __asm_NTT(int32_t*, int32_t*, int32_t*);
extern void __asm_iNTT(int32_t*, int32_t*, int32_t*);
extern void __asm_point_mul_pre(int32_t*, int32_t*, int32_t*, int32_t*);
extern void __asm_extend(int32_t*, int32_t*, int32_t*);
extern void __asm_point_montmul(int32_t*, const int32_t*, const int32_t*, int32_t*);

extern void __asm_NTT_fast(int32_t*, int32_t*, int32_t*);
extern void __asm_iNTT_fast(int32_t*, int32_t*, int32_t*);
extern void __asm_point_mul_pre_fast(int32_t*, int32_t*, int32_t*, int32_t*);
extern void __asm_point_montmul_fast(int32_t*, const int32_t*, const int32_t*, int32_t*);

extern void __asm_FNT257(int32_t*, int32_t*);
extern void __asm_iFNT257(int32_t*, int32_t*);
extern void __asm_basemul257(int32_t*, const int32_t*, const int32_t*, int32_t*);


#endif
