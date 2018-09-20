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
		__in(ch_bit<32>) in_write_data,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<2>) in_wb,

		// Debugging outputs
		__out(ch_bit<32>) actual_change,

		// Outputs
		// (decode_io) out
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<5>) out_rs2,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<2>) out_wb,
		__out(ch_bit<4>) out_alu_op,
		__out(ch_bit<1>) out_rs2_src, // NEW
		__out(ch_bit<12>) out_itype_immed, // new
		__out(ch_bit<3>) out_mem_read, // NEW
		__out(ch_bit<3>) out_mem_write, // NEW
		__out(ch_bit2)   out_PC_next
	);

	void describe()
	{

		ch_mem<ch_bit<32>, 32> registers;

		ch_bit<7> curr_opcode;
		ch_bool is_itype;
		ch_bool is_rtype;
		ch_bool is_stype;

		ch_bool write_register = ch_sel(io.in_wb.as_uint() > 0, ch_bool(true), ch_bool(false));

		registers.write(io.in_rd, io.in_write_data, write_register);


		curr_opcode        = ch_slice<7>(io.in_instruction);;
		io.out_rd          = ch_slice<5>(io.in_instruction >> 7);
		io.out_rs1         = ch_slice<5>(io.in_instruction >> 15);
		io.out_rd1         = registers.read(io.out_rs1);
		io.out_rs2         = ch_slice<5>(io.in_instruction >> 20);
		io.out_rd2         = registers.read(io.out_rs2);
		ch_bit<3> func3    = ch_slice<3>(io.in_instruction >> 12);
		ch_bit<7> func7    = ch_slice<7>(io.in_instruction >> 25);
		io.out_PC_next     = io.in_PC_next;

		// MEM signals 
		io.out_mem_read  = ch_sel(curr_opcode == 3, func3, ch_bit<3>(7));
		io.out_mem_write = ch_sel(curr_opcode == 35, func3, ch_bit<3>(7));


		// Write Back sigal
		is_rtype  = curr_opcode == 51;
		is_itype  = (curr_opcode == 19) || (curr_opcode == 3); 
		is_stype  = (curr_opcode == 35);

		io.out_wb = ch_sel(is_rtype, ch_bit<2>(1), ch_sel(is_itype, ch_bit<2>(2), ch_bit<2>(0)));

		io.out_rs2_src = ch_sel(is_itype, ch_bit<1>(1), ch_bit<1>(0));

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

		__switch(curr_opcode)
			__case(19) 
			{
				ch_bool shift_i = (func3 == 1) || (func3 == 5);

				ch_bit<12> shift_i_immediate = ch_cat(ch_bit<7>(0), io.out_rs2); // out_rs2 represents shamt

				io.out_itype_immed = ch_sel(shift_i, shift_i_immediate, ch_slice<12>(io.in_instruction >> 20));
			}
			__case(35)
			{
				io.out_itype_immed = ch_cat(func7, io.out_rd);
			}
			// __case(2)
			// {

			// }
			__default
			{
				io.out_itype_immed = ch_bit<12>(123); 
			};

		// Debugging outputs
		io.actual_change = registers.read(ch_uint<5>(6));


	}

};


