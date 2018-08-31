#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Fetch
{
	__io(
		__out(ch_bit<32>) instruction,
		__out(ch_bit2)  PC_next
	);

	void describe()
	{

		
		ch_rom<ch_bit<32>, 4> inst_mem({0x00720233, 00720233, 0x00720233, 0x00000000});
		ch_reg<ch_bit2> PC(0);

		io.instruction = inst_mem.read(PC.as_uint());
		io.PC_next = ch_sel(PC.as_uint() == 3, PC, PC.as_uint() + 1);
		
		PC->next       = io.PC_next;




	}
};