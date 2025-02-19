
#ifndef TOOLS_H
#define TOOLS_H

#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

struct compress_profile{
    size_t array_n;
    size_t ntt_n;
    size_t log_ntt_n;
    size_t compressed_layers;
    size_t merged_layers[16];
};

struct commutative_ring{
    size_t sizeZ;
    void (*memberZ)(void*, void*);
    void (*addZ)(void*, void*, void*);
    void (*subZ)(void*, void*, void*);
    void (*mulZ)(void*, void*, void*);
    void (*expZ)(void*, void*, size_t);
    size_t modQ;
};

// ================================
// reducing elements to *mod

void cmod_int16(void *des, void *src, void *mod);
void cmod_int32(void *des, void *src, void *mod);
void cmod_int64(void *des, void *src, void *mod);

// ================================
// addition in *mod

void addmod_int16(void *des, void *src1, void *src2, void *mod);
void addmod_int32(void *des, void *src1, void *src2, void *mod);

// ================================
// subtraction in *mod

void submod_int16(void *des, void *src1, void *src2, void *mod);
void submod_int32(void *des, void *src1, void *src2, void *mod);

// ================================
// multiplication in *mod

void mulmod_int16(void *des, void *src1, void *src2, void *mod);
void mulmod_int32(void *des, void *src1, void *src2, void *mod);

// ================================
// exponentiation in *mod

void expmod_int16(void *des, void *src, size_t e, void *mod);
void expmod_int32(void *des, void *src, size_t e, void *mod);

// ================================
// in-place bit-reversing the array

void bitreverse(void *src, size_t len, size_t size);

#endif

