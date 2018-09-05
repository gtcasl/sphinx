#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Execute
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

		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<1>) out_wb,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		ch_bit<32> ALU_in1 = io.in_rd1;
		ch_bit<32> ALU_in2 = io.in_rd2; 


		__switch(io.in_func3.as_uint())
			__case(0) 
			{
				ch_bit<32> add = ALU_in1.as_int() + ALU_in2.as_int();
				ch_bit<32> sub = ALU_in1.as_int() - ALU_in2.as_int();
				io.out_alu_result = ch_sel(io.in_func7.as_uint() == 0, add, sub);
			}
			__case(1)
			{
				io.out_alu_result = ALU_in1.as_uint() << ALU_in2.as_uint();
			}
			__case(2)
			{
				io.out_alu_result = ch_sel(ALU_in1.as_int() < ALU_in2.as_int(), ch_bit<32>(0), ch_bit<32>(1));
			}
			__case(3)
			{
				io.out_alu_result = ch_sel(ALU_in1.as_uint() < ALU_in2.as_uint(), ch_bit<32>(0), ch_bit<32>(1));
			}
			__case(4)
			{
				io.out_alu_result = ALU_in1 ^ ALU_in2;
			}
			__case(5)
			{
				ch_bit<32> logical = ALU_in1.as_uint() >> ALU_in2.as_uint();
				ch_bit<32> arithm  = ALU_in1.as_int()  >> ALU_in2.as_uint();
				io.out_alu_result  = ch_sel(io.in_func7.as_uint() == 0, logical, arithm);
			}
			__case(6)
			{
				io.out_alu_result = ALU_in1 | ALU_in2;
			}
			__case(7)
			{
				io.out_alu_result = ALU_in2 & ALU_in1;
			}
			__default
			{
				io.out_alu_result = 0;
			};

			io.out_rd = io.in_rd;
			io.out_wb = io.in_wb;
			io.out_rs1 = io.in_rs1;
			io.out_rs2 = io.in_rs2;
			io.out_PC_next = io.in_PC_next;

	}
};