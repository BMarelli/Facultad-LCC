.text
  .global main
  main:
    movl $-1, %eax
    movl $1, %ecx
    sall $8, %ecx
    notl %ecx
    andl %ecx, %eax
    ret
