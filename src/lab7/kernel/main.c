#include "main.h"


task *current;
task *tasks[TASK_NUM];


// trap handler
void traps() {
    uint epc = csr_read(mepc);
    epc += 4;
    csr_write(mepc, epc);

#ifdef ADVANCE
    uint cause = csr_read(mcause);

    switch (cause) {
        case ILLEGAL_INST:
            asm("mv gp, %0" :: "r"(cause));
            break;
        case ECALL:
            schedule();
            for (int i = 0; i < TASK_NUM; i++) {
                if (current == tasks[i]) {
                    asm("addi gp, %0, 0x100" :: "r"(i));
                }
            }
            break;
    }
#else
    schedule();
    for (int i = 1; i < TASK_NUM; i++) {
                if (current == tasks[i]) {
                    asm("addi gp, %0, 0x100" :: "r"(i));
                }
            }
#endif
}


// the real worker process
void proc() {
    while (1) {
        switch (current->counter) {
#ifdef ADVANCE
            case 0x555:
                asm("unimp");
                break;
#endif
            case 0:
                asm("ecall");
                break;
        }

        if (current->counter)
            current->counter--;
    }
}

void switch_to(task *next) {
    if (current == next)
        return;
    _switch_to(&current, &next);
}



void init_tasks(void) {
    for (int i = 0; i < TASK_NUM; i++) {
        tasks[i] = (task *) (((int)&stack_top) + i * TASK_SIZE);
        tasks[i]->id = i;
        tasks[i]->counter = COUNTER_INIT;
        tasks[i]->thread.ra = (uint) &_mret;
        tasks[i]->thread.sp = (uint)(tasks[i]) + TASK_SIZE;
    }

    current = tasks[0];
    asm("mv sp, %0" :: "r"(current->thread.sp));
}


void schedule(void) {
    task *next = NULL;   // pointer to next task
    task **p;            // pointer to all tasks

    while (1) {
        int i = TASK_NUM;       // initialize i to the last pid
        p = &tasks[TASK_NUM];   // initialize p to the last task

        while (--i) {           // back traverse
            if(!*--p)
                continue;       // if NULL, skip
            if((*p)->counter) { // if counter > 0
                next=tasks[i];  // renew the switched-to task
            }
        }
        
        // if has valid next, break from the while loop
        // (if all counters are 0, then this will not happen)
        if (next)
            break;

        // else, refresh all counters
        for (int i = 1; i < TASK_NUM; i++)
            tasks[i]->counter = COUNTER_INIT;
    }

    switch_to(next);
}




int main() {
    init_tasks();
    proc();
    return 0;
}