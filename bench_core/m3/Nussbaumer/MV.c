
#include <memory.h>

#include "MV.h"

void matrix_vector_mul(int32_t *des, int32_t *srcM, int32_t *srcV, size_t len){

    memset(des, 0, len * sizeof(int32_t));

    for(size_t i = 0; i < len; i++){
        for(size_t k = 0; k < len; k++){
            des[i] += srcM[i * len + k] * srcV[k];
        }
    }

}

void matrix_mul(int32_t *des, int32_t *src1, int32_t *src2, size_t len){

    memset(des, 0, len * len * sizeof(int32_t));

    for(size_t i = 0; i < len; i++){
        for(size_t j = 0; j < len; j++){
            for(size_t k = 0; k < len; k++){
                des[i * len + j] += src1[i * len + k] * src2[k * len + j];
            }
        }
    }

}


void TMVP(int32_t *des, int32_t *srcM, int32_t *srcV, size_t len){

    for(size_t i = 0; i < len; i++){
        des[i] = 0;
        for(size_t j = 0; j < len; j++){
            des[i] += srcM[len - 1 - i + j] * srcV[j];
        }
    }

}

