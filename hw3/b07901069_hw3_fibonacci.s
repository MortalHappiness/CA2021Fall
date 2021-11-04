.globl __start

.text
__start:
    li a0, 5
    ecall
    jal fibonacci
    mv s0, a0
    j output

fibonacci:
    addi sp, sp, -24
    sw ra, 16(sp)
    sw s0, 8(sp)
    sw s1, 0(sp)
    li t0, 1
    ble a0, t0, fibonacci_return
    mv s0, a0
    addi a0, s0, -1
    jal ra, fibonacci
    mv s1, a0
    addi a0, s0, -2
    jal ra, fibonacci
    add a0, s1, a0
    lw ra, 16(sp)
    lw s0, 8(sp)
    lw s1, 0(sp)
fibonacci_return:
    addi sp, sp, 24
    ret

output:
    li a0, 1
    mv a1, s0
    ecall

exit:
    li a0, 10
    ecall