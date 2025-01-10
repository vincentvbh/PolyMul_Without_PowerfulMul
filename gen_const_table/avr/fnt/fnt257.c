

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"

#define ARRAY_N 256
#define NTT_N 128
#define LOGNTT_N 7
#define BASE_N (ARRAY_N / NTT_N)

// 2^8 + 1 = 0
#define Q (257)

#define OMEGA (-42)
#define OMEGA_INV (104)
#define ZETA (-27)
#define ZETA_INV (19)

int16_t mod = Q;

void memberZ(void *des, void *src){
    cmod_int16(des, src, &mod);
}

void addZ(void *des, void *src1, void *src2){
    addmod_int16(des, src1, src2, &mod);
}

void subZ(void *des, void *src1, void *src2){
    submod_int16(des, src1, src2, &mod);
}

void mulZ(void *des, void *src1, void *src2){
    mulmod_int16(des, src1, src2, &mod);
}

void expZ(void *des, void *src, size_t e){
    expmod_int16(des, src, e, &mod);
}

void fnt257_mulZ(void *des, void *src1, void *src2)
{
    int32_t src = (int32_t)(*(int16_t*)src1) * (int32_t)(*(int16_t*)src2);
    int32_t r;
    uint16_t hi;
	hi = src & 0xFFFF;
	r = hi + (src >> 16);

    uint8_t lo;
	lo = r & 0xFF;
	r = lo - (r >> 8);

    *(int16_t*)des = (int16_t) r;
}

struct commutative_ring naive_mod_coeff_ring = {
    .sizeZ = sizeof(int16_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};

struct commutative_ring ntt_coeff_ring = {
    .sizeZ = sizeof(int16_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = fnt257_mulZ,
    .expZ = expZ
};

int16_t streamlined_twiddle_table[NTT_N - 1];
struct compress_profile profile;

// ================
const
int32_t streamlined_FNT_table[NTT_N] = {
16, 4, 64, 2, 32, 8, 128, -60, 68, 17, 15, -120, -121, 34, 30, -35, -46, 117, 73, -70, -92, -23, -111, 44, -67, -81, -11, 88, 123, 95, -22, -42, 99, 89, -118, -84, -59, -79, 21, -50, -29, 57, -116, -100, -58, 114, 25, -72, -124, -31, 18, 113, 9, -62, 36, -49, -13, 61, -52, -98, -26, 122, -104, -27, 82, -108, 71, -54, -93, 41, -115, 78, -37, 55, 109, -101, -74, 110, -39, -83, -43, -75, 85, 91, -86, 107, -87, 97, 10, -126, 40, -63, 20, 5, 80, 106, -103, -90, 102, -45, 51, 77, -53, 65, 12, 3, 48, -127, 24, 6, 96, -112, 7, 66, 28, 33, 14, -125, 56, 38, 94, -105, 119, 76, -69, 47, -19, 0,
};

const
int32_t mul_FNT_table[NTT_N >> 1] = {
-27, 82, -108, 71, -54, -93, 41, -115, 78, -37, 55, 109, -101, -74, 110, -39, -83, -43, -75, 85, 91, -86, 107, -87, 97, 10, -126, 40, -63, 20, 5, 80, 106, -103, -90, 102, -45, 51, 77, -53, 65, 12, 3, 48, -127, 24, 6, 96, -112, 7, 66, 28, 33, 14, -125, 56, 38, 94, -105, 119, 76, -69, 47, -19, 
};

const
int32_t streamlined_iFNT_table[NTT_N] = {
-16, -64, -4, -128, -8, -32, -2, -30, -34, 121, 120, -15, -17, -68, 60, 22, -95, -123, -88, 11, 81, 67, -44, 111, 23, 92, 70, -73, -117, 46, 35, 104, -122, 26, 98, 52, -61, 13, 49, -36, 62, -9, -113, -18, 31, 124, 72, -25, -114, 58, 100, 116, -57, 29, 50, -21, 79, 59, 84, 118, -89, -99, 42, 19, -47, 69, -76, -119, 105, -94, -38, -56, 125, -14, -33, -28, -66, -7, 112, -96, -6, -24, 127, -48, -3, -12, -65, 53, -77, -51, 45, -102, 90, 103, -106, -80, -5, -20, 63, -40, 126, -10, -97, 87, -107, 86, -91, -85, 75, 43, 83, 39, -110, 74, 101, -109, -55, 37, -78, 115, -41, 93, 54, -71, 108, -82, 27, 0,
};

int main(void)
{
    int16_t poly1[ARRAY_N], poly2[ARRAY_N];
    int16_t ref[ARRAY_N], res[ARRAY_N];

    int16_t omega, zeta, twiddle, scale, t;

    //! Generate Random Number =============================================================================================
    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        naive_mod_coeff_ring.memberZ(poly1 + i, &t);
        t = rand();
        naive_mod_coeff_ring.memberZ(poly2 + i, &t);
    }

