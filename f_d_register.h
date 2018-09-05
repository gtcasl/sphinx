#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct F_D_Register
{
	__io(
		__in(ch_bit<32>) in_instruction,
		__in(ch_bit<2>)  in_PC_next,
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<2>) out_PC_next

	);

	void describe()
	{

		ch_reg<ch_bit<32>> instruction(0);
		ch_reg<ch_bit<2>> PC_next(0);

		
		io.out_instruction = instruction;
		io.out_PC_next     = PC_next;

		instruction->next = io.in_instruction;
		    PC_next->next = io.in_PC_next;
	}
};