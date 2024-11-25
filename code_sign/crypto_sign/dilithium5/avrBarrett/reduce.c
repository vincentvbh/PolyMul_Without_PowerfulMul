#include "params.h"
#include "reduce.h"
#include <stdint.h>

/*************************************************
* Name:        montgomery_reduce
*
* Description: For finite field element a with -2^{31}Q <= a <= Q*2^31,
*              compute r \equiv a*2^{-32} (mod Q) such that -Q < r < Q.
*
* Arguments:   - int64_t: finite field element a
*
* Returns r.
**************************************************/
int32_t montgomery_reduce(int64_t a) {
    int32_t t;

    t = (int32_t)((uint64_t)a * (uint64_t)QINV);
    t = (a - (int64_t)t * Q) >> 32;
    return t;
}

/*************************************************
* Name:        reduce32
*
* Description: For finite field element a with a <= 2^{31} - 2^{22} - 1,
*              compute r \equiv a (mod Q) such that -6283009 <= r <= 6283007.
*
* Arguments:   - int32_t: finite field element a
*
* Returns r.
**************************************************/
int32_t reduce32(int32_t a) {
    int32_t t;

    t = (a + (1ULL << 22)) >> 23;
    t = a - t * Q;
    return t;
}

/*************************************************
* Name:        caddq
*
* Description: Add Q if input coefficient is negative.
*
* Arguments:   - int32_t: finite field element a
*
* Returns r.
**************************************************/
int32_t caddq(int32_t a) 
{
    volatile int32_t tmp;
    tmp = a >> 31;
    tmp &= Q;
    a += tmp;
    return a;
}

/*************************************************
* Name:        freeze
*
* Description: For finite field element a, compute standard
*              representative r = a mod^+ Q.
*
* Arguments:   - int32_t: finite field element a
*
* Returns r.
**************************************************/
int32_t freeze(int32_t a) {
    a = reduce32(a);
    a = caddq(a);
    return a;
}

int32_t freeze_32(int32_t a)
{
    volatile int32_t t = (a + (1ULL << 22)) >> 23;
    a -= t * Q;
    
    //if(a>= Q/2) a-=Q;
    a -= (0 - (1 ^  (a^((a^(a-Q/2))&(Q/2^(a-Q/2))))>>31)) & Q;
    //if(a<= -Q/2) a+=Q;
    a += (0 - (1 ^ (-Q/2^((-Q/2^(-Q/2-a))&(a^(-Q/2-a))))>>31)) & Q;

    return a;
}