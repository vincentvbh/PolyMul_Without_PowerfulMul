#include "randombytes.h"

int randombytes(uint8_t *buf, size_t n)
{
  for(uint8_t cnt_i = 0 ; cnt_i < n ; cnt_i ++)
  {
    buf[cnt_i] = cnt_i;
  }
  
  return n;
}