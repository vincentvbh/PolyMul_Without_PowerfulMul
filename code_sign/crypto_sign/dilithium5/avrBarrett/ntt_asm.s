/*!
 * @details     void ntt_asm(int32_t a[N]);
 * @brief       NTT
 * @param[in]   signed 32-bit polynomial data : a
 * @param[out]  return NTT(a)
 * @note        ..
 * @pre         ..
 */
            EXTERN  streamlined_CT_NTT_table
            NAME    ntt_asm     ;   module name
            PUBLIC  ntt_asm     ;   make the main label vissible outside this module
            RSEG    CODE        ;   place program in 'CODE' segment

#define b0      r12
#define b1      r13
#define b2      r14
#define b3      r15
#define a0      r16
#define a1      r17
#define a2      r18
#define a3      r19
#define bp0     r20
#define bp1     r21
#define bp2     r22
#define bp3     r23
#define ntt_q   r24
#define mulr0   r4
#define mulr1   r5
#define mulr2   r6
#define mulr3   r7
#define tmp0    r8
#define tmp1    r9
#define tmp2    r10
#define tmp3    r11
#define o_cnt   r2
#define i_cnt   r25
#define zero    r3

//signed 16-bit X signed 16-bit mulciplication
mc_muls16x16_32    MACRO    m_a0, m_a1, m_b0, m_b1, m_c0, m_c1, m_c2, m_c3, m_zero

	muls    m_a1,   m_b1        ;   (signed)ah * (signed)
	movw	m_c2,   r0
	mul     m_a0,   m_b0        ;   al * bl
	movw	m_c0,   r0
	mulsu	m_a1,   m_b0        ;   (signed)ah * bl
	sbc     m_c3,   m_zero
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero
	mulsu	m_b1,   m_a0        ;   (signed)bh * al
	sbc     m_c3,   m_zero
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero

    ENDM

//signed 16-bit X unsigned 16-bit mulciplication
mc_mulsu16x16_32    MACRO    m_a0, m_a1, m_b0, m_b1, m_c0, m_c1, m_c2, m_c3, m_zero

	mulsu   m_a1,   m_b1        ;   (signed)ah * (unsigned)bh
	movw	m_c2,   r0
	mul     m_a0,   m_b0        ;   al * bl
	movw	m_c0,   r0
	mulsu	m_a1,   m_b0        ;   (signed)ah * bl
	sbc     m_c3,   m_zero
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero
	mul     m_b1,   m_a0        ;   (unsigned)bh * al
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero
    
    ENDM
    
//signed 32-bit X 32-bit multiplication and return low 32-bit
mc_muls32x32_lo32   MACRO    m_a0, m_a1, m_a2, m_a3, m_b0, m_b1, m_b2, m_b3, m_c0, m_c1, m_c2, m_c3, m_zero

	mul     m_a0,   m_b0
    movw    m_c0,   r0    
    mul     m_a2,   m_b0
    movw    m_c2,   r0
    mul     m_a1,   m_b0
    add     m_c1,   r0
    adc     m_c2,   r1
    adc     m_c3,   m_zero    
    mul     m_a0,   m_b1
    add     m_c1,   r0
    adc     m_c2,   r1
    adc     m_c3,   m_zero    
    mul     m_a1,   m_b1
    add     m_c2,   r0
    adc     m_c3,   r1    
    mul     m_a0,   m_b2
    add     m_c2,   r0
    adc     m_c3,   r1    
    mulsu   m_a3,   m_b0
    add     m_c3,   r0    
    mul     m_a2,   m_b1
    add     m_c3,   r0    
    mul     m_a1,   m_b2
    add     m_c3,   r0    
    mulsu   m_b3,   m_a0
    add     m_c3,   r0
       
    ENDM

//signed 32-bit X Q multiplication and return low 32-bit
mc_muls32xq_lo32    MACRO    m_a0, m_a1, m_a2, m_a3, m_q, m_c0, m_c1, m_c2, m_c3, m_zero

	movw    m_c0,   m_a0
    movw    m_c2,   m_a2
    ldi     m_q,    0xE0
    mul     m_a0,   m_q
    add     m_c1,   r0
    adc     m_c2,   r1
    adc     m_c3,   zero
    mul     m_a2,   m_q
    add     m_c3,   r0
    mul     m_a1,   m_q
    add     m_c2,   r0
    adc     m_c3,   r1
    ldi     m_q,    0x7F
    mul     m_a0,   m_q
    add     m_c2,   r0
    adc     m_c3,   r1
    mul     m_a1,   m_q
    add     m_c3,   r0
    
    ENDM

