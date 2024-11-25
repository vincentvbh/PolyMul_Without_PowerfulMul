
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"

// When INPLACE is defined, the input and output of shift_addsub/addsub_shift_neg can be overlapped.
// If INPLACE is not define, overlapped input and output will result in incorrect result.
// For fully optimized implementations, one should not overlap the input and output and prepare buffers
// for the intermediate results.

#define INPLACE

#define ARRAY_N 256

// ======== Optimization Guide ========
// Nussbaumer fast Fourier transform extends the coefficient ring and adjoins
// structures that splits based on the substructure of the polynomial ring.
// The benefit is that the splitting the newly adjoined structure amounts
// to additions, subtractions, and negayclic shifts.

// Q = 1, 2, 4, ..., 2^24
#define Q (1 << 19)
#define COEFF_SIZE (sizeof(int32_t))

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
// Toeplitz TC-4

int32_t TC4_trunc[7][7] = {
{ 1,  0,  0,  0, 0, 0, 0},
{ 1,  1,  1,  1, 0, 0, 0},
{ 1, -1,  1, -1, 0, 0, 0},
{ 1,  2,  4,  8, 0, 0, 0},
{ 1, -2,  4, -8, 0, 0, 0},
{ 8,  4,  2,  1, 0, 0, 0},
{ 0,  0,  0,  1, 0, 0, 0}
};

int32_t iTC4_T_modified_scale[7] = {
1, -1431655765, 954437177, 954437177, -286331153, -1527099483, 1
};

// int32_t iTC4_T_modified[7][7] = {
// {4,   -8,   -5,   10,    1,    -2, 0},
// {0,   -4,    4,    9,   -1,    -2, 0},
// {0,   -4,   12,   -7,   -3,     2, 0},
// {0,    2,   -3,   -4,    3,     2, 0},
// {0,    2,   -5,    0,    5,    -2, 0},
// {0,    4,    0,   -5,    0,     1, 0},
// {0,   -4,    8,    5,  -10,    -1, 2}
// };

// 1/8, 1/4, 1/2, 1/2
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

static
void TMVP_Hom_V(int32_t *des, int32_t *src){
    for(size_t i = 0; i < 32; i++){
        for(size_t j = 0; j < 4; j++){
            TMVP_TC_Hom_V(des + i * 28 + j, src + i * 16 + j, 4);
        }
    }
}

static
void TMVP_Hom_M(int32_t *des, int32_t *src){
    for(size_t i = 0; i < 32; i++){
        TMVP_TC_Hom_M(des + i * 56, src + i * 16);
    }
}

static
void TMVP_BiHom(int32_t *des, int32_t *src_M, int32_t *src_V){
    for(size_t i = 0; i < 32; i++){
        for(size_t j = 0; j < 7; j++){
            TMVP(des + i * 28 + j * 4, src_M + i * 56 + j * 8, src_V + i * 28 + j * 4, 4);
        }
    }
}

static
void TMVP_Hom_I(int32_t *des, int32_t *src){
    for(size_t i = 0; i < 32; i++){
        for(size_t j = 0; j < 4; j++){
            TMVP_TC_Hom_I(des + i * 16 + j, src + i * 28 + j, 4);
        }
    }
}

// ================
// Nussbaumer

static
void shift_addsub(int32_t *des, int32_t *src, size_t jump, size_t shift){

#ifdef INPLACE

    int32_t buff[16];

    for(size_t i = 0; i < shift; i++){
        buff[i] = src[i] + src[jump * 16 + ( (i + 16 - shift) % 16)];
        des[i]  = src[i] - src[jump * 16 + ( (i + 16 - shift) % 16)];
    }

    for(size_t i = shift; i < 16; i++){
        buff[i] = src[i] - src[jump * 16 + (i - shift)];
        des[i]  = src[i] + src[jump * 16 + (i - shift)];
    }

    for(size_t i = 0; i < 16; i++){
        des[jump * 16 + i] = buff[i];
    }

#else

    for(size_t i = 0; i < shift; i++){
        des[i]             = src[i] - src[jump * 16 + ( (i + 16 - shift) % 16)];
        des[jump * 16 + i] = src[i] + src[jump * 16 + ( (i + 16 - shift) % 16)];
    }

    for(size_t i = shift; i < 16; i++){
        des[i]             = src[i] + src[jump * 16 + (i - shift)];
        des[jump * 16 + i] = src[i] - src[jump * 16 + (i - shift)];
    }

#endif

}

