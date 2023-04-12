# CS 21 Lab2 -- S2 AY 2021-2022
# Carl David B. Ragunton -- 05/01/2022
# 202004243_9.asm -- a program that solves a sudoku board of size 9x9

#Note: Please insert the input one line at a time without pressing enter. This program won't work if the input is inserted all at once.

.eqv 	row $s0
.eqv 	col $s1
.eqv 	num $s2
.eqv 	num_already_used $s3
.eqv 	sudoku_value $s4
.eqv 	ROW $s5
.eqv 	COL $s6

.text
main:
	li $v0 8			#getting input
	la $a0, line1
	li $a1, 10
	syscall
	
	la $a0, line2
	syscall
	
	la $a0, line3
	syscall

	la $a0, line4
	syscall
	
	la $a0, line5
	syscall
	
	la $a0, line6
	syscall
	
	la $a0, line7
	syscall
	
	la $a0, line8
	syscall
	
	la $a0, line9
	syscall
	
	jal sudoku			#calling sudoku(board)
	
	li $a0, 10 			#printing board
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line1
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line2
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line3
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line4
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line5
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line6
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line7
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line8
	syscall
	
	li $a0, 10 
	li $v0, 11 
	syscall
	
	li $v0, 4 
	la $a0, line9
	syscall
	
	li $v0, 10			#end
	syscall
	
sudoku:					#sudoku( )
	#				#preamble
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw row, 24($sp)
	sw col, 20($sp)
	sw num, 16($sp)
	#
	
	li row, 0			#resetting row
	li num, 0x31			#num="1" in ASCII
	li sudoku_value, 0		#resetting sudoku_value
	
for_row:
	beq row, 9, for_row_x		#end of for_row; row=9
	li col, 0			#resetting col

for_col:
	beq col, 9, for_col_x		#end of for_col; col=9
	
	li $t0, 32
	mul $t0, $t0, row
	add $t0, $t0, col		#$t0 = initial board[row][col]
	li $t1, 0x10010000
	add $t1, $t1, $t0		#$t1 = final board[row][col] address
	lb $t2, 0($t1)			#$t2 = board[row][col] value
	
	beq $t2, 0x30, if1		#if board[row][col]=="0", start to solve it
	
	addi col, col, 1		#col++
	j for_col
	
for_col_x:
	addi row, row, 1		#row++
	j for_row
	
for_row_x:
	li sudoku_value, 0x1		#last "0" has been solved; will cause a domino effect on the other recursions
	jr $ra				
	
if1:
	li num, 0x31			#resetting num

for_num:
	beq num, 0x3A, for_num_x	#end of for_num; num=0x3A
	
NUM_ALREADY_USED:
	li ROW, 0x0			#reset ROW
	li COL, 0x0			#reset COL
	li num_already_used, 0		#num_already_used=0

for_ROW:				#checks if num is already in current column
	beq ROW, 9, for_ROW_x		#end of for_ROW; ROW=9
	
	li $t0, 32
	mul $t0, $t0, ROW
	add $t0, $t0, col		#$t0 = initial board[ROW][col]
	li $t1, 0x10010000
	add $t1, $t1, $t0		#$t1 = final board[ROW][col] address
	lb $t2, 0($t1)			#$t2 = board[ROW][col] value
	
	beq num_already_used, 1, num_already_used_true	#if num_already_used is 1; can't use this num anymore
	seq num_already_used, $t2, num
	
	addi ROW, ROW, 1		#ROW++
	j for_ROW
	
for_ROW_x:

for_COL:				#checks if num is already in current row
	beq COL, 9, for_COL_x		#end of for_COL; COL=9
	
	li $t0, 32
	mul $t0, $t0, row
	add $t0, $t0, COL		#$t0 = initial board[row][COL]
	li $t1, 0x10010000
	add $t1, $t1, $t0		#$t1 = final board[row][COL] address
	lb $t2, 0($t1)			#$t2 = board[row][COL] value
	
	beq num_already_used, 1, num_already_used_true	#if num_already_used is 1; can't use this num anymore
	seq num_already_used, $t2, num
	
	addi COL, COL, 1		#COL++
	j for_COL
	
for_COL_x:
	li $t0, 0x3
	div row, $t0
	mflo $t1
	mul $t1, $t1, 3
	addi $t6, $t1, 3		#$t6=floor(row/3)*3+3
	move ROW, $t1			#ROW=floor(row/3)*3

for_ROW_square:				#checks if num is already in current 3x3 square
	beq ROW, $t6, for_ROW_square_x	#end of outer loop; ROW=floor(row/3)*3+3
	
	li $t3, 0x3
	div col, $t3
	mflo $t4
	mul $t4, $t4, 3
	addi $t7, $t4, 3		#$t7=floor(col/3)*3+3
	move COL, $t4			#COL=floor(col/3)*3
	
for_COL_square:
	beq COL, $t7, for_COL_square_x	#end of inner loop; COL=floor(col/3)*3+3
	
	li $t0, 32
	mul $t0, $t0, ROW
	add $t0, $t0, COL		#$t0 = initial board[ROW][COL]
	li $t1, 0x10010000
	add $t1, $t1, $t0		#$t1 = final board[ROW][COL] address
	lb $t2, 0($t1)			#$t2 = board[ROW][COL] value
	
	beq num_already_used, 1, num_already_used_true	#if num_already_used is 1; can't use this num anymore
	seq num_already_used, $t2, num
	
	addi COL, COL, 1		#COL++
	j for_COL_square
	
for_COL_square_x:
	addi ROW, ROW, 1		#ROW++
	j for_ROW_square

for_ROW_square_x:
	beq num_already_used, 1, num_already_used_true	#if num_already_used is 1; can't use this num anymore
	
num_already_used_false:
	li $t0, 32
	mul $t0, $t0, row
	add $t0, $t0, col		#$t0 = initial board[row][col]
	li $t1, 0x10010000
	add $t1, $t1, $t0		#$t1 = final board[row][col] address
	
	sb num, 0($t1)			#board[row][col] = num
	
	jal sudoku			#recurse sudoku(board) to solve the next "0"
	
	#				#retrieve values from previous recursion
	lw $ra, 28($sp)
	lw row, 24($sp)
	lw col, 20($sp)
	lw num, 16($sp)
	addu $sp, $sp, 32
	#
	
	beq sudoku_value, 0x1, sudoku_true#if sudoku is true
	
	li $t0, 32
	mul $t0, $t0, row
	add $t0, $t0, col		#$t0 = initial board[row][col]
	li $t1, 0x10010000
	add $t1, $t1, $t0		#$t1 = final board[row][col] address
	
	li $t3, 0x30
	sb $t3, 0($t1)			#board[r][c] = "0"
	
num_already_used_true:
	addi num, num, 1		#num++
	j for_num
	
sudoku_true:
	li sudoku_value, 0x1
	jr $ra				#return 1
	
for_num_x:
	li sudoku_value, 0x0
	jr $ra				#return 0
	
	
	
	
.data
line1:	.space 32
line2:	.space 32
line3:	.space 32
line4:	.space 32
line5:	.space 32
line6:	.space 32
line7:	.space 32
line8:	.space 32
line9:	.space 32
