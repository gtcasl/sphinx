#pragma once

#include <cash.h>
#include <ioport.h>

using namespace ch::system;
using namespace ch::logic;

struct M_W_Register {
  __io (
    __in(ch_bit<32>) in_alu_result,
    __in(ch_bit<32>) in_mem_result,  // NEW
    __in(ch_bit<5>) in_rd,
    __in(ch_bit<2>) in_wb,
    __in(ch_bit<5>) in_rs1,
    __in(ch_bit<5>) in_rs2,
    __in(ch_bit<32>) in_PC_next,
#ifdef CACHE_ENABLED
    __in(ch_bool) in_freeze,
#endif
#ifdef BRANCH_WB
    __in(ch_bit<1>) in_branch_dir,
    __in(ch_bit<32>) in_branch_dest,
#endif
    __out(ch_bit<32>) out_alu_result,
    __out(ch_bit<32>) out_mem_result,  // NEW
    __out(ch_bit<5>) out_rd,
    __out(ch_bit<2>) out_wb,
    __out(ch_bit<5>) out_rs1,
    __out(ch_bit<5>) out_rs2,
#ifdef BRANCH_WB
    __out(ch_bit<1>) out_branch_dir,
    __out(ch_bit<32>) out_branch_dest,
#endif
    __out(ch_bit<32>) out_PC_next
  );

  void describe() {
    ch_reg<ch_bit<32>> alu_result(0);
    ch_reg<ch_bit<32>> mem_result(0);
    ch_reg<ch_bit<5>> rd(0);
    ch_reg<ch_bit<5>> rs1(0);
    ch_reg<ch_bit<5>> rs2(0);
    ch_reg<ch_bit<2>> wb(0);
    ch_reg<ch_bit<32>> PC_next(0);    
#ifdef BRANCH_WB
    ch_reg<ch_bit<1>> branch_dir(NOT_TAKEN_int);
    ch_reg<ch_bit<32>> branch_dest(0);
#endif
    io.out_alu_result = alu_result;
    io.out_mem_result = mem_result;
    io.out_rd = rd;
    io.out_rs1 = rs1;
    io.out_rs2 = rs2;
    io.out_wb = wb;
    io.out_PC_next = PC_next;    
#ifdef BRANCH_WB
    io.out_branch_dir = branch_dir;
    io.out_branch_dest = branch_dest;
#endif

#ifdef CACHE_ENABLED
    __if (!io.in_freeze) {
#endif
      alu_result->next = io.in_alu_result;
      mem_result->next = io.in_mem_result;
      rd->next = io.in_rd;
      rs1->next = io.in_rs1;
      rs2->next = io.in_rs2;
      wb->next = io.in_wb;
      PC_next->next = io.in_PC_next;      
#ifdef BRANCH_WB
      branch_dir->next = io.in_branch_dir;
      branch_dest->next = io.in_branch_dest;
#endif
#ifdef CACHE_ENABLED
    };
#endif
  }
};
