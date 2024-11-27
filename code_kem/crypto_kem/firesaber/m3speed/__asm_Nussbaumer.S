
#include "macros.i"

.syntax unified


// 0
// 0, 8
// 0, 8, 4, 12
// 0, 8, 4, 12, 2, 10, 6, 14
// 0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15
.align 4
.global __asm_Nussbaumer_neg256_0_1_2_3_4
.type __asm_Nussbaumer_neg256_0_1_2_3_4, %function
__asm_Nussbaumer_neg256_0_1_2_3_4:
    push.w {r4-r12, lr}

    .equ width, 4

// ================

.rept 4

.set indx, 0
.rept 4

    ldr.w  r4, [r2, #( 0+ 0*16+indx*16)*width]
    ldr.w  r5, [r2, #( 0+ 8*16+indx*16)*width]
    ldr.w  r6, [r2, #( 4+ 4*16+indx*16)*width]
    ldr.w  r7, [r2, #( 4+12*16+indx*16)*width]
    ldr.w  r8, [r2, #( 8+ 0*16+indx*16)*width]
    ldr.w  r9, [r2, #( 8+ 8*16+indx*16)*width]
    ldr.w r10, [r2, #(12+ 4*16+indx*16)*width]
    ldr.w r11, [r2, #(12+12*16+indx*16)*width]

    // 0, 0
    sub_add1 r4, r9
    // 8, 8
    add_sub1 r5, r8
    // 4, 4
    sub_add1 r6, r11
    // 12, 12
    add_sub1 r7, r10

    // 0, 0
    sub_add1 r4, r7
    // 8, 8
    add_sub1 r5, r6

    // 8, 8
    sub_add1 r8, r10
    // 0, 0
    sub_add1 r9, r11

    str.w  r4, [r1, #(256+ 0*16+0+indx)*width]
    str.w  r5, [r1, #(256+ 0*16+8+indx)*width]
    str.w  r6, [r1, #(256+ 4*16+8+indx)*width]
    str.w  r7, [r1, #(256+ 4*16+0+indx)*width]
    str.w  r8, [r1, #(256+ 8*16+8+indx)*width]
    str.w  r9, [r1, #(256+ 8*16+0+indx)*width]
    str.w r10, [r1, #(256+12*16+8+indx)*width]
    str.w r11, [r1, #(256+12*16+0+indx)*width]

.set indx, indx+1
.endr

.set indx, 0
.rept 4

    ldr.w  r4, [r2, #( 0+ 4*16+indx*16)*width]
    ldr.w  r5, [r2, #( 0+12*16+indx*16)*width]
    ldr.w  r6, [r2, #( 4+ 0*16+indx*16)*width]
    ldr.w  r7, [r2, #( 4+ 8*16+indx*16)*width]
    ldr.w  r8, [r2, #( 8+ 4*16+indx*16)*width]
    ldr.w  r9, [r2, #( 8+12*16+indx*16)*width]
    ldr.w r10, [r2, #(12+ 0*16+indx*16)*width]
    ldr.w r11, [r2, #(12+ 8*16+indx*16)*width]

    // 4, 4
    sub_add1 r4, r9
    // 12, 12
    add_sub1 r5, r8
    // 0, 0
    sub_add1 r6, r11
    // 8, 8
    add_sub1 r7, r10

    // 4, 4
    add_sub1 r4, r6
    // 12, 12
    add_sub1 r5, r7
    // 12, 12
    add_sub1 r8, r11
    // 4, 4
    sub_add1 r9, r10

    str.w  r4, [r1, #(256+ 0*16+ 4+indx)*width]
    str.w  r5, [r1, #(256+ 0*16+12+indx)*width]
    str.w  r6, [r1, #(256+ 4*16+ 4+indx)*width]
    str.w  r7, [r1, #(256+ 4*16+12+indx)*width]
    str.w  r8, [r1, #(256+ 8*16+12+indx)*width]
    str.w  r9, [r1, #(256+ 8*16+ 4+indx)*width]
    str.w r10, [r1, #(256+12*16+ 4+indx)*width]
    str.w r11, [r1, #(256+12*16+12+indx)*width]

.set indx, indx+1
.endr

.set indx, 0
.rept 8

    ldr.w  r4, [r2, #( 0+ 0*16+indx*16)*width]
    ldr.w  r5, [r2, #( 0+ 8*16+indx*16)*width]
    ldr.w  r6, [r2, #( 4+ 0*16+indx*16)*width]
    ldr.w  r7, [r2, #( 4+ 8*16+indx*16)*width]
    ldr.w  r8, [r2, #( 8+ 0*16+indx*16)*width]
    ldr.w  r9, [r2, #( 8+ 8*16+indx*16)*width]
    ldr.w r10, [r2, #(12+ 0*16+indx*16)*width]
    ldr.w r11, [r2, #(12+ 8*16+indx*16)*width]

    // 0, 0, 8, 8, 0, 0, 8, 8
    add_sub4 r4, r8, r5, r9, r6, r10, r7, r11

    // 0, 0, 8, 8
    add_sub2 r4, r6, r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    add_sub1 r9, r10

    str.w  r4, [r1, #( 0*16+ 0+indx)*width]
    str.w  r5, [r1, #( 0*16+ 8+indx)*width]
    str.w  r6, [r1, #( 4*16+ 0+indx)*width]
    str.w  r7, [r1, #( 4*16+ 8+indx)*width]
    str.w  r8, [r1, #( 8*16+ 0+indx)*width]
    str.w  r9, [r1, #( 8*16+ 8+indx)*width]
    str.w r10, [r1, #(12*16+ 8+indx)*width]
    str.w r11, [r1, #(12*16+ 0+indx)*width]

.set indx, indx+1
.endr

    add.w r2, r2, #width
    add.w r1, r1, #16*width

.endr

    sub.w r1, r1, #4*16*width

// ================

// ========
// 0, 0, 8

.set indx, 0
.rept 8

    ldr.w  r4, [r1, #( 0*16+ 0+indx)*width]
    ldr.w  r5, [r1, #( 0*16+ 8+indx)*width]
    ldr.w  r6, [r1, #( 1*16+ 0+indx)*width]
    ldr.w  r7, [r1, #( 1*16+ 8+indx)*width]
    ldr.w  r8, [r1, #( 2*16+ 0+indx)*width]
    ldr.w  r9, [r1, #( 2*16+ 8+indx)*width]
    ldr.w r10, [r1, #( 3*16+ 0+indx)*width]
    ldr.w r11, [r1, #( 3*16+ 8+indx)*width]

    // 0, 0, 8, 8, 0, 0, 8, 8
    add_sub4 r4, r8, r5, r9, r6, r10, r7, r11

    // 0, 0, 8, 8
    add_sub2 r4, r6, r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    add_sub1 r9, r10

    str.w  r4, [r0, #( 0*16+ 0+indx)*width]
    str.w  r5, [r0, #( 0*16+ 8+indx)*width]
    str.w  r6, [r0, #( 1*16+ 0+indx)*width]
    str.w  r7, [r0, #( 1*16+ 8+indx)*width]
    str.w  r8, [r0, #( 2*16+ 0+indx)*width]
    str.w  r9, [r0, #( 2*16+ 8+indx)*width]
    str.w r10, [r0, #( 3*16+ 8+indx)*width]
    str.w r11, [r0, #( 3*16+ 0+indx)*width]

.set indx, indx+1
.endr

// ========
// 8, 4, 12

.set indx, 0
.rept 4

    ldr.w  r4, [r1, #( 4*16+ 0+indx)*width]
    ldr.w  r5, [r1, #( 4*16+ 8+indx)*width]
    ldr.w  r6, [r1, #( 5*16+ 4+indx)*width]
    ldr.w  r7, [r1, #( 5*16+12+indx)*width]
    ldr.w  r8, [r1, #( 6*16+ 0+indx)*width]
    ldr.w  r9, [r1, #( 6*16+ 8+indx)*width]
    ldr.w r10, [r1, #( 7*16+ 4+indx)*width]
    ldr.w r11, [r1, #( 7*16+12+indx)*width]

    // 0, 0
    sub_add1 r4, r9
    // 8, 8
    add_sub1 r5, r8
    // 4, 4
    sub_add1 r6, r11
    // 12, 12
    add_sub1 r7, r10

    // 0, 0
    sub_add1 r4, r7
    // 8, 8
    add_sub1 r5, r6
    // 8, 8
    sub_add1 r8, r10
    // 0, 0
    sub_add1 r9, r11

    str.w  r4, [r0, #( 4*16+ 0+indx)*width]
    str.w  r5, [r0, #( 4*16+ 8+indx)*width]
    str.w  r6, [r0, #( 5*16+ 8+indx)*width]
    str.w  r7, [r0, #( 5*16+ 0+indx)*width]
    str.w  r8, [r0, #( 6*16+ 8+indx)*width]
    str.w  r9, [r0, #( 6*16+ 0+indx)*width]
    str.w r10, [r0, #( 7*16+ 8+indx)*width]
    str.w r11, [r0, #( 7*16+ 0+indx)*width]

.set indx, indx+1
.endr

.set indx, 0
.rept 4

    ldr.w  r4, [r1, #( 4*16+ 4+indx)*width]
    ldr.w  r5, [r1, #( 4*16+12+indx)*width]
    ldr.w  r6, [r1, #( 5*16+ 0+indx)*width]
    ldr.w  r7, [r1, #( 5*16+ 8+indx)*width]
    ldr.w  r8, [r1, #( 6*16+ 4+indx)*width]
    ldr.w  r9, [r1, #( 6*16+12+indx)*width]
    ldr.w r10, [r1, #( 7*16+ 0+indx)*width]
    ldr.w r11, [r1, #( 7*16+ 8+indx)*width]

    // 4, 4
    sub_add1 r4, r9
    // 12, 12
    add_sub1 r5, r8
    // 0, 0
    sub_add1 r6, r11
    // 8, 8
    add_sub1 r7, r10

    // 4, 4
    add_sub1 r4, r6
    // 12, 12
    add_sub1 r5, r7
    // 12, 12
    add_sub1 r8, r11
    // 4, 4
    sub_add1 r9, r10

    str.w  r4, [r0, #( 4*16+ 4+indx)*width]
    str.w  r5, [r0, #( 4*16+12+indx)*width]
    str.w  r6, [r0, #( 5*16+ 4+indx)*width]
    str.w  r7, [r0, #( 5*16+12+indx)*width]
    str.w  r8, [r0, #( 6*16+12+indx)*width]
    str.w  r9, [r0, #( 6*16+ 4+indx)*width]
    str.w r10, [r0, #( 7*16+ 4+indx)*width]
    str.w r11, [r0, #( 7*16+12+indx)*width]

.set indx, indx+1
.endr

// ========
// 4, 2, 10
// 0, 14, 12, 10
// 8, 6, 4, 2

.rept 2

    ldr.w  r4, [r1, #( 8*16+ 0)*width]
    ldr.w  r5, [r1, #( 8*16+ 8)*width]
    ldr.w  r6, [r1, #( 9*16+14)*width]
    ldr.w  r7, [r1, #( 9*16+ 6)*width]
    ldr.w  r8, [r1, #(10*16+12)*width]
    ldr.w  r9, [r1, #(10*16+ 4)*width]
    ldr.w r10, [r1, #(11*16+10)*width]
    ldr.w r11, [r1, #(11*16+ 2)*width]

    // 0, 0
    sub_add1 r4, r8
    // 8, 8
    add_sub1 r5, r9
    // 14, 14
    add_sub1 r6, r10
    // 6, 6
    add_sub1 r7, r11

    // 0, 0
    sub_add1 r4, r6
    // 8, 8
    add_sub1 r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    sub_add1 r9, r10

    str.w  r4, [r0, #( 8*16+ 0)*width]
    str.w  r5, [r0, #( 8*16+ 8)*width]
    str.w  r6, [r0, #( 9*16+ 0)*width]
    str.w  r7, [r0, #( 9*16+ 8)*width]
    str.w  r8, [r0, #(10*16+ 0)*width]
    str.w  r9, [r0, #(10*16+ 8)*width]
    str.w r10, [r0, #(11*16+ 8)*width]
    str.w r11, [r0, #(11*16+ 0)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 4, 2, 10
// 2, 0, 14, 12
// 10, 8, 6, 4

.rept 2

    ldr.w  r4, [r1, #( 8*16+ 2)*width]
    ldr.w  r5, [r1, #( 8*16+10)*width]
    ldr.w  r6, [r1, #( 9*16+ 0)*width]
    ldr.w  r7, [r1, #( 9*16+ 8)*width]
    ldr.w  r8, [r1, #(10*16+14)*width]
    ldr.w  r9, [r1, #(10*16+ 6)*width]
    ldr.w r10, [r1, #(11*16+12)*width]
    ldr.w r11, [r1, #(11*16+ 4)*width]

    // 2, 2
    sub_add1 r4, r8
    // 10, 10
    add_sub1 r5, r9
    // 0, 0
    sub_add1 r6, r10
    // 8, 8
    add_sub1 r7, r11

    // 2, 2
    add_sub1 r4, r6
    // 10, 10
    add_sub1 r5, r7
    // 2, 2
    sub_add1 r8, r11
    // 10, 10
    add_sub1 r9, r10

    str.w  r4, [r0, #( 8*16+ 2)*width]
    str.w  r5, [r0, #( 8*16+10)*width]
    str.w  r6, [r0, #( 9*16+ 2)*width]
    str.w  r7, [r0, #( 9*16+10)*width]
    str.w  r8, [r0, #(10*16+ 2)*width]
    str.w  r9, [r0, #(10*16+10)*width]
    str.w r10, [r0, #(11*16+10)*width]
    str.w r11, [r0, #(11*16+ 2)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 4, 2, 10
// 4, 2, 0, 14
// 12, 10, 8, 6

.rept 2

    ldr.w  r4, [r1, #( 8*16+ 4)*width]
    ldr.w  r5, [r1, #( 8*16+12)*width]
    ldr.w  r6, [r1, #( 9*16+ 2)*width]
    ldr.w  r7, [r1, #( 9*16+10)*width]
    ldr.w  r8, [r1, #(10*16+ 0)*width]
    ldr.w  r9, [r1, #(10*16+ 8)*width]
    ldr.w r10, [r1, #(11*16+14)*width]
    ldr.w r11, [r1, #(11*16+ 6)*width]

    // 4, 4
    add_sub1 r4, r8
    // 12, 12
    add_sub1 r5, r9
    // 2, 2
    sub_add1 r6, r10
    // 10, 10
    add_sub1 r7, r11

    // 4, 4
    add_sub1 r4, r6
    // 12, 12
    add_sub1 r5, r7
    // 4, 4
    sub_add1 r8, r11
    // 12, 12
    add_sub1 r9, r10

    str.w  r4, [r0, #( 8*16+ 4)*width]
    str.w  r5, [r0, #( 8*16+12)*width]
    str.w  r6, [r0, #( 9*16+ 4)*width]
    str.w  r7, [r0, #( 9*16+12)*width]
    str.w  r8, [r0, #(10*16+ 4)*width]
    str.w  r9, [r0, #(10*16+12)*width]
    str.w r10, [r0, #(11*16+12)*width]
    str.w r11, [r0, #(11*16+ 4)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 4, 2, 10
// 6, 4, 2, 0
// 14, 12, 10, 8

.rept 2

    ldr.w  r4, [r1, #( 8*16+ 6)*width]
    ldr.w  r5, [r1, #( 8*16+14)*width]
    ldr.w  r6, [r1, #( 9*16+ 4)*width]
    ldr.w  r7, [r1, #( 9*16+12)*width]
    ldr.w  r8, [r1, #(10*16+ 2)*width]
    ldr.w  r9, [r1, #(10*16+10)*width]
    ldr.w r10, [r1, #(11*16+ 0)*width]
    ldr.w r11, [r1, #(11*16+ 8)*width]

    // 6, 6
    add_sub1 r4, r8
    // 14, 14
    add_sub1 r5, r9
    // 4, 4
    add_sub1 r6, r10
    // 12, 12
    add_sub1 r7, r11

    // 6, 6
    add_sub1 r4, r6
    // 14, 14
    add_sub1 r5, r7
    // 6, 6
    sub_add1 r8, r11
    // 14, 14
    add_sub1 r9, r10

    str.w  r4, [r0, #( 8*16+ 6)*width]
    str.w  r5, [r0, #( 8*16+14)*width]
    str.w  r6, [r0, #( 9*16+ 6)*width]
    str.w  r7, [r0, #( 9*16+14)*width]
    str.w  r8, [r0, #(10*16+ 6)*width]
    str.w  r9, [r0, #(10*16+14)*width]
    str.w r10, [r0, #(11*16+14)*width]
    str.w r11, [r0, #(11*16+ 6)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// ========
// 12, 6, 14
// 0, 10, 4, 14
// 8, 2, 12, 6

.rept 2

    ldr.w  r4, [r1, #(12*16+ 0)*width]
    ldr.w  r5, [r1, #(12*16+ 8)*width]
    ldr.w  r6, [r1, #(13*16+10)*width]
    ldr.w  r7, [r1, #(13*16+ 2)*width]
    ldr.w  r8, [r1, #(14*16+ 4)*width]
    ldr.w  r9, [r1, #(14*16+12)*width]
    ldr.w r10, [r1, #(15*16+14)*width]
    ldr.w r11, [r1, #(15*16+ 6)*width]

    // 0, 0
    sub_add1 r4, r8
    // 8, 8
    sub_add1 r5, r9
    // 10, 10
    sub_add1 r6, r10
    // 2, 2
    sub_add1 r7, r11

    // 0, 0
    sub_add1 r4, r6
    // 8, 8
    add_sub1 r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    sub_add1 r9, r10

    str.w  r4, [r0, #(12*16+ 0)*width]
    str.w  r5, [r0, #(12*16+ 8)*width]
    str.w  r6, [r0, #(13*16+ 0)*width]
    str.w  r7, [r0, #(13*16+ 8)*width]
    str.w  r8, [r0, #(14*16+ 0)*width]
    str.w  r9, [r0, #(14*16+ 8)*width]
    str.w r10, [r0, #(15*16+ 8)*width]
    str.w r11, [r0, #(15*16+ 0)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 12, 6, 14
// 2, 12, 6, 0
// 10, 4, 14, 8

.rept 2

    ldr.w  r4, [r1, #(12*16+ 2)*width]
    ldr.w  r5, [r1, #(12*16+10)*width]
    ldr.w  r6, [r1, #(13*16+12)*width]
    ldr.w  r7, [r1, #(13*16+ 4)*width]
    ldr.w  r8, [r1, #(14*16+ 6)*width]
    ldr.w  r9, [r1, #(14*16+14)*width]
    ldr.w r10, [r1, #(15*16+ 0)*width]
    ldr.w r11, [r1, #(15*16+ 8)*width]

    // 2, 2
    sub_add1 r4, r8
    // 10, 10
    sub_add1 r5, r9
    // 12, 12
    add_sub1 r6, r10
    // 4, 4
    sub_add1 r7, r11

    // 2, 2
    sub_add1 r4, r6
    // 10, 10
    add_sub1 r5, r7
    // 2, 2
    sub_add1 r8, r11
    // 10, 10
    sub_add1 r9, r10

    str.w  r4, [r0, #(12*16+ 2)*width]
    str.w  r5, [r0, #(12*16+10)*width]
    str.w  r6, [r0, #(13*16+ 2)*width]
    str.w  r7, [r0, #(13*16+10)*width]
    str.w  r8, [r0, #(14*16+ 2)*width]
    str.w  r9, [r0, #(14*16+10)*width]
    str.w r10, [r0, #(15*16+10)*width]
    str.w r11, [r0, #(15*16+ 2)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 12, 6, 14
// 4, 14, 8, 2
// 12, 6, 0, 10

.rept 2

    ldr.w  r4, [r1, #(12*16+ 4)*width]
    ldr.w  r5, [r1, #(12*16+12)*width]
    ldr.w  r6, [r1, #(13*16+14)*width]
    ldr.w  r7, [r1, #(13*16+ 6)*width]
    ldr.w  r8, [r1, #(14*16+ 8)*width]
    ldr.w  r9, [r1, #(14*16+ 0)*width]
    ldr.w r10, [r1, #(15*16+ 2)*width]
    ldr.w r11, [r1, #(15*16+10)*width]

    // 4, 4
    sub_add1 r4, r8
    // 12, 12
    add_sub1 r5, r9
    // 14, 14
    add_sub1 r6, r10
    // 6, 6
    sub_add1 r7, r11

    // 4, 4
    sub_add1 r4, r6
    // 12, 12
    add_sub1 r5, r7
    // 4, 4
    sub_add1 r8, r11
    // 12, 12
    sub_add1 r9, r10

    str.w  r4, [r0, #(12*16+ 4)*width]
    str.w  r5, [r0, #(12*16+12)*width]
    str.w  r6, [r0, #(13*16+ 4)*width]
    str.w  r7, [r0, #(13*16+12)*width]
    str.w  r8, [r0, #(14*16+ 4)*width]
    str.w  r9, [r0, #(14*16+12)*width]
    str.w r10, [r0, #(15*16+12)*width]
    str.w r11, [r0, #(15*16+ 4)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 12, 6, 14
// 6, 0, 10, 4
// 14, 8, 2, 12

.rept 2

    ldr.w  r4, [r1, #(12*16+ 6)*width]
    ldr.w  r5, [r1, #(12*16+14)*width]
    ldr.w  r6, [r1, #(13*16+ 0)*width]
    ldr.w  r7, [r1, #(13*16+ 8)*width]
    ldr.w  r8, [r1, #(14*16+10)*width]
    ldr.w  r9, [r1, #(14*16+ 2)*width]
    ldr.w r10, [r1, #(15*16+ 4)*width]
    ldr.w r11, [r1, #(15*16+12)*width]

    // 6, 6
    sub_add1 r4, r8
    // 14, 14
    add_sub1 r5, r9
    // 0, 0
    sub_add1 r6, r10
    // 8, 8
    sub_add1 r7, r11

    // 6, 6
    add_sub1 r4, r6
    // 14, 14
    add_sub1 r5, r7
    // 6, 6
    sub_add1 r8, r11
    // 14, 14
    add_sub1 r9, r10

    str.w  r4, [r0, #(12*16+ 6)*width]
    str.w  r5, [r0, #(12*16+14)*width]
    str.w  r6, [r0, #(13*16+ 6)*width]
    str.w  r7, [r0, #(13*16+14)*width]
    str.w  r8, [r0, #(14*16+ 6)*width]
    str.w  r9, [r0, #(14*16+14)*width]
    str.w r10, [r0, #(15*16+14)*width]
    str.w r11, [r0, #(15*16+ 6)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// ========
// 2, 1, 9
// 0, 15, 14, 13
// 8, 7, 6, 5

    ldr.w  r4, [r1, #(16*16+ 0)*width]
    ldr.w  r5, [r1, #(16*16+ 8)*width]
    ldr.w  r6, [r1, #(17*16+15)*width]
    ldr.w  r7, [r1, #(17*16+ 7)*width]
    ldr.w  r8, [r1, #(18*16+14)*width]
    ldr.w  r9, [r1, #(18*16+ 6)*width]
    ldr.w r10, [r1, #(19*16+13)*width]
    ldr.w r11, [r1, #(19*16+ 5)*width]

    // 0, 0
    sub_add1 r4, r8
    // 8, 8
    add_sub1 r5, r9
    // 15, 15
    add_sub1 r6, r10
    // 7, 7
    add_sub1 r7, r11

    // 0, 0
    sub_add1 r4, r6
    // 8, 8
    add_sub1 r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    sub_add1 r9, r10

    str.w  r4, [r0, #(16*16+ 0)*width]
    str.w  r5, [r0, #(16*16+ 8)*width]
    str.w  r6, [r0, #(17*16+ 0)*width]
    str.w  r7, [r0, #(17*16+ 8)*width]
    str.w  r8, [r0, #(18*16+ 0)*width]
    str.w  r9, [r0, #(18*16+ 8)*width]
    str.w r10, [r0, #(19*16+ 8)*width]
    str.w r11, [r0, #(19*16+ 0)*width]

// 2, 1, 9
// 1, 0, 15, 14
// 9, 8, 7, 6

    ldr.w  r4, [r1, #(16*16+ 1)*width]
    ldr.w  r5, [r1, #(16*16+ 9)*width]
    ldr.w  r6, [r1, #(17*16+ 0)*width]
    ldr.w  r7, [r1, #(17*16+ 8)*width]
    ldr.w  r8, [r1, #(18*16+15)*width]
    ldr.w  r9, [r1, #(18*16+ 7)*width]
    ldr.w r10, [r1, #(19*16+14)*width]
    ldr.w r11, [r1, #(19*16+ 6)*width]

    // 1, 1
    sub_add1 r4, r8
    // 9, 9
    add_sub1 r5, r9
    // 0, 0
    sub_add1 r6, r10
    // 8, 8
    add_sub1 r7, r11

    // 1, 1
    add_sub1 r4, r6
    // 9, 9
    add_sub1 r5, r7
    // 1, 1
    sub_add1 r8, r11
    // 9, 9
    add_sub1 r9, r10

    str.w  r4, [r0, #(16*16+ 1)*width]
    str.w  r5, [r0, #(16*16+ 9)*width]
    str.w  r6, [r0, #(17*16+ 1)*width]
    str.w  r7, [r0, #(17*16+ 9)*width]
    str.w  r8, [r0, #(18*16+ 1)*width]
    str.w  r9, [r0, #(18*16+ 9)*width]
    str.w r10, [r0, #(19*16+ 9)*width]
    str.w r11, [r0, #(19*16+ 1)*width]

// 2, 1, 9
// 2, 1, 0, 15
// 10, 9, 8, 7

    ldr.w  r4, [r1, #(16*16+ 2)*width]
    ldr.w  r5, [r1, #(16*16+10)*width]
    ldr.w  r6, [r1, #(17*16+ 1)*width]
    ldr.w  r7, [r1, #(17*16+ 9)*width]
    ldr.w  r8, [r1, #(18*16+ 0)*width]
    ldr.w  r9, [r1, #(18*16+ 8)*width]
    ldr.w r10, [r1, #(19*16+15)*width]
    ldr.w r11, [r1, #(19*16+ 7)*width]

    // 2, 2
    add_sub1 r4, r8
    // 10, 10
    add_sub1 r5, r9
    // 1, 1
    sub_add1 r6, r10
    // 9, 9
    add_sub1 r7, r11

    // 2, 2
    add_sub1 r4, r6
    // 10, 10
    add_sub1 r5, r7
    // 2, 2
    sub_add1 r8, r11
    // 10, 10
    add_sub1 r9, r10

    str.w  r4, [r0, #(16*16+ 2)*width]
    str.w  r5, [r0, #(16*16+10)*width]
    str.w  r6, [r0, #(17*16+ 2)*width]
    str.w  r7, [r0, #(17*16+10)*width]
    str.w  r8, [r0, #(18*16+ 2)*width]
    str.w  r9, [r0, #(18*16+10)*width]
    str.w r10, [r0, #(19*16+10)*width]
    str.w r11, [r0, #(19*16+ 2)*width]

// 2, 1, 9
// 3, 2, 1, 0
// 11, 10, 9, 8

.set indx, 0
.rept 5

    ldr.w  r4, [r1, #(16*16+ 3+indx)*width]
    ldr.w  r5, [r1, #(16*16+11+indx)*width]
    ldr.w  r6, [r1, #(17*16+ 2+indx)*width]
    ldr.w  r7, [r1, #(17*16+10+indx)*width]
    ldr.w  r8, [r1, #(18*16+ 1+indx)*width]
    ldr.w  r9, [r1, #(18*16+ 9+indx)*width]
    ldr.w r10, [r1, #(19*16+ 0+indx)*width]
    ldr.w r11, [r1, #(19*16+ 8+indx)*width]

    // 3, 3
    add_sub1 r4, r8
    // 11, 11
    add_sub1 r5, r9
    // 2, 2
    add_sub1 r6, r10
    // 10, 10
    add_sub1 r7, r11

    // 3, 3
    add_sub1 r4, r6
    // 11, 11
    add_sub1 r5, r7
    // 3, 3
    sub_add1 r8, r11
    // 11, 11
    add_sub1 r9, r10

    str.w  r4, [r0, #(16*16+ 3+indx)*width]
    str.w  r5, [r0, #(16*16+11+indx)*width]
    str.w  r6, [r0, #(17*16+ 3+indx)*width]
    str.w  r7, [r0, #(17*16+11+indx)*width]
    str.w  r8, [r0, #(18*16+ 3+indx)*width]
    str.w  r9, [r0, #(18*16+11+indx)*width]
    str.w r10, [r0, #(19*16+11+indx)*width]
    str.w r11, [r0, #(19*16+ 3+indx)*width]

.set indx, indx+1
.endr

// ========
// 10, 5, 13
// 0, 11, 6, 1
// 8, 3, 14, 9

.rept 2

    ldr.w  r4, [r1, #(20*16+ 0)*width]
    ldr.w  r5, [r1, #(20*16+ 8)*width]
    ldr.w  r6, [r1, #(21*16+11)*width]
    ldr.w  r7, [r1, #(21*16+ 3)*width]
    ldr.w  r8, [r1, #(22*16+ 6)*width]
    ldr.w  r9, [r1, #(22*16+14)*width]
    ldr.w r10, [r1, #(23*16+ 1)*width]
    ldr.w r11, [r1, #(23*16+ 9)*width]

    // 0, 0
    sub_add1 r4, r8
    // 8, 8
    sub_add1 r5, r9
    // 11, 11
    add_sub1 r6, r10
    // 3, 3
    sub_add1 r7, r11

    // 0, 0
    sub_add1 r4, r6
    // 8, 8
    add_sub1 r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    sub_add1 r9, r10

    str.w  r4, [r0, #(20*16+ 0)*width]
    str.w  r5, [r0, #(20*16+ 8)*width]
    str.w  r6, [r0, #(21*16+ 0)*width]
    str.w  r7, [r0, #(21*16+ 8)*width]
    str.w  r8, [r0, #(22*16+ 0)*width]
    str.w  r9, [r0, #(22*16+ 8)*width]
    str.w r10, [r0, #(23*16+ 8)*width]
    str.w r11, [r0, #(23*16+ 0)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 10, 5, 13
// 2, 13, 8, 3
// 10, 5, 0, 11

.set indx, 0
.rept 3

    ldr.w  r4, [r1, #(20*16+ 2+indx)*width]
    ldr.w  r5, [r1, #(20*16+10+indx)*width]
    ldr.w  r6, [r1, #(21*16+13+indx)*width]
    ldr.w  r7, [r1, #(21*16+ 5+indx)*width]
    ldr.w  r8, [r1, #(22*16+ 8+indx)*width]
    ldr.w  r9, [r1, #(22*16+ 0+indx)*width]
    ldr.w r10, [r1, #(23*16+ 3+indx)*width]
    ldr.w r11, [r1, #(23*16+11+indx)*width]

    // 2, 2
    sub_add1 r4, r8
    // 10, 10
    add_sub1 r5, r9
    // 13, 13
    add_sub1 r6, r10
    // 5, 5
    sub_add1 r7, r11

    // 2, 2
    sub_add1 r4, r6
    // 10, 10
    add_sub1 r5, r7
    // 2, 2
    sub_add1 r8, r11
    // 10, 10
    sub_add1 r9, r10

    str.w  r4, [r0, #(20*16+ 2+indx)*width]
    str.w  r5, [r0, #(20*16+10+indx)*width]
    str.w  r6, [r0, #(21*16+ 2+indx)*width]
    str.w  r7, [r0, #(21*16+10+indx)*width]
    str.w  r8, [r0, #(22*16+ 2+indx)*width]
    str.w  r9, [r0, #(22*16+10+indx)*width]
    str.w r10, [r0, #(23*16+10+indx)*width]
    str.w r11, [r0, #(23*16+ 2+indx)*width]

.set indx, indx+1
.endr

// 10, 5, 13
// 5, 0, 11, 6
// 13, 8, 3, 14

.rept 2

    ldr.w  r4, [r1, #(20*16+ 5)*width]
    ldr.w  r5, [r1, #(20*16+13)*width]
    ldr.w  r6, [r1, #(21*16+ 0)*width]
    ldr.w  r7, [r1, #(21*16+ 8)*width]
    ldr.w  r8, [r1, #(22*16+11)*width]
    ldr.w  r9, [r1, #(22*16+ 3)*width]
    ldr.w r10, [r1, #(23*16+ 6)*width]
    ldr.w r11, [r1, #(23*16+14)*width]

    // 5, 5
    sub_add1 r4, r8
    // 13, 13
    add_sub1 r5, r9
    // 0, 0
    sub_add1 r6, r10
    // 8, 8
    sub_add1 r7, r11

    // 5, 5
    add_sub1 r4, r6
    // 13, 13
    add_sub1 r5, r7
    // 5, 5
    sub_add1 r8, r11
    // 13, 13
    add_sub1 r9, r10

    str.w  r4, [r0, #(20*16+ 5)*width]
    str.w  r5, [r0, #(20*16+13)*width]
    str.w  r6, [r0, #(21*16+ 5)*width]
    str.w  r7, [r0, #(21*16+13)*width]
    str.w  r8, [r0, #(22*16+ 5)*width]
    str.w  r9, [r0, #(22*16+13)*width]
    str.w r10, [r0, #(23*16+13)*width]
    str.w r11, [r0, #(23*16+ 5)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 10, 5, 13
// 7, 2, 13, 8
// 15, 10, 5, 0

    ldr.w  r4, [r1, #(20*16+ 7)*width]
    ldr.w  r5, [r1, #(20*16+15)*width]
    ldr.w  r6, [r1, #(21*16+ 2)*width]
    ldr.w  r7, [r1, #(21*16+10)*width]
    ldr.w  r8, [r1, #(22*16+13)*width]
    ldr.w  r9, [r1, #(22*16+ 5)*width]
    ldr.w r10, [r1, #(23*16+ 8)*width]
    ldr.w r11, [r1, #(23*16+ 0)*width]

    // 7, 7
    sub_add1 r4, r8
    // 15, 15
    add_sub1 r5, r9
    // 2, 2
    sub_add1 r6, r10
    // 10, 10
    add_sub1 r7, r11

    // 7, 7
    add_sub1 r4, r6
    // 15, 15
    add_sub1 r5, r7
    // 7, 7
    sub_add1 r8, r11
    // 15, 15
    add_sub1 r9, r10

    str.w  r4, [r0, #(20*16+ 7)*width]
    str.w  r5, [r0, #(20*16+15)*width]
    str.w  r6, [r0, #(21*16+ 7)*width]
    str.w  r7, [r0, #(21*16+15)*width]
    str.w  r8, [r0, #(22*16+ 7)*width]
    str.w  r9, [r0, #(22*16+15)*width]
    str.w r10, [r0, #(23*16+15)*width]
    str.w r11, [r0, #(23*16+ 7)*width]

// ========
// 6, 3, 11
// 0, 13, 10, 7
// 8, 5, 2, 15

    ldr.w  r4, [r1, #(24*16+ 0)*width]
    ldr.w  r5, [r1, #(24*16+ 8)*width]
    ldr.w  r6, [r1, #(25*16+13)*width]
    ldr.w  r7, [r1, #(25*16+ 5)*width]
    ldr.w  r8, [r1, #(26*16+10)*width]
    ldr.w  r9, [r1, #(26*16+ 2)*width]
    ldr.w r10, [r1, #(27*16+ 7)*width]
    ldr.w r11, [r1, #(27*16+15)*width]

    // 0, 0
    sub_add1 r4, r8
    // 8, 8
    add_sub1 r5, r9
    // 13, 13
    add_sub1 r6, r10
    // 5, 5
    sub_add1 r7, r11

    // 0, 0
    sub_add1 r4, r6
    // 8, 8
    add_sub1 r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    sub_add1 r9, r10

    str.w  r4, [r0, #(24*16+ 0)*width]
    str.w  r5, [r0, #(24*16+ 8)*width]
    str.w  r6, [r0, #(25*16+ 0)*width]
    str.w  r7, [r0, #(25*16+ 8)*width]
    str.w  r8, [r0, #(26*16+ 0)*width]
    str.w  r9, [r0, #(26*16+ 8)*width]
    str.w r10, [r0, #(27*16+ 8)*width]
    str.w r11, [r0, #(27*16+ 0)*width]

// 6, 3, 11
// 1, 14, 11, 8
// 9, 6, 3, 0

.rept 2

    ldr.w  r4, [r1, #(24*16+ 1)*width]
    ldr.w  r5, [r1, #(24*16+ 9)*width]
    ldr.w  r6, [r1, #(25*16+14)*width]
    ldr.w  r7, [r1, #(25*16+ 6)*width]
    ldr.w  r8, [r1, #(26*16+11)*width]
    ldr.w  r9, [r1, #(26*16+ 3)*width]
    ldr.w r10, [r1, #(27*16+ 8)*width]
    ldr.w r11, [r1, #(27*16+ 0)*width]

    // 1, 1
    sub_add1 r4, r8
    // 9, 9
    add_sub1 r5, r9
    // 14, 14
    add_sub1 r6, r10
    // 6, 6
    add_sub1 r7, r11

    // 1, 1
    sub_add1 r4, r6
    // 9, 9
    add_sub1 r5, r7
    // 1, 1
    sub_add1 r8, r11
    // 9, 9
    sub_add1 r9, r10

    str.w  r4, [r0, #(24*16+ 1)*width]
    str.w  r5, [r0, #(24*16+ 9)*width]
    str.w  r6, [r0, #(25*16+ 1)*width]
    str.w  r7, [r0, #(25*16+ 9)*width]
    str.w  r8, [r0, #(26*16+ 1)*width]
    str.w  r9, [r0, #(26*16+ 9)*width]
    str.w r10, [r0, #(27*16+ 9)*width]
    str.w r11, [r0, #(27*16+ 1)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// 6, 3, 11
// 3, 0, 13, 10
// 11, 8, 5, 2

.set indx, 0
.rept 3

    ldr.w  r4, [r1, #(24*16+ 3+indx)*width]
    ldr.w  r5, [r1, #(24*16+11+indx)*width]
    ldr.w  r6, [r1, #(25*16+ 0+indx)*width]
    ldr.w  r7, [r1, #(25*16+ 8+indx)*width]
    ldr.w  r8, [r1, #(26*16+13+indx)*width]
    ldr.w  r9, [r1, #(26*16+ 5+indx)*width]
    ldr.w r10, [r1, #(27*16+10+indx)*width]
    ldr.w r11, [r1, #(27*16+ 2+indx)*width]

    // 3, 3
    sub_add1 r4, r8
    // 11, 11
    add_sub1 r5, r9
    // 0, 0
    sub_add1 r6, r10
    // 8, 8
    add_sub1 r7, r11

    // 3, 3
    add_sub1 r4, r6
    // 11, 11
    add_sub1 r5, r7
    // 3, 3
    sub_add1 r8, r11
    // 11, 11
    add_sub1 r9, r10

    str.w  r4, [r0, #(24*16+ 3+indx)*width]
    str.w  r5, [r0, #(24*16+11+indx)*width]
    str.w  r6, [r0, #(25*16+ 3+indx)*width]
    str.w  r7, [r0, #(25*16+11+indx)*width]
    str.w  r8, [r0, #(26*16+ 3+indx)*width]
    str.w  r9, [r0, #(26*16+11+indx)*width]
    str.w r10, [r0, #(27*16+11+indx)*width]
    str.w r11, [r0, #(27*16+ 3+indx)*width]

.set indx, indx+1
.endr

// 6, 3, 11
// 6, 3, 0, 13
// 14, 11, 8, 5

.rept 2

    ldr.w  r4, [r1, #(24*16+ 6)*width]
    ldr.w  r5, [r1, #(24*16+14)*width]
    ldr.w  r6, [r1, #(25*16+ 3)*width]
    ldr.w  r7, [r1, #(25*16+11)*width]
    ldr.w  r8, [r1, #(26*16+ 0)*width]
    ldr.w  r9, [r1, #(26*16+ 8)*width]
    ldr.w r10, [r1, #(27*16+13)*width]
    ldr.w r11, [r1, #(27*16+ 5)*width]

    // 6, 6
    add_sub1 r4, r8
    // 14, 14
    add_sub1 r5, r9
    // 3, 3
    sub_add1 r6, r10
    // 11, 11
    add_sub1 r7, r11

    // 6, 6
    add_sub1 r4, r6
    // 14, 14
    add_sub1 r5, r7
    // 6, 6
    sub_add1 r8, r11
    // 14, 14
    add_sub1 r9, r10

    str.w  r4, [r0, #(24*16+ 6)*width]
    str.w  r5, [r0, #(24*16+14)*width]
    str.w  r6, [r0, #(25*16+ 6)*width]
    str.w  r7, [r0, #(25*16+14)*width]
    str.w  r8, [r0, #(26*16+ 6)*width]
    str.w  r9, [r0, #(26*16+14)*width]
    str.w r10, [r0, #(27*16+14)*width]
    str.w r11, [r0, #(27*16+ 6)*width]

    add.w r1, r1, #width
    add.w r0, r0, #width

.endr

    sub.w r1, r1, #2*width
    sub.w r0, r0, #2*width

// ========
// 14, 7, 15
// 0, 9, 2, 11
// 8, 1, 10, 3

.set indx, 0
.rept 5

    ldr.w  r4, [r1, #(28*16+ 0+indx)*width]
    ldr.w  r5, [r1, #(28*16+ 8+indx)*width]
    ldr.w  r6, [r1, #(29*16+ 9+indx)*width]
    ldr.w  r7, [r1, #(29*16+ 1+indx)*width]
    ldr.w  r8, [r1, #(30*16+ 2+indx)*width]
    ldr.w  r9, [r1, #(30*16+10+indx)*width]
    ldr.w r10, [r1, #(31*16+11+indx)*width]
    ldr.w r11, [r1, #(31*16+ 3+indx)*width]

    // 0, 0
    sub_add1 r4, r8
    // 8, 8
    sub_add1 r5, r9
    // 9, 9
    sub_add1 r6, r10
    // 1, 1
    sub_add1 r7, r11

    // 0, 0
    sub_add1 r4, r6
    // 8, 8
    add_sub1 r5, r7
    // 0, 0
    sub_add1 r8, r11
    // 8, 8
    sub_add1 r9, r10

    str.w  r4, [r0, #(28*16+ 0+indx)*width]
    str.w  r5, [r0, #(28*16+ 8+indx)*width]
    str.w  r6, [r0, #(29*16+ 0+indx)*width]
    str.w  r7, [r0, #(29*16+ 8+indx)*width]
    str.w  r8, [r0, #(30*16+ 0+indx)*width]
    str.w  r9, [r0, #(30*16+ 8+indx)*width]
    str.w r10, [r0, #(31*16+ 8+indx)*width]
    str.w r11, [r0, #(31*16+ 0+indx)*width]

.set indx, indx+1
.endr

// 14, 7, 15
// 5, 14, 7, 0
// 13, 6, 15, 8

    ldr.w  r4, [r1, #(28*16+ 5)*width]
    ldr.w  r5, [r1, #(28*16+13)*width]
    ldr.w  r6, [r1, #(29*16+14)*width]
    ldr.w  r7, [r1, #(29*16+ 6)*width]
    ldr.w  r8, [r1, #(30*16+ 7)*width]
    ldr.w  r9, [r1, #(30*16+15)*width]
    ldr.w r10, [r1, #(31*16+ 0)*width]
    ldr.w r11, [r1, #(31*16+ 8)*width]

    // 5, 5
    sub_add1 r4, r8
    // 13, 13
    sub_add1 r5, r9
    // 14, 14
    add_sub1 r6, r10
    // 6, 6
    sub_add1 r7, r11

    // 5, 5
    sub_add1 r4, r6
    // 13, 13
    add_sub1 r5, r7
    // 5, 5
    sub_add1 r8, r11
    // 13, 13
    sub_add1 r9, r10

    str.w  r4, [r0, #(28*16+ 5)*width]
    str.w  r5, [r0, #(28*16+13)*width]
    str.w  r6, [r0, #(29*16+ 5)*width]
    str.w  r7, [r0, #(29*16+13)*width]
    str.w  r8, [r0, #(30*16+ 5)*width]
    str.w  r9, [r0, #(30*16+13)*width]
    str.w r10, [r0, #(31*16+13)*width]
    str.w r11, [r0, #(31*16+ 5)*width]

// 14, 7, 15
// 6, 15, 8, 1
// 14, 7, 0, 9

    ldr.w  r4, [r1, #(28*16+ 6)*width]
    ldr.w  r5, [r1, #(28*16+14)*width]
    ldr.w  r6, [r1, #(29*16+15)*width]
    ldr.w  r7, [r1, #(29*16+ 7)*width]
    ldr.w  r8, [r1, #(30*16+ 8)*width]
    ldr.w  r9, [r1, #(30*16+ 0)*width]
    ldr.w r10, [r1, #(31*16+ 1)*width]
    ldr.w r11, [r1, #(31*16+ 9)*width]

    // 6, 6
    sub_add1 r4, r8
    // 14, 14
    add_sub1 r5, r9
    // 15, 15
    add_sub1 r6, r10
    // 7, 7
    sub_add1 r7, r11

    // 6, 6
    sub_add1 r4, r6
    // 14, 14
    add_sub1 r5, r7
    // 6, 6
    sub_add1 r8, r11
    // 14, 14
    sub_add1 r9, r10

    str.w  r4, [r0, #(28*16+ 6)*width]
    str.w  r5, [r0, #(28*16+14)*width]
    str.w  r6, [r0, #(29*16+ 6)*width]
    str.w  r7, [r0, #(29*16+14)*width]
    str.w  r8, [r0, #(30*16+ 6)*width]
    str.w  r9, [r0, #(30*16+14)*width]
    str.w r10, [r0, #(31*16+14)*width]
    str.w r11, [r0, #(31*16+ 6)*width]

// 14, 7, 15
// 7, 0, 9, 2
// 15, 8, 1, 10

    ldr.w  r4, [r1, #(28*16+ 7)*width]
    ldr.w  r5, [r1, #(28*16+15)*width]
    ldr.w  r6, [r1, #(29*16+ 0)*width]
    ldr.w  r7, [r1, #(29*16+ 8)*width]
    ldr.w  r8, [r1, #(30*16+ 9)*width]
    ldr.w  r9, [r1, #(30*16+ 1)*width]
    ldr.w r10, [r1, #(31*16+ 2)*width]
    ldr.w r11, [r1, #(31*16+10)*width]

    // 7, 7
    sub_add1 r4, r8
    // 15, 15
    add_sub1 r5, r9
    // 0, 0
    sub_add1 r6, r10
    // 8, 8
    sub_add1 r7, r11

    // 7, 7
    add_sub1 r4, r6
    // 15, 15
    add_sub1 r5, r7
    // 7, 7
    sub_add1 r8, r11
    // 15, 15
    add_sub1 r9, r10

    str.w  r4, [r0, #(28*16+ 7)*width]
    str.w  r5, [r0, #(28*16+15)*width]
    str.w  r6, [r0, #(29*16+ 7)*width]
    str.w  r7, [r0, #(29*16+15)*width]
    str.w  r8, [r0, #(30*16+ 7)*width]
    str.w  r9, [r0, #(30*16+15)*width]
    str.w r10, [r0, #(31*16+15)*width]
    str.w r11, [r0, #(31*16+ 7)*width]

// ================

    pop.w {r4-r12, pc}



















