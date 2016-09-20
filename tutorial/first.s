	/* -- first.s */
	/* This is a comment */
	/*
		Registers (they can hold 32 bits each):
		r0 - r15

		You should represent integers in twos complement

		r0 -- r4 are used as parameters. More than four parameters and the stack is used
		r0 - This holds the exit code
		r1
		r2
		r3
		r4
		r5
		r6
		r7
		r8
		r9
		r10
		r11
		r12
		sp (r13) - Stack Pointer
		lr (r14) - Link Register (address of last thing that called us)
		pc (r15) - Program Counter (also called ip or "Instruction Pointer")
		cpsr - Current Program Status Register

		mov DES, SRC - Move SRC into DES
		add DES, LFT, RGT - Add LFT and RGT and store result into DES
		ldr DES, SRC - Load SRC into DES (from memory to register)
		str SRC, DES - Store SRC into DES (from register to memory)
		cmp RE1, RE2 - Compares the two registers by doing RE1 - RE2. Stores info in cpsr
		and DES, LFT, RGT - LFT & RGT -> DES
		
		word - 32 bits (4 bytes)
		pc will move 4 bytes every instruction after the execution of an instruction, assuming the instruction did not modify the pc
		value in pc contains the address of the next instruction
		cpsr contains 4 condition codes: N (Negative), Z (Zero), C (Carry), V (oVerflow)
			* N will be enabled if the result of the instruction yields a negative number. Disabled otherwise
			* Z will be enabled if the result of the instruction yields a zero value. Disabled if non-zero
			* C will be enabled if the result of the instruction yields a value that requires a 33rd bit to be represented
			* V will be enabled if the result of the instruction yields a value that cannot be represented in 32 bit two's complement

		However, CPSR does contain more (it is, after all, 32 bits):
			* Q will be enabled if overflow or saturation occured in some instructions, normally related to digital signal processing
			* GE (Greater than or equal to flags)
		CPSR:

		0000 0    000          0000        0000 0000 0000 0000 0000
		NZCV Q RAZ/SBZP Reserved, UNK/SBZP  GE   Reserved, UNK/SBZP
		Useful CPSR Info:
			* EQ (equal: When Z is enabled)
			* NE (not equal: When Z is disabled)
			* GE (Greater than or equal to, in twos complement: When both V and N are enabled or disabled)
			* LT (lower than, in two’s complement). This is the opposite of GE, so when V and N are not both enabled or disabled (V is not N)
			* GT (greather than, in two’s complement). When Z is disabled and N and V are both enabled or disabled (Z is 0, N is V)
			* LE (lower or equal than, in two’s complement). When Z is enabled or if not that, N and V are both enabled or disabled (Z is 1.
			  If Z is not 1 then N is V)
			* MI (minus/negative) When N is enabled (N is 1) 
			* PL (plus/positive or zero) When N is disabled (N is 0)
			* VS (overflow set) When V is enabled (V is 1)
			* VC (overflow clear) When V is disabled (V is 0)
			* HI (higher) When C is enabled and Z is disabled (C is 1 and Z is 0)
			* LS (lower or same) When C is disabled or Z is enabled (C is 0 or Z is 1)
			* CS/HS (carry set/higher or same) When C is enabled (C is 1)
			* CC/LO (carry clear/lower) When C is disabled (C is 0)

		COMBINE ANY OF THOSE ABOVE WITH 'b' TO MAKE A BRANCH CONDITIONAL (THIS IS JMP IN OTHER INSTRUCTION SETS)
	
	*/
	/* -- load01.s */

	/* -- Data section */
	.data

	/* Ensure variable is 4-byte aligned */
	.balign 4
	/* Define storage for myvar1 */
myvar1:
	/* Contents of myvar1 is just 4 bytes containing value '3' */
	.word 3

	/* Ensure variable is 4-byte aligned */
	.balign 4
	/* Define storage for myvar2 */
myvar2:
	/* Contents of myvar2 is just 4 bytes containing value '4' */
	.word 4

	/* -- Code section */
	.text

	/* Ensure code is 4 byte aligned */
	.balign 4
	.global main
main:
	ldr r1, addr_of_myvar1 /* r1 ← &myvar1 */
	ldr r1, [r1]           /* r1 ← *r1 */
	ldr r2, addr_of_myvar2 /* r2 ← &myvar2 */
	ldr r2, [r2]           /* r2 ← *r2 */
	add r0, r1, r2         /* r0 ← r1 + r2 */
	bx lr

	/* Labels needed to access data */
addr_of_myvar1: .word myvar1
addr_of_myvar2: .word myvar2
