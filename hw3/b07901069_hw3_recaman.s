.globl __start

.data
    seq: .zero 804
    seq_len: .word 0

.text
__start:
    li a0, 5
    ecall
    jal recaman
    mv s0, a0
    j output

recaman:
    addi sp, sp, -24
    sw ra, 16(sp)
    sw s0, 8(sp)
    sw s1, 0(sp)
    beq a0, zero, recaman_add_to_seq
    mv s0, a0
    addi a0, a0, -1
    jal ra, recaman
    sub t0, a0, s0
    add t1, a0, s0
    ble t0, zero, recaman_else
    la t2, seq
    la t3, seq_len
    lw t3, 0(t3)
    li t4, 0
    j recaman_for_test_condition
recaman_for:
    slli t5, t4, 2
    add t5, t2, t5
    lw t5, 0(t5)
    bne t5, t0, recaman_for_else
    mv a0, t1
    j recaman_add_to_seq
recaman_for_else:
    addi t4, t4, 1
recaman_for_test_condition:
    blt t4, t3, recaman_for
    mv a0, t0
    j recaman_add_to_seq
recaman_else:
    mv a0, t1
recaman_add_to_seq:
    la t0, seq
    la t1, seq_len
    lw t2, 0(t1)
    slli t3, t2, 2
    add t3, t0, t3
    sw a0, 0(t3)
    addi t2, t2, 1
    sw t2, 0(t1)
    lw ra, 16(sp)
    lw s0, 8(sp)
    lw s1, 0(sp)
    addi sp, sp, 24
    ret

output:
    li a0, 1
    mv a1, s0
    ecall

exit:
    li a0, 10
    ecall