.data
  w: .word 0xaabb
  format2: .asciz "%p\n"
.text
  .global main
    main:
    movq $0x55, %rax
    movw $0xbeef, %ax
    movb $0xbb, %ah
    shlb $4, %ah
    notw %ax
    movb w, %al
    movq %rax, %rsi
    movq $format2, %rdi
    xorq %rax, %rax
    call printf
    ret
