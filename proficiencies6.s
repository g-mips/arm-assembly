.text

.global _start
	
.balign 4
allocation:
	push {lr}

	
	pop {pc}

.balgin 4
_start:
	bl allocation
	
	mov r7, #1
	svc #0
