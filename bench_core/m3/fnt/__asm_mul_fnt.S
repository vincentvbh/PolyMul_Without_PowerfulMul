
#include "macros.i"
#include "macros_fnt.i"

.syntax unified


.align 4
.global __asm_basemul257
.type __asm_basemul257, %function
__asm_basemul257:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov.w r14, #64
    _basemul257_loop:
#else
.rept 64
#endif

    ldr.w  r5, [r1, #1*4]
    ldr.w  r6, [r1, #2*4]
    ldr.w  r7, [r1, #3*4]
    ldr.w  r4, [r1], #4*4
    ldr.w  r9, [r2, #1*4]
    ldr.w r10, [r2, #2*4]
    ldr.w r11, [r2, #3*4]
    ldr.w  r8, [r2], #4*4

    mul r12, r4, r9
    mla r12, r5, r8, r12
    str.w r12, [r0, #1*4]

    ldr.w r12, [r3], #4

    mul r9, r9, r12
    mul r4, r4, r8
    mla r4, r5, r9, r4
    FNT_reduce_lo r4, r5
    str.w r4, [r0], #2*4

    mul r4, r6, r11
    mla r4, r7, r10, r4
    str.w r4, [r0, #1*4]
    mul r11, r11, r12
    mul r4, r6, r10
    mls r4, r7, r11, r4
    FNT_reduce_lo r4, r5
    str.w r4, [r0], #2*4

#ifdef LOOP
    subs.w r14, #1
    bne.w _basemul257_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}









