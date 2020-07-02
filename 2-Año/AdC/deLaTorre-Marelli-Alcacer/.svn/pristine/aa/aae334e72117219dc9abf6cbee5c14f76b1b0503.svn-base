#if !defined(__GUINDOWS_H__)
#define __GUINDOWS_H__

#include <setjmp.h>

typedef jmp_buf task;

#define TRANSFER(o, d) (setjmp(o) == 0 ? (longjmp(d, 1), 0) : 0)

extern void stack(task, void (*pf)());

#endif  // __GUINDOWS_H__
