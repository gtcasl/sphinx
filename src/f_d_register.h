#include <cash.h>
#include <ioport.h>
#include "define.h"

// using namespace ch::logic;
// using namespace ch::system;


struct F_D_Register
{
	__io(
		__in(ch_bit<32>)  in_instruction,
		__in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<32>)  in_curr_PC,
		__in(ch_bit<1>)   in_branch_stall,
		__in(ch_bit<1>)   in_branch_stall_exe,
		__in(ch_bit<1>)   in_fwd_stall,
		
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>) out_curr_PC,
		__out(ch_bit<32>) out_PC_next

	);

	void describe()
	{

		ch_reg<ch_bit<32>> instruction(0);
		ch_reg<ch_bit<32>> PC_next(0);
		ch_reg<ch_bit<32>> curr_PC(0);


		ch_bool stall = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL) || (io.in_branch_stall_exe == STALL);

		io.out_instruction = instruction;
		io.out_PC_next     = PC_next;
		io.out_curr_PC     = curr_PC;

		__if(io.in_fwd_stall == NO_STALL)
		{
			instruction->next  = io.in_instruction;
			PC_next->next      = io.in_PC_next;
			curr_PC->next      = io.in_curr_PC;
		} __else
		{
			// ch_print("STALLING F_D_Register");
			instruction->next = instruction.as_uint();
			PC_next->next     = PC_next.as_uint();
			curr_PC->next     = curr_PC.as_uint();
		};


	}
};