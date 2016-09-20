	/* Variables */
	.data
	
	.balign 4
output:
	.asciz "Hello! You choose: %d\n"

	/* What Will I ask the user? */
	.balign 4
ask_input:
	.asciz "Give me a number greater than or equal to 20: "

	/* Pass the input type essentially */
	.balign 4
input:
	.asciz "%d"

	/* Assign the input to something */
	.balign 4
num:
	.word 0

	.balign 4
max_num:
	.word 20
	
	/* We will need to return to different parts of the program. This can help. */
return:
	.word 0
	
	/* Program */
	.text

	.global printf
	.global scanf
	.global main
main:
	ldr r1, =return
	str lr, [r1]
	ldr r2, =max_num
	ldr r2, [r2]
	mov r1, #0
	b loop_cond

	/* Loop */
loop:
	ldr r0, =ask_input
	bl printf
	ldr r0, =input
	ldr r1, =num
	bl scanf
	ldr r1, =num
	ldr r1, [r1]
loop_cond:
	ldr r2, =max_num
	ldr r2, [r2]
	cmp r2, r1
	bgt loop
	/* End Loop */
	
end:
	ldr r0, =output
	bl printf
	ldr lr, =return
	ldr lr, [lr]
	bx lr