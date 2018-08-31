#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Decode
{
	__io(
		__in(ch_bit<32>)   instruction,
		__in(ch_bit2)    PC_next_in,
		__out(ch_bit<7>) opcode,
		__out(ch_bit<5>) rd,
		__out(ch_bit<5>) rs1,
		__out(ch_bit<32>) rd1,
		__out(ch_bit<5>) rs2,
		__out(ch_bit<32>) rd2,
		__out(ch_bit<3>) func3,
		__out(ch_bit<7>) func7,
		__out(ch_bit<1>) wb,
		__out(ch_bit2)   PC_next_out
	);

	void describe()
	{

		ch_rom<ch_bit<32>, 32> registers({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,
			26,27,28,29,30,31});

		io.opcode      = ch_slice<7>(io.instruction);;
		io.rd          = ch_slice<5>(io.instruction >> 7);
		io.rs1         = ch_slice<5>(io.instruction >> 15);
		io.rd1         = registers.read(io.rs1);
		io.rs2         = ch_slice<5>(io.instruction >> 20);
		io.rd2         = registers.read(io.rs2);
		io.func3       = ch_slice<3>(io.instruction >> 12);
		io.func7       = ch_slice<7>(io.instruction >> 25);
		io.PC_next_out = io.PC_next_in;

		io.wb          = ch_sel(io.opcode == 51, ch_bit<1>(1), ch_bit<1>(0));
		// io.wb = 1;



	}
};