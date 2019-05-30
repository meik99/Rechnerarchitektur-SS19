.data
str: .asciiz " this     is a   string! "

.globl main

.text

main:
	la   $a0, str
    jal  titlecase
    add  $s0, $v0, $0
    addi $v0, $0, 10
    syscall

titlecase:
    addi $sp, $sp, -4
	sw   $fp, 0($sp)
	addi $fp, $sp, 4

    addi $t0, $0, 0 
    addi $t1, $0, 1
loop:
    lb   $t2, 0($a0)
	beq  $t2, $0, end_loop
    beq  $t1, $0, else1
    slti $t3, $t2, 97
    bne  $t3, $0, else1
    slti $t3, $t2, 123
    beq  $t3, $0, else1
    addi $t2, $t2, -32
    sb   $t2, 0($a0)
    addi $t1, $0, 0
    j    endif1
else1:
    addi $t3, $0, 32
    bne  $t2, $t3, else2
    addi $t0, $t0, 1
    sub  $t0, $t0, $t1
    addi $t1, $0, 1
    j endif1
else2:
    addi $t1, $0, 0 
endif1:
    addi $a0, $a0, 1
    j    loop
end_loop:
    addi $t0, $t0, 1
    sub  $v0, $t0, $t1
    lw   $fp, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
