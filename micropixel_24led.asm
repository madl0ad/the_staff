	.file	"micropixel_24led.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__RAMPZ__ = 0x3b
__CCP__ = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.global	sendByte
	.type	sendByte, @function
sendByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r25,1604
	ldi r18,lo8(7)
	ldi r19,0
	ldi r26,lo8(1)
	ldi r27,0
	mov r22,r24
	ldi r23,0
	ldi r30,lo8(68)
	ldi r31,lo8(6)
.L3:
	movw r20,r26
	mov r0,r18
	rjmp 2f
	1:
	lsl r20
	rol r21
	2:
	dec r0
	brpl 1b
	and r20,r22
	and r21,r23
	cp __zero_reg__,r20
	cpc __zero_reg__,r21
	brge .L4
	ldi r25,lo8(32)
	rjmp .L2
.L4:
	ldi r25,0
.L2:
	st Z,r25
	mov r20,r25
	ori r20,lo8(-128)
	st Z,r20
	st Z,r25
	subi r18,1
	sbc r19,__zero_reg__
	brcc .L3
/* epilogue start */
	ret
	.size	sendByte, .-sendByte
.global	startFrame
	.type	startFrame, @function
startFrame:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,0
	call sendByte
	ldi r24,0
	call sendByte
	ldi r24,0
	call sendByte
	ldi r24,0
	jmp sendByte
	.size	startFrame, .-startFrame
.global	endFrame
	.type	endFrame, @function
endFrame:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(-1)
	call sendByte
	ldi r24,lo8(-1)
	call sendByte
	ldi r24,lo8(-1)
	call sendByte
	ldi r24,lo8(-1)
	jmp sendByte
	.size	endFrame, .-endFrame
.global	sendRGB
	.type	sendRGB, @function
sendRGB:
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 3 */
.L__stack_usage = 3
	mov r28,r24
	mov r29,r22
	mov r17,r20
	ldi r24,lo8(-1)
	call sendByte
	mov r24,r17
	call sendByte
	mov r24,r29
	call sendByte
	mov r24,r28
/* epilogue start */
	pop r29
	pop r28
	pop r17
	jmp sendByte
	.size	sendRGB, .-sendRGB
.global	sendRGB_
	.type	sendRGB_, @function
sendRGB_:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	ldi r24,lo8(-1)
	call sendByte
	ldd r24,Y+2
	call sendByte
	ldd r24,Y+1
	call sendByte
	ld r24,Y
/* epilogue start */
	pop r29
	pop r28
	jmp sendByte
	.size	sendRGB_, .-sendRGB_
.global	sendRGBpack
	.type	sendRGBpack, @function
sendRGBpack:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 6 */
.L__stack_usage = 6
	mov r17,r24
	movw r14,r22
	call startFrame
	tst r17
	breq .L11
	movw r28,r14
	subi r17,lo8(-(-1))
	mov r16,r17
	ldi r17,0
	subi r16,-1
	sbci r17,-1
	lsl r16
	rol r17
	add r16,r14
	adc r17,r15
.L12:
	ld r24,Y+
	ld r25,Y+
	call sendRGB_
	cp r28,r16
	cpc r29,r17
	brne .L12
