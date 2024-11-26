

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <time.h>

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"

#define ARRAY_N 256
#define NTT_N 128
#define LOGNTT_N 7
#define BASE_N (ARRAY_N / NTT_N)

#define Q (769)
#define RmodQ (-598)
#define Qprime (64769)
#define RmodQhi (50963)
#define omegaQ (7)
#define omegainvQ (110)
#define QINV256 (-6)
#define RsqrmodQ (19)
#define QinvR (-767)

int16_t mod = Q;

void memberZ(void *des, void *src)
{
    cmod_int16(des, src, &mod);
}

void addZ(void *des, void *src1, void *src2)
{
    addmod_int16(des, src1, src2, &mod);
}

void subZ(void *des, void *src1, void *src2)
{
    submod_int16(des, src1, src2, &mod);
}

void mulZ(void *des, void *src1, void *src2)
{
    mulmod_int16(des, src1, src2, &mod);
}

void expZ(void *des, void *src, size_t e)
{
    expmod_int16(des, src, e, &mod);
}

static int16_t fnt769_montgomery_reduce(int32_t a) {
    int16_t t;

    t = (int16_t)a * QinvR;
    t = (a - (int32_t)t * Q) >> 16;
    return t;
}

void montZ(void *des, void *src1, void *src2)
{
    int32_t imm = (int32_t)(*(int16_t*)src1) * (*(int16_t*)src2);
    *(int16_t*)des = fnt769_montgomery_reduce(imm);
}

void fnt769_basemul(int16_t r[2], const int16_t a[2], const int16_t b[2], int16_t zeta) 
{
    r[0]  = fnt769_montgomery_reduce((int32_t)a[1] * b[1]);
    r[0]  = fnt769_montgomery_reduce((int32_t)r[0] * zeta);
    r[0] += fnt769_montgomery_reduce((int32_t)a[0] * b[0]);
    r[1]  = fnt769_montgomery_reduce((int32_t)a[0] * b[1]);
    r[1] += fnt769_montgomery_reduce((int32_t)a[1] * b[0]);
}

struct commutative_ring naive_mod_coeff_ring =
    {
        .sizeZ = sizeof(int16_t),
        .memberZ = memberZ,
        .addZ = addZ,
        .subZ = subZ,
        .mulZ = mulZ,
        .expZ = expZ,
        .modQ = Q};

struct commutative_ring ntt_coeff_ring =
    {
        .sizeZ = sizeof(int16_t),
        .memberZ = memberZ,
        .addZ = addZ,
        .subZ = subZ,
        .mulZ = montZ, //!Montgomery Multiplication
        .expZ = expZ,
        .modQ = Q};




int16_t streamlined_twiddle_table[NTT_N - 1];
struct compress_profile profile;

// ================
int main(void)
{    
    int16_t poly1[ARRAY_N], poly2[ARRAY_N];
    int16_t ref[ARRAY_N], res[ARRAY_N];

    int16_t omega, zeta, twiddle, scale, t;

    //! Generate Random Number =============================================================================================
    srand(time(NULL));
    for (size_t i = 0; i < ARRAY_N; i++)
    {
        t = rand();
        naive_mod_coeff_ring.memberZ(poly1 + i, &t);
        t = rand();
        naive_mod_coeff_ring.memberZ(poly2 + i, &t);
    }

    //! Naive (School Book) Multiplication ==================================================================================
    twiddle = -1; //* X^{256} - 1
    naive_mulR(ref, poly1, poly2, ARRAY_N, &twiddle, naive_mod_coeff_ring);

    //! NTT-based Polynomial Multiplication =================================================================================
    //* Setting Profile : Merging
    profile.array_n = ARRAY_N;
    profile.ntt_n = NTT_N;
    profile.log_ntt_n = LOGNTT_N;

    profile.compressed_layers = LOGNTT_N;
    for (size_t i = 0; i < profile.compressed_layers; i++)
        profile.merged_layers[i] = 1;

    //* Forward 7-Layer NTT:  do NTT(poly1), NTT(poly2)
    scale = RmodQ;
    zeta = omegaQ;
    naive_mod_coeff_ring.expZ(&omega, &zeta, 2);
    gen_streamlined_DWT_table(streamlined_twiddle_table, &scale, &omega, &zeta, profile, 0, naive_mod_coeff_ring);

    compressed_CT_NTT(poly1, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);
    compressed_CT_NTT(poly2, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);


    //* Point Multiplication : do {res} = NTT(poly1) o NTT(poly2)
    for (int i = 0; i < 256 / 4; i++) 
    {
        fnt769_basemul(&res[4 * i]      , &poly1[4 * i]     , &poly2[4 * i]     ,  streamlined_twiddle_table[63 + i]); 
        fnt769_basemul(&res[4 * i + 2]  , &poly1[4 * i + 2] , &poly2[4 * i + 2] , -streamlined_twiddle_table[63 + i]); 
    }

    //* iNTT : do {res} = iNTT(res)
    scale = RmodQ;
    zeta = omegainvQ;
    naive_mod_coeff_ring.expZ(&omega, &zeta, 2);
    gen_streamlined_DWT_table(streamlined_twiddle_table, &scale, &omega, &zeta, profile, 0, naive_mod_coeff_ring);

    compressed_GS_NTT(res, 0, LOGNTT_N - 1, streamlined_twiddle_table, profile, ntt_coeff_ring);

    for(int i = 0; i < 256; i++) res[i] = fnt769_montgomery_reduce((int32_t)res[i] * 655); //! 655 = RmodQ ^{2} / 256

    //* freeze
    scale = 1;
    for(size_t i = 0; i < ARRAY_N; i++) naive_mod_coeff_ring.mulZ(res + i, res + i, &scale);

    scale = 1;
    for(size_t i = 0; i < ARRAY_N; i++) naive_mod_coeff_ring.mulZ(ref + i, ref + i, &scale);

    //! Compare ===========================================================================================================
    for(size_t i = 0; i < ARRAY_N; i++) assert(ref[i] == res[i]);

    printf("Test finished!\n");
}