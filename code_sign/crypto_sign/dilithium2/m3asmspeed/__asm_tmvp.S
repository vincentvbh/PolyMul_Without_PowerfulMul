
#include "macros.i"

.syntax unified
.cpu cortex-m3

// TC4 with {0, 1, -1, 2, -2, 1/2, \infty}
// .align 4
// .global __asm_TC4_16
// .type __asm_TC4_16, %function
// __asm_TC4_16:
//     push.w {r4-r12, lr}

// .rept 4

//     ldr.w r4, [r1, # 0*4]
//     ldr.w r5, [r1, # 4*4]
//     ldr.w r6, [r1, # 8*4]
//     ldr.w r7, [r1, #12*4]

//     str.w r7, [r0, #24*4]

//     add.w r9, r7, r6, lsl #1
//     add.w r9, r9, r5, lsl #2
//     add.w r9, r9, r4, lsl #3

//     str.w r9, [r0, #20*4]

//     add.w r8, r4, r6, lsl #2
//     add.w r9, r5, r7, lsl #2
//     add.w r8, r8, r9, lsl #1
//     sub.w r9, r8, r9, lsl #2

//     str.w r9, [r0, #16*4]
//     str.w r8, [r0, #12*4]

//     add.w r8, r4, r6
//     add.w r9, r5, r7
//     add.w r8, r8, r9
//     sub.w r9, r8, r9, lsl #1

//     str.w r9, [r0, # 8*4]
//     str.w r8, [r0, # 4*4]

//     str.w r4, [r0, # 0*4]

//     add.w r0, r0, #4
//     add.w r1, r1, #4

// .endr

//     pop.w {r4-r12, pc}

.align 4
.global __asm_TC4_16_full
.type __asm_TC4_16_full, %function
__asm_TC4_16_full:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov r3, #32
    _TC4_16_loop:
#else
.rept 32
#endif

