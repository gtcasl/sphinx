#pragma once

#include "buses.h"
#include "d_e_register.h"
#include "decode.h"
#include "define.h"
#include "e_m_register.h"
#include "execute.h"
#include "f_d_register.h"
#include "fetch.h"
#include "forwarding.h"
#include "m_w_register.h"
#include "memory.h"
#include "util.h"
#include "write_back.h"

// Handlers
#include "csr_handler.h"
#include "interrupt_handler.h"

// JTAG
#include "JTAG/jtag.h"

struct Pipeline {
  __io (
    (IBUS_io)IBUS,
    (DBUS_io)DBUS,
    (INTERRUPT_io)INTERRUPT,
    (JTAG_io)jtag,
    __in(ch_bool) in_debug,
    __out(ch_bool) out_fwd_stall,    // DInst counting
    __out(ch_bool) out_branch_stall  // DInst counting
  );

  void describe() {
// DYNAMIC INSTRUCTION COUNTING:
#ifdef BRANCH_WB
    io.out_branch_stall = decode.io.out_branch_stall ||
                          execute.io.out_branch_stall ||
                          memory.io.out_branch_stall;
#else
    io.out_branch_stall =
        decode.io.out_branch_stall || execute.io.out_branch_stall;
#endif
    io.out_fwd_stall = forwarding.io.out_fwd_stall;

    // IBUS I/O
    fetch.io.IBUS(io.IBUS);
    fetch.io.in_debug(io.in_debug);
    // DBUS I/O
    memory.io.DBUS(io.DBUS);

    // JTAG I/O
    jtag_handler.io.JTAG(io.jtag);

    // Interrupt I/O
    interrupt_handler.io.INTERRUPT(io.INTERRUPT);

    // interrupt handler to FETCH
    fetch.io.in_interrupt(interrupt_handler.io.out_interrupt);
    fetch.io.in_interrupt_pc(interrupt_handler.io.out_interrupt_pc);

// EXE TO FETCH
#ifdef BRANCH_WB
    m_w_register.io.in_branch_dir(memory.io.out_branch_dir);
    m_w_register.io.in_branch_dest(memory.io.out_branch_dest);

    fetch.io.in_branch_dir(m_w_register.io.out_branch_dir);
    fetch.io.in_branch_dest(m_w_register.io.out_branch_dest);
#else
    fetch.io.in_branch_dir(memory.io.out_branch_dir);
    fetch.io.in_branch_dest(memory.io.out_branch_dest);
#endif

// DECODE TO FETCH
#ifdef JAL_MEM
    e_m_register.io.in_jal(execute.io.out_jal);
    e_m_register.io.in_jal_dest(execute.io.out_jal_dest);
    fetch.io.in_jal(e_m_register.io.out_jal);
    fetch.io.in_jal_dest(e_m_register.io.out_jal_dest);
#else
    fetch.io.in_jal(execute.io.out_jal);
    fetch.io.in_jal_dest(execute.io.out_jal_dest);
#endif

    // fetch TO f_d_register
    f_d_register.io.in_instruction(fetch.io.out_instruction);
    // f_d_register.io.in_PC_next(fetch.io.out_PC_next);
    f_d_register.io.in_curr_PC(fetch.io.out_curr_PC);

    // f_d_register to decode
    decode.io.in_instruction(f_d_register.io.out_instruction);
    // decode.io.in_PC_next(f_d_register.io.out_PC_next);
    decode.io.in_curr_PC(f_d_register.io.out_curr_PC);

    // decode.io.in_csr_data(csr_handler.io.out_decode_csr_data);

    // CSR HANDLER
    csr_handler.io.in_decode_csr_address(decode.io.out_csr_address);
    csr_handler.io.in_mem_csr_address(e_m_register.io.out_csr_address);
    csr_handler.io.in_mem_is_csr(e_m_register.io.out_is_csr);
    csr_handler.io.in_mem_csr_result(e_m_register.io.out_csr_result);

    // decode to d_e_register
    d_e_register.io.in_rd(decode.io.out_rd);
    d_e_register.io.in_rs1(decode.io.out_rs1);
    d_e_register.io.in_rd1(decode.io.out_rd1);
    d_e_register.io.in_rs2(decode.io.out_rs2);
    d_e_register.io.in_rd2(decode.io.out_rd2);
    d_e_register.io.in_alu_op(decode.io.out_alu_op);
    d_e_register.io.in_PC_next(decode.io.out_PC_next);
    d_e_register.io.in_rs2_src(decode.io.out_rs2_src);
    d_e_register.io.in_itype_immed(decode.io.out_itype_immed);
    d_e_register.io.in_wb(decode.io.out_wb);
    d_e_register.io.in_mem_read(decode.io.out_mem_read);
    d_e_register.io.in_mem_write(decode.io.out_mem_write);
    d_e_register.io.in_branch_type(decode.io.out_branch_type);  // branch type
    d_e_register.io.in_upper_immed(decode.io.out_upper_immed);
    d_e_register.io.in_csr_address(decode.io.out_csr_address);
    d_e_register.io.in_is_csr(decode.io.out_is_csr);
    // d_e_register.io.in_csr_data(decode.io.out_csr_data);
    d_e_register.io.in_csr_mask(decode.io.out_csr_mask);
    d_e_register.io.in_jal(decode.io.out_jal);
    d_e_register.io.in_jal_offset(decode.io.out_jal_offset);
    d_e_register.io.in_curr_PC(f_d_register.io.out_curr_PC);
    // d_e_register.io(decode.io);

    // Decode to f_d_register
    f_d_register.io.in_branch_stall = decode.io.out_branch_stall;
    // Decode to FETCH
    fetch.io.in_branch_stall = decode.io.out_branch_stall;

    // d_e_register to execute
    execute.io.in_rd(d_e_register.io.out_rd);
    execute.io.in_rs1(d_e_register.io.out_rs1);
    execute.io.in_rd1(d_e_register.io.out_rd1);
    execute.io.in_rs2(d_e_register.io.out_rs2);
    execute.io.in_rd2(d_e_register.io.out_rd2);
    execute.io.in_alu_op(d_e_register.io.out_alu_op);
    execute.io.in_PC_next(d_e_register.io.out_PC_next);
    execute.io.in_rs2_src(d_e_register.io.out_rs2_src);
    execute.io.in_itype_immed(d_e_register.io.out_itype_immed);
    execute.io.in_wb(d_e_register.io.out_wb);
    execute.io.in_mem_read(d_e_register.io.out_mem_read);
    execute.io.in_mem_write(d_e_register.io.out_mem_write);
    execute.io.in_branch_type(d_e_register.io.out_branch_type);
    execute.io.in_upper_immed(d_e_register.io.out_upper_immed);
    execute.io.in_csr_address(d_e_register.io.out_csr_address);
    execute.io.in_is_csr(d_e_register.io.out_is_csr);
    // execute.io.in_csr_data(d_e_register.io.out_csr_data);
    execute.io.in_csr_data(csr_handler.io.out_decode_csr_data);
    execute.io.in_csr_mask(d_e_register.io.out_csr_mask);
    execute.io.in_jal(d_e_register.io.out_jal);
    execute.io.in_jal_offset(d_e_register.io.out_jal_offset);
    execute.io.in_curr_PC(d_e_register.io.out_curr_PC);

    // execute to e_m_register
    e_m_register.io.in_alu_result(execute.io.out_alu_result);
    e_m_register.io.in_rd(execute.io.out_rd);
    e_m_register.io.in_rs1(execute.io.out_rs1);
    e_m_register.io.in_rs2(execute.io.out_rs2);
    e_m_register.io.in_rd1(execute.io.out_rd1);
    e_m_register.io.in_rd2(execute.io.out_rd2);
    e_m_register.io.in_PC_next(execute.io.out_PC_next);
    e_m_register.io.in_wb(execute.io.out_wb);
    e_m_register.io.in_mem_read(execute.io.out_mem_read);
    e_m_register.io.in_mem_write(execute.io.out_mem_write);
    e_m_register.io.in_csr_address(execute.io.out_csr_address);
    e_m_register.io.in_is_csr(execute.io.out_is_csr);
    e_m_register.io.in_csr_result(execute.io.out_csr_result);
    e_m_register.io.in_curr_PC(d_e_register.io.out_curr_PC);
    e_m_register.io.in_branch_type(d_e_register.io.out_branch_type);
    e_m_register.io.in_branch_offset(execute.io.out_branch_offset);

    // e_m_regsiter to memory
    memory.io.in_alu_result(e_m_register.io.out_alu_result);
    memory.io.in_rd(e_m_register.io.out_rd);
    memory.io.in_rs1(e_m_register.io.out_rs1);
    memory.io.in_rd1(e_m_register.io.out_rd1);
    memory.io.in_rs2(e_m_register.io.out_rs2);
    memory.io.in_rd2(e_m_register.io.out_rd2);
    memory.io.in_PC_next(e_m_register.io.out_PC_next);
    memory.io.in_wb(e_m_register.io.out_wb);
    memory.io.in_mem_read(e_m_register.io.out_mem_read);
    memory.io.in_mem_write(e_m_register.io.out_mem_write);
    memory.io.in_curr_PC(e_m_register.io.out_curr_PC);
    memory.io.in_branch_offset(e_m_register.io.out_branch_offset);
    memory.io.in_branch_type(e_m_register.io.out_branch_type);

    // memory to m_w_register
    m_w_register.io.in_alu_result(memory.io.out_alu_result);
    m_w_register.io.in_mem_result(memory.io.out_mem_result);
    m_w_register.io.in_rd(memory.io.out_rd);
    m_w_register.io.in_rs1(memory.io.out_rs1);
    m_w_register.io.in_rs2(memory.io.out_rs2);
    m_w_register.io.in_PC_next(memory.io.out_PC_next);
    m_w_register.io.in_wb(memory.io.out_wb);

    // m_w_register to write_back
    write_back.io.in_alu_result(m_w_register.io.out_alu_result);
    write_back.io.in_rd(m_w_register.io.out_rd);
    write_back.io.in_rs1(m_w_register.io.out_rs1);
    write_back.io.in_rs2(m_w_register.io.out_rs2);
    write_back.io.in_PC_next(m_w_register.io.out_PC_next);
    write_back.io.in_wb(m_w_register.io.out_wb);
    write_back.io.in_mem_result(m_w_register.io.out_mem_result);

    // write_back to decode
    decode.io.in_write_data(write_back.io.out_write_data);
    decode.io.in_rd(write_back.io.out_rd);
    decode.io.in_wb(write_back.io.out_wb);

    // Forwarding unit
    forwarding.io.in_decode_src1(decode.io.out_rs1);
    forwarding.io.in_decode_src2(decode.io.out_rs2);
    forwarding.io.in_decode_csr_address(decode.io.out_csr_address);

    forwarding.io.in_execute_dest(execute.io.out_rd);
    forwarding.io.in_execute_wb(execute.io.out_wb);
    forwarding.io.in_execute_alu_result(execute.io.out_alu_result);
    forwarding.io.in_execute_PC_next(execute.io.out_PC_next);
    forwarding.io.in_execute_is_csr(execute.io.out_is_csr);
    forwarding.io.in_execute_csr_address(execute.io.out_csr_address);
    forwarding.io.in_execute_csr_result(execute.io.out_csr_result);

    forwarding.io.in_memory_dest(memory.io.out_rd);
    forwarding.io.in_memory_wb(memory.io.out_wb);
    forwarding.io.in_memory_alu_result(memory.io.out_alu_result);
    forwarding.io.in_memory_mem_data(memory.io.out_mem_result);
    forwarding.io.in_memory_PC_next(memory.io.out_PC_next);
    forwarding.io.in_memory_is_csr(e_m_register.io.out_is_csr);
    forwarding.io.in_memory_csr_address(e_m_register.io.out_csr_address);
    forwarding.io.in_memory_csr_result(e_m_register.io.out_csr_result);

    forwarding.io.in_writeback_dest(m_w_register.io.out_rd);
    forwarding.io.in_writeback_wb(m_w_register.io.out_wb);
    forwarding.io.in_writeback_alu_result(m_w_register.io.out_alu_result);
    forwarding.io.in_writeback_mem_data(m_w_register.io.out_mem_result);
    forwarding.io.in_writeback_PC_next(m_w_register.io.out_PC_next);

#ifdef FORWARDING
    decode.io.in_src1_fwd(forwarding.io.out_src1_fwd);
    decode.io.in_src2_fwd(forwarding.io.out_src2_fwd);
    decode.io.in_csr_fwd(forwarding.io.out_csr_fwd);
    decode.io.in_src1_fwd_data(forwarding.io.out_src1_fwd_data);
    decode.io.in_src2_fwd_data(forwarding.io.out_src2_fwd_data);
    decode.io.in_csr_fwd_data(forwarding.io.out_csr_fwd_data);
#endif

#ifdef BRANCH_WB
    decode.io.in_stall =
        (execute.io.out_branch_stall == STALL) || memory.io.out_branch_stall;

    fetch.io.in_branch_stall_exe =
        execute.io.out_branch_stall || memory.io.out_branch_stall;
    f_d_register.io.in_branch_stall_exe =
        execute.io.out_branch_stall || memory.io.out_branch_stall;
    d_e_register.io.in_branch_stall =
        execute.io.out_branch_stall || memory.io.out_branch_stall;
#else
    decode.io.in_stall = (execute.io.out_branch_stall == STALL);

    fetch.io.in_branch_stall_exe = execute.io.out_branch_stall;
    f_d_register.io.in_branch_stall_exe = execute.io.out_branch_stall;
    d_e_register.io.in_branch_stall = execute.io.out_branch_stall;
#endif

    fetch.io.in_fwd_stall = forwarding.io.out_fwd_stall;
    f_d_register.io.in_fwd_stall = forwarding.io.out_fwd_stall;
    d_e_register.io.in_fwd_stall = forwarding.io.out_fwd_stall;

#ifdef CACHE_ENABLED

    f_d_register.io.in_freeze = fetch.io.out_delay || memory.io.out_delay;
    d_e_register.io.in_freeze = fetch.io.out_delay || memory.io.out_delay;
    e_m_register.io.in_freeze = fetch.io.out_delay || memory.io.out_delay;
    m_w_register.io.in_freeze = fetch.io.out_delay || memory.io.out_delay;
    fetch.io.in_freeze = memory.io.out_delay;

#else

    fetch.io.in_freeze = FALSE;

#endif
  }

  ch_module<Fetch> fetch;
  ch_module<F_D_Register> f_d_register;
  ch_module<Decode> decode;
  ch_module<D_E_Register> d_e_register;
  ch_module<Execute> execute;
  ch_module<E_M_Register> e_m_register;
  ch_module<Memory> memory;
  ch_module<M_W_Register> m_w_register;
  ch_module<Write_Back> write_back;
  ch_module<Forwarding> forwarding;
  ch_module<Interrupt_Handler> interrupt_handler;
  ch_module<JTAG> jtag_handler;
  ch_module<CSR_Handler> csr_handler;
};
