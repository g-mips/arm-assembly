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

.data

debug:
file_name:
.asciz "test.txt"
	
message_to_write:
.ascii "This is a message\n"
	
message_to_read:
.skip 19
	
heap:
.word 0

heap_end:
.word 0
	
choose_a_number:
.asciz "Please give me a number: "

number_to_store:
.skip 3

.text

.global _start

/*
	This "class" looks like this:
	char name[20]
	greet
	getName
	setName
*/
	
.balign 4
person_constructor:
	push {r4,lr}

	ldr r4, =person_vtable
	str r4, [r0, #20]
	
	pop {r4,pc}

.balign 4
person_get_name:
	push {lr}

	ldr r0, [r0]
	
	pop {pc}

.balign 4
person_set_name:
	push {r4,lr}

	str r1, [r0]
	
	pop {r4,pc}

.balign 4
person_vtable:
.word 0  // FP to greet
.word person_get_name // FP to person_get_name
.word person_set_name // FP to person_set_name

.balign 4
french_person_constructor:
	push {r4-r5,lr}

	mov r4, r0
	bl person_constructor

	ldr r5, =french_person_vtable
	str r5, [r4, #20]
	
	pop {r4-r5,pc}

.balign 4
french_person_vtable:
.word french_person_greet
.word person_vtable+4
.word person_vtable+8
	
.balign 4
french_person_greet:
	push {r4-r5,lr}
	sub sp, sp, #2
	
	mov r4, r0

	ldr r0, =.Lfrench_person_greet_0
	bl print
	
	mov r0, r4
	bl print

	mov r5, #10
	strb r5, [sp]
	mov r5, #0
	strb r5, [sp, #1]

	mov r0, sp
	bl print
	
	add sp, sp, #2
	pop {r4-r5,pc}
.Lfrench_person_greet_0:
.asciz "Bonjour "
	
.balign 4
english_person_constructor:
	push {r4-r5,lr}

	mov r4, r0
	bl person_constructor

	ldr r5, =english_person_vtable
	str r5, [r4, #20]
	
	pop {r4-r5,pc}

.balign 4
english_person_vtable:
.word english_person_greet
.word person_vtable+4
.word person_vtable+8

.balign 4
english_person_greet:
	push {r4-r5,lr}
	sub sp, sp, #2
	
	mov r4, r0

	ldr r0, =.Lenglish_person_greet_0
	bl print
	
	mov r0, r4
	bl print

	mov r5, #10
	strb r5, [sp]
	mov r5, #0
	strb r5, [sp, #1]

	mov r0, sp
	bl print
	
	add sp, sp, #2
	pop {r4-r5,pc}
.Lenglish_person_greet_0:
.asciz "Hello "

.balign 4
file_io:
	push {r4-r5,r7,lr}
	
	ldr r0, =file_name
	mov r1, #(O_CREAT | O_WRONLY)
	movw r2, #(S_IWOTH | S_IROTH | S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP)
	mov r7, #OPEN
	svc #0

	mov r4, r0

	cmp r4, #-1
	beq .Lfile_io_end

	mov r0, r4
	ldr r1, =message_to_write
	mov r2, #18
	mov r7, #WRITE
	svc #0

	mov r0, r4
	mov r7, #CLOSE
	svc #0

	ldr r0, =file_name
	mov r1, #O_RDONLY
	mov r7, #OPEN
	svc #0

	mov r4, r0

	cmp r4, #-1
	beq .Lfile_io_end
	
	mov r0, r4
	ldr r1, =message_to_read
	mov r2, #18
	mov r7, #READ
	svc #0

	ldr r0, =message_to_read
	bl print

	mov r0, r4
	mov r7, #CLOSE
	svc #0

.Lfile_io_end:
	pop {r4-r5,r7,pc}

.balign 4
choose_number:
	push {r4-r5,lr}

	ldr r0, =choose_a_number
	bl print

	ldr r0, =number_to_store
	mov r1, #3
	bl get_input

	ldr r0, =number_to_store
	bl atoi

	mov r5, #0
	ldr r4, =number_to_store
	strb r5, [r4]
	strb r5, [r4, #4]
	
	cmp r0, #1
	beq case_1
	cmp r0, #2
	beq case_2
	cmp r0, #3
	beq case_3
	b default
case_1:
	add r0, #3
case_2:
	add r0, #1
	b after_switch
case_3:
	sub r0, #2
default:
	sub r0, #1
after_switch:
	mov r1, r0
	ldr r0, =number_to_store
	bl utoa

	ldr r0, =number_to_store
	mov r1, #10
	bl add_char

	ldr r0, =number_to_store
	bl print
	
	pop {r4-r5,pc}
	
.balign 4
allocation_1:
	push {r4-r7,lr}

	// Get the current BRK
	mov r7, #BRK
	mov r0, #0
	svc #0

	// Get the starting and ending heap locations (which right now are right next to each other)
	ldr r4, =heap
	ldr r5, =heap_end

	// Move the return from BRK to head and head_end
	str r0, [r4]
	str r0, [r5]

	// Move the address of head and head_end to r0
	mov r4, r0
	mov r5, r0

	mov r6, #0
.Lcount_start:
	// Is the end less than the beginning? Then skip!
	cmp r4, r5
	blo .Lskip_alloc

	// Add 4 bytes to heap
	add r0, r4, #4
	mov r7, #BRK
	svc #0

	// Store the new heap_end
	mov r5, r0
	ldr r1, =heap_end
	str r0, [r1]
.Lskip_alloc:
	add r6, r6, #1
	str r6, [r4], #1
.Lcount_test:
	cmp r6, #20
	bne .Lcount_start
.Lcount_end:

	pop {r4-r7,pc}

.balign 4
main:
	push {r4-r7,lr}
	sub sp, sp, #48

	mov r0, sp
	bl french_person_constructor

	ldr r0, =.Lmain_0
	bl get_length

	mov r2, r0
	ldr r0, =.Lmain_0
	mov r1, sp
	bl copy_string

	add r4, sp, #24
	mov r0, r4
	bl english_person_constructor

	ldr r0, =.Lmain_0
	bl get_length

	mov r2, r0
	ldr r0, =.Lmain_0
	add r1, sp, #24
	bl copy_string
	
	// Call french greet
	ldr r4, [sp, #20]
	ldr r4, [r4]
	mov r0, sp
	blx r4

	// Call english greet
	ldr r4, [sp, #44]
	ldr r4, [r4]
	add r0, sp, #24
	blx r4

	add sp, sp, #48
	pop {r4-r7,pc}
.Lmain_0:
.asciz "Grant"

.balign 4
alloc_test:
	push {r4,lr}
	sub sp, sp, #8
	
	mov r0, #3
	bl malloc

	str r0, [sp]
	
	mov r4, #1
	str r4, [r0]
	mov r4, #2
	str r4, [r0, #1]
	mov r4, #3
	str r4, [r0, #2]

	mov r0, #5
	bl malloc

	str r0, [sp, #4]
	
	ldr r0, [sp]
	bl free

	mov r0, #2
	bl malloc

	str r0, [sp, #8]

	ldr r0, [sp, #4]
	bl free

	ldr r0, [sp, #8]
	bl free
	
	add sp, sp, #8
	pop {r4,pc}
	

.balign 4
check_optimized:
	push {r4,lr}

	mov r4, #1
	mov r4, r4, lsl #31
	mov r0, r4
	bl check_pow_2_op
	
	pop {r4,pc}
	
.balign 4
_start:
	ldr r4, =debug

	bl check_optimized
//	bl main
	
//	bl file_io

//	bl choose_number

//	bl alloc_test
	
	mov r7, #1
	svc #0
