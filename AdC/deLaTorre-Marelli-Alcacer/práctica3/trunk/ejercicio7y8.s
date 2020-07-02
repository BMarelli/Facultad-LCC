.text
  .global sum
  sum:
    movq %rdx, %rcx

    repetir:
        movss (%rdi), %xmm0
        movss (%rsi), %xmm1
        addss %xmm0, %xmm1
        movss %xmm1, (%rdi)
        addq $4, %rdi
        addq $4, %rsi
        loop repetir

    xorq %rax, %rax
    ret

  .global sum_simd
  sum_simd:
    movaps (%rdi), %xmm0
    movaps (%rsi), %xmm1
    addps %xmm0, %xmm1
    movaps %xmm1, (%rdi)

    xorq %rax, %rax
    ret
