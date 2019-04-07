#pragma once

using namespace ch::logic;
using namespace ch::system;

struct Write_Back
{
	__io(
		__in(ch_bit<32>) in_alu_result,
		__in(ch_bit<32>) in_mem_result,
		__in(ch_bit<5>)  in_rd,
		__in(ch_bit<2>)  in_wb,
		__in(ch_bit<5>)  in_rs1,
		__in(ch_bit<5>)  in_rs2,
		__in(ch_bit<32>) in_PC_next,

		__out(ch_bit<32>) out_write_data,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<2>) out_wb
	);

	void describe()
	{

		ch_bool is_jal = io.in_wb.as_uint() == WB_JAL_int;
		ch_bool uses_alu = io.in_wb.as_uint() == WB_ALU_int;

		io.out_write_data = ch_sel(is_jal , io.in_PC_next, ch_sel(uses_alu, io.in_alu_result, io.in_mem_result));

		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;

		// ch_print("****************");
		// ch_print("Write Back");
		// ch_print("****************");		

		// ch_print("rd: {0}, alu_result: {1}, mem_result: {2}, PC_next: {3}, WB: {4}", io.in_rd, io.in_alu_result, io.in_mem_result, io.in_PC_next, io.in_wb);
		// ch_print("rd: {0}, write+data: {1}", io.in_rd, io.out_write_data);


	}
};
