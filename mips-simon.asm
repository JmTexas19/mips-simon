#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	sequenceArray:		.space	20		#Sequence of 5
	genID:			.word 	0		#ID of generator
	seed:			.word	0		#Seed of generator



.text
	#CLEAR VALUES
	la		$a0, genID		#Load address of genID into $a0
	jal		initializeValues	#Jump and link to initializeValues

	#GET RANDOM NUM
	
	#EXIT
	li		$v0, 17			#Load exit call
	syscall					#Execute

#Procedure: initializeValues
#Clear all values for new game
#Input
initializeValues:
	#CLEAR
	sw		$0, 0($a0)			#Set generator ID to 0

	jr		$ra			#Return