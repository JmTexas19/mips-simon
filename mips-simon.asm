#Julian Marin (jcm5814)
#October 24, 2018
#MIPS SIMON SAYS

.data
	#STACK
	stack_beg:
       				.word   0 : 40
	stack_end:
	
	#DATA
	seqArray:		.space	100		#Sequence array
	max:			.word	0		#Max of sequence
	genID:			.word 	0		#ID of generator
	seed:			.word	0		#Seed of generator
	randomNum:		.word	0		#Random number generated
	
	#STRINGS
	winPrompt:		.asciiz "YOU WIN!"	#Win prompt
	losePrompt:		.asciiz "YOU LOSE!"	#Lose prompt
	introPrompt:		.asciiz "Welcome to Simon Says! Enter 1 for easy, 2 for normal, 3 for hard. Enter 0 to quit."
	colourPrompt:		.asciiz "BLUE: 1\nGREEN: 2\nRED: 3\nMAGENTA: 4\n"
	invalidNumPrompt:	.asciiz "Invalid number entered, please try again."
	digit1:			.asciiz "1"
	digit2:			.asciiz "2"
	digit3:			.asciiz "3"
	digit4:			.asciiz "4"
	
	#COLOR TABLE
	colourTable:		.word	0x000000	#Black
				.word	0x0000ff	#Blue
				.word	0x00ff00	#Green
				.word	0xff0000	#Red
				.word	0x00ffff	#Blue-Green
				.word	0xff00ff	#Blue-Red
				.word	0xffff00	#Green-Red
				.word	0xffffff	#White
			
	#DIGIT TABLE	
	DigitTable:
        .byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        .byte   '0', 0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '1', 0x38,0x78,0xf8,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
        .byte   '2', 0x7e,0xff,0x83,0x06,0x0c,0x18,0x30,0x60,0xc0,0xc1,0xff,0x7e
        .byte   '3', 0x7e,0xff,0x83,0x03,0x03,0x1e,0x1e,0x03,0x03,0x83,0xff,0x7e
        .byte   '4', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '5', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0x7f,0x03,0x03,0x83,0xff,0x7f
        .byte   '6', 0xc0,0xc0,0xc0,0xc0,0xc0,0xfe,0xfe,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '7', 0x7e,0xff,0x03,0x06,0x06,0x0c,0x0c,0x18,0x18,0x30,0x30,0x60
        .byte   '8', 0x7e,0xff,0xc3,0xc3,0xc3,0x7e,0x7e,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '9', 0x7e,0xff,0xc3,0xc3,0xc3,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '+', 0x00,0x00,0x00,0x18,0x18,0x7e,0x7e,0x18,0x18,0x00,0x00,0x00
        .byte   '-', 0x00,0x00,0x00,0x00,0x00,0x7e,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   '*', 0x00,0x00,0x00,0x66,0x3c,0x18,0x18,0x3c,0x66,0x00,0x00,0x00
        .byte   '/', 0x00,0x00,0x18,0x18,0x00,0x7e,0x7e,0x00,0x18,0x18,0x00,0x00
        .byte   '=', 0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   'A', 0x18,0x3c,0x66,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3
        .byte   'B', 0xfc,0xfe,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'C', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc1,0xff,0x7e
        .byte   'D', 0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'E', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xff,0xff
        .byte   'F', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xc0,0xc0
# add additional characters here....
# first byte is the ascii character
# next 12 bytes are the pixels that are "on" for each of the 12 lines
        .byte    0, 0,0,0,0,0,0,0,0,0,0,0,0
	
