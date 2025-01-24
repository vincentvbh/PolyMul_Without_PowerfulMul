
#include <assert.h>

#include <stdint.h>
#include <stdio.h>

#include "NTT_params.h"
#include "ring.h"

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"

struct compress_profile profile;

#define ITERATIONS 10000
#define BUFF_MAX 4096

// ================

// common buffer
int32_t streamlined_twiddle_table[NTT_N << 1];

int32_t buff[BUFF_MAX];

int32_t __sq[1u << 9];
int32_t __sqrt[1u << 9];
uint32_t __usqrt[1u << 9];

const
int32_t streamlined_FNT_table[NTT_N] = {
16, 4, 64, 2, 32, 8, 128, -60, -35, -46, 68, 117, 73, 17, -70, -92, 15, -23, -111, -120, 44, -67, -121, -81, -11, 34, 88, 123, 30, 95, -22, -42, -27, 82, 99, -108, 71, 89, -54, -93, -118, 41, -115, -84, 78, -37, -59, 55, 109, -79, -101, -74, 21, 110, -39, -50, -83, -43, -29, -75, 85, 57, 91, -86, -116, 107, -87, -100, 97, 10, -58, -126, 40, 114, -63, 20, 25, 5, 80, -72, 106, -103, -124, -90, 102, -31, -45, 51, 18, 77, -53, 113, 65, 12, 9, 3, 48, -62, -127, 24, 36, 6, 96, -49, -112, 7, -13, 66, 28, 61, 33, 14, -52, -125, 56, -98, 38, 94, -26, -105, 119, 122, 76, -69, -104, 47, -19
};

const
int32_t mul_FNT_table[NTT_N >> 1] = {
-27, 82, -108, 71, -54, -93, 41, -115, 78, -37, 55, 109, -101, -74, 110, -39, -83, -43, -75, 85, 91, -86, 107, -87, 97, 10, -126, 40, -63, 20, 5, 80, 106, -103, -90, 102, -45, 51, 77, -53, 65, 12, 3, 48, -127, 24, 6, 96, -112, 7, 66, 28, 33, 14, -125, 56, 38, 94, -105, 119, 76, -69, 47, -19
};

const
int32_t streamlined_iFNT_table[NTT_N] = {
-16, -64, -4, -128, -8, -32, -2, -30, 22, -95, -34, -123, -88, 121, 11, 81, 120, 67, -44, -15, 111, 23, -17, 92, 70, -68, -73, -117, 60, 46, 35, 104, 19, -47, -122, 69, -76, 26, -119, 105, 98, -94, -38, 52, -56, 125, -61, -14, -33, 13, -28, -66, 49, -7, 112, -36, -96, -6, 62, -24, 127, -9, -48, -3, -113, -12, -65, -18, 53, -77, 31, -51, 45, 124, -102, 90, 72, 103, -106, -25, -80, -5, -114, -20, 63, 58, -40, 126, 100, -10, -97, 116, 87, -107, -57, 86, -91, 29, -85, 75, 50, 43, 83, -21, 39, -110, 79, 74, 101, 59, -109, -55, 84, 37, -78, 118, 115, -41, -89, 93, 54, -99, -71, 108, 42, -82, 27
};

int main(void){

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t ref[ARRAY_N], res[ARRAY_N];

    int32_t omega, zeta, twiddle, scale, t;

    printf("\n============ gen FNT 257 started ============\n");

    for(size_t i = 0; i < Q; i++){
        __sq[i] = __sqrt[i] = 0;
    }

    for(size_t i = 0; i < Q; i++){
        t = i;
        mulmod_int32(__sq + i, &t, &t, &mod);
    }

    for(size_t i = 0; i < Q; i++){
        t = __sq[i];
        if(t < 0){
            t += Q;
        }
        __usqrt[t] = i;
        cmod_int32(__sqrt + t, __usqrt + t, &mod);
    }

    profile.array_n = ARRAY_N;
    profile.ntt_n = NTT_N;
    profile.log_ntt_n = LOGNTT_N;

    profile.compressed_layers = 3;
    profile.merged_layers[0] = 3;
    profile.merged_layers[1] = 2;
    profile.merged_layers[2] = 2;

    zeta = ZETA;
    omega = OMEGA;
    scale = 1;
    gen_streamlined_DWT_table(buff,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    for(size_t i = 0; i < (NTT_N - 1); i++){
        assert(buff[i] == streamlined_FNT_table[i]);
    }

    scale = ZETA;
    omega = OMEGA;
    gen_mul_table(buff, &scale, &omega, profile, coeff_ring);

    for(size_t i = 0; i < (NTT_N / 2); i++){
        assert(buff[i] == mul_FNT_table[i]);
    }

    profile.compressed_layers = 3;
    profile.merged_layers[0] = 3;
    profile.merged_layers[1] = 2;
    profile.merged_layers[2] = 2;

    zeta = ZETA_INV;
    omega = OMEGA_INV;
    scale = 1;
    gen_streamlined_DWT_table(buff,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    for(size_t i = 0; i < (NTT_N - 1); i++){
        assert(buff[i] == streamlined_iFNT_table[i]);
    }

    printf("gen FNT tables finished!\n");




}
