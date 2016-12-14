.set EXIT, 1

.set NULL, 0
.set NEW_LINE, 10
.set SPACE, 32
.set CAP_A, 65
.set LOW_A, 97
.set COMMA, 44
.set STAR, 42

.set O_CREAT, 64
.set O_RDONLY, 0
.set O_WRONLY, 1

.set S_IWOTH, 00002
.set S_IROTH, 00004
.set S_IRUSR, 00400
.set S_IWUSR, 00200
.set S_IRGRP, 00040
.set S_IWGRP, 00020

.data
debug:
RED:
.asciz "\033[31m"
DEFAULT_COLOR:
.asciz "\033[39m"

/******
 * STRUCT CELLS
 *    INT possibleValues
 *    CHAR value
 *    CHAR default
 *****/
.text

.global _start

/*********************************************************************************
 *
 * r0 - cells struct
 *
 ********************************************************************************/
.data
.balign 4
.LprintBoard_row_coor:
.skip 2
.text
.balign 4
printBoard:	
	push {r4-r10,lr}
	sub sp, sp, #4
	
	// Save r0 onto the stack
	str r0, [sp]
	
	// Print out the column coordinates
	ldr r0, =.LprintBoard_col_coors
	bl print
	
	// Print out board row by row with row coordinates at the beginning of each row
	// Check for default values and change the color of them

	// Load in cells
	// Initialize row counter - r5
	ldr r4, [sp]
	mov r5, #1
	mov r8, #CAP_A
.LprintBoard_loop_1:
	// rowCounter % #4
	mov r6, #4
	mov r0, r5
	mov r1, r6
	bl mod
	mov r7, r0

	// r7 == 1 or r7 == 2 prints out a regular row. r7 == 0 prints out a special row.
	cmp r7, #0
	beq .LprintBoard_sep_row_print
.LprintBoard_row_coor_print:
	//------------------------------//	
	// Print space
	ldr r0, =.LprintBoard_row_coor
	mov r1, #SPACE
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	mov r1, #NULL
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print
	
	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	//------------------------------//
	// Print row coordinate
	ldr r0, =.LprintBoard_row_coor
	mov r1, r8
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print
	
	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	//------------------------------//	
	// Print space
	ldr r0, =.LprintBoard_row_coor
	mov r1, #SPACE
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print
	
	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	//-------------- INNER LOOP ----------------//
	// Initialize col counter - r6
	mov r6, #0
	mov r7, #1
