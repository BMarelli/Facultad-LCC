.text
  .global rgb_to_gray1
  rgb_to_gray1:
    li t0, 0x0000ff
    and t0, a0, t0

    li t1, 0x00ff00
    and t1, a0, t1
    srli t1, t1, 8

    li t2, 0xff0000
    and t2, a0, t2
    srli t2, t2, 16

    add t1, t1, t2
    add t0, t0, t1
    li t1, 3
    div a0, t0, t1
    ret


  .global rgb_to_gray2
  rgb_to_gray2:
    li t3, 100
    li t4, 30
    li t5, 59
    li t6, 11

    li t0, 0x0000ff
    and t0, a0, t0
    mul t0, t0, t4
    div t0, t0, t3

    li t1, 0x00ff00
    and t1, a0, t1
    srli t1, t1, 8
    mul t1, t1, t5
    div t1, t1, t3

    li t2, 0xff0000
    and t2, a0, t2
    srli t2, t2, 16
    mul t2, t2, t6
    div t2, t2, t3

    add t1, t1, t2
    add t0, t0, t1
    li t1, 3
    div a0, t0, t1
    ret

  .global ycbcr_to_gray
  ycbcr_to_gray:
    li t0, 0x0000ff
    and a0, a0, t0
    ret

