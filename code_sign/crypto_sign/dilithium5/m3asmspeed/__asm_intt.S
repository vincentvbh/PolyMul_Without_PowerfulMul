
#include "macros.i"
#include "mulmod.i"
#include "butterflies.i"
#include "reduce.i"

.cpu cortex-m3
.syntax unified

.align 4
.global __asm_iNTT
__asm_iNTT:

    push {r4-r12, lr}

    .equ width, 4

    ldr.w r2, [r2, #4]

    .equ jump, 1

    ldr.w r3, [r1, #(0+16)]
    ldrh.w r12, [r1, #(4+16)]
    ldrsh.w r14, [r1, #(6+16)]

#ifdef LOOP
    push.w {r1}
    add.w r1, r0, #256*width
    _i_light_loop:
#else
.rept 32
#endif

    ldr.w r4, [r0, #0*width]
    ldr.w r5, [r0, #1*width]
    ldr.w r6, [r0, #2*width]
    ldr.w r7, [r0, #3*width]

    add_sub2 r4, r5, r6, r7
    add_sub1 r4, r6

    butterfly r5, r7, r3, r12, r14, r2, r8, r9, r10, r11

    str.w r5, [r0, #1*width]
    str.w r7, [r0, #3*width]

    ldr.w r8, [r0, #4*width]
    ldr.w r9, [r0, #5*width]
    ldr.w r10, [r0, #6*width]
    ldr.w r11, [r0, #7*width]

    add_sub2 r8, r9, r10, r11
    add_sub1 r8, r10

    add_sub1 r4, r8

    reduce_32 r4, r2, r5
    reduce_32 r8, r2, r7

    str.w r4, [r0, #0*width]
    str.w r8, [r0, #4*width]

    butterfly r9, r11, r3, r12, r14, r2, r4, r5, r7, r8

    str.w r9, [r0, #5*width]
    str.w r11, [r0, #7*width]

    butterfly r6, r10, r3, r12, r14, r2, r4, r5, r7, r8

    str.w r6, [r0, #2*width]
    str.w r10, [r0, #6*width]

    add.w r0, r0, #8*width

#ifdef LOOP
    cmp.w r0, r1
    bne.w _i_light_loop
    pop.w {r1}
#else
.endr
#endif

    sub.w r0, r0, #(256-1)*width

    ldr.w r3, [r1, #(0+32)]
    ldrh.w r12, [r1, #(4+32)]
    ldrsh.w r14, [r1, #(6+32)]

#ifdef LOOP
    add.w r7, r0, #256*width
    _i_2_1_loop:
#else
.rept 32
#endif

    ldr.w r5, [r0, #0*width]
    ldr.w r9, [r0, #4*width]

    butterfly r5, r9, r3, r12, r14, r2, r4, r6, r8, r10

    str.w r9, [r0, #4*width]
    str.w r5, [r0], #8*width

#ifdef LOOP
    cmp.w r0, r7
    bne.w _i_2_1_loop
#else
.endr
#endif

    sub.w r0, r0, #(256+1-3)*width

    ldr.w r3, [r1, #(0+48)]
    ldrh.w r12, [r1, #(4+48)]
    ldrsh.w r14, [r1, #(6+48)]

#ifdef LOOP
    add.w r5, r0, #256*width
    _i_2_3_loop:
#else
.rept 32
#endif

    ldr.w r7, [r0, #0*width]
    ldr.w r11, [r0, #4*width]

    butterfly r7, r11, r3, r12, r14, r2, r4, r6, r8, r10

    str.w r11, [r0, #4*width]
    str.w r7, [r0], #8*width

#ifdef LOOP
    cmp.w r0, r5
    bne.w _i_2_3_loop
#else
.endr
#endif

    sub.w r0, r0, #(256+3)*width

// 3

    .equ jump, 8

    add.w r1, r1, #64

#ifdef LOOP
    add.w r3, r0, #256*width
    _i_3_light_loop:
#else
.rept 4
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]
    ldr.w r8, [r0, #4*jump*width]
    ldr.w r9, [r0, #5*jump*width]
    ldr.w r10, [r0, #6*jump*width]
    ldr.w r11, [r0, #7*jump*width]

    add_sub4 r4, r5, r6, r7, r8, r9, r10, r11
    add_sub2 r4, r6, r8, r10
    add_sub1 r4, r8

    reduce_32 r4, r2, r12
    reduce_32 r8, r2, r14

    str.w r4, [r0, #0*jump*width]
    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r8, [r0, #4*jump*width]
    str.w r9, [r0, #5*jump*width]
    str.w r10, [r0, #6*jump*width]
    str.w r11, [r0, #7*jump*width]
    add.w r0, r0,  #8*jump*width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _i_3_light_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    add.w r6, r0, #7*width
    _i_3_loop:
#else
.rept 7
#endif

    ldrh.w r12, [r1, #4]
    ldrsh.w r14, [r1, #6]
    ldr.w r3, [r1], #8

#ifdef LOOP
    add.w r7, r0, #256*width
    _i_3_inner_loop:
#else
.rept 16
#endif

    ldr.w r4, [r0]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r3, r12, r14, r2, r8, r9, r10, r11

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #16*width

#ifdef LOOP
    cmp.w r0, r7
    bne.w _i_3_inner_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_3_loop
#else
.endr
#endif

    sub.w r0, r0, #(8-1)*width

// 4

    .equ jump, 16

    add.w r1, r1, #8

#ifdef LOOP
    add.w r6, r0, #15*width
    _i_4_loop:
#else
.rept 15
#endif

    ldrh.w r12, [r1, #4]
    ldrsh.w r14, [r1, #6]
    ldr.w r3, [r1], #8

#ifdef LOOP
    add.w r7, r0, #256*width
    _i_4_inner_loop:
#else
.rept 8
#endif

    ldr.w r4, [r0]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r3, r12, r14, r2, r8, r9, r10, r11

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #32*width

#ifdef LOOP
    cmp.w r0, r7
    bne.w _i_4_inner_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_4_loop
#else
.endr
#endif

    sub.w r0, r0, #(16-1)*width

// 5

    .equ jump, 32

    add.w r1, r1, #8

#ifdef LOOP
    add.w r6, r0, #31*width
    _i_5_loop:
#else
.rept 31
#endif

    ldrh.w r12, [r1, #4]
    ldrsh.w r14, [r1, #6]
    ldr.w r3, [r1], #8

#ifdef LOOP
    add.w r7, r0, #256*width
    _i_5_inner_loop:
#else
.rept 4
#endif

    ldr.w r4, [r0]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r3, r12, r14, r2, r8, r9, r10, r11

    str.w r4, [r0]
    str.w r5, [r0, #jump*width]
    add.w r0, r0, #64*width

#ifdef LOOP
    cmp.w r0, r7
    bne.w _i_5_inner_loop
#else
.endr
#endif

    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_5_loop
#else
.endr
#endif

    sub.w r0, r0, #32*width

// 6

    .equ jump, 64

#ifdef LOOP
    add.w r6, r0, #64*width
    _i_6_loop:
#else
.rept 64
#endif

    ldrh.w r12, [r1, #4]
    ldrsh.w r14, [r1, #6]
    ldr.w r3, [r1], #8

.rept 2

    ldr.w r4, [r0]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r3, r12, r14, r2, r8, r9, r10, r11

    str.w r4, [r0]
    str.w r5, [r0, #jump*width]
    add.w r0, r0, #128*width

.endr

    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_6_loop
#else
.endr
#endif

    sub.w r0, r0, #64*width

// 7

    .equ jump, 128

#ifdef LOOP
    add.w r6, r0, #128*width
    _i_7_loop:
#else
.rept 128
#endif

    ldrh.w r12, [r1, #4]
    ldrsh.w r14, [r1, #6]
    ldr.w r3, [r1], #8

    ldr.w r4, [r0]
    ldr.w r5, [r0, #jump*width]

    butterfly r4, r5, r3, r12, r14, r2, r8, r9, r10, r11

    str.w r4, [r0]
    str.w r5, [r0, #jump*width]
    add.w r0, r0, #width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_7_loop
#else
.endr
#endif

    pop {r4-r12, pc}

.align 4
.global __asm_iNTT_fast
__asm_iNTT_fast:
    push.w {r4-r12, lr}

    .equ width, 4

    ldr.w r2, [r2, #4]

// 0, 1

    .equ jump, 1

    ldr.w r8, [r1, #4*width]
    ldr.w r9, [r1, #5*width]

#ifdef LOOP
    add.w r3, r0, #256*width
    _i_01_inner_loop:
#else
.rept 64
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]

    add_sub2 r4, r5, r6, r7

    mulmod_fast r7, r7, r8, r9, r2, r12, r14

    add_sub2 r4, r6, r5, r7

    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r4, [r0], #4*jump*width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _i_01_inner_loop
#else
.endr
#endif

    add.w r1, r1, #6*width
    sub.w r0, r0, #256*width

// 2, 3

    .equ jump, 4

.set indx, 0
.rept 4

    ldr.w r8, [r1, #0*width]
    ldr.w r9, [r1, #1*width]

#ifdef LOOP
    add.w r3, r0, #256*width

.if indx == 0
    _i_23_0_inner_loop:
.elseif indx == 1
    _i_23_1_inner_loop:
.elseif indx == 2
    _i_23_2_inner_loop:
.else
    _i_23_3_inner_loop:
.endif

#else
.rept 16
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]


    mulmod_fast r5, r5, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r5, r6, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]
    mulmod_fast r6, r6, r10, r11, r2, r12, r14
    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]
    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]
    str.w r4, [r0], #4*jump*width

#ifdef LOOP
    cmp.w r0, r3

.if indx == 0
    bne.w _i_23_0_inner_loop
.elseif indx == 1
    bne.w _i_23_1_inner_loop
.elseif indx == 2
    bne.w _i_23_2_inner_loop
.else
    bne.w _i_23_3_inner_loop
.endif

#else
.endr
#endif

    add.w r1, r1, #6*width
    sub.w r0, r0, #(256-1)*width

.set indx, indx+1
.endr

    sub.w r0, r0, #4*width

// 4, 5

    .equ jump, 16

#ifdef LOOP
    add.w r3, r0, #16*width
    _i_45_loop:
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


    mulmod_fast r5, r5, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r5, r6, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]
    mulmod_fast r6, r6, r10, r11, r2, r12, r14
    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]
    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    str.w r4, [r0, #0*jump*width]
    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]

    add.w r0, r0, #4*jump*width

.endr

    add.w r1, r1, #6*width
    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _i_45_loop
#else
.endr
#endif

    sub.w r0, r0, #16*width

// 6, 7

    .equ jump, 64

#ifdef LOOP
    add.w r3, r0, #64*width
    _i_67_loop:
#else
.rept 64
#endif

    ldr.w r8, [r1, #0*width]
    ldr.w r9, [r1, #1*width]

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]
    ldr.w r6, [r0, #2*jump*width]
    ldr.w r7, [r0, #3*jump*width]


    mulmod_fast r5, r5, r8, r9, r2, r12, r14
    mulmod_fast r7, r7, r8, r9, r2, r12, r14
    add_sub2 r4, r5, r6, r7

    ldr.w r10, [r1, #2*width]
    ldr.w r11, [r1, #3*width]
    mulmod_fast r6, r6, r10, r11, r2, r12, r14
    ldr.w r10, [r1, #4*width]
    ldr.w r11, [r1, #5*width]
    mulmod_fast r7, r7, r10, r11, r2, r12, r14
    add_sub2 r4, r6, r5, r7

    str.w r4, [r0, #0*jump*width]
    str.w r5, [r0, #1*jump*width]
    str.w r6, [r0, #2*jump*width]
    str.w r7, [r0, #3*jump*width]

    add.w r0, r0, #4*jump*width

    add.w r1, r1, #6*width
    sub.w r0, r0, #(256-1)*width

#ifdef LOOP
    cmp.w r0, r3
    bne.w _i_67_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}

.align 4
.global __asm_iNTT_negacyclic
__asm_iNTT_negacyclic:
    push.w {r4-r12, lr}
    sub.w sp, sp, #16

    .equ width, 4

    ldr.w r2, [r2, #4]

// 7

    .equ jump, 1

    add.w r1, r1, #127*8

#ifdef LOOP
    add.w r6, r0, #256*width
    _i_7_negacyclic_loop:
#else
.rept 128
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #(1+jump)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_7_negacyclic_loop
#else
.endr
#endif

    sub.w r1, r1, #(128+64)*8
    sub.w r0, r0, #256*width

// 6

    .equ jump, 2

#ifdef LOOP
    add.w r6, r0, #256*width
    _i_6_negacyclic_loop:
#else
.rept 64
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #(1+jump)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_6_negacyclic_loop
#else
.endr
#endif

    sub.w r1, r1, #(64+32)*8
    sub.w r0, r0, #256*width

// 5

    .equ jump, 4

#ifdef LOOP
    add.w r6, r0, #256*width
    _i_5_negacyclic_loop:
#else
.rept 32
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

.rept 3

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

.endr

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #(1+jump)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_5_negacyclic_loop
#else
.endr
#endif

    sub.w r1, r1, #(32+16)*8
    sub.w r0, r0, #256*width

// 4

    .equ jump, 8

#ifdef LOOP
    add.w r6, r0, #256*width
    _i_4_negacyclic_loop:
#else
.rept 16
#endif

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

.rept 7

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14
    reduce_32 r4, r2, r3

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

.endr

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14
    reduce_32 r4, r2, r3

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #(1+jump)*width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_4_negacyclic_loop
#else
.endr
#endif

    sub.w r1, r1, #(16+8)*8
    sub.w r0, r0, #256*width

// 3

    .equ jump, 16

.set indx, 0
.rept 8

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

#ifdef LOOP
    add.w r6, r0, #16*width

.if indx == 0
    _i_3_0_negacyclic:
.elseif indx == 1
    _i_3_1_negacyclic:
.elseif indx == 2
    _i_3_2_negacyclic:
.elseif indx == 3
    _i_3_3_negacyclic:
.elseif indx == 4
    _i_3_4_negacyclic:
.elseif indx == 5
    _i_3_5_negacyclic:
.elseif indx == 6
    _i_3_6_negacyclic:
.elseif indx == 7
    _i_3_7_negacyclic:
.endif

#else
.rept 16
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

#ifdef LOOP
    cmp.w r0, r6

.if indx == 0
    bne.w _i_3_0_negacyclic
.elseif indx == 1
    bne.w _i_3_1_negacyclic
.elseif indx == 2
    bne.w _i_3_2_negacyclic
.elseif indx == 3
    bne.w _i_3_3_negacyclic
.elseif indx == 4
    bne.w _i_3_4_negacyclic
.elseif indx == 5
    bne.w _i_3_5_negacyclic
.elseif indx == 6
    bne.w _i_3_6_negacyclic
.elseif indx == 7
    bne.w _i_3_7_negacyclic
.endif

#else
.endr
#endif

    add.w r0, r0, #jump*width

.set indx, indx+1
.endr

    sub.w r1, r1, #(8+4)*8
    sub.w r0, r0, #256*width

// 2

    .equ jump, 32


.set indx, 0
.rept 4

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

#ifdef LOOP
    add.w r6, r0, #32*width

.if indx == 0
    _i_2_0_negacyclic:
.elseif indx == 1
    _i_2_1_negacyclic:
.elseif indx == 2
    _i_2_2_negacyclic:
.elseif indx == 3
    _i_2_3_negacyclic:
.endif

#else
.rept 32
#endif


    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

#ifdef LOOP
    cmp.w r0, r6

.if indx == 0
    bne.w _i_2_0_negacyclic
.elseif indx == 1
    bne.w _i_2_1_negacyclic
.elseif indx == 2
    bne.w _i_2_2_negacyclic
.elseif indx == 3
    bne.w _i_2_3_negacyclic
.endif

#else
.endr
#endif

    add.w r0, r0, #jump*width

.set indx, indx+1
.endr

    sub.w r1, r1, #(4+2)*8
    sub.w r0, r0, #256*width

// 1

    .equ jump, 64

.set indx, 0
.rept 2

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

#ifdef LOOP
    add.w r6, r0, #64*width

.if indx == 0
    _i_1_0_negacyclic:
.elseif indx == 1
    _i_1_1_negacyclic:
.endif

#else
.rept 64
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

#ifdef LOOP
    cmp.w r0, r6

.if indx == 0
    bne.w _i_1_0_negacyclic
.elseif indx == 1
    bne.w _i_1_1_negacyclic
.endif

#else
.endr
#endif

    add.w r0, r0, #jump*width

.set indx, indx+1
.endr

    sub.w r1, r1, #(2+1)*8
    sub.w r0, r0, #256*width

// 0

    .equ jump, 128

    ldrh.w r9, [r1, #4]
    ldrsh.w r10, [r1, #6]
    ldr.w r8, [r1], #8

#ifdef LOOP
    add.w r6, r0, #128*width
    _i_0_negacyclic:
#else
.rept 128
#endif

    ldr.w r4, [r0, #0*jump*width]
    ldr.w r5, [r0, #1*jump*width]

    GS_butterfly r4, r5, r8, r9, r10, r2, r3, r11, r12, r14

    str.w r5, [r0, #jump*width]
    str.w r4, [r0], #width

#ifdef LOOP
    cmp.w r0, r6
    bne.w _i_0_negacyclic
#else
.endr
#endif

    add.w sp, sp, #16
    pop.w {r4-r12, pc}







