.set OPEN 5
.set CLOSE 6

.set O_APPEND 1024
.set O_ASYNC 8192
.set O_CLOSEXEC 524288
.set O_CREAT 64
.set O_RDONLY 0
.set O_WRONLY 1
.set O_RDWR 2

.data

debug:
file_name:
.ascii "test.txt"
	
message_to_write:
.ascii "This is a message\n"
	
message_to_read:
.skip 18
	
heap:
.word 0
	
.text

.global _start

.balign 4
file_io:
	push {r4,r7,lr}
	
	ldr r0, =file_name
	ldr r0, [r0]
	mov r1, #{O_CREAT | O_RDWR}
	mov r7, #OPEN
	svc #0

	mov r4, r0
	
	pop {r4,r7,pc}
	
.balign 4
allocation:
	push {lr}

	
	
	pop {pc}

.balgin 4
_start:
	ldr r0, =debug
	
	bl allocation
	
	mov r7, #1
	svc #0
