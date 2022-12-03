# global configuration
.equ DATA_BYTES, 4
.equ CONTEXT_BYTES, DATA_BYTES * 32


# initial value
.equ MSTATUS_INIT, 0x1800

# tss offset
.equ TSS_OFFSET, 8




.global _start
_start:
    # set mstatus register
    li      a0, MSTATUS_INIT    # MPP = 11
    csrw    mstatus, a0

    # set machine trap vector
    la      t0, trap_handler
    csrw    mtvec, t0

    # call clear_bss
    jal     clear_bss

    la      sp, stack_top

    j       main  # jump to main
    

.global clear_bss
clear_bss:
    # load the address of bss sections space
    # including *bss_start* and *bss_end*
    la      t0, bss_start
    la      t1, bss_end

    # address reach the end of bss section
    # clear all done
1:  bgeu    t0, t1, 2f

    # put zero into the location
    sw      zero, 0(t0)
    addi    t0, t0, DATA_BYTES  # t0 = t0 + 4
    j       1b                  # jump back to the seeking loop

2:  ret




.global trap_handler
trap_handler:
    addi    sp, sp, -CONTEXT_BYTES
    sw      x0, 0(sp)
    sw      x1, 4(sp)
    sw      x2, 8(sp)
    sw      x4, 16(sp)
    sw      x5, 20(sp)
    sw      x6, 24(sp)
    sw      x7, 28(sp)
    sw      x8, 32(sp)
    sw      x9, 36(sp)
    sw      x10, 40(sp)
    sw      x11, 44(sp)
    sw      x12, 48(sp)
    sw      x13, 52(sp)
    sw      x14, 56(sp)
    sw      x15, 60(sp)
    sw      x16, 64(sp)
    sw      x17, 68(sp)
    sw      x18, 72(sp)
    sw      x19, 76(sp)
    sw      x20, 80(sp)
    sw      x21, 84(sp)
    sw      x22, 88(sp)
    sw      x23, 92(sp)
    sw      x24, 96(sp)
    sw      x25, 100(sp)
    sw      x26, 104(sp)
    sw      x27, 108(sp)
    sw      x28, 112(sp)
    sw      x29, 116(sp)
    sw      x30, 120(sp)
    sw      x31, 124(sp)

    jal     traps

    lw      x0, 0(sp)
    lw      x1, 4(sp)
    lw      x2, 8(sp)
    lw      x4, 16(sp)
    lw      x5, 20(sp)
    lw      x6, 24(sp)
    lw      x7, 28(sp)
    lw      x8, 32(sp)
    lw      x9, 36(sp)
    lw      x10, 40(sp)
    lw      x11, 44(sp)
    lw      x12, 48(sp)
    lw      x13, 52(sp)
    lw      x14, 56(sp)
    lw      x15, 60(sp)
    lw      x16, 64(sp)
    lw      x17, 68(sp)
    lw      x18, 72(sp)
    lw      x19, 76(sp)
    lw      x20, 80(sp)
    lw      x21, 84(sp)
    lw      x22, 88(sp)
    lw      x23, 92(sp)
    lw      x24, 96(sp)
    lw      x25, 100(sp)
    lw      x26, 104(sp)
    lw      x27, 108(sp)
    lw      x28, 112(sp)
    lw      x29, 116(sp)
    lw      x30, 120(sp)
    lw      x31, 124(sp)
    addi    sp, sp, CONTEXT_BYTES
    mret




.global _switch_to
_switch_to:
    lw      a2, 0(a0)
    lw      a3, 0(a1)
    addi    a2, a2, TSS_OFFSET
    addi    a3, a3, TSS_OFFSET

    sw      ra, 0(a2)
    sw      sp, 4(a2)
    sw      s0, 8(a2)
    sw      s1, 12(a2)
    sw      s2, 16(a2)
    sw      s3, 20(a2)
    sw      s4, 24(a2)
    sw      s5, 28(a2)
    sw      s6, 32(a2)
    sw      s7, 36(a2)
    sw      s8, 40(a2)
    sw      s9, 44(a2)
    sw      s10, 48(a2)
    sw      s11, 52(a2)

    lw      ra, 0(a3)
    lw      sp, 4(a3)
    lw      s0, 8(a3)
    lw      s1, 12(a3)
    lw      s2, 16(a3)
    lw      s3, 20(a3)
    lw      s4, 24(a3)
    lw      s5, 28(a3)
    lw      s6, 32(a3)
    lw      s7, 36(a3)
    lw      s8, 40(a3)
    lw      s9, 44(a3)
    lw      s10, 48(a3)
    lw      s11, 52(a3)

    lw  a2, 0(a1)
    sw  a2, 0(a0)

    ret

.global _mret
_mret:
    la      a0, proc
    csrw    mepc, a0
    mret