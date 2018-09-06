#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct D_E_Register
{
	__io(
		__in(ch_bit<7>) in_opcode,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<5>) in_rs1,
		__in(ch_bit<32>)in_rd1,
		__in(ch_bit<5>) in_rs2,
		__in(ch_bit<32>)in_rd2,
		__in(ch_bit<3>) in_func3,
		__in(ch_bit<7>) in_func7,
		__in(ch_bit<1>) in_wb,
		__in(ch_bit2)   in_PC_next,

		__out(ch_bit<7>) out_opcode,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<32>)out_rd1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit<32>)out_rd2,
		__out(ch_bit<3>) out_func3,
		__out(ch_bit<7>) out_func7,
		__out(ch_bit<1>) out_wb,
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		ch_reg<ch_bit<7>>  opcode(0);
		ch_reg<ch_bit<5>>  rd(0);
		ch_reg<ch_bit<5>>  rs1(0);
		ch_reg<ch_bit<32>> rd1(0);
		ch_reg<ch_bit<5>>  rs2(0);
		ch_reg<ch_bit<32>> rd2(0);
		ch_reg<ch_bit<3>>  func3(0);
		ch_reg<ch_bit<7>>  func7(0);
		ch_reg<ch_bit<1>>  wb(0);
		ch_reg<ch_bit2>    PC_next_out(0);

		io.out_opcode = opcode;
		io.out_rd = rd;
		io.out_rs1 = rs1;
		io.out_rd1 = rd1;
		io.out_rs2 = rs2;
		io.out_rd2 = rd2;
		io.out_func3 = func3;
		io.out_func7 = func7;
		io.out_wb = wb;
		io.out_PC_next = PC_next_out;
		
		opcode->next = io.in_opcode;
		rd->next = io.in_rd;
		rs1->next = io.in_rs1;
		rd1->next = io.in_rd1;
		rs2->next = io.in_rs2;
		rd2->next = io.in_rd2;
		func3->next = io.in_func3;
		func7->next = io.in_func7;
		wb->next = io.in_wb;
		PC_next_out->next = io.in_PC_next;



	}
};