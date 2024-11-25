#ifndef PACKING_H
#define PACKING_H
#include "params.h"
#include "polyvec.h"
#include <stdint.h>

void pack_pk(uint8_t pk[CRYPTO_PUBLICKEYBYTES], const uint8_t rho[SEEDBYTES], const polyveck *t1);

void pack_sk(uint8_t sk[CRYPTO_SECRETKEYBYTES],
                                      const uint8_t rho[SEEDBYTES],
                                      const uint8_t tr[SEEDBYTES],
                                      const uint8_t key[SEEDBYTES],
                                      const polyveck *t0,
                                      const polyvecl *s1,
                                      const polyveck *s2);

void pack_sk_rho_tr_key(uint8_t sk[CRYPTO_SECRETKEYBYTES],
                                      const uint8_t rho[SEEDBYTES],
                                      const uint8_t tr[SEEDBYTES],
                                      const uint8_t key[SEEDBYTES]);

void pack_sk_t0_s1_s2(uint8_t sk[CRYPTO_SECRETKEYBYTES],
                                      const polyveck *t0,
                                      const polyvecl *s1,
                                      const polyveck *s2);

void pack_sig(uint8_t sig[CRYPTO_BYTES], const uint8_t c[SEEDBYTES], const polyvecl *z, const polyveck *h);

void pack_sig_setup(uint8_t sig[CRYPTO_BYTES], const uint8_t c[SEEDBYTES]);

void pack_sig_z(uint8_t *sig, polyvecl *z);

void pack_sig_h(uint8_t *sig, polyveck *h);

void unpack_pk(uint8_t rho[SEEDBYTES], polyveck *t1, const uint8_t pk[CRYPTO_PUBLICKEYBYTES]);

void unpack_pk_rho(uint8_t rho[SEEDBYTES], const uint8_t pk[CRYPTO_PUBLICKEYBYTES]);

void unpack_pk_t1(polyveck *t1, const uint8_t pk[CRYPTO_PUBLICKEYBYTES]);

void unpack_sk(uint8_t rho[SEEDBYTES], uint8_t tr[SEEDBYTES], uint8_t key[SEEDBYTES],
                                        polyveck *t0,
                                        polyvecl *s1,
                                        polyveck *s2,
                                        const uint8_t sk[CRYPTO_SECRETKEYBYTES]);
void unpack_sk_rho_tr_key(uint8_t rho[SEEDBYTES], uint8_t tr[SEEDBYTES], uint8_t key[SEEDBYTES],
                                        const uint8_t sk[CRYPTO_SECRETKEYBYTES]);

void unpack_sk_s1_s2_t0(polyvecl *s1, polyveck *s2, polyveck *t0,
                                        const uint8_t sk[CRYPTO_SECRETKEYBYTES]);

int unpack_sig(uint8_t c[SEEDBYTES], polyvecl *z, polyveck *h, const uint8_t sig[CRYPTO_BYTES]);

void unpack_sig_c_z(uint8_t c[SEEDBYTES], polyvecl *z, const uint8_t sig[CRYPTO_BYTES]);

int unpack_sig_h(polyveck *h, const uint8_t sig[CRYPTO_BYTES]);

#endif
