export
CROSS_=riscv32-unknown-elf-
AR=${CROSS_}ar
GCC=${CROSS_}gcc
LD=${CROSS_}ld
OBJCOPY=${CROSS_}objcopy
OBJDUMP=${CROSS_}objdump

NAME=kernel
TARGET_DIR=build
ELF=${TARGET_DIR}/${NAME}.elf
BIN=${TARGET_DIR}/${NAME}.bin
DUMP=${TARGET_DIR}/${NAME}.dump
SIM=${TARGET_DIR}/sim.elf
COE=${TARGET_DIR}/${NAME}.coe

ISA ?= rv32im
ABI ?= ilp32

INCLUDE = -I ../include
CF = -O3 -march=$(ISA) -mabi=$(ABI) -mcmodel=medany -ffunction-sections -fdata-sections -nostartfiles -nostdlib -nostdinc -static -lgcc -Wl,--nmagic -Wl,--gc-sections -fno-tree-loop-distribute-patterns -fno-inline-small-functions -g -Wall -DADVANCE
CFLAG = ${CF} ${INCLUDE}

.PHONY: all clean

all:
	mkdir -p build
	make $(ELF)
	make $(BIN)
	make $(DUMP)
	make $(SIM)
	make $(COE)


build/head.o: head.S
	$(GCC) $(CFLAG) -c $^ -o $@

build/main.o: main.c
	$(GCC) $(CFLAG) -c $^ -o $@

$(ELF): kernel.lds build/head.o build/main.o
	$(LD) -T $^ -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $(ELF) $(BIN)

$(DUMP): $(ELF)
	$(OBJDUMP) -d $^ > $@

$(SIM): sim.lds build/head.o build/main.o
	$(LD) -T $^ -o $@

$(COE): $(BIN)
	od -t x4 -An -w1 -v $^ | sed -e 's/ //g' -e 's/$$/,/' > $@
	sed -i '1i memory_initialization_vector=' $@
	sed -i '1i memory_initialization_radix=16;' $@


clean:
	-@rm -rf build