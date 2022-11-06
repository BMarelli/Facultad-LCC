.text

  # buscar_caracter(char* %rdi, char %rsi, unsigned long %rdx)
  .global buscar_caracter
  buscar_caracter:
    movq %rdx, %rcx
    movb %sil, %al
    xorq %r8, %r8
    cld
    repetir1:
      scasb
      je fin1
      incq %r8
      loop repetir1
      movq $-1, %rax
      ret

    fin1:
      movq %r8, %rax
      ret

  # comparar_cadenas(char* %rdi, char* %rsi, unsigned long %rdx)
  .global comparar_cadenas
  comparar_cadenas:
    movq %rdx, %rcx

    cld
    repetir2:
      cmpsb
      jne diferente
      loop repetir2
      movq $0, %rax
      ret

    diferente:
      decq %rsi
      decq %rdi

      cmpsb
      ja menor
      movq $1, %rax
      ret

    menor:
      movq $-1, %rax
      ret

  # comparar_cadenas(char* %rdi, char* %rsi, unsigned long %rdx, unsigned long %rcx)
  .global fuerza_bruta
    fuerza_bruta:
      movq %rsi, %r9

      movq %rcx, %r10

      subq %rcx, %rdx
      incq %rdx
      movq %rdx, %r11

      xorq %r12, %r12

    repetir3:
      movb (%rsi), %sil
      call buscar_caracter
      cmpq $-1, %rax
      je fin2

      movq %rax, %r13
      movq %rdi, %r14

      movq %r9, %rsi
      movq %r10, %rdx
      decq %rdi
      call comparar_cadenas
      cmpq $0, %rax
      je encontrado

      addq %r13, %r12
      incq %r12

      movq %r14, %rdi
      movq %r9, %rsi
      movq %r11, %rdx
      subq %r13, %rdx
      movq %rdx, %r11
      jmp repetir3

    encontrado:
      addq %r12, %r13
      movq %r13, %rax
      ret

    fin2:
      ret
