#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Memory
{
	__io(
		__in(ch_bit<32>) in_alu_result,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<1>) in_wb,
		__in(ch_bit<5>) in_rs1,
		__in(ch_bit<5>) in_rs2,
		__in(ch_bit2)   in_PC_next,
		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<1>) out_wb,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		io.out_alu_result = io.in_alu_result;
		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;
		io.out_rs1 = io.in_rs1;
		io.out_rs2 = io.in_rs2;
		io.out_PC_next = io.in_PC_next;


	}
};