// des and src should not overlap when INPLACE shift_addsub is not enabled.
static
void CT_1(int32_t *des, int32_t *src){

    for(size_t i = 0; i < 8; i++){
        shift_addsub(des + i * 16, src + i * 16, 8, 0);
    }

    for(size_t i = 16; i < 24; i++){
        shift_addsub(des + i * 16, src + i * 16, 8, 8);
    }

}

// des and src should not overlap when INPLACE shift_addsub is not enabled.
static
void CT_2(int32_t *des, int32_t *src){

    for(size_t i = 0; i < 4; i++){
        shift_addsub(des + i * 16, src + i * 16, 4,  0);
    }

    for(size_t i = 8; i < 12; i++){
        shift_addsub(des + i * 16, src + i * 16, 4,  8);
    }

    for(size_t i = 16; i < 20; i++){
        shift_addsub(des + i * 16, src + i * 16, 4,  4);
    }

    for(size_t i = 24; i < 28; i++){
        shift_addsub(des + i * 16, src + i * 16, 4, 12);
    }

}

// des and src should not overlap when INPLACE shift_addsub is not enabled.
static
void CT_3(int32_t *des, int32_t *src){

    for(size_t i = 0; i < 2; i++){
        shift_addsub(des + i * 16, src + i * 16, 2,  0);
    }

    for(size_t i = 4; i < 6; i++){
        shift_addsub(des + i * 16, src + i * 16, 2,  8);
    }

    for(size_t i = 8; i < 10; i++){
        shift_addsub(des + i * 16, src + i * 16, 2,  4);
    }

    for(size_t i = 12; i < 14; i++){
        shift_addsub(des + i * 16, src + i * 16, 2, 12);
    }

    for(size_t i = 16; i < 18; i++){
        shift_addsub(des + i * 16, src + i * 16, 2,  2);
    }

    for(size_t i = 20; i < 22; i++){
        shift_addsub(des + i * 16, src + i * 16, 2, 10);
    }

    for(size_t i = 24; i < 26; i++){
        shift_addsub(des + i * 16, src + i * 16, 2,  6);
    }

    for(size_t i = 28; i < 30; i++){
        shift_addsub(des + i * 16, src + i * 16, 2, 14);
    }

}

// des and src should not overlap when INPLACE shift_addsub is not enabled.
static
void CT_4(int32_t *des, int32_t *src){

    shift_addsub(des +  0 * 16, src +  0 * 16, 1,  0);
    shift_addsub(des +  2 * 16, src +  2 * 16, 1,  8);
    shift_addsub(des +  4 * 16, src +  4 * 16, 1,  4);
    shift_addsub(des +  6 * 16, src +  6 * 16, 1, 12);
    shift_addsub(des +  8 * 16, src +  8 * 16, 1,  2);
    shift_addsub(des + 10 * 16, src + 10 * 16, 1, 10);
    shift_addsub(des + 12 * 16, src + 12 * 16, 1,  6);
    shift_addsub(des + 14 * 16, src + 14 * 16, 1, 14);
    shift_addsub(des + 16 * 16, src + 16 * 16, 1,  1);
    shift_addsub(des + 18 * 16, src + 18 * 16, 1,  9);
    shift_addsub(des + 20 * 16, src + 20 * 16, 1,  5);
    shift_addsub(des + 22 * 16, src + 22 * 16, 1, 13);
    shift_addsub(des + 24 * 16, src + 24 * 16, 1,  3);
    shift_addsub(des + 26 * 16, src + 26 * 16, 1, 11);
    shift_addsub(des + 28 * 16, src + 28 * 16, 1,  7);
    shift_addsub(des + 30 * 16, src + 30 * 16, 1, 15);

}

static
void addsub_shift_neg(int32_t *des, int32_t *src, size_t jump, size_t shift, bool neg){

#ifdef INPLACE

    int32_t buff[16];

    if(neg){

        for(size_t i = 0; i < 16 - shift; i++){
            buff[i] = src[jump * 16 + i] - src[i];
            des[i]  = src[jump * 16 + i] + src[i];
        }

        for(size_t i = 16 - shift; i < 16; i++){
            buff[i] = src[i] - src[jump * 16 + i];
            des[i]  = src[i] + src[jump * 16 + i];
        }

    }else{

        for(size_t i = 0; i < 16 - shift; i++){
            buff[i] = src[i] - src[jump * 16 + i];
            des[i]  = src[i] + src[jump * 16 + i];
        }

        for(size_t i = 16 - shift; i < 16; i++){
            buff[i] = src[jump * 16 + i] - src[i];
            des[i]  = src[jump * 16 + i] + src[i];
        }

    }

    for(size_t i = 0; i < 16 - shift; i++){
        des[jump * 16 + i + shift] = buff[i];
    }

    for(size_t i = 16 - shift; i < 16; i++){
        des[jump * 16 + i + shift - 16] = buff[i];
    }

#else

    if(neg){

        for(size_t i = 0; i < 16 - shift; i++){
            des[i]                     = src[jump * 16 + i] + src[i];
            des[jump * 16 + i + shift] = src[jump * 16 + i] - src[i];
        }

        for(size_t i = 16 - shift; i < 16; i++){
            des[i]                          = src[i] + src[jump * 16 + i];
            des[jump * 16 + i + shift - 16] = src[i] - src[jump * 16 + i];
        }

    }else{

        for(size_t i = 0; i < 16 - shift; i++){
            des[i]                     = src[i] + src[jump * 16 + i];
            des[jump * 16 + i + shift] = src[i] - src[jump * 16 + i];
        }

        for(size_t i = 16 - shift; i < 16; i++){
            des[i]                          = src[jump * 16 + i] + src[i];
            des[jump * 16 + i + shift - 16] = src[jump * 16 + i] - src[i];
        }

    }

#endif

}

