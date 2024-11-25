
/*!
 * @details     int32_t fnt257_ntt_asm (int32_t a[256]);
 * @brief       FNT
 * @param[in]   signed 32-bit x 256 polynomial data : a
 * @param[out]  return FNT(a)
 * @note        ..
 * @pre         ..
 */
            EXTERN  fnt_q1_zetas
            NAME    fnt257_ntt_asm      ;   module name
            PUBLIC  fnt257_ntt_asm      ;   make the main label vissible outside this module
            RSEG    CODE                ;   place program in 'CODE' segment

#define mulr0   r2 
#define mulr1   r3 
#define mulr2   r4 
#define mulr3   r5 
#define tmp0    r6 
#define tmp1    r7 
#define tmp2    r8 
#define tmp3    r9 
#define rtmp0   r10
#define rtmp1   r11
#define adr0    r12
#define adr1    r13
#define zero    r15
#define a0      r16
#define a1      r17
#define b0      r18
#define b1      r19
#define z0      r20
#define z1      r21
#define c_tmp   r23
#define i_cnt   r24
#define o_cnt   r25

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
    
mc_fnt_ct_hi    MACRO    m_a0, m_a1, m_b0, m_b1

	ld      m_a0,   X+
    ld      m_a1,   X
    ldd     m_b0,   Y+0
    ldd     m_b1,   Y+1

    ENDM

mc_fnt_ct_lo    MACRO    m_a0, m_a1, m_b0, m_b1, m_tmp0, m_tmp1

	movw    m_tmp0, m_a0
    add     m_a0,   m_b0
    adc     m_a1,   m_b1
    sub     m_tmp0, m_b0
    sbc     m_tmp1, m_b1    
    
    st      X,      m_a1
    st      -X,     m_a0
    std     Y+0,    m_tmp0
    std     Y+1,    m_tmp1    
    adiw    r26,    4
    adiw    r28,    4

    ENDM
    
mc_fnt_ct_lo_f  MACRO    m_a0, m_a1, m_b0, m_b1, m_tmp0, m_tmp1, m_tmp2

	movw    m_tmp0, m_a0
    add     m_a0,   m_b0
    adc     m_a1,   m_b1
    sub     m_tmp0, m_b0
    sbc     m_tmp1, m_b1    
    
    mov     m_tmp2, m_a1
    lsl     m_tmp2
    sbc     m_tmp2, m_tmp2    
    sbiw    r26,    1
    st      X+,     m_a0
    st      X+,     m_a1
    st      X+,     m_tmp2
    st      X+,     m_tmp2
    
    mov     m_tmp2, m_tmp1
    lsl     m_tmp2
    sbc     m_tmp2, m_tmp2       
    st      Y+,     m_tmp0
    st      Y+,     m_tmp1
    st      Y+,     m_tmp2
    st      Y+,     m_tmp2
    
    ENDM
    
mc_fnt_reduce   MACRO   m_a0, m_a1, m_a2, m_a3, m_tmp0, m_tmp1
    clr     m_tmp1
    mov     m_tmp0, m_a3
    lsl     m_tmp0
    sbc     m_tmp0, m_tmp0        
    add     m_a2,   m_a0
    adc     m_a3,   m_a1
    adc     m_tmp0, m_tmp1       
    sub     m_a2,   m_a3
    sbc     m_tmp1, m_tmp0
       
    ENDM

mc_shift1    MACRO    m_b0, m_b1

	lsl b0 
    rol b1

    ENDM

mc_shift2    MACRO    m_b0, m_b1

	mc_shift1 m_b0, m_b1
    mc_shift1 m_b0, m_b1

    ENDM


mc_shift4    MACRO    m_b0, m_b1

	mc_shift2 m_b0, m_b1
    mc_shift2 m_b0, m_b1

    ENDM
    
    
mc_shift6    MACRO    m_b0, m_b1

	mc_shift2 m_b0, m_b1
    mc_shift4 m_b0, m_b1

    ENDM
                      
fnt257_ntt_asm:
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
    movw    adr0,   r16
    
    ;   Z = zetas || zetashi table
    ldi     r30,    low (fnt_q1_zetas)
    ldi     r31,    high(fnt_q1_zetas)
    adiw    r30,    8
    
layer0: // Layer 0 : Fnt butterfly with 16
    ;   load cnt
    ldi     i_cnt,  128
        
in0:
    ; (a + 16b), (a-16b) 
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_shift4       b0, b1
    mc_fnt_ct_lo    a0, a1, b0, b1, tmp0, tmp1
    dec     i_cnt
    brne    in0

