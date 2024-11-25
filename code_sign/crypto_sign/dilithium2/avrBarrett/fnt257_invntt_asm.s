/*!
 * @details     int32_t fnt257_invntt_asm (int32_t a[256]);
 * @brief       FNT
 * @param[in]   signed 32-bit x 256 polynomial data : a
 * @param[out]  return invFNT(a)
 * @note        ..
 * @pre         ..
 */
            EXTERN  invfnt_q1_zetas
            NAME    fnt257_invntt_asm       ;   module name
            PUBLIC  fnt257_invntt_asm       ;   make the main label vissible outside this module
            RSEG    CODE                    ;   place program in 'CODE' segment

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
    
mc_fnt_gs_hi    MACRO    m_a0, m_a1, m_b0, m_b1, m_tmp0, m_tmp1

	ld      m_a0,   X+
    ld      m_a1,   X
    ldd     m_b0,   Y+0
    ldd     m_b1,   Y+1
                      
    movw    m_tmp0, m_a0 
    add     m_a0,   m_b0
    adc     m_a1,   m_b1    
    sub     m_b0,   m_tmp0
    sbc     m_b1,   m_tmp1

    ENDM

mc_fnt_gs_lo    MACRO    m_a0, m_a1, m_b0, m_b1

	st      X,      m_a1
    st      -X,     m_a0
    std     Y+0,    m_b0
    std     Y+1,    m_b1    
    adiw    r26,    4
    adiw    r28,    4

    ENDM
    
mc_fnt_gs_lo_f  MACRO   m_a0, m_a1, m_b0, m_b1, m_tmp0

    
    mov     m_tmp0, m_a1
    lsl     m_tmp0
    sbc     m_tmp0, m_tmp0    
    sbiw    r26,    1
    st      X+,     m_a0
    st      X+,     m_a1
    st      X+,     m_tmp0
    st      X+,     m_tmp0
    
    mov     m_tmp0, m_b1
    lsl     m_tmp0
    sbc     m_tmp0, m_tmp0       
    st      Y+,     m_b0
    st      Y+,     m_b1
    st      Y+,     m_tmp0
    st      Y+,     m_tmp0
    
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
                      
fnt257_invntt_asm:
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
    movw    adr0,   r16
    
    ;   Z = zetas || zetashi table
    ldi     r30,    low (invfnt_q1_zetas)
    ldi     r31,    high(invfnt_q1_zetas)
    
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
    
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo    a0, a1, tmp2, rtmp1       
    dec     i_cnt
    brne    in6             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  2      ;
    
    dec     o_cnt
    brne    out6           ;

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
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo    a0, a1, tmp2, rtmp1       
    
    dec     i_cnt
    brne    in5             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  4      ;
    
    dec     o_cnt
    brne    out5            ;

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
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo    a0, a1, tmp2, rtmp1
    
    dec     i_cnt
    brne    in4             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  8      ;
    
    dec     o_cnt
    brne    out4            ;

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
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo    a0, a1, tmp2, rtmp1
    
    dec     i_cnt
    brne    in3             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  16      ;
    
    dec     o_cnt
    brne    out3            ;

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
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo    a0, a1, tmp2, rtmp1
    
    dec     i_cnt
    brne    in2             ;
    
    add     r26,    c_tmp
    adc     r27,    zero
    add     r28,    c_tmp
    adc     r29,    zero
    ldi     i_cnt,  32      ;
    
    dec     o_cnt
    brne    out2            ;

layer1: // Layer 1 : Fnt butterfly
    ldi     i_cnt,  64      ;
    ldi     o_cnt,  2       ;    
    movw    r26,    adr0
    movw    r28,    adr0
    inc     r29
    
out1:        
    lpm     z0,     Z+
    lpm     z1,     Z+     
in1:
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo    a0, a1, tmp2, rtmp1
    
    dec     i_cnt
    brne    in1             ;
        
    inc     r27
    inc     r29
    ldi     i_cnt,  64      ;
    
    dec     o_cnt
    brne    out1            ;

layer0: // Layer 0 : Fnt butterfly with    
    ldi     i_cnt,  128
    movw    r26,    adr0
    movw    r28,    adr0
    inc     r29
    inc     r29
    adiw    r30,    2
    lpm     z0,     Z+
    lpm     z1,     Z+ 
    
in0:   
    mc_fnt_gs_hi    a0, a1, b0, b1, tmp0, tmp1    
    mc_muls16x16_32 b0, b1, z0, z1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1
    mc_fnt_gs_lo_f  a0, a1, tmp2, rtmp1, tmp0
    dec     i_cnt
    brne    in0    

layer_mont:
    ldi     i_cnt,  128    
    movw    r28,    adr0    
    clr     b0
    clr     b1
    dec     b0 ; b <- 255

mont:
    ldd     a0,     Y+0
    ldd     a1,     Y+1
    
    mc_muls16x16_32 a0, a1, b0, b1, tmp0, tmp1, tmp2, tmp3, zero    
    mc_fnt_reduce   tmp0, tmp1, tmp2, tmp3, rtmp0, rtmp1 ;rtn tmp2, rtmp1    
    
    mov     tmp0,   rtmp1
    lsl     tmp0
    sbc     tmp0,   tmp0       
    st      Y+,     tmp2
    st      Y+,     rtmp1
    st      Y+,     tmp0
    st      Y+,     tmp0
        
    dec     i_cnt
    brne    mont

end_fnt_invntt:

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
    

