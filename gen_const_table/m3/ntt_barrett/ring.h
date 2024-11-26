#ifndef RING_H
#define RING_H

#include <stdint.h>
#include <stddef.h>

#include "tools.h"

extern int32_t mod;

void memberZ(void *des, void *src);
void addZ(void *des, void *src1, void *src2);
void subZ(void *des, void *src1, void *src2);
void mulZ(void *des, void *src1, void *src2);
void expZ(void *des, void *src, size_t e);

extern struct commutative_ring coeff_ring;

#endif