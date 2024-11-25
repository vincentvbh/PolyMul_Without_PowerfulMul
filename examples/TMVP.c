
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <memory.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"

// Q = 1, 2, 4, ..., 2^29
#define Q (1 << 19)

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
// Toeplitz-TC4 matrices
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

 4,     0,    0,    0,     0,     0,    0
-8,  -4/3, -4/9,  2/9,  2/15,  4/45,   -4
-5,   4/3,  4/3, -1/3,  -1/3,     0,    8
10,     3, -7/9, -4/9,     0,  -1/9,    5
 1,  -1/3, -1/3,  1/3,   1/3,     0,  -10
-2,  -2/3,  2/9,  2/9, -2/15,  1/45,   -1
 0,     0,    0,    0,     0,     0,    2

diag(1/4, 1/2, 1/2, 1/8, 1/8, 1/2, 1/2)

// ========

(T^(-1))^*

=

diag(1/4, 1/2, 1/2, 1/8, 1/8, 1/2, 1/2)

diag(1, 1/3, 1/9, 1/9, 1/15, 1/45)

4,   -8,   -5,   10,    1,    -2, 0
0,   -4,    4,    9,   -1,    -2, 0
0,   -4,   12,   -7,   -3,     2, 0
0,    2,   -3,   -4,    3,     2, 0
0,    2,   -5,    0,    5,    -2, 0
0,    4,    0,   -5,    0,     1, 0
0,   -4,    8,    5,  -10,    -1, 2

// ================
// inverses modulo 2^32

3^(-1) = -1431655765
5^(-1) = -858993459
9^(-1) = 954437177
15^(-1) = -286331153
45^(-1) = -1527099483

// ================

*/

// TC4 is only for referential purpose and not used.
int32_t TC4[7][7] = {
{ 1,  0,  0,  0,  0,   0,  0},
{ 1,  1,  1,  1,  1,   1,  1},
{ 1, -1,  1, -1,  1,  -1,  1},
{ 1,  2,  4,  8, 16,  32, 64},
{ 1, -2,  4, -8, 16, -32, 64},
{64, 32, 16,  8,  4,   2,  1},
{ 0,  0,  0,  0,  0,   0,  1}
};

int32_t TC4_trunc[7][7] = {
{ 1,  0,  0,  0, 0, 0, 0},
{ 1,  1,  1,  1, 0, 0, 0},
{ 1, -1,  1, -1, 0, 0, 0},
{ 1,  2,  4,  8, 0, 0, 0},
{ 1, -2,  4, -8, 0, 0, 0},
{ 8,  4,  2,  1, 0, 0, 0},
{ 0,  0,  0,  1, 0, 0, 0}
};

// TC4_trunc_T is only for referential purpose and not used.
int32_t TC4_trunc_T[7][7] = {
{ 1,  1,  1,  1,  1,  8,  0},
{ 0,  1, -1,  2, -2,  4,  0},
{ 0,  1,  1,  4,  4,  2,  0},
{ 0,  1, -1,  8, -8,  1,  1},
{ 0,  0,  0,  0,  0,  0,  0},
{ 0,  0,  0,  0,  0,  0,  0},
{ 0,  0,  0,  0,  0,  0,  0}
};

// diag(1, 1/3, 1/9, 1/9, 1/15, 1/45, 1)
int32_t iTC4_T_modified_scale[7] = {
1, -1431655765, 954437177, 954437177, -286331153, -1527099483, 1
};

int32_t iTC4_T_modified[7][7] = {
{4,   -8,   -5,   10,    1,    -2, 0},
{0,   -4,    4,    9,   -1,    -2, 0},
{0,   -4,   12,   -7,   -3,     2, 0},
{0,    2,   -3,   -4,    3,     2, 0},
{0,    2,   -5,    0,    5,    -2, 0},
{0,    4,    0,   -5,    0,     1, 0},
{0,   -4,    8,    5,  -10,    -1, 2}
};

// The first 4 coefficients are scaled by 8, 4, 2, 2, respectively.
int32_t TC4_trunc_T_modified[7][7] = {
{ 2,  4,  4,  1,  1, 32,  0},
{ 0,  2, -2,  1, -1,  8,  0},
{ 0,  1,  1,  1,  1,  2,  0},
{ 0,  1, -1,  2, -2,  1,  1},
{ 0,  0,  0,  0,  0,  0,  0},
{ 0,  0,  0,  0,  0,  0,  0},
{ 0,  0,  0,  0,  0,  0,  0}
};

static
void TMVP(int32_t *des, int32_t *srcM, int32_t *srcV, size_t len){

    int32_t buff[len];

    for(size_t i = 0; i < len; i++){
        buff[i] = 0;
        for(size_t j = 0; j < len; j++){
            buff[i] += srcM[len - 1 - i + j] * srcV[j];
        }
    }

    memmove(des, buff, sizeof(buff));

}

// TMVP_TC_Hom_V transforming a vector of 4 elements to a vector of 7 elements.
static
void TMVP_TC_Hom_V(int32_t *des, int32_t *src, size_t jump){

    int32_t buff[7];

    for(size_t i = 0; i < 7; i++){
        buff[i] = 0;
        for(size_t j = 0; j < 4; j++){
            buff[i] += TC4_trunc[i][j] * src[j * jump];
        }
    }

    for(size_t i = 0; i < 7; i++){
        des[i * jump] = buff[i];
    }

}

