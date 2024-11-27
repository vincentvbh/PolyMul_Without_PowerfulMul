#include "api.h"
#include "sign.h"
#include "hal.h"
#include "sendfn.h"
#include "randombytes.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#ifndef ITERATIONS
#define ITERATIONS 100
#endif

#define MLEN 59

#define printcycles(S, U) send_unsignedll((S), (U))

char out[128];

int main(void)
{
  unsigned char sk[CRYPTO_SECRETKEYBYTES];
  unsigned char pk[CRYPTO_PUBLICKEYBYTES];
  unsigned char sm[MLEN+CRYPTO_BYTES];
  size_t smlen;
  unsigned long long t0, t1;
  int i;

  hal_setup(CLOCK_BENCHMARK);

  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }

  init_randombytes();

  for(i=0;i<ITERATIONS; i++)
  {
    // Key-pair generation
    t0 = hal_get_time();
    crypto_sign_keypair(pk, sk);
    t1 = hal_get_time();
    printcycles("keypair cycles:", t1-t0);

    // Signing
    t0 = hal_get_time();
    crypto_sign(sm, &smlen, sm, MLEN, sk);
    t1 = hal_get_time();
    printcycles("sign cycles:", t1-t0);

    // Verification
    t0 = hal_get_time();
    crypto_sign_open(sm, &smlen, sm, smlen, pk);
    t1 = hal_get_time();
    printcycles("verify cycles:", t1-t0);

    hal_send_str("+");
  }
  hal_send_str("#\n");
  return 0;
}
