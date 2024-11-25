
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"
#include "ring.h"
#include "MV.h"
#include "Hom.h"

#include "hal.h"

char out[128];

int main(void){

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t poly_Hom_M[32][7][8];
    int32_t poly_Hom_V[32][7][4];
    int32_t res_MV[32][7][4];
    int32_t ref[ARRAY_N], res[ARRAY_N];

    int32_t twiddle, t;

    hal_setup(CLOCK_FAST);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");


    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        cmod_int32(poly1 + i, &t, &mod);
        t = rand();
        cmod_int32(poly2 + i, &t, &mod);
    }

    twiddle = -1;
    naive_mulR(ref, poly1, poly2, ARRAY_N, &twiddle, coeff_ring);
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(ref + i, ref + i, &mod);
    }

    Hom_M((int32_t*)&poly_Hom_M[0][0][0], poly2);
    Hom_V((int32_t*)&poly_Hom_V[0][0][0], poly1);
    __asm_TMVP_mul_4x4_full((int32_t*)&res_MV[0][0][0], (int32_t*)&poly_Hom_M[0][0][0], (int32_t*)&poly_Hom_V[0][0][0]);
    Hom_I(res, (int32_t*)&res_MV[0][0][0]);

    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(res + i, res + i, &mod);
    }

    for(size_t i = 0; i < ARRAY_N; i++){
        if(ref[i] != res[i]){
            sprintf(out, "%4zu: %12lx, %12lx\n", i, ref[i], res[i]);
            hal_send_str(out);
        }
    }

    hal_send_str("Test finished!\n");

}









