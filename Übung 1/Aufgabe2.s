.globl main

.data

.text

# $s0: sum
# $t0: i
# $t1: tmp-variable

main:
    #Initialize registers with zero
    addi    $s0 $zero   0
    addi    $t0 $zero   0
    addi    $t1 $zero   0

loop:
    slti    $t1 $t0     100     #If t0 < 100: t1 = 1; else t1 = 0
    beq     $t1 $zero   exit    #If t1 == 0 => t0 >= 100 => jump to exit

ifIModThree:
    addi    $t1 $zero   3       #Set tmp = 3
    div     $t0 $t1             # i / tmp
    mfhi    $t1
    beq     $t1 $zero   addIToSum   # i % 3 == 0 is true

ifIModFive:
    addi    $t1 $zero   5       #Set tmp = 5
    div     $t0 $t1             # i / tmp
    mfhi    $t1
    beq     $t1 $zero   addIToSum   # i % 5 == 0 is true
    j       incI
    
addIToSum:
    add     $s0 $s0 $t0

incI:
    addi    $t0 $t0     1       #i++
    j   loop


exit:
    addi    $v0 $zero   10
    syscall

