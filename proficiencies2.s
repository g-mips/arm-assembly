/******** DATA SECTION *******/
.data

// Number to start with
.balign 4
num:
.word 0

/******** TEXT SECTION *******/
.text
	
.global _start

add_x_to:
	push {lr}

	ldr r4, [r0]
	add r4, r4, r1
	str r4, [r0]
	
	pop {pc}

sub_x_to:
	push {lr}

	ldr r4, [r0]
	sub r4, r4, r1
	str r4, [r0]
	
	pop {pc}

mul_x_to:
	push {lr}

	ldr r4, [r0]
	mul r4, r1, r4
	str r4, [r0]
	
	pop {pc}
	
div_x_to:
	push {lr}

	ldr r4, [r0]
	add r4, r4, r1
	str r4, [r0]
	
	pop {pc}
	
_start:
	mov r7, #1

	// Call add_x_to
	ldr r0, =num
	mov r1, #5
	bl add_x_to

	// Call sub_x_to
	mov r1, #1
	bl sub_x_to

	// Call mul_x_to
	mov r1, #3
	bl mul_x_to

//	mov r1, #2		
//	bl div_x_to
	
	ldr r0, =num
	ldr r0, [r0]
	
	svc #0
