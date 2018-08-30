#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Fetch
{
	__io(
		__out(ch_bit32) instruction,
		__out(ch_bit2)  PC_next
	);

	void describe()
	{

		
		ch_rom<ch_bit32, 3> inst_mem({0xD5760D7F, 0x01284820, 0x01285020});
		ch_reg<ch_bit2> PC(0);

		io.instruction = inst_mem.read(PC);
		io.PC_next     = PC.as_uint() + 1;
		PC->next       = io.PC_next;


	}
};