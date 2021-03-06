# Integers to hexadecimal numbers conversion
# Lab 5.1
	# Data Memory Section
	.data
number:	.asciiz "Enter a number: "
	.align 2
result:	.space 40
	# Program Memory section
	.text
	.globl main
main:	
	# Prompt the user to enter a number
	li $v0, 4 				#print string
	la $a0, number 			#"Enter a number: "
	syscall
	# Get the number
	li $v0, 5 				#read integer
	syscall
	add $s5, $v0, $zero		#s5 = user input
	
	la $s0, result 			#adress of result
	addi $t0, $zero, 48 	#set $t0 to 48
	sw $t0, 0($s0)          #store 48('0') at location 0 in result
	addi $t0, $0, 120       #set $t0 equal to 120
    sw $t0, 4($s0)          #store 120('x') at location 1 in $a1
	addi $t2, $s0, 36 		# adress of location 9 in result

	addi $s2, $zero, 0 		# int i = 0;
	addi $t1, $zero, 8 		# store the index limit: 8 in this case
for1:	bge $s2, $t1, after_for1	# if i >= 8 run after_for1
	move $a0, $s5 			#set user input as argument 0 for converting hex function
	move $a1, $t2
	
	addi $sp, $sp, -20
	sw $t0, 20($sp)			# push $t registers before print_hex() function
	sw $t1, 16($sp)
	sw $t2, 12($sp)
	jal print_hex			#print_hex(a0)
	lw $t2, 12($sp)			# pop $t registers after print_hex() function
	lw $t1, 16($sp)			
	lw $t0, 20($sp)
	addi $sp, $sp, 20
	move $t2, $v0			# update the new adress to print
	
	srl $s5, $s5, 4			#shift right 4 bits to deal with the next 4digit number
	addi $s2, $s2, 1 		# i++
	j for1 					# looping	
after_for1:
	# loop through the 'result' array to print out one by one character
	addi $s2, $zero, 0		# int i = 0
	addi $t1, $zero, 10		# store the index limit: 10 in this case
for2:	bge $s2, $t1, after_for2	# if i >= 10 run after_for2
	li $v0, 4 				# print string
	la $a0, ($s0)			# print each character in result
	syscall
	addi $s0, $s0, 4		# move to the next character
	addi $s2, $s2, 1 		# i++
	j for2 					# looping
after_for2:
	li $v0, 10 				#exit
	syscall
print_hex:			
	sw $s2, 8($sp)			# push $s registers before using inside the function
	sw $s5, 4($sp)
	
	andi $s3, $a0, 0x0f 	# get the last 4 digit
convertToHex:
	ble $s3, 9, lessThan9
	addi $s3, $s3, 7
lessThan9:
	addi $t2, $s3, 48
	sw $t2, ($a1)			#result[s1] = hex number
	subi $v0, $a1, 4 		#move to the next address on the left
	
	lw $s5, 4($sp)			# pop $s registers after using inside the function
	lw $s2, 8($sp)
	jr $ra
