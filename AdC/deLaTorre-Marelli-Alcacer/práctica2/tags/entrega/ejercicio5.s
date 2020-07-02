.text
  .global fact1
  fact1:
    cmpq $1, %rdi
    jbe devolver_caso_base
    pushq %rdi
    decq %rdi
    call fact1
    popq %rbx
    mulq %rbx
    ret
  devolver_caso_base:
    movq $1, %rax
    ret

  .global fact2
  fact2:
    movq $1, %rax
    movq %rdi, %rcx
    repetir:
      mulq %rdi
      decq %rdi
      loop repetir
    ret
