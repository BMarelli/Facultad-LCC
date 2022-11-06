.text
  .global fact1
  fact1:
    addi sp, sp, -16
    sd ra, (sp)

    li t1, 1
    beq a0, t1, final1
    sd a0, 8(sp)
    addi a0, a0, -1
    jal ra, fact1
    ld t0, 8(sp)
    mul a0, a0, t0
    final1:
      ld ra, (sp)
      addi sp, sp, 16
      ret

  .global fact2
  fact2:
    li t0, 1
    li t1, 1

    loop2:
      beq a0, t1, final2
      mul t0, t0, a0
      addi a0, a0, -1
      j loop2

    final2:
      mv a0, t0
      ret
