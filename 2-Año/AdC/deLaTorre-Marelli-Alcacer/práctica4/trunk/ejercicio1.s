.text
  .global _div
  _div:
    mv t0, a0
    li t1, 0

    loop:
      blt t0, a1, terminar
      sub t0, t0, a1
      addi t1, t1, 1
      j loop

    terminar:
      mv a0, t1
      ret

