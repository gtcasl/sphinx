#include <cash.h>
#include <ioport.h>
#include "define.h"

// __inout(decode_io, (
// 	__out(ch_bit<7>) out_opcode,
// 	__out(ch_bit<5>) out_rd,
// 	__out(ch_bit<5>) out_rs1,
// 	__out(ch_bit<32>) out_rd1,
// 	__out(ch_bit<5>) out_rs2,
// 	__out(ch_bit<32>) out_rd2,
// 	__out(ch_bit<1>) out_wb,
// 	__out(ch_bit<4>) out_alu_op,
// 	__out(ch_bit2)   out_PC_next
// ));

// using namespace ch::logic;
// using namespace ch::system;


struct D_E_Register
{
	__io(
		__in(ch_bit<5>)  in_rd,
		__in(ch_bit<5>)  in_rs1,
		__in(ch_bit<32>) in_rd1,
		__in(ch_bit<5>)  in_rs2,
		__in(ch_bit<32>) in_rd2,
		__in(ch_bit<4>)  in_alu_op,
		__in(ch_bit<2>)  in_wb,
		__in(ch_bit<1>)  in_rs2_src, // NEW
		__in(ch_bit<32>) in_itype_immed, // new
		__in(ch_bit<3>)  in_mem_read, // NEW
		__in(ch_bit<3>)  in_mem_write,
		__in(ch_bit<32>) in_PC_next,
		__in(ch_bit<3>)  in_branch_type,
		__in(ch_bit<1>)  in_fwd_stall,
		__in(ch_bit<1>)  in_branch_stall,
		__in(ch_bit<20>) in_upper_immed,
		__in(ch_bit<12>) in_csr_address, // done
		__in(ch_bit<1>)  in_is_csr, // done
		// __in(ch_bit<32>) in_csr_data, // done
		__in(ch_bit<32>) in_csr_mask, // done
		__in(ch_bit<32>) in_curr_PC,
		__in(ch_bit<1>)  in_jal,
		__in(ch_bit<32>) in_jal_offset,


         // (ch_flip_io<decode_io>) in,
		__out(ch_bit<12>) out_csr_address, // done
		__out(ch_bit<1>)  out_is_csr, // done
		// __out(ch_bit<32>) out_csr_data, // done
		__out(ch_bit<32>) out_csr_mask, // done
		__out(ch_bit<5>)  out_rd,
		__out(ch_bit<5>)  out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<5>)  out_rs2,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<4>)  out_alu_op,
		__out(ch_bit<2>)  out_wb,
		__out(ch_bit<1>)  out_rs2_src, // NEW
		__out(ch_bit<32>) out_itype_immed, // new
		__out(ch_bit<3>)  out_mem_read,
		__out(ch_bit<3>)  out_mem_write,
		__out(ch_bit<3>)  out_branch_type,
		__out(ch_bit<20>) out_upper_immed,
		__out(ch_bit<32>) out_curr_PC,
		__out(ch_bit<1>)  out_jal,
		__out(ch_bit<32>) out_jal_offset,
		__out(ch_bit<32>) out_PC_next
	);

	void describe()
	{

		ch_reg<ch_bit<5>>  rd(0);
		ch_reg<ch_bit<5>>  rs1(0);
		ch_reg<ch_bit<32>> rd1(0);
		ch_reg<ch_bit<5>>  rs2(0);
		ch_reg<ch_bit<32>> rd2(0);
		ch_reg<ch_bit<4>>  alu_op(0);
		ch_reg<ch_bit<2>>  wb(NO_WB_int);
		ch_reg<ch_bit<32>> PC_next_out(0);
		ch_reg<ch_bit<1>>  rs2_src(0);
		ch_reg<ch_bit<32>> itype_immed(0);
		ch_reg<ch_bit<3>>  mem_read(NO_MEM_READ_int);
		ch_reg<ch_bit<3>>  mem_write(NO_MEM_WRITE_int);
		ch_reg<ch_bit<3>>  branch_type(NO_BRANCH_int);
		ch_reg<ch_bit<20>> upper_immed(0);
		ch_reg<ch_bit<12>> csr_address(0);
		ch_reg<ch_bit<1>>  is_csr(0);
		// ch_reg<ch_bit<32>> csr_data(0);
		ch_reg<ch_bit<32>> csr_mask(0);
		ch_reg<ch_bit<32>> curr_PC(0);
		ch_reg<ch_bit<1>>  jal(NO_JUMP_int);
		ch_reg<ch_bit<32>> jal_offset(0);

		// rd->next          = io.in_rd;
		// rs1->next         = io.in_rs1;
		// rd1->next         = io.in_rd1;
		// rs2->next         = io.in_rs2;
		// rd2->next         = io.in_rd2;
		// alu_op->next      = io.in_alu_op;
		// wb->next          = io.in_wb;
		// PC_next_out->next = io.in_PC_next;
		// rs2_src->next     = io.in_rs2_src;
		// itype_immed->next = io.in_itype_immed;
		// mem_read->next    = io.in_mem_read;
		// mem_write->next   = io.in_mem_write;
		// branch_type->next = io.in_branch_type;

		ch_bool stalling = (io.in_fwd_stall == STALL) || (io.in_branch_stall == STALL);

		io.out_rd          = rd;
		io.out_rs1         = rs1;
		io.out_rd1         = rd1;
		io.out_rs2         = rs2;
		io.out_rd2         = rd2;
		io.out_alu_op      = alu_op;
		io.out_wb          = wb;
		io.out_PC_next     = PC_next_out;
		io.out_rs2_src     = rs2_src;
		io.out_itype_immed = itype_immed;
		io.out_mem_read    = mem_read;
		io.out_mem_write   = mem_write;
		io.out_branch_type = branch_type;
		io.out_upper_immed = upper_immed;
		io.out_csr_address = csr_address;
		io.out_is_csr      = is_csr;
		// io.out_csr_data    = csr_data;
		io.out_csr_mask    = csr_mask;
		io.out_jal         = jal;
		io.out_jal_offset  = jal_offset;
		io.out_curr_PC     = curr_PC;


		rd->next          = ch_sel(stalling, CH_ZERO(5)  , io.in_rd);
		rs1->next         = ch_sel(stalling, CH_ZERO(5)  , io.in_rs1);
		rd1->next         = ch_sel(stalling, CH_ZERO(32) , io.in_rd1);
		rs2->next         = ch_sel(stalling, CH_ZERO(5)  , io.in_rs2);
		rd2->next         = ch_sel(stalling, CH_ZERO(32) , io.in_rd2);
		alu_op->next      = ch_sel(stalling, NO_ALU      , io.in_alu_op);
		wb->next          = ch_sel(stalling, NO_WB       , io.in_wb);
		PC_next_out->next = ch_sel(stalling, CH_ZERO(32) , io.in_PC_next);
		rs2_src->next     = ch_sel(stalling, RS2_REG     , io.in_rs2_src);
		itype_immed->next = ch_sel(stalling, anything32  , io.in_itype_immed);
		mem_read->next    = ch_sel(stalling, NO_MEM_READ , io.in_mem_read);
		mem_write->next   = ch_sel(stalling, NO_MEM_WRITE, io.in_mem_write);
		branch_type->next = ch_sel(stalling, NO_BRANCH   , io.in_branch_type);
		upper_immed->next = ch_sel(stalling, CH_ZERO(20) , io.in_upper_immed);
		csr_address->next = ch_sel(stalling, CH_ZERO(12) , io.in_csr_address);
		is_csr->next      = ch_sel(stalling, CH_ZERO(1)  , io.in_is_csr);
		// csr_data->next    = ch_sel(stalling, CH_ZERO(32) , io.in_csr_data);
		csr_mask->next    = ch_sel(stalling, CH_ZERO(32) , io.in_csr_mask);
		jal->next         = ch_sel(stalling, NO_JUMP     , io.in_jal);
		jal_offset->next  = ch_sel(stalling, CH_ZERO(32) , io.in_jal_offset);
		curr_PC->next     = ch_sel(stalling, CH_ZERO(32) , io.in_curr_PC);


	}
};