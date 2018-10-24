#Julian Marin (jcm5814)
#October 24, 2018
#MIPS SIMON SAYS

.data
	seqArray:		.space	100		#Sequence array
	max:			.word	0		#Max of sequence
	genID:			.word 	0		#ID of generator
	seed:			.word	0		#Seed of generator
	randomNum:		.word	0		#Random number generated

.text
	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seeqArray into $a0
	la		$a1, max		#Load address of max into $a1

	#CLEAR VALUES
	jal		initializeValues	#Jump and link to initializeValues

	#LOOP BASED ON DIFFICULTY
	li		$t6, 0			#Counter
	createSeqLoop:
	#LOAD ARGUMENTS
	la		$a0, genID		#Load address of genID into $a0
	la		$a1, seed		#Load address of seed into $a1

	#GET RANDOM NUM
	jal		getRandomNum		#Jump and link to getRandomNum
	sw		$v0, randomNum		#Store generated number
	
	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seqArray into $a0
	la		$a1, randomNum		#Load address of randomNum into $a1
	la		$a2, max		#Load address of randomNum into $a2
	
	#CORRECT SEQUENCE ELEMENT POSITION
	move		$t7, $t6		#Copy counter into $t1
	sll		$t7, $t7, 2		#Multiply by 4
	add		$a0, $a0, $t7		#Add to array address to set correct element
	addi		$t6, $t6, 1		#Increment counter
	
	#ADD RANDOM TO SEQ AND CHECK LOOP
	jal		addToSeq		#Jump and link to addToSeq
	bne		$t0, 5, createSeqLoop	#Loop if counter is not 5 [PLACEHOLDER UNTIL DIFFICULTY IS ADDED]
	
	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seqArray into $a0
	la		$a1, max		#Load address of max into $a1
	
	#DISPLAY SEQUENCE
	jal		displaySeq		#Jump and link to displaySeq
	
	#USER CHECK
	la		$a0, seqArray		#Load address of seqArray into $a0 (THIS IS DONE TO RESET TO START OF ARRAY)
	jal		userCheck		#Jump and link to displaySeq
	
	#EXIT
	li		$v0, 17			#Load exit call
	syscall					#Execute

#Procedure: initializeValues
#Clear all values for new game
#$a0 = pointer to seqArray
#$a1 = pointer to max
initializeValues:
	#CLEAR SEQUENCE	
	li		$t0, 24			#Max words to clear
	li		$t1, 0			#Index
	initLoop:
	sw		$0, 0($a0)		#Clear index of array
	addi		$t1, $t1, 1		#Incremement counter
	addi		$a0, $a0, 4		#Incremement to next element in array
	bne 		$t1, 25, initLoop	#Loop if counter is not 100
	subi		$a0, $a0, 100		#Go back to first element
	
	#CLEAR MAX
	sw		$0, 0($a1)		#Reset Max
	
	jr		$ra			#Return
	
#Procedure: getRandomNum
#Get random number for sequence
#$a0 = pointer to genID
#$a1 = pointer to seed
#$v0 = random number generated
getRandomNum:
	#CLEAR
	sw		$0, 0($a0)		#Set generator ID to 0

	#SAVE ADDRESSES
	move		$t0, $a0		#Copy address of genID in $a0 into $t0
	move		$t1, $a1		#Copy address of seed in $a1 into $t1
	
	#GET AND STORE SYSTEM TIME
	li		$v0, 30			#Load syscall for systime
	syscall					#Execute
	sw		$a0, 0($t1)		#Store systime into seed
	
	#SET AND STORE SEED
	lw		$a0, ($t0)		#Set $a0 to genID
	lw		$a1, ($t1)		#Set $a1 to seed
	li		$v0, 40			#Load syscall for seed
	syscall					#Execute
	sw		$a1, 0($t1)		#Store generated seed into seed label
	
	#PAUSE FOR RANDOMNESS
	li		$a0, 10			#Sleep for 10ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#GENERATE RANDOM RANGE 1-4
	li		$a1, 4			#Upper bound of range = 4
	li		$v0, 42			#Load syscall for random int range
	syscall					#Execute
	addi		$a0, $a0, 1		#Add 1 to make range 1-4
	move		$v0, $a0		#Copy generated random to $v0
	
	#RESET ADDRESSES
	move		$a0, $t0		#Copy address of genID in $t0 into $a0
	move		$a1, $t1		#Copy address of seed in $t1 into $a1
	
	jr		$ra			#Return
	
#Procedure: addToSeq
#Add generated random to sequence
#$a0 pointer to seqArray
#$a1 pointer to randomNum
#$a2 pointer to max
addToSeq:
	#ADD TO SEQUENCE ARRAY
	lw		$t0, 0($a1)		#Load word of randomNum into $t0
	sw		$t0, 0($a0)		#Store randomNum into sequence
	
	#INCREMENT MAX
	lw		$t0, 0($a2)		#Load word of randomNum into $t0
	addi		$t0, $t0, 1		#Increment max by 1
	sw		$t0, 0($a2)		#Store incremented value into max
	
	jr		$ra			#Return

#Procedure: displaySeq
#Display generated sequence to player
#$a0 pointer to seqArray
#$a1 pointer to max
displaySeq:
	#BLINK EACH NUM IN SEQUENCE
	li		$t0, 0			#Counter
	lw		$t1, 0($a1)		#Load word of max from $a1
	move		$t2, $a0		#Copy address of sequence to $t2
	blinkLoop:	
	#PRINT ELEMENT
	lw		$a0, 0($t2)		#Get element from sequence
	li		$v0, 1			#Load syscall for print int
	syscall					#Execute
	
	#INCREMENT AND CHECK
	addi		$t2, $t2, 4		#Increment to next element
	addi		$t0, $t0, 1		#Increment counter by 1
	
	#PRINT NEWLINE AND CHECK CONDITION
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	
	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	bne		$t0, 5, blinkLoop	#Loop if counter has not reached max
	
	jr		$ra			#Return
	
#Procedure: userCheck:
#Display generated sequence to player
#$a0 pointer to seqArray
#$a1 pointer to max
userCheck:
	#BLINK EACH NUM IN SEQUENCE
	li		$t0, 0			#Counter
	lw		$t1, 0($a1)		#Load word of max from $a1
	move		$t2, $a0		#Copy address of sequence to $t2
	userCheckLoop:	
	#GET USER INPUT
	li		$v0, 5			#Load syscall for read int
	syscall					#Execute
	
	#CHECK IF CORRECT
	lw		$a0, 0($t2)		#Get element from sequence
	bne		$v0, $a0, fail		#Check if user input is correct
	
	#INCREMENT AND CHECK
	addi		$t2, $t2, 4		#Increment to next element
	addi		$t0, $t0, 1		#Increment counter by 1
	
	bne		$t0, 5, userCheckLoop	#Loop if counter has not reached max
	
	#USER PASS
	li		$v0, 1			#Set return to 1 (WIN)
	jr		$ra			#Return
	
	#IF USER FAILS
	fail:
	li		$v0, 0			#Set return to 0 (LOSE)
	jr		$ra			#Return
	
	
	
	
	
	