.rept 4

    ldr.w r4, [r1, # 0*4]
    ldr.w r5, [r1, # 4*4]
    ldr.w r6, [r1, # 8*4]
    ldr.w r7, [r1, #12*4]

    str.w r7, [r0, #24*4]

    add.w r9, r7, r6, lsl #1
    add.w r9, r9, r5, lsl #2
    add.w r9, r9, r4, lsl #3

    str.w r9, [r0, #20*4]

    add.w r8, r4, r6, lsl #2
    add.w r9, r5, r7, lsl #2
    add.w r8, r8, r9, lsl #1
    sub.w r9, r8, r9, lsl #2

    str.w r9, [r0, #16*4]
    str.w r8, [r0, #12*4]

    add.w r8, r4, r6
    add.w r9, r5, r7
    add.w r8, r8, r9
    sub.w r9, r8, r9, lsl #1

    str.w r9, [r0, # 8*4]
    str.w r8, [r0, # 4*4]

    str.w r4, [r0, # 0*4]

    add.w r0, r0, #4
    add.w r1, r1, #4

.endr

    add.w r0, r0, #(28-4)*4
    add.w r1, r1, #(16-4)*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _TC4_16_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}

// int32_t TC4_trunc_T_modified[7][7] = {
// { 2,  4,  4,  1,  1, 32,  0},
// { 0,  2, -2,  1, -1,  8,  0},
// { 0,  1,  1,  1,  1,  2,  0},
// { 0,  1, -1,  2, -2,  1,  1},
// { 0,  0,  0,  0,  0,  0,  0},
// { 0,  0,  0,  0,  0,  0,  0},
// { 0,  0,  0,  0,  0,  0,  0}
// };

// .align 4
// .global __asm_TC4_T_16
// .type __asm_TC4_T_16, %function
// __asm_TC4_T_16:
//     push.w {r4-r12, lr}

// .rept 4

//     ldr.w  r4, [r1, # 0*4]
//     ldr.w  r5, [r1, # 4*4]
//     ldr.w  r6, [r1, # 8*4]
//     ldr.w  r7, [r1, #12*4]
//     ldr.w  r8, [r1, #16*4]
//     ldr.w  r9, [r1, #20*4]
//     ldr.w r10, [r1, #24*4]

//     add.w r5, r5, r6
//     sub.w r6, r5, r6, lsl #1
//     add.w r7, r7, r8
//     sub.w r8, r7, r8, lsl #1

// // ========

//     add.w r11, r7, r9, lsl #5
//     add.w r11, r11, r5, lsl #2
//     add.w r11, r11, r4, lsl #1
//     asr.w r11, r11, #2

//     str.w r11, [r0, #12*4]

//     add.w r11, r8, r9, lsl #3
//     add.w r11, r11, r6, lsl #1
//     asr.w r11, r11, #1

//     str.w r11, [r0, # 8*4]

//     add.w r11, r7, r9, lsl #1
//     add.w r11, r11, r5
//     // asr.w r11, r11, #1
//     str.w r11, [r0, # 4*4]

//     add.w r11, r9, r10
//     add.w r11, r11, r8, lsl #1
//     add.w r11, r11, r6
//     // asr.w r11, r11, #1
//     str.w r11, [r0, # 0*4]


// // ========

//     add.w r0, r0, #4
//     add.w r1, r1, #4

// .endr

//     pop.w {r4-r12, pc}

.align 4
.global __asm_TC4_T_16_full
.type __asm_TC4_T_16_full, %function
__asm_TC4_T_16_full:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov r3, #32
    _TC4_T_16_loop:
#else
.rept 32
#endif

.rept 4

    ldr.w  r4, [r1, # 0*4]
    ldr.w  r5, [r1, # 4*4]
    ldr.w  r6, [r1, # 8*4]
    ldr.w  r7, [r1, #12*4]
    ldr.w  r8, [r1, #16*4]
    ldr.w  r9, [r1, #20*4]
    ldr.w r10, [r1, #24*4]

    add.w r5, r5, r6
    sub.w r6, r5, r6, lsl #1
    add.w r7, r7, r8
    sub.w r8, r7, r8, lsl #1

// ========

    add.w r11, r7, r9, lsl #5
    add.w r11, r11, r5, lsl #2
    add.w r11, r11, r4, lsl #1
    asr.w r11, r11, #2

    str.w r11, [r0, #12*4]

    add.w r11, r8, r9, lsl #3
    add.w r11, r11, r6, lsl #1
    asr.w r11, r11, #1

    str.w r11, [r0, # 8*4]

    add.w r11, r7, r9, lsl #1
    add.w r11, r11, r5
    // asr.w r11, r11, #1
    str.w r11, [r0, # 4*4]

    add.w r11, r9, r10
    add.w r11, r11, r8, lsl #1
    add.w r11, r11, r6
    // asr.w r11, r11, #1
    str.w r11, [r0, # 0*4]

// ========

    add.w r0, r0, #4
    add.w r1, r1, #4

.endr

    add.w r0, r0, #(16-4)*4
    add.w r1, r1, #(28-4)*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _TC4_T_16_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}

// ========

// diag(1, 1/3, 1/9, 1/9, 1/15, 1/45, 1)

// 4,   -8,   -5,   10,    1,    -2, 0
// 0,   -4,    4,    9,   -1,    -2, 0
// 0,   -4,   12,   -7,   -3,     2, 0
// 0,    2,   -3,   -4,    3,     2, 0
// 0,    2,   -5,    0,    5,    -2, 0
// 0,    4,    0,   -5,    0,     1, 0
// 0,   -4,    8,    5,  -10,    -1, 2

// ========

// 3^(-1) = -1431655765
// 5^(-1) = -858993459
// 9^(-1) = 954437177
// 15^(-1) = -286331153
// 45^(-1) = -1527099483

// ========

// .align 4
// .global __asm_iTC4_T_7x7
// .type __asm_iTC4_T_7x7, %function
// __asm_iTC4_T_7x7:
//     push.w {r4-r12, lr}

//     .equ INV3, -1431655765
//     .equ INV5, -858993459
//     .equ INV9, 954437177
//     .equ INV15, -286331153
//     .equ INV45, -1527099483

//     movw r8, #:lower16:INV3
//     movt r8, #:upper16:INV3

//     movw r9, #:lower16:INV9
//     movt r9, #:upper16:INV9

//     movw r10, #:lower16:INV15
//     movt r10, #:upper16:INV15

//     movw r11, #:lower16:INV45
//     movt r11, #:upper16:INV45

// // 0
// // 15, 11, 7, 3, -15, -11, -7

// .rept 4

//     ldr.w r4, [r1, #15*4]
//     ldr.w r5, [r1, #11*4]
//     ldr.w r6, [r1, # 7*4]
//     ldr.w r7, [r1, # 3*4]

// // ========

// // 1
// // 4,   -8,   -5,   10,    1,    -2, 0

//     // 3 r4 - 6 r5 - 5 r6 + 10 r7

//     sub.w r12, r6, r7, lsl #1
//     add.w r12, r12, r12, lsl #2
//     sub.w r14, r4, r5, lsl #1
//     add.w r14, r14, r14, lsl #1
//     sub.w r12, r14, r12

//     str.w r12, [r0, #0*8*4]

// // ========

// // 1/3
// // 0,   -4,    4,    9,   -1,    -2, 0

//     // r4 - 2 r5 + 4 r6 + 9 r7

//     sub.w r12, r4, r5, lsl #1
//     add.w r12, r12, r6, lsl #2
//     add.w r12, r12, r7
//     add.w r12, r12, r7, lsl #3

//     mul r12, r12, r8

//     str.w r12, [r0, #1*8*4]

// // ========

// // 1/9
// // 0,   -4,   12,   -7,   -3,     2, 0

//     // 3 r4 - 6 r5 + 12 r6 - 7 r7

//     sub.w r12, r4, r5, lsl #1
//     add.w r12, r12, r6, lsl #2
//     sub.w r12, r12, r7, lsl #1
//     add.w r12, r12, r12, lsl #1
//     sub.w r12, r12, r7

//     mul r12, r12, r9

//     str.w r12, [r0, #2*8*4]

// // ========

// // 1/9
// // 0,    2,   -3,   -4,    3,     2, 0

//     // -3 r4 - 3 r6 - 4 r7
//     add.w r12, r4, r6
//     sub.w r12, r12, r12, lsl #2
//     sub.w r12, r12, r7, lsl #2

//     mul r12, r12, r9

//     str.w r12, [r0, #3*8*4]

// // ========

// // 1/15
// // 0,    2,   -5,    0,    5,    -2, 0

//     // -5 r4 + 4 r5 - 5 r6

//     add.w r12, r4, r6
//     add.w r12, r12, r12, lsl #2
//     rsb.w r12, r12, r5, lsl #2

//     mul r12, r12, r10

//     str.w r12, [r0, #4*8*4]

// // ========

// // 1/45
// // 0,    4,    0,   -5,    0,     1, 0

//     // 3 r5 - 5 r7

//     sub.w r12, r5, r7
//     add.w r12, r12, r12, lsl #1
//     sub.w r12, r12, r7, lsl #1

//     mul r12, r12, r11

//     str.w r12, [r0, #5*8*4]

// // ========

// // 1
// // 0,   -4,    8,    5,  -10,    -1, 2

//     add.w r12, r7, r4, lsl #1
//     add.w r12, r12, r12, lsl #2
//     add.w r12, r12, r5
//     sub.w r12, r12, r6, lsl #1
//     sub.w r12, r12, r5, lsl #2
//     add.w r12, r12, r6, lsl #3

//     str.w r12, [r0, #6*8*4]

// // ========

//     add.w r0, r0, #4

//     sub.w r1, r1, #4

// .endr

//     add.w r1, r1, #4*4

// // 4
// // 11, 7, 3, -15, -11, -7, -3

// .rept 3

//     ldr.w r4, [r1, #11*4]
//     ldr.w r5, [r1, # 7*4]
//     ldr.w r6, [r1, # 3*4]
//     ldr.w r7, [r1, #15*4]

// // ========

// // 1
// // 4,   -8,   -5,   10,    1,    -2, 0

//     // 3 r4 - 6 r5 - 5 r6 - 10 r7

//     add.w r12, r6, r7, lsl #1
//     add.w r12, r12, r12, lsl #2
//     sub.w r14, r4, r5, lsl #1
//     add.w r14, r14, r14, lsl #1
//     sub.w r12, r14, r12

//     str.w r12, [r0, #0*8*4]

// // ========

// // 1/3
// // 0,   -4,    4,    9,   -1,    -2, 0

//     // r4 - 2 r5 + 4 r6 - 9 r7

//     sub.w r12, r4, r5, lsl #1
//     add.w r12, r12, r6, lsl #2
//     sub.w r12, r12, r7
//     sub.w r12, r12, r7, lsl #3

//     mul r12, r12, r8

//     str.w r12, [r0, #1*8*4]

// // ========

// // 1/9
// // 0,   -4,   12,   -7,   -3,     2, 0

//     // 3 r4 - 6 r5 + 12 r6 + 7 r7

//     sub.w r12, r4, r5, lsl #1
//     add.w r12, r12, r6, lsl #2
//     add.w r12, r12, r7, lsl #1
//     add.w r12, r12, r12, lsl #1
//     add.w r12, r12, r7

//     mul r12, r12, r9

//     str.w r12, [r0, #2*8*4]

// // ========

// // 1/9
// // 0,    2,   -3,   -4,    3,     2, 0

//     // -3 r4 - 3 r6 + 4 r7
//     add.w r12, r4, r6
//     sub.w r12, r12, r12, lsl #2
//     add.w r12, r12, r7, lsl #2

//     mul r12, r12, r9

//     str.w r12, [r0, #3*8*4]

// // ========

// // 1/15
// // 0,    2,   -5,    0,    5,    -2, 0

//     // -5 r4 + 4 r5 - 5 r6

//     add.w r12, r4, r6
//     add.w r12, r12, r12, lsl #2
//     rsb.w r12, r12, r5, lsl #2

//     mul r12, r12, r10

//     str.w r12, [r0, #4*8*4]

// // ========

// // 1/45
// // 0,    4,    0,   -5,    0,     1, 0

//     // 3 r5 + 5 r7

//     add.w r12, r5, r5, lsl #1
//     add.w r12, r12, r7
//     add.w r12, r12, r7, lsl #2

//     mul r12, r12, r11

//     str.w r12, [r0, #5*8*4]

// // ========

// // 1
// // 0,   -4,    8,    5,  -10,    -1, 2

//     // 10 r4 - 3 r5 + 6 r6 - 5 r7

//     rsb.w r12, r7, r4, lsl #1
//     add.w r12, r12, r12, lsl #2
//     rsb.w r14, r5, r6, lsl #1
//     add.w r14, r14, r14, lsl #1
//     add.w r12, r12, r14

//     str.w r12, [r0, #6*8*4]

// // ========

//     add.w r0, r0, #4
//     sub.w r1, r1, #4

// .endr


//     pop.w {r4-r12, pc}

.align 4
.global __asm_iTC4_T_7x7_full
.type __asm_iTC4_T_7x7_full, %function
__asm_iTC4_T_7x7_full:
    push.w {r4-r12, lr}

    .equ INV3, -1431655765
    .equ INV5, -858993459
    .equ INV9, 954437177
    .equ INV15, -286331153
    .equ INV45, -1527099483

    movw r8, #:lower16:INV3
    movt r8, #:upper16:INV3

    movw r9, #:lower16:INV9
    movt r9, #:upper16:INV9

    movw r10, #:lower16:INV15
    movt r10, #:upper16:INV15

    movw r11, #:lower16:INV45
    movt r11, #:upper16:INV45

#ifdef LOOP
    mov r3, #32
    _iTC4_T_7x7_loop:
#else
.rept 32
#endif

// 0
// 15, 11, 7, 3, -15, -11, -7

.rept 4

    ldr.w r4, [r1, #15*4]
    ldr.w r5, [r1, #11*4]
    ldr.w r6, [r1, # 7*4]
    ldr.w r7, [r1, # 3*4]

// ========

// 1
// 4,   -8,   -5,   10,    1,    -2, 0

    // 3 r4 - 6 r5 - 5 r6 + 10 r7

    sub.w r12, r6, r7, lsl #1
    add.w r12, r12, r12, lsl #2
    sub.w r14, r4, r5, lsl #1
    add.w r14, r14, r14, lsl #1
    sub.w r12, r14, r12

    str.w r12, [r0, #0*8*4]

// ========

// 1/3
// 0,   -4,    4,    9,   -1,    -2, 0

    // r4 - 2 r5 + 4 r6 + 9 r7

    sub.w r12, r4, r5, lsl #1
    add.w r12, r12, r6, lsl #2
    add.w r12, r12, r7
    add.w r12, r12, r7, lsl #3

    mul r12, r12, r8

    str.w r12, [r0, #1*8*4]

// ========

// 1/9
// 0,   -4,   12,   -7,   -3,     2, 0

    // 3 r4 - 6 r5 + 12 r6 - 7 r7

    sub.w r12, r4, r5, lsl #1
    add.w r12, r12, r6, lsl #2
    sub.w r12, r12, r7, lsl #1
    add.w r12, r12, r12, lsl #1
    sub.w r12, r12, r7

    mul r12, r12, r9

    str.w r12, [r0, #2*8*4]

// ========

// 1/9
// 0,    2,   -3,   -4,    3,     2, 0

    // -3 r4 - 3 r6 - 4 r7
    add.w r12, r4, r6
    sub.w r12, r12, r12, lsl #2
    sub.w r12, r12, r7, lsl #2

    mul r12, r12, r9

    str.w r12, [r0, #3*8*4]

// ========

// 1/15
// 0,    2,   -5,    0,    5,    -2, 0

    // -5 r4 + 4 r5 - 5 r6

    add.w r12, r4, r6
    add.w r12, r12, r12, lsl #2
    rsb.w r12, r12, r5, lsl #2

    mul r12, r12, r10

    str.w r12, [r0, #4*8*4]

// ========

// 1/45
// 0,    4,    0,   -5,    0,     1, 0

    // 3 r5 - 5 r7

    sub.w r12, r5, r7
    add.w r12, r12, r12, lsl #1
    sub.w r12, r12, r7, lsl #1

    mul r12, r12, r11

    str.w r12, [r0, #5*8*4]

// ========

// 1
// 0,   -4,    8,    5,  -10,    -1, 2

    // 10 r4 - 3 r5 + 6 r6 + 5 r7

    add.w r12, r7, r4, lsl #1
    add.w r12, r12, r12, lsl #2
    add.w r12, r12, r5
    sub.w r12, r12, r6, lsl #1
    sub.w r12, r12, r5, lsl #2
    add.w r12, r12, r6, lsl #3

    str.w r12, [r0, #6*8*4]

// ========

    add.w r0, r0, #4

    sub.w r1, r1, #4

.endr

    add.w r1, r1, #4*4

// 4
// 11, 7, 3, -15, -11, -7, -3

.rept 3

    ldr.w r4, [r1, #11*4]
    ldr.w r5, [r1, # 7*4]
    ldr.w r6, [r1, # 3*4]
    ldr.w r7, [r1, #15*4]

// ========

// 1
// 4,   -8,   -5,   10,    1,    -2, 0

    // 3 r4 - 6 r5 - 5 r6 - 10 r7

    add.w r12, r6, r7, lsl #1
    add.w r12, r12, r12, lsl #2
    sub.w r14, r4, r5, lsl #1
    add.w r14, r14, r14, lsl #1
    sub.w r12, r14, r12

    str.w r12, [r0, #0*8*4]

// ========

// 1/3
// 0,   -4,    4,    9,   -1,    -2, 0

    // r4 - 2 r5 + 4 r6 - 9 r7

    sub.w r12, r4, r5, lsl #1
    add.w r12, r12, r6, lsl #2
    sub.w r12, r12, r7
    sub.w r12, r12, r7, lsl #3

    mul r12, r12, r8

    str.w r12, [r0, #1*8*4]

// ========

// 1/9
// 0,   -4,   12,   -7,   -3,     2, 0

    // 3 r4 - 6 r5 + 12 r6 + 7 r7

    sub.w r12, r4, r5, lsl #1
    add.w r12, r12, r6, lsl #2
    add.w r12, r12, r7, lsl #1
    add.w r12, r12, r12, lsl #1
    add.w r12, r12, r7

    mul r12, r12, r9

    str.w r12, [r0, #2*8*4]

// ========

// 1/9
// 0,    2,   -3,   -4,    3,     2, 0

    // -3 r4 - 3 r6 + 4 r7

    add.w r12, r4, r6
    sub.w r12, r12, r12, lsl #2
    add.w r12, r12, r7, lsl #2

    mul r12, r12, r9

    str.w r12, [r0, #3*8*4]

// ========

// 1/15
// 0,    2,   -5,    0,    5,    -2, 0

    // -5 r4 + 4 r5 - 5 r6

    add.w r12, r4, r6
    add.w r12, r12, r12, lsl #2
    rsb.w r12, r12, r5, lsl #2

    mul r12, r12, r10

    str.w r12, [r0, #4*8*4]

// ========

// 1/45
// 0,    4,    0,   -5,    0,     1, 0

    // 3 r5 + 5 r7

    add.w r12, r5, r5, lsl #1
    add.w r12, r12, r7
    add.w r12, r12, r7, lsl #2

    mul r12, r12, r11

    str.w r12, [r0, #5*8*4]

// ========

// 1
// 0,   -4,    8,    5,  -10,    -1, 2

    // 10 r4 - 3 r5 + 6 r6 - 5 r7

    rsb.w r12, r7, r4, lsl #1
    add.w r12, r12, r12, lsl #2
    rsb.w r14, r5, r6, lsl #1
    add.w r14, r14, r14, lsl #1
    add.w r12, r12, r14

    str.w r12, [r0, #6*8*4]

// ========

    add.w r0, r0, #4

    sub.w r1, r1, #4

.endr

    add.w r1, r1, #(16+3)*4
    add.w r0, r0, #(7*8-7)*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _iTC4_T_7x7_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}































