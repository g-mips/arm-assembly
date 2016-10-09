.data

.balign 4
b_num:
.byte 124

.balign 4
string:
.skip 5

.text

.global _start

add_char:
	// r0 - pointer to buffer
	// r1 - char to add
	push {r4,lr}

	b add_char_loop_1_cond
add_char_loop_1:	
	add r0, r0, #1
add_char_loop_1_cond:
	ldr r4,[r0]
	and r5, r4, #255
	cmp r5, #0
	bne add_char_loop_1

	strb r1, [r0], #1
	mov r1, #0
	str r1, [r0]
	
	pop {r4,pc}
	
utoa:
	push {r4,lr}

	bl utoa_r
	mov r4, #0
	strb r4, [r0], #1
	
	pop {r4,pc}

utoa_r:	
	push {r4-r6,lr}

	mov r4, r0		// r4 contains buffer pointer
	mov r5, r1		// r5 contains number

	mov r0, r1		// Move number into r0
	mov r6, #10
	udiv r0, r6		// Get the number divided by 10

	sub r5, r5, r0, LSL #3
	sub r5, r5, r0, LSL #1	// These subs give me the remainder of udiv

	// So now we have r0 - quotient and r5 - remainder
	// The remainder is the new character that will be put onto the string!

	cmp r0, #0		// Is quotient non-zero?
	movne r1, r0		// If it isn't zero, move quotient into r1. This prepares it for the recursive call.
	mov r0, r4		// character is moved into r0
	blne utoa_r		// If the quotient is zero, we are done and we don't call

	add r5, r5, #48		// This converts the remainder to a character
	strb r5, [r0], #1	// We then stick the new character on the buffer

	pop {r4-r6,pc}

print:
	push {r7,lr}

	// TODO(Grant): Code to determine length of r0, put in r2
	
	mov r1, r0
	mov r0, #1
	mov r7, #4
	svc #0
	
	pop {r7,pc}
	
main:
	push {lr}

	ldr r0, pstring
	ldr r1, pb_num
	ldr r1, [r1]
	bl utoa

	ldr r0, pstring
	mov r1, #10
	bl add_char
	
	ldr r1, pstring
	mov r0, #1
	mov r2, #4
	mov r7, #4
	svc #0
	
	pop {pc}
pstring: 	.word string
pb_num:		.word b_num
	
_start:
	bl main
	
	mov r7, #0x1
	svc #0

