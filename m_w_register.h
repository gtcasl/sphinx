#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct M_W_Register
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

		ch_reg<ch_bit<32>>  alu_result(0);
		ch_reg<ch_bit<5>>  rd(0);
		ch_reg<ch_bit<5>>  rs1(0);
		ch_reg<ch_bit<5>>  rs2(0);
		ch_reg<ch_bit<1>>  wb(0);
		ch_reg<ch_bit2>    PC_next(0);

		io.out_alu_result = alu_result;
		io.out_rd = rd;
		io.out_rs1 = rs1;
		io.out_rs2 = rs2;
		io.out_wb = wb;
		io.out_PC_next = PC_next;
		
		alu_result->next = io.in_alu_result;
		rd->next = io.in_rd;
		rs1->next = io.in_rs1;
		rs2->next = io.in_rs2;
		wb->next = io.in_wb;
		PC_next->next = io.in_PC_next;



	}
};