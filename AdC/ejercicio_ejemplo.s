.data
  format: .string "%p\n"

.text
  .global main
  main:
    movq %rsi, %r14
    movq %rdi, %rcx
    xorq %r12, %r12

  repite:
    movq $format, %rdi
    movq (%r14, %r12, 8), %rsi
    xorq %rax, %rax
    movq %rcx, %r13
    call printf
    movq %r13, %rcx
    incq %r12

    loop repite
    ret