.text
main:
	#STACK
	la		$sp, stack_end

	#DRAW BLUE CIRCLE
	la		$a0, 64			#x 
	la		$a1, 64			#y 
	la		$a2, 1			#colour
	la		$a3, 64			#square size 
	blueFillLoop:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, blueFillLoop	#If a3 is not 0, branch
	
	#DRAW DIGIT
	li		$a0, 59			#x 
	li		$a1, 59			#y 
	la		$a2, digit1
	jal		OutText
	
	#PLAY TONE BLUE
	li		$a0, 60			#Pitch
	li		$a1, 4000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW GREEN CIRCLE
	la		$a0, 192		#x 
	la		$a1, 64			#y 
	la		$a2, 2			#colour 
	la		$a3, 64			#square size 
	greenFillLoop:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, greenFillLoop	#If a3 is not 0, branch
	
	#DRAW DIGIT
	li		$a0, 187		#x 
	li		$a1, 59			#y 
	la		$a2, digit2
	jal		OutText
	
	#PLAY TONE GREEN
	li		$a0, 65			#Pitch
	li		$a1, 4000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW RED CIRCLE
	la		$a0, 64			#x 
	la		$a1, 192		#y
	la		$a2, 3			#colour 
	la		$a3, 64			#square size 
	redFillLoop:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, redFillLoop	#If a3 is not 0, branch
	
	#DRAW DIGIT
	li		$a0, 59			#x 
	li		$a1, 187		#y 
	la		$a2, digit3
	jal		OutText
	
	#PLAY TONE RED
	li		$a0, 70			#Pitch
	li		$a1, 4000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW MAGENTA CIRCLE
	la		$a0, 192		#x 
	la		$a1, 192		#y 
	la		$a2, 5			#colour  
	la		$a3, 64			#square size 
	magentaFillLoop:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, magentaFillLoop	#If a3 is not 0, branch
	
	#DRAW DIGIT
	li		$a0, 187		#x 
	li		$a1, 187		#y 
	la		$a2, digit4
	jal		OutText
	
	#PLAY TONE MAGENTA
	li		$a0, 75			#Pitch
	li		$a1, 4000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute

	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seeqArray into $a0
	la		$a1, max		#Load address of max into $a1

	#CLEAR VALUES
	jal		initializeValues	#Jump and link to initializeValues

	#PRINT INTRO
	la		$a0, introPrompt	#Load address of intoPrompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#GET USER INPUT
	li		$v0, 5			#Load syscall for read int
	syscall		
	
	#CHECK USER INPUT
	beq		$v0, 0, exit		#Branch if $v0 is equal to 2 (QUIT)
	beq		$v0, 1, easy		#Branch if $v0 is equal to 1 (EASY)
	beq		$v0, 2, normal		#Branch if $v0 is equal to 2 (NORMAL)
	beq		$v0, 3, hard		#Branch if $v0 is equal to 3 (HARD)
	j		invalidNum		#Jump to invalidNum
	
	#EASY MODE
	easy:
	li		$t0, 5			#Load 5 into $t0
	sw		$t0, max		#Store 5 into max label	
	j		continue		#Jump to continue
	
	#NORMAL MODE
	normal:
	li		$t0, 8			#Load 8 into $t0
	sw		$t0, max		#Store 5 into max label	
	j		continue		#Jump to continue
	
	#HARD MODE
	hard:
	li		$t0, 11			#Load 11 into $t0
	sw		$t0, max		#Store 5 into max label	
	j		continue		#Jump to continue
	
	continue:
	#PRINT COLORS
	la		$a0, colourPrompt	#Load address of colourPrompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#CLEAR
	jal		clearDisplay		#Clear display
	
	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#LOOP BASED ON DIFFICULTY
	li		$t6, 0			#Counter
	lw		$t5, max		#Number of sequences
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
	
	#CORRECT SEQUENCE ELEMENT POSITION
	move		$t7, $t6		#Copy counter into $t1
	sll		$t7, $t7, 2		#Multiply by 4
	add		$a0, $a0, $t7		#Add to array address to set correct element
	addi		$t6, $t6, 1		#Increment counter
	
	#ADD RANDOM TO SEQ AND CHECK LOOP
	jal		addToSeq		#Jump and link to addToSeq
	bne		$t6, $t5, createSeqLoop	#Loop if counter is not max
	
	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seqArray into $a0
	la		$a1, max		#Load address of max into $a1
	
	#DISPLAY SEQUENCE
	jal		displaySeq		#Jump and link to displaySeq
	li		$v0, 1			#Set $v0 to win
	
	printResult:	
	#PRINT RESULT
	beq		$v0, 0, lose		#Branch if return is equal to 0
	beq		$v0, 1, win		#Branch if return is equal to 1
	
	#LOSE
	lose:
	la		$a0, losePrompt		#Load address of lose prompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#PRINT NEWLINE
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	j		resetReg		#Loop program
	
	#WIN
	win:
	la		$a0, winPrompt		#Load address of win prompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#PRINT NEWLINE
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	j		resetReg		#Loop program
	
	#INVALID NUM
	invalidNum:
	la		$a0, invalidNumPrompt	#Load address of invalidNumPrompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#PRINT NEWLINE
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	j		resetReg		#Loop program
	
	resetReg:
	#RESET ALL REGISTERS AND LOOP
	li		$t0, 0
	li		$t1, 0
	li		$t2, 0
	li		$t3, 0
	li		$t4, 0
	li		$t5, 0
	li		$t6, 0
	li		$s1, 0
	li		$s2, 0
	li		$s3, 0
	li		$a0, 0
	li		$a1, 0
	li		$a2, 0
	li		$v0, 0
	j		main			#Loop program
	
	#EXIT
	exit:
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
addToSeq:
	#ADD TO SEQUENCE ARRAY
	lw		$t0, 0($a1)		#Load word of randomNum into $t0
	sw		$t0, 0($a0)		#Store randomNum into sequence
	
	jr		$ra			#Return

