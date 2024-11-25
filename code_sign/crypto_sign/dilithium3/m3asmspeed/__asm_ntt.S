
#include "macros.i"
#include "mulmod.i"
#include "butterflies.i"
#include "reduce.i"

.cpu cortex-m3
.syntax unified

.align 4
.global __asm_NTT
__asm_NTT:

    push {r4-r12, lr}
    sub.w sp, sp, #16

    .equ width, 4

    .equ jump, 128

    ldr.w r2, [r2, #4]

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}


#ifdef LOOP
    add.w r1, r0, #128*width
    _0_loop:
#else
.rept 64
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _0_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-128)*width


// 1

    .equ jump, 64

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #64*width
    _1_0_loop:
#else
.rept 32
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _1_0_loop
#else
.endr
#endif

    add.w r0, r0, #64*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #64*width
    _1_1_loop:
#else
.rept 32
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _1_1_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-64)*width

// 2

    .equ jump, 32

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #32*width
    _2_0_loop:
#else
.rept 16
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _2_0_loop
#else
.endr
#endif

    add.w r0, r0, #32*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #32*width
    _2_1_loop:
#else
.rept 16
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _2_1_loop
#else
.endr
#endif

    add.w r0, r0, #32*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #32*width
    _2_2_loop:
#else
.rept 16
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _2_2_loop
#else
.endr
#endif

    add.w r0, r0, #32*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #32*width
    _2_3_loop:
#else
.rept 16
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _2_3_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-32)*width

// 3

    .equ jump, 16

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_0_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_0_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_1_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_1_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_2_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_2_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_3_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_3_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_4_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_4_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_5_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_5_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_6_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_6_loop
#else
.endr
#endif

    add.w r0, r0, #16*width

    pop.w {r1}
    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8
    push.w {r1}

