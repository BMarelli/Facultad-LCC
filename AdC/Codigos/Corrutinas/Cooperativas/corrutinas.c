#include "guindows.h"
#include <stdio.h>

static task t1, t2, taskmain;

static void ft1(void)
{
    for (double d = -1; ; d += 0.001) {
        printf("d=%f\n", d);
        TRANSFER(t1, t2);
    }
}

static void ft2(void)
{
    for (unsigned i = 0; i < 10000; i++) {
        printf("i=%u\n", i);
        TRANSFER(t2, t1);
    }
    TRANSFER(t2, taskmain);
}

int main(void)
{
    stack(t1, ft1);
    stack(t2, ft2);
    TRANSFER(taskmain, t1);
    return 0;
}
