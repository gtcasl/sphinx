#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct F_D_Register
{
	__io(
		__in(ch_bit<32>) instruction_in,
		__in(ch_bit<2>)  PC_next_in,
		__out(ch_bit<32>) instruction_out,
		__out(ch_bit<2>) PC_next_out

	);

	void describe()
	{

		ch_reg<ch_bit<32>> instruction(0);
		ch_reg<ch_bit<2>> PC_next(0);

		
		io.instruction_out = instruction;
		io.PC_next_out     = PC_next;

		instruction->next = io.instruction_in;
		    PC_next->next = io.PC_next_in;
	}
};