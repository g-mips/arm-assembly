.data

debug:	
b_num:
.byte 20

b_num2:
.byte 2
	
/*
.balign 4
message:
.asciz "Please enter a number: "
*/

.balign 4
beg_conv_message:
.asciz "Now let's convert!\012"

.balign 4
false_message:
.asciz "Your number is not a power of 2\n"

.balign 4
true_message:
.asciz "Your number is a power of 2\n"

.bss
.lcomm string 5

/*
.balign 4
.lcomm b_num, 1
*/	
.text

.global _start

.balign 4
main:
	push {r4-r6,lr}

	// Call utoa
	ldr r1, =debug
	ldr r1, =b_num
	ldr r0, =string
	ldrb r1, [r1]
	bl utoa

	// Call add_char
	ldr r0, =string
	mov r1, #10
	bl add_char

	// Call print
	ldr r0, =string
	bl print

	// Call print
	ldr r0, =beg_conv_message
	bl print

	// load in the b_num and b_num2
	// r4: 20, r5: 2
	ldr r4, =b_num
	ldrb r4, [r4]
	ldr r5, =b_num2
	ldrb r5, [r5]

	// Byte math
	// TODO(Grant): mul and div
	smulbb r4, r5, r4		// r4 = 2 * 20 = 40
	udiv r4, r4, r5		// r4 = 40 / 2 = 20
	uadd8 r4, r4, r5	// r4 = 20 + 2 = 22
	usub8 r4, r4, r5	// r4 = 22 - 2 = 20

	// Convert byte to short (halfword)
	sxtb16 r6, r4
	mov r4, r6
	mov r6, #0

	mov r5, #240

	// Short math
	// TODO(Grant): mul and div
	smulbb r4, r5, r4	// r4 = 240 * 20 = 4800
	udiv r4, r4, r5		// r4 = 4800 / 240 = 20
	uadd16 r4, r5, r4	// r4 = 240 + 20 = 260
	usub16 r4, r4, r5	// r4 = 260 - 240 = 20

	// Convert short to int (word)
	sxth r6, r4
	mov r4, r6
	mov r6, #0

	// r4 = 20, r6 = 240
	// TODO(Grant): convert to 64 bit (or long)
	// Number will be stored into r4 and r5
	// Other number will be stored into r6 and r7
	mov r6, r5
	mov r7, #0
	
	mov r5, #0

	// 64 bit subtraction
	
	subs r2, r6, r4
	sbc r3, r7, r5
	
//	bl print

	mov r0, #62
	bl check_pow_2
	cmp r0, #0
	bne main_else_1
	ldr r0, =false_message
	b main_end
main_else_1:	
	ldr r0, =true_message
main_end:
	bl print
	mov r0, r4
	pop {r4-r6,pc}

.balign 4
_start:
	bl main

	mov r7, #0x1
	svc #0
