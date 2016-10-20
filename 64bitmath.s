.data

longstring:
.asciz "%llu\n"

.text
.global main
main:
	push {r4, r5, r6, r7, r8, r9, lr}

	// ADDITION
	adr r0, longints
	ldrd r4, [r0]
	ldrd r6, [r0, #8]
	adds r2, r4, r6
	adc r3, r5, r7
	ldr r0, longstring_a
	bl printf

	// SUBTRACTION
	
	// MULTIPLICATION

	//   xy
	//   zw
	// ------
	// (w, x) (w, y)
	// (z, y)
	// ------ [NOTE: y is now 2nd part of the lower register of w * y]
	// (x + y + w)  =  y
	
	ldrd r4, [r0]		// x,y
	ldrd r6, [r0, #8]	// z,w
	umull r0, r1, r4, r6	// y * w
	umull r2, r3, r5, r6	// x * w
	umull r8, r9, r4, r7		// z * y
	add r1, r1, r0		// y + w
	add r1, r1, r5		// (y + w) + x

	mov r2, r0
	mov r3, r1
	ldr r0, longstring_a
	bl printf

	// DIVISION
	
	pop {r4, r5, r6, r7, r8, r9, lr}

longints:
.word 0xcb417800
.word 0x2
.word 0xa43b7400
.word 0xb
longstring_a:
.word longstring