#Procedure: displaySeq
#Display generated sequence to player
#$a0 pointer to seqArray
#$a1 pointer to max
displaySeq:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -12		#Make room on stack for 4 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	sw		$a0, 4($sp)		#Store $a0 on element 1 of stack
	sw		$a1, 8($sp)		#Store $a1 on element 2 of stack
	lw		$s3, 0($a1)		#Load word of max into $s3
	
	#FOR LOOP FOR GOING THROUGH SEQUENCE ONE BY ONE
	li		$s2, 2			#Counter for going through loop one by one number of elements to display [counter 2]
	move		$s5, $a0		#Save pointer to first element in sequence in $s5
	lw		$t1, 0($a1)		#Load word of max from $a1
	forLoop:	
	beqz  		$s1, displayUserCheckSkip	#If counter 1 is equal to 0, skip userCheck
	
	#RESET ADDRESSES
	li		$a0, 0			#Reset $a0
	li		$a1, 0			#Reset $a1
	lw		$a0, 4($sp)		#Reset $a0 address
	lw		$a1, 8($sp)		#Reset $a0 address
	
	#USER CHECK
	addi		$s2, $s2, 1		#Increment counter 2 by 1
	sw		$s2, 0($a1)		#Store new max into label
	jal		userCheck		#Jump and link to user check
	
	#RESET
	li		$a0, 0			#Reset $a0
	li		$a1, 0			#Reset $a1
	lw		$s5, 4($sp)		#Reset $s5
	lw		$a0, 4($sp)		#Reset $a0 address
	move		$t1, $s2		#Load word of max from $s2
	
	#CHECK IF DONE
	beq 		$s2, $s3, displayDone	#If loop does not equal max, branch
	
	#PAUSE
	li		$a0, 1200		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	move		$a0, $s5		#Reset $a0 address

	displayUserCheckSkip:
	#BLINK EACH NUM IN SEQUENCE
	li		$s1, 0			#Counter
	move		$t2, $a0		#Copy address of sequence to $t2
	move		$t4, $a1		#Copy pointer of max to $t4
	
	#CLEAR DISPLAY
	jal		clearDisplay		#Clear Display
	move		$t2, $s5		#Load sequence
	
	#LOAD ELEMENT
	blinkLoop:	
	lw		$t3, 0($t2)		#Load element from sequence
	move		$a0, $t3		#Copy num to blink
	li		$a1, 700		#Reset $a1
	jal		blinkNum
	move		$t2, $s5		#Load sequence
		
	returnLoop:				#Return from blink
	#INCREMENT AND CHECK
	addi		$t2, $t2, 4		#Increment to next element in sequence
	addi		$s1, $s1, 1		#Increment counter by 1		
	move		$s5, $t2		#Set $s5
	
	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	ble   		$s1, $s2, blinkLoop	#Loop if counter has not reached 2nd counter
	
	j		forLoop
	
	displayDone:
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	
	jr		$ra			#Return
	
