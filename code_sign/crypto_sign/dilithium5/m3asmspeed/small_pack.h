#ifndef SMALL_PACK_H
#define SMALL_PACK_H

#include "polyvec.h"
#include "smallpoly.h"
#include "params.h"

#include <stdint.h>

void unpack_sk_small_t0(uint8_t rho[SEEDBYTES],
                   uint8_t tr[SEEDBYTES],
                   uint8_t key[SEEDBYTES],
                   polyveck* t0,
                   polyvecl *s1,
                   polyveck *s2,
                   const uint8_t sk[CRYPTO_SECRETKEYBYTES]);

#endif

