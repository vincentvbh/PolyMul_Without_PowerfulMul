#ifndef RING_H
#define RING_H

#include <stdint.h>
#include <stddef.h>

#include "tools.h"


#define ARRAY_N 256
#define INNER_N 16

#define Q (1 << 19)
extern int32_t mod;

void memberZ(void *des, void *src);
void addZ(void *des, void *src1, void *src2);
void subZ(void *des, void *src1, void *src2);
void mulZ(void *des, void *src1, void *src2);
void expZ(void *des, void *src, size_t e);

#define COEFF_SIZE (sizeof(int32_t))

extern struct commutative_ring coeff_ring;

void memberZ_negacyclic(void *des, void *src);
void addZ_negacyclic(void *des, void *src1, void *src2);
void subZ_negacyclic(void *des, void *src1, void *src2);
void mulZ_negacyclic(void *des, void *src1, void *src2);
void expZ_negacyclic(void *des, void *src, size_t e);

extern struct commutative_ring negacyclic_ring;

#endif