// TMVP_TC_Hom_I transforming a vector of 7 elements to a vector of 7 elements.
static
void TMVP_TC_Hom_I(int32_t *des, int32_t *src, size_t jump){

    int32_t buff[4];

    for(size_t i = 0; i < 4; i++){
        buff[i] = 0;
        for(size_t j = 0; j < 7; j++){
            buff[i] += TC4_trunc_T_modified[i][j] * src[j * jump];
        }
    }

    des[0 * jump] = buff[3] >> 1;
    des[1 * jump] = buff[2] >> 1;
    des[2 * jump] = buff[1] >> 2;
    des[3 * jump] = buff[0] >> 3;

}

// TMVP_TC_Hom_M transforming a size-16 polynomial into its Toeplitz form followed by
// the transformation mapping seven 4x4 Toeplitz matrices to seven 4x4 Toeplitz matrices.
// We apply on-the-fly extraction for the small Toeplitz matrices and merge the negation with
// the map iTC4_T_modified itself.
static
void TMVP_TC_Hom_M(int32_t *des, int32_t *src){

    int32_t src_buff[4];
    int32_t buff[7];

    for(size_t i = 0; i < 4; i++){

        src_buff[0] = src[15 - i];
        src_buff[1] = src[11 - i];
        src_buff[2] = src[7 - i];
        src_buff[3] = src[3 - i];

        buff[0] =    3 * src_buff[0] - 6 * src_buff[1] -  5 * src_buff[2] + 10 * src_buff[3];
        buff[1] =        src_buff[0] - 2 * src_buff[1] +  4 * src_buff[2] +  9 * src_buff[3];
        buff[2] =    3 * src_buff[0] - 6 * src_buff[1] + 12 * src_buff[2] -  7 * src_buff[3];
        buff[3] = (-3) * src_buff[0]                   -  3 * src_buff[2] -  4 * src_buff[3];
        buff[4] = (-5) * src_buff[0] + 4 * src_buff[1] -  5 * src_buff[2];
        buff[5] =                      3 * src_buff[1]                    -  5 * src_buff[3];
        buff[6] =   10 * src_buff[0] - 3 * src_buff[1] +  6 * src_buff[2] +  5 * src_buff[3];

        for(size_t j = 0; j < 7; j++){
            des[j * 8 + i] = buff[j] * iTC4_T_modified_scale[j];
        }

    }

    for(size_t i = 0; i < 3; i++){

        src_buff[0] = src[11 - i];
        src_buff[1] = src[7 - i];
        src_buff[2] = src[3 - i];
        src_buff[3] = src[15 - i];

        buff[0] =    3 * src_buff[0] - 6 * src_buff[1] -  5 * src_buff[2] - 10 * src_buff[3];
        buff[1] =        src_buff[0] - 2 * src_buff[1] +  4 * src_buff[2] -  9 * src_buff[3];
        buff[2] =    3 * src_buff[0] - 6 * src_buff[1] + 12 * src_buff[2] +  7 * src_buff[3];
        buff[3] = (-3) * src_buff[0]                   -  3 * src_buff[2] +  4 * src_buff[3];
        buff[4] = (-5) * src_buff[0] + 4 * src_buff[1] -  5 * src_buff[2];
        buff[5] =                      3 * src_buff[1]                    +  5 * src_buff[3];
        buff[6] =   10 * src_buff[0] - 3 * src_buff[1] +  6 * src_buff[2] -  5 * src_buff[3];

        for(size_t j = 0; j < 7; j++){
            des[j * 8 + i + 4] = buff[j] * iTC4_T_modified_scale[j];
        }

    }

}

// Compute the product of two size-16 polynomials in Z_Q[x] / (x^16 + 1) via Toeplitz-TC4.
// Notice that in our use case, the input of this function has coefficients
// in Z_{2^24} so we don't really need to load the most-significant byte of the inputs.
// (We still need to compute the 32-bit results.)
static
void TMVP_TC4_negacyclic16_mul(int32_t *des, int32_t *src1, int32_t *src2){

    int32_t src1_V_full[7][4];
    int32_t src2_Toeplitz_full[7][8];
    int32_t res_V_full[7][4];

    for(size_t i = 0; i < 4; i++){
        TMVP_TC_Hom_V((int32_t*)&src1_V_full[0][i], src1 + i, 4);
    }

    TMVP_TC_Hom_M((int32_t*)&src2_Toeplitz_full[0][0], src2);

    for(size_t i = 0; i < 7; i++){
        TMVP((int32_t*)&res_V_full[i][0], (int32_t*)&src2_Toeplitz_full[i][0], (int32_t*)&src1_V_full[i][0], 4);
    }

    for(size_t i = 0; i < 4; i++){
        TMVP_TC_Hom_I(des + i, (int32_t*)&res_V_full[0][i], 4);
    }

}

int main(void){

    int32_t poly1[16], poly2[16];
    int32_t ref[16], res[16];

    int32_t twiddle, t;

    for(size_t i = 0; i < 4; i++){
        t = rand();
        cmod_int32(poly1 + i, &t, &mod);
        t = rand();
        cmod_int32(poly2 + i, &t, &mod);
    }

    // Compute the product in Z_{2^32}[x] / (x^16 + 1).
    twiddle = -1;
    naive_mulR(ref, poly1, poly2, 16, &twiddle, coeff_ring);
    // Reduce from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < 16; i++){
        cmod_int32(ref + i, ref + i, &mod);
    }

    // Compute the product in Z_{2^32}[x] / (x^4 + 1) with TMVP built upon the
    // Toom-4 with the point set {0, 1, -1, 2, -2, 1/2, \infty}.
    TMVP_TC4_negacyclic16_mul(res, poly1, poly2);
    // Reduce from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < 16; i++){
        cmod_int32(res + i, res + i, &mod);
    }

    for(size_t i = 0; i < 16; i++){
        assert(ref[i] == res[i]);
    }

    printf("Test finished!\n");


}
























