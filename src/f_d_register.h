#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;


struct F_D_Register
{
	__io(
		__in(ch_bit<32>) in_instruction,
		__in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<1>) in_branch_stall,
		__in(ch_bit<1>) in_fwd_stall,
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>) out_PC_next

	);

	void describe()
	{

		ch_reg<ch_bit<32>> instruction(0);
		ch_reg<ch_bit<32>> PC_next(0);

		ch_bool stall = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL);
		
		io.out_instruction = instruction;
		io.out_PC_next     = PC_next;


		instruction->next = ch_sel(stall, CH_ZERO(32), io.in_instruction);
		    PC_next->next = ch_sel(stall, CH_ZERO(32), io.in_PC_next);


	}
};