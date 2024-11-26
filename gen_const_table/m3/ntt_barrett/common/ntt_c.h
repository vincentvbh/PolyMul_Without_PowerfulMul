
#ifndef NTT_C_H
#define NTT_C_H

#include "tools.h"

// ================================
// Cooley-Tukey butterfly

void CT_butterfly(
    void *src,
    size_t indx_a, size_t indx_b,
    void *twiddle,
    struct commutative_ring ring
    );

// ================================
// multi-layer Cooley-Tukey butterfly for the forward transformation

void m_layer_CT_butterfly(
    void *src,
    size_t layers, size_t step,
    void *_root_table,
    struct commutative_ring ring
    );

// ================================
// multi-layer Cooley-Tukey butterfly for the inverse transformation

void m_layer_CT_ibutterfly(
    void *src,
    size_t layers, size_t step,
    void *_root_table,
    struct commutative_ring ring
    );

void m_layer_GS_ibutterfly(
    void *src,
    size_t layers, size_t step,
    void *_root_table,
    struct commutative_ring ring
    );

// ================================
// NTT with Cooley-Tukey butterfly
// we must use m_layer_CT_butterfly here

void compressed_CT_NTT(
    void *src,
    size_t start_level, size_t end_level,
    void *_root_table,
    struct compress_profile _profile,
    struct commutative_ring ring
    );

// ================================
// iNTT with Cooley-Tukey butterfly
// we must use m_layer_CT_ibutterfly here

void compressed_CT_iNTT(
    void *src,
    size_t start_level, size_t end_level,
    void *_root_table,
    struct compress_profile _profile,
    struct commutative_ring ring
    );

void compressed_GS_NTT(
    void *src,
    size_t start_level, size_t end_level,
    void *_root_table,
    struct compress_profile _profile,
    struct commutative_ring ring
    );

#endif




