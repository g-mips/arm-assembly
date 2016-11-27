.set READ, 3
.set WRITE, 4
.set OPEN, 5
.set CLOSE, 6

.set O_APPEND, 1024
.set O_ASYNC, 8192
.set O_CLOSEXEC, 524288
.set O_CREAT, 64
.set O_RDONLY, 0
.set O_WRONLY, 1
.set O_RDWR, 2

.set S_IWOTH, 00002
.set S_IROTH, 00004
.set S_IRUSR, 00400
.set S_IWUSR, 00200
.set S_IRGRP, 00040
.set S_IWGRP, 00020

.set BRK, 45

.set MALLOC_STRUCT_SIZE, 12
.data

// Pointer to head of malloc linked list
malloc_base:
.word 0 // This is an address
	
.text

.global pow
.global check_pow_2
.global check_pow_2_op
.global get_length
.global add_char
.global utoa
.global atoi
.global get_input
.global print
.global copy_string
.global malloc
.global free
	
//----------------- FIND_FREE_BLOCK ----------------//
// r0 - Used to point to the last block of the linked list
//      if there is no free space left, but is passed in like
//      a double pointer. 
// r1 - Biggest size the block can be
//-------------------------------------------------//	
.balign 4
find_free_block:
	push {r4-r5,lr}

	ldr r4, =malloc_base			// malloc_base address
	ldr r4, [r4]				// address global_base is pointing to

	b .Lfind_free_block_loop_1_check
