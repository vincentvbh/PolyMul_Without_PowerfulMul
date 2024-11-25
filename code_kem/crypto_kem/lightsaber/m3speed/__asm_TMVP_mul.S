
#include "macros.i"

.syntax unified
.cpu cortex-m3

// .align 4
// .global __asm_mul_neg4x4
// .type __asm_mul_neg4x4, %function
// __asm_mul_neg4x4:
//     push.w {r4-r12, lr}

// .rept 8

//     ldr.w r4, [r1]
//     ldr.w r5, [r1, #1*4]
//     ldr.w r6, [r1, #2*4]
//     ldr.w r7, [r1, #3*4]
//     ldr.w r8, [r2]
//     ldr.w r9, [r2, #1*4]
//     ldr.w r10, [r2, #2*4]
//     ldr.w r11, [r2, #3*4]
//     add.w r1, r1, #4*4
//     add.w r2, r2, #4*4

//     mul r12, r4, r8
//     mls r12, r5, r11, r12
//     mls r12, r6, r10, r12
//     mls r12, r7, r9, r12
//     str.w r12, [r0, #0*4]

//     mul r12, r4, r9
//     mla r12, r5, r8, r12
//     mls r12, r6, r11, r12
//     mls r12, r7, r10, r12
//     str.w r12, [r0, #1*4]

//     mul r12, r4, r10
//     mla r12, r5, r9, r12
//     mla r12, r6, r8, r12
//     mls r12, r7, r11, r12
//     str.w r12, [r0, #2*4]

//     mul r12, r4, r11
//     mla r12, r5, r10, r12
//     mla r12, r6, r9, r12
//     mla r12, r7, r8, r12
//     str.w r12, [r0, #3*4]

//     add.w r0, r0, #4*4

// .endr

//     pop.w {r4-r12, pc}

// .align 4
// .global __asm_TMVP_mul_4x4
// .type __asm_TMVP_mul_4x4, %function
// __asm_TMVP_mul_4x4:
//     push.w {r4-r12, lr}


// .rept 7

//     ldr.w r4, [r1]
//     ldr.w r5, [r1, #1*4]
//     ldr.w r6, [r1, #2*4]
//     ldr.w r7, [r1, #3*4]
//     ldr.w r8, [r1, #4*4]
//     ldr.w r9, [r1, #5*4]
//     ldr.w r10, [r2]
//     ldr.w r11, [r2, #1*4]
//     ldr.w r12, [r2, #2*4]
//     ldr.w r14, [r2, #3*4]

//     mul r3, r4, r10
//     mla r3, r5, r11, r3
//     mla r3, r6, r12, r3
//     mla r3, r7, r14, r3

//     str.w r3, [r0, #3*4]

//     ldr.w r4, [r1, #6*4]

//     mul r3, r5, r10
//     mla r3, r6, r11, r3
//     mla r3, r7, r12, r3
//     mla r3, r8, r14, r3

//     str.w r3, [r0, #2*4]

//     mul r3, r6, r10
//     mla r3, r7, r11, r3
//     mla r3, r8, r12, r3
//     mla r3, r9, r14, r3

//     str.w r3, [r0, #1*4]

//     mul r3, r7, r10
//     mla r3, r8, r11, r3
//     mla r3, r9, r12, r3
//     mla r3, r4, r14, r3

//     str.w r3, [r0]

//     add.w r1, r1, #8*4
//     add.w r2, r2, #4*4
//     add.w r0, r0, #4*4

// .endr

//     pop.w {r4-r12, pc}

.align 4
.global __asm_TMVP_mul_4x4_full
.type __asm_TMVP_mul_4x4_full, %function
__asm_TMVP_mul_4x4_full:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov r3, #32
    _TMVP_mul_4x4_loop:
#else
.rept 32
#endif

.set indx, 0
.rept 7

    ldr.w r4, [r1, #(indx*8+0)*4]
    ldr.w r5, [r1, #(indx*8+1)*4]
    ldr.w r6, [r1, #(indx*8+2)*4]
    ldr.w r7, [r1, #(indx*8+3)*4]
    ldr.w r8, [r1, #(indx*8+4)*4]
    ldr.w r10, [r2, #(indx*4+0)*4]
    ldr.w r11, [r2, #(indx*4+1)*4]
    ldr.w r12, [r2, #(indx*4+2)*4]
    ldr.w r14, [r2, #(indx*4+3)*4]

    mul r9, r4, r10
    mla r9, r5, r11, r9
    mla r9, r6, r12, r9
    mla r9, r7, r14, r9

    str.w r9, [r0, #(indx*4+3)*4]

    mul r9, r5, r10
    mla r9, r6, r11, r9
    mla r9, r7, r12, r9
    mla r9, r8, r14, r9

    str.w r9, [r0, #(indx*4+2)*4]

    ldr.w r4, [r1, #(indx*8+5)*4]
    ldr.w r5, [r1, #(indx*8+6)*4]

    mul r9, r6, r10
    mla r9, r7, r11, r9
    mla r9, r8, r12, r9
    mla r9, r4, r14, r9

    str.w r9, [r0, #(indx*4+1)*4]

    mul r9, r7, r10
    mla r9, r8, r11, r9
    mla r9, r4, r12, r9
    mla r9, r5, r14, r9

    str.w r9, [r0, #(indx*4+0)*4]

.set indx, indx+1
.endr

    add.w r1, r1, #7*8*4
    add.w r2, r2, #7*4*4
    add.w r0, r0, #7*4*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _TMVP_mul_4x4_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}

.align 4
.global __asm_TMVP_mla_4x4_full
.type __asm_TMVP_mla_4x4_full, %function
__asm_TMVP_mla_4x4_full:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov r3, #32
    _TMVP_mla_4x4_loop:
#else
.rept 32
#endif

.set indx, 0
.rept 7

    ldr.w r4, [r1, #(indx*8+0)*4]
    ldr.w r5, [r1, #(indx*8+1)*4]
    ldr.w r6, [r1, #(indx*8+2)*4]
    ldr.w r7, [r1, #(indx*8+3)*4]
    ldr.w r8, [r1, #(indx*8+4)*4]
    ldr.w r9, [r0, #(indx*4+3)*4]
    ldr.w r10, [r2, #(indx*4+0)*4]
    ldr.w r11, [r2, #(indx*4+1)*4]
    ldr.w r12, [r2, #(indx*4+2)*4]
    ldr.w r14, [r2, #(indx*4+3)*4]

    mla r9, r4, r10, r9
    mla r9, r5, r11, r9
    mla r9, r6, r12, r9
    mla r9, r7, r14, r9

    str.w r9, [r0, #(indx*4+3)*4]
    ldr.w r9, [r0, #(indx*4+2)*4]

    mla r9, r5, r10, r9
    mla r9, r6, r11, r9
    mla r9, r7, r12, r9
    mla r9, r8, r14, r9

    str.w r9, [r0, #(indx*4+2)*4]

    ldr.w r4, [r1, #(indx*8+5)*4]
    ldr.w r9, [r0, #(indx*4+1)*4]
    ldr.w r5, [r1, #(indx*8+6)*4]

    mla r9, r6, r10, r9
    mla r9, r7, r11, r9
    mla r9, r8, r12, r9
    mla r9, r4, r14, r9

    str.w r9, [r0, #(indx*4+1)*4]
    ldr.w r9, [r0, #(indx*4+0)*4]

    mla r9, r7, r10, r9
    mla r9, r8, r11, r9
    mla r9, r4, r12, r9
    mla r9, r5, r14, r9

    str.w r9, [r0, #(indx*4+0)*4]

.set indx, indx+1
.endr

    add.w r1, r1, #7*8*4
    add.w r2, r2, #7*4*4
    add.w r0, r0, #7*4*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _TMVP_mla_4x4_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}




