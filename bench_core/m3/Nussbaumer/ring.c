
#include <memory.h>

#include "ring.h"
#include "naive_mult.h"

int32_t mod = Q;

void memberZ(void *des, void *src){
    *(int32_t*)des = *(int32_t*)src;
}

void addZ(void *des, void *src1, void *src2){
    *(int32_t*)des = (*(int32_t*)src1) + (*(int32_t*)src2);
}

void subZ(void *des, void *src1, void *src2){
    *(int32_t*)des = (*(int32_t*)src1) - (*(int32_t*)src2);
}

void mulZ(void *des, void *src1, void *src2){
    *(int32_t*)des = (*(int32_t*)src1) * (*(int32_t*)src2);
}

void expZ(void *des, void *src, size_t e){

    int32_t src_v = *(int32_t*)src;
    int32_t tmp_v;

    tmp_v = 1;
    for(; e; e >>= 1){
        if(e & 1){
            tmp_v = tmp_v * src_v;
        }
        src_v = src_v * src_v;
    }

    memmove(des, &tmp_v, sizeof(int32_t));
}

struct commutative_ring coeff_ring = {
    .sizeZ = sizeof(int32_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};

void memberZ_negacyclic(void *des, void *src){
    for(size_t i = 0; i < INNER_N; i++){
        coeff_ring.memberZ(des + i * COEFF_SIZE, src + i * COEFF_SIZE);
    }
}

void addZ_negacyclic(void *des, void *src1, void *src2){
    for(size_t i = 0; i < INNER_N; i++){
        coeff_ring.addZ(des + i * COEFF_SIZE, src1 + i * COEFF_SIZE, src2 + i * COEFF_SIZE);
    }
}

void subZ_negacyclic(void *des, void *src1, void *src2){
    for(size_t i = 0; i < INNER_N; i++){
        coeff_ring.subZ(des + i * COEFF_SIZE, src1 + i * COEFF_SIZE, src2 + i * COEFF_SIZE);
    }
}

void mulZ_negacyclic(void *des, void *src1, void *src2){
    int32_t twiddle = -1;
    naive_mulR(des, src1, src2, INNER_N, &twiddle, coeff_ring);
}

void expZ_negacyclic(void *des, void *src, size_t e){

    int32_t src_v[INNER_N];
    int32_t tmp_v[INNER_N];
    int32_t twiddle = -1;

    memmove(src_v, src, INNER_N * coeff_ring.sizeZ);

    memset(tmp_v, 0, INNER_N * coeff_ring.sizeZ);
    tmp_v[0] = 1;

    for(; e; e >>= 1){
        if(e & 1){
            naive_mulR(tmp_v, tmp_v, src_v, INNER_N, &twiddle, coeff_ring);
        }
        naive_mulR(src_v, src_v, src_v, INNER_N, &twiddle, coeff_ring);
    }

    memmove(des, tmp_v, INNER_N * coeff_ring.sizeZ);
}

struct commutative_ring negacyclic_ring = {
    .sizeZ = COEFF_SIZE * INNER_N,
    .memberZ = memberZ_negacyclic,
    .addZ = addZ_negacyclic,
    .subZ = subZ_negacyclic,
    .mulZ = mulZ_negacyclic,
    .expZ = expZ_negacyclic
};




