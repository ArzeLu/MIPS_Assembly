##################################################
#######                                      #######
####        Matrix Multiplication v1.0       #######
##                Arze      Lu               #######
##                 May 10 2024               ####### 
###                                            #####
####################################################
################################################
#########################################
##########                    ############
######        DATA SECTION        
### 

.data
	# First matrix data (Input)
	x: .float 87.2, 21.8, 76.6
	   .float 21.1, 17.8, 72.7
	   .float 62.6, 80.7, 18.5

	# Second matrix data (Weights)
	w: .float 71.5, 65.3, 60.0
	   .float 12.8, 51.7, 38.5
	   .float 92.4, 36.9, 44.6
	
	# Output matrix
	y: .space 36  #  allocate 3 * 3 * 4 bytes for result matrix
	
	newline: .asciiz "\n"
	wall: .asciiz "  ||  "
	floor: .asciiz "----------------------------------------------"
	result_prompt: .asciiz "Y MATRIX: \n"
	
	#.eqv MATRIX_HEIGHT 
	#.eqv MATRIX_WIDTH
	.eqv MATRIX_DIM 3    # Matrix dimension 3 x 3
	.eqv FLOAT_SIZE 4    # single precision floating point uses 4 bytes
	
#########################################
##########                    ############
######           MACROS        
### 
.macro exit
	li $v0, 10
	syscall
.end_macro

.macro print_wall
	la $a0, wall
	li $v0, 4
	syscall
.end_macro

.macro print_floor
	la $a0, floor
	li $v0, 4
	syscall
.end_macro
	
.macro print_newline
	la $a0, newline
	li $v0, 4
	syscall
.end_macro

#########################################
##########                    ############
######        INSTRUCTIONS        
###                                    

.text
	li $t0, 0 # index k
	li $t1, 0 # index i
	li $t2, 0 # index j

	## Calculate initial index of matrix y
	mul $s0, $t0, MATRIX_DIM 
	add $s0, $s0, $t1
	mul $s0, $s0, FLOAT_SIZE
	
	li $s7, MATRIX_DIM
	mul $s7, $s7, FLOAT_SIZE   # Calculate index advancing for matrix w
	
	loop_k:
		
		loop_i:
			## Calculate initial index of matrix x
			mul $s1, $t0, MATRIX_DIM
			add $s1, $s1, $t2
			mul $s1, $s1, FLOAT_SIZE 
			
			## Calculate initial index of matrix w
			mul $s2, $t2, MATRIX_DIM 
			add $s2, $s2, $t1
			mul $s2, $s2, FLOAT_SIZE
			
			loop_j:
				lwc1 $f1, x($s1)  # load data from matrix x
				lwc1 $f2, w($s2)  # load data from matrix w
				lwc1 $f0, y($s0)  # load data from matrix y
				
				## Perform data calc for matrix y
				mul.s  $f3, $f1, $f2  
				add.s $f3, $f3, $f0
				
				s.s $f3, y($s0)   # store the result into appropriate matrix y slot
				
				add $s1, $s1, FLOAT_SIZE   # Calc next index of matrix x
				add $s2, $s2, $s7          # Calc next index of matrix w
				
				add $t2, $t2, 1                # j = j + 1
				blt $t2, MATRIX_DIM, loop_j   # loop if j smaller than MATRIX_DIM
				li $t2, 0                      # if not, reset index j
			
			add $s0, $s0, FLOAT_SIZE    # Calc next index of matrix y
			add $t1, $t1, 1              
			blt $t1, MATRIX_DIM, loop_i 
			li $t1, 0
		
		add $t0, $t0, 1   # k = k + 1
		blt $t0, MATRIX_DIM, loop_k
	
	li $t0, 0 # index i
	li $t1, 0 # index j
	
	la $a0, result_prompt
	li $v0, 4
	syscall
	print_floor
	print_newline
	
	iter_print_y:
		print_wall
		
		mul $s0, $t0, MATRIX_DIM 
		add $s0, $s0, $t1
		mul $s0, $s0, FLOAT_SIZE
				
		lwc1 $f12, y($s0)
		li $v0, 2
		syscall
		
		add $t1, $t1, 1  
		blt $t1, MATRIX_DIM, iter_print_y   
		li $t1, 0  
		
		print_wall
		print_newline
		print_floor
		print_newline
		
		add $t0, $t0, 1  
		blt $t0, MATRIX_DIM, iter_print_y 
			
	exit

################################################################################################################
################################################################################################################
################################################################################################################
################################################################################################################
################################################################################################################
###################################         THE END OF PROGRAM          ########################################
################################################################################################################
################################################################################################################
################################################################################################################
################################################################################################################
