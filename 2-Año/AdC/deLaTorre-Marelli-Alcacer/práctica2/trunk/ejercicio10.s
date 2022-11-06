.text
  .global setjmp2
  # setjmp2(jmp_buf %rdi)
  setjmp2:
    # callee saved: rbp, rbx, r12, r13, r14, r15.
    movq %rbp, 8(%rdi)
    movq %rbx, 16(%rdi)
    movq %r12, 24(%rdi)
    movq %r13, 32(%rdi)
    movq %r14, 40(%rdi)
    movq %r15, 48(%rdi)

    # stack pointer
    movq %rsp, 56(%rdi)
    addq $8, 56(%rdi)

    # return address
    movq (%rsp), %r8
    movq %r8, 64(%rdi)

    xorq %rax, %rax
    ret

  .global longjmp2
  # longjmp2(jmp_buf %rdi, unsigned long %rsi)
  longjmp2:
    # restauramos callee saved
    movq 8(%rdi), %rbp
    movq 16(%rdi), %rbx
    movq 24(%rdi), %r12
    movq 32(%rdi), %r13
    movq 40(%rdi), %r14
    movq 48(%rdi), %r15

    # restauramos stack pointer
    movq 56(%rdi), %rsp

    # restauramos return address
    movq 64(%rdi), %rdi

    # retorno de setjmp2
    movq %rsi, %rax

    jmp *%rdi


