.data
  format: .asciz "%ld\n"
  format2: .asciz "%p\n"
  i: .quad 0xDEADBEEF

.text
  .global main
    main:
    movq $format, %rdi
    movq $1234, %rsi
    xorq %rax, %rax
    call printf

    # (a)
    movq $format, %rdi
    movq %rsp, %rsi
    xorq %rax, %rax
    call printf

    # (b)
    movq $format, %rdi
    leaq format, %rsi
    xorq %rax, %rax
    call printf

    # (c)
    movq $format2, %rdi
    leaq format, %rsi
    xorq %rax, %rax
    call printf

    # (d)
    movq $format, %rdi
    movq (%rsp), %rsi
    xorq %rax, %rax
    call printf

    # (e)
    movq $format, %rdi
    movq 8(%rsp), %rsi
    xorq %rax, %rax
    call printf

    # (f)
    movq $format2, %rdi
    movq i, %rsi
    xorq %rax, %rax
    call printf

    # (g)
    movq $format2, %rdi
    leaq i, %rsi
    xorq %rax, %rax
    call printf

    xorq %rax, %rax
    ret
