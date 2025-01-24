
#include "api.h"
#include "hal.h"
#include "sendfn.h"
#include "randombytes.h"

#include <stdio.h>
#include <string.h>

#ifndef MAX_STACK_SIZE
#define MAX_STACK_SIZE hal_get_stack_size()
#endif

#ifndef STACK_SIZE_INCR
#define STACK_SIZE_INCR 0x1000
#endif

#define MLEN 32

#define send_stack_usage(S, U) send_unsigned((S), (U))

unsigned int canary_size;
volatile unsigned char *p;
unsigned int c;
uint8_t canary = 0x42;

unsigned char pk[CRYPTO_PUBLICKEYBYTES];
unsigned char sk[CRYPTO_SECRETKEYBYTES];
unsigned char sm[MLEN + CRYPTO_BYTES];
unsigned char m[MLEN];

size_t mlen;
size_t smlen;
unsigned int rc;
unsigned int stack_key_gen, stack_sign, stack_verify;

#define FILL_STACK()                                                           \
  p = &a;                                                                      \
  while (p > &a - canary_size)                                                    \
    *(p--) = canary;
#define CHECK_STACK()                                                         \
  c = canary_size;                                                                \
  p = &a - canary_size + 1;                                                       \
  while (*p == canary && p < &a) {                                             \
    p++;                                                                       \
    c--;                                                                       \
  }                                                                            \

static int test_sign(void) {
  volatile unsigned char a;
  // Alice generates a public key
  FILL_STACK()
  crypto_sign_keypair(pk, sk);
  CHECK_STACK()
  if(c >= canary_size) return -1;
  stack_key_gen = c;

  // Bob derives a secret key and creates a response
  randombytes(m, MLEN);
  FILL_STACK()
  crypto_sign(sm, &smlen, m, MLEN, sk);
  CHECK_STACK()
  if(c >= canary_size) return -1;
  stack_sign = c;

  // Alice uses Bobs response to get her secret key
  FILL_STACK()
  rc = crypto_sign_open(sm, &mlen, sm, smlen, pk);
  CHECK_STACK()
  if(c >= canary_size) return -1;
  stack_verify = c;

  if (rc) {
    hal_send_str("ERROR signature verification!\n");
    return -1;
  } else {
    send_stack_usage("keypair stack usage:", stack_key_gen);
    send_stack_usage("sign stack usage:", stack_sign);
    send_stack_usage("verify stack usage:", stack_verify);
    hal_send_str("Signature valid!\n");
    return 0;
  }
}

int main(void) {
  hal_setup(CLOCK_FAST);

  int i;

  // marker for automated benchmarks
  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }
  canary_size = STACK_SIZE_INCR;
  while(test_sign()){
    if(canary_size == MAX_STACK_SIZE) {
      hal_send_str("ERROR failed to measure stack usage.\n");
      break;
    }
    canary_size += STACK_SIZE_INCR;
    if(canary_size >= MAX_STACK_SIZE) {
      canary_size = MAX_STACK_SIZE;
    }
  }

  // marker for automated benchmarks
  hal_send_str("#\n");

  return 0;
}