// des and src should not overlap when INPLACE addsub_shift_neg is not enabled.
static
void GS_1(int32_t *des, int32_t *src){

    for(size_t i = 0; i < 8; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 8, 0, 0);
    }

    for(size_t i = 16; i < 24; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 8, 8, 1);
    }

}

// des and src should not overlap when INPLACE addsub_shift_neg is not enabled.
static
void GS_2(int32_t *des, int32_t *src){

    for(size_t i = 0; i < 4; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 4,  0, 0);
    }

    for(size_t i = 8; i < 12; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 4,  8, 1);
    }

    for(size_t i = 16; i < 20; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 4, 12, 1);
    }

    for(size_t i = 24; i < 28; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 4,  4, 1);
    }

}

// des and src should not overlap when INPLACE addsub_shift_neg is not enabled.
static
void GS_3(int32_t *des, int32_t *src){

    for(size_t i = 0; i < 2; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2,  0, 0);
    }

    for(size_t i = 4; i < 6; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2,  8, 1);
    }

    for(size_t i = 8; i < 10; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2, 12, 1);
    }

    for(size_t i = 12; i < 14; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2,  4, 1);
    }

    for(size_t i = 16; i < 18; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2, 14, 1);
    }

    for(size_t i = 20; i < 22; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2,  6, 1);
    }

    for(size_t i = 24; i < 26; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2, 10, 1);
    }

    for(size_t i = 28; i < 30; i++){
        addsub_shift_neg(des + i * 16, src + i * 16, 2,  2, 1);
    }

}

// des and src should not overlap when INPLACE addsub_shift_neg is not enabled.
static
void GS_4(int32_t *des, int32_t *src){

    addsub_shift_neg(des +  0 * 16, src +  0 * 16, 1,  0, 0);
    addsub_shift_neg(des +  2 * 16, src +  2 * 16, 1,  8, 1);
    addsub_shift_neg(des +  4 * 16, src +  4 * 16, 1, 12, 1);
    addsub_shift_neg(des +  6 * 16, src +  6 * 16, 1,  4, 1);
    addsub_shift_neg(des +  8 * 16, src +  8 * 16, 1, 14, 1);
    addsub_shift_neg(des + 10 * 16, src + 10 * 16, 1,  6, 1);
    addsub_shift_neg(des + 12 * 16, src + 12 * 16, 1, 10, 1);
    addsub_shift_neg(des + 14 * 16, src + 14 * 16, 1,  2, 1);
    addsub_shift_neg(des + 16 * 16, src + 16 * 16, 1, 15, 1);
    addsub_shift_neg(des + 18 * 16, src + 18 * 16, 1,  7, 1);
    addsub_shift_neg(des + 20 * 16, src + 20 * 16, 1, 11, 1);
    addsub_shift_neg(des + 22 * 16, src + 22 * 16, 1,  3, 1);
    addsub_shift_neg(des + 24 * 16, src + 24 * 16, 1, 13, 1);
    addsub_shift_neg(des + 26 * 16, src + 26 * 16, 1,  5, 1);
    addsub_shift_neg(des + 28 * 16, src + 28 * 16, 1,  9, 1);
    addsub_shift_neg(des + 30 * 16, src + 30 * 16, 1,  1, 1);

}

