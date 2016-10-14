.data

.balign 4
number:
.asciz "567"
	
.text

.global _start

.balign 4
main:
	push {lr}

	ldr r0, =number
	bl atoi
	
	pop {pc}

.balign 4
_start:
	bl main
	
	mov r7, #1
	svc #0