    //! Naive (School Book) Multiplication ==================================================================================
    twiddle = -1;
    naive_mulR(ref, poly1, poly2, ARRAY_N, &twiddle, naive_mod_coeff_ring);

    //! NTT-based Polynomial Multiplication =================================================================================
    //* Setting Profile : Merging
    profile.array_n = ARRAY_N;
    profile.ntt_n = NTT_N;
    profile.log_ntt_n = LOGNTT_N;

    profile.compressed_layers = LOGNTT_N;
    for(size_t i = 0; i < profile.compressed_layers; i++){
        profile.merged_layers[i] = 1;
    }

    //* Forward 7-Layer NTT:  do NTT(poly1), NTT(poly2)
    zeta = ZETA;
    omega = OMEGA;
    scale = 1;
    gen_streamlined_DWT_table(streamlined_twiddle_table, &scale, &omega, &zeta, profile, 0, naive_mod_coeff_ring);
    for(size_t i = 0; i < NTT_N; i++) assert(streamlined_twiddle_table[i] == streamlined_FNT_table[i]);

    compressed_CT_NTT(poly1, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);
    compressed_CT_NTT(poly2, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);

    //* Point Multiplication : do {res} = NTT(poly1) o NTT(poly2)
    scale = ZETA;
    omega = OMEGA;
    gen_mul_table(streamlined_twiddle_table, &scale, &omega, profile, naive_mod_coeff_ring);
    for(size_t i = 0; i < NTT_N >> 1; i++) assert(streamlined_twiddle_table[i] == mul_FNT_table[i]);

    for(size_t i = 0; i < ARRAY_N; i += 2 * BASE_N){
        twiddle = streamlined_twiddle_table[i / (2 * BASE_N)];
        naive_mulR(res + i + 0 * BASE_N, poly1 + i + 0 * BASE_N, poly2 + i + 0 * BASE_N, BASE_N, &twiddle, ntt_coeff_ring);
        twiddle = -twiddle;
        naive_mulR(res + i + 1 * BASE_N, poly1 + i + 1 * BASE_N, poly2 + i + 1 * BASE_N, BASE_N, &twiddle, ntt_coeff_ring);
    }

    //* iNTT : do {res} = iNTT(res)
    zeta = ZETA_INV;
    omega = OMEGA_INV;
    scale = 1;
    gen_streamlined_DWT_table(streamlined_twiddle_table, &scale, &omega, &zeta, profile, 0, naive_mod_coeff_ring);
    for(size_t i = 0; i < NTT_N; i++) assert(streamlined_twiddle_table[i] == streamlined_iFNT_table[i]);
    
    compressed_GS_NTT(res, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);

    //* freeze result : res in (-Q/2, Q/2) ==> res in (0, Q)
    scale = 1; 
    for(size_t i = 0; i < ARRAY_N; i++) naive_mod_coeff_ring.mulZ(res + i, res + i, &scale);    

    scale = NTT_N;
    for(size_t i = 0; i < ARRAY_N; i++) naive_mod_coeff_ring.mulZ(ref + i, ref + i, &scale);    

    //! Compare ===========================================================================================================
    for(size_t i = 0; i < ARRAY_N; i++) assert(ref[i] == res[i]);            

    printf("Test finished!\n");
}