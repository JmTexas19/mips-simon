#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	sequenceArray:		.space	20		#Sequence of 5
	genID:			.word 	0		#ID of generator
	seed:			.word	0		#Seed of generator

.text
	#LOAD ARGUMENTS
	la		$a0, genID		#Load address of genID into $a0
	la		$a1, seed		#Load address of seed into $a1

	#CLEAR VALUES
	jal		initializeValues	#Jump and link to initializeValues

	#GET RANDOM NUM
	jal		getRandomNum		#Jump and link to getRandomNum
	
	#EXIT
	li		$v0, 17			#Load exit call
	syscall					#Execute

#Procedure: initializeValues
#Clear all values for new game
#$a0 = pointer to genID
#$a1 = pointer to seed
initializeValues:
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
	
	#RESET ADDRESSES
	move		$a0, $t0		#Copy address of genID in $t0 into $a0
	move		$a1, $t1		#Copy address of seed in $t1 into $a1

	jr		$ra			#Return
	
#Procedure: getRandomNum
#Get random number for sequence
#$a0 = pointer to genID
#$a1 = pointer to seed
#$v0 = random number generated
getRandomNum:
	#SAVE ADDRESSES
	move		$t0, $a0		#Copy address of genID in $a0 into $t0
	move		$t1, $a1		#Copy address of seed in $a1 into $t1
	
	#GENERATE RANDOM RANGE 1-4
	li		$a1, 4			#Upper bound of range = 4
	li		$v0, 42			#Load syscall for random int range
	syscall					#Execute
	addi		$a0, $a0, 1		#Add 1 to make range 1-4
	
	#RESET ADDRESSES
	move		$a0, $t0		#Copy address of genID in $t0 into $a0
	move		$a1, $t1		#Copy address of seed in $t1 into $a1
	
	jr		$ra			#Return
	
	
	
	
	
	
	
	
	
	
	
	
	