.L11:
	call endFrame
	ldi r24,lo8(2999)
	ldi r25,hi8(2999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
	.size	sendRGBpack, .-sendRGBpack
.global	sendRawRGBpack
	.type	sendRawRGBpack, @function
sendRawRGBpack:
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 12 */
.L__stack_usage = 12
	mov r9,r24
	movw r14,r22
	movw r12,r20
	movw r10,r18
	call startFrame
	tst r9
	breq .L15
	movw r28,r16
	adiw r28,1
	dec r9
	mov r16,r9
	ldi r17,0
	subi r16,-1
	sbci r17,-1
	mov r8,__zero_reg__
	mov r9,__zero_reg__
.L18:
	ld r24,Y+
	tst r24
	breq .L16
	movw r30,r10
	add r30,r8
	adc r31,r9
	ld r20,Z
	movw r30,r12
	add r30,r8
	adc r31,r9
	ld r22,Z
	movw r30,r14
	add r30,r8
	adc r31,r9
	ld r24,Z
	call sendRGB
	rjmp .L17
.L16:
	ldi r20,0
	ldi r22,0
	ldi r24,0
	call sendRGB
.L17:
	ldi r24,-1
	sub r8,r24
	sbc r9,r24
	cp r8,r16
	cpc r9,r17
	brne .L18
.L15:
	call endFrame
	ldi r24,lo8(2999)
	ldi r25,hi8(2999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	ret
	.size	sendRawRGBpack, .-sendRawRGBpack
.global	flush_mask
	.type	flush_mask, @function
flush_mask:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(mask)
	ldi r31,hi8(mask)
	ldi r24,lo8(mask+25)
	ldi r25,hi8(mask+25)
.L21:
	st Z+,__zero_reg__
	cp r30,r24
	cpc r31,r25
	brne .L21
/* epilogue start */
	ret
	.size	flush_mask, .-flush_mask
.global	fill_mask
	.type	fill_mask, @function
fill_mask:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(mask)
	ldi r31,hi8(mask)
	ldi r18,lo8(mask+25)
	ldi r19,hi8(mask+25)
	ldi r24,lo8(1)
.L24:
	st Z+,r24
	cp r30,r18
	cpc r31,r19
	brne .L24
/* epilogue start */
	ret
	.size	fill_mask, .-fill_mask
.global	formColorPack_scheme
	.type	formColorPack_scheme, @function
formColorPack_scheme:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 6 */
.L__stack_usage = 6
	tst r24
	breq .L26
	mov r30,r20
	mov r31,r21
	mov r26,r22
	mov r27,r23
	ldi r20,0
	ldi r21,0
	ldi r16,lo8(1)
	ldi r17,0
	ldi r19,0
.L29:
	lds r28,pal
	lds r29,pal+1
	ld r22,Y
	ldd r23,Y+1
	st Z,r22
	std Z+1,r23
	cpi r20,lo8(8)
	brsh .L28
	movw r22,r16
	mov r0,r20
	rjmp 2f
	1:
	lsl r22
	rol r23
	2:
	dec r0
	brpl 1b
	movw r14,r22
	and r14,r18
	and r15,r19
	cp r22,r14
	cpc r23,r15
	brne .L28
	ld r22,X+
	ld r23,X
	sbiw r26,1
	st Z,r22
	std Z+1,r23
.L28:
	subi r20,-1
	sbci r21,-1
	adiw r30,2
	adiw r26,2
	cp r20,r24
	brlo .L29
.L26:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
	.size	formColorPack_scheme, .-formColorPack_scheme
.global	mode_9
	.type	mode_9, @function
mode_9:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ret
	.size	mode_9, .-mode_9
.global	mode_10
	.type	mode_10, @function
mode_10:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ret
	.size	mode_10, .-mode_10
.global	process_button
	.type	process_button, @function
process_button:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,-11
	ldi r18,1
	cpc r25,r18
	brlo .L34
	or r22,r23
	breq .+2
	rjmp .L44
	lds r24,power
	subi r24,lo8(-(1))
	cpi r24,lo8(2)
	brsh .L36
	sts power,r24
	rjmp .L37
.L36:
	sts power,__zero_reg__
.L37:
	lds r22,power
	ldi r24,lo8(e_power)
	ldi r25,hi8(e_power)
	call eeprom_write_byte
	ldi r24,lo8(1)
	ret
.L34:
	cpi r24,101
	cpc r25,__zero_reg__
	brlo .L38
	or r22,r23
	breq .+2
	rjmp .L45
	lds r24,mode
	subi r24,lo8(-(1))
	cpi r24,lo8(13)
	brsh .L39
	sts mode,r24
	rjmp .L40
.L39:
	ldi r24,lo8(1)
	sts mode,r24
.L40:
	lds r22,mode
	ldi r24,lo8(e_mode)
	ldi r25,hi8(e_mode)
	call eeprom_write_byte
	ldi r24,lo8(1)
	ret
.L38:
	sbiw r24,11
	brlo .L46
	or r22,r23
	brne .L47
	lds r24,ss
	cpi r24,lo8(1)
	brne .L41
	sts ss,__zero_reg__
	sts s,r24
	rjmp .L42
.L41:
	lds r24,s
	subi r24,lo8(-(1))
	cpi r24,lo8(11)
	brsh .L43
	sts s,r24
	rjmp .L42
.L43:
	ldi r24,lo8(1)
	sts s,r24
	sts ss,r24
.L42:
	lds r22,mode
	ldi r24,lo8(e_mode)
	ldi r25,hi8(e_mode)
	call eeprom_write_byte
	lds r22,s
	ldi r24,lo8(e_serie)
	ldi r25,hi8(e_serie)
	call eeprom_write_byte
	lds r22,ss
	ldi r24,lo8(e_s_serie)
	ldi r25,hi8(e_s_serie)
	call eeprom_write_byte
	ldi r24,lo8(1)
	ret
.L44:
	ldi r24,0
	ret
.L45:
	ldi r24,0
	ret
.L46:
	ldi r24,0
	ret
.L47:
	ldi r24,0
	ret
	.size	process_button, .-process_button
.global	check_button
	.type	check_button, @function
check_button:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,1576
	sts button_state.3882,__zero_reg__
	sbrc r24,4
	rjmp .L49
	ldi r24,lo8(1)
	sts button_state.3882,r24
	lds r24,hold.3881
	lds r25,hold.3881+1
	adiw r24,1
	sts hold.3881,r24
	sts hold.3881+1,r25
	lds r22,last_button_state.3883
	cpi r22,lo8(1)
	brne .L54
.L52:
	ldi r23,0
	lds r24,hold.3881
	lds r25,hold.3881+1
	call process_button
	rjmp .L50
.L54:
	ldi r24,0
.L50:
	lds r25,button_state.3882
	cpse r25,__zero_reg__
	rjmp .L51
.L53:
	lds r18,last_button_state.3883
	cpse r18,__zero_reg__
	rjmp .L51
	sts hold.3881,__zero_reg__
	sts hold.3881+1,__zero_reg__
.L51:
	sts last_button_state.3883,r25
	ret
.L49:
	lds r22,last_button_state.3883
	tst r22
	breq .L52
	lds r25,button_state.3882
	ldi r24,0
	rjmp .L53
	.size	check_button, .-check_button
.global	const_light
	.type	const_light, @function
const_light:
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,9
	out __SP_L__,r28
	out __SP_H__,r29
/* prologue: function */
/* frame size = 9 */
/* stack size = 27 */
.L__stack_usage = 27
	mov r25,r24
	lds r24,bbb
	cpi r24,lo8(1)
	brne .+2
	rjmp .L57
	tst r22
	brne .+2
	rjmp .L80
	std Y+2,r25
	mov r24,r22
	lsl r24
	lsl r24
	lsl r24
	mov r4,r24
	sub r4,r22
	mov __tmp_reg__,r31
	ldi r31,lo8(100)
	mov r10,r31
	mov r31,__tmp_reg__
	mov r9,__zero_reg__
	clr r8
	dec r8
	mov __tmp_reg__,r31
	ldi r31,lo8(r+18)
	mov r6,r31
	ldi r31,hi8(r+18)
	mov r7,r31
	mov r31,__tmp_reg__
	mov __tmp_reg__,r31
	ldi r31,lo8(100)
	mov r11,r31
	mov r31,__tmp_reg__
	mov r2,r25
	mov r3,__zero_reg__
	std Y+3,r10
	std Y+1,r9
.L79:
	ldd r24,Y+2
	cpi r24,lo8(8)
	brlo .+2
	rjmp .L58
	lds r16,mr
	lds r17,mr+1
	add r16,r2
	adc r17,r3
	lds r22,mg
	lds r23,mg+1
	add r22,r2
	adc r23,r3
	lds r20,mb
	lds r21,mb+1
	add r20,r2
	adc r21,r3
	ldi r30,lo8(r)
	ldi r31,hi8(r)
	ldi r18,lo8(g)
	ldi r19,hi8(g)
	ldi r24,lo8(b)
	ldi r25,hi8(b)
	ldi r26,lo8(mask)
	ldi r27,hi8(mask)
	mov __tmp_reg__,r31
	ldi r31,lo8(r+24)
	mov r14,r31
	ldi r31,hi8(r+24)
	mov r15,r31
	mov r31,__tmp_reg__
	set
	clr r12
	bld r12,1
	std Y+4,r24
	std Y+5,r25
	std Y+6,r26
	std Y+7,r27
.L59:
	movw r26,r16
	ld r24,X
	st Z+,r24
	movw r26,r22
	ld r24,X
	movw r26,r18
	st X+,r24
	movw r18,r26
	movw r26,r20
	ld r24,X
	ldd r26,Y+4
	ldd r27,Y+5
	st X+,r24
	std Y+4,r26
	std Y+5,r27
	ldd r26,Y+6
	ldd r27,Y+7
	st X+,r12
	std Y+6,r26
	std Y+7,r27
	cp r30,r14
	cpc r31,r15
	brne .L59
	rjmp .L60
.L58:
	ldd r27,Y+2
	cpi r27,lo8(9)
	brne .+2
	rjmp .L61
	brsh .L62
	cpi r27,lo8(8)
	breq .L63
	rjmp .L60
.L62:
	ldd r30,Y+2
	cpi r30,lo8(10)
	brne .+2
	rjmp .L64
	cpi r30,lo8(11)
	brne .+2
	rjmp .L65
	rjmp .L60
.L63:
	lds r31,power
	std Y+8,r31
	ldi r30,lo8(r)
	ldi r31,hi8(r)
	mov __tmp_reg__,r31
	ldi r31,lo8(r+6)
	mov r14,r31
	ldi r31,hi8(r+6)
	mov r15,r31
	mov r31,__tmp_reg__
	ldi r16,lo8(r+12)
	ldi r17,hi8(r+12)
	ldi r22,lo8(g)
	ldi r23,hi8(g)
	ldi r20,lo8(g+6)
	ldi r21,hi8(g+6)
	ldi r18,lo8(g+12)
	ldi r19,hi8(g+12)
	mov __tmp_reg__,r31
	ldi r31,lo8(b)
	mov r12,r31
	ldi r31,hi8(b)
	mov r13,r31
	mov r31,__tmp_reg__
	ldi r24,lo8(b+6)
	ldi r25,hi8(b+6)
	ldi r26,lo8(b+12)
	ldi r27,hi8(b+12)
	mov __tmp_reg__,r31
	ldi r31,lo8(50)
	mov r10,r31
	mov r31,__tmp_reg__
	mov __tmp_reg__,r31
	ldi r31,lo8(-106)
	mov r5,r31
	mov r31,__tmp_reg__
	clr r9
	dec r9
	std Y+6,r14
	std Y+7,r15
	ldd r15,Y+8
	std Y+8,r22
	std Y+9,r23
	movw r22,r26
.L68:
	ldi r27,lo8(1)
	cpse r15,r27
	rjmp .L66
	st Z,r5
	ldd r26,Y+6
	ldd r27,Y+7
	st X,__zero_reg__
	movw r26,r16
	st X,r9
	ldd r26,Y+8
	ldd r27,Y+9
	st X,r5
	movw r26,r20
	st X,__zero_reg__
	movw r26,r18
	st X,__zero_reg__
	movw r26,r12
	st X,r5
	movw r26,r24
	st X,r9
	movw r26,r22
	st X,__zero_reg__
	rjmp .L67
.L66:
	st Z,r10
	ldd r26,Y+6
	ldd r27,Y+7
	st X,__zero_reg__
	movw r26,r16
	st X,r11
	ldd r26,Y+8
	ldd r27,Y+9
	st X,r10
	movw r26,r20
	st X,__zero_reg__
	movw r26,r18
	st X,__zero_reg__
	movw r26,r12
	st X,r10
	movw r26,r24
	st X,r11
	movw r26,r22
	st X,__zero_reg__
.L67:
	adiw r30,1
	ldd r26,Y+6
	ldd r27,Y+7
	adiw r26,1
	std Y+6,r26
	std Y+7,r27
	subi r16,-1
	sbci r17,-1
	ldd r26,Y+8
	ldd r27,Y+9
	adiw r26,1
	std Y+8,r26
	std Y+9,r27
	subi r20,-1
	sbci r21,-1
	subi r18,-1
	sbci r19,-1
	ldi r27,-1
	sub r12,r27
	sbc r13,r27
	adiw r24,1
	subi r22,-1
	sbci r23,-1
	ldi r26,hi8(r+6)
	cpi r30,lo8(r+6)
	cpc r31,r26
	breq .+2
	rjmp .L68
	rjmp .L60
.L61:
	lds r10,power
	ldi r30,lo8(r)
	ldi r31,hi8(r)
	mov __tmp_reg__,r31
	ldi r31,lo8(r+1)
	mov r14,r31
	ldi r31,hi8(r+1)
	mov r15,r31
	mov r31,__tmp_reg__
	ldi r16,lo8(r+2)
	ldi r17,hi8(r+2)
	ldi r22,lo8(g)
	ldi r23,hi8(g)
	ldi r20,lo8(g+1)
	ldi r21,hi8(g+1)
	ldi r18,lo8(g+2)
	ldi r19,hi8(g+2)
	ldi r24,lo8(b)
	ldi r25,hi8(b)
	ldi r26,lo8(b+1)
	ldi r27,hi8(b+1)
	mov __tmp_reg__,r31
	ldi r31,lo8(b+2)
	mov r12,r31
	ldi r31,hi8(b+2)
	mov r13,r31
	mov r31,__tmp_reg__
	clr r9
	dec r9
	std Y+4,r14
	std Y+5,r15
	std Y+6,r22
	std Y+7,r23
	movw r22,r26
.L71:
	ldi r27,lo8(1)
	cpse r10,r27
	rjmp .L69
	st Z,r9
	ldd r26,Y+4
	ldd r27,Y+5
	st X,__zero_reg__
	movw r26,r16
	st X,__zero_reg__
	ldd r26,Y+6
	ldd r27,Y+7
	st X,__zero_reg__
	movw r26,r20
	st X,__zero_reg__
	movw r26,r18
	st X,r9
	movw r26,r24
	st X,__zero_reg__
	movw r26,r22
	st X,r9
	movw r26,r12
	st X,__zero_reg__
	rjmp .L70
.L69:
	st Z,r11
	ldd r26,Y+4
	ldd r27,Y+5
	st X,__zero_reg__
	movw r26,r16
	st X,__zero_reg__
	ldd r26,Y+6
	ldd r27,Y+7
	st X,__zero_reg__
	movw r26,r20
	st X,__zero_reg__
	movw r26,r18
	st X,r11
	movw r26,r24
	st X,__zero_reg__
	movw r26,r22
	st X,r11
	movw r26,r12
	st X,__zero_reg__
.L70:
	adiw r30,3
	ldd r26,Y+4
	ldd r27,Y+5
	adiw r26,3
	std Y+4,r26
	std Y+5,r27
	subi r16,-3
	sbci r17,-1
	ldd r26,Y+6
	ldd r27,Y+7
	adiw r26,3
	std Y+6,r26
	std Y+7,r27
	subi r20,-3
	sbci r21,-1
	subi r18,-3
	sbci r19,-1
	adiw r24,3
	subi r22,-3
	sbci r23,-1
	ldi r27,3
	add r12,r27
	adc r13,__zero_reg__
	cp r30,r6
	cpc r31,r7
	breq .+2
	rjmp .L71
	rjmp .L60
.L64:
	lds r18,power
	ldi r22,lo8(r)
	ldi r23,hi8(r)
	ldi r24,lo8(g)
	ldi r25,hi8(g)
	ldi r26,lo8(b)
	ldi r27,hi8(b)
	ldi r19,lo8(-1)
	movw r20,r24
	movw r16,r26
	ldd r24,Y+3
	movw r30,r22
.L74:
	cpi r18,lo8(1)
	brne .L72
	st Z,r19
	movw r26,r20
	st X,r8
	movw r26,r16
	st X,r19
	rjmp .L73
.L72:
	st Z,r11
	movw r26,r20
	st X,r24
	movw r26,r16
	st X,r11
.L73:
	adiw r30,1
	subi r20,-1
	sbci r21,-1
	subi r16,-1
	sbci r17,-1
	cp r30,r6
	cpc r31,r7
	brne .L74
	rjmp .L60
.L65:
	lds r18,power
	ldd r19,Y+1
	lsl r19
	ldi r22,lo8(r)
	ldi r23,hi8(r)
	ldi r24,lo8(g)
	ldi r25,hi8(g)
	ldi r26,lo8(b)
	ldi r27,hi8(b)
	movw r20,r24
	ldd r24,Y+3
	ldd r25,Y+1
	movw r30,r22
	movw r22,r26
.L77:
	cpi r18,lo8(1)
	brne .L75
	st Z,__zero_reg__
	movw r26,r20
	st X,r19
	movw r26,r22
	st X,r8
	rjmp .L76
.L75:
	st Z,__zero_reg__
	movw r26,r20
	st X,r25
	movw r26,r22
	st X,r24
.L76:
	adiw r30,1
	subi r20,-1
	sbci r21,-1
	subi r22,-1
	sbci r23,-1
	cp r30,r6
	cpc r31,r7
	brne .L77
.L60:
	call check_button
	cpi r24,lo8(1)
	brne .L78
	ldi r25,lo8(1)
	sts bbb,r25
	rjmp .L57
.L78:
	ldi r16,lo8(mask)
	ldi r17,hi8(mask)
	ldi r18,lo8(b)
	ldi r19,hi8(b)
	ldi r20,lo8(g)
	ldi r21,hi8(g)
	ldi r22,lo8(r)
	ldi r23,hi8(r)
	ldi r24,lo8(24)
	call sendRawRGBpack
	ldi r27,lo8(-14)
	add r8,r27
	ldd r30,Y+1
	subi r30,lo8(-(7))
	std Y+1,r30
	ldd r31,Y+3
	subi r31,lo8(-(-7))
	std Y+3,r31
	cpse r30,r4
	rjmp .L79
	ldi r24,0
	rjmp .L57
.L80:
	ldi r24,0
.L57:
/* epilogue start */
	adiw r28,9
	out __SP_L__,r28
	out __SP_H__,r29
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	ret
	.size	const_light, .-const_light
.global	mode_1
	.type	mode_1, @function
mode_1:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call fill_mask
	ldi r22,lo8(10)
	lds r24,s
	jmp const_light
	.size	mode_1, .-mode_1
.global	mode_2
	.type	mode_2, @function
mode_2:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call fill_mask
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	call flush_mask
	ldi r22,lo8(10)
	lds r24,s
	jmp const_light
	.size	mode_2, .-mode_2
.global	mode_3
	.type	mode_3, @function
mode_3:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	ldi r28,lo8(mask+1)
	ldi r29,hi8(mask+1)
	movw r30,r28
	ldi r24,lo8(1)
	ldi r25,lo8(1)
.L92:
	cpi r24,lo8(13)
	brsh .L90
	st Z,r25
	rjmp .L91
.L90:
	st Z,__zero_reg__
.L91:
	subi r24,lo8(-(1))
	adiw r30,1
	cpi r24,lo8(25)
	brne .L92
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	ldi r24,lo8(1)
	ldi r25,lo8(1)
.L95:
	cpi r24,lo8(13)
	brsh .L93
	st Y,__zero_reg__
	rjmp .L94
.L93:
	st Y,r25
.L94:
	subi r24,lo8(-(1))
	adiw r28,1
	cpi r24,lo8(25)
	brne .L95
	ldi r22,lo8(10)
	lds r24,s
/* epilogue start */
	pop r29
	pop r28
	jmp const_light
	.size	mode_3, .-mode_3
.global	mode_4
	.type	mode_4, @function
mode_4:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,a.3823
	lds r25,a.3823+1
	ldi r20,lo8(24)
	ldi r21,0
	sub r20,r24
	sbc r21,r25
	ldi r30,lo8(mask+1)
	ldi r31,hi8(mask+1)
	ldi r24,lo8(1)
	ldi r25,0
	ldi r19,lo8(1)
.L102:
	cpi r24,lo8(1)
	breq .L99
	cp r24,r20
	cpc r25,r21
	breq .L99
	cpi r24,lo8(24)
	brne .L100
.L99:
	st Z,r19
	rjmp .L101
.L100:
	st Z,__zero_reg__
.L101:
	adiw r30,1
	adiw r24,1
	cpi r24,25
	cpc r25,__zero_reg__
	brne .L102
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	lds r24,a.3823
	lds r25,a.3823+1
	adiw r24,1
	cpi r24,25
	cpc r25,__zero_reg__
	brsh .L103
	sts a.3823,r24
	sts a.3823+1,r25
	ret
.L103:
	sts a.3823,__zero_reg__
	sts a.3823+1,__zero_reg__
	ret
	.size	mode_4, .-mode_4
.global	mode_5
	.type	mode_5, @function
mode_5:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r20,a.3830
	lds r21,a.3830+1
	ldi r30,lo8(mask+1)
	ldi r31,hi8(mask+1)
	ldi r24,lo8(1)
	ldi r25,0
	ldi r19,lo8(1)
.L110:
	cp r20,r24
	cpc r21,r25
	brsh .L107
	tst r24
	breq .L107
	cpi r24,lo8(24)
	brne .L108
.L107:
	st Z,r19
	rjmp .L109
.L108:
	st Z,__zero_reg__
.L109:
	adiw r24,1
	adiw r30,1
	cpi r24,25
	cpc r25,__zero_reg__
	brne .L110
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	lds r24,a.3830
	lds r25,a.3830+1
	adiw r24,1
	cpi r24,25
	cpc r25,__zero_reg__
	brsh .L111
	sts a.3830,r24
	sts a.3830+1,r25
	ret
.L111:
	sts a.3830,__zero_reg__
	sts a.3830+1,__zero_reg__
	ret
	.size	mode_5, .-mode_5
.global	mode_6
	.type	mode_6, @function
mode_6:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(mask+1)
	ldi r31,hi8(mask+1)
	ldi r24,lo8(1)
	ldi r25,lo8(1)
.L117:
	sbrs r24,1
	rjmp .L115
	st Z,r25
	rjmp .L116
.L115:
	st Z,__zero_reg__
.L116:
	subi r24,lo8(-(1))
	adiw r30,1
	cpi r24,lo8(25)
	brne .L117
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	lds r24,a.3837
	lds r25,a.3837+1
	adiw r24,1
	cpi r24,25
	cpc r25,__zero_reg__
	brsh .L118
	sts a.3837,r24
	sts a.3837+1,r25
	ret
.L118:
	sts a.3837,__zero_reg__
	sts a.3837+1,__zero_reg__
	ret
	.size	mode_6, .-mode_6
.global	mode_7
	.type	mode_7, @function
mode_7:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r18,a.3844
	lds r19,a.3844+1
	ldi r22,lo8(24)
	ldi r23,0
	sub r22,r18
	sbc r23,r19
	ldi r30,lo8(mask+1)
	ldi r31,hi8(mask+1)
	ldi r20,lo8(mask+25)
	ldi r21,hi8(mask+25)
	ldi r24,lo8(1)
	ldi r25,0
	ldi r26,lo8(1)
.L124:
	cp r18,r24
	cpc r19,r25
	brsh .L122
	cp r24,r22
	cpc r25,r23
	brsh .L122
	st Z,r26
	rjmp .L123
.L122:
	st Z,__zero_reg__
.L123:
	adiw r24,1
	adiw r30,1
	cp r30,r20
	cpc r31,r21
	brne .L124
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	lds r24,a.3844
	lds r25,a.3844+1
	adiw r24,1
	cpi r24,13
	cpc r25,__zero_reg__
	brsh .L125
	sts a.3844,r24
	sts a.3844+1,r25
	ret
.L125:
	sts a.3844,__zero_reg__
	sts a.3844+1,__zero_reg__
	ret
	.size	mode_7, .-mode_7
.global	mode_8
	.type	mode_8, @function
mode_8:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r18,a.3851
	lds r19,a.3851+1
	ldi r26,lo8(24)
	ldi r27,0
	sub r26,r18
	sbc r27,r19
	ldi r30,lo8(mask+1)
	ldi r31,hi8(mask+1)
	ldi r20,lo8(mask+25)
	ldi r21,hi8(mask+25)
	ldi r24,lo8(1)
	ldi r25,0
	ldi r22,lo8(1)
.L132:
	cp r24,r18
	cpc r25,r19
	brlo .L129
	cp r26,r24
	cpc r27,r25
	brsh .L130
.L129:
	st Z,r22
	rjmp .L131
.L130:
	st Z,__zero_reg__
.L131:
	adiw r24,1
	adiw r30,1
	cp r30,r20
	cpc r31,r21
	brne .L132
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	lds r24,a.3851
	lds r25,a.3851+1
	adiw r24,1
	cpi r24,13
	cpc r25,__zero_reg__
	brsh .L133
	sts a.3851,r24
	sts a.3851+1,r25
	ret
.L133:
	sts a.3851,__zero_reg__
	sts a.3851+1,__zero_reg__
	ret
	.size	mode_8, .-mode_8
.global	binary
	.type	binary, @function
binary:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r22,a.3874
	lds r23,a.3874+1
	ldi r20,lo8(mask)
	ldi r21,hi8(mask)
	ldi r18,lo8(mask+24)
	ldi r19,hi8(mask+24)
	movw r30,r20
	ldi r26,lo8(1)
.L139:
	movw r24,r30
	sub r24,r20
	sbc r25,r21
	and r24,r22
	and r25,r23
	or r24,r25
	breq .L137
	st Z,r26
	rjmp .L138
.L137:
	st Z,__zero_reg__
.L138:
	adiw r30,1
	cp r30,r18
	cpc r31,r19
	brne .L139
	ldi r22,lo8(10)
	lds r24,s
	call const_light
	lds r24,a.3874
	lds r25,a.3874+1
	adiw r24,1
	cpi r24,25
	cpc r25,__zero_reg__
	brsh .L140
	sts a.3874,r24
	sts a.3874+1,r25
	ret
.L140:
	sts a.3874,__zero_reg__
	sts a.3874+1,__zero_reg__
	ret
	.size	binary, .-binary
.global	demo
	.type	demo, @function
demo:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,mmm.3921
	call make_serie
	lds r24,nnn.3922
	subi r24,lo8(-(1))
	sts nnn.3922,r24
	cpi r24,lo8(11)
	brlo .L144
	lds r24,s
	subi r24,lo8(-(1))
	sts s,r24
	ldi r24,lo8(1)
	sts nnn.3922,r24
.L144:
	lds r24,s
	cpi r24,lo8(11)
	brlo .L145
	lds r24,mmm.3921
	subi r24,lo8(-(1))
	sts mmm.3921,r24
	ldi r24,lo8(1)
	sts s,r24
.L145:
	lds r24,mmm.3921
	cpi r24,lo8(12)
	brlo .L143
	sts mmm.3921,__zero_reg__
.L143:
	ret
	.size	demo, .-demo
.global	make_serie
	.type	make_serie, @function
make_serie:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	cpi r24,lo8(2)
	breq .L149
	cpi r24,lo8(3)
	breq .L150
	cpi r24,lo8(1)
	brne .L164
	call mode_1
	rjmp .L153
.L149:
	call mode_2
	rjmp .L153
.L150:
	call mode_3
	rjmp .L153
.L164:
	cpi r24,lo8(5)
	breq .L154
	cpi r24,lo8(6)
	breq .L155
	cpi r24,lo8(4)
	brne .L153
	call mode_4
	rjmp .L158
.L154:
	call mode_5
	rjmp .L158
.L155:
	call mode_6
	rjmp .L158
.L153:
	cpi r28,lo8(7)
	breq .L159
	cpi r28,lo8(8)
	breq .L160
	rjmp .L158
.L159:
/* epilogue start */
	pop r28
	jmp mode_7
.L160:
/* epilogue start */
	pop r28
	jmp mode_8
.L158:
	cpi r28,lo8(11)
	breq .L162
	cpi r28,lo8(12)
	breq .L163
	rjmp .L165
.L162:
/* epilogue start */
	pop r28
	jmp binary
.L163:
/* epilogue start */
	pop r28
	jmp demo
.L165:
/* epilogue start */
	pop r28
	ret
	.size	make_serie, .-make_serie
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(e_mode)
	ldi r25,hi8(e_mode)
	call eeprom_read_byte
	mov r17,r24
	sts mode,r24
	ldi r24,lo8(e_serie)
	ldi r25,hi8(e_serie)
	call eeprom_read_byte
	mov r29,r24
	sts s,r24
	ldi r24,lo8(e_s_serie)
	ldi r25,hi8(e_s_serie)
	call eeprom_read_byte
	mov r28,r24
	sts ss,r24
	ldi r24,lo8(e_power)
	ldi r25,hi8(e_power)
	call eeprom_read_byte
	mov r25,r24
	sts power,r24
	cpi r17,lo8(13)
	brlo .L167
	ldi r24,lo8(1)
	sts mode,r24
.L167:
	cpi r29,lo8(11)
	brlo .L168
	ldi r24,lo8(1)
	sts s,r24
.L168:
	cpi r28,lo8(2)
	brlo .L169
	sts ss,__zero_reg__
.L169:
	cpi r25,lo8(2)
	brlo .L170
	ldi r24,lo8(1)
	sts power,r24
.L170:
	ldi r24,lo8(-1)
	sts 1568,r24
	sts 1572,__zero_reg__
	sts 1600,r24
	sts 1604,__zero_reg__
	clr r7
	inc r7
	mov __tmp_reg__,r31
	ldi r31,lo8(hr)
	mov r14,r31
	ldi r31,hi8(hr)
	mov r15,r31
	mov r31,__tmp_reg__
	ldi r16,lo8(hg)
	ldi r17,hi8(hg)
	ldi r28,lo8(hb)
	ldi r29,hi8(hb)
	mov __tmp_reg__,r31
	ldi r31,lo8(fr)
	mov r10,r31
	ldi r31,hi8(fr)
	mov r11,r31
	mov r31,__tmp_reg__
	mov __tmp_reg__,r31
	ldi r31,lo8(fg)
	mov r12,r31
	ldi r31,hi8(fg)
	mov r13,r31
	mov r31,__tmp_reg__
	mov __tmp_reg__,r31
	ldi r31,lo8(fb)
	mov r8,r31
	ldi r31,hi8(fb)
	mov r9,r31
	mov r31,__tmp_reg__
.L171:
	sts bbb,__zero_reg__
	lds r24,mode
	call make_serie
	lds r24,ss
	cpi r24,lo8(1)
	brne .L172
	lds r24,s
	subi r24,lo8(-(1))
	cpi r24,lo8(11)
	brsh .L173
	sts s,r24
	rjmp .L172
.L173:
	sts s,r7
.L172:
	lds r24,power
	cpi r24,lo8(1)
	brne .L174
	sts mr,r10
	sts mr+1,r11
	sts mg,r12
	sts mg+1,r13
	sts mb,r8
	sts mb+1,r9
	rjmp .L171
.L174:
	sts mr,r14
	sts mr+1,r15
	sts mg,r16
	sts mg+1,r17
	sts mb,r28
	sts mb+1,r29
	rjmp .L171
	.size	main, .-main
	.data
	.type	nnn.3922, @object
	.size	nnn.3922, 1
nnn.3922:
	.byte	1
	.type	mmm.3921, @object
	.size	mmm.3921, 1
mmm.3921:
	.byte	1
	.local	last_button_state.3883
	.comm	last_button_state.3883,1,1
	.local	hold.3881
	.comm	hold.3881,2,1
	.local	button_state.3882
	.comm	button_state.3882,1,1
	.local	a.3874
	.comm	a.3874,2,1
	.local	a.3851
	.comm	a.3851,2,1
	.local	a.3844
	.comm	a.3844,2,1
	.local	a.3837
	.comm	a.3837,2,1
	.local	a.3830
	.comm	a.3830,2,1
	.local	a.3823
	.comm	a.3823,2,1
.global	bbb
	.section .bss
	.type	bbb, @object
	.size	bbb, 1
bbb:
	.zero	1
	.comm	pal,2,1
	.comm	mask,25,1
	.comm	b,24,1
	.comm	g,24,1
	.comm	r,24,1
.global	e_power
	.section	.eeprom,"aw",@progbits
	.type	e_power, @object
	.size	e_power, 1
e_power:
	.zero	1
.global	e_s_serie
	.type	e_s_serie, @object
	.size	e_s_serie, 1
e_s_serie:
	.zero	1
.global	e_serie
	.type	e_serie, @object
	.size	e_serie, 1
e_serie:
	.zero	1
.global	e_mode
	.type	e_mode, @object
	.size	e_mode, 1
e_mode:
	.zero	1
	.comm	power,1,1
	.comm	ss,1,1
	.comm	s,1,1
	.comm	mode,1,1
	.comm	mb,2,1
	.comm	mg,2,1
	.comm	mr,2,1
.global	hb
	.data
	.type	hb, @object
	.size	hb, 8
hb:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	100
	.byte	100
	.byte	100
	.byte	100
.global	hg
	.type	hg, @object
	.size	hg, 8
hg:
	.byte	0
	.byte	0
	.byte	100
	.byte	100
	.byte	100
	.byte	0
	.byte	0
	.byte	100
.global	hr
	.type	hr, @object
	.size	hr, 8
hr:
	.byte	0
	.byte	100
	.byte	100
	.byte	0
	.byte	0
	.byte	0
	.byte	100
	.byte	100
.global	fb
	.type	fb, @object
	.size	fb, 8
fb:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
.global	fg
	.type	fg, @object
	.size	fg, 8
fg:
	.byte	0
	.byte	0
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	0
	.byte	0
	.byte	-1
.global	fr
	.type	fr, @object
	.size	fr, 8
fr:
	.byte	0
	.byte	-1
	.byte	-1
	.byte	0
	.byte	0
	.byte	0
	.byte	-1
	.byte	-1
	.ident	"GCC: (GNU) 4.9.2"
.global __do_copy_data
.global __do_clear_bss