// barrett-based CT butterfly
mc_barrett_ct_butterfly MACRO

	ldd     a0,     Y+0
    ldd     a1,     Y+1
    ldd     a2,     Y+2
    ldd     a3,     Y+3
    
    //  hi = a_hi * bp_hi;
    mc_muls16x16_32     a2, a3, bp2, bp3, mulr0, mulr1, mulr2, mulr3, zero
    
    //  hi += ((a_lo * bp_hi) >> 16);
    mc_mulsu16x16_32    bp2, bp3, a0, a1, tmp0, tmp1, tmp2, tmp3, zero
    mov     r0,     tmp3
    lsl     r0
    sbc     r0,     r0
    add     mulr0,  tmp2
    adc     mulr1,  tmp3
    adc     mulr2,  r0
    adc     mulr3,  r0

    //  hi += ((a_hi * bp_lo) >> 16);
    mc_mulsu16x16_32    a2, a3, bp0, bp1, tmp0, tmp1, tmp2, tmp3, zero
    mov     r0,     tmp3
    lsl     r0
    sbc     r0,     r0
    add     mulr0,  tmp2
    adc     mulr1,  tmp3
    adc     mulr2,  r0
    adc     mulr3,  r0
    
    //  hi * q
    ;   tmp = hi * q
    mc_muls32xq_lo32    mulr0, mulr1, mulr2, mulr3, ntt_q, tmp0, tmp1, tmp2, tmp3, zero
   
    //  lo = a * b; 
    ;   change location [b <- bp] [bp <- b]
    movw    mulr0,  bp0
    movw    mulr2,  bp2
    movw    bp0,    b0
    movw    bp2,    b2
    movw    b0,     mulr0
    movw    b2,     mulr2
    
    //  return lo - hi * q;
    ;   [b <- bp] [bp <- b] [mulr <- lo = a * b]
    mc_muls32x32_lo32   a0, a1, a2, a3, bp0, bp1, bp2, bp3, mulr0, mulr1, mulr2, mulr3, zero  
    sub     mulr0,  tmp0
    sbc     mulr1,  tmp1
    sbc     mulr2,  tmp2
    sbc     mulr3,  tmp3
    
    ;   recover Location of b and bp
    movw    tmp0,   bp0
    movw    tmp2,   bp2
    movw    bp0,    b0
    movw    bp2,    b2
    movw    b0,     tmp0
    movw    b2,     tmp2
    
    // CT butterfly : (a, b) -> (a+zb, a-zb)
    ld      a0,     X+
    ld      a1,     X+
    ld      a2,     X+
    ld      a3,     X+
    sbiw    r26,    4
    movw    tmp0,   a0
    movw    tmp2,   a2
    add     a0,     mulr0
    adc     a1,     mulr1
    adc     a2,     mulr2
    adc     a3,     mulr3
    sub     tmp0,   mulr0
    sbc     tmp1,   mulr1
    sbc     tmp2,   mulr2
    sbc     tmp3,   mulr3
    st      X+,     a0
    st      X+,     a1
    st      X+,     a2
    st      X+,     a3
    st      Y+,     tmp0
    st      Y+,     tmp1
    st      Y+,     tmp2
    st      Y+,     tmp3 
    
    ENDM
    
mc_load_zetas MACRO

    lpm     b0,     z+
    lpm     b1,     z+
    lpm     b2,     z+
    lpm     b3,     z+
    lpm     bp0,    z+
    lpm     bp1,    z+
    lpm     bp2,    z+
    lpm     bp3,    z+

    ENDM
                   
ntt_asm:
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
    push    r16
    push    r17
    push    r18
    push    r19
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
    
initialize:
    clr     zero
    ;   X = (int32_t*)&a, Y= (int32_t*)&a + 128
    movw    r26,    r16
    movw    r28,    r16
    inc     r29
    inc     r29
    push    r16
    push    r17
    
    ;   Z = zetas || zetashi table
    ldi     r30,    low (streamlined_CT_NTT_table)
    ldi     r31,    high(streamlined_CT_NTT_table)
    
layer0:
    ldi     r24,    128
    mov     i_cnt,  r24

out0:
   mc_load_zetas
    
in0:
    mc_barrett_ct_butterfly     
    dec     i_cnt
    breq    layer1
    jmp     in0
    
layer1:
    pop     r27
    pop     r26
    push    r26
    push    r27
    movw    r28,    r26
    inc     r29

    ldi     r24,    2
    mov     o_cnt,  r24
    ldi     i_cnt,  64

out1:
    mc_load_zetas
    