.Lfind_free_block_loop_1:
	str r4, [r0]				// puts the previous chunk into last
	ldr r5, [r4, #4]			// address that contains the address of where the next block is located
//	ldr r5, [r5]				// address of where the next block is located
//	str r5, [r4]				// store address of where the next block is located
	mov r4, r5
.Lfind_free_block_loop_1_check:
	cmp r4, #0				// checks to see if current address is null
	beq .Lfind_free_block_end

	ldr r5, [r4, #8]			// load free value into r5
	cmp r5, #0				// checks to see if block is free
	beq .Lfind_free_block_loop_1

	ldr r5, [r4]				// load size value into r5
	cmp r5, r1				// checks to see if block is big enough
	blt .Lfind_free_block_loop_1
.Lfind_free_block_end:
	mov r0, r4
	pop {r4-r5,pc}

//----------------- REQUEST_SPACE -----------------//
// r0 - Used to point to the last block of the linked list
//      if there is no free space left
// r1 - Size that is requested for the block
//-------------------------------------------------//	
.balign 4
request_space:
	push {r4-r5,r7,lr}
	sub sp, sp, #40

	str r0, [sp]
	str r1, [sp, #36]
	
	mov r7, #BRK
	mov r0, #0
	svc #0

	str r0, [sp, #12]

	mov r7, #BRK
	ldr r4, [sp, #36]
	add r0, r4, r0
	add r0, r0, #MALLOC_STRUCT_SIZE
	svc #0

	str r0, [sp, #24]
	
	ldr r4, [sp, #12]
	cmp r0, r4
	bne .Lrequest_space_success

	mov r0, #0
	b .Lrequest_space_end
.Lrequest_space_success:
	ldr r0, [sp]
	cmp r0, #0
	beq .Lrequest_space_last_not_null

	ldr r4, [sp, #12]
	str r4, [r0, #4]
.Lrequest_space_last_not_null:
	ldr r4, [sp, #12]
	ldr r5, [sp, #36]
	str r5, [r4]
	mov r5, #0
	str r5, [r4, #4]
	str r5, [r4, #8]
	mov r0, r4
.Lrequest_space_end:
	add sp, sp, #40
	pop {r4-r5,r7,pc}

//--------------------- MALLOC ---------------------//
// r0 - Size of requested block
// 
//-------------------------------------------------//	
.balign 4
malloc:
	push {r4,lr}
	sub sp, sp, #28

	str r0, [sp, #24]
	
	cmp r0, #0
	beq .Lmalloc_end

	ldr r4, =malloc_base				// address of where malloc_base is located
	ldr r4, [r4]					// address that malloc_base contains
	cmp r4, #0
	bne .Lmalloc_not_first

// First time calling malloc code
	mov r0, #0
	ldr r1, [sp, #24]				// size (just a number)
	// TODO(Grant): Implement request_space
	bl request_space

	str r0, [sp]					// address of where the block is stored
	
	cmp r0, #0
	beq .Lmalloc_end

	ldr r4, =malloc_base				// address of where malloc_base is located
	ldr r0, [sp]					// gets the address of where the block is stored
	str r0, [r4]					// stores the address of where the block is stored into the address that malloc_base contains
	b .Lmalloc_pre_end
.Lmalloc_not_first:
	ldr r4, =malloc_base				// address of where malloc_base is located
	ldr r4, [r4]					// address that malloc_base contains
	str r4, [sp, #12]				// stores the address that malloc_base contains into a local variable called last

	add r0, sp, #12					// stores the address of the last variable into r0
	ldr r1, [sp, #24]				// size (just a number)
	bl find_free_block

	str r0, [sp]
	
	cmp r0, #0
	beq .Lmalloc_no_free

	mov r4, #0
	str r4, [r0, #8]
	b .Lmalloc_pre_end
.Lmalloc_no_free:
	ldr r0, [sp, #12]
	ldr r1, [sp, #24]
	bl request_space

	str r0, [sp]

	cmp r0, #0
	beq .Lmalloc_end
.Lmalloc_pre_end:
	ldr r0, [sp]
	add r0, r0, #12
.Lmalloc_end:
	add sp, sp, #28
	pop {r4,pc}

//--------------------- FREE ----------------------//
// r0 - Address to free
// 
//-------------------------------------------------//
free:
	push {r4,lr}
	
	cmp r0, #0
	beq .Lfree_end

	sub r0, r0, #MALLOC_STRUCT_SIZE
	mov r4, #1
	str r4, [r0, #8]
.Lfree_end:
	pop {r4,pc}
	
//---------------------- POW ----------------------//
// r0 - Base Number
// r1 - Power Number
// Computes r0^r1
//-------------------------------------------------//	
.balign 4
pow:
	push {r4-r5,lr}

	// Edge case where power number is 0
	mov r4, r0
	mov r0, #1
	cmp r1, #0
	beq pow_end

	// Restore r0 if edge case was untrue
	mov r0, r4
	mov r5, #1
	b pow_loop_1_check
pow_loop_1:	
	mul r0, r4, r0
	add r5, r5, #1
pow_loop_1_check:	
	cmp r5, r1
	blt pow_loop_1

pow_end:
	pop {r4-r5,pc}
	
//------------------- CHECK_POW_2 -------------------//
// r0 - Number (Up to 32 bits)
// Loops through 
// a NULL character is founds. Returns length in r0.
//-------------------------------------------------//
.balign 4
check_pow_2:
	push {r4-r6,lr}

	// r4 - counter of ones
	// r5 - pow 2 checker
	mov r4, #0
	mov r5, #1

check_pow_2_loop:
	// TODO(Grant): Fix this and figure out how to implement it
	// Have we gotten two many bits?
//	cmp r4, #1
//	ble check_pow_2_loop

	ands r6, r5, r0

	// Advance one on both counters
	addne r4, #1
	lsl r5, #1

	// Have we gone through each bit?
	cmp r5, #0
	bne check_pow_2_loop

	// There should be one one if it is a power of 2. Otherwise don't!
	cmp r4, #1
	moveq r0, #1
	movne r0, #0
	
	pop {r4-r6,pc}

//----------------- CHECK_POW_2_OP -----------------//
// r0 - Number (Up to 32 bits)
//-------------------------------------------------//
.balign 4
check_pow_2_op:	
	push {r4-r5,lr}

	cmp r0, #0
	beq .Lcheck_pow_2_op_false
	
	clz r4, r0
	lsl r0, r0, r4

	mov r5, #1
	mov r5, r5, lsl #31

	cmp r0, r5
	bne .Lcheck_pow_2_op_false

	mov r0, #1
	b .Lcheck_pow_2_op_end
.Lcheck_pow_2_op_false:
	mov r0, #0
.Lcheck_pow_2_op_end:
	pop {r4-r5,pc}
	
//------------------- GET_LENGTH -------------------//
// r0 - Buffer Pointer
// Counts each character in the Buffer Pointer until
// a NULL character is founds. Returns length in r0.
//-------------------------------------------------//
.balign 4
get_length:
	push {r4,lr}

	mov r1, #0
	
	b get_length_loop_1_cond
get_length_loop_1:
	// r0 - Buffer pointer
	// r1 - Length
	add r0, r0, #1
	add r1, r1, #1
get_length_loop_1_cond:
	// We only want to compare the next byte in our "string"
	ldrb r4,[r0]
	cmp r4, #0
	bne get_length_loop_1

	// Move length into return register
	mov r0, r1
	pop {r4,pc}
	
//-------------------- ADD_CHAR --------------------//
// r0 - Buffer Pointer (32 bits)
// r1 - Character to add (byte)
// Adds r1 to r0 once the NULL character is found.
// WARNING: This assumes there is enough room for
// another character!
//-------------------------------------------------//	
.balign 4
add_char:
	// r0 - pointer to buffer
	// r1 - char to add
	push {r4-r5,lr}

	b add_char_loop_1_cond
add_char_loop_1:
	// Go to next byte (or character)
	add r0, r0, #1
add_char_loop_1_cond:
	ldrb r4,[r0]
	cmp r4, #0
	bne add_char_loop_1

	// Add the character and then the null character
	strb r1, [r0], #1
	mov r1, #0
	str r1, [r0]
	
	pop {r4-r5,pc}

//---------------------- ATOI ---------------------//
// r0 - Buffer Pointer to be converted (32 bits)
// Converts a string into a number
//-------------------------------------------------//	
.balign 4
atoi:
	push {r4-r7,lr}
	sub sp, sp, #8
	
	// Save buffer pointer and set length to 0
	mov r6, r0
	mov r5, #0
	mov r1, #0

	// r0 - Current buffer pointer
	// r1 - Number
	// r4 - Current byte
	// r5 - Length
	// r6 - saved buffer pointer
	b atoi_loop_1_check
atoi_loop_1:
	add r5, r5, #1
	add r0, r0, #1
atoi_loop_1_check:
	// Get the current byte
	ldrb r4, [r0]
	
	// Is our current byte a number?
	cmp r4, #48
	blt atoi_after_loop_1

	cmp r4, #57
	ble atoi_loop_1

atoi_after_loop_1:	
	// Restore pointer
	mov r0, r6

	// Get length - 1
	sub r5, r5, #1

	// r0 - Current buffer pointer
	// r1 - Number
	// r4 - Current byte
	// r5 - Length - 1
	// r6 - Saved buffer pointer
	b atoi_loop_2_check
atoi_loop_2:	
	// Subtract by "0" (#48)
	sub r4, r4, #48
	str r0, [sp]
	str r1, [sp, #4]

	mov r0, #10
	mov r1, r5
	bl pow

	// r0 contains 10^length-1-current_position
	mul r7, r4, r0

	ldr r0, [sp]
	ldr r1, [sp, #4]

	add r1, r1, r7
	
	// Advance to next byte
	add r0, r0, #1
	sub r5, r5, #1
atoi_loop_2_check:
	// Get the current byte
	ldrb r4, [r0]
	
	// Is our current byte a number?
	cmp r4, #48
	blt atoi_end

	cmp r4, #57
	ble atoi_loop_2

atoi_end:
	mov r0, r1

	add sp, sp, #8
	pop {r4-r7,pc}
	
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
	// Think of this equation: N = D * Q + R
	push {r4-r6,lr}

	mov r4, r0		// r4 contains buffer pointer
	mov r5, r1		// r5 contains number

	mov r0, r1		// Move number into r0
	mov r6, #10
	udiv r0, r6		// Get the number divided by 10

	// We know N, D, and Q. Solving for R is: R = N - D * Q
	// r5 contains N. r0 contains Q.
	// r0, lsl #3 gives me Q * (D - 2).
	// r0, lsl #1 gives me Q * (D - 8).
	// OR in otherwords Q * D
	sub r5, r5, r0, lsl #3
	sub r5, r5, r0, lsl #1	// These subs give me the remainder of udiv

	// So now we have r0 - quotient and r5 - remainder
	// The remainder is the new character that will be put onto the string!

	cmp r0, #0		// Is quotient non-zero?
	movne r1, r0		// If it isn't zero, move quotient into r1. This prepares it for the recursive call.
	mov r0, r4		// character is moved into r0
	blne utoa_r		// If the quotient is zero, we are done and we don't call

	add r5, r5, #48		// This converts the remainder to a character
	strb r5, [r0], #1	// We then stick the new character on the buffer

	pop {r4-r6,pc}

//------------------- GET_INPUT -------------------//
// r0 - Buffer to store input
// r1 - Length of buffer
// Gets input from the user from stdin
//-------------------------------------------------//
.balign 4
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

//------------------ COPY_STRING -------------------//
// r0 - String to copy
// r1 - Where to copy
// r2 - Length of string	
// 
//-------------------------------------------------//	
.balign 4
copy_string:
	push {r4-r5,lr}

	mov r5, #0
	b .Lcopy_string_loop_1_check
.Lcopy_string_loop_1:
	strb r4, [r1]
	add r1, r1, #1
	add r0, r0, #1
	add r5, r5, #1
.Lcopy_string_loop_1_check:
	cmp r2, r5
	beq .Lcopy_string_loop_1_end
	ldrb r4, [r0]
	cmp r4, #0
	bne .Lcopy_string_loop_1
.Lcopy_string_loop_1_end:
	pop {r4-r5,pc}
