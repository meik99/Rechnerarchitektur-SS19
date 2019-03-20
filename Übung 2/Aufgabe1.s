.globl main

.data
    str: .asciiz "this    is      a string!"
    newline: .asciiz "\n"

.text

# $s0 = words
main:
    addi    $s0, $zero, 0   # Initialize s0 with 0    
    la      $a0, str        # Load address of str into a0
    jal		titlecase	    # jump to titlecase and save position to $ra

    addi    $s0, $v0, 0     # Save result of titlecase into s0

    addi    $v0, $zero, 4   # Set v0 to 4 to print string
    la      $a0, str        # Load adress of str into a0
    syscall                 # Call to print srt to screen


    addi    $v0, $zero, 4   # Set v0 to 4 to print string
    la      $a0, newline        # Load adress of newline into a0
    syscall                 # Call to print newline to screen

    #addi    $v0, $zero, 1   # Set v0 to 1 to print integer
    #addi    $a0, $s0, 0     # Load result of titlecase into a0
    #syscall                 # Call to print result of titlecase to screen

    addi    $v0, $zero, 10  # Set v0 to 10 to exit program
    syscall                 # Exit program

    


# $a0 = char* c
# $t0 = words
# $t1 = last_was_whitespace
# $t2 = current character
# $t3 = counter for character
# $t4 = tmp variable
titlecase:
    # Initialize function
    addi    $sp,    $sp,    -12 # Creating space for 3 words
    sw      $fp,    8($sp)      # Save Framepointer in sp + 8
    sw      $ra,    4($sp)      # Save Return Adress in sp + 4
    sw      $a0,    0($sp)      # Save argument a0 in sp + 0

    # Initialize $t0, $t2, $t3, $t4 and $t1 with 0, 0, 0, 0 and 1 respectivly
    addi    $t0,    $zero,  0
    addi    $t1,    $zero,  1
    addi    $t2,    $zero,  0
    addi    $t3,    $zero,  0
    addi    $t4,    $zero,  0

    addi	$t3,    $a0,    0		# Load adress of c into t3
    
titlecase_loop:
    lb		$t2, 0($t3)		# Load character at $t3 into $t2
    beq     $t2, $zero, titlecase_exit # Exit loop if t2 == 0

    # check if last was whitespace | if (last_was_whitespace &&...
    beq		$t1, $zero, titlecase_check_for_whitespace	# if $t1 == 0 then titlecase_check_for_whitespace

    # check if current character >= 'a'
    # $t4 = $t2 - 32: set t4 to current char - 32
    addi	$t4, $t2, -97			
    bltz    $t4, titlecase_check_for_whitespace # ... && *c >= 'a' ...
         
    # check if current charachter <= z
    addi	$t4, $t2, -123
    slt     $t4, $t4, 0     # set t4 = 1 if t4 < 0 (which means c <= 'z'
    beq     $t4, $zero, titlecase_check_for_whitespace # ... && *c <= 'z')

    xori    $t2, $t2, 32        # c ^= 32
    sb		$t2, 0($t3)	    	# Save capitalized letter back into str
    
    addi    $t1, $zero, 0       # last_was_whtiespace = 0
    j		titlecase_increase_counter    # jump to titlecase_increase_counter   

    
titlecase_check_for_whitespace:
    # if (*c == ' ') {titlecase_handle_whitespace}
    beq     $t2, 32, titlecase_handle_whitespace 

    # else
    addi    $t1, $zero, 0   # last_was_whitespace = 0
    j       titlecase_increase_counter


titlecase_handle_whitespace:
    addi    $t0, $t0, 1         # words = words + 1
    sub		$t0, $t0, $t1		# words = words - last_was_whitespace
    addi    $t1, $zero, 1       # last_was_whitespace = 1
    j		titlecase_increase_counter	# jump to titlecase_increase_counter
    
    

titlecase_increase_counter:
    addi    $t3, $t3, 1         # c++ (only increase by one byte for next character
    j       titlecase_loop

titlecase_exit:
    addi    $t0, $t0, 1         # words = words + 1
    sub		$t0, $t0, $t1		# $ words = words - last_was_whitespace

    addi    $v0, $t0, 0     # Set return value to words

    # Clean Up
    lw      $fp, 8($sp)         # Set Framepointer
    lw      $ra, 4($sp)         # Set Return Adress
    addiu   $sp, $sp, 12        # Remove Stackframe
    jr      $ra                 # Jump to return adress

