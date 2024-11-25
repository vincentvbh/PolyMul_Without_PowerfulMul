
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <memory.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"

// ================
// This file demonstrates polynomial multiplication of size-4m polynomials in Z_Q[x]
// via Toom-4 with the point set {0, 1, -1, 2, -2, 1/2, \infty}.

// ================
// Optimization guide.
/*

1. While applying the matrices, make use of barrel shifter to multiply
   by the correct constants. For example, 3 * a can be implemented as
   a + (a << 1) and 9 * a can beimplemented as a + (a << 3).
   With such optimization, we save the memory operations loading the matrices.

2. Notice that point set is carefully chosen. In principle, when an integer z
   is chosen, we also choose -z. So evaluating a polynomial at {z, -z} will be faster
   by first evaluating for the odds and evens individually and applying an add-sub pair.

*/

#define ARRAY_N 256

// Q = 1, 2, 4, ..., 2^13
#define Q (1 << 13)

uint16_t mod = Q;

void memberZ(void *des, void *src){
    *(uint16_t*)des = *(uint16_t*)src;
}

void addZ(void *des, void *src1, void *src2){
    *(uint16_t*)des = (*(uint16_t*)src1) + (*(uint16_t*)src2);
}

void subZ(void *des, void *src1, void *src2){
    *(uint16_t*)des = (*(uint16_t*)src1) - (*(uint16_t*)src2);
}

void mulZ(void *des, void *src1, void *src2){
    *(uint16_t*)des = (*(uint16_t*)src1) * (*(uint16_t*)src2);
}

void expZ(void *des, void *src, size_t e){

    uint16_t src_v = *(uint16_t*)src;
    uint16_t tmp_v;

    tmp_v = 1;
    for(; e; e >>= 1){
        if(e & 1){
            tmp_v = tmp_v * src_v;
        }
        src_v = src_v * src_v;
    }

    memmove(des, &tmp_v, sizeof(uint16_t));
}

