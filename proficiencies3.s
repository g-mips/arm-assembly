.data

.balign 4
b_num:
.byte 124

.balign 4
message:
.asciz "Please enter a number: "
	
.bss

.balign 4
.lcomm string, 5
/*
.balign 4
.lcomm b_num, 1
*/	
.text

.global _start

//------------------- GET_LENGTH -------------------//
// r0 - Buffer Pointer
// Counts each character in the Buffer Pointer until
// a NULL character is founds. Returns length in r0.
//-------------------------------------------------//
.balign 4
get_length:
	push {r4-r5,lr}

	mov r1, #0
	
	b get_length_loop_1_cond
get_length_loop_1:
	add r0, r0, #1
	add r1, r1, #1
get_length_loop_1_cond:
	ldr r4,[r0]
	and r5, r4, #255
	cmp r5, #0
	bne get_length_loop_1

	mov r0, r1
	pop {r4-r5,pc}
	
//-------------------- ADD_CHAR --------------------//
// r0 - Buffer Pointer (32 bits)
// r1 - Character to add (byte)
// Adds r1 to r0 once the NULL character is found.
//-------------------------------------------------//	
.balign 4
add_char:
	// r0 - pointer to buffer
	// r1 - char to add
	push {r4-r5,lr}

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
	
	pop {r4-r5,pc}

//---------------------- UTOA ---------------------//
// r0 - Buffer Pointer (32 bits)
// r1 - Number to be converted (up to an uint)
// Converts r1 to a string and stores it in r0
//-------------------------------------------------//	
.balign 4
utoa:
	push {r4,lr}

	bl utoa_r

	// We need to add the NULL character at the end
	mov r4, #0
	strb r4, [r0], #1
	
	pop {r4,pc}

.balign 4
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

//--------------------- PRINT ---------------------//
// r0 - String to be printed
// Prints r0 to console. r0 NEEDS to end with NULL.
//-------------------------------------------------//	
.balign 4
print:
	push {r4,r7,lr}

	mov r4, r0

	bl get_length
	mov r1, r4
	mov r2, r0
	mov r0, #1
	mov r7, #4
	svc #0
	
	pop {r4,r7,pc}

.balign 4
main:
	push {lr}
/*	 
	ldr r0, =message
	bl print

	mov r0, #0
	mov r1, =string
	mov r2, #5
	mov r7, #3
	svc #0
*/	
	ldr r0, =string
	ldr r1, =b_num
	ldr r1, [r1]
	bl utoa

	ldr r0, =string
	mov r1, #10
	bl add_char

	ldr r0, =string
	bl print

	mov r0, #0
	pop {pc}

.balign 4
_start:
	bl main

	mov r7, #0x1
	svc #0

