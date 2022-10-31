#include "print.h"
#include "sbi.h"

extern void test();

int start_kernel() {
    puti(2022);
    puts(" ZJU Computer System II\n");

    test(); // DO NOT DELETE !!!

	return 0;
}
