#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;


const std::string& init_file = "../traces/rv32ui-p-andi.hex";

struct Fetch
{
	__io(
		__in(ch_bit<32>) in_din,
		__in(ch_bool) in_push,
		__in(ch_bit<1>) in_branch_dir,
		__in(ch_bit<32>) in_branch_dest,
		__in(ch_bit<1>) in_branch_stall,
		__in(ch_bit<1>) in_fwd_stall,
		__in(ch_bit<1>) in_jal,
		__in(ch_bit<32>) in_jal_dest,
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>) out_PC,
		__out(ch_bit<32>)  out_PC_next
	);

	void describe()
	{

		ch_reg<ch_bit<32>> PC(0); // 10364
		ch_bool stall = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL);
		
		io.out_instruction = ch_sel(stall || io.in_push, CH_ZERO(32), io.in_din);


		io.out_PC = ch_sel(io.in_jal == JUMP_int, io.in_jal_dest, ch_sel(io.in_branch_dir.as_uint() == TAKEN_int, io.in_branch_dest, PC.as_uint()));

		io.out_PC_next = io.out_PC.as_uint() + 4;

		// ch_rom<ch_bit<32>, 4096> mem(init_file);


		//ch_print("DIR: {0}\tDEST{1}",io.in_branch_dir, io.in_branch_dest);
		//ch_print("STALL: {0}", io.in_branch_stall);

		// io.out_PC_next = PC.as_uint();

		// io.out_PC = ch_sel(io.in_branch_dir.as_uint() == 1, io.in_branch_dest, PC.as_uint());
		// io.out_PC_next = ch_sel(io.in_branch_dir.as_uint() == 1, io.in_branch_dest.as_uint() + 1, PC.as_uint() + 1);
		// PC->next       = ch_sel(io.in_branch_dir.as_uint() == 1, io.in_branch_dest.as_uint() + 1, PC.as_uint() + 1);
		
		PC->next       = ch_sel(io.in_push, io.in_din, ch_sel(stall, io.out_PC, io.out_PC_next));
	}

};

