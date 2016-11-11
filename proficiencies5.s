.data

.balign 4
string_message:	 .asciz "%s\n"
	
.balign 4
message: .asciz "%d\n"

.balign 4
format:	.asciz "%d"

.balign 4
float_message:	 .asciz "%.4f\012"

.balign 4
float_1:	.float 5.89

.balign 4
float_2:	.float 4.21

.balign 4
float_3:	.float 1.1135

.balign 4
float_4:	.float 9.234

.balign 4
float_5:	.float 3.14

.balign 4
float_6:	.float 2.594

.bss

.balign 4
string:	.skip 7
	
.text

.global main

.balign 4
floating_point_math:
	push {r4-r5,lr}
	vpush {s16-s21}
	mov r5, #0b10011 // stride = 1 len = 3
	mov r5, r5, lsl #16
	vmrs r4, fpscr
	orr r4, r4, r5
	vmsr fpscr, r4

	vmov.f32 s16, s0
	ldr r4, =float_1
	vldr s17, [r4]
	ldr r4, =float_2
	vldr s18, [r4]	
	vmov.f32 s19, s1
	ldr r4, =float_3
	vldr s20, [r4]	
	ldr r4, =float_4
	vldr s21, [r4]	

	vadd.f32 s8, s16, s19

	ldr r0, =float_message
	mov r2, #3
	vcvt.f64.f32 d0, s8
	fmrrd r2, r3, d0
	bl printf

	ldr r0, =float_message
	vcvt.f64.f32 d0, s9
	fmrrd r2, r3, d0
	bl printf

	ldr r0, =float_message	
	vcvt.f64.f32 d0, s10
	fmrrd r2, r3, d0
	bl printf

	ldr r0, =float_message	
	vcvt.f64.f32 d0, s11
	fmrrd r2, r3, d0
	bl printf

	// Exit Code
	mov r5, #31
	mov r5, r5, lsl #16
	vmrs r4, fpscr
	bic r4, r4, r5
	vmsr fpscr, r4
	vpop {s16-s21}
	pop {r4-r5,pc}
	
.balign 4
allocation:
	push {r4-r6,lr}

	mov r0, #5
	bl malloc

	mov r6, r0
	
	mov r4, #3
	mov r5, #97
	b allocation_loop_check
allocation_loop:
	strb r5, [r0]
	add r5, r5, #1
	sub r4, r4, #1
	add r0, r0, #1
allocation_loop_check:
	cmp r4, #0
	bne allocation_loop

	mov r5, #0
	strb r5, [r0]
	
	ldr r0, =string_message
	mov r1, r6
	bl printf

	mov r0, r6
	bl free
	
	pop {r4-r6,pc}

.balign 4
print_4_nums:
	push {r4,fp,lr}
	mov fp, sp
	sub sp, sp, #16
	
	ldr r4, [fp, #12]
	str r0, [sp]
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r3, [sp, #12]
	str r4, [sp, #16]

	ldr r0, =message
	ldr r1, [sp]
	bl printf

	ldr r0, =message
	ldr r1, [sp, #4]
	bl printf

	ldr r0, =message
	ldr r1, [sp, #8]
	bl printf

	ldr r0, =message
	ldr r1, [sp, #12]	
	bl printf

	ldr r0, =message
	ldr r1, [sp, #16]	
	bl printf

	add sp, sp, #16
	mov sp, fp
	pop {r4,fp,pc}

.balign 4
main:
	push {r4,lr}
	sub sp, sp, #4
	
	mov r0, #1
	mov r1, #2
	mov r2, #3
	mov r3, #4
	mov r4, #5
	str r4, [sp]
	bl print_4_nums

	ldr r4, =float_5
	vldr s0, [r4]
	ldr r4, =float_6
	vldr s1, [r4]
	bl floating_point_math

	bl allocation
	
	// TODO(Grant): Heap Memory Using Malloc
	add sp, sp, #4
	pop {r4,pc}
