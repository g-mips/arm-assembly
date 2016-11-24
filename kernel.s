.section .init
.globl _start
_start:
	ldr r0, =0x3F200000

	// Enable Output to pin 16
	ldr r1, [r0,#4] // 0x3F200004
	mov r2, #7
	and r1, r2, lsl #18 // 0x0
	mov r2, #1
	orr r1, r2, lsl #18 // 0b01000000000000000000
	str r1, [r0,#4]

	mov r1, #1
	lsl r1, #15
.Linf_loop:
	// Turn on
	str r1, [r0,#0x20]

	// Wait a certain amount of time
	mov r2,#0x3F0000
.Lwait_1:
	sub r2,#1
	cmp r2,#0
	bne .Lwait_1

	// Turn off
	str r1, [r0,#0x2C]

	// Wait a certain amount of time
	mov r2,#0x3F0000
.Lwait_2:
	sub r2,#1
	cmp r2,#0
	bne .Lwait_2

	b .Linf_loop
