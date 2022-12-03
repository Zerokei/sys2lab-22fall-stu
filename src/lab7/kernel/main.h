#ifndef MAIN_H
#define MAIN_H


// common defines
#define NULL    0
typedef unsigned int uint;

// cause exception / interruption number
#define ILLEGAL_INST    2
#define ECALL           11




// task
#define TASK_NUM        3
#define TASK_SIZE       0x100
#define COUNTER_INIT    0x1000

struct tss_struct {
    uint ra;
    uint sp;
    uint s0;
    uint s1;
    uint s2;
    uint s3;
    uint s4;
    uint s5;
    uint s6;
    uint s7;
    uint s8;
    uint s9;
    uint s10;
    uint s11;
};

typedef struct tss_struct tss;

struct task_struct {
    int id;         // task id
    int counter;    // pseudo counter
    tss thread;     // task's tss
};



typedef struct task_struct task;


// macro operation for CSRs

#define csr_read(csr) ({ uint _v; \
    __asm__("csrr %0, " #csr : "=r"(_v)); _v; })

#define csr_write(csr, _v) ({ \
    __asm__("csrw " #csr ", %0" : :"rK"(_v)); })

#define csr_set(csr, _v) ({ \
    __asm__("csrs " #csr ", %0" : :"rK"(_v)); })

#define csr_clear(csr, _v) ({ \
    __asm__("csrc " #csr ", %0" : :"rK"(_v)); })


// global extern declaration
extern int stack_top;
extern void *_mret;

// function declaration
void traps();

void schedule();

void switch_to(task *next);

void init_tasks(void);

#endif