static
void Hom_V(int32_t *des, int32_t *src){

    int32_t buff_NTT[32 * 16];

    for(size_t i = 0; i < 16; i++){
        for(size_t j = 0; j < 16; j++){
            buff_NTT[(j + 16) * 16 + i] = buff_NTT[j * 16 + i] = src[i * 16 + j];
        }
    }

#ifdef INPLACE
    CT_1(buff_NTT, buff_NTT);
    CT_2(buff_NTT, buff_NTT);
    CT_3(buff_NTT, buff_NTT);
    CT_4(buff_NTT, buff_NTT);
#else
    CT_1(des, buff_NTT);
    CT_2(buff_NTT, des);
    CT_3(des, buff_NTT);
    CT_4(buff_NTT, des);
#endif

    TMVP_Hom_V(des, buff_NTT);

}

static
void Hom_M(int32_t *des, int32_t *src){

    int32_t buff_NTT[32 * 16];

    for(size_t i = 0; i < 16; i++){
        for(size_t j = 0; j < 16; j++){
            buff_NTT[(j + 16) * 16 + i] = buff_NTT[j * 16 + i] = src[i * 16 + j];
        }
    }

#ifdef INPLACE
    CT_1(buff_NTT, buff_NTT);
    CT_2(buff_NTT, buff_NTT);
    CT_3(buff_NTT, buff_NTT);
    CT_4(buff_NTT, buff_NTT);
#else
    CT_1(des, buff_NTT);
    CT_2(buff_NTT, des);
    CT_3(des, buff_NTT);
    CT_4(buff_NTT, des);
#endif

    TMVP_Hom_M(des, buff_NTT);

}

static
void Hom_I(int32_t *des, int32_t *src){

    int32_t buff[16];
    int32_t buff_NTT[32 * 16];

    TMVP_Hom_I(buff_NTT, src);

    // Apply the inverse of symbolic FFT.
#ifdef INPLACE
    GS_4(buff_NTT, buff_NTT);
    GS_3(buff_NTT, buff_NTT);
    GS_2(buff_NTT, buff_NTT);
    GS_1(buff_NTT, buff_NTT);
#else
    GS_4(src, buff_NTT);
    GS_3(buff_NTT, src);
    GS_2(src, buff_NTT);
    GS_1(buff_NTT, src);
#endif

// ========

    // Apply the 0th layer of GS butterfly buffly and
    // map
    // ( Z_{32}[y] / (y^16 + 1) ) [x] / (x^32 - 1)
    // to
    // ( Z_{32}[y] / (y^16 + 1) ) [x] / (x^16 - y)
    // on the fly.

    for(size_t i = 0; i < 16; i++){
        des[i]  = buff_NTT[i * 16] + buff_NTT[(i + 16) * 16];
        buff[i] = buff_NTT[i * 16] - buff_NTT[(i + 16) * 16];
    }

    for(size_t i = 1; i < 16; i++){
        for(size_t j = 0; j < 16; j++){
            des[i * 16 + j] = buff_NTT[j * 16 + i] + buff_NTT[(j + 16) * 16 + i];
            des[i * 16 + j] = des[i * 16 + j] + buff[j];
            des[i * 16 + j] = des[i * 16 + j] >> 5;
            buff[j]         = buff_NTT[j * 16 + i] - buff_NTT[(j + 16) * 16 + i];
        }
    }

    for(size_t i = 0; i < 16; i++){
        des[i] -= buff[i];
        des[i] >>= 5;
    }

}

static
void BiHom(int32_t *des, int32_t *src_M, int32_t *src_V){
    TMVP_BiHom(des, src_M, src_V);
}

int main(void){

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t poly1_V[32 * 7 * 4];
    int32_t poly2_M[32 * 7 * 8];
    int32_t res_MV[32 * 7 * 4];
    int32_t ref[ARRAY_N], res[ARRAY_N];

    int32_t twiddle, t;

// ================
// Initialization

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        cmod_int32(poly1 + i, &t, &mod);
        t = rand();
        cmod_int32(poly2 + i, &t, &mod);
    }

// ================

    // We compute poly1 * poly2 in Z_{2^32}[x] / (x^256 + 1).
    twiddle = -1;
    naive_mulR(ref, poly1, poly2, ARRAY_N, &twiddle, coeff_ring);
    // Reduce the coefficient ring from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(ref + i, ref + i, &mod);
    }

// Nussbaumer and Toeplitz-TC4 for Z_Q[x]/ (x^256 + 1)
// ================

    Hom_V(poly1_V, poly1);
    Hom_M(poly2_M, poly2);
    BiHom(res_MV, poly2_M, poly1_V);
    Hom_I(res, res_MV);

// ================

    // Reduce the coefficient ring from Z_{2^32} to Z_Q.
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(res + i, res + i, &mod);
    }

// ================

    for(size_t i = 0; i < ARRAY_N; i++){
        assert(ref[i] == res[i]);
    }

    printf("Test finished!\n");

}









