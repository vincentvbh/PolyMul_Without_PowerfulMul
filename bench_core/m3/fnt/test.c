
#include <assert.h>

#include <stdint.h>
#include <stdio.h>

#include "hal.h"

#include "NTT_params.h"
#include "ring.h"

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"

struct compress_profile profile;

int32_t const_buff[8] = {
};

char out[128];

#define ITERATIONS 10000
#define BUFF_MAX 4096

// ================

// common buffer
int32_t streamlined_twiddle_table[NTT_N << 1];

int32_t buff[BUFF_MAX];

int32_t __sq[1u << 9];
int32_t __sqrt[1u << 9];
uint32_t __usqrt[1u << 9];

extern
void __asm_FNT257(int32_t*, int32_t*);

extern
void __asm_basemul257(int32_t*, int32_t*, int32_t*, int32_t*);

extern
void __asm_iFNT257(int32_t*, int32_t*);

int main(void){

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t ref[ARRAY_N], res[ARRAY_N];

    int32_t omega, zeta, twiddle, scale, t;

    hal_setup(CLOCK_FAST);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        cmod_int32(poly1 + i, &t, &mod);
        t = rand();
        cmod_int32(poly2 + i, &t, &mod);
    }

    twiddle = -1;
    naive_mulR(ref,
        poly1, poly2, ARRAY_N, &twiddle, coeff_ring);

    // for(size_t i = 0; i < Q; i++){
    //     __sq[i] = __sqrt[i] = 0;
    // }

    // for(size_t i = 0; i < Q; i++){
    //     t = i;
    //     mulmod_int32(__sq + i, &t, &t, &mod);
    // }

    // for(size_t i = 0; i < Q; i++){
    //     t = __sq[i];
    //     if(t < 0){
    //         t += Q;
    //     }
    //     __usqrt[t] = i;
    //     cmod_int32(__sqrt + t, __usqrt + t, &mod);
    // }

    profile.array_n = ARRAY_N;
    profile.ntt_n = NTT_N;
    profile.log_ntt_n = LOGNTT_N;

#if 1

    profile.compressed_layers = 3;
    profile.merged_layers[0] = 3;
    profile.merged_layers[1] = 2;
    profile.merged_layers[2] = 2;

    zeta = ZETA;
    omega = OMEGA;
    scale = 1;
    gen_streamlined_DWT_table(buff,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    __asm_FNT257(poly1, buff);
    __asm_FNT257(poly2, buff);

    scale = ZETA;
    omega = OMEGA;
    gen_mul_table(buff, &scale, &omega, profile, coeff_ring);

    __asm_basemul257(res, poly1, poly2, buff);

    profile.compressed_layers = 3;
    profile.merged_layers[0] = 3;
    profile.merged_layers[1] = 2;
    profile.merged_layers[2] = 2;

    zeta = ZETA_INV;
    omega = OMEGA_INV;
    scale = 1;
    gen_streamlined_DWT_table(buff,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    __asm_iFNT257(res, buff);

#else

    profile.compressed_layers = LOGNTT_N;
    for(size_t i = 0; i < profile.compressed_layers; i++){
        profile.merged_layers[i] = 1;
    }

    zeta = ZETA;
    omega = OMEGA;
    scale = 1;
    gen_streamlined_DWT_table(buff,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    compressed_CT_NTT(poly1,
        0, LOGNTT_N - 1, buff, profile, coeff_ring);
    compressed_CT_NTT(poly2,
        0, LOGNTT_N - 1, buff, profile, coeff_ring);

    scale = ZETA;
    omega = OMEGA;
    gen_mul_table(buff, &scale, &omega, profile, coeff_ring);

    for(size_t i = 0; i < ARRAY_N; i += 2 * BASE_N){
        twiddle = buff[i / (2 * BASE_N)];
        naive_mulR(res + i + 0 * BASE_N, poly1 + i + 0 * BASE_N, poly2 + i + 0 * BASE_N, BASE_N, &twiddle, coeff_ring);
        twiddle = -twiddle;
        naive_mulR(res + i + 1 * BASE_N, poly1 + i + 1 * BASE_N, poly2 + i + 1 * BASE_N, BASE_N, &twiddle, coeff_ring);
    }

    zeta = ZETA_INV;
    omega = OMEGA_INV;
    scale = 1;
    gen_streamlined_DWT_table(buff,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    compressed_GS_NTT(res,
        0, LOGNTT_N - 1, buff, profile, coeff_ring);

    scale = NTT_N;
    for(size_t i = 0; i < ARRAY_N; i++){
        coeff_ring.mulZ(ref + i, ref + i, &scale);
    }

#endif

    // for(size_t i = 0; i < ARRAY_N; i++){
    //     assert(ref[i] == res[i]);
    // }

    hal_send_str("Test finished!");

}















