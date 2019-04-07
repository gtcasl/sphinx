#pragma once

#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::logic;
using namespace ch::system;


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

struct RegisterFile
{
	__io(
		__in(ch_bool) in_write_register,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<32>) in_data,
		__in(ch_bit<5>) in_src1,
		__in(ch_bit<5>) in_src2,

		__out(ch_bit<32>) out_src1_data,
		__out(ch_bit<32>) out_src2_data
	);

	void describe()
	{
		ch_mem<ch_bit<32>, 32> registers;
		// ch_reg<ch_bool> starting(true);

		// __if(starting)
		// {
		// 	starting->next = ch_bool(false);
		// };

		ch_bit<32> write_data;
		ch_bit<5> write_register;
		ch_bool enable;



		// __if(starting)
		// {
		// 	write_data     = ch_bit<32>(0);
		// 	write_register = ch_bit<5>(0);
		// 	enable         = TRUE; 
		// } __else
		// {
			write_data     = io.in_data;
			write_register = io.in_rd;
			enable         = io.in_write_register && ((io.in_rd != ch_bit<5>(0)));
		// };

		registers.write(write_register, write_data, enable);

    	io.out_src1_data = ch_sel(io.in_src1.as_uint() == ZERO_REG_int, CH_ZERO(32), registers.read(io.in_src1));
    	io.out_src2_data = ch_sel(io.in_src2.as_uint() == ZERO_REG_int, CH_ZERO(32), registers.read(io.in_src2));


		// ch_print("Reg 0: {0}", registers.read(ch_bit<5>(0)));
		// ch_print("Reg 1: {0}", registers.read(ch_bit<5>(1)));
		// ch_print("Reg 2: {0}", registers.read(ch_bit<5>(2)));
		// ch_print("Reg 3: {0}", registers.read(ch_bit<5>(3)));
		// ch_print("Reg 4: {0}", registers.read(ch_bit<5>(4)));
		// ch_print("Reg 5: {0}", registers.read(ch_bit<5>(5)));
		// ch_print("Reg 6: {0}", registers.read(ch_bit<5>(6)));
		// ch_print("Reg 7: {0}", registers.read(ch_bit<5>(7)));
		// ch_print("Reg 8: {0}", registers.read(ch_bit<5>(8)));
		// ch_print("Reg 9: {0}", registers.read(ch_bit<5>(9)));
		// ch_print("Reg 10: {0}", registers.read(ch_bit<5>(10)));
		// ch_print("Reg 11: {0}", registers.read(ch_bit<5>(11)));
		// ch_print("Reg 12: {0}", registers.read(ch_bit<5>(12)));
		// ch_print("Reg 13: {0}", registers.read(ch_bit<5>(13)));
		// ch_print("Reg 14: {0}", registers.read(ch_bit<5>(14)));
		// ch_print("Reg 15: {0}", registers.read(ch_bit<5>(15)));
		// ch_print("Reg 16: {0}", registers.read(ch_bit<5>(16)));
		// ch_print("Reg 17: {0}", registers.read(ch_bit<5>(17)));
		// ch_print("Reg 18: {0}", registers.read(ch_bit<5>(18)));
		// ch_print("Reg 19: {0}", registers.read(ch_bit<5>(19)));
		// ch_print("Reg 20: {0}", registers.read(ch_bit<5>(20)));
		// ch_print("Reg 21: {0}", registers.read(ch_bit<5>(21)));
		// ch_print("Reg 22: {0}", registers.read(ch_bit<5>(22)));
		// ch_print("Reg 23: {0}", registers.read(ch_bit<5>(23)));
		// ch_print("Reg 24: {0}", registers.read(ch_bit<5>(24)));
		// ch_print("Reg 25: {0}", registers.read(ch_bit<5>(25)));
		// ch_print("Reg 26: {0}", registers.read(ch_bit<5>(26)));
		// ch_print("Reg 27: {0}", registers.read(ch_bit<5>(27)));
		// ch_print("Reg 28: {0}", registers.read(ch_bit<5>(28)));
		// ch_print("Reg 29: {0}", registers.read(ch_bit<5>(29)));
		// ch_print("Reg 30: {0}", registers.read(ch_bit<5>(30)));
		// ch_print("Reg 31: {0}", registers.read(ch_bit<5>(31)));


	}
};


