#include <stdio.h>
#include <stdint.h>
#include "api.h"


int main()
{
    int ret = 0;

    uint8_t pk[CRYPTO_PUBLICKEYBYTES] = {0};
    uint8_t sk[CRYPTO_SECRETKEYBYTES] = {0};
    uint8_t ss[CRYPTO_BYTES] = {0};
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES] = {0};
    uint8_t re_ss[CRYPTO_BYTES] = {0};

    crypto_kem_keypair(pk, sk);
    crypto_kem_enc(ct, ss, pk);
    crypto_kem_dec(re_ss, ct, sk);
    
    return 0;
}