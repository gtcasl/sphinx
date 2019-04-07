#pragma once

#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::logic;
using namespace ch::system;


struct F_D_Register
{
	__io(
		__in(ch_bit<32>)  in_instruction,
		// __in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<32>)  in_curr_PC,
		__in(ch_bit<1>)   in_branch_stall,
		__in(ch_bit<1>)   in_branch_stall_exe,
		__in(ch_bit<1>)   in_fwd_stall,
		#ifdef CACHE_ENABLED
		__in(ch_bool)     in_freeze,
		#endif
		
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>) out_curr_PC
		// __out(ch_bit<32>) out_PC_next


	);

	void describe()
	{

		ch_reg<ch_bit<32>> instruction(0);
		// ch_reg<ch_bit<32>> PC_next(0);
		ch_reg<ch_bit<32>> curr_PC(0);


		ch_bool stall = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL) || (io.in_branch_stall_exe == STALL);

		io.out_instruction = instruction;
		// io.out_PC_next     = PC_next;
		io.out_curr_PC     = curr_PC;

		#ifdef CACHE_ENABLED
		__if((io.in_fwd_stall == NO_STALL) && !io.in_freeze)
		#else
		__if(io.in_fwd_stall == NO_STALL)
		#endif
		{
			instruction->next  = io.in_instruction;
			// PC_next->next      = io.in_PC_next;
			curr_PC->next      = io.in_curr_PC;
		};


	}
};
