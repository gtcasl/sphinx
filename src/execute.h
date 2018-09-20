#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Execute
{
	__io(
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<5>) in_rs1,
		__in(ch_bit<32>)in_rd1,
		__in(ch_bit<5>) in_rs2,
		__in(ch_bit<32>)in_rd2,
		__in(ch_bit<4>) in_alu_op,
		__in(ch_bit<2>) in_wb,
		__in(ch_bit<1>) in_rs2_src, // NEW
		__in(ch_bit<12>) in_itype_immed, // new
		__in(ch_bit<3>) in_mem_read, // NEW
		__in(ch_bit<3>) in_mem_write, // NEW
		__in(ch_bit2)   in_PC_next,

		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<2>) out_wb,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<3>) out_mem_read,
		__out(ch_bit<3>) out_mem_write,
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		
		ch_bit<20> ones(1048575);
		ch_bit<20> zeros(0);
		ch_bit<32> se_itype_immed = ch_sel(io.in_itype_immed[11] == 1, ch_cat(ones, io.in_itype_immed), ch_cat(zeros, io.in_itype_immed));


		ch_bit<32> ALU_in1 = io.in_rd1;

		ch_bool which_in2 = io.in_rs2_src == 1;
		ch_bit<32> ALU_in2 = ch_sel(which_in2, se_itype_immed, io.in_rd2); 


		__switch(io.in_alu_op.as_uint())
			__case(0) 
			{
				io.out_alu_result = ALU_in1.as_int() + ALU_in2.as_int();
			}
			__case(1)
			{
				io.out_alu_result = ALU_in1.as_int() - ALU_in2.as_int();
			}
			__case(2)
			{
				io.out_alu_result = ALU_in1.as_uint() << ALU_in2.as_uint();
			}
			__case(3)
			{
				io.out_alu_result = ch_sel(ALU_in1.as_int() < ALU_in2.as_int(), ch_bit<32>(0), ch_bit<32>(1));
			}
			__case(4)
			{
				io.out_alu_result = ch_sel(ALU_in1.as_uint() < ALU_in2.as_uint(), ch_bit<32>(0), ch_bit<32>(1));
			}
			__case(5)
			{
				
				io.out_alu_result = ALU_in1 ^ ALU_in2;
			}
			__case(6)
			{
				io.out_alu_result = ALU_in1.as_uint() >> ALU_in2.as_uint();
			}
			__case(7)
			{
				io.out_alu_result  = ALU_in1.as_int()  >> ALU_in2.as_uint();
			}
			__case(8)
			{
				io.out_alu_result = ALU_in1 | ALU_in2;
			}
			__case(9)
			{
				io.out_alu_result = ALU_in2 & ALU_in1;
			}
			__default
			{
				io.out_alu_result = 0;
			};

			io.out_rd = io.in_rd;
			io.out_wb = io.in_wb;
			io.out_mem_read = io.in_mem_read;
			io.out_mem_write = io.in_mem_write;
			io.out_rs1 = io.in_rs1;
			io.out_rd1 = io.in_rd1;
			io.out_rd2 = io.in_rd2;
			io.out_rs2 = io.in_rs2;
			io.out_PC_next = io.in_PC_next;

	}
};