struct commutative_ring coeff_ring = {
    .sizeZ = sizeof(uint16_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};

// ================
// Karatsuba

// Multiply two size-64 polynomials in R[x] / (x^64 + 1) via
// R[x] / (x^64 + 1)
// to
// (R[y] / (y^16 + 1)) / (x^4 - y)
// to
// (R[y] / (y^16 + 1)) / (x^7) (2 layers of Karatsuba)
static
void negacyclic_Karatsuba_striding(uint16_t *des, const uint16_t *src1, const uint16_t *src2){

    uint16_t res_p00[16], res_p01[16], res_p02[16],
             res_p10[16], res_p11[16], res_p12[16],
             res_p20[16], res_p21[16], res_p22[16];

    uint16_t p00, p01, p02,
             p10, p11, p12,
             p20, p21, p22;

    uint16_t _p01, _p11, _p21;

    uint16_t buff[3];

    memset(res_p00, 0, sizeof(res_p00));
    memset(res_p01, 0, sizeof(res_p01));
    memset(res_p02, 0, sizeof(res_p02));
    memset(res_p10, 0, sizeof(res_p10));
    memset(res_p11, 0, sizeof(res_p11));
    memset(res_p12, 0, sizeof(res_p12));
    memset(res_p20, 0, sizeof(res_p20));
    memset(res_p21, 0, sizeof(res_p21));
    memset(res_p22, 0, sizeof(res_p22));

    for(size_t i = 0; i < 16; i++){

        // Load 4, cache 9.
        p00 = src1[4 * i + 0];
        p02 = src1[4 * i + 1];
        p20 = src1[4 * i + 2];
        p22 = src1[4 * i + 3];

        p01 = p00 + p02;
        p21 = p20 + p22;

        p10 = p00 + p20;
        p12 = p02 + p22;

        p11 = p10 + p12;

        for(size_t j = 0; j < 16 - i; j++){

            res_p00[i + j]      += p00 * src2[4 * j + 0];
            res_p02[i + j]      += p02 * src2[4 * j + 1];
            _p01                 = src2[4 * j + 0] + src2[4 * j + 1];
            res_p01[i + j]      += p01 * _p01;

            res_p20[i + j]      += p20 * src2[4 * j + 2];
            res_p22[i + j]      += p22 * src2[4 * j + 3];
            _p21                 = src2[4 * j + 2] + src2[4 * j + 3];
            res_p21[i + j]      += p21 * _p21;

            res_p10[i + j]      += p10 * (src2[4 * j + 0] + src2[4 * j + 2]);
            res_p12[i + j]      += p12 * (src2[4 * j + 1] + src2[4 * j + 3]);
            _p11                 = _p01 + _p21;
            res_p11[i + j]      += p11 * _p11;

        }
        for(size_t j = 16 - i; j < 16; j++){

            res_p00[i + j - 16] -= p00 * src2[4 * j + 0];
            res_p02[i + j - 16] -= p02 * src2[4 * j + 1];
            _p01                 = src2[4 * j + 0] + src2[4 * j + 1];
            res_p01[i + j - 16] -= p01 * _p01;

            res_p20[i + j - 16] -= p20 * src2[4 * j + 2];
            res_p22[i + j - 16] -= p22 * src2[4 * j + 3];
            _p21                 = src2[4 * j + 2] + src2[4 * j + 3];
            res_p21[i + j - 16] -= p21 * _p21;

            res_p10[i + j - 16] -= p10 * (src2[4 * j + 0] + src2[4 * j + 2]);
            res_p12[i + j - 16] -= p12 * (src2[4 * j + 1] + src2[4 * j + 3]);
            _p11                 = _p01 + _p21;
            res_p11[i + j - 16] -= p11 * _p11;

        }
    }

    // Load 9, store 6.
    for(size_t i = 0; i < 16; i++){
        res_p01[i] = res_p01[i] - res_p00[i] - res_p02[i];
        res_p11[i] = res_p11[i] - res_p10[i] - res_p12[i];
        res_p21[i] = res_p21[i] - res_p20[i] - res_p22[i];

        res_p10[i] = res_p10[i] - res_p00[i] - res_p20[i];
        res_p11[i] = res_p11[i] - res_p01[i] - res_p21[i];
        res_p12[i] = res_p12[i] - res_p02[i] - res_p22[i];

        res_p10[i] += res_p02[i];
        res_p20[i] += res_p12[i];
    }

    // Load 11, store 4, Cache 3.
    des[0]  = res_p00[0] - res_p20[15];
    des[1]  = res_p01[0] - res_p21[15];
    des[2]  = res_p10[0] - res_p22[15];
    des[3]  = res_p11[0];
    buff[0] = res_p20[0];
    buff[1] = res_p21[0];
    buff[2] = res_p22[0];
    // Load 7, store 4, cache 3.
    for(size_t i = 1; i < 15; i++){
        des[4 * i + 0] = buff[0] + res_p00[i];
        des[4 * i + 1] = buff[1] + res_p01[i];
        des[4 * i + 2] = buff[2] + res_p10[i];
        des[4 * i + 3] =           res_p11[i];
        buff[0]        =           res_p20[i];
        buff[1]        =           res_p21[i];
        buff[2]        =           res_p22[i];
    }
    // Load 4, store 4.
    des[60] = buff[0] + res_p00[15];
    des[61] = buff[1] + res_p01[15];
    des[62] = buff[2] + res_p10[15];
    des[63] =           res_p11[15];

}

// ================
// Toom-4 matrices
/*

// ========

T
=

 1,  0,  0,  0,  0,   0,  0
 1,  1,  1,  1,  1,   1,  1
 1, -1,  1, -1,  1,  -1,  1
 1,  2,  4,  8, 16,  32, 64
 1, -2,  4, -8, 16, -32, 64
64, 32, 16,  8,  4,   2,  1
 0,  0,  0,  0,  0,   0,  1

// ========

T^{-1}
=

   1,     0,     0,     0,     0,     0,    0
  -2,  -2/3,  -2/9,  1/36,  1/60,  2/45,   -2
-5/4,   2/3,   2/3, -1/24, -1/24,     0,    4
 5/2,   3/2, -7/18, -1/18,     0, -1/18,  5/2
 1/4,  -1/6,  -1/6,  1/24,  1/24,     0,   -5
-1/2,  -1/3,   1/9,  1/36, -1/60,  1/90, -1/2
   0,     0,     0,     0,     0,     0,    1

=

diag(1, 1/4, 1/8, 1/2, 1/8, 1/4, 1)

   1,    0,    0,    0,     0,    0,   0
  -8, -8/3, -8/9,  1/9,  1/15, 8/45,  -8
 -10, 16/3, 16/3, -1/3,  -1/3,    0,  32
   5,    3, -7/9, -1/9,     0, -1/9,   5
   2, -4/3, -4/3,  1/3,   1/3,    0, -40
  -2, -4/3,  4/9,  1/9, -1/15, 2/45,  -2
   0,    0,    0,    0,     0,    0,   1

=

diag(1, 1/4, 1/8, 1/2, 1/8, 1/4, 1)

diag(1, 1/45, 1/3, 1/9, 1/3, 1/45, 1)

   1,    0,    0,    0,     0,    0,    0
-360, -120,  -40,    5,     3,    8, -360
 -30,   16,   16,   -1,    -1,    0,   96
  45,   27,   -7,   -1,     0,   -1,   45
   6,   -4,   -4,    1,     1,    0, -120
 -90,  -60,   20,    5,    -3,    2,  -90
   0,    0,    0,    0,     0,    0,    1

*/

// ================
// inverses modulo 2^16

// 3^(-1) = -21845
// 5^(-1) = -13107
// 9^(-1) = -29127
// 15^(-1) = -4369
// 45^(-1) = 20389

// ================

// Toom-4 evaluation full matrix
uint16_t TC4[7][7] = {
{ 1,  0,  0,  0,  0,   0,  0},
{ 1,  1,  1,  1,  1,   1,  1},
{ 1, -1,  1, -1,  1,  -1,  1},
{ 1,  2,  4,  8, 16,  32, 64},
{ 1, -2,  4, -8, 16, -32, 64},
{64, 32, 16,  8,  4,   2,  1},
{ 0,  0,  0,  0,  0,   0,  1}
};

// Toom-4 evaluation matrix
uint16_t TC4_trunc[7][7] = {
{ 1,  0,  0,  0, 0, 0, 0},
{ 1,  1,  1,  1, 0, 0, 0},
{ 1, -1,  1, -1, 0, 0, 0},
{ 1,  2,  4,  8, 0, 0, 0},
{ 1, -2,  4, -8, 0, 0, 0},
{ 8,  4,  2,  1, 0, 0, 0},
{ 0,  0,  0,  1, 0, 0, 0}
};

// Scaling for the inversion.
// diag(1, 1/45, 1/3, 1/9, 1/3, 1/45, 1)
uint16_t iTC4_modified_scale[7] = {
1, 20389, -21845, -29127, -21845, 20389, 1
};

// Toom-4 inversion matrix.
uint16_t iTC4_modified[7][7] = {
{   1,    0,    0,    0,     0,    0,    0},
{-360, -120,  -40,    5,     3,    8, -360},
{ -30,   16,   16,   -1,    -1,    0,   96},
{  45,   27,   -7,   -1,     0,   -1,   45},
{   6,   -4,   -4,    1,     1,    0, -120},
{ -90,  -60,   20,    5,    -3,    2,  -90},
{   0,    0,    0,    0,     0,    0,    1}
};

static
void TC_striding(uint16_t *des, uint16_t *src){

    uint16_t t0, t1, t2, t3;

     for(size_t i = 0; i < 64; i++){
        des[0 * 64 + i] = src[i * 4 + 0];
        t0 = src[i * 4 + 0] + src[i * 4 + 2];
        t1 = src[i * 4 + 1] + src[i * 4 + 3];
        des[1 * 64 + i] = t0 + t1;
        des[2 * 64 + i] = t0 - t1;
        t2 = src[i * 4 + 0] + 4 * src[i * 4 + 2];
        t3 = src[i * 4 + 1] + 4 * src[i * 4 + 3];
        des[3 * 64 + i] = t2 + 2 * t3;
        des[4 * 64 + i] = t2 - 2 * t3;
        des[5 * 64 + i] = ((src[i * 4 + 0] * 2 + src[i * 4 + 1]) * 2 + src[i * 4 + 2] ) * 2 + src[i * 4 + 3];
        des[6 * 64 + i] = src[i * 4 + 3];
    }

}

static
void iTC_striding(uint16_t *des, uint16_t *src){

    uint16_t TC4_buff[7];
    uint16_t t0, t1;

    for(size_t i = 0; i < 64; i++){

        // {-360, -120,  -40,    5,     3,    8, -360},
        t0 = ( (src[0 * 64 + i] + src[6 * 64 + i]) * 3 + src[1 * 64 + i]) * 3 + src[2 * 64 + i];
        t0 = src[5 * 64 + i] - t0 * 5;
        t0 *= 8;
        t0 += src[3 * 64 + i] * 5;
        t0 += src[4 * 64 + i] * 3;
        TC4_buff[1] = t0 * iTC4_modified_scale[1];

        // { -30,   16,   16,   -1,    -1,    0,   96},
        t0 = src[1 * 64 + i] + src[2 * 64 + i];
        t1 = src[3 * 64 + i] + src[4 * 64 + i];
        t0 = 16 * t0 - t1;
        t0 = t0 - 30 * src[0 * 64 + i];
        t0 += 96 * src[6 * 64 + i];
        TC4_buff[2] = t0 * iTC4_modified_scale[2];

        // {  45,   27,   -7,   -1,     0,   -1,   45},
        t0 = src[0 * 64 + i] + src[6 * 64 + i];
        t1 = src[3 * 64 + i] + src[5 * 64 + i];
        t0 = 45 * t0 - t1;
        t0 += 27 * src[1 * 64 + i];
        t0 = t0 - 7 * src[2 * 64 + i];
        TC4_buff[3] = t0 * iTC4_modified_scale[3];

        // {   6,   -4,   -4,    1,     1,    0, -120},
        t0 = src[1 * 64 + i] + src[2 * 64 + i];
        t1 = src[3 * 64 + i] + src[4 * 64 + i];
        t0 = t1 - 4 * t0;
        t0 += 6 * src[0 * 64 + i];
        t0 = t0 - 120 * src[6 * 64 + i];
        TC4_buff[4] = t0 * iTC4_modified_scale[4];

        // { -90,  -60,   20,    5,    -3,    2,  -90},
        t0 = src[0 * 64 + i] + src[6 * 64 + i];
        t0 *= -90;
        t0 = t0 - 60 * src[1 * 64 + i];
        t0 += 20 * src[2 * 64 + i];
        t0 += 5 * src[3 * 64 + i];
        t0 = t0 - 3 * src[4 * 64 + i];
        t0 += 2 * src[5 * 64 + i];
        TC4_buff[5] = t0 * iTC4_modified_scale[5];

        // Multiply by powers of two.
        src[1 * 64 + i] = TC4_buff[1] >> 2;
        src[2 * 64 + i] = TC4_buff[2] >> 3;
        src[3 * 64 + i] = TC4_buff[3] >> 1;
        src[4 * 64 + i] = TC4_buff[4] >> 3;
        src[5 * 64 + i] = TC4_buff[5] >> 2;
    }

    // Export the result.
    for(size_t i = 0; i < 64; i++){
        des[i * 4 + 3] = src[3 * 64 + i];
    }

    for(size_t i = 0; i < 63; i++){
        des[(i + 1) * 4 + 0] = src[0 * 64 + i + 1] + src[4 * 64 + i];
        des[(i + 1) * 4 + 1] = src[1 * 64 + i + 1] + src[5 * 64 + i];
        des[(i + 1) * 4 + 2] = src[2 * 64 + i + 1] + src[6 * 64 + i];
    }

    des[0] = src[0 * 64 + 0] - src[4 * 64 + 63];
    des[1] = src[1 * 64 + 0] - src[5 * 64 + 63];
    des[2] = src[2 * 64 + 0] - src[6 * 64 + 63];

}

// This function computes the product of two size-256 polynomials in Z_{2^16}[x] / (x^256 + 1)
// using Toom-4 with the point set {0, 1, -1, 2, -2, 1/2, \infty}.
// Notice that matrices are modifed to ensure the well-defineness over Z_{2^16}.
static
void TC_striding_mul(uint16_t *des, uint16_t *src1, uint16_t *src2){

    uint16_t src1_extended[7 * 64], src2_extended[7 * 64];

    // Apply Toom-4 evaluation matrix.
    TC_striding(src1_extended, src1);
    TC_striding(src2_extended, src2);

    // Compute small-dimensional products.
    for(size_t i = 0; i < 7; i++){
        negacyclic_Karatsuba_striding(src1_extended + i * 64,
                                      src1_extended + i * 64,
                                      src2_extended + i * 64);
    }

    // Apply Toom-4 inversion matrix.
    iTC_striding(des, src1_extended);

}

int main(void){

    uint16_t poly1[ARRAY_N], poly2[ARRAY_N];
    uint16_t ref[ARRAY_N], res[ARRAY_N];

    uint16_t t;
    uint16_t twiddle;

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        coeff_ring.memberZ(poly1 + i, &t);
        t = rand();
        coeff_ring.memberZ(poly2 + i, &t);
    }

    twiddle = -1;
    // Compute the product in Z_{2^32}[x].
    naive_mulR(ref, poly1, poly2, ARRAY_N, &twiddle, coeff_ring);
    // Reduce from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int16(ref + i, ref + i, &mod);
    }

    // Compute the product in Z_{2^32}[x] / (x^ARRAY_N + 1) via
    // striding followed by Toom-4 with the point set
    // {0, 1, -1, 2, -2, 1/2, \infty}.
    TC_striding_mul(res, poly1, poly2);
    // Reduce from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int16(res + i, res + i, &mod);
    }

    for(size_t i = 0; i < ARRAY_N; i++){
        assert(ref[i] == res[i]);
    }

    printf("Test finished!\n");



}
























