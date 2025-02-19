#ifndef POLYVEC_H
#define POLYVEC_H
#include "params.h"
#include "poly.h"
#include <stdint.h>
#include <stddef.h>

/* Vectors of polynomials of length L */
typedef struct {
    poly vec[L];
} polyvecl;


extern void __asm_InnerProd_L(int32_t*, const int32_t*, const int32_t*);
extern void __asm_InnerProd_L_fast(int32_t*, const int32_t*, const int32_t*);

void polyvecl_uniform_eta(polyvecl *v, const uint8_t seed[CRHBYTES], uint16_t nonce);
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES], uint16_t nonce);

void polyvecl_reduce(polyvecl *v);
void polyvecl_freeze(polyvecl *v);

void polyvecl_add(polyvecl *w, const polyvecl *u, const polyvecl *v);

void polyvecl_ntt(polyvecl *v);
void polyvecl_ntt_fast(polyvecl *v);
void polyvecl_ntt_small(polyvecl *v);

void polyvecl_invntt_tomont(polyvecl *v);
void polyvecl_invntt_tomont_small(polyvecl *v);

void polyvecl_pointwise_poly_montgomery(polyvecl *r, const poly *a, const polyvecl *v);
void polyvecl_pointwise_poly_montgomery_small(polyvecl *r, const poly *a, const polyvecl *v);
void polyvecl_pointwise_acc_montgomery(poly *w, polyvecl *u, polyvecl *v);
void polyvecl_pointwise_acc_montgomery_fast(poly *w, polyvecl *u, polyvecl *v);

int polyvecl_chknorm(const polyvecl *v, int32_t B);



/* Vectors of polynomials of length K */
typedef struct {
    poly vec[K];
} polyveck;

void polyveck_uniform_eta(polyveck *v, const uint8_t seed[CRHBYTES], uint16_t nonce);

void polyveck_reduce(polyveck *v);
void polyveck_caddq(polyveck *v);
void polyveck_freeze(polyveck *v);

void polyveck_add(polyveck *w, const polyveck *u, const polyveck *v);
void polyveck_sub(polyveck *w, const polyveck *u, const polyveck *v);
void polyveck_shiftl(polyveck *v);

void polyveck_ntt(polyveck *v);
void polyveck_ntt_fast(polyveck *v);
void polyveck_ntt_small(polyveck *v);

void polyveck_invntt_tomont(polyveck *v);
void polyveck_invntt_tomont_fast(polyveck *v);
void polyveck_invntt_tomont_small(polyveck *v);

void polyveck_pointwise_poly_montgomery(polyveck *r, const poly *a, const polyveck *v);
void polyveck_pointwise_poly_montgomery_fast(polyveck *r, const poly *a, const polyveck *v);
void polyveck_pointwise_poly_montgomery_small(polyveck *r, const poly *a, const polyveck *v);


int polyveck_chknorm(const polyveck *v, int32_t B);

void polyveck_power2round(polyveck *v1, polyveck *v0, const polyveck *v);
void polyveck_decompose(polyveck *v1, polyveck *v0, const polyveck *v);
unsigned int polyveck_make_hint(polyveck *h,
        const polyveck *v0,
        const polyveck *v1);
void polyveck_use_hint(polyveck *w, const polyveck *u, const polyveck *h);

void polyveck_pack_w1(uint8_t r[K * POLYW1_PACKEDBYTES], const polyveck *w1);

void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES]);
void polyvecl_expand(polyvecl *row, const uint8_t rho[SEEDBYTES], size_t i);

void polyvec_matrix_pointwise_montgomery(polyveck *t, polyvecl mat[K], polyvecl *v);
void polyvec_matrix_pointwise_montgomery_fast(polyveck *t, polyvecl mat[K], polyvecl *v);

#endif
