#include "ntt.h"
#include "params.h"
#include "reduce.h"
#include <stdint.h>

#define FNT_Q2 (769)
#define FNT_Q2HF (769 / 2)
#define FNT_Q2HFNEG -(769 / 2)


void ntt(int32_t a[N]) 
{
    ntt_asm(a);
    for (int cnt_i = 0; cnt_i < N; cnt_i++)  a[cnt_i] = freeze_32(a[cnt_i]);
}

void invntt_tomont(int32_t a[N]) 
{
    invntt_asm(a);
}

void invntt(int32_t a[N])
{
    invntt_asm(a);
}

void point_mul_on_the_fly(int32_t res[N], int32_t src1[N], int32_t src2[N])
{
    for (int cnt_i = 0; cnt_i < N; cnt_i++)
    { 
        res[cnt_i] = Barrett_mul_on_the_fly_asm(src1[cnt_i], src2[cnt_i]);
    }
}
void point_mul_pre(int32_t res[N], int32_t src1[N], int32_t src2_extended[N << 1])
{
    for (int cnt_i = 0; cnt_i < N; cnt_i++)
    {
        res[cnt_i] = Barrett_mul_pre_asm(src1[cnt_i], src2_extended[2 * cnt_i + 0], src2_extended[2 * cnt_i + 1]);

    }
}

void ntt_small(int32_t a[N])
{
    fnt769_ntt_asm(a);
}

void invntt_small(int32_t a[N])
{
    fnt769_invntt_asm(a);
}

static int ct_lt_s32(uint32_t x, uint32_t y) {return (x ^ ((x ^ (x - y)) & (y ^ (x - y)))) >> 31;}

static int ct_gt_s32(uint32_t x, uint32_t y) {return ct_lt_s32(y, x);}

int32_t fnt_freeze(int32_t src)
{
	int32_t r  = src;	
	uint16_t mask;

	mask = 0 -ct_gt_s32(src, FNT_Q2HF); // if (src > FNT_Q2HF) r -= 769;
	r -= mask & 769;
	mask = 0 - ct_lt_s32(src, (uint32_t) FNT_Q2HFNEG); // if (src < -FNT_Q2HF) r += 769;
	r += mask & 769;
	return r;
}


int16_t fnt769_montgomery_reduce(int32_t a)
{
    int16_t t;
	int16_t hi = a >> 16; 

	t = (int16_t)a * (-767); 
	t = ((int32_t)t * 769) >> 16; 
	return hi - t; 
}

void fnt769_basemul(int32_t r[2], int32_t a[2], int32_t b[2], int16_t zeta)
{
    int32_t tmp[2] = {0};
  
    tmp[0] =  (int32_t)fnt769_montgomery_reduce(a[1]  * b[1]);
    tmp[0] =  (int32_t)fnt769_montgomery_reduce(tmp[0]* zeta);
    tmp[0] += (int32_t)fnt769_montgomery_reduce(a[0]  * b[0]);
    tmp[1] =  (int32_t)fnt769_montgomery_reduce(a[0]  * b[1]);
    tmp[1] += (int32_t)fnt769_montgomery_reduce(a[1]  * b[0]);
    
    r[0] = tmp[0]; r[1] = tmp[1];
}

void point_mul_small(int32_t des[N], int32_t src1[N], int32_t src2[N])
{
  for(int cnt_i = 0 ; cnt_i < N / 4 ; cnt_i++)
  {
    fnt769_basemul(&des[4 * cnt_i    ], &src1[4 * cnt_i    ], &src2[4 * cnt_i    ], FNT_Q2_zetas[64 + cnt_i]);
    fnt769_basemul(&des[4 * cnt_i + 2], &src1[4 * cnt_i + 2], &src2[4 * cnt_i + 2], -FNT_Q2_zetas[64 + cnt_i]);
  } 
}