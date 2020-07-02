.text
  .global main
  main:
    movl $0xAA, %eax
    movl $0xAA, %ecx
    sall $24, %eax
    orl %ecx, %eax
    ret
