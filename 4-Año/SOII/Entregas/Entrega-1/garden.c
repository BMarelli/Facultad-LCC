#include "guindows.h"
#include <stdbool.h>
#include <stdio.h>

#define ITERS_PER_TURNSTILE  20

static task t1, t2, tmain, tsched;
static bool t1_done, t2_done;
static unsigned count;

static void ftsched(void)
{
    static unsigned i;
    for (;;) {
        if (i++ % 2 != 0 && !t1_done) {
            ACTIVATE(t1);
        } else if (!t2_done) {
            ACTIVATE(t2);
        } else {
            ACTIVATE(tmain);
        }
    }
}

static void ft1(void)
{
    for (unsigned i = 0; i < ITERS_PER_TURNSTILE; i++) {
        unsigned c = count;
        //YIELD(t1);
        count = c + 1;
        YIELD(t1);
    }
    t1_done = true;
    YIELD(t1);
}

static void ft2(void)
{
    for (unsigned i = 0; i < ITERS_PER_TURNSTILE; i++) {
        unsigned c = count;
        //YIELD(t2);
        count = c + 1;
        YIELD(t2);
    }
    t2_done = true;
    YIELD(t2);
}

int main(void)
{
    stack(t1, ft1);
    stack(t2, ft2);
    stack(tsched, ftsched);
    TRANSFER(tmain, tsched);
    printf("Total count: %u (should be %u)\n",
           count, 2 * ITERS_PER_TURNSTILE);
    return 0;
}
