#ifndef POLY_H
#define POLY_H

#include "SABER_params.h"
#include <stdint.h>

void MatrixVectorMulKeyPairNTT_A(uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]);
void MatrixVectorMulKeyPairNTT_B(uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]);
void MatrixVectorMulKeyPairNTT_D(uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]);

uint32_t MatrixVectorMulEncNTT_A(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare);
uint32_t MatrixVectorMulEncNTT_C(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare);
uint32_t MatrixVectorMulEncNTT_D(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare);

void InnerProdDecNTT(uint8_t m[SABER_KEYBYTES], const uint8_t ciphertext[SABER_BYTES_CCA_DEC], const uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]);
void InnerProdDecNTT_stack(uint8_t m[SABER_KEYBYTES], const uint8_t ciphertext[SABER_BYTES_CCA_DEC], const uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]);

#endif