#Procedure: userCheck:
#Display generated sequence to player
#$a0 pointer to seqArray
#$a1 pointer to max
userCheck:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -12		#Make room on stack for 4 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	sw		$a1, 4($sp)		#Store max on element 1 of stack
	sw		$a0, 8($sp)		#Store max on element 2 of stack
	
	#BLINK EACH NUM IN SEQUENCE
	li		$s4, 0			#Counter
	move		$s6, $a0		#Copy address of sequence to $t2
	
	userCheckLoop:	
	#GET USER INPUT
	jal		getChar			#Get character from user
	
	#CHECK IF CORRECT
	addi		$v0, $v0, -48		#Convert ascii to decimal
	lw		$a0, 0($s6)		#Get element from sequence
	bne		$v0, $a0, fail		#Check if user input is correct
	
	#INCREMENT AND CHECK
	addi		$s6, $s6, 4		#Increment to next element
	addi		$s4, $s4, 1		#Increment counter by 1
	
	#BLINK AND LOOP
	li		$a1, 70			#Reset $a1
	jal		blinkNum		#Jump and link to blinkNum
	lw		$a1, 4($sp)		#Load max pointer of stack
	lw		$a1, 0($a1)		#Load max of stack
	bne		$s4, $a1, userCheckLoop	#Loop if counter has not reached max
	li		$v0, 1			#Set return to 1 (WIN)
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 12		#Readjust stack
	jr		$ra			#Return
	
	fail:
	#FAIL SOUND
	li		$a0, 0			#Pitch
	li		$a1, 4000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#PAUSE
	li		$a0, 1200		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#IF USER FAILS
	#PLAY FAILURE
	lw		$a0, 0($s6)		#Get element from sequence
	li		$a1, 200		#Delay
	jal		blinkNum		#Jump and link to blinkNum
	lw		$a0, 0($s6)		#Get element from sequence
	li		$a1, 200		#Delay
	jal		blinkNum		#Jump and link to blinkNum	
	
	#LEAVE
	li		$v0, 0			#Set return to 0 (LOSE)
	j		printResult		#Jump straight to printResult

#Procedure: drawDot:
#Draw a dot on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)	
#$a2 = colour number (0-7)
drawDot:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -8		#Make room on stack for 2 words
	sw		$a2, 0($sp)		#Store $a2 on element 0 of stack
	sw		$ra, 4($sp)		#Store $ra on element 1 of stack

	
	#CALCULATE ADDRESS
	jal		calculateAddress	#returns address of pixel in $v0
	lw		$a2, 0($sp)		#Restore $a2 from stack
	sw		$v0, 0($sp)		#Save $v0 on element 0 of stack
	
	#GET COLOR
	jal		getColour		#Returns colour in $v1
	lw		$v0, 0($sp)		#Restores $v0 from stack
	
	#MAKE DOT AND RESTORE $RA
	sw		$v1, 0($v0)		#Make dot
	lw		$ra, 4($sp)		#Restore $ra from stack
	addi		$sp, $sp, 8		#Readjust stack
	
	jr		$ra			#Return
	
#Procedure: calculateAddress:
#Convert x and y coordinate to address
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$v0 = memory address
calculateAddress:
	#CALCULATIONS
	sll		$a0, $a0, 2		#Multiply $a0 by 4
	sll		$a1, $a1, 7		#Multiply $a1 by 256
	sll		$a1, $a1, 3		#Multiply $a1 by 4
	add		$a0, $a0, $a1		#Add $a1 to $a0
	addi		$v0, $a0, 0x10040000	#Add base address for display + $a0 to $v0
	
	jr		$ra			#Return
	