.LprintBoard_row_coor_print_loop_2:
	mov r0, r7
	mov r1, #4
	bl mod
	
	cmp r0, #0
	beq .LprintBoard_print_vertical
	
	ldr r10, [r4]
	ldrb r10, [r10, #5]

	cmp r10, #1
	beq .LprintBoard_default_color_value
.LprintBoard_non_default_value:
	//------------------------------//	
	// Print space or value
	ldr r0, =.LprintBoard_row_coor
	ldr r10, [r4]
	ldrb r1, [r10, #4]
	cmp r1, #48
	moveq r1, #SPACE
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print

	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	//------------------------------//	
	// Print space	
	ldr r0, =.LprintBoard_row_coor
	mov r1, #SPACE
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print

	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	b .LprintBoard_row_coor_print_loop_2_cond
.LprintBoard_default_color_value:
	//------------------------------//	
	// Print color code
	ldr r0, =RED
	bl print

	//------------------------------//	
	// Print value	
	ldr r0, =.LprintBoard_row_coor
	ldr r10, [r4]
	ldrb r1, [r10, #4]
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print

	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	//------------------------------//	
	// Print default color code
	ldr r0, =DEFAULT_COLOR
	bl print

	//------------------------------//	
	// Print space	
	ldr r0, =.LprintBoard_row_coor
	mov r1, #SPACE
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print

	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	b .LprintBoard_row_coor_print_loop_2_cond
.LprintBoard_print_vertical:
	ldr r0, =.LprintBoard_vertical
	bl print
	sub r4, r4, #4
.LprintBoard_row_coor_print_loop_2_cond:
	add r4, r4, #4
	add r6, r6, #1
	add r7, r7, #1
	cmp r6, #11
	blt .LprintBoard_row_coor_print_loop_2

	ldr r0, =.LprintBoard_row_coor
	mov r1, #NEW_LINE
	bl add_char

	ldr r0, =.LprintBoard_row_coor
	bl print

	ldr r0, =.LprintBoard_row_coor
	bl clear_buffer

	b .LprintBoard_loop_1_cond
.LprintBoard_sep_row_print:
	ldr r0, =.LprintBoard_sep_row
	bl print
	sub r8, r8, #1
.LprintBoard_loop_1_cond:
	add r8, r8, #1
	add r5, r5, #1
	cmp r8, #74
	blt .LprintBoard_loop_1

	add sp, sp, #4
	pop {r4-r10,pc}
.LprintBoard_vertical:
.asciz "| "
.LprintBoard_col_coors:
.asciz "\n   A B C   D E F   G H I\n"
.LprintBoard_sep_row:
.asciz "   ---------------------\n"

/*********************************************************************************
 *
 * r0 - Buffer for file name
 *
 ********************************************************************************/
.text
.balign 4
getFileName:
	push {r4,lr}

	mov r4, r0
	
	// Ask for file name
	ldr r0, =.LgetFileName_file_prompt
	bl print

	// Get the file name
	mov r0, r4
	mov r1, #256
	bl get_input

	mov r2, r0
	mov r0, r4
	sub r1, r2, #1
	bl remove_char
	
	pop {r4,pc}
.LgetFileName_file_prompt:
.asciz "Please enter a sudoku board file >> "

/*********************************************************************************
 *
 * r0 - array of structs
 * r1 - size of array
 *
 ********************************************************************************/
.data
.balign 4
.LloadBoard_file_name:
.skip 256
	
.balign 4
.LloadBoard_file_info:
.skip 1
.text
.balign 4
loadBoard:	
	push {r4-r10,lr}
	sub sp, sp, #4

	str r0, [sp]
	mov r5, r0
	mov r9, r1

	ldr r0, =.LloadBoard_file_name
	bl getFileName
	
	// Load file from filename found in r0
	ldr r0, =.LloadBoard_file_name
	mov r1, #0
	bl open

	cmp r0, #-1
	beq .LloadBoard_end

	mov r6, r0
	mov r4, #0
	mov r10, r5
.LloadBoard_loop_1:
	ldr r0, [r10]
	mov r1, #6
	bl clear_bytes
.LloadBoard_loop_1_cond:
	add r10, r10, #4
	add r4, r4, #1
	cmp r4, r9
	blt .LloadBoard_loop_1
	
	// Set up cells found in r1
	mov r0, r6
	mov r10, #0
	mov r4, r0
.LloadBoard_loop_2:
	ldr r6, [r5]	
	// Read the next byte
	mov r0, r4
	ldr r1, =.LloadBoard_file_info
	mov r2, #1
	bl read

//	cmp r0, #1
//	blt .LloadBoard_end
	
	// Check what the byte is
	ldr r0, =.LloadBoard_file_info
	ldr r0, [r0]
	cmp r0, #NEW_LINE
	beq .LloadBoard_loop_2_check

	cmp r0, #COMMA
	beq .LloadBoard_loop_2_check

	cmp r0, #STAR
	moveq r8, #1
	streqb r8, [r6, #5]
	
	strneb r0, [r6, #4]
	addne r10, r10, #1
	addne r5, r5, #4
.LloadBoard_loop_2_check:
	cmp r10, r9
	blt .LloadBoard_loop_2
	
	// Return 0 on success, -1 on error
	mov r0, r4
	bl close

	ldr r0, [sp]
	bl computePossibleValues
	
	mov r0, #0
.LloadBoard_end:
	add sp, sp, #4
	pop {r4-r10,pc}

/*********************************************************************************
 *
 * r0 - cells
 * r1 - fileName
 ********************************************************************************/
.balign 4
saveBoard:	
	push {r4-r10,lr}

	mov r4, r0
	mov r5, r1

	mov r0, r5
	mov r1, #(O_WRONLY | O_CREAT)
	movw r2, #(S_IWOTH | S_IROTH | S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP)
	bl open

	cmp r0, #0
	blt .LsaveBoard_end
	
	mov r9, r0
	
	mov r7, #0
	mov r10, #0
.LsaveBoard_loop:
	ldr r6, [r4, r7]
	ldrb r8, [r6, #5]

	mov r0, r9
	ldr r1, =.LsaveBoard_star
	mov r2, #1
	
	cmp r8, #1
	bleq write

	mov r0, r9
	add r1, r6, #4
	mov r2, #1
	bl write

	mov r0, r9
	ldr r1, =.LsaveBoard_comma
	mov r2, #1
	cmp r10, #8
	blne write
	
	mov r0, r9
	ldr r1, =.LsaveBoard_new_line
	mov r2, #1
	cmp r10, #8
	beq .LsaveBoard_write_new_line
.LsaveBoard_loop_cond:
	add r7, r7, #4
	add r10, r10, #1
	cmp r7, #324
	blt .LsaveBoard_loop
	b .LsaveBoard_pre_end
.LsaveBoard_write_new_line:
	bl write

	mov r10, #0
	
	b .LsaveBoard_loop_cond
.LsaveBoard_pre_end:
	mov r0, r9
	bl close
.LsaveBoard_end:
	pop {r4-r10,pc}
	
.LsaveBoard_star:
.ascii "*"
.LsaveBoard_comma:
.ascii ","
.LsaveBoard_new_line:
.ascii "\n"
	

/*********************************************************************************
 *
 * r0 - cell
 * r1 - number
 *
 ********************************************************************************/
.balign 4
checkValidityOfNumber:	
	push {r4,lr}

	ldr r0, [r0]

	mov r4, #1
	mov r4, r4, lsl r1
	and r2, r0, r4

	cmp r2, #0
	moveq r0, #0
	movne r0, #1	

	pop {r4,pc}
	

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
 * r0 - cells
 *
 ********************************************************************************/
.balign 4
computePossibleValues:	
	push {r4-r10,lr}
	sub sp, sp, #4

	str r0, [sp]
	
	// r4 - counter
	// r5 - possible values
	mov r4, #0
.LcomputePossibleValues_main_loop:
	movw r5, #1022

	mov r9, #4
	mul r9, r4, r9
	ldr r0, [sp]
	ldr r0, [r0, r9]
	ldrb r1, [r0, #5]

	cmp r1, #1
	moveq r5, #0
	streq r5, [r0]
	beq .LcomputePossibleValues_main_loop_cond
	
	// MOD BY 9 gives column number
	// DIVIDE BY 3 gives row number
	mov r0, r4
	mov r1, #9
	bl mod

	// r6 - column index
	// r7 - row index
	mov r6, r0
	mov r0, r4
	mov r1, #9
	udiv r7, r4, r1

	mov r0, r7
	mov r1, #3
	bl mod
	mov r7, r0

	// -------------------- ROW LOOP ------------------- //
	sub r8, r4, r6
.LcomputePossibleValues_inner_row_loop:
	ldr r10, =.LcomputePossibleValues_inner_row_loop_cond
	b .LcomputePossibleValues_remove_possible_value
.LcomputePossibleValues_inner_row_loop_cond:
	add r8, r8, #1

	mov r0, r8
	mov r1, #9
	bl mod

	cmp r0, #0
	bne .LcomputePossibleValues_inner_row_loop

	// -------------------- COLUMN LOOP ------------------- //
	mov r8, r6
.LcomputePossibleValues_inner_col_loop:
	ldr r10, =.LcomputePossibleValues_inner_col_loop_cond
	b .LcomputePossibleValues_remove_possible_value
.LcomputePossibleValues_inner_col_loop_cond:
	add r8, r8, #9

	mov r1, #9
	udiv r0, r8, r1

	cmp r0, #9
	bne .LcomputePossibleValues_inner_col_loop

	// -------------------- BOX LOOP ------------------- //
	// Col box position
	mov r0, r6
	mov r1, #3
	bl mod
	mov r8, r0

	// Row box position
	mov r0, r7
	//mov r1, #3
	//bl mod

	mov r6, #0
	// Gets the first number in the box
	mov r1, #9
	mul r0, r1, r0
	sub r0, r4, r0
	sub r8, r0, r8
.LcomputePossibleValues_inner_box_loop:
	ldr r10, =.LcomputePossibleValues_inner_box_loop_cond
	b .LcomputePossibleValues_remove_possible_value
.LcomputePossibleValues_inner_box_loop_cond:
	add r8, r8, #1

	mov r0, r8
	mov r1, #3
	bl mod
	cmp r0, #0
	addeq r8, r8, #6
	addeq r6, r6, #1

	cmp r6, #0
	beq .LcomputePossibleValues_inner_box_loop
	
	mov r0, r6
	mov r1, #3
	bl mod
	cmp r0, #0
	bne .LcomputePossibleValues_inner_box_loop

	// ------------------------- MAIN LOOP CONDITION ----------------------- //
.LcomputePossibleValues_main_loop_cond:
	mov r9, #4
	mul r9, r4, r9
	ldr r0, [sp]
	ldr r0, [r0, r9]
	str r5, [r0]
	
	add r4, r4, #1
	cmp r4, #81
	blt .LcomputePossibleValues_main_loop

	b .LcomputePossibleValues_end
	// -------------------- THIS HAPPENS IN THE INNER LOOPS --------------------- //
	// -------------------- START --------------------- //
.LcomputePossibleValues_remove_possible_value:
	// No need to compare itself
	cmp r8, r4
	bxeq r10

	// Load array
	// Load index in array
	// Load value of cell
	mov r9, #4
	mul r9, r8, r9
	ldr r0, [sp] // 0x7efff
	ldr r0, [r0, r9] // 0x2100c+r8
	ldrb r0, [r0, #4] 

	sub r0, r0, #48
	mov r9, #1
	mov r9, r9, lsl r0

	// Get rid of the number that is the possible value
	mov r0, #0
	and r0, r5, r9
	cmp r0, #0
	eorne r5, r9

	bx r10
	// -------------------- END --------------------- //
.LcomputePossibleValues_end:

	add sp, sp, #4
	pop {r4-r10,pc}

.data
.balign 4
.LdisplayPossibleValue_value:
.skip 4
.text
.balign 4
displayPossibleValues:
	push {r4-r6,lr}
	sub sp, sp, #4

	str r0, [sp]		

	mov r4, #1
.LdisplayPossibleValues_loop:
	ldr r5, [sp]
	ldr r5, [r5]
	
	mov r6, #1
	and r5, r5, r6, lsl r4
	
	cmp r5, #0
	bne .LdisplayPossibleValues_print_value

.LdisplayPossibleValues_loop_1_cond:
	add r4, r4, #1
	cmp r4, #9
	ble .LdisplayPossibleValues_loop
	b .LdisplayPossibleValues_end
.LdisplayPossibleValues_print_value:
	ldr r0, =.LdisplayPossibleValue_value
	add r1, r4, #48
	bl add_char

	ldr r0, =.LdisplayPossibleValue_value
	bl print

	ldr r0, =.LdisplayPossibleValue_value
	mov r1, #4
	bl clear_bytes
	
	b .LdisplayPossibleValues_loop_1_cond
.LdisplayPossibleValues_end:
	add sp, sp, #4
	pop {r4-r6,pc}
	
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
 * r0 - cell
 * r1 - value
 *
 ********************************************************************************/
.balign 4
fillCell:	
	push {r4-r5,lr}

	mov r4, r0
	mov r5, r1
	bl checkValidityOfNumber

	cmp r0, #0
	beq .LfillCell_end

	add r5, r5, #48
	str r5, [r4, #4]

	mov r0, #1
.LfillCell_end:
	pop {r4-r5,pc}
	

/*********************************************************************************
 *
 *
 *
 ********************************************************************************/
.balign 4
checkBounds:	
	push {lr}

	pop {pc}

.data
.balign 4
.Lmain_file_name:
.skip 256

.balign 4
.Lmain_option:
.skip 256
.text
.balign 4
main:
	push {r4-r6,lr}
	sub sp, sp, #324

	// Create an array of structs by allocation!
	mov r4, #0
	mov r5, sp
.Lmain_loop_1:
	mov r0, #6
	bl malloc

	str r0, [r5]
	mov r1, #6
	bl clear_bytes
.Lmain_loop_1_cond:
	add r5, r5, #4
	add r4, r4, #1
	cmp r4, #81
	blt .Lmain_loop_1

	// Load the board
	mov r0, sp
	mov r1, #81
	bl loadBoard
	
	// --------------------------------- MAIN LOOP ---------------------------------
.Lmain_main_loop:
	// Print the board
	mov r0, sp
	bl printBoard

.Lmain_main_loop_cond:
	// Display options for user
	ldr r0, =.Lmain_options
	bl print
	
	ldr r0, =.Lmain_options_prompt
	bl print
	
	ldr r0, =.Lmain_option
	mov r1, #256
	bl get_input

	mov r2, r0
	ldr r0, =.Lmain_option
	sub r1, r2, #1
	bl remove_char

	ldr r0, =.Lmain_option
	ldrb r0, [r0]
	bl to_lower
	cmp r0, #113
	beq .Lmain_switch_1_case_q
	cmp r0, #115
	beq .Lmain_switch_1_case_s
	cmp r0, #108
	beq .Lmain_switch_1_case_l
	cmp r0, #102
	beq .Lmain_switch_1_case_f
	cmp r0, #112
	beq .Lmain_switch_1_case_p
	b .Lmain_switch_1_default

.Lmain_switch_1_case_q:
	b .Lmain_end
.Lmain_switch_1_case_s:
	ldr r0, =.Lmain_file_name
	bl getFileName

	mov r0, sp
	ldr r1, =.Lmain_file_name
	bl saveBoard
	
	b .Lmain_switch_1_after
.Lmain_switch_1_case_l:
	// Load the board
	mov r0, sp
	mov r1, #81
	bl loadBoard
	
	b .Lmain_switch_1_after
.Lmain_switch_1_case_f:
	ldr r10, =.Lmain_switch_1_case_f_2
	b .Lmain_get_coors
.Lmain_switch_1_case_f_2:

	ldr r0, =.Lmain_value_prompt
	bl print

	ldr r0, =.Lmain_option
	mov r1, #256
	bl get_input

	cmp r0, #2
	blt .Lmain_print_invalid_value

	ldr r0, =.Lmain_option
	ldrb r0, [r0]
	
	cmp r0, #49
	blt .Lmain_print_invalid_value

	cmp r0, #57
	bgt .Lmain_print_invalid_value

	sub r0, r0, #48
	mov r1, r0
	mov r0, r6	
	bl fillCell

	cmp r0, #0
	beq .Lmain_print_invalid_value
	
	b .Lmain_switch_1_after
.Lmain_switch_1_case_p:
	ldr r10, =.Lmain_switch_1_case_p_2
	b .Lmain_get_coors
.Lmain_switch_1_case_p_2:
	bl displayPossibleValues
	
	b .Lmain_switch_1_after
.Lmain_switch_1_default:
	ldr r0, =RED
	bl print

	ldr r0, =.Lmain_incorrect_option
	bl print

	ldr r0, =DEFAULT_COLOR
	bl print
	
	b .Lmain_main_loop_cond
.Lmain_switch_1_after:
	b .Lmain_main_loop
.Lmain_print_invalid_value:
	ldr r0, =RED
	bl print

	ldr r0, =.Lmain_invalid_value
	bl print
	
	ldr r0, =DEFAULT_COLOR
	bl print

	b .Lmain_main_loop
.Lmain_print_invalid_coors:
	ldr r0, =RED
	bl print

	ldr r0, =.Lmain_invalid_coors
	bl print

	ldr r0, =DEFAULT_COLOR
	bl print
	
	b .Lmain_main_loop
.Lmain_get_coors:
	ldr r0, =.Lmain_coordinates
	bl print

	ldr r0, =.Lmain_option
	mov r1, #256
	bl get_input

	cmp r0, #3
	blt .Lmain_print_invalid_coors

	ldr r2, =.Lmain_option
	ldrb r2, [r2]
	mov r0, r2
	bl to_upper

	cmp r0, #65
	blt .Lmain_print_invalid_coors

	cmp r0, #73
	bgt .Lmain_print_invalid_coors

	mov r2, r0
	
	ldr r3, =.Lmain_option
	ldrb r3, [r3, #1]
	mov r0, r3
	bl to_upper

	cmp r0, #65
	blt .Lmain_print_invalid_coors

	cmp r0, #73
	bgt .Lmain_print_invalid_coors

	mov r1, r0
	mov r0, r2
	
	// col
	sub r0, r0, #65
	// row
	sub r1, r1, #65

	mov r2, #9
	mul r1, r2, r1
	add r0, r1, r0

	mov r1, #4
	mul r0, r1, r0
	ldr r0, [sp, r0]

	mov r6, r0
	
	bx r10
.Lmain_end:
	// Free up my memory before ending exiting this function
	mov r4, #0
	mov r5, sp
.Lmain_loop_2:
	ldr r0, [r5]
	bl free
.Lmain_loop_2_cond:
	add r4, r4, #1
	cmp r4, #81
	addlt r5, r5, #4
	blt .Lmain_loop_2

	add sp, sp, #324	
	pop {r4-r6,pc}
.Lmain_invalid_value:
.asciz "\n\tINVALID VALUE!\n"
.Lmain_value_prompt:
.asciz "\nPlease enter a value: "
.Lmain_coordinates:
.asciz "\nPlease enter a col (x) and row (y) coordinate (i.e. AB): "
.Lmain_options_prompt:
.asciz "\n >> "
.Lmain_invalid_coors:
.asciz "\n\tINVALID COORDINATES!\n"
.Lmain_incorrect_option:
.asciz "\n\tINVALID OPTION!\n"
.Lmain_options:
.asciz "\n- (Q)uit: This will quit Sudoku\n- (S)ave: This will save the current board to the file you specify\n- (L)oad: This will load a board from a file that you specify\n- (F)ill Cell: This will fill in a cell that you specify with a value that you give it.\n- Show (P)ossible Values: This will show the possible values of a given coordinate.\n"
	
.balign 4
_start:
	ldr r0, =debug
	bl main

	mov r0, #0
	mov r7, #EXIT
	svc #0
.Ltest_file:
.ascii "3x3-1"
