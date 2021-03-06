# print array function
# Lab 5.2
	# Data Memory Section
	.data
myarray:.word -20, -10, -4, -1, 1, 4, 10, 20, 5, 5
	.align 2
hex:	.space 40
	.align 2
comma:	.asciiz ", "
	# Program Memory section
	.text
	.globl __start
__start:
	la $s5, myarray 	#adress of myarray
	addi $s4, $zero, 0 	# int i = 0;
	addi $t1, $zero, 10 # store the index limit: 10 in this case
loop_myarray:	
	bge $s4, $t1, after_loop_myarray# if i >= 10 run after_for1
	lw $a0, ($s5)		#load each number to print out
	
	addi $sp, $sp -44
	sw $t1, 44($sp)		# push %t register to the stack
	jal print_hex		#print_hex(a0)
	lw $t1, 44($sp)		# pop %t register from the stack
	addi $sp, $sp, 44	
	
	beq $s4, 9, skip_comma
	li $v0, 4 			#print string
	la $a0, comma 		#, "
	syscall
skip_comma:
	addi $s5, $s5, 4	#next number
	addi $s4, $s4, 1	#i++
	j loop_myarray
after_loop_myarray:
	li $v0, 10 			#exit
	syscall
	
print_hex:
	sw $ra, 40($sp)		#push ra to the stack
	sw $s4, 36($sp)		# push %s registers to the stack
	sw $s5, 32($sp)
	
	add $s6, $a0, $zero	#s6 = array element
	
	la $s0, hex 		#adress of result
	addi $t0, $zero, 48 #set $t0 to 48
	sw $t0, 0($s0)      #store 48('0') at location 0 in result
	addi $t0, $0, 120   #set $t0 equal to 120
        sw $t0, 4($s0)          #store 120('x) at location 1 in $a1
	addi $s1, $s0, 36 	# adress of location 9 in result

	addi $s2, $zero, 0 	# int i = 0;
	addi $t2, $zero, 8 	# store the index limit: 8 in this case
for1:	bge $s2, $t2, after_for1# if i >= 8 run after_for1
	move $a0, $s6 		#set user input as argument 0 for converting hex function
	move $a1, $s1
	
	sw $t0, 28($sp)		# push %t registers to the stack
	sw $t2, 24($sp)
	jal convert_hex		#print_hex(a0)
	lw $t2, 24($sp)
	lw $t0, 28($sp)		# push %t registers to the stack
	
	move $s1, $v0
	srl $s6, $s6, 4		#shift right 4 bits to deal with the next 4digit number
	addi $s2, $s2, 1 	# i++
	j for1 				# looping	
after_for1:
	# loop through the 'result' array to print out one by one character
	addi $s2, $zero, 0	# int i = 0
	addi $t2, $zero, 10	# store the index limit: 10 in this case
for2:	bge $s2, $t2, after_for2# if i >= 10 run after_for2
	li $v0, 4 			# print string
	la $a0, ($s0)		# print each character in result
	syscall
	addi $s0, $s0, 4	# move to the next character
	addi $s2, $s2, 1 	# i++
	j for2 				# looping
after_for2:
	lw $s5, 32($sp)		# pop %s registers from the stack
	lw $s4, 36($sp)
	lw $ra, 40($sp)		#pop ra from the stack
	jr $ra
convert_hex:
	sw $ra, 20($sp)		#push ra to the stack
	sw $s0, 16($sp)		#push %s registers to the stack
	sw $s1, 12($sp)
	sw $s2, 8($sp)	
	sw $s6, 4($sp)
	
	andi $s3, $a0, 0x0f # get the last 4 digit
	ble $s3, 9, lessThan9
	addi $s3, $s3, 7
lessThan9:
	addi $t3, $s3, 48
	sw $t3, ($a1)		#result[s1] = hex number
	subi $v0, $a1, 4 	#move to the next address on the left
	
	lw $s6, 4($sp)		#pop %s registers from the stack
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)	
	lw $ra, 20($sp)		#pop ra from the stack
	jr $ra
