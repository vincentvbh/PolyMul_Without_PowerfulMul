#ifndef RANDOMBYTES_H
#define RANDOMBYTES_H
#include <stdint.h>

#ifdef _WIN32
#include <CRTDEFS.H>
#else
#include <unistd.h>
#endif

void init_randombytes();
int randombytes(uint8_t *buf, size_t n);

#endif
