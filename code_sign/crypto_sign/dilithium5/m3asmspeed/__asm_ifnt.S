
#include "macros.i"
#include "macros_fnt.i"

.syntax unified
.cpu cortex-m3

.align 4
.global __asm_iFNT257
.type __asm_iFNT257, %function
__asm_iFNT257:
    push.w {r4-r12, lr}

    .equ width, 4
    .equ jump, 2

    add.w r1, r1, #(7+24)*width

#ifdef LOOP
    mov.w r2, #32
    _i_5_6_loop:
#else
.rept 32
#endif

    ldr.w r9, [r1, #1*width]
    ldr.w r10, [r1, #2*width]
    ldr.w r8, [r1], #3*width

// ================

    ldrstr4 ldr.w, r0, r4, r5, r6, r7, #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width

    add_sub2 r4, r5, r6, r7
    mul r5, r5, r9
    mul r7, r7, r10

    FNT_reduce_hi r5, r11
    FNT_reduce_hi r7, r11

    add_sub2 r4, r6, r5, r7
    mul r6, r6, r8
    mul r7, r7, r8

    FNT_reduce_hi r6, r11
    FNT_reduce_hi r7, r11

    ldrstr4jump str.w, r0, r4, r5, r6, r7, #1*jump*width, #2*jump*width, #3*jump*width, #width

// ================

    ldrstr4 ldr.w, r0, r4, r5, r6, r7, #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width

    add_sub2 r4, r5, r6, r7
    mul r5, r5, r9
    mul r7, r7, r10

    FNT_reduce_hi r5, r11
    FNT_reduce_hi r7, r11

    add_sub2 r4, r6, r5, r7
    mul r6, r6, r8
    mul r7, r7, r8

    FNT_reduce_hi r6, r11
    FNT_reduce_hi r7, r11

    ldrstr4jump str.w, r0, r4, r5, r6, r7, #1*jump*width, #2*jump*width, #3*jump*width, #(8-2+1)*width

// ================

#ifdef LOOP
    subs.w r2, r2, #1
    bne.w _i_5_6_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width
    sub.w r1, r1, #(96+24)*width

    .equ jump, 8

#ifdef LOOP
    mov.w r2, #8
    _i_3_4_loop:
#else
.rept 8
#endif

    ldr.w r9, [r1, #1*width]
    ldr.w r10, [r1, #2*width]
    ldr.w r8, [r1], #3*width

#ifdef LOOP
    mov.w r3, #8
    _i_3_4_inner_loop:
#else
.rept 8
#endif

    ldrstr4 ldr.w, r0, r4, r5, r6, r7, #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width

    add_sub2 r4, r5, r6, r7
    mul r5, r5, r9
    mul r7, r7, r10

    FNT_reduce_hi r5, r11
    FNT_reduce_hi r7, r11

    add_sub2 r4, r6, r5, r7
    mul r6, r6, r8
    mul r7, r7, r8

    FNT_reduce_hi r6, r11
    FNT_reduce_hi r7, r11

    ldrstr4jump str.w, r0, r4, r5, r6, r7, #1*jump*width, #2*jump*width, #3*jump*width, #width

#ifdef LOOP
    subs.w r3, r3, #1
    bne.w _i_3_4_inner_loop
#else
.endr
#endif

    add.w r0, r0, #(32-8)*width

#ifdef LOOP
    subs.w r2, r2, #1
    bne.w _i_3_4_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width

    .equ jump, 32

    mov.w r3, #257
    mov.w r12, #16711935
    mov.w r14, #127

#ifdef LOOP
    mov.w r2, #32
    _i_0_1_2_loop:
#else
.rept 32
#endif

    ldrstr8 ldr.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, \
        #0*jump*width, #1*jump*width, #2*jump*width, #3*jump*width, \
        #4*jump*width, #5*jump*width, #6*jump*width, #7*jump*width

    add_sub4 r4, r5, r6, r7, r8, r9, r10, r11

    add_sub2 r4, r6, r8, r10
    FNT_reduce_hi r7, r1
    FNT_reduce_hi r11, r1
    FNT_CT_ibutterfly r5, r7, 4
    FNT_CT_ibutterfly r9, r11, 4

    add_sub1 r4, r8
    FNT_reduce_hi r9, r1
    FNT_reduce_hi r10, r1
    FNT_reduce_hi r11, r1
    FNT_CT_ibutterfly r5, r9, 6
    FNT_CT_ibutterfly r6, r10, 4
    FNT_CT_ibutterfly r7, r11, 2

    lsl r4, r4, #1
    lsl r6, r6, #7
    lsl r7, r7, #6
    lsl r8, r8, #5
    lsl r9, r9, #4
    lsl r10, r10, #3
    lsl r11, r11, #2

    FNT_neg_freeze r4, r12, r3, r14
    FNT_neg_freeze r5, r12, r3, r14
    FNT_freeze r6, r12, r3, r14
    FNT_freeze r7, r12, r3, r14
    FNT_freeze r8, r12, r3, r14
    FNT_freeze r9, r12, r3, r14
    FNT_freeze r10, r12, r3, r14
    FNT_freeze r11, r12, r3, r14

    ldrstr8jump str.w, r0, r4, r5, r6, r7, r8, r9, r10, r11, \
        #1*jump*width, #2*jump*width, #3*jump*width, \
        #4*jump*width, #5*jump*width, #6*jump*width, #7*jump*width, #width

#ifdef LOOP
    subs.w r2, r2, #1
    bne.w _i_0_1_2_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}





