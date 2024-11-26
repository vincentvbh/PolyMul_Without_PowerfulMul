
#ifndef NAIVE_MULT
#define NAIVE_MULT

#include <stddef.h>

#include "tools.h"

// ================================
// multiplication in R[x] / (x^len - twiddle)
// where R is the ring defined by mod, addmod, mulmod

void naive_mulR(
    void *des,
    void *src1, void *src2,
    size_t len, void *twiddle,
    struct commutative_ring ring
    );

// ================================
// point-wise multiplication of src1[len * jump] by src2[len]
// in particular, for i in {0, ..., len - 1} and j in {0, ..., jump - 1},
// src1[i * jump + j] is multiplied by src2[i]

void point_mul(
    void *des,
    void *src1, void *src2,
    size_t len, size_t jump,
    struct commutative_ring ring
    );

#endif

