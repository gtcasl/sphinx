#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


// __inout(decode_io, (
// 	__out(ch_bit<7>) out_opcode,
// 	__out(ch_bit<5>) out_rd,
// 	__out(ch_bit<5>) out_rs1,
// 	__out(ch_bit<32>) out_rd1,
// 	__out(ch_bit<5>) out_rs2,
// 	__out(ch_bit<32>) out_rd2,
// 	__out(ch_bit<1>) out_wb,
// 	__out(ch_bit<4>) out_alu_op,
// 	__out(ch_bit2)   out_PC_next
// ));

struct Decode
{
	__io(
		// Fetch Inputs
		__in(ch_bit<32>)   in_instruction,
		__in(ch_bit2)    in_PC_next,
		// WriteBack inputs
		__in(ch_bit<32>) in_alu_result,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<1>) in_wb,

		// Debugging outputs
		__out(ch_bit<32>) actual_change,

		// Outputs
		// (decode_io) out
		__out(ch_bit<7>) out_opcode,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<1>) out_wb,
		__out(ch_bit<4>) out_alu_op,
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		ch_mem<ch_bit<32>, 32> registers;



		registers.write(ch_uint<5>(4), ch_uint<32>(4) );
		registers.write(ch_uint<5>(7), ch_uint<32>(7) );



		registers.write(io.in_rd, io.in_alu_result, io.in_wb.as_uint());


		ch_print("\nPC: {0}\nWB:{1}\nDATA{2}", io.in_PC_next, io.in_wb, io.in_alu_result);


		io.out_opcode      = ch_slice<7>(io.in_instruction);;
		io.out_rd          = ch_slice<5>(io.in_instruction >> 7);
		io.out_rs1         = ch_slice<5>(io.in_instruction >> 15);
		io.out_rd1         = registers.read(io.out_rs1);
		io.out_rs2         = ch_slice<5>(io.in_instruction >> 20);
		io.out_rd2         = registers.read(io.out_rs2);
		ch_bit<3> func3    = ch_slice<3>(io.in_instruction >> 12);
		ch_bit<7> func7    = ch_slice<7>(io.in_instruction >> 25);
		io.out_PC_next     = io.in_PC_next;

		// Write Back sigal
		io.out_wb          = ch_sel(io.out_opcode == 51, ch_bit<1>(1), ch_bit<1>(0));

		// ALU OP
		__switch(func3.as_uint())
			__case(0) 
			{
				io.out_alu_op = ch_sel(func7.as_uint() == 0, ch_bit<4>(0), ch_bit<4>(1));
			}
			__case(1)
			{
				io.out_alu_op = ch_bit<4>(2);
			}
			__case(2)
			{
				io.out_alu_op = ch_bit<4>(3);
			}
			__case(3)
			{
				io.out_alu_op = ch_bit<4>(4);
			}
			__case(4)
			{
				io.out_alu_op = ch_bit<4>(5);
			}
			__case(5)
			{
				io.out_alu_op  = ch_sel(func7.as_uint() == 0, ch_bit<4>(6), ch_bit<4>(7));
			}
			__case(6)
			{
				io.out_alu_op = ch_bit<4>(8);
			}
			__case(7)
			{
				io.out_alu_op = ch_bit<4>(9);
			}
			__default
			{
				io.out_alu_op = 15;
			};

		// Debugging outputs
		io.actual_change = registers.read(ch_uint<5>(6));


	}

};


