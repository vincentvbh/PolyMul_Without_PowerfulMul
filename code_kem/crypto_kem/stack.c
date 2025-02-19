
#include "api.h"
#include "hal.h"
#include "sendfn.h"
#include "randombytes.h"

#include <string.h>

#ifndef MAX_STACK_SIZE
#define MAX_STACK_SIZE hal_get_stack_size()
#endif

#ifndef STACK_SIZE_INCR
#define STACK_SIZE_INCR 0x1000
#endif

#define send_stack_usage(S, U) send_unsigned((S), (U))

unsigned int canary_size;
volatile unsigned char *p;
unsigned int c;
uint8_t canary = 0x42;

unsigned char key_a[CRYPTO_BYTES], key_b[CRYPTO_BYTES];
unsigned char pk[CRYPTO_PUBLICKEYBYTES];
unsigned char sendb[CRYPTO_CIPHERTEXTBYTES];
unsigned char sk_a[CRYPTO_SECRETKEYBYTES];
unsigned int stack_key_gen, stack_encaps, stack_decaps;

#define FILL_STACK()                                                           \
  p = &a;                                                                      \
  while (p > &a - canary_size)                                                 \
    *(p--) = canary;
#define CHECK_STACK()                                                          \
  c = canary_size;                                                             \
  p = &a - canary_size + 1;                                                    \
  while (*p == canary && p < &a) {                                             \
    p++;                                                                       \
    c--;                                                                       \
  }

static int test_keys(void) {
  volatile unsigned char a;
  // Alice generates a public key
  FILL_STACK()
  crypto_kem_keypair(pk, sk_a);
  CHECK_STACK()
  if(c >= canary_size) return -1;
  stack_key_gen = c;

  // Bob derives a secret key and creates a response
  FILL_STACK()
  crypto_kem_enc(sendb, key_b, pk);
  CHECK_STACK()
  if(c >= canary_size) return -1;
  stack_encaps = c;

  // Alice uses Bobs response to get her secret key
  FILL_STACK()
  crypto_kem_dec(key_a, sendb, sk_a);
  CHECK_STACK()
  if(c >= canary_size) return -1;
  stack_decaps = c;

  if (memcmp(key_a, key_b, CRYPTO_BYTES)){
    return -1;
  } else {
    send_stack_usage("keypair stack usage:", stack_key_gen);
    send_stack_usage("encaps stack usage:", stack_encaps);
    send_stack_usage("decaps stack usage:", stack_decaps);
    hal_send_str("OK KEYS\n");
    hal_send_str("#\n");
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
  while(test_keys()){
    canary_size += STACK_SIZE_INCR;
    if(canary_size >= MAX_STACK_SIZE) {
      hal_send_str("failed to measure stack usage.\n");
      break;
    }
  }
  // marker for automated benchmarks
  hal_send_str("#\n");

  return 0;
}
