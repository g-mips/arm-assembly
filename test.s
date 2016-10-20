.data

.balign 4 
number:
.asciz "567"

.bss

.balign 4 
string:
.skip 12
	
.text

.global _start

.balign 4
main:
	push {lr}

	ldr r0, =number
	bl atoi

	mov r1, r0
	ldr r0, =string
	bl utoa

	ldr r0, =string
	mov r1, #10
	bl add_char
	
	ldr r0, =string
	bl print
	
	pop {pc}

.balign 4
_start:
	bl main
	
	mov r7, #1
	svc #0
