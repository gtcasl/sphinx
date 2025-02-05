#pragma once

#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::logic;
using namespace ch::system;

struct Execute {
  __io (
    __in(ch_bit<5>) in_rd,
    __in(ch_bit<5>) in_rs1,
    __in(ch_bit<32>) in_rd1,
    __in(ch_bit<5>) in_rs2,
    __in(ch_bit<32>) in_rd2,
    __in(ch_bit<4>) in_alu_op,
    __in(ch_bit<2>) in_wb,
    __in(ch_bit<1>) in_rs2_src,       // NEW
    __in(ch_bit<32>) in_itype_immed,  // new
    __in(ch_bit<3>) in_mem_read,      // NEW
    __in(ch_bit<3>) in_mem_write,     // NEW
    __in(ch_bit<32>) in_PC_next,
    __in(ch_bit<3>) in_branch_type,
    __in(ch_bit<20>) in_upper_immed,
    __in(ch_bit<12>) in_csr_address,  // done
    __in(ch_bit<1>) in_is_csr,        // done
    __in(ch_bit<32>) in_csr_data,     // done
    __in(ch_bit<32>) in_csr_mask,     // done
    __in(ch_bit<1>) in_jal,
    __in(ch_bit<32>) in_jal_offset,
    __in(ch_bit<32>) in_curr_PC,
    __out(ch_bit<12>) out_csr_address,
    __out(ch_bit<1>) out_is_csr,
    __out(ch_bit<32>) out_csr_result,
    __out(ch_bit<32>) out_alu_result,
    __out(ch_bit<5>) out_rd,
    __out(ch_bit<2>) out_wb,
    __out(ch_bit<5>) out_rs1,
    __out(ch_bit<32>) out_rd1,
    __out(ch_bit<5>) out_rs2,
    __out(ch_bit<32>) out_rd2,
    __out(ch_bit<3>) out_mem_read,
    __out(ch_bit<3>) out_mem_write,
    __out(ch_bit<1>) out_jal,
    __out(ch_bit<32>) out_jal_dest,
    __out(ch_bit<32>) out_branch_offset,
    __out(ch_bit<1>) out_branch_stall,
    __out(ch_bit<32>) out_PC_next
  );

