.data
longstring:
	.asciz "%llu\n"


.text
.global main
main:
	push {r4-r10, lr}
	adr r8, longints
	ldrd r4, [r8]
	ldrd r6, [r8, #8]

	// Print first value
	mov r2, r4
	mov r3, r5
	ldr r0, longstring_a
	bl printf

	// Print second value
	mov r2, r6
	mov r3, r7
	ldr r0, longstring_a
	bl printf

	// Add values and print
	adds r2, r4, r6
	adc r3, r5, r7
	ldr r0, longstring_a
	bl printf

//		     (r5, r4)
//		     (r7, r6)
//		     --------
//		        (r4 * r6) -> (r3, r2)
//		   (r5 * r6)  -> (r1, r0)
//		   (r4 * r7)  -> (r9, r8)
//	      (r5 * r7) -> Nowhere, as this is bits 65 to 96
//      	     --------
//		((r0 + r3 + r8), r2)
mult:
	ldrd r4, [r8]		// (r5, r4)
	ldrd r6, [r8, #8]	// (r7, r6)
	umull r2, r3, r4, r6	// r4 * r6 -> (r3, r2)
	umull r0, r1, r5, r6	// r5 * r6 -> (r1, r0)
	umull r8, r9, r4, r7	// r4 * r7 -> (r9, r8)
	add r3, r3, r0		// r0 + r3 -> r3
	add r3, r3, r8		// (r0 + r3) + r8 -> r3

	ldr r0, longstring_a
	bl printf

	pop {r4-r10, pc}

longints:
	.word 0xcb417800
	.word 0x2
	.word 0xa43b7400
	.word 0xb
longstring_a:
	.word longstring
  