#Procedure: getColour:
#Get the colour based on $a2
#$a2 = colour number (0-7)
getColour:
	#GET COLOUR	
	la		$a0, colourTable	#Load Base
	sll		$a2, $a2, 2		#Index x4 is offset
	add		$a2, $a2, $a0		#Address is base + offset
	lw		$v1, 0($a2)		#Get actual color from memory

	jr		$ra			#Return
	
#Procedure: drawHorzLine:
#Draw a horizontal line on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = length of the line
drawHorzLine:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -16		#Make room on stack for 4 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	
	#HORIZONTAL LOOP
	horzLoop:
	jal		drawDot			#Jump and Link to drawDot
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	
	#INCREMENT VALUES
	addi		$a0, $a0, 1		#Increment x by 1
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	addi		$a3, $a3, -1		#Decrement length of line
	bne		$a3, $0, horzLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 16		#Readjust stack
	
	jr		$ra			#Return

#Procedure: drawVertLine:
#Draw a vertical line on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = length of the line (1-32)
drawVertLine:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -16		#Make room on stack for 4 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a0 on element 0 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	
	#HORIZONTAL LOOP
	vertLoop:
	jal		drawDot			#Jump and Link to drawDot
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	
	#INCREMENT VALUES
	addi		$a1, $a1, 1		#Increment y by 1
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	addi		$a3, $a3, -1		#Decrement length of line
	bne		$a3, $0, vertLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 16		#Readjust stack
	
	jr		$ra			#Return

#Procedure: drawBox:
#Draw a box on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = size of box (1-32)
drawBox:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -24		#Make room on stack for 5 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	sw		$a3, 20($sp)		#Store $a3 on element 5 of stack
	move		$s0, $a3		#Copy $a3 to temp register
	sw		$s0, 16($sp)		#Store $s0 on element 5 of stack
	
	boxLoop:
	jal 		drawHorzLine		#Jump and link to drawHorzLine
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	lw		$a3, 20($sp)		#Restore $a3 from stack
	lw		$s0, 16($sp)		#Restore $s0 from stack
	
	#INCREMENT VALUES
	addi		$a1, $a1, 1		#Increment y by 1
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	addi		$s0, $s0, -1		#Decrement counter
	sw		$s0, 16($sp)		#Store $s0 on element 5 of stack
	bne		$s0, $0, boxLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 24		#Readjust stack
	addi		$s0, $s0, 0		#Reset $s0
	
	jr		$ra			#Return
	
#Procedure: clearDisplay:
#Clear a box on the bitmap display
clearDisplay:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack
	
	#GET REGISTERS READY TO CLEAR
	la		$a0, 0			#x-coordinate = 0
	la		$a1, 0			#y-coordinate = 0
	la		$a2, 0			#colour = black
	la		$a3, 256			#size to clear = 32
	
	jal		drawBox			#Clear Screen
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	
	jr		$ra			#Return
		
