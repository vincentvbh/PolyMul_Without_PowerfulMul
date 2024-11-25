 
 
            NAME    mont_mul                          ;   module name
            PUBLIC  mont_mul                          ;   make the main label vissible outside this module
            RSEG    CODE                              ;   place program in 'CODE' segment
            
                                   
mont_mul:

;prolog
    push    r0
    push    r1
    push    r2
    push    r3
    push    r4
    push    r5
    push    r6
    push    r7
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    push    r20
    push    r21
    push    r22
    push    r23
    push    r24
    push    r25
    push    r26
    push    r27
    push    r28
    push    r29
    push    r30
    push    r31

#define zero    r2
#define a0      r16
#define a1      r17
#define a2      r18
#define a3      r19
#define b0      r20
#define b1      r21
#define b2      r22
#define b3      r23

#define res0    r8
#define res1    r9
#define res2    r10
#define res3    r11
#define res4    r12
#define res5    r13
#define res6    r14
#define res7    r15

#define ar0     r2
#define ar1     r3
#define ar2     r4
#define ar3     r5
#define ar4     r6
#define ar5     r7
#define ar6     r24
#define ar7     r25

    // 32x32-bit long multiplication 
    clr     zero
    
    mul     a0,     b0
    movw    res0,   r0
    mul     a0,     b2
    movw    res2,   r0
    mul     a2,     b2
    movw    res4,   r0
    muls    a3,     b3
    movw    res6,   r0
    
    mul     a1,     b0
    add     res1,   r0
    adc     res2,   r1
    adc     res3,   zero
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    
    mul     a2,     b0
    add     res2,   r0
    adc     res3,   r1    
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mulsu   a3,     b0
    sbc     res5,   zero
    sbc     res6,   zero
    sbc     res7,   zero    
    add     res3,   r0
    adc     res4,   r1       
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    ;======================
    mul     a0,     b1
    add     res1,   r0
    adc     res2,   r1
    adc     res3,   zero
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mul     a1,     b1
    add     res2,   r0
    adc     res3,   r1    
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mul     a2,     b1
    add     res3,   r0
    adc     res4,   r1       
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mulsu   a3,     b1
    sbc     res6,   zero
    sbc     res7,   zero    
    add     res4,   r0
    adc     res5,   r1           
    adc     res6,   zero
    adc     res7,   zero
    
    ;======================
    mul     a1,     b2
    add     res3,   r0
    adc     res4,   r1
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mulsu   a3,     b2    
    sbc     res7,   zero    
    add     res5,   r0
    adc     res6,   r1           
    adc     res7,   zero    
        
    mulsu   b3,     a0
    sbc     res5,   zero
    sbc     res6,   zero
    sbc     res7,   zero    
    add     res3,   r0
    adc     res4,   r1           
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mulsu   b3,     a1   
    sbc     res6,   zero
    sbc     res7,   zero    
    add     res4,   r0
    adc     res5,   r1           
    adc     res6,   zero
    adc     res7,   zero  
    
    mulsu   b3,     a2       
    sbc     res7,   zero    
    add     res5,   r0
    adc     res6,   r1           
    adc     res7,   zero
           
    ;======================

    // t = (int32_t)((uint64_t)a * (uint64_t)DILITHIUM_QINV);
#undef zero
#define zero r20

    clr     zero
    
    movw    ar0,    res0
    movw    ar2,    res2
    movw    ar4,    res4
    movw    ar6,    res6
    
    movw    a0,     res0
    movw    a2,     res2
    ldi     b1,     0x20
    ldi     b2,     0x80        
    ldi     b3,     0x03        
        
    movw    res0,   a0     
    movw    res2,   a2
    
    mul     a0,     b1
    add     res1,   r0
    adc     res2,   r1
    adc     res3,   zero
    
    mul     a1,     b1
    add     res2,   r0
    adc     res3,   r1
    
    mul     a0,     b2
    add     res2,   r0
    adc     res3,   r1
    
    mul     a2,     b1
    add     res3,   r0
    
    mul     a1,     b2
    add     res3,   r0
    
    mul     a0,     b3
    add     res3,   r0
                 
    // t = (int64_t)t * DILITHIUM_Q       
    movw    a0,     res0
    movw    a2,     res2
    
    ldi     b1,     0xE0
    ldi     b2,     0x7F        
        
    mul     a2,     b2
    movw    res4,   r0
    clr     res6
    clr     res7   
    
    ldi     b3,     0x01
    mulsu   a3,     b3    
    sbc     res4,   zero
    sbc     res5,   zero
    sbc     res6,   zero
    sbc     res7,   zero                    
    
    mul     a0,     b1
    add     res1,   r0
    adc     res2,   r1
    adc     res3,   zero
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mul     a1,     b1
    add     res2,   r0
    adc     res3,   r1    
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mul     a0,     b2
    add     res2,   r0
    adc     res3,   r1    
    adc     res4,   zero
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mul     a2,     b1
    add     res3,   r0
    adc     res4,   r1        
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mul     a1,     b2
    add     res3,   r0
    adc     res4,   r1        
    adc     res5,   zero
    adc     res6,   zero
    adc     res7,   zero
    
    mulsu   a3,     b1
    sbc     res6,   zero
    sbc     res7,   zero
    add     res4,   r0
    adc     res5,   r1
    adc     res6,   zero
    adc     res7,   zero

    mulsu   a3,     b2
    sbc     res7,   zero
    add     res5,   r0
    adc     res6,   r1
    adc     res7,   zero
    
    // t = (a - (int64_t)t * DILITHIUM_Q) >> 32;
    sub     ar0,    res0
    sbc     ar1,    res1
    sbc     ar2,    res2
    sbc     ar3,    res3
    sbc     ar4,    res4
    sbc     ar5,    res5
    sbc     ar6,    res6
    sbc     ar7,    res7        
    
    movw    r16,    ar4
    movw    r18,    ar6
    
#undef zero

#undef ar0
#undef ar1
#undef ar2
#undef ar3
#undef ar4
#undef ar5
#undef ar6
#undef ar7
    
#undef res0
#undef res1
#undef res2
#undef res3
#undef res4
#undef res5
#undef res6
#undef res7

#undef a0
#undef a1
#undef a2
#undef a3
#undef b0
#undef b1
#undef b2
#undef b3

    
;epilog
    pop     r31
    pop     r30
    pop     r29
    pop     r28
    pop     r27
    pop     r26
    pop     r25
    pop     r24
    pop     r23
    pop     r22
    pop     r21
    pop     r20
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     r7
    pop     r6
    pop     r5
    pop     r4
    pop     r3
    pop     r2
    pop     r1
    pop     r0

    ret

    END