in1:
    mc_barrett_ct_butterfly
    dec     i_cnt
    breq    end_layer1
    jmp     in1
    
end_layer1:
    dec     o_cnt
    breq    layer2
    inc     r27
    inc     r29
    ldi     i_cnt,  64
    jmp     out1

layer2:
    pop     r27
    pop     r26
    push    r26
    push    r27
    movw    r28,    r26
    ldi     r24,    128
    add     r28,    r24
    adc     r29,    zero
    ldi     r24,    4
    mov     o_cnt,  r24
    ldi     i_cnt,  32

out2:
    mc_load_zetas
     
in2:
    mc_barrett_ct_butterfly   
    dec     i_cnt
    breq    end_layer2
    jmp     in2
    
end_layer2:
    dec     o_cnt
    breq    layer3
    ldi     r24,    128
    add     r26,    r24
    adc     r27,    zero
    add     r28,    r24
    adc     r29,    zero
    ldi     i_cnt,  32
    jmp     out2
    
layer3:
    pop     r27
    pop     r26
    push    r26
    push    r27
    movw    r28,    r26
    ldi     r24,    64
    add     r28,    r24
    adc     r29,    zero

    ldi     r24,    8
    mov     o_cnt,  r24
    ldi     i_cnt,  16

out3:
    mc_load_zetas
    
in3:
    mc_barrett_ct_butterfly
    dec     i_cnt
    breq    end_layer3
    jmp     in3
    
end_layer3:
    dec     o_cnt
    breq    layer4
    ldi     r24,    64
    add     r26,    r24
    adc     r27,    zero
    add     r28,    r24
    adc     r29,    zero
    ldi     i_cnt,  16
    jmp     out3

layer4:
    pop     r27
    pop     r26
    push    r26
    push    r27
    movw    r28,    r26
    adiw    r28,    32

    ldi     r24,    16
    mov     o_cnt,  r24
    ldi     i_cnt,  8
    
out4:
    ;   load zetap and zeta
    mc_load_zetas
    
in4:
    mc_barrett_ct_butterfly
    
    dec     i_cnt
    breq    end_layer4
    jmp     in4
    
end_layer4:
    dec     o_cnt
    breq    layer5
    adiw    r26,    32
    adiw    r28,    32
    ldi     i_cnt,  8
    jmp     out4

layer5:
    pop     r27
    pop     r26
    push    r26
    push    r27
    movw    r28,    r26
    adiw    r28,    16

    ldi     r24,    32
    mov     o_cnt,  r24
    ldi     i_cnt,  4

out5:
   mc_load_zetas
       
in5:
    mc_barrett_ct_butterfly
    
    dec     i_cnt
    breq    end_layer5
    jmp     in5
    
end_layer5:
    dec     o_cnt
    breq    layer6
    adiw    r26,    16
    adiw    r28,    16
    ldi     i_cnt,  4
    jmp     out5

layer6:
    pop     r27
    pop     r26
    push    r26
    push    r27
    movw    r28,    r26
    adiw    r28,    8

    ldi     r24,    64
    mov     o_cnt,  r24
    ldi     i_cnt,  2

out6:
    mc_load_zetas
    
in6:
    mc_barrett_ct_butterfly
    
    dec     i_cnt
    breq    end_layer6
    jmp     in6
    
end_layer6:
    dec     o_cnt
    breq    layer7
    adiw    r26,    8
    adiw    r28,    8
    ldi     i_cnt,  2
    jmp     out6

layer7:
    pop     r27
    pop     r26
    movw    r28,    r26
    adiw    r28,    4

    ldi     r24,    128
    mov     o_cnt,  r24
    ldi     i_cnt,  1

out7:
    mc_load_zetas
    
in7:
    mc_barrett_ct_butterfly
    
    dec     i_cnt
    breq    end_layer7
    jmp     in7
    
end_layer7:
    dec     o_cnt
    breq    end_ntt
    adiw    r26,    4
    adiw    r28,    4
    ldi     i_cnt,  1
    jmp     out7

end_ntt:
    
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
    pop     r19
    pop     r18
    pop     r17
    pop     r16
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
    
#undef b0      
#undef b1      
#undef b2      
#undef b3      
#undef a0      
#undef a1      
#undef a2      
#undef a3      
#undef bp0     
#undef bp1     
#undef bp2     
#undef bp3     
#undef ntt_q   
#undef mulr0   
#undef mulr1   
#undef mulr2   
#undef mulr3   
#undef tmp0    
#undef tmp1    
#undef tmp2    
#undef tmp3    
#undef o_cnt   
#undef i_cnt   
#undef zero    

    ret

    END
    

