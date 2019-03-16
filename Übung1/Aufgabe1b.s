# a = 0xcafebeef;
# b = 0xfeedfeed;
# y = (~a | ~b) ^ (a & b)

.globl main

.data
    x: .word 0xcafebeef     # Declare hex number a in data section.
    y: .word 0xfeedfeed     # Declare hex number b in data section.
.text
main:
    lw $s0, x               # Load a into $s0.
    lw $s1, y               # Load b into $s1.

    nor $t1, $s0, $0        # Calculate left side of XOR into $t1.
    nor $t2, $s1, $0
    or $t1, $t1, $t2

    and $t2, $s0, $s1       # Calculate right side of XOR into $t2.

    xor $s0, $t1, $t2       # XOR both sides and store result (-1) into $s0.

    addi $v0, $0, 10
    syscall