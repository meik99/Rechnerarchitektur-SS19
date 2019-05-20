# void floating(int ia, int ib) {
#     double a = (double)ia;
#     double b = (double)ib;
#     while(1.0 < a / b) {
#         b = b + 1.0;
#         a = a / b;
#     }
#     printf("%f", a);
# }

.globl main

.data
.text

# Method: floating(int, int)
# Params: int ia = $a0, int ib = $a1
# Description:
#     Converts params to double a, b
#     while a / b > 1
#         adds 1 to b
#         divides a by b
#     prints a
floating:
    floatin_init:
        addi $sp, $sp, -24 # Reserve space for 3 words (return address, argument n, frame pointer).
        sw   $ra, 8($sp)   # Preserve return address.
        sw   $s0, 4($sp)   # Store the callee safe register $s0 on the stack.
        sw   $fp, 0($sp)   # Preserve frame pointer.
        addi $fp, $sp, 24  # Adjust frame pointer.

    floating_load_params:
        addi    $t0,    $0,     1
        mtc1    $a0,    $f6
        mtc1    $a1,    $f8
        mtc1    $t0,    $f12

        cvt.d.w $f0,    $f6     # f0 = a
        cvt.d.w $f2,    $f8     # f2 = b
        cvt.d.w $f4,    $f12    # f4 = 1

    floating_loop_header:
        div.d   $f6,    $f0,    $f2 # f6 = a / b
        c.lt.d  $f4,    $f6         # 1 < f6 (a / b)
        bc1f    floating_print # if false jump

    floating_loop_body:
        add.d   $f2,    $f2,    $f4 # add 1 to b
        div.d   $f0,    $f0,    $f2 # divide a by b
        j   floating_loop_header

    floating_print:
        mtc1    $zero,    $f6
        mtc1    $zero,    $f7

        addi    $v0,    $0,    3
        mov.d   $f12,   $f0
        syscall

    floating_exit:
        lw   $fp, 0($sp)   # Restore frame pointer.
        lw   $s0, 4($sp)   # Restore the callee safe register $s0 from the stack.
        lw   $ra, 8($sp)   # Restore return address.
        addi $sp, $sp, 24  # clean up stack.
        jr   $ra	       # Use return address to jump back.

main:
    addi $sp, $sp, -8  # Reserve space for 2 words.
    sw   $ra, 4($sp)   # Preserve return address.
    sw   $fp, 0($sp)   # Preserve frame pointer.

    addi $a0, $0, 10
    addi $a1, $0, 2

    jal floating

    lw   $fp, 0($sp)   # Restore frame pointer
   	lw   $ra, 4($sp)   # Restore return address
   	jr $ra             # Exit.


# .globl main

# .data
# .text
# main:
#     addi $sp, $sp, -8  # Reserve space for 2 words.
#     sw   $ra, 4($sp)   # Preserve return address.
#     sw   $fp, 0($sp)   # Preserve frame pointer.

#     addi $a0, $0, 10   # Sets the first argument to (10). <-
#     jal catalan        # Call the catalan function.

#     add $s0, $0, $v0  # Result (16796) is stored in $s0.  <-

#     lw   $fp, 0($sp)   # Restore frame pointer
#    	lw   $ra, 4($sp)   # Restore return address
#    	jr $ra             # Exit.

# catalan:
#     addi $sp, $sp, -24 # Reserve space for 3 words (return address, argument n, frame pointer).
#     sw   $ra, 8($sp)   # Preserve return address.
#     sw   $s0, 4($sp)   # Store the callee safe register $s0 on the stack.
#     sw   $fp, 0($sp)   # Preserve frame pointer.
#     addi $fp, $sp, 24  # Adjust frame pointer.

#     addi $t1, $0, 1    # Cache value 1 in register $t1 for comparison.
#     addi $v0, $0, 1    # Set the return value of the function to 1.

#     slt $t2, $a0, 2    # Store result of n smaller 2 in $t2. Immediately return 1 if n is smaller than 2.
#     beq $t1, $t2, catalan_return

#     addi $s0, $0, 0    # Set $s0 (res) to 0.
#     addi $t0, $0, 0    # Set $t0 (i) to 0.
#     add  $t3, $0, $a0  # Cache argument $a0 (n) in $t3.

# catalan_loop:
#     add $v0, $0, $s0                # Cache $s0 (res) as return value.
#     slt $t2, $t0, $t3               # Check if $0(i) < $t2(n).
#     beq $0, $t2, catalan_return     # If not smaller then go to return.

#     sw $t0, 20($sp)     # Store temp register $t0(i) on the stack. (The caller is responsible)
#     sw $t3, 16($sp)     # Store temp register $t3(n) on the stack.  (The caller is responsible)

#     add $a0, $0, $t0   # Sets the first argument to $t0(i).
#     jal  catalan       # catalan(i)

#     lw $t3, 16($sp)   # Restore temp register $t3(n) from the stack.
#     lw $t0, 20($sp)   # Restore temp register $t0(i) from the stack.

#     addi $a0, $0, -1  # Set the parameter of catalan(n-i-1).
#     add $a0, $a0, $t3
#     sub $a0, $a0, $t0

#     sw $t0, 20($sp)     # Store temp register $t0(i) on the stack. (The caller is responsible)
#     sw $t3, 16($sp)     # Store temp register $t3(n) on the stack. (The caller is responsible)
#     sw $v0, 12($sp)     # Store temp register catalan(i) result on the stack. (The caller is responsible)

#     jal  catalan      # catalan(n-i-1)

#     lw $t4, 12($sp)   # Restore temp register catalan(i) result from the stack.
#     lw $t3, 16($sp)   # Restore temp register $t3(n) from the stack.
#     lw $t0, 20($sp)   # Restore temp register $t0(i) from the stack.

#     mul $t4, $t4, $v0  # Multiply catalan(i)*catalan(n-i-1) and store result in $t4.
#     add $s0, $s0, $t4 # Add the result. res += catalan(i)*catalan(n-i-1);

#     addi $t0, $t0, 1 # Perform i++.
#     j catalan_loop   # Jump to loop begin.

# catalan_return:
#     lw   $fp, 0($sp)   # Restore frame pointer.
#     lw   $s0, 4($sp)   # Restore the callee safe register $s0 from the stack.
#     lw   $ra, 8($sp)   # Restore return address.
#     addi $sp, $sp, 24  # clean up stack.
#     jr   $ra	       # Use return address to jump back.