#Procedure: blinkNum:
#Clear a box on the bitmap display
#$a0 = num to blink
#$a1 = delay
blinkNum:
#BLINK CORRECT
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -8		#Make room on stack for 2 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack

	#BRANCH
	beq		$a0, 1, playBlue	#BLUE
	beq		$a0, 2,	playGreen	#GREEN
	beq		$a0, 3,	playRed		#RED
	beq		$a0, 4,	playMagenta	#MAGENTA

	#BLINK BLUE
	blinkCBlue:
	playBlue:
	#PLAY TONE BLUE
	li		$a0, 60			#Pitch
	li		$a1, 1000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW
	la		$a0, 64			#x = 1
	la		$a1, 64			#y = 1
	la		$a2, 1			#colour = 1
	la		$a3, 64			#square size = 14
	blueFillLoop2:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, blueFillLoop2	#If a3 is not 0, branch

	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 64			#x = 1
	la		$a1, 64			#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	blueFillLoop3:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, blueFillLoop3	#If a3 is not 0, branch
	
	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 64			#x = 1
	la		$a1, 64			#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	blueFillLoop4:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, blueFillLoop4	#If a3 is not 0, branch
	j		continueUserCheck
	
	#BLINK GREEN
	playGreen:
	#PLAY TONE GREEN
	li		$a0, 65			#Pitch
	li		$a1, 1000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW
	la		$a0, 192		#x = 1
	la		$a1, 64			#y = 1
	la		$a2, 2			#colour = 1
	la		$a3, 64			#square size = 14
	greenFillLoop2:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, greenFillLoop2	#If a3 is not 0, branch

	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 192		#x = 1
	la		$a1, 64			#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	greenFillLoop3:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, greenFillLoop3	#If a3 is not 0, branch
	
	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 192		#x = 1
	la		$a1, 64			#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	greenFillLoop4:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, greenFillLoop4	#If a3 is not 0, branch
	j		continueUserCheck
	
	#BLINK RED
	playRed:
	#PLAY TONE RED
	li		$a0, 70			#Pitch
	li		$a1, 1000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW
	blinkCRed:
	la		$a0, 64			#x = 1
	la		$a1, 192		#y = 1
	la		$a2, 3			#colour = 1
	la		$a3, 64			#square size = 14
	redFillLoop2:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, redFillLoop2	#If a3 is not 0, branch

	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 64			#x = 1
	la		$a1, 192		#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	redFillLoop3:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, redFillLoop3	#If a3 is not 0, branch
	
	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 64			#x = 1
	la		$a1, 192		#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	redFillLoop4:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, redFillLoop4	#If a3 is not 0, branch
	
	j		continueUserCheck
	
	#BLINK MAGENTA
	playMagenta:
	#PLAY TONE MAGENTA
	li		$a0, 75			#Pitch
	li		$a1, 1000		#Duration
	li		$a2, 0			#Instrument
	li		$a3, 127		#Volume
	li		$v0, 31			#Load syscall
	syscall					#Execute
	
	#DRAW
	blinkCMagenta:
	la		$a0, 192		#x = 1
	la		$a1, 192		#y = 1
	la		$a2, 5			#colour = 1
	la		$a3, 64			#square size = 14
	magentaFillLoop2:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, magentaFillLoop2	#If a3 is not 0, branch

	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 192		#x = 1
	la		$a1, 192		#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	magentaFillLoop3:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, magentaFillLoop3	#If a3 is not 0, branch
	
	#PAUSE
	lw		$a0, 4($sp)		#delay
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 192		#x = 1
	la		$a1, 192		#y = 1
	la		$a2, 0			#colour = 1
	la		$a3, 64			#square size = 14
	magentaFillLoop4:
	jal		drawCircle		#Jump and link to drawCircle
	addi		$a3, $a3, -1		#Decrement radius
	bnez		$a3, magentaFillLoop4	#If a3 is not 0, branch
	j		continueUserCheck
		
	continueUserCheck:
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 8		#Readjust stack
	jr		$ra			#Return

#Procedure: getChar
#Poll the keypad, wait for input
getChar:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	li		$s7, 0			#Counter
	j		check			#Skip first sleep
	
	charLoop:
	#SLEEP
	li		$a0, 1000		#1 second sleep
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#POLLING
	check:
	jal		isCharThere		#Jump and link to isCharThere
	addi		$s7, $s7, 1		#Increment $s3
	beq		$s7, 10, leaveChar	#If 5 seconds have passed, leave
	beqz  		$v0, charLoop		#If there is input, finish polling, else loop
	
	leaveChar:
	lui		$t0, 0xffff		#Register 0xffff0000
	lw		$v0, 4($t0)		#Get control
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	jr		$ra
	
