#ifndef MV_H
#define MV_H

#include <stdint.h>
#include <stddef.h>

void matrix_vector_mul(int32_t *des, int32_t *srcM, int32_t *srcV, size_t len);
void matrix_mul(int32_t *des, int32_t *src1, int32_t *src2, size_t len);
void TMVP(int32_t *des, int32_t *srcM, int32_t *srcV, size_t len);

#endif

