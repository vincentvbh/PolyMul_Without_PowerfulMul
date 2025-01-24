/* Deterministic randombytes by Daniel J. Bernstein */
/* taken from SUPERCOP (https://bench.cr.yp.to)     */

#include "api.h"
#include "randombytes.h"
#include "hal.h"

#include <stdio.h>
#include <string.h>
#include <stdint.h>

#define MAXMLEN 256

typedef uint32_t uint32;

static void printbytes(const unsigned char *x, unsigned long long xlen)
{
  char outs[2*xlen+1];
  unsigned long long i;
  for(i=0;i<xlen;i++)
    sprintf(outs+2*i, "%02x", x[i]);
  outs[2*xlen] = 0;
  hal_send_str(outs);
}

int main(void)
{
  unsigned char sk[CRYPTO_SECRETKEYBYTES];
  unsigned char pk[CRYPTO_PUBLICKEYBYTES];

  unsigned char mi[MAXMLEN];
  unsigned char sm[MAXMLEN+CRYPTO_BYTES];
  size_t smlen;
  size_t mlen;

  int r;
  size_t i,j;

  hal_setup(CLOCK_FAST);

  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }

  for(i=(MAXMLEN>>1); i<MAXMLEN; i=(i==0)?i+1:i<<1)
  {
    randombytes(mi,i);

    crypto_sign_keypair(pk, sk);

    printbytes(pk,CRYPTO_PUBLICKEYBYTES);
    printbytes(sk,CRYPTO_SECRETKEYBYTES);

    crypto_sign(sm, &smlen, mi, i, sk);

    printbytes(sm, smlen);

    // By relying on m == sm we prevent having to allocate CRYPTO_BYTES twice
    r = crypto_sign_open(sm, &mlen, sm, smlen, pk);

    if(r)
    {
      hal_send_str("ERROR: signature verification failed");
      hal_send_str("#");
      return -1;
    }
    for(j=0;j<i;j++)
    {
      if(sm[j]!=mi[j])
      {
        hal_send_str("ERROR: message recovery failed");
        hal_send_str("#");
        return -1;
      }
    }
  }

  hal_send_str("#\n");
  return 0;
}
