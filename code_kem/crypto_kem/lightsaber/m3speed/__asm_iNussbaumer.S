
#include "macros.i"

.syntax unified
.cpu cortex-m3

.align 4
.global __asm_iNussbaumer_neg256_0_1_2_3
.type __asm_iNussbaumer_neg256_0_1_2_3, %function
__asm_iNussbaumer_neg256_0_1_2_3:
    push.w {r4-r12, lr}

    .equ width, 4

// ================

// 0, 0, 8
#ifdef LOOP
    mov.w r3, #8
    _iNussbaumer_nega256_0_1_loop:
#else
.rept 8
#endif

.set indx, 0
.rept 8

    ldr.w  r4, [r1, #(0*16+0+indx)*width]
    ldr.w  r5, [r1, #(0*16+8+indx)*width]
    ldr.w  r6, [r1, #(1*16+0+indx)*width]
    ldr.w  r7, [r1, #(1*16+8+indx)*width]
    ldr.w  r8, [r1, #(2*16+0+indx)*width]
    ldr.w  r9, [r1, #(2*16+8+indx)*width]
    ldr.w r10, [r1, #(3*16+0+indx)*width]
    ldr.w r11, [r1, #(3*16+8+indx)*width]

    add_sub4 r4, r6, r5, r7, r8, r10, r9, r11
    add_sub4 r4, r8, r5, r9, r6, r11, r7, r10

    str.w  r4, [r1, #(0*16+0+indx)*width]
    str.w  r5, [r1, #(0*16+8+indx)*width]
    str.w  r6, [r1, #(1*16+0+indx)*width]
    str.w r10, [r1, #(1*16+8+indx)*width]
    str.w  r8, [r1, #(2*16+0+indx)*width]
    str.w  r9, [r1, #(2*16+8+indx)*width]
    str.w r11, [r1, #(3*16+0+indx)*width]
    str.w  r7, [r1, #(3*16+8+indx)*width]

.set indx, indx+1
.endr

    add.w r1, r1, #64*width

#ifdef LOOP
    subs.w r3, #1
    bne.w _iNussbaumer_nega256_0_1_loop
#else
.endr
#endif

    sub.w r1, r1, #512*width

// ================

// 0, 0, 8

#ifdef LOOP
    mov.w r3, #2
    _iNussbaumer_nega256_2_3_inner_0_1_loop:
#else
.rept 2
#endif

.set indx, 0
.rept 8

    ldr.w  r4, [r1, #( 0*16+ 0+indx)*width]
    ldr.w  r5, [r1, #( 0*16+ 8+indx)*width]
    ldr.w  r6, [r1, #( 4*16+ 0+indx)*width]
    ldr.w  r7, [r1, #( 4*16+ 8+indx)*width]
    ldr.w  r8, [r1, #( 8*16+ 0+indx)*width]
    ldr.w  r9, [r1, #( 8*16+ 8+indx)*width]
    ldr.w r10, [r1, #(12*16+ 0+indx)*width]
    ldr.w r11, [r1, #(12*16+ 8+indx)*width]

    add_sub4 r4, r6, r5, r7, r8, r10, r9, r11
    add_sub4 r4, r8, r5, r9, r6, r11, r7, r10

    str.w  r4, [r0, #( 0*16+ 0+indx)*width]
    str.w  r5, [r0, #( 0*16+ 8+indx)*width]
    str.w  r6, [r0, #( 4*16+ 0+indx)*width]
    str.w r10, [r0, #( 4*16+ 8+indx)*width]
    str.w  r8, [r0, #( 8*16+ 0+indx)*width]
    str.w  r9, [r0, #( 8*16+ 8+indx)*width]
    str.w r11, [r0, #(12*16+ 0+indx)*width]
    str.w  r7, [r0, #(12*16+ 8+indx)*width]

.set indx, indx+1
.endr

    add.w r0, r0, #256*width
    add.w r1, r1, #256*width

#ifdef LOOP
    subs.w r3, #1
    bne.w _iNussbaumer_nega256_2_3_inner_0_1_loop
#else
.endr
#endif

    sub.w r0, r0, #512*width
    sub.w r1, r1, #512*width

// ========

// 12, 14, 6

#ifdef LOOP
    mov.w r3, #2
    _iNussbaumer_nega256_2_3_inner_2_3_loop:
#else
.rept 2
#endif

// 12, 14, 6
// 0, 4, 2, 6
// 8, 12, 10, 14

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 1*16+ 0+indx)*width]
    ldr.w  r5, [r1, #( 1*16+ 8+indx)*width]
    ldr.w  r6, [r1, #( 5*16+ 4+indx)*width]
    ldr.w  r7, [r1, #( 5*16+12+indx)*width]
    ldr.w  r8, [r1, #( 9*16+ 2+indx)*width]
    ldr.w  r9, [r1, #( 9*16+10+indx)*width]
    ldr.w r10, [r1, #(13*16+ 6+indx)*width]
    ldr.w r11, [r1, #(13*16+14+indx)*width]

    // 0, 0
    add_sub1 r4, r6
    // 2, 2
    add_sub1 r8, r10

    // 8, 8
    add_sub1 r5, r7
    // 10, 10
    add_sub1 r9, r11

    // 0, 0
    add_sub1 r4, r8
    // 8, 8
    add_sub1 r5, r9

    // 0, 0
    add_sub1 r6, r11
    // 8, 8
    sub_add1 r7, r10

    str.w  r4, [r0, #( 1*16+ 0+indx)*width]
    str.w  r5, [r0, #( 1*16+ 8+indx)*width]
    str.w  r6, [r0, #( 5*16+ 0+indx)*width]
    str.w  r7, [r0, #( 5*16+ 8+indx)*width]
    str.w  r8, [r0, #( 9*16+ 0+indx)*width]
    str.w  r9, [r0, #( 9*16+ 8+indx)*width]
    str.w r11, [r0, #(13*16+ 0+indx)*width]
    str.w r10, [r0, #(13*16+ 8+indx)*width]

.set indx, indx+1
.endr

// 12, 14, 6
// 2, 6, 4, 8
// 10, 14, 12, 0

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 1*16+ 2+indx)*width]
    ldr.w  r5, [r1, #( 1*16+10+indx)*width]
    ldr.w  r6, [r1, #( 5*16+ 6+indx)*width]
    ldr.w  r7, [r1, #( 5*16+14+indx)*width]
    ldr.w  r8, [r1, #( 9*16+ 4+indx)*width]
    ldr.w  r9, [r1, #( 9*16+12+indx)*width]
    ldr.w r10, [r1, #(13*16+ 8+indx)*width]
    ldr.w r11, [r1, #(13*16+ 0+indx)*width]

    // 2, 2
    add_sub1 r4, r6
    // 4, 4
    add_sub1 r8, r10

    // 10, 10
    add_sub1 r5, r7
    // 12, 12
    sub_add1 r9, r11

    // 2, 2
    add_sub1 r4, r8
    // 10, 10
    add_sub1 r5, r9

    // 2, 2
    add_sub1 r6, r11
    // 10, 10
    sub_add1 r7, r10

    str.w  r4, [r0, #( 1*16+ 2+indx)*width]
    str.w  r5, [r0, #( 1*16+10+indx)*width]
    str.w  r6, [r0, #( 5*16+ 2+indx)*width]
    str.w  r7, [r0, #( 5*16+10+indx)*width]
    str.w  r8, [r0, #( 9*16+ 2+indx)*width]
    str.w  r9, [r0, #( 9*16+10+indx)*width]
    str.w r11, [r0, #(13*16+ 2+indx)*width]
    str.w r10, [r0, #(13*16+10+indx)*width]

.set indx, indx+1
.endr

// 12, 14, 6
// 4, 8, 6, 10
// 12, 0, 14, 2

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 1*16+ 4+indx)*width]
    ldr.w  r5, [r1, #( 1*16+12+indx)*width]
    ldr.w  r6, [r1, #( 5*16+ 8+indx)*width]
    ldr.w  r7, [r1, #( 5*16+ 0+indx)*width]
    ldr.w  r8, [r1, #( 9*16+ 6+indx)*width]
    ldr.w  r9, [r1, #( 9*16+14+indx)*width]
    ldr.w r10, [r1, #(13*16+10+indx)*width]
    ldr.w r11, [r1, #(13*16+ 2+indx)*width]

    // 4, 4
    add_sub1 r4, r6
    // 6, 6
    add_sub1 r8, r10

    // 12, 12
    sub_add1 r5, r7
    // 14, 14
    sub_add1 r9, r11

    // 4, 4
    add_sub1 r4, r8
    // 12, 12
    add_sub1 r5, r9

    // 4, 4
    add_sub1 r6, r11
    // 12, 12
    sub_add1 r7, r10

    str.w  r4, [r0, #( 1*16+ 4+indx)*width]
    str.w  r5, [r0, #( 1*16+12+indx)*width]
    str.w  r6, [r0, #( 5*16+ 4+indx)*width]
    str.w  r7, [r0, #( 5*16+12+indx)*width]
    str.w  r8, [r0, #( 9*16+ 4+indx)*width]
    str.w  r9, [r0, #( 9*16+12+indx)*width]
    str.w r11, [r0, #(13*16+ 4+indx)*width]
    str.w r10, [r0, #(13*16+12+indx)*width]

.set indx, indx+1
.endr

// 12, 14, 6
// 6, 10, 8, 12
// 14, 2, 0, 4

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 1*16+ 6+indx)*width]
    ldr.w  r5, [r1, #( 1*16+14+indx)*width]
    ldr.w  r6, [r1, #( 5*16+10+indx)*width]
    ldr.w  r7, [r1, #( 5*16+ 2+indx)*width]
    ldr.w  r8, [r1, #( 9*16+ 8+indx)*width]
    ldr.w  r9, [r1, #( 9*16+ 0+indx)*width]
    ldr.w r10, [r1, #(13*16+12+indx)*width]
    ldr.w r11, [r1, #(13*16+ 4+indx)*width]

    // 6, 6
    add_sub1 r4, r6
    // 8, 8
    add_sub1 r8, r10

    // 14, 14
    sub_add1 r5, r7
    // 0, 0
    add_sub1 r9, r11

    // 6, 6
    add_sub1 r4, r8
    // 14, 14
    sub_add1 r5, r9

    // 6, 6
    sub_add1 r6, r11
    // 14, 14
    sub_add1 r7, r10

    str.w  r4, [r0, #( 1*16+ 6+indx)*width]
    str.w  r5, [r0, #( 1*16+14+indx)*width]
    str.w  r6, [r0, #( 5*16+ 6+indx)*width]
    str.w  r7, [r0, #( 5*16+14+indx)*width]
    str.w  r8, [r0, #( 9*16+ 6+indx)*width]
    str.w  r9, [r0, #( 9*16+14+indx)*width]
    str.w r11, [r0, #(13*16+ 6+indx)*width]
    str.w r10, [r0, #(13*16+14+indx)*width]

.set indx, indx+1
.endr

    add.w r0, r0, #256*width
    add.w r1, r1, #256*width

#ifdef LOOP
    subs.w r3, #1
    bne.w _iNussbaumer_nega256_2_3_inner_2_3_loop
#else
.endr
#endif

    sub.w r0, r0, #512*width
    sub.w r1, r1, #512*width

// ========

// 8, 12, 4

#ifdef LOOP
    mov.w r3, #2
    _iNussbaumer_nega256_2_3_inner_4_5_loop:
#else
.rept 2
#endif

// 8, 12, 4
// 0, 8, 4, 12
// 8, 0, 12, 4

.set indx, 0
.rept 4

    ldr.w  r4, [r1, #( 2*16+ 0+indx)*width]
    ldr.w  r5, [r1, #( 2*16+ 8+indx)*width]
    ldr.w  r6, [r1, #( 6*16+ 8+indx)*width]
    ldr.w  r7, [r1, #( 6*16+ 0+indx)*width]
    ldr.w  r8, [r1, #(10*16+ 4+indx)*width]
    ldr.w  r9, [r1, #(10*16+12+indx)*width]
    ldr.w r10, [r1, #(14*16+12+indx)*width]
    ldr.w r11, [r1, #(14*16+ 4+indx)*width]

    // 0, 0
    add_sub1 r4, r6
    // 4, 4
    add_sub1 r8, r10

    // 8, 8
    sub_add1 r5, r7
    // 12, 12
    sub_add1 r9, r11

    // 0, 0
    add_sub1 r4, r8
    // 8, 8
    add_sub1 r5, r9

    // 0, 0
    add_sub1 r6, r11
    // 8, 8
    sub_add1 r7, r10

    str.w  r4, [r0, #( 2*16+ 0+indx)*width]
    str.w  r5, [r0, #( 2*16+ 8+indx)*width]
    str.w  r6, [r0, #( 6*16+ 0+indx)*width]
    str.w  r7, [r0, #( 6*16+ 8+indx)*width]
    str.w  r8, [r0, #(10*16+ 0+indx)*width]
    str.w  r9, [r0, #(10*16+ 8+indx)*width]
    str.w r11, [r0, #(14*16+ 0+indx)*width]
    str.w r10, [r0, #(14*16+ 8+indx)*width]

.set indx, indx+1
.endr

// 8, 12, 4
// 4, 12, 8, 0
// 12, 4, 0, 8

.set indx, 0
.rept 4

    ldr.w  r4, [r1, #( 2*16+ 4+indx)*width]
    ldr.w  r5, [r1, #( 2*16+12+indx)*width]
    ldr.w  r6, [r1, #( 6*16+12+indx)*width]
    ldr.w  r7, [r1, #( 6*16+ 4+indx)*width]
    ldr.w  r8, [r1, #(10*16+ 0+indx)*width]
    ldr.w  r9, [r1, #(10*16+ 8+indx)*width]
    ldr.w r10, [r1, #(14*16+ 8+indx)*width]
    ldr.w r11, [r1, #(14*16+ 0+indx)*width]

    // 4, 4
    add_sub1 r4, r6
    // 0, 0
    add_sub1 r8, r10

    // 12, 12
    sub_add1 r5, r7
    // 8, 8
    sub_add1 r9, r11

    // 4, 4
    add_sub1 r4, r9
    // 12, 12
    sub_add1 r5, r8

    // 4, 4
    sub_add1 r6, r10
    // 12, 12
    sub_add1 r7, r11

    str.w  r4, [r0, #( 2*16+ 4+indx)*width]
    str.w  r5, [r0, #( 2*16+12+indx)*width]
    str.w  r6, [r0, #( 6*16+ 4+indx)*width]
    str.w  r7, [r0, #( 6*16+12+indx)*width]
    str.w  r9, [r0, #(10*16+ 4+indx)*width]
    str.w  r8, [r0, #(10*16+12+indx)*width]
    str.w r10, [r0, #(14*16+ 4+indx)*width]
    str.w r11, [r0, #(14*16+12+indx)*width]

.set indx, indx+1
.endr

    add.w r0, r0, #256*width
    add.w r1, r1, #256*width

#ifdef LOOP
    subs.w r3, #1
    bne.w _iNussbaumer_nega256_2_3_inner_4_5_loop
#else
.endr
#endif

    sub.w r0, r0, #512*width
    sub.w r1, r1, #512*width

// ================

// 4, 10, 2

#ifdef LOOP
    mov.w r3, #2
    _iNussbaumer_nega256_2_3_inner_6_7_loop:
#else
.rept 2
#endif

// 4, 10, 2
// 0, 12, 6, 2
// 8, 4, 14, 10

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 3*16+ 0+indx)*width]
    ldr.w  r5, [r1, #( 3*16+ 8+indx)*width]
    ldr.w  r6, [r1, #( 7*16+12+indx)*width]
    ldr.w  r7, [r1, #( 7*16+ 4+indx)*width]
    ldr.w  r8, [r1, #(11*16+ 6+indx)*width]
    ldr.w  r9, [r1, #(11*16+14+indx)*width]
    ldr.w r10, [r1, #(15*16+ 2+indx)*width]
    ldr.w r11, [r1, #(15*16+10+indx)*width]

    // 0, 0
    add_sub1 r4, r6
    // 6, 6
    sub_add1 r8, r10

    // 8, 8
    sub_add1 r5, r7
    // 14, 14
    sub_add1 r9, r11

    // 0, 0
    add_sub1 r4, r8
    // 8, 8
    add_sub1 r5, r9

    // 0, 0
    add_sub1 r6, r11
    // 8, 8
    sub_add1 r7, r10

    str.w  r4, [r0, #( 3*16+ 0+indx)*width]
    str.w  r5, [r0, #( 3*16+ 8+indx)*width]
    str.w  r6, [r0, #( 7*16+ 0+indx)*width]
    str.w  r7, [r0, #( 7*16+ 8+indx)*width]
    str.w  r8, [r0, #(11*16+ 0+indx)*width]
    str.w  r9, [r0, #(11*16+ 8+indx)*width]
    str.w r11, [r0, #(15*16+ 0+indx)*width]
    str.w r10, [r0, #(15*16+ 8+indx)*width]

.set indx, indx+1
.endr

// 4, 10, 2
// 2, 14, 8, 4
// 10, 6, 0, 12

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 3*16+ 2+indx)*width]
    ldr.w  r5, [r1, #( 3*16+10+indx)*width]
    ldr.w  r6, [r1, #( 7*16+14+indx)*width]
    ldr.w  r7, [r1, #( 7*16+ 6+indx)*width]
    ldr.w  r8, [r1, #(11*16+ 8+indx)*width]
    ldr.w  r9, [r1, #(11*16+ 0+indx)*width]
    ldr.w r10, [r1, #(15*16+ 4+indx)*width]
    ldr.w r11, [r1, #(15*16+12+indx)*width]

    // 2, 2
    add_sub1 r4, r6
    // 8, 8
    sub_add1 r8, r10

    // 10, 10
    sub_add1 r5, r7
    // 0, 0
    add_sub1 r9, r11

    // 2, 2
    add_sub1 r4, r8
    // 10, 10
    sub_add1 r5, r9

    // 2, 2
    sub_add1 r6, r11
    // 10, 10
    sub_add1 r7, r10

    str.w  r4, [r0, #( 3*16+ 2+indx)*width]
    str.w  r5, [r0, #( 3*16+10+indx)*width]
    str.w  r6, [r0, #( 7*16+ 2+indx)*width]
    str.w  r7, [r0, #( 7*16+10+indx)*width]
    str.w  r8, [r0, #(11*16+ 2+indx)*width]
    str.w  r9, [r0, #(11*16+10+indx)*width]
    str.w r11, [r0, #(15*16+ 2+indx)*width]
    str.w r10, [r0, #(15*16+10+indx)*width]

.set indx, indx+1
.endr

// 4, 10, 2
// 4, 0, 10, 6
// 12, 8, 2, 14

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 3*16+ 4+indx)*width]
    ldr.w  r5, [r1, #( 3*16+12+indx)*width]
    ldr.w  r6, [r1, #( 7*16+ 0+indx)*width]
    ldr.w  r7, [r1, #( 7*16+ 8+indx)*width]
    ldr.w  r8, [r1, #(11*16+10+indx)*width]
    ldr.w  r9, [r1, #(11*16+ 2+indx)*width]
    ldr.w r10, [r1, #(15*16+ 6+indx)*width]
    ldr.w r11, [r1, #(15*16+14+indx)*width]

    // 4, 4
    sub_add1 r4, r6
    // 10, 10
    sub_add1 r8, r10

    // 12, 12
    sub_add1 r5, r7
    // 2, 2
    add_sub1 r9, r11

    // 4, 4
    add_sub1 r4, r8
    // 12, 12
    sub_add1 r5, r9

    // 4, 4
    sub_add1 r6, r11
    // 12, 12
    sub_add1 r7, r10

    str.w  r4, [r0, #( 3*16+ 4+indx)*width]
    str.w  r5, [r0, #( 3*16+12+indx)*width]
    str.w  r6, [r0, #( 7*16+ 4+indx)*width]
    str.w  r7, [r0, #( 7*16+12+indx)*width]
    str.w  r8, [r0, #(11*16+ 4+indx)*width]
    str.w  r9, [r0, #(11*16+12+indx)*width]
    str.w r11, [r0, #(15*16+ 4+indx)*width]
    str.w r10, [r0, #(15*16+12+indx)*width]

.set indx, indx+1
.endr

// 4, 10, 2
// 6, 2, 12, 8
// 14, 10, 4, 0

.set indx, 0
.rept 2

    ldr.w  r4, [r1, #( 3*16+ 6+indx)*width]
    ldr.w  r5, [r1, #( 3*16+14+indx)*width]
    ldr.w  r6, [r1, #( 7*16+ 2+indx)*width]
    ldr.w  r7, [r1, #( 7*16+10+indx)*width]
    ldr.w  r8, [r1, #(11*16+12+indx)*width]
    ldr.w  r9, [r1, #(11*16+ 4+indx)*width]
    ldr.w r10, [r1, #(15*16+ 8+indx)*width]
    ldr.w r11, [r1, #(15*16+ 0+indx)*width]

    // 6, 6
    sub_add1 r4, r6
    // 12, 12
    sub_add1 r8, r10

    // 14, 14
    sub_add1 r5, r7
    // 4, 4
    sub_add1 r9, r11

    // 6, 6
    add_sub1 r4, r8
    // 14, 14
    sub_add1 r5, r9

    // 6, 6
    sub_add1 r6, r11
    // 14, 14
    sub_add1 r7, r10

    str.w  r4, [r0, #( 3*16+ 6+indx)*width]
    str.w  r5, [r0, #( 3*16+14+indx)*width]
    str.w  r6, [r0, #( 7*16+ 6+indx)*width]
    str.w  r7, [r0, #( 7*16+14+indx)*width]
    str.w  r8, [r0, #(11*16+ 6+indx)*width]
    str.w  r9, [r0, #(11*16+14+indx)*width]
    str.w r11, [r0, #(15*16+ 6+indx)*width]
    str.w r10, [r0, #(15*16+14+indx)*width]

.set indx, indx+1
.endr

    add.w r0, r0, #256*width
    add.w r1, r1, #256*width

#ifdef LOOP
    subs.w r3, #1
    bne.w _iNussbaumer_nega256_2_3_inner_6_7_loop
#else
.endr
#endif

// ================

    pop.w {r4-r12, pc}

.align 4
.global __asm_iNussbaumer_neg256_4_last
.type __asm_iNussbaumer_neg256_4_last, %function
__asm_iNussbaumer_neg256_4_last:
    push.w {r4-r12, lr}

    .equ width, 4

    add.w r2, r1, #256*width

// {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
// {0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

// ================

// ================
// 0
// {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #0*width]
    ldr.w r7, [r2, #1*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 7

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 1
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #1*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 7

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+1)*width]
    ldr.w r7, [r2, #(indx+2)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 1

    ldr.w r4, [r1, #(15+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(15+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 2
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #2*width]
    ldr.w r7, [r2, #3*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 6

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+2)*width]
    ldr.w r7, [r2, #(indx+3)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 1

    ldr.w r4, [r1, #(indx+14)*width]
    ldr.w r5, [r1, #(indx+15)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+14)*16*width]
    str.w r9, [r0, #(indx+15)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 3
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #3*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 6

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+3)*width]
    ldr.w r7, [r2, #(indx+4)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 3

    ldr.w r4, [r1, #(13+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(13+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 4
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #4*width]
    ldr.w r7, [r2, #5*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 5

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+4)*width]
    ldr.w r7, [r2, #(indx+5)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 2

    ldr.w r4, [r1, #(indx+12)*width]
    ldr.w r5, [r1, #(indx+13)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+12)*16*width]
    str.w r9, [r0, #(indx+13)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 5
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #5*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 5

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+5)*width]
    ldr.w r7, [r2, #(indx+6)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 5

    ldr.w r4, [r1, #(11+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(11+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 6
// {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #6*width]
    ldr.w r7, [r2, #7*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 4

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+6)*width]
    ldr.w r7, [r2, #(indx+7)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 3

    ldr.w r4, [r1, #(indx+10)*width]
    ldr.w r5, [r1, #(indx+11)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+10)*16*width]
    str.w r9, [r0, #(indx+11)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 7
// {0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #7*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 4

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+7)*width]
    ldr.w r7, [r2, #(indx+8)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 7

    ldr.w r4, [r1, #(9+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(9+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 8
// {0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #8*width]
    ldr.w r7, [r2, #9*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 3

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+8)*width]
    ldr.w r7, [r2, #(indx+9)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 4

    ldr.w r4, [r1, #(indx+8)*width]
    ldr.w r5, [r1, #(indx+9)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+8)*16*width]
    str.w r9, [r0, #(indx+9)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 9
// {0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #9*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 3

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+9)*width]
    ldr.w r7, [r2, #(indx+10)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 9

    ldr.w r4, [r1, #(7+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(7+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 10
// {0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #10*width]
    ldr.w r7, [r2, #11*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 2

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+10)*width]
    ldr.w r7, [r2, #(indx+11)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 5

    ldr.w r4, [r1, #(indx+6)*width]
    ldr.w r5, [r1, #(indx+7)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+6)*16*width]
    str.w r9, [r0, #(indx+7)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 11
// {0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #11*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 2

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+11)*width]
    ldr.w r7, [r2, #(indx+12)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 11

    ldr.w r4, [r1, #(5+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(5+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 12
// {0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r5, [r1, #1*width]
    ldr.w r6, [r2, #12*width]
    ldr.w r7, [r2, #13*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #1*16*width]

.set indx, 2
.rept 1

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+12)*width]
    ldr.w r7, [r2, #(indx+13)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 6

    ldr.w r4, [r1, #(indx+4)*width]
    ldr.w r5, [r1, #(indx+5)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+4)*16*width]
    str.w r9, [r0, #(indx+5)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 13
// {0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #13*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 1
.rept 1

    ldr.w r4, [r1, #(indx+0)*width]
    ldr.w r5, [r1, #(indx+1)*width]
    ldr.w r6, [r2, #(indx+13)*width]
    ldr.w r7, [r2, #(indx+14)*width]

    add.w r8, r4, r6
    add.w r8, r8, r10
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+0)*16*width]
    str.w r9, [r0, #(indx+1)*16*width]

.set indx, indx+2
.endr

.set indx, 0
.rept 13

    ldr.w r4, [r1, #(3+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(3+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 14
// {0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #(0)*width]
    ldr.w r5, [r1, #(1)*width]
    ldr.w r6, [r2, #(14)*width]
    ldr.w r7, [r2, #(15)*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

    add.w r9, r5, r7
    add.w r9, r9, r10
    sub.w r10, r5, r7

    asr.w r9, r9, #6
    str.w r9, [r0, #(1)*16*width]

.set indx, 0
.rept 7

    ldr.w r4, [r1, #(indx+2)*width]
    ldr.w r5, [r1, #(indx+3)*width]
    ldr.w r6, [r2, #(indx+0)*width]
    ldr.w r7, [r2, #(indx+1)*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    sub.w r9, r5, r7
    add.w r9, r9, r10
    add.w r10, r5, r7

    asr.w r8, r8, #6
    asr.w r9, r9, #6
    str.w r8, [r0, #(indx+2)*16*width]
    str.w r9, [r0, #(indx+3)*16*width]

.set indx, indx+2
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width

// ================
// 15
// {0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

    ldr.w r4, [r1, #0*width]
    ldr.w r6, [r2, #15*width]

    add.w r11, r4, r6
    sub.w r10, r4, r6

.set indx, 0
.rept 15

    ldr.w r4, [r1, #(1+indx)*width]
    ldr.w r6, [r2, #indx*width]

    sub.w r8, r4, r6
    add.w r8, r8, r10
    add.w r10, r4, r6

    asr.w r8, r8, #6
    str.w r8, [r0, #(1+indx)*16*width]

.set indx, indx+1
.endr

    sub.w r11, r11, r10
    asr.w r11, r11, #6
    str.w r11, [r0, #0*16*width]

    add.w r0, r0, #width
    add.w r1, r1, #16*width
    add.w r2, r2, #16*width


    pop.w {r4-r12, pc}

