#Procedure: isCharThere
#Poll the keypad, wait for input
#v0 = 0 (no data) or 1 (char in buffer)
isCharThere:
	lui		$t0, 0xffff		#Register 0xffff0000
	lw		$t1, 0($t0)		#Get control
	and		$v0, $t1, 1		#Look at least significent bit
	jr		$ra
	
#Procedure: drawCircle:
#Draw a circle in the center of the input pixel (This will be implemented using the 
#midpoint circle algorithm from https://en.wikipedia.org/wiki/Midpoint_circle_algorithm
#a0 = x0
#a1 = y0
#a2 = color
#a3 = radius
drawCircle:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -20		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 0 of stack
	sw		$a0, 4($sp)		#Store $a0 on element 1 of stack
	sw		$a1, 8($sp)		#Store $a1 on element 2 of stack
	sw		$a2, 12($sp)		#Store $a1 on element 3 of stack
	sw		$a3, 16($sp)		#Store $a1 on element 4 of stack

	#VARIABLES
	move		$t0, $a0			#x0
	move		$t1, $a1			#y0
	move		$t2, $a3			#radius
	addi		$t3, $t2, -1			#x
	li		$t4, 0				#y
	li		$t5, 1				#dx
	li		$t6, 1				#dy
	li		$t7, 0				#Err
	
	#CALCULATE ERR (dx - (radius << 1))
	sll		$t8, $t2, 1			#Bitshift radius left 1	
	subu		$t7, $t5, $t8			#Subtract dx - shifted radius 
	
	#While(x >= y)
	circleLoop:
	blt 		$t3, $t4, skipCircleLoop	#If x < y, skip circleLoop
	
	#Draw Dot (x0 + x, y0 + y)
	addu		$a0, $t0, $t3
	addu		$a1, $t1, $t4
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 + y, y0 + x)
        addu		$a0, $t0, $t4
	addu		$a1, $t1, $t3
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 - y, y0 + x)
        subu		$a0, $t0, $t4
	addu		$a1, $t1, $t3
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 - x, y0 + y)
        subu		$a0, $t0, $t3
	addu		$a1, $t1, $t4
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 - x, y0 - y)
        subu		$a0, $t0, $t3
	subu		$a1, $t1, $t4
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 - y, y0 - x)
        subu		$a0, $t0, $t4
	subu		$a1, $t1, $t3
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 + y, y0 - x)
        addu		$a0, $t0, $t4
	subu		$a1, $t1, $t3
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
        #Draw Dot (x0 + x, y0 - y)
	addu		$a0, $t0, $t3
	subu		$a1, $t1, $t4
	lw		$a2, 12($sp)
	jal		drawDot				#Jump to drawDot
	
	#If (err <= 0)
	bgtz 		$t7, doElse
	addi		$t4, $t4, 1		#y++
	addu		$t7, $t7, $t6		#err += dy
	addi		$t6, $t6, 2		#dy += 2
	j		circleContinue		#Skip else stmt
	
	#Else If (err > 0)
	doElse:
	addi		$t3, $t3, -1		#x--
	addi		$t5, $t5, 2		#dx += 2
	sll		$t8, $t2, 1		#Bitshift radius left 1	
	subu		$t9, $t5, $t8		#Subtract dx - shifted radius 
	addu		$t7, $t7, $t9		#err += $t9
	
	circleContinue:
	#LOOP
	j		circleLoop
	
	#CONTINUE
	skipCircleLoop:		
	
	#RESTORE REGISTERS
	lw		$ra, 0($sp)		
	lw		$a0, 4($sp)		
	lw		$a1, 8($sp)		
	lw		$a2, 12($sp)		
	lw		$a3, 16($sp)		
	addi		$sp, $sp, 20		#Readjust stack
	
	jr		$ra
	
# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
OutText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _text9

        la      $t3, DigitTable # find the character in the table
_text3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 8          # 8 bits to go out
_text5:
        la      $t7, colourTable
        lw      $t7, 0($t7)     # assume black
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _text6
        la      $t7, colourTable     # else it is white
        lw      $t7, 28($t7)
_text6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