layer1: // Layer 1 : Fnt butterfly with 4 and 64
    ;   load cnt
    ldi     i_cnt,  64
    movw    r26,    adr0
    movw    r28,    adr0
    inc     r29
    
in10:
    ; (a + 4b), (a-4b) 
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_shift2       b0, b1
    mc_fnt_ct_lo    a0, a1, b0, b1, tmp0, tmp1 
    dec     i_cnt
    brne    in10
    
    ldi     i_cnt,  64
    inc     r27
    inc     r29    
in11:
    ; (a + 64b), (a-64b) 
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_shift6       b0, b1
    mc_fnt_ct_lo    a0, a1, b0, b1, tmp0, tmp1        
    dec     i_cnt
    brne    in11

layer2: // Layer 2 : Fnt butterfly with 2, 32, 8, 128
    ldi     i_cnt,  32      ;
    ldi     o_cnt,  4       ;    
    movw    r26,    adr0
    movw    r28,    adr0
    ldi     c_tmp,  128     ;
    add     r28,    c_tmp
    adc     r29,    zero
    
out2:        
    lpm     z0,     Z+
    lpm     z1,     Z+     
in2:
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1    
    mc_fnt_ct_lo    a0, a1, tmp2, rtmp1, tmp0, tmp1
    
    dec     i_cnt
    brne    in2             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  32      ;
    
    dec     o_cnt
    brne    out2            ;
        
layer3: // Layer 3 : Fnt butterfly with origin FNT Zetas
    ldi     i_cnt,  16      ;
    ldi     o_cnt,  8       ;    
    movw    r26,    adr0
    movw    r28,    adr0
    ldi     c_tmp,  64      ;
    add     r28,    c_tmp
    adc     r29,    zero
    
out3:        
    lpm     z0,     Z+
    lpm     z1,     Z+     
in3:
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1    
    mc_fnt_ct_lo    a0, a1, tmp2, rtmp1, tmp0, tmp1
    
    dec     i_cnt
    brne    in3             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  16      ;
    
    dec     o_cnt
    brne    out3            ;


layer4: // Layer 4 : Fnt butterfly with origin FNT Zetas
    ldi     i_cnt,  8       ;
    ldi     o_cnt,  16      ;    
    movw    r26,    adr0
    movw    r28,    adr0
    ldi     c_tmp,  32      ;
    add     r28,    c_tmp
    adc     r29,    zero
    
out4:        
    lpm     z0,     Z+
    lpm     z1,     Z+     
in4:
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1    
    mc_fnt_ct_lo    a0, a1, tmp2, rtmp1, tmp0, tmp1
    
    dec     i_cnt
    brne    in4             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  8      ;
    
    dec     o_cnt
    brne    out4            ;

layer5: // Layer 5 : Fnt butterfly with origin FNT Zetas
    ldi     i_cnt,  4       ;
    ldi     o_cnt,  32      ;    
    movw    r26,    adr0
    movw    r28,    adr0
    ldi     c_tmp,  16      ;
    add     r28,    c_tmp
    adc     r29,    zero
    
out5:        
    lpm     z0,     Z+
    lpm     z1,     Z+     
in5:
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1    
    mc_fnt_ct_lo    a0, a1, tmp2, rtmp1, tmp0, tmp1
    
    dec     i_cnt
    brne    in5             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  4      ;
    
    dec     o_cnt
    brne    out5            ;

layer6: // Layer 6 : Fnt butterfly with origin FNT Zetas
    ldi     i_cnt,  2       ;
    ldi     o_cnt,  64      ;    
    movw    r26,    adr0
    movw    r28,    adr0
    ldi     c_tmp,  8      ;
    add     r28,    c_tmp
    adc     r29,    zero
    
out6:        
    lpm     z0,     Z+
    lpm     z1,     Z+     
in6:
    mc_fnt_ct_hi    a0, a1, b0, b1
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1      
    mc_fnt_ct_lo_f  a0, a1, tmp2, rtmp1, tmp0, tmp1, tmp3
    
    dec     i_cnt
    brne    in6             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  2      ;
    
    dec     o_cnt
    brne    out6           ;


end_fntntt:

#undef mulr0  
#undef mulr1  
#undef mulr2  
#undef mulr3  
#undef tmp0   
#undef tmp1   
#undef tmp2   
#undef tmp3   
#undef rtmp0  
#undef rtmp1  
#undef adr0   
#undef adr1   
#undef zero   
#undef a0     
#undef a1     
#undef b0     
#undef b1     
#undef z0     
#undef z1     
#undef c_tmp  
#undef i_cnt  
#undef o_cnt  

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
    
    ret

    END
    

