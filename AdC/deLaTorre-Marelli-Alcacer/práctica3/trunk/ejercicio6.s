.text
  .global solve
  solve:
    movss %xmm0, %xmm7
    mulss %xmm4, %xmm7
    movss %xmm3, %xmm8
    mulss %xmm1, %xmm8
    ucomiss %xmm8, %xmm7
    jz determinante_nulo
    subss %xmm8, %xmm7

    movss %xmm2, %xmm6
    mulss %xmm4, %xmm6
    movss %xmm1, %xmm8
    mulss %xmm5, %xmm8
    subss %xmm8, %xmm6

    divss %xmm7, %xmm6
    movss %xmm6, (%rdi)

    movss %xmm0, %xmm6
    mulss %xmm5, %xmm6
    movss %xmm3, %xmm8
    mulss %xmm2, %xmm8
    subss %xmm8, %xmm6

    divss %xmm7, %xmm6
    movss %xmm6, (%rsi)
    ret

    determinante_nulo:
    movq $-1, %rax
    ret
