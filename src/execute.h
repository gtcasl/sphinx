#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;


struct Execute
{
	__io(
		__in(ch_bit<5>)   in_rd,
		__in(ch_bit<5>)   in_rs1,
		__in(ch_bit<32>)  in_rd1,
		__in(ch_bit<5>)   in_rs2,
		__in(ch_bit<32>)  in_rd2,
		__in(ch_bit<4>)   in_alu_op,
		__in(ch_bit<2>)   in_wb,
		__in(ch_bit<1>)   in_rs2_src, // NEW
		__in(ch_bit<12>)  in_itype_immed, // new
		__in(ch_bit<3>)   in_mem_read, // NEW
		__in(ch_bit<3>)   in_mem_write, // NEW
		__in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<3>)   in_branch_type,
		__in(ch_bit<20>)  in_upper_immed,
		__in(ch_bit<12>)  in_csr_address, // done
		__in(ch_bit<1>)   in_is_csr, // done
		__in(ch_bit<32>)  in_csr_data, // done
		__in(ch_bit<32>)  in_csr_mask, // done

		__out(ch_bit<12>) out_csr_address,
		__out(ch_bit<1>)  out_is_csr,
		__out(ch_bit<32>) out_csr_result,
		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<5>)  out_rd,
		__out(ch_bit<2>)  out_wb,
		__out(ch_bit<5>)  out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<5>)  out_rs2,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<3>)  out_mem_read,
		__out(ch_bit<3>)  out_mem_write,
		__out(ch_bit<1>)  out_branch_dir,
		__out(ch_bit<32>) out_branch_dest,
		__out(ch_bit<32>) out_PC_next
	);


	void describe()
	{
		ch_print("****************");
		ch_print("EXECUTE");
		ch_print("****************");		

		io.out_is_csr      = io.in_is_csr;
		io.out_csr_address = io.in_csr_address;

		ch_bit<32> se_itype_immed = ch_sel(io.in_itype_immed[11] == 1, ch_cat(ONES_20BITS, io.in_itype_immed), ch_cat(CH_ZERO(20), io.in_itype_immed));

		//ch_print("Decode: Immediate: {0}, SIGNEXTENDED: {0}", io.in_itype_immed.as_uint(), se_itype_immed);

		ch_bit<32> ALU_in1 = io.in_rd1;

		ch_bool which_in2 = io.in_rs2_src == RS2_IMMED_int;
		ch_bit<32> ALU_in2 = ch_sel(which_in2, se_itype_immed, io.in_rd2);


		ch_bit<32> upper_immed = ch_cat(io.in_upper_immed, CH_ZERO(12));

		io.out_branch_dest = (io.in_PC_next.as_int() - 4) + (se_itype_immed.as_int() << 1);
		ch_print("BRANCH_DEST: {0} = {1} + {2}", io.out_branch_dest, (io.in_PC_next.as_int() - 4), (se_itype_immed.as_int() << 1));
		ch_print("BRANCH ITYPE_IMMED: {0}", io.in_itype_immed);

		__switch(io.in_alu_op.as_uint())
			__case(ADD_int)
			{
				//ch_print("ADD_int");
				io.out_alu_result = ALU_in1.as_int() + ALU_in2.as_int();
				io.out_csr_result = anything32;
				ch_print("ADD_int: Immediate: {0}, RS2_SRC: {1}, rs1_reg#: {2}", io.in_itype_immed, io.in_rs2_src, io.in_rs1);
				ch_print("Adding {0} + {1}", ALU_in1.as_int(), ALU_in2.as_int());
				ch_print("alu_result = {0}", io.out_alu_result);
				ch_print("Going to DEST: {0}", io.in_rd);
			}
			__case(SUB_int)
			{
				//ch_print("SUB_int");
				io.out_alu_result = ALU_in1.as_int() - ALU_in2.as_int();
				io.out_csr_result = anything32;
				ch_print("SUB_int: {0} - {1} = {2}", ALU_in1, ALU_in2, io.out_alu_result);
			}
			__case(SLLA_int)
			{
				//ch_print("SLLA_int");
				io.out_alu_result = ALU_in1.as_uint() << ALU_in2.as_uint();
				io.out_csr_result = anything32;
			}
			__case(SLT_int)
			{
				//ch_print("SLT_int");
				io.out_alu_result = ch_sel(ALU_in1.as_int() < ALU_in2.as_int(), ch_bit<32>(1), ch_bit<32>(0));
				io.out_csr_result = anything32;
			}
			__case(SLTU_int)
			{
				//ch_print("SLTU_int");
				ch_uint<32> ALU_in1_int  = ALU_in1.as_uint();
				ch_uint<32> ALU_in2_int  = ALU_in2.as_uint();
				io.out_alu_result      = ch_sel(ALU_in1_int < ALU_in2_int, ch_bit<32>(1), ch_bit<32>(0));
				io.out_csr_result      = anything32;
				ch_print("SLT: {0} < {1}? {2}", ALU_in1_int, ALU_in2_int, io.out_alu_result);
			}
			__case(XOR_int)
			{
				//ch_print("XOR");
				io.out_alu_result = ALU_in1 ^ ALU_in2;
				io.out_csr_result = anything32;
			}
			__case(SRL_int)
			{
				//ch_print("SRL_int");
				io.out_alu_result = ALU_in1.as_uint() >> ALU_in2.as_uint();
				io.out_csr_result = anything32;
			}
			__case(SRA_int)
			{
				//ch_print("SRA");
				ch_int32 ALU_in1_int = ALU_in1.as_int();
				io.out_alu_result    = ALU_in1_int  >> ALU_in2.as_uint();
				io.out_csr_result    = anything32;
				ch_print("STA: {0} >> {1} = {2}", ALU_in1, ALU_in2, io.out_alu_result);
			}
			__case(OR_int)
			{
				//ch_print("OR");
				io.out_alu_result = ALU_in1 | ALU_in2;
				io.out_csr_result = anything32;
			}
			__case(AND_int)
			{
				//ch_print("AND");
				io.out_alu_result = ALU_in2 & ALU_in1;
				io.out_csr_result = anything32;
			}
			__case(SUBU_int)
			{
				//ch_print("SUBU");
					


				// ch_bit<32> use1 = ch_sel((ALU_in1[31] == 1), -ALU_in1.as_uint(), (1-ALU_in1.as_uint()));
				// ch_bit<32> use2 = ch_sel((ALU_in2[31] == 1), -ALU_in2.as_uint(), (1-ALU_in2.as_uint()));

				// // ch_print("SUBU signed: {0} - {1} = {2}", ALU_in1, ALU_in2, ALU_in1.as_int() - ALU_in2.as_int());

				// ch_print("SUBU unsigned: {0} - {1} = {2}", ALU_in1, ALU_in2, ALU_in1.as_uint() - ALU_in2.as_uint());
				// ch_print("SUBU vodo: {0} - {1} = {2}", use1, use2, use1.as_int() - use2.as_int());

				ch_print("SUBU: {0} < {1}", ALU_in1.as_uint(), ALU_in2.as_uint());

				__if(ALU_in1.as_uint() >= ALU_in2.as_uint())
				{
					ch_print("\t=0xFFFFFF");
					io.out_alu_result = 0x0;
				} __else
				{
					ch_print("\t=0x0");
					io.out_alu_result = 0xffffffff;
				};

				// io.out_alu_result = ALU_in1.as_uint() - ALU_in2.as_uint();
				io.out_csr_result = anything32;

			}
			__case(LUI_ALU_int)
			{
				io.out_alu_result = upper_immed;
				io.out_csr_result = anything32;
			}
			__case(AUIPC_ALU_int)
			{
				io.out_alu_result = (io.in_PC_next.as_int() - 4) + upper_immed.as_int();
				io.out_csr_result = anything32;
			}
			__case(CSR_ALU_RW_int)
			{
				io.out_alu_result = io.in_csr_data;
				io.out_csr_result = io.in_csr_mask;
			}
			__case(CSR_ALU_RS_int)
			{
				io.out_alu_result = io.in_csr_data;
				io.out_csr_result = io.in_csr_data | io.in_csr_mask;
			}
			__case(CSR_ALU_RC_int)
			{
				io.out_alu_result = io.in_csr_data;
				io.out_csr_result = io.in_csr_data & (0xFFFFFFFF - io.in_csr_mask.as_uint());
			}
			__default
			{
				//ch_print("INVALID ALU OP");
				io.out_alu_result = 0;
				io.out_csr_result = anything32;
			};


		__switch(io.in_branch_type.as_uint())
			__case(BEQ_int)
			{
				//ch_print("BEQ INSTRUCTION IN EXE");
				//ch_print("RS1: {0}, RD1: {1}", io.in_rs1, io.in_rd1);
				//ch_print("RS2: {0}, RD2: {1}", io.in_rs2, io.in_rd2);
				//ch_print("ALU Result: {0}", io.out_alu_result);

				io.out_branch_dir = ch_sel(io.out_alu_result.as_uint() == 0, TAKEN, NOT_TAKEN);
				ch_print("BEQ_int");
			}
			__case(BNE_int)
			{
				io.out_branch_dir = ch_sel(io.out_alu_result.as_uint() == 0, NOT_TAKEN, TAKEN);
			}
			__case(BLT_int)
			{
				io.out_branch_dir = ch_sel(io.out_alu_result[31] == 0, NOT_TAKEN, TAKEN);
				ch_print("BRANCH: is {0} < {1}? The answer is: {2}, ALU_RESULT: {3}", ALU_in1, ALU_in2, io.out_branch_dir, io.out_alu_result);
			}
			__case(BGT_int)
			{
				io.out_branch_dir = ch_sel(io.out_alu_result[31] == 0, TAKEN, NOT_TAKEN);
				ch_print("BGT_int");
				ch_print("BRANCH: sr1 {0}, src2: {1}", io.in_rs1, io.in_rs2);
				ch_print("BRANCH: is {0} > {1}? The answer is: {2}, ALU_RESULT: {3}", ALU_in1, ALU_in2, io.out_branch_dir, io.out_alu_result);
			}
			__case(BLTU_int)
			{
				io.out_branch_dir = ch_sel(io.out_alu_result[31] == 0, NOT_TAKEN, TAKEN);
				ch_print("BLTU_int: {0}", io.out_branch_dir);
			}
			__case(BGTU_int)
			{
				io.out_branch_dir = ch_sel(io.out_alu_result[31] == 0, TAKEN, NOT_TAKEN);
				ch_print("BGTU_int: RESULT: {0}", io.out_branch_dir);
			}
			__case(NO_BRANCH_int)
			{
				io.out_branch_dir = NOT_TAKEN;
				ch_print("NO_B_int");
			}
			__default
			{
				io.out_branch_dir = NOT_TAKEN;
				ch_print("Default_b_int");
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