struct Decode
{
	__io(
		// Fetch Inputs
		__in(ch_bit<32>)  in_instruction,
		// __in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<32>)  in_curr_PC,
		__in(ch_bool)     in_stall,
		// WriteBack inputs
		__in(ch_bit<32>)  in_write_data,
		__in(ch_bit<5>)   in_rd,
		__in(ch_bit<2>)   in_wb,

		#ifdef FORWARDING
		// FORWARDING INPUTS
		__in(ch_bit<1>)   in_src1_fwd,
		__in(ch_bit<32>)  in_src1_fwd_data,
		__in(ch_bit<1>)   in_src2_fwd,
		__in(ch_bit<32>)  in_src2_fwd_data,

		// CSR
		__in(ch_bit<1>)   in_csr_fwd, 
		__in(ch_bit<32>)  in_csr_fwd_data,

		#endif

		// __in(ch_bit<32>)  in_csr_data, // done

		__out(ch_bit<12>) out_csr_address, // done
		__out(ch_bit<1>)  out_is_csr, // done
		// __out(ch_bit<32>) out_csr_data, // done
		__out(ch_bit<32>) out_csr_mask, // done

		// Outputs
		// (decode_io) out
		__out(ch_bit<5>)  out_rd,
		__out(ch_bit<5>)  out_rs1,
		__out(ch_bit<32>) out_rd1,
		__out(ch_bit<5>)  out_rs2,
		__out(ch_bit<32>) out_rd2,
		__out(ch_bit<2>)  out_wb,
		__out(ch_bit<4>)  out_alu_op,
		__out(ch_bit<1>)  out_rs2_src, // NEW
		__out(ch_bit<32>) out_itype_immed, // new
		__out(ch_bit<3>)  out_mem_read, // NEW
		__out(ch_bit<3>)  out_mem_write, // NEW
		__out(ch_bit<3>)  out_branch_type,
		__out(ch_bit<1>)  out_branch_stall,
		__out(ch_bit<1>)  out_jal,
		__out(ch_bit<32>) out_jal_offset,
		__out(ch_bit<20>) out_upper_immed,
		__out(ch_bit<32>) out_PC_next
	);

