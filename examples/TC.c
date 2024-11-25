
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

#define ARRAY_N 16

// Q = 1, 2, 4, ..., 2^29
#define Q (1 << 29)

int32_t mod = Q;

void memberZ(void *des, void *src){
    *(int32_t*)des = *(int32_t*)src;
}

void addZ(void *des, void *src1, void *src2){
    *(int32_t*)des = (*(int32_t*)src1) + (*(int32_t*)src2);
}

void subZ(void *des, void *src1, void *src2){
    *(int32_t*)des = (*(int32_t*)src1) - (*(int32_t*)src2);
}

void mulZ(void *des, void *src1, void *src2){
    *(int32_t*)des = (*(int32_t*)src1) * (*(int32_t*)src2);
}

void expZ(void *des, void *src, size_t e){

    int32_t src_v = *(int32_t*)src;
    int32_t tmp_v;

    tmp_v = 1;
    for(; e; e >>= 1){
        if(e & 1){
            tmp_v = tmp_v * src_v;
        }
        src_v = src_v * src_v;
    }

    memmove(des, &tmp_v, sizeof(int32_t));
}

struct commutative_ring coeff_ring = {
    .sizeZ = sizeof(int32_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};

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
// inverses modulo 2^32

// 3^(-1) = -1431655765
// 5^(-1) = -858993459
// 9^(-1) = 954437177
// 15^(-1) = -286331153
// 45^(-1) = -1527099483

// ================

// Toom-4 evaluation full matrix
int32_t TC4[7][7] = {
{ 1,  0,  0,  0,  0,   0,  0},
{ 1,  1,  1,  1,  1,   1,  1},
{ 1, -1,  1, -1,  1,  -1,  1},
{ 1,  2,  4,  8, 16,  32, 64},
{ 1, -2,  4, -8, 16, -32, 64},
{64, 32, 16,  8,  4,   2,  1},
{ 0,  0,  0,  0,  0,   0,  1}
};

// Toom-4 evaluation matrix
// This is also referred as Hom-V in TMVP.
int32_t TC4_trunc[7][7] = {
{ 1,  0,  0,  0, 0, 0, 0},
{ 1,  1,  1,  1, 0, 0, 0},
{ 1, -1,  1, -1, 0, 0, 0},
{ 1,  2,  4,  8, 0, 0, 0},
{ 1, -2,  4, -8, 0, 0, 0},
{ 8,  4,  2,  1, 0, 0, 0},
{ 0,  0,  0,  1, 0, 0, 0}
};

// diag(1, 1/45, 1/3, 1/9, 1/3, 1/45, 1)
int32_t iTC4_modified_scale[7] = {
1, -1527099483, -1431655765, 954437177, -1431655765, -1527099483, 1
};

int32_t iTC4_modified[7][7] = {
{   1,    0,    0,    0,     0,    0,    0},
{-360, -120,  -40,    5,     3,    8, -360},
{ -30,   16,   16,   -1,    -1,    0,   96},
{  45,   27,   -7,   -1,     0,   -1,   45},
{   6,   -4,   -4,    1,     1,    0, -120},
{ -90,  -60,   20,    5,    -3,    2,  -90},
{   0,    0,    0,    0,     0,    0,    1}
};

static
void TC(int32_t *des, int32_t *src){

    int32_t buff[7];

    for(size_t i = 4; i < 7; i++){
        buff[i] = 0;
    }

    for(size_t i = 0; i < 4; i++){
        for(size_t j = 0; j < 7; j++){
            buff[j] = 0;
            for(size_t k = 0; k < 4; k++){
                buff[j] += TC4_trunc[j][k] * src[i * 4 + k];
            }
        }
        for(size_t j = 0; j < 7; j++){
            des[j * 4 + i] = buff[j];
        }
    }

}

static
void iTC(int32_t *des, int32_t *src){

    int32_t TC4_buff[7];
    int32_t buff[7];

    // Apply Toom-4 inversion matrix.
    for(size_t j = 0; j < 7; j++){
        TC4_buff[j] = 0;
        for(size_t k = 0; k < 7; k++){
            TC4_buff[j] += iTC4_modified[j][k] * src[k * 4 + 0];
        }
        TC4_buff[j] = TC4_buff[j] * iTC4_modified_scale[j];
    }
    // Multiply by powers of two.
    TC4_buff[1] >>= 2;
    TC4_buff[2] >>= 3;
    TC4_buff[3] >>= 1;
    TC4_buff[4] >>= 3;
    TC4_buff[5] >>= 2;
    for(size_t j = 0; j < 7; j++){
        src[j * 4 + 0] = TC4_buff[j];
    }

    for(size_t j = 4; j < 7; j++){
        buff[j] = TC4_buff[j];
    }

    for(size_t i = 1; i < 4; i++){
        for(size_t j = 0; j < 7; j++){
            TC4_buff[j] = 0;
            for(size_t k = 0; k < 7; k++){
                TC4_buff[j] += iTC4_modified[j][k] * src[k * 4 + i];
            }
            TC4_buff[j] = TC4_buff[j] * iTC4_modified_scale[j];
        }
        // Multiply by powers of two.
        TC4_buff[1] >>= 2;
        TC4_buff[2] >>= 3;
        TC4_buff[3] >>= 1;
        TC4_buff[4] >>= 3;
        TC4_buff[5] >>= 2;
        for(size_t j = 0; j < 4; j++){
            src[j * 4 + i] = TC4_buff[j];
        }
        for(size_t j = 0; j < 3; j++){
            src[j * 4 + i] += buff[j + 4];
        }
        for(size_t j = 4; j < 7; j++){
            buff[j] = TC4_buff[j];
        }

    }

    for(size_t j = 0; j < 3; j++){
        src[j * 4 + 0] -= buff[j + 4];
    }

    // Export the result.
    for(size_t i = 0; i < 4; i++){
        for(size_t j = 0; j < 4; j++){
            des[i * 4 + j] = src[j * 4 + i];
        }
    }

}

static
void negacyclic_4x4(int32_t *des, int32_t *src1, int32_t *src2){
    des[0] = src1[0] * src2[0] - src1[3] * src2[1]
           - src1[2] * src2[2] - src1[1] * src2[3];
    des[1] = src1[1] * src2[0] + src1[0] * src2[1]
           - src1[3] * src2[2] - src1[2] * src2[3];
    des[2] = src1[2] * src2[0] + src1[1] * src2[1]
           + src1[0] * src2[2] - src1[3] * src2[3];
    des[3] = src1[3] * src2[0] + src1[2] * src2[1]
           + src1[1] * src2[2] + src1[0] * src2[3];
}

// This function computes the product of two size-4 polynomials in Z_Q[x]
// using Toom-4 with the point set {0, 1, -1, 2, -2, 1/2, \infty}.
// Notice that matrices are modifed to ensure the well-defineness over Z_{32}.
static
void TC_striding_mul(int32_t *des, int32_t *src1, int32_t *src2){

    int32_t src1_extended[7][4], src2_extended[7][4];
    int32_t res[7][4];

    // Apply Toom-4 evaluation matrix.
    TC((int32_t*)&src1_extended[0][0], src1);
    TC((int32_t*)&src2_extended[0][0], src2);

    // Compute small-dimensional products.
    for(size_t i = 0; i < 7; i++){
        negacyclic_4x4((int32_t*)&res[i][0], (int32_t*)&src1_extended[i][0], (int32_t*)&src2_extended[i][0]);
    }

    iTC(des, (int32_t*)&res[0][0]);

}

int main(void){

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t ref[ARRAY_N], res[ARRAY_N];

    int32_t t;
    int32_t twiddle;

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
        cmod_int32(ref + i, ref + i, &mod);
    }

    // Compute the product in Z_{2^32}[x] via Toom-4 with the point set
    // {0, 1, -1, 2, -2, 1/2, \infty}.
    TC_striding_mul(res, poly1, poly2);
    // Reduce from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(res + i, res + i, &mod);
    }

    for(size_t i = 0; i < ARRAY_N; i++){
        assert(ref[i] == res[i]);
    }

    printf("Test finished!\n");



}
