  void describe() {
    // ch_println("****************");
    // ch_println("EXECUTE");
    // ch_println("****************");

    ch_bool which_in2 = io.in_rs2_src == RS2_IMMED_int;

    ch_bit<32> ALU_in1 = io.in_rd1;
    ch_bit<32> ALU_in2 = ch_sel(which_in2, io.in_itype_immed, io.in_rd2);

    ch_bit<32> upper_immed = ch_cat(io.in_upper_immed, CH_ZERO(12));

    io.out_jal_dest = io.in_rd1.as_int() + io.in_jal_offset.as_int();
    io.out_jal = io.in_jal;

    __switch (io.in_alu_op.as_uint())
    __case (ADD_int) {
      // ch_println("ADD_int");
      ch_int<32> temp = ALU_in1.as_int() + ALU_in2.as_int();
      io.out_alu_result = temp;
      io.out_csr_result = anything32;

      //ch_println("EXECUTE: {0} = {1} + {2}\t{3}", temp, ALU_in1, ALU_in2, io.in_curr_PC);
      //ch_println("ADD_int: Immediate: {0}, rs1_reg: {1}, rs2_reg#: {2}", io.in_itype_immed, io.in_rs1, io.in_rs2);
    }
    __case (SUB_int) {
      // ch_println("SUB_int");
      io.out_alu_result = ALU_in1.as_int() - ALU_in2.as_int();
      io.out_csr_result = anything32;
      // ch_println("SUB_int: {0} - {1} = {2}", ALU_in1, ALU_in2,
      // io.out_alu_result);
    }
    __case (SLLA_int) {
      // ch_println("SLLA_int");
      ch_bit<5> to_shift = ch_slice<5>(ALU_in2);
      io.out_alu_result = ALU_in1.as_uint() << to_shift.as_uint();
      io.out_csr_result = anything32;
    }
    __case (SLT_int) {
      // ch_println("SLT_int");
      io.out_alu_result = ch_sel(ALU_in1.as_int() < ALU_in2.as_int(),
                                 ch_bit<32>(1), ch_bit<32>(0));
      io.out_csr_result = anything32;
    }
    __case (SLTU_int) {
      // ch_println("SLTU_int");
      ch_uint<32> ALU_in1_int = ALU_in1.as_uint();
      ch_uint<32> ALU_in2_int = ALU_in2.as_uint();
      io.out_alu_result =
          ch_sel(ALU_in1_int < ALU_in2_int, ch_bit<32>(1), ch_bit<32>(0));
      io.out_csr_result = anything32;
      // ch_println("SLT: {0} < {1}? {2}", ALU_in1_int, ALU_in2_int,
      // io.out_alu_result);
    }
    __case (XOR_int) {
      // ch_println("XOR");
      io.out_alu_result = ALU_in1 ^ ALU_in2;
      io.out_csr_result = anything32;
    }
    __case (SRL_int) {
      // ch_println("SRL_int");
      ch_bit<5> to_shift = ch_slice<5>(ALU_in2);
      io.out_alu_result = ALU_in1.as_uint() >> to_shift.as_uint();
      io.out_csr_result = anything32;
    }
    __case (SRA_int) {
      // ch_println("SRA");
      ch_int32 ALU_in1_int = ALU_in1.as_int();
      ch_bit<5> to_shift = ch_slice<5>(ALU_in2);
      io.out_alu_result = ALU_in1_int >> to_shift.as_uint();
      io.out_csr_result = anything32;
      // ch_println("STA: {0} >> {1} = {2}", ALU_in1, ALU_in2, io.out_alu_result);
    }
    __case (OR_int) {
      // ch_println("OR");
      io.out_alu_result = ALU_in1 | ALU_in2;
      io.out_csr_result = anything32;
    }
    __case (AND_int) {
      // ch_println("AND");
      io.out_alu_result = ALU_in2 & ALU_in1;
      io.out_csr_result = anything32;
    }
    __case (SUBU_int) {
      __if (ALU_in1.as_uint() >= ALU_in2.as_uint()) { io.out_alu_result = 0x0; }
      __else { io.out_alu_result = 0xffffffff; };

      // io.out_alu_result = ALU_in1.as_uint() - ALU_in2.as_uint();
      io.out_csr_result = anything32;
    }
    __case (LUI_ALU_int) {
      // ch_println("LUI: {0} -------> {1}", io.in_upper_immed, upper_immed);
      io.out_alu_result = upper_immed;
      io.out_csr_result = anything32;
    }
    __case (AUIPC_ALU_int) {
      io.out_alu_result = io.in_curr_PC.as_int() + upper_immed.as_int();
      io.out_csr_result = anything32;
    }
    __case (CSR_ALU_RW_int) {
      io.out_alu_result = io.in_csr_data;
      io.out_csr_result = io.in_csr_mask;
    }
    __case (CSR_ALU_RS_int) {
      io.out_alu_result = io.in_csr_data;
      io.out_csr_result = io.in_csr_data | io.in_csr_mask;
    }
    __case (CSR_ALU_RC_int) {
      io.out_alu_result = io.in_csr_data;
      io.out_csr_result =
          io.in_csr_data & (0xFFFFFFFF - io.in_csr_mask.as_uint());
    }
    __default {
      // ch_println("INVALID ALU OP");
      io.out_alu_result = 0;
      io.out_csr_result = anything32;
    };

#ifdef JAL_MEM
    io.out_branch_stall =
        ch_sel((io.in_branch_type.as_uint() != NO_BRANCH_int) || io.in_jal,
               STALL, NO_STALL);
#else
    io.out_branch_stall =
        ch_sel(io.in_branch_type.as_uint() != NO_BRANCH_int, STALL, NO_STALL);
#endif

    io.out_rd = io.in_rd;
    io.out_wb = io.in_wb;
    io.out_mem_read = io.in_mem_read;
    io.out_mem_write = io.in_mem_write;
    io.out_rs1 = io.in_rs1;
    io.out_rd1 = io.in_rd1;
    io.out_rd2 = io.in_rd2;
    io.out_rs2 = io.in_rs2;
    io.out_PC_next = io.in_PC_next;
    io.out_is_csr = io.in_is_csr;
    io.out_csr_address = io.in_csr_address;
    io.out_branch_offset = io.in_itype_immed;
  }
};
