

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

    compressed_CT_NTT(poly1, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);
    compressed_CT_NTT(poly2, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);

    //* Point Multiplication : do {res} = NTT(poly1) o NTT(poly2)
    scale = ZETA;
    omega = OMEGA;
    gen_mul_table(streamlined_twiddle_table, &scale, &omega, profile, naive_mod_coeff_ring);

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