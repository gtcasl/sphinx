#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct E_M_Register
{
	__io(
		__in(ch_bit<32>)  in_alu_result,
		__in(ch_bit<5>)   in_rd,
		__in(ch_bit<2>)   in_wb,
		__in(ch_bit<5>)   in_rs1,
		__in(ch_bit<32>)  in_rd1,
		__in(ch_bit<5>)   in_rs2,
		__in(ch_bit<32>)  in_rd2,
		__in(ch_bit<3>)   in_mem_read, // NEW
		__in(ch_bit<3>)   in_mem_write, // NEW
		__in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<12>)  in_csr_address,
		__in(ch_bit<1>)   in_is_csr,
		__in(ch_bit<32>)  in_csr_result,

		__out(ch_bit<12>) out_csr_address,
		__out(ch_bit<1>)  out_is_csr,
		__out(ch_bit<32>) out_csr_result,
		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<5>)  out_rd,
		__out(ch_bit<2>)  out_wb,
		__out(ch_bit<5>)  out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<5>)  out_rs2,
		__out(ch_bit<3>)  out_mem_read,
		__out(ch_bit<3>)  out_mem_write,
		__out(ch_bit<32>) out_PC_next
	);

	void describe()
	{

		ch_reg<ch_bit<32>>  alu_result(0);
		ch_reg<ch_bit<5>>  rd(0);
		ch_reg<ch_bit<5>>  rs1(0);
		ch_reg<ch_bit<32>> rd1(0);
		ch_reg<ch_bit<5>>  rs2(0);
		ch_reg<ch_bit<32>> rd2(0);
		ch_reg<ch_bit<2>>  wb(0);
		ch_reg<ch_bit<32>> PC_next(0);
		ch_reg<ch_bit<3>>  mem_read(0);
		ch_reg<ch_bit<3>>  mem_write(0);
		ch_reg<ch_bit<12>> csr_address(0);
		ch_reg<ch_bit<1>>  is_csr(0);
		ch_reg<ch_bit<32>> csr_result(0);

		io.out_alu_result = alu_result;
		io.out_rd = rd;
		io.out_rs1 = rs1;
		io.out_rs2 = rs2;
		io.out_wb = wb;
		io.out_PC_next = PC_next;
		io.out_mem_read = mem_read;
		io.out_mem_write = mem_write;
		io.out_rd1 = rd1;
		io.out_rd2 = rd2;
		io.out_csr_address = csr_address;
		io.out_is_csr = is_csr;
		io.out_csr_result = csr_result;
		
		alu_result->next = io.in_alu_result;
		rd->next = io.in_rd;
		rs1->next = io.in_rs1;
		rs2->next = io.in_rs2;
		wb->next = io.in_wb;
		PC_next->next = io.in_PC_next;
		mem_read->next = io.in_mem_read;
		mem_write->next = io.in_mem_write;
		rd1->next = io.in_rd1;
		rd2->next = io.in_rd2;
		csr_address->next = io.in_csr_address;
		is_csr->next = io.in_is_csr;
		csr_result->next = io.in_csr_result;

	}
};