#ifdef LOOP
    add.w r1, r0, #16*width
    _3_7_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #(jump+0)*width]
    ldr.w r7, [r0, #(jump+1)*width]

    butterfly r4, r6, r8, r9, r10, r2, r3, r11, r12, r14
    butterfly r5, r7, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #1*width]
    str.w r6, [r0, #(jump+0)*width]
    str.w r7, [r0, #(jump+1)*width]
    str.w r4, [r0], #2*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _3_7_loop
#else
.endr
#endif

    add.w r0, r0, #16*width
    pop.w {r1}


    sub.w r0, r0, #256*width

// 4

    .equ jump, 8

#ifdef LOOP
    add.w r6, r0, 256*width
    _4_loop:
#else
.rept 16
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

#ifdef LOOP
    add.w r7, r0, #8*width
    _4_inner_loop:
#else
.rept 2
#endif


    ldr.w r4, [r0, #1*width]
    ldr.w r5, [r0, #(1+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(1+jump)*width]
    str.w r4, [r0, #1*width]

    ldr.w r4, [r0, #2*width]
    ldr.w r5, [r0, #(2+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(2+jump)*width]
    str.w r4, [r0, #2*width]

    ldr.w r4, [r0, #3*width]
    ldr.w r5, [r0, #(3+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(3+jump)*width]
    str.w r4, [r0, #3*width]

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #(0+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(0+jump)*width]
    str.w r4, [r0], #4*width

#ifdef LOOP
    cmp.w r0, r7
    bne.w _4_inner_loop
#else
.endr
#endif

    add.w r0, r0, #8*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _4_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width

// 5

    .equ jump, 4

#ifdef LOOP
    add.w r6, r0, #256*width
    _5_loop:
#else
.rept 32
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

    ldr.w r4, [r0, #1*width]
    ldr.w r5, [r0, #(1+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(1+jump)*width]
    str.w r4, [r0, #1*width]

    ldr.w r4, [r0, #2*width]
    ldr.w r5, [r0, #(2+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(2+jump)*width]
    str.w r4, [r0, #2*width]

    ldr.w r4, [r0, #3*width]
    ldr.w r5, [r0, #(3+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(3+jump)*width]
    str.w r4, [r0, #3*width]

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #(0+jump)*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #(0+jump)*width]
    str.w r4, [r0], #8*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _5_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width

// 6

    .equ jump, 2

#ifdef LOOP
    add.w r6, r0, #256*width
    _6_loop:
#else
.rept 64
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #(1+2)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _6_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width

// 7

    .equ jump, 1

#ifdef LOOP
    add.w r6, r0, #256*width
    _7_loop:
#else
.rept 128
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #(1+1)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _7_loop
#else
.endr
#endif



    add.w sp, sp, #16
    pop {r4-r12, pc}

.align 4
.global __asm_NTT_fast
__asm_NTT_fast:

    push {r4-r12, lr}
    sub.w sp, sp, #16

    .equ width, 4


    ldr.w r2, [r2, #4]

// 0, 1

    .equ jump, 64

    ldr.w r8, [r1, #0*width]
    ldr.w r9, [r1, #1*width]

#ifdef LOOP
    add.w r3, r0, #64*width
    _01_inner_loop:
#else
.rept 64
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]

    mulmod_fast r6, r6, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]

    mulmod_fast r5, r5, r10, r11, r2, r12, r14
    add_sub1 r4, r5

    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]

    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub1 r6, r7

    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r4, [r0], #width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _01_inner_loop
#else
.endr
#endif


    add.w r1, r1, #6*width
    sub.w r0, r0, #64*width

// 2, 3

    .equ jump, 16

.set indx, 0
.rept 4

    ldr.w r8, [r1, #0*width]
    ldr.w r9, [r1, #1*width]

#ifdef LOOP
    add.w r3, r0, #16*width

.if indx == 0
    _23_0_inner_loop:
.elseif indx == 1
    _23_1_inner_loop:
.elseif indx == 2
    _23_2_inner_loop:
.else
    _23_3_inner_loop:
.endif

#else
.rept 16
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]

    mulmod_fast r6, r6, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]

    mulmod_fast r5, r5, r10, r11, r2, r12, r14
    add_sub1 r4, r5

    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]

    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub1 r6, r7

    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r4, [r0], #width

#ifdef LOOP

    cmp.w r0, r3

.if indx == 0
    bne.w _23_0_inner_loop
.elseif indx == 1
    bne.w _23_1_inner_loop
.elseif indx == 2
    bne.w _23_2_inner_loop
.else
    bne.w _23_3_inner_loop
.endif

#else
.endr
#endif

    add.w r1, r1, #6*width
    add.w r0, r0, #(64-16)*width

.set indx, indx+1
.endr

    sub.w r0, r0, #256*width

// 4, 5

    .equ jump, 4

#ifdef LOOP
    add.w r3, r0, #256*width
    _45_loop:
#else
.rept 16
#endif

    ldr.w r8, [r1, #0*width]
    ldr.w r9, [r1, #1*width]

.rept 4

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]

    mulmod_fast r6, r6, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]

    mulmod_fast r5, r5, r10, r11, r2, r12, r14
    add_sub1 r4, r5

    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]

    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub1 r6, r7

    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r4, [r0], #width

.endr

    add.w r1, r1, #6*width
    add.w r0, r0, #(16-4)*width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _45_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width

// 6, 7

    .equ jump, 1

#ifdef LOOP
    add.w r3, r0, #256*width
    _67_loop:
#else
.rept 64
#endif

    ldr.w r8, [r1, #0*width]
    ldr.w r9, [r1, #1*width]

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]

    mulmod_fast r6, r6, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]

    mulmod_fast r5, r5, r10, r11, r2, r12, r14
    add_sub1 r4, r5

    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]

    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub1 r6, r7

    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r4, [r0], #4*width

    add.w r1, r1, #6*width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _67_loop
#else
.endr
#endif

    sub.w r0, r0, #256*width



    add.w sp, sp, #16
    pop {r4-r12, pc}







