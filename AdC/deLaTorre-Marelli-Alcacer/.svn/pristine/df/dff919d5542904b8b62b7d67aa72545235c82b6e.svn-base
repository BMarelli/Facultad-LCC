.text
  .global main
    main:

    # (a)
    movq $0xADEADBEEF, %rax
    rorq $32, %rax

    movq $0xADEADBEEF, %rax
    rolq $32, %rax

    # (b)
    movq $0xADEADBEEF, %rax
    movq $64, %rcx
    xorq %rsi, %rsi
    repetir:
      rorq $1, %rax
      adcq $0, %rsi
      loop repetir

    movq %rsi, %rax
    ret
