#   int arr[9] = {4, 8, 12, 11, 5, 21, 1, 99, 41};
#
#   int main() {
#       int sum = 0;
#       int *p = arr;
#       while(*p > 1) {
#           sum += *p;
#           p++;
#       }
#   // sum enthaelt das Ergebnis
#   }

.globl main

.data
    arr: .word 4, 8, 12, 11, 5, 21, 1, 99, 41   # Declare the source array with values.
.text
main:
    addi $s0, $0, 0         # Store the initial 0 sum into $s0 .
    la $t1, arr             # Load the address of the array into $t1.
    addi $t2, $0, 1         # Store the constant 1 into $t2.
  loop:
    lw $t3, 0($t1)          # Load element from current position of array in $t1 into $t3.
    slt $t4, $t2, $t3       # Check if $t3 > $t2 and store result into $t4.
    beq $t3, $t2, endloop   # If element is exactly 1 jump to end loop.
    beq $t4, $0, endloop    # If result from $t3 > $t2 is zero jump to end loop.

    add $s0, $s0, $t3       # Add the current element to the sum.

    addi $t1, $t1, 4        # Increase the address of the array by 4 bytes to point at next word.
    j loop                  # Jump back to loop.
  endloop:
    addi $v0, $0, 10        # Result sum is stored in $s0.
    syscall