.data
  a: .float 1
  b: .float 5
  c: .float 0.5
  d: .float 4

.text
  .global main
  main:
    addi sp, sp, -16
    sd ra, (sp)

    la t0, a
    flw fa0, (t0)
    la t0, b
    flw fa1, (t0)
    la t0, c
    flw fa2, (t0)
    la t0, d
    flw fa3, (t0)

    call det # gdb-riscv: print $fa0 -> 1.5

    ld ra, (sp)
    addi sp, sp, 16
    ret

  .global det
  det:
    fmul.s fa0, fa0, fa3
    fmul.s fa1, fa1, fa2
    fsub.s fa0, fa0, fa1
    ret
