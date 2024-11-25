
#include "small_pack.h"
#include "smallpoly.h"

void unpack_sk_small_t0(uint8_t rho[SEEDBYTES],
                   uint8_t tr[SEEDBYTES],
                   uint8_t key[SEEDBYTES],
                   polyveck* t0,
                   polyvecl *s1,
                   polyveck *s2,
                   const uint8_t sk[CRYPTO_SECRETKEYBYTES])
{
    unsigned int i;

    for (i = 0; i < SEEDBYTES; ++i)
        rho[i] = sk[i];
    sk += SEEDBYTES;

    for (i = 0; i < SEEDBYTES; ++i)
      key[i] = sk[i];
    sk += SEEDBYTES;

    for (i = 0; i < SEEDBYTES; ++i)
      tr[i] = sk[i];
    sk += SEEDBYTES;

    for (i = 0; i < L; ++i){
        polyeta_unpack(&s1->vec[i], sk + i * POLYETA_PACKEDBYTES);
    }
    sk += L * POLYETA_PACKEDBYTES;

    for (i = 0; i < K; ++i) {
        polyeta_unpack(&s2->vec[i], sk + i * POLYETA_PACKEDBYTES);
    }
    sk += K * POLYETA_PACKEDBYTES;

    for (i = 0; i < K; ++i) {
        polyt0_unpack_small(&t0->vec[i], sk + i * POLYT0_PACKEDBYTES);
    }
}
