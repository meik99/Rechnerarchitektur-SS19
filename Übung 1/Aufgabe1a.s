# a = -17;
# b = 10;
# y = (-(a << b) + (a * b)) >> 7;

.globl main

.data
.text
main:
    addi $s0, $0, -17    # Constant 0 from zero register $0 plus constant -17 gets stored into safe register $s0.
    addi $s1, $0, 10     # Constant 0 from zero register $0 plus constant 10 gets stored into safe register $s1.

    sllv $t1, $s0, $s1   # Calculate left side of plus into $t1.
    addi $t2, $0, -1
    mult $t1, $t2
    mflo $t1

    mult $s0, $s1        # Calculate left side of plus into $t1.
    mflo $t2

    add $s0, $t1, $t2    # Add both sides together.
    srl $s0, $s0, 7      # Shift Right, Result (134) is in register $s0.

    addi $v0, $0, 10
    syscall