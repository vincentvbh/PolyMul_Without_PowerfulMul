
#include "macros.i"
#include "macros_fnt.i"

.syntax unified
.cpu cortex-m3

.align 4
.global __asm_FNT257
.type __asm_FNT257, %function
__asm_FNT257:
    push.w {r4-r12, lr}

    mov.w r14, r2

    .equ width, 4
    .equ jump, 32

#ifdef LOOP
    mov r2, #32
    _0_1_2_loop:
#else
.rept 32
#endif

    ldrstr8 ldr.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, \
        #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width, \
        #4*jump*width, #5*jump*width, #6*jump*width, #7*jump*width

    // 2176
    FNT_CT_butterfly  r4,  r8, 4
    FNT_CT_butterfly  r5,  r9, 4
    FNT_CT_butterfly  r6, r10, 4
    FNT_CT_butterfly  r7, r11, 4

    // 10880
    FNT_CT_butterfly  r4,  r6, 2
    FNT_CT_butterfly  r5,  r7, 2
    // 141440
    FNT_CT_butterfly  r8, r10, 6
    FNT_CT_butterfly  r9, r11, 6

    // 32640
    FNT_CT_butterfly  r4,  r5, 1
    // 359040
    FNT_CT_butterfly  r6,  r7, 5
    // 1272960
    FNT_CT_butterfly  r8,  r9, 3
    // 18245760
    FNT_CT_butterfly r10, r11, 7

    FNT_reduce_hi r10, r12
    FNT_reduce_hi r11, r12

    ldrstr8jump str.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, \
        #1*jump*width, #2*jump*width, #3*jump*width, \
        #4*jump*width, #5*jump*width, #6*jump*width, #7*jump*width, #width

#ifdef LOOP
    subs.w r2, #1
    bne.w _0_1_2_loop
#else
.endr
#endif

    sub.w r0, r0, #32*width
    add.w r1, r1, #7*width

    .equ jump, 8

#ifdef LOOP
    mov.w r2, #8
    _3_4_loop:
#else
.rept 8
#endif

    ldr.w r9, [r1, #1*width]
    ldr.w r10, [r1, #2*width]
    ldr.w r8, [r1], #3*width

#ifdef LOOP
    mov.w r3, #8
    _3_4_inner_loop:
#else
.rept 8
#endif

    ldrstr4 ldr.w, r0, r4, r5, r6, r7, #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width

    mul r6, r6, r8
    mul r7, r7, r8
    add_sub2 r4, r6, r5, r7

    FNT_reduce r4, r12
    FNT_reduce r5, r12
    FNT_reduce r6, r12
    FNT_reduce r7, r12

    mul r5, r5, r9
    mul r7, r7, r10
    add_sub2 r4, r5, r6, r7

    ldrstr4jump str.w, r0, r4, r5, r6, r7, #1*jump*width, #2*jump*width, #3*jump*width, #width

#ifdef LOOP
    subs.w r3, #1
    bne.w _3_4_inner_loop
#else
.endr
#endif

    add.w r0, r0, #(32-8)*width

#ifdef LOOP
    subs.w r2, #1
    bne.w _3_4_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width

    .equ jump, 2

#ifdef LOOP
    mov.w r3, #32
    _5_6_inner_loop:
#else
.rept 32
#endif

    ldr.w r9, [r1, #1*width]
    ldr.w r10, [r1, #2*width]
    ldr.w r8, [r1], #3*width

// ================

    ldrstr4 ldr.w, r0, r4, r5, r6, r7, #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width

    mul r6, r6, r8
    mul r7, r7, r8
    add_sub2 r4, r6, r5, r7

    mul r5, r5, r9
    mul r7, r7, r10
    add_sub2 r4, r5, r6, r7

    FNT_reduce r4, r12
    FNT_reduce r5, r12
    FNT_reduce r6, r12
    FNT_reduce r7, r12

    ldrstr4jump str.w, r0, r4, r5, r6, r7, #1*jump*width, #2*jump*width, #3*jump*width, #width

// ================

    ldrstr4 ldr.w, r0, r4, r5, r6, r7, #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width

    mul r6, r6, r8
    mul r7, r7, r8
    add_sub2 r4, r6, r5, r7

    mul r5, r5, r9
    mul r7, r7, r10
    add_sub2 r4, r5, r6, r7

    FNT_reduce r4, r12
    FNT_reduce r5, r12
    FNT_reduce r6, r12
    FNT_reduce r7, r12

    ldrstr4jump str.w, r0, r4, r5, r6, r7, #1*jump*width, #2*jump*width, #3*jump*width, #(8-2+1)*width

// ================

#ifdef LOOP
    subs.w r3, #1
    bne.w _5_6_inner_loop
#else
.endr
#endif


    pop.w {r4-r12, pc}





