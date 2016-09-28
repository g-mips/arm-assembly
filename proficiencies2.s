/******** DATA SECTION *******/
.data

// Number to start with
.balign 4
time:
.word 0
.word 0
	
.balign 4
user_input:
.skip 12

.balign 4
message:
.ascii "Please enter a number: "

length_of_message = . - message

.balign 4
number_message_g:
.ascii "Your number is greater than 10\n"

len_of_g = . - number_message_g

.balign 4
number_message_e:
.ascii "Your number is equal to 10\n"

len_of_e = . - number_message_e

.balign 4
number_message_l:
.ascii "Your number is less than 10\n"

len_of_l = . - number_message_l
	
/* 2 nums */
.balign 4
my_struc:
.skip 8
	
/******** TEXT SECTION *******/
.text
	
.global _start

store_into_struct:
	push {lr}

	ldr r4, [r0]

	pop {pc}
	
add_x_to:
	push {r4-r6,lr}

	ldr r4, [r0]
	add r5, r0, #4

	ldr r6, [r5]
	add r4, r4, r6
	
	str r4, [r0]
	
	pop {r4-r6,pc}

sub_x_to:
	push {r4,lr}

	ldr r4, [r0]
	sub r4, r4, r1
	str r4, [r0]
	
	pop {r4,pc}

mul_x_to:
	push {r4,lr}		// STMDB sp!, {r4,lr} OR STMFD sp!, {r4,lr} OR STR LR, [sp, #-4]!

	ldr r4, [r0]
	mul r4, r1, r4
	str r4, [r0]
	
	pop {r4,pc}		// LDMIA sp!, {r4,pc} OR LDMFD sp!, {r4,pc} OR LDR PC, [sp], #4
	
div_x_to:
	// r0 N.
	// r1 D.
	// r2 Q.
	// r3 R.
	push {lr}
	
	clz  r3, r0 		// Count the leading zeros of N
	clz  r2, r1 		// Count the leading zeros of D

	sub  r3, r2, r3		// Zeros of D minus Zeros of N (r2 - r3)
	add r3, r3, #1 		// Add one extra

	mov r2, #0 		// Start Q with 0

	b div_x_to_loop_check
div_x_to_loop:	
	cmp r0, r1, lsl r3       /* Compute r0 - (r1 << r3) and update cpsr */
	adc r2, r2, r2           /* r2 ← r2 + r2 + C. Note that if r0 >= (r1 << r3) then C=1, C=0 otherwise */
	subcs r0, r0, r1, lsl r3 /* r0 ← r0 - (r1 << r3) if C = 1 (this is, only if r0 >= (r1 << r3) ) */
div_x_to_loop_check:
	subs r3, r3, #1          /* r3 ← r3 - 1 */
	bpl div_x_to_loop        /* if r3 >= 0 (N=0) then branch to div_x_to_loop */

	mov r0, r2
		
	pop {pc}
	
_start:
/*
	sub sp, sp, #12

	mov r4, #3
	mov r5, #5
	
	str r4, [sp]
	str r5, [sp, #4]
	
	add sp, sp, #12
	*/
	sub sp, sp, #8		// sp = sp - 4

	// Prepare my_struc using the stack
	mov r4, #5		// r0 = 5
	str r4, [sp]
	ldr r4, =my_struc
	ldr r5, [sp]
	str r5, [r4]
	add r4, r4, #4
	add r5, r5, #5
	str r5, [r4]
	sub r4, r4, #4
	
	// Call add_x_to
	ldr r0, =my_struc
	bl add_x_to

	// Call sub_x_to
	mov r0, r4
	mov r1, #1
	bl sub_x_to

	mov r5, #0
_start_loop:
	// Call mul_x_to
	mov r0, r4	
	mov r1, #2
	bl mul_x_to

	ldr r0, [r4]
	mov r1, #2		
	bl div_x_to

	str r0, [r4]
_start_loop_cond:
	add r5, r5, #1
	cmp r5, #3
	blt _start_loop
_start_end:
	// Get time
	ldr r0, =time
	mov r7, #0xd
	svc #0

	// TODO(Grant): Write Time to screen
	
	// Write message to screen
	mov r0, #1
	ldr r1, =message
	ldr r2, =length_of_message
	mov r7, #0x4
	svc #0

	// Get user input
	mov r0, #0
	ldr r1, =user_input
	mov r2, #12
	mov r7, #0x3
	svc #0

	// TODO(Grant): User input will return the length in r0 so use it!
	
	ldr r5, =user_input
	ldr r5, [r5]
	cmp r5, #10
	// If greater, display text on screen saying it's greater
	ble _start_else_if
	ldr r1, =number_message_g
	ldr r2, =len_of_g
	b end
	// If equal to, display text on screen saying it's equal
_start_else_if:
	cmp r5, #10
	bne _start_else
	ldr r1, =number_message_e
	ldr r2, =len_of_e
	b end	
	// Else, display test on screen saying it's less than
_start_else:
	ldr r1, =number_message_l
	ldr r2, =len_of_l
end:
	str r0, [sp, #4]

	mov r0, #1
	mov r7, #0x4
	svc #0

	// Display number to screen
	mov r0, #1
	ldr r1, =user_input
	ldr r2, [sp, #4]
	mov r7, #0x4
	svc #0
	
	// Put the number that was manipulated the whole time back into r0 for viewing on the error code
	ldr r0, [r4]
	add sp, sp, #4
	mov r7, #1
	svc #0
