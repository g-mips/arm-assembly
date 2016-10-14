.data

.code 16

.balign 2
message1:
.asciz "To stop this loop, please enter q\012"

.balign 2
message2:
.asciz "You entered: "

.balign 2
message3:
.asciz "Your number is under 5\n"

.balign 2
message4:
.asciz "Your number is above or equal to 5\n"
	
.balign 2
character:
.skip 2
	
.text

.code 16
	
.balign 2
main:
	push {r4,lr}

main_loop_1:	
	ldr r0, =message1
	bl print
	
	ldr r0, =character
	mov r1, #2
	bl get_input

	mov r3, r0
	
	ldr r0, =message2
	bl print

	ldr r0, =character
	bl print

	ldr r0, =character
	ldrb r0, [r0]
	cmp r0, #113
	bne main_loop_1

	mov r4, #0
	b main_loop_2_check
main_loop_2:
	add r4, r4, #1
	cmp r4, #5
	bge main_loop_2_else
	ldr r0, =message3
	bl print
	b main_loop_2_check
main_loop_2_else:
	ldr r0, =message4
	bl print
main_loop_2_check:
	cmp r4, #10
	bne main_loop_2
	
	pop {r4,pc}
	
.code 32
.global _start

.balign 4
_start:
	blx main

	mov r7, #1
	svc #0
