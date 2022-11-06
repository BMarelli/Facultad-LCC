.text
  .global main
  main:
    movl $-1, %eax
    movl $2, %ecx
    imull %ecx

    movq $-1, %rcx
    salq $32, %rcx
    orq %rcx, %rax

    xorq %rax, %rax
    movw $-1, %ax
    movw $2, %cx
    mulw %cx

    sall $16, %edx
    orl %edx, %eax
    ret
