.text
  .global main
  main:
    movl $1, %eax
    movl $1, %ecx
    sall $31, %eax
    sall $15, %ecx
    orl %ecx, %eax
    ret
