
#include "api.h"
#include "hal.h"
#include "randombytes.h"

#include <string.h>

#define NTESTS 10

const uint8_t canary[8] = {
  0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF
};

/* allocate a bit more for all keys and messages and
 * make sure it is not touched by the implementations.
 */
static void write_canary(uint8_t *d) {
  for (size_t i = 0; i < 8; i++) {
    d[i] = canary[i];
  }
}

static int check_canary(const uint8_t *d) {
  for (size_t i = 0; i < 8; i++) {
    if (d[i] != canary[i]) {
      return -1;
    }
  }
  return 0;
}

static int test_keys(void)
{
  unsigned char key_a[CRYPTO_BYTES+16], key_b[CRYPTO_BYTES+16];
  unsigned char pk[CRYPTO_PUBLICKEYBYTES+16];
  unsigned char sendb[CRYPTO_CIPHERTEXTBYTES+16];
  unsigned char sk_a[CRYPTO_SECRETKEYBYTES+16];

  write_canary(key_a); write_canary(key_a+sizeof(key_a)-8);
  write_canary(key_b); write_canary(key_b+sizeof(key_b)-8);
  write_canary(pk); write_canary(pk+sizeof(pk)-8);
  write_canary(sendb); write_canary(sendb+sizeof(sendb)-8);
  write_canary(sk_a); write_canary(sk_a+sizeof(sk_a)-8);


  int i;

  for(i=0; i<NTESTS; i++)
  {
    // Alice generates a public key
    crypto_kem_keypair(pk+8, sk_a+8);
    hal_send_str("DONE key pair generation!");

    // Bob derives a secret key and creates a response
    crypto_kem_enc(sendb+8, key_b+8, pk+8);
    hal_send_str("DONE encapsulation!");

    // Alice uses Bobs response to get her secret key
    crypto_kem_dec(key_a+8, sendb+8, sk_a+8);
    hal_send_str("DONE decapsulation!");

    if(memcmp(key_a+8, key_b+8, CRYPTO_BYTES))
    {
      hal_send_str("ERROR KEYS\n");
    }
    else if(check_canary(key_a) || check_canary(key_a+sizeof(key_a)-8) ||
            check_canary(key_b) || check_canary(key_b+sizeof(key_b)-8) ||
            check_canary(pk) || check_canary(pk+sizeof(pk)-8) ||
            check_canary(sendb) || check_canary(sendb+sizeof(sendb)-8) ||
            check_canary(sk_a) || check_canary(sk_a+sizeof(sk_a)-8))
    {
      hal_send_str("ERROR canary overwritten\n");
    }
    else
    {
      hal_send_str("OK KEYS\n");
    }
  }

  return 0;
}

int main(void)
{
  hal_setup(CLOCK_FAST);

  int i;

  // marker for automated testing
  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }
  test_keys();
  hal_send_str("#");

  return 0;
}