	void describe()
	{

		// ch_print("PC: {0}", io.in_curr_PC);


		ch_bit<7> curr_opcode(0);
		ch_bit<4> alu_op;
		ch_bit<4> b_alu_op;
		ch_bit<32> rd1_register;
		ch_bit<32> rd2_register;

		ch_bool is_itype;
		ch_bool is_rtype;
		ch_bool is_stype;
		ch_bool is_btype;
		ch_bool is_linst;
		ch_bool is_jal;
		ch_bool is_jalr;
		ch_bool is_lui;
		ch_bool is_auipc;
		ch_bool is_csr;
		ch_bool is_csr_immed;
		ch_bool is_e_inst;

		ch_bool write_register = ch_sel(io.in_wb.as_uint() != NO_WB_int, TRUE, FALSE);

		curr_opcode      = ch_slice<7>(io.in_instruction);


		io.out_rd        = ch_slice<5>(io.in_instruction >> 7);
		io.out_rs1       = ch_slice<5>(io.in_instruction >> 15);
		io.out_rs2       = ch_slice<5>(io.in_instruction >> 20);
		ch_bit<3> func3  = ch_slice<3>(io.in_instruction >> 12);
		ch_bit<7> func7  = ch_slice<7>(io.in_instruction >> 25);
		ch_bit<12> u_12  = ch_slice<12>(io.in_instruction >> 20);
		io.out_PC_next   = io.in_curr_PC.as_uint() + ch_uint(4);


		registerfile.io.in_write_register = write_register;
		registerfile.io.in_rd             = io.in_rd;
		registerfile.io.in_data           = io.in_write_data;
		registerfile.io.in_src1           = io.out_rs1;
		registerfile.io.in_src2           = io.out_rs2;
		rd1_register                      = registerfile.io.out_src1_data;
		rd2_register                      = registerfile.io.out_src2_data;



		// Write Back sigal
		is_rtype     = (curr_opcode == R_INST);
		is_linst     = (curr_opcode == L_INST);
		is_itype     = (curr_opcode == ALU_INST) || is_linst; 
		is_stype     = (curr_opcode == S_INST);
		is_btype     = (curr_opcode == B_INST);
		is_jal       = (curr_opcode == JAL_INST);
		is_jalr      = (curr_opcode == JALR_INST);
		is_lui       = (curr_opcode == LUI_INST);
		is_auipc     = (curr_opcode == AUIPC_INST);
		is_csr       = (curr_opcode == SYS_INST) && (func3 != 0);
		is_csr_immed = (is_csr) && (func3[2] == 1);
		is_e_inst    = (curr_opcode == SYS_INST) && (func3 == 0);


		// ch_print("DECODE: PC: {0}, INSTRUCTION: {1}", io.in_curr_PC, io.in_instruction);


		#ifdef FORWARDING
			io.out_rd1 = ch_sel(is_jal, io.in_curr_PC,
						                ch_sel(io.in_src1_fwd == FWD, io.in_src1_fwd_data, rd1_register));
			io.out_rd2 = ch_sel(io.in_src2_fwd == FWD, io.in_src2_fwd_data, rd2_register);
			// io.out_csr_data = ch_sel(io.in_csr_fwd.as_uint() == 1, io.in_csr_fwd_data, io.in_csr_data);
		#else
			io.out_rd1 = ch_sel(is_jal, io.in_curr_PC, rd1_register);
			io.out_rd2 = rd2_register;
			// io.out_csr_data = io.in_csr_data;
		#endif


		// ch_print("curr_PC: {0}\tcurr_isnt: {1}\tStall: {2}", io.in_curr_PC, io.in_instruction, io.in_stall);


		io.out_is_csr   = is_csr.as_uint();
    	io.out_csr_mask = ch_sel(is_csr_immed, ch_resize<32>(io.out_rs1), io.out_rd1);



		io.out_wb        = ch_sel((is_jal || is_jalr || is_e_inst), WB_JAL,
			                   ch_sel(is_linst, WB_MEM, 
			                   	     ch_sel((is_itype || is_rtype || is_lui || is_auipc || is_csr), WB_ALU,
			                   	     	    NO_WB)));
		io.out_rs2_src   = ch_sel(is_itype || is_stype, RS2_IMMED, RS2_REG);
		// MEM signals 
		io.out_mem_read  = ch_sel(is_linst, func3, NO_MEM_READ);
		io.out_mem_write = ch_sel(is_stype, func3, NO_MEM_WRITE);

		// ch_print("****************");
		// ch_print("DECODE");
		// ch_print("****************");

		// ch_print("Curr_inst: {0} , FWD for src1: {1} d: {2}, FWD for src2: {3} , d: {4}", io.in_instruction, io.in_src1_fwd, io.out_rd1, io.in_src2_fwd, io.out_rd2);
		// ch_print("src1: {0}, src2: {1}, rd: {2}", io.out_rs1, io.out_rs2, io.out_rd);

		// UPPER IMMEDIATE
		__switch(curr_opcode)
			__case(LUI_INST)
			{
				io.out_upper_immed  = ch_cat(func7, io.out_rs2, io.out_rs1, func3);
			}
			__case(AUIPC_INST)
			{
				io.out_upper_immed  = ch_cat(func7, io.out_rs2, io.out_rs1, func3);
			}
			__default
			{
				io.out_upper_immed  = anything20;
			};

		// JAL 
		__switch(curr_opcode)
			__case(JAL_INST)
			{
				ch_bit<8>  b_19_to_12      = ch_slice<8>(io.in_instruction >> 12);
				ch_bit<1>  b_11            = io.in_instruction[20];
				ch_bit<10> b_10_to_1       = ch_slice<10>(io.in_instruction >> 21);
				ch_bit<1>  b_20            = io.in_instruction[31];
				ch_bit<1>  b_0             = ch_bit<1>(0);
				ch_bit<21> unsigned_offset = ch_cat(b_20, b_19_to_12, b_11, b_10_to_1, b_0);
       		 	ch_bit<32> offset          = ch_sel(b_20.as_uint() == 1, ch_cat(ONES_11BITS, unsigned_offset), ch_resize<32>(unsigned_offset));

       		 	io.out_jal        = JUMP;
				io.out_jal_offset = offset;
			}
			__case(JALR_INST)
			{
				ch_bit<12> jalr_immed = ch_cat(func7, io.out_rs2);
        		ch_bit<32> offset     = ch_sel(jalr_immed[11] == 1, ch_cat(ONES_20BITS, jalr_immed), ch_resize<32>(jalr_immed));

        		io.out_jal        = JUMP;
				io.out_jal_offset = offset;
			}
			__case(SYS_INST)
			{
				ch_bool cond1 = func3.as_uint() == 0;
				ch_bool cond2 = u_12.as_uint()  <  2;

				__if (cond1 && cond2)
				{
					io.out_jal          = JUMP;
					io.out_jal_offset   = ch_bit<32>(0xb0000000);
				} __else
				{
					io.out_jal          = NO_JUMP;
					io.out_jal_offset   = anything32;
				};
			}
			__default
			{
				io.out_jal          = NO_JUMP;
				io.out_jal_offset   = anything32;
			};


		// CSR
		ch_bool csr_cond1  = func3.as_uint() != 0;
		ch_bool csr_cond2  = u_12.as_uint()  >= 2;
		ch_bool csr_cond3  = curr_opcode     == curr_opcode;
		io.out_csr_address = ch_sel(csr_cond1 && csr_cond2 && csr_cond3, u_12, anything);


		// ITYPE IMEED
		ch_bit<12> tempp;
		__switch(curr_opcode)
			__case(ALU_INST)
			{
				ch_bool shift_i = (func3 == 1) || (func3 == 5);
				// ch_bit<12> shift_i_immediate = ch_cat(ch_bit<7>(0), io.out_rs2);
        		ch_bit<12> shift_i_immediate = ch_resize<12>(io.out_rs2);

        		tempp              = ch_sel(shift_i, shift_i_immediate, u_12);
				io.out_itype_immed = ch_sel(tempp[11] == 1, ch_cat(ONES_20BITS, tempp), ch_resize<32>(tempp));
			}
			__case(S_INST)
			{
				tempp              = ch_cat(func7, io.out_rd);
				io.out_itype_immed = ch_sel(tempp[11] == 1, ch_cat(ONES_20BITS, tempp), ch_resize<32>(tempp));
			}
			__case(L_INST)
			{
				tempp = ch_bit<12>(0);
				io.out_itype_immed = ch_sel(u_12[11] == 1, ch_cat(ONES_20BITS, u_12), ch_resize<32>(u_12));
			}
			__case(B_INST)
			{
				ch_bit<1> b_12      = io.in_instruction[31];
				ch_bit<1> b_11      = io.in_instruction[7];
				ch_bit<4> b_1_to_4  = ch_slice<4>(io.in_instruction >> 8);
				ch_bit<6> b_5_to_10 = ch_slice<6>(io.in_instruction >> 25);

				tempp              = ch_cat(b_12, b_11, b_5_to_10, b_1_to_4);
				io.out_itype_immed = ch_sel(b_12 == 1, ch_cat(ONES_20BITS, tempp), ch_resize<32>(tempp));
			}
			__default
			{
				tempp = ch_bit<12>(0);
				io.out_itype_immed = anything32;
			};


		__switch(curr_opcode)
			__case(B_INST)
			{
				io.out_branch_stall = STALL;

				//ch_print("BRANCH INSTRUCTION: {0}\tOFFSET: {1}", io.in_instruction, (io.out_itype_immed << 1));

				__switch(func3.as_uint())
					__case(0)
					{
						io.out_branch_type = BEQ;
					}
					__case(1)
					{
						io.out_branch_type = BNE;
					}
					__case(4)
					{
						io.out_branch_type = BLT;
					}
					__case(5)
					{
						io.out_branch_type = BGT;
					}
					__case(6)
					{
						io.out_branch_type = BLTU;
					}
					__case(7)
					{
						io.out_branch_type = BGTU;
					}
					__default
					{
						io.out_branch_type = NO_BRANCH; 
					};

			}
			__case(JAL_INST)
			{
				io.out_branch_type  = NO_BRANCH;
				io.out_branch_stall = STALL;


			}
			__case(JALR_INST)
			{
				io.out_branch_type  = NO_BRANCH;
				io.out_branch_stall = STALL;

			}
			__default
			{
				io.out_branch_type  = NO_BRANCH;
				io.out_branch_stall = NO_STALL;
			};


		// ALU OP
		__switch(func3.as_uint())
			__case(0) 
			{
				ch_bool is_alu = curr_opcode == ALU_INST;
				alu_op = ch_sel(is_alu, ADD, ch_sel(func7.as_uint() == 0, ADD, SUB));
			}
			__case(1)
			{
				alu_op = SLLA;
			}
			__case(2)
			{
				alu_op = SLT;
			}
			__case(3)
			{
				alu_op = SLTU;
			}
			__case(4)
			{
				alu_op = XOR;
			}
			__case(5)
			{
				alu_op  = ch_sel(func7.as_uint() == 0, SRL, SRA);
			}
			__case(6)
			{
				alu_op = OR;
			}
			__case(7)
			{
				alu_op = AND;
			}
			__default
			{
				alu_op = NO_ALU; 
			};

		ch_bit<2> csr_type = ch_slice<2>(func3);
		ch_bit<4> csr_alu  = ch_sel(csr_type == 1, CSR_ALU_RW,
								    ch_sel(csr_type == 2, CSR_ALU_RS,
								    	   ch_sel(csr_type == 3, CSR_ALU_RC,
								    	   	      NO_ALU)));

		io.out_alu_op = ch_sel(is_btype, ch_sel(io.out_branch_type.as_uint() < (BLTU_int) , SUB, SUBU), 
							  ch_sel(is_lui, LUI_ALU,
							  	     ch_sel(is_auipc, AUIPC_ALU,
							  	     	    ch_sel(is_csr, csr_alu,
							  	     	           ch_sel(is_stype || is_linst, ADD, alu_op)))));


	}


	ch_module<RegisterFile> registerfile;

};


