#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct F_D_Register
{
	__io(
		__in(ch_bit<32>) instruction,
		__in(ch_bit<2>)  PC_next_in,
		__out(ch_bit<7>) opcode,
		__out(ch_bit<5>) rd,
		__out(ch_bit<5>) rs1,
		__out(ch_bit<5>) rs2,
		__out(ch_bit<3>) func3,
		__out(ch_bit<7>) func7,
		__out(ch_bit<2>) PC_next_out

	);

	void describe()
	{

		
		ch_reg<ch_bit<7>> opcode(0);

		ch_reg<ch_bit<5>> rd(0);
		ch_reg<ch_bit<5>> rs1(0);
		ch_reg<ch_bit<5>> rs2(0);

		ch_reg<ch_bit<3>> func3(0);
		ch_reg<ch_bit<7>> func7(0);

		ch_reg<ch_bit<2>> PC_next;

		io.opcode      = opcode;
		io.rd          = rd;
		io.rs1         = rs1;
		io.rs2         = rs2;
		io.func3       = func3;
		io.func7       = func7;
		io.PC_next_out = PC_next;

		 opcode->next = ch_slice<7>(io.instruction);
		     rd->next = ch_slice<5>(io.instruction >> 7);
		  func3->next = ch_slice<3>(io.instruction >> 12);
		    rs1->next = ch_slice<5>(io.instruction >> 15);
		    rs2->next = ch_slice<5>(io.instruction >> 20);
		  func7->next = ch_slice<7>(io.instruction >> 25);
	    PC_next->next = io.PC_next_in;
	}
};