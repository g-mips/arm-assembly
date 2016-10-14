.data

.balign 4
message:
.asciz "%d\n"
	
.text

.global main
	
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

	// TODO(Grant): Heap Memory Using Malloc
	add sp, sp, #4
	pop {r4,pc}
