
#include <memory.h>

#include "NTT_params.h"
#include "ring.h"

int32_t mod = Q;

void memberZ(void *des, void *src){
    cmod_int32(des, src, &mod);
}

void addZ(void *des, void *src1, void *src2){
    addmod_int32(des, src1, src2, &mod);
}

void subZ(void *des, void *src1, void *src2){
    submod_int32(des, src1, src2, &mod);
}

void mulZ(void *des, void *src1, void *src2){
    mulmod_int32(des, src1, src2, &mod);
}

void expZ(void *des, void *src, size_t e){
    expmod_int32(des, src, e, &mod);
}

struct commutative_ring coeff_ring = {
    .sizeZ = sizeof(int32_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};


