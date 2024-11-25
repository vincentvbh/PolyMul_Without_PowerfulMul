

#include <stdint.h>
#include <stdio.h>

#include "hal.h"

#include "NTT_params.h"
#include "ring.h"


uint64_t oldcount, newcount;
char out[128];

#define ITERATIONS 10000

#define II_K 4
#define II_L 4

// #define III_K 6
// #define III_L 5

#define V_K 8
#define V_L 7


static
int32_t buff[NTT_N];

extern
void __asm_FNT257(int32_t*, int32_t*);

extern
void __asm_basemul257(int32_t*, int32_t*, int32_t*, int32_t*);

extern
void __asm_iFNT257(int32_t*, int32_t*);

// ================

int main(void){

    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");

    int32_t res[ARRAY_N];
    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t c[ARRAY_N];
    int32_t s2[V_K][ARRAY_N];
    int32_t cs2[V_K][ARRAY_N];

    hal_send_str("\n============ FNT benchmark ============\n");

    hal_send_str("\n============ Assembly benchmark ============\n");

    oldcount = hal_get_time();
    __asm_FNT257(poly1, buff);
    newcount = hal_get_time();
    sprintf(out, "__asm_FNT257 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_basemul257(res, poly1, poly2, buff);
    newcount = hal_get_time();
    sprintf(out, "__asm_basemul257 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iFNT257(poly1, buff);
    newcount = hal_get_time();
    sprintf(out, "__asm_iFNT257 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    hal_send_str("\n============ Table 14 numbers ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < II_L; i++){
        __asm_basemul257((int32_t*)&cs2[i][0], (int32_t*)&s2[i][0], c, buff);
    }
    for(size_t i = 0; i < II_L; i++){
        __asm_iFNT257((int32_t*)&cs2[i][0], buff);
    }
    newcount = hal_get_time();
    sprintf(out, "Dilithium II c s2 FNT rejection loop cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < II_K; i++){
        __asm_basemul257((int32_t*)&cs2[i][0], (int32_t*)&s2[i][0], c, buff);
    }
    for(size_t i = 0; i < II_K; i++){
        __asm_iFNT257((int32_t*)&cs2[i][0], buff);
    }
    newcount = hal_get_time();
    sprintf(out, "Dilithium II c s2 FNT rejection loop cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < V_L; i++){
        __asm_basemul257((int32_t*)&cs2[i][0], (int32_t*)&s2[i][0], c, buff);
    }
    for(size_t i = 0; i < V_L; i++){
        __asm_iFNT257((int32_t*)&cs2[i][0], buff);
    }
    newcount = hal_get_time();
    sprintf(out, "Dilithium V c s2 FNT rejection loop cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < V_K; i++){
        __asm_basemul257((int32_t*)&cs2[i][0], (int32_t*)&s2[i][0], c, buff);
    }
    for(size_t i = 0; i < V_K; i++){
        __asm_iFNT257((int32_t*)&cs2[i][0], buff);
    }
    newcount = hal_get_time();
    sprintf(out, "Dilithium V c s2 FNT rejection loop cycles: %lld", newcount - oldcount);
    hal_send_str(out);

}













