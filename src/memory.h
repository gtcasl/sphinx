#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Memory
{
	__io(
		__in(ch_bit<32>) in_alu_result,
		__in(ch_bit<3>) in_mem_read, // New
		__in(ch_bit<3>) in_mem_write, // New
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<2>) in_wb,
		__in(ch_bit<5>) in_rs1,
		__in(ch_bit<32>) in_rd1,
		__in(ch_bit<5>) in_rs2,
		__in(ch_bit<32>) in_rd2,
		__in(ch_bit2)   in_PC_next,

		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<32>) out_mem_result, // Neww
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<2>) out_wb,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		ch_mem<ch_bit<32>, 4096> mem_module;

		// 

		ch_bit<32> mem_result(0);

		__switch(io.in_mem_read.as_uint())
			__case(0) 
			{
				ch_bit<24> ones(16777215);
				ch_bit<24> zeros(0);
				
				// LB sign extend
				ch_bit<8> byte = ch_slice<8>(mem_module.read(ch_slice<12>(io.in_alu_result)));
				mem_result = ch_sel(byte[7] == 1, ch_cat(ones, byte), ch_cat(zeros, byte));
			}
			__case(1)
			{
				// LH sign extend
				ch_bit<16> ones(65535);
				ch_bit<16> zeros(0);
				
				ch_bit<16> half = ch_slice<16>(mem_module.read(ch_slice<12>(io.in_alu_result)));
				mem_result = ch_sel(half[15] == 1, ch_cat(ones, half), ch_cat(zeros, half));
			}
			__case(2)
			{
				// LW
				mem_result = mem_module.read(ch_slice<12>(io.in_alu_result));
			}
			__case(4)
			{
				ch_bit<24> zeros(0);
				// LBU
				ch_bit<8> byte = ch_slice<8>(mem_module.read(ch_slice<12>(io.in_alu_result)));
				mem_result = ch_cat(zeros, byte);
			}
			__case(5)
			{
				ch_bit<16> zeros(0);

				// LHU
				ch_bit<16> half = ch_slice<16>(mem_module.read(ch_slice<12>(io.in_alu_result)));
				mem_result = ch_cat(zeros, half);
			}
			__default
			{
				mem_result = ch_bit<32>(0); 
			};


		// __switch(io.in_mem_write.as_uint())
		// 	__case(0) 
		// 	{
		// 		// SB
		// 		ch_bit<24> zeros(0);
		// 		ch_bit<32> word = ch_cat(zeros, ch_slice<8>(io.in_rd2)) | mem_module.read(ch_slice<12>(io.in_alu_result));
		// 		mem_module.write(ch_slice<12>(io.in_alu_result), word, true);
		// 	}
		// 	__case(1)
		// 	{
		// 		// SH
		// 		ch_bit<16> zeros(0);
		// 		ch_bit<32> word = ch_cat(zeros, ch_slice<16>(io.in_rd2)) | mem_module.read(ch_slice<12>(io.in_alu_result));
		// 		mem_module.write(ch_slice<12>(io.in_alu_result), word, true);
		// 	__case(2)
		// 	{
		// 		// SW
		// 		mem_module.write(ch_slice<12>(io.in_alu_result), io.in_rd2, true);
		// 	}
		// 	__default
		// 	{

		// 	};



		io.out_mem_result = ch_sel(io.in_mem_read == 1, mem_module.read(ch_slice<12>(io.in_alu_result)), ch_bit<32>(0));

		io.out_alu_result = io.in_alu_result;
		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;
		io.out_rs1 = io.in_rs1;
		io.out_rs2 = io.in_rs2;
		io.out_PC_next = io.in_PC_next;


	}
};