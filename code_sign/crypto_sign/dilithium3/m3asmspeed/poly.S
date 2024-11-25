
#include "params.h"

#include "macros.i"
#include "reduce.i"

.cpu cortex-m3
.syntax unified

.align 4
.global __asm_poly_reduce
__asm_poly_reduce:
    push {r4-r12, lr}

    movw r1,#:lower16:Q
    movt r1,#:upper16:Q

    add.w r2, r0, #1024
    _reduce_loop:

    ldr.w r4, [r0]
    ldr.w r5, [r0, #1*4]
    ldr.w r6, [r0, #2*4]
    ldr.w r7, [r0, #3*4]
    ldr.w r8, [r0, #4*4]
    ldr.w r9, [r0, #5*4]
    ldr.w r10, [r0, #6*4]
    ldr.w r11, [r0, #7*4]

    reduce_32  r4, r1, r12
    reduce_32  r5, r1, r12
    reduce_32  r6, r1, r12
    reduce_32  r7, r1, r12
    reduce_32  r8, r1, r12
    reduce_32  r9, r1, r12
    reduce_32 r10, r1, r12
    reduce_32 r11, r1, r12

    str.w r5, [r0, #1*4]
    str.w r6, [r0, #2*4]
    str.w r7, [r0, #3*4]
    str.w r8, [r0, #4*4]
    str.w r9, [r0, #5*4]
    str.w r10, [r0, #6*4]
    str.w r11, [r0, #7*4]
    str.w r4, [r0], #8*4

    cmp.w r2, r0
    bne.w _reduce_loop

    pop {r4-r12, pc}

.macro caddq a, q, t
    and     \t, \q, \a, asr #31
    add     \a, \a, \t
.endm

.align 4
.global __asm_poly_caddq
__asm_poly_caddq:
    push {r4-r12, lr}

    movw r1,#:lower16:Q
    movt r1,#:upper16:Q

    add.w r2, r0, #1024
    _caddq_loop:

    ldr.w r4, [r0]
    ldr.w r5, [r0, #1*4]
    ldr.w r6, [r0, #2*4]
    ldr.w r7, [r0, #3*4]
    ldr.w r8, [r0, #4*4]
    ldr.w r9, [r0, #5*4]
    ldr.w r10, [r0, #6*4]
    ldr.w r11, [r0, #7*4]

    caddq  r4, r1, r12
    caddq  r5, r1, r12
    caddq  r6, r1, r12
    caddq  r7, r1, r12
    caddq  r8, r1, r12
    caddq  r9, r1, r12
    caddq r10, r1, r12
    caddq r11, r1, r12

    str.w r5, [r0, #1*4]
    str.w r6, [r0, #2*4]
    str.w r7, [r0, #3*4]
    str.w r8, [r0, #4*4]
    str.w r9, [r0, #5*4]
    str.w r10, [r0, #6*4]
    str.w r11, [r0, #7*4]
    str.w r4, [r0], #8*4

    cmp.w r2, r0
    bne.w _caddq_loop

    pop {r4-r12, pc}

.align 4
.global __asm_poly_add
__asm_poly_add:
    push {r4-r12, lr}

    add.w r3, r0, #1024
    _add_loop:

    ldr.w  r5, [r1, #1*4]
    ldr.w  r6, [r1, #2*4]
    ldr.w  r7, [r1, #3*4]
    ldr.w  r4, [r1], #4*4
    ldr.w  r9, [r2, #1*4]
    ldr.w r10, [r2, #2*4]
    ldr.w r11, [r2, #3*4]
    ldr.w  r8, [r2], #4*4

    add r4, r8
    add r5, r9
    add r6, r10
    add r7, r11

    str.w  r5, [r0, #1*4]
    str.w  r6, [r0, #2*4]
    str.w  r7, [r0, #3*4]
    str.w  r4, [r0], #4*4

    cmp.w r3, r0
    bne.w _add_loop

    pop {r4-r12, pc}

.align 4
.global __asm_poly_sub
__asm_poly_sub:
    push {r4-r12, lr}

    add.w r3, r0, #1024
    _sub_loop:

    ldr.w  r5, [r1, #1*4]
    ldr.w  r6, [r1, #2*4]
    ldr.w  r7, [r1, #3*4]
    ldr.w  r4, [r1], #4*4
    ldr.w  r9, [r2, #1*4]
    ldr.w r10, [r2, #2*4]
    ldr.w r11, [r2, #3*4]
    ldr.w  r8, [r2], #4*4

    sub r4, r8
    sub r5, r9
    sub r6, r10
    sub r7, r11

    str.w  r5, [r0, #1*4]
    str.w  r6, [r0, #2*4]
    str.w  r7, [r0, #3*4]
    str.w  r4, [r0], #4*4

    cmp.w r3, r0
    bne.w _sub_loop

    pop {r4-r12, pc}

    // a1 = (a + (1 << (D - 1)) - 1) >> D;
    // *a0 = a - (a1 << D);

.macro _power2round a1, a0, a

    add.w \a1, \a, #4095
    asr.w \a1, \a1, #13
    sub.w \a0, \a, \a1, lsl #13

.endm

.align 4
.global __asm_poly_power2round
__asm_poly_power2round:
    push {r4-r12, lr}

    add.w r3, r2, #1024
    _power2round_loop:

    ldr.w r4, [r2, #0*4]
    ldr.w r5, [r2, #1*4]

    _power2round r6, r7, r4
    _power2round r8, r9, r5

    str.w r6, [r0, #0*4]
    str.w r7, [r1, #0*4]
    str.w r8, [r0, #1*4]
    str.w r9, [r1, #1*4]

    add.w r2, r2, #2*4
    add.w r0, r0, #2*4
    add.w r1, r1, #2*4

    cmp.w r3, r2
    bne.w _power2round_loop

    pop {r4-r12, pc}

    // Dilithium 2
    // a1  = (a + 127) >> 7;
    // a1  = (a1 * 11275 + (1 << 23)) >> 24;
    // a1 ^= ((43 - a1) >> 31) & a1;

    // *a0  = a - a1 * 2 * GAMMA2;
    // *a0 -= (((Q - 1) / 2 - *a0) >> 31) & Q;

    // Dilithium 3, 5
    // a1  = (a + 127) >> 7;
    // a1  = (a1 * 1025 + (1 << 21)) >> 22;
    // a1 &= 15;

    // *a0  = a - a1 * 2 * GAMMA2;
    // *a0 -= (((Q - 1) / 2 - *a0) >> 31) & Q;

.macro _decompose a1, a0, a, _127, one, _2GAMMA2, _Q, t

#if L == 4

    add.w \a1, \a, \_127
    asr.w \a1, \a1, #7
    mov.w \t, #11275
    mul \a1, \a1, \t
    add.w \a1, \one, \a1, asr #23
    asr.w \a1, \a1, #1
    rsb.w \t, \a1, #43
    and.w \t, \a1, \t, asr #31
    eor.w \a1, \a1, \t

    mul \a0, \a1, \_2GAMMA2
    sub.w \a0, \a, \a0
    rsb.w \t, \a0, \_Q, asr #1
    and.w \t, \_Q, \t, asr #31
    sub.w \a0, \a0, \t

#else

    add.w \a1, \a, \_127
    asr.w \a1, \a1, #7
    add.w \a1, \a1, \a1, lsl #10
    add.w \a1, \one, \a1, asr #21
    ubfx \a1, \a1, #1, #4

    mul \a0, \a1, \_2GAMMA2
    sub.w \a0, \a, \a0
    rsb.w \t, \a0, \_Q, asr #1
    and.w \t, \_Q, \t, asr #31
    sub.w \a0, \a0, \t

#endif

.endm

.align 4
.global __asm_poly_decompose
__asm_poly_decompose:
    push {r4-r12, lr}

    mov.w r9, #1
    rsb.w r8, r9, r9, lsl #7
    movw r10, #:lower16:GAMMA2
    movt r10, #:upper16:GAMMA2
    lsl.w r10, r10, #1
    movw r11, #:lower16:Q
    movt r11, #:upper16:Q

    add.w r3, r2, #1024
    _decompose_loop:

    ldr.w r4, [r2, #0*4]
    ldr.w r5, [r2, #1*4]

    _decompose r6, r7, r4, r8, r9, r10, r11, r12

    str.w r6, [r0, #0*4]
    str.w r7, [r1, #0*4]

    _decompose r6, r7, r5, r8, r9, r10, r11, r12

    str.w r6, [r0, #1*4]
    str.w r7, [r1, #1*4]

    add.w r2, r2, #2*4
    add.w r0, r0, #2*4
    add.w r1, r1, #2*4

    cmp.w r3, r2
    bne.w _decompose_loop

    pop {r4-r12, pc}

.align 4
.global __asm_poly_chknorm
__asm_poly_chknorm:
    push.w {lr}

    movw r2, #:lower16:Q
    movt r2, #:upper16:Q
    asr.w r2, r2, #3

    cmp r1, r2
    it gt
    bgt _out_of_bound

    add.w r3, r0, #1024
    _poly_chknorm_loop:

    ldr.w r2, [r0]

    and.w r12, r2, r2, asr #31
    sub.w r2, r2, r12, lsl #1

    cmp r2, r1
    it ge
    bge _out_of_bound

    add.w r0, r0, #4

    cmp.w r3, r0
    bne.w _poly_chknorm_loop

    mov.w r0, #0
    pop.w {pc}

    _out_of_bound:
    mov.w r0, #1
    pop.w {pc}






