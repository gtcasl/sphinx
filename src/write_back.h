struct Write_Back
{
	__io(
		__in(ch_bit<32>) in_alu_result,
		__in(ch_bit<32>) in_mem_result,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<2>) in_wb,
		__in(ch_bit<5>) in_rs1,
		__in(ch_bit<5>) in_rs2,
		__in(ch_bit<32>)   in_PC_next,

		__out(ch_bit<32>) out_write_data,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<2>) out_wb
	);

	void describe()
	{


		io.out_write_data = ch_sel(io.in_wb.as_uint() == 1, io.in_alu_result, io.in_mem_result);

		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;


	}
};