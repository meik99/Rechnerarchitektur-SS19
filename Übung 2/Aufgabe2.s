# int catalan(int n) {
#     if(n < 2) {
#         return 1;
#     }
#     int res = 0;
#     for(int i=0; i<n; i++) {
#         res += catalan(i)*catalan(n-i-1);
#     }
#     return res;
# }

.globl main

.data
.text
main:
    addi $sp, $sp, -8  # Reserve space for 2 words.
    sw   $ra, 4($sp)   # Preserve return address.
    sw   $fp, 0($sp)   # Preserve frame pointer.

    addi $a0, $0, 5    # Sets the first argument to 5.
    jal catalan        # Call the catalan function.

    lw   $fp, 0($sp)   # restore frame pointer
   	lw   $ra, 4($sp)   # restore return address
   	jr $ra

catalan:
    addi $sp, $sp, -12 # Reserve space for 3 words (return address, argument n, frame pointer).
    sw   $ra, 8($sp)   # Preserve return address.
    sw   $a0, 4($sp)   # Preserve argument n.
    sw   $fp, 0($sp)   # Preserve frame pointer.
    addi $fp, $sp, 12  # Adjust frame pointer.

    addi $t3, $0, 1    # Cache value 1 in register t3 for comparison.
    addi $s0, $0, 1    # Set $s0 to 1.

    slt $t1, $a0, 2                 # Store result of (n<2) in t1.
    beq $t3, $t1, catalan_return    # Immediately return 1 if n is smaller than 2. 1 == t1

    addi $s0, $0, 0    # Set $s0 (res) to 0.
    addi $t0, $0, 0    # Set $t0 (i) to 0.
    add $t2, $0, $a0    # Cache argument $a (n) in $t2.
catalan_loop:
    slt $t1, $t0, $t2               # Check if $0(i) < $t2(n).
    beq $0, $t1, catalan_return     # If not smaller then go to return.

    add $a0, $0, $t0  # Sets the first argument to i. $t0.
    jal  catalan       # catalan(i)

    addi $t0, $t0, 1 # Perform i++.
    j catalan_loop   # Jump to loop begin.


catalan_return:
    lw   $fp, 0($sp)   # Restore frame pointer.
    lw   $ra, 8($sp)   # restore return address.
    addi $sp, $sp, 12  # clean up stack.
    jr   $ra	       # Use return address to jump back.
