struct Write_Back
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
		__out(ch_bit<1>) out_wb
	);

	void describe()
	{


		io.out_alu_result = io.in_alu_result;
		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;


	}
};