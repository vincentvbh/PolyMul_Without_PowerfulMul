
#include "params.h"
#include "NTT_params.h"

#include "macros.i"
#include "mulmod.i"
#include "reduce.i"

.syntax unified


.align 4
.global __asm_point_mul_pre
__asm_point_mul_pre:
    push.w {r4-r12, lr}


    ldr.w r3, [r3, #4]

    add.w r12, r0, #1024
    _point_mul_pre_loop:

    ldr.w r4, [r1], #4
    ldrh.w r6, [r2, #4]
    ldrsh.w r7, [r2, #6]
    ldr.w r5, [r2], #8

    mulmod r4, r5, r6, r7, r3, r8, r9, r10, r11
    reduce_32 r11, r3, r10

    str.w r11, [r0], #4

    cmp.w r0, r12
    bne.w _point_mul_pre_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_point_mul_pre_fast
__asm_point_mul_pre_fast:
    push.w {r4-r12, lr}

    ldr.w r3, [r3, #4]

    add.w r12, r0, #1024
    _point_mul_pre_fast_loop:

    ldr.w r4, [r1], #4
    ldr.w r6, [r2, #4]
    ldr.w r5, [r2], #8

    mulmod_fast r4, r4, r5, r6, r3, r8, r9

    str.w r4, [r0], #4

    cmp.w r0, r12
    bne.w _point_mul_pre_fast_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_extend
__asm_extend:

    push.w {r4-r12, lr}
    sub.w sp, sp, #32

    ldr.w r12, [r2, #0]
    ldr.w r3, [r2, #8]
    ldrh.w r5, [r2, #12]
    ldrsh.w r6, [r2, #14]
    ldr.w r2, [r2, #4]

    lsr.w r7, r2, #1

    add.w r14, r0, #256*8
    str.w r14, [sp, #0]
    _extend_loop:

    ldr.w r4, [r1], #4
    freeze_32 r4, r2, r7, r14
    str.w r4, [r0, #0]
    mulmod r4, r3, r5, r6, r2, r8, r9, r10, r14
    freeze_32 r14, r2, r7, r4
    mul   r14, r14, r12
    str.w r14, [r0, #4]

    add.w r0, r0, #8

    ldr.w r14, [sp, #0]
    cmp.w r0, r14
    bne.w _extend_loop

    add.w sp, sp, #32
    pop.w {r4-r12, pc}

.align 4
.global __asm_point_montmul
__asm_point_montmul:

    push.w {r4-r12, lr}

    ldrh.w  r8, [r3, #4]
    ldrsh.w r9, [r3, #6]
    ldr.w   r3, [r3]

    add.w r12, r0, #1024
    _point_montmul_loop:

    ldrsh.w r5, [r1, #2]
    ldrh.w  r4, [r1], #4
    ldrsh.w r7, [r2, #2]
    ldrh.w  r6, [r2], #4

    const_montmul r5, r4, r5, r6, r7, r10, r3, r8, r9

    str.w   r5, [r0], #4

    cmp.w r0, r12
    bne.w _point_montmul_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_point_montmul_fast
__asm_point_montmul_fast:

    push.w {r4-r12, lr}

    ldr.w  r8, [r3]
    ldr.w  r3, [r3, #4]

    add.w r12, r0, #1024
    _point_montmul_fast_loop:

    ldr.w  r5, [r1, #4]
    ldr.w  r4, [r1], #8
    ldr.w  r7, [r2, #4]
    ldr.w  r6, [r2], #8

    montmul_fast r4, r4, r6, r8, r3, r10, r11
    montmul_fast r5, r5, r7, r8, r3, r10, r11

    str.w   r5, [r0, #4]
    str.w   r4, [r0], #8

    cmp.w r0, r12
    bne.w _point_montmul_fast_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_InnerProd_L_fast
.type __asm_InnerProd_L_fast, %function
__asm_InnerProd_L_fast:
    push.w {r4-r12, lr}

    add.w r4, r1, #4*256*4
    add.w r5, r2, #4*256*4

    movw r10, #:lower16:Qprime
    movt r10, #:upper16:Qprime
    movw r11, #:lower16:Q
    movt r11, #:upper16:Q

.rept 256

    ldr.w r8, [r1, #0*4]
    ldr.w r9, [r2, #0*4]

    smull r6, r7, r8, r9

.set indx, 1
.rept 3

    ldr.w r8, [r1, #(indx*256)*4]
    ldr.w r9, [r2, #(indx*256)*4]

    smlal r6, r7, r8, r9

.set indx, indx+1
.endr

.if L > 4

    ldr.w r8, [r4, #0*4]
    ldr.w r9, [r5, #0*4]

    smlal r6, r7, r8, r9

.endif

.if L > 6

    ldr.w r8, [r4, #1*256*4]
    ldr.w r9, [r5, #1*256*4]
    ldr.w r12, [r4, #2*256*4]
    ldr.w r14, [r5, #2*256*4]

    smlal r6, r7, r8, r9
    smlal r6, r7, r12, r14

.endif

    mul r8, r6, r10
    smlal r6, r7, r8, r11

    str.w r7, [r0, #0*4]

    add.w r1, r1, #4
    add.w r2, r2, #4
.if L > 4
    add.w r4, r4, #4
    add.w r5, r5, #4
.endif
    add.w r0, r0, #4

.endr

    pop.w {r4-r12, pc}

.align 4
.global __asm_InnerProd_L
.type __asm_InnerProd_L, %function
__asm_InnerProd_L:
    push.w {r4-r12, lr}

    movw r10, #:lower16:Qprime
    movt r10, #:upper16:Qprime
    movw r11, #:lower16:Q
    movt r11, #:upper16:Q
    asr.w r12, r11, #16
    ubfx.w r11, r11, #0, #16

.rept 256

    ldrh.w r4, [r1, #0*2]
    ldrsh.w r5, [r1, #1*2]
    ldrh.w r6, [r2, #0*2]
    ldrsh.w r7, [r2, #1*2]

    const_smull r8, r9, r4, r5, r6, r7, r14


.set indx, 1
.rept 3

    ldrh.w r4, [r1, #((indx*256)*4+0*2)]
    ldrsh.w r5, [r1, #((indx*256)*4+1*2)]
    ldrh.w r6, [r2, #((indx*256)*4+0*2)]
    ldrsh.w r7, [r2, #((indx*256)*4+1*2)]

    const_smlal r8, r9, r4, r5, r6, r7, r14

.set indx, indx+1
.endr

.if L > 4

    add.w r1, r1, #4*256*4
    add.w r2, r2, #4*256*4

    ldrh.w r4, [r1, #0*2]
    ldrsh.w r5, [r1, #1*2]
    ldrh.w r6, [r2, #0*2]
    ldrsh.w r7, [r2, #1*2]

    const_smlal r8, r9, r4, r5, r6, r7, r14

.endif

.if L > 6

    ldrh.w r4, [r1, #(1*256*4+0*2)]
    ldrsh.w r5, [r1, #(1*256*4+1*2)]
    ldrh.w r6, [r2, #(1*256*4+0*2)]
    ldrsh.w r7, [r2, #(1*256*4+1*2)]

    const_smlal r8, r9, r4, r5, r6, r7, r14

    ldrh.w r4, [r1, #(2*256*4+0*2)]
    ldrsh.w r5, [r1, #(2*256*4+1*2)]
    ldrh.w r6, [r2, #(2*256*4+0*2)]
    ldrsh.w r7, [r2, #(2*256*4+1*2)]

    const_smlal r8, r9, r4, r5, r6, r7, r14

.endif

    mul r4, r8, r10
    asr.w r5, r4, #16
    ubfx.w r4, r4, #0, #16
    const_smlal r8, r9, r4, r5, r11, r12, r14

    str.w r9, [r0, #0*4]

    add.w r1, r1, #4
    add.w r2, r2, #4
.if L > 4
    sub.w r1, r1, #4*256*4
    sub.w r2, r2, #4*256*4
.endif
    add.w r0, r0, #4

.endr

    pop.w {r4-r12, pc}




















