.globl __start

.rodata
    division_by_zero: .string "division by zero"
    remainder_by_zero: .string "remainder by zero"
    jump_table: .word L0, L1, L2, L3, L4, L5, L6

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

###################################
#  TODO: Develop your calculator  #
#                                 #
###################################
# switch
blt s1, zero, exit # If op < 0, go to exit
li t0, 6
bgt s1, t0, exit # If op > 6, go to exit
la t0, jump_table
slli t1, s1, 2
add t0, t0, t1
lw t1, 0(t0)
jr t1

L0:
    add s3, s0, s2
    j output
L1:
    sub s3, s0, s2
    j output
L2:
    mul s3, s0, s2
    j output
L3:
    beq s2, zero, division_by_zero_except
    div s3, s0, s2
    j output
L4:
    beq s2, zero, remainder_by_zero_except
    rem s3, s0, s2
    j output
L5:
    li s3, 1
    j L5_loop_test_condition
    L5_loop:
        mul s3, s3, s0
        addi s2, s2, -1
    L5_loop_test_condition:
        bgt s2, zero, L5_loop
    j output
L6:
    li s3, 1
    j L6_loop_test_condition
    L6_loop:
        mul s3, s3, s0
        addi s0, s0, -1
    L6_loop_test_condition:
        bgt s0, zero, L6_loop

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit

remainder_by_zero_except:
    li a0, 4
    la a1, remainder_by_zero
    ecall
    jal zero, exit
