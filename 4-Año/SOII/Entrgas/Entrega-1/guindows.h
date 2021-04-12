#ifndef __GUINDOWS2_H
#define __GUINDOWS2_H

#include <setjmp.h>

typedef jmp_buf task;

#define TPILA  "4096"
#define CREATE_STACK(t, f)  do { if (setjmp(t)) f(); asm("subq $"TPILA", %rsp");} while (0)
#define DESTROY_STACK(t)  asm("addq $" TPILA ", %rsp")

#define TRANSFER(o, d)  (setjmp(o) == 0 ? (longjmp(d, 1), 0) : 0)
#define ACTIVATE(d)  TRANSFER(tsched, d)
#define YIELD(o)  TRANSFER(o, tsched)

extern void stack(task, void (*pf)());

#endif  // __GUINDOWS2_H
