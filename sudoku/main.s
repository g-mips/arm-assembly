.set EXIT, 1

.data
debug:
	
.text

.global _start

/*********************************************************************************
 *
 * r0 - cells struct
 *
 ********************************************************************************/
.balign 4
printBoard:	
	push {lr}

	// Save r0 into another register or onto the stack
	
	// Print out the column coordinates
	ldr r0, =.LprintBoard_col_coors
	bl print

	// Print out board row by row with row coordinates at the beginning of each row
	// Check for default values and change the color of them

	// Display options for user
	ldr r0, =.LprintBoard_options
	bl print

	pop {pc}
.LprintBoard_color:
.asciz "\033[31m"
.LprintBoard_default:
.asciz "\033[39m"
.LprintBoard_col_coors:
.asciz "\n   A B C D E F G H I\n"
.LprintBoard_options:
.asciz "\n- (Q)uit: This will quit Sudoku\n- (S)ave: This will save the current board to the file you specify\n- (L)oad: This will load a board from a file that you specify\n- (E)rase Cell: This will erase contents of a cell given, granted that the cell is not a default cell.\n-  Erase (B)oard: This will erase the contents of all non-default cells.\n- (F)ill Cell: This will fill in a cell that you specify with a value that you give it.\n"

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
loadBoard:	
	push {lr}

	// Load file from filename found in r0

	// Set up cells found in r1

	// Return cells
	
	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
saveBoard:	
	push {lr}

	
	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
getUserInput:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
checkValidityOfNumber:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
checkRow:
	push {lr}

	pop {pc}
	
	
/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
checkColumn:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
checkBox:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
computePossibleValues:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
eraseCell:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
eraseBoard:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
fillCell:	
	push {lr}

	pop {pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
checkBounds:	
	push {lr}

	pop {pc}
	
.balign 4
main:
	push {lr}

// This loop prints out instructions of what to do, options to choose from, and checks
// user input to make sure it is a legitimate option.
.Lmain_loop_1:
	ldr r0, =.Lmain_dimension_prompt
	bl print

	ldr r0, =.Lmain_dim_options
	bl print

	ldr r0, =.Lmain_option_string
	mov r1, #2
	bl get_input

	ldr r0, =.Lmain_option_string
	bl atoi

.Lmain_loop_1_check:
	cmp r0, #2
	ble .Lmain_loop_1_end

	ldr r0, =.Lmain_dim_incor
	bl print

	b .Lmain_loop_1
.Lmain_loop_1_end:

	
	pop {pc}
.Lmain_dimension_prompt:
.asciz "Please select dimensions for your sudoku board!\n"
.Lmain_dim_options:
.asciz "1) 2\n2) 3\n"
.Lmain_option_string:
.skip 2
.Lmain_dim_incor:
.asciz "Incorrect option!\n"


.balign 4
_start:
	ldr r0, =debug
//	bl main

	bl printBoard

	mov r0, #0
	mov r7, #EXIT
	svc #0
