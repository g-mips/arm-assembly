.text
.code 16
	
.global check_pow_2
.global get_length
.global add_char
.global utoa
.global print
.global get_input
	
//------------------- CHECK_POW_2 -------------------//
// r0 - Number (Up to 32 bits)
// Loops through 
// a NULL character is founds. Returns length in r0.
//-------------------------------------------------//
.balign 2
check_pow_2:
	push {r4-r6,lr}

	// r4 - counter of ones
	// r5 - pow 2 checker
	mov r4, #0
	mov r5, #1

check_pow_2_loop:	
	// Have we gotten two many bits?
//	cmp r4, #1
//	ble check_pow_2_loop

	mov r6, r5
	and r6, r6, r0
	cmp r6, #0
	
	// Advance one on both counters
	beq check_pow_2_dont_advance
	add r4, #1
check_pow_2_dont_advance:	
	lsl r5, #1

	// Have we gone through each bit?
	cmp r5, #0
	bne check_pow_2_loop

	// There should be one one if it is a power of 2. Otherwise don't!
	cmp r4, #1
	bne check_pow_2_end
	mov r0, #1
check_pow_2_end:	
	mov r0, #0
	
	pop {r4-r6,pc}
	
//------------------- GET_LENGTH -------------------//
// r0 - Buffer Pointer
// Counts each character in the Buffer Pointer until
// a NULL character is founds. Returns length in r0.
//-------------------------------------------------//
.balign 2
get_length:
	push {r4-r5,lr}

	mov r1, #0
	
	b get_length_loop_1_cond
get_length_loop_1:
	add r0, r0, #1
	add r1, r1, #1
get_length_loop_1_cond:
	ldrb r4,[r0]
	mov r5, #255
	and r5, r4, r5
	cmp r5, #0
	bne get_length_loop_1

	mov r0, r1
	pop {r4-r5,pc}
	
//-------------------- ADD_CHAR --------------------//
// r0 - Buffer Pointer (32 bits)
// r1 - Character to add (byte)
// Adds r1 to r0 once the NULL character is found.
//-------------------------------------------------//	
.balign 2
add_char:
	// r0 - pointer to buffer
	// r1 - char to add
	push {r4-r5,lr}

	b add_char_loop_1_cond
add_char_loop_1:	
	add r0, r0, #1
add_char_loop_1_cond:
	ldr r4,[r0]
	mov r5, #255
	and r5, r4, r5
	cmp r5, #0
	bne add_char_loop_1

	strb r1, [r0]
	add r0, r0, #1
	mov r1, #0
	str r1, [r0]
	
	pop {r4-r5,pc}

//---------------------- ATOI ---------------------//
// r0 - Buffer Pointer (32 bits)
// r1 - Number to be converted (up to an uint)
// Converts r1 to a string and stores it in r0
//-------------------------------------------------//	
.balign 2
atoi:
	push {lr}

	pop {pc}
	
//---------------------- UTOA ---------------------//
// r0 - Buffer Pointer (32 bits)
// r1 - Number to be converted (up to an uint)
// Converts r1 to a string and stores it in r0
//-------------------------------------------------//	
.balign 2
utoa:
	push {r4,lr}

	bl utoa_r

	// We need to add the NULL character at the end
	mov r4, #0
	strb r4, [r0]
	add r0, r0, #1
	
	pop {r4,pc}

.balign 2
utoa_r:	
	push {r4-r6,lr}

	mov r4, r0		// r4 contains buffer pointer
	mov r5, r1		// r5 contains number

	mov r0, r1		// Move number into r0
	mov r6, #10
	udiv r0, r6		// Get the number divided by 10

	lsl r6, r0, #3
	sub r5, r5, r6
	lsl r6, r0, #1
	sub r5, r5, r6		// These subs give me the remainder of udiv

	// So now we have r0 - quotient and r5 - remainder
	// The remainder is the new character that will be put onto the string!

	cmp r0, #0		// Is quotient non-zero?
	beq utoa_r_dont_mov
	mov r1, r0		// If it isn't zero, move quotient into r1. This prepares it for the recursive call.
utoa_r_dont_mov:	
	mov r0, r4		// character is moved into r0
	beq utoa_r_dont_branch
	bl utoa_r		// If the quotient is zero, we are done and we don't call
utoa_r_dont_branch:	
	add r5, r5, #48		// This converts the remainder to a character
	strb r5, [r0]		// We then stick the new character on the buffer
	add r0, r0, #1

	pop {r4-r6,pc}

//------------------- GET_INPUT -------------------//
// r0 - Buffer to store input
// r1 - Length of buffer
// Gets input from the user from stdin
//-------------------------------------------------//
.balign 2
get_input:
	push {r4-r5,r7,lr}

	mov r4, r0
	
	mov r2, r1
	mov r1, r0
	mov r0, #0
	mov r7, #3
	svc #0
	
	add r4, r4, r0
	mov r5, #0
	
	strb r5, [r4]
	
	pop {r4-r5,r7,pc}

//--------------------- PRINT ---------------------//
// r0 - String to be printed
// Prints r0 to console. r0 NEEDS to end with NULL.
//-------------------------------------------------//	
.balign 2
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
