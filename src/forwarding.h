#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;


struct Forwarding
{
	__io(
		// INFO FROM DECODE
		__in(ch_bit<5>)  in_decode_src1,
		__in(ch_bit<5>)  in_decode_src2,
		__in(ch_bit<12>) in_decode_csr_address, 

		// INFO FROM EXE
		__in(ch_bit<5>)  in_execute_dest,
		__in(ch_bit<2>)  in_execute_wb,
		__in(ch_bit<32>) in_execute_alu_result,
		__in(ch_bit<32>) in_execute_PC_next,
		__in(ch_bit<1>)  in_execute_is_csr,
		__in(ch_bit<12>) in_execute_csr_address,
		__in(ch_bit<32>) in_execute_csr_result,

		// INFO FROM MEM
		__in(ch_bit<5>)  in_memory_dest,
		__in(ch_bit<2>)  in_memory_wb,
		__in(ch_bit<32>) in_memory_alu_result,
		__in(ch_bit<32>) in_memory_mem_data,
		__in(ch_bit<32>) in_memory_PC_next,
		__in(ch_bit<1>)  in_memory_is_csr,
		__in(ch_bit<12>) in_memory_csr_address,
		__in(ch_bit<32>) in_memory_csr_result,

		// INFO FROM WB
		__in(ch_bit<5>)  in_writeback_dest,
		__in(ch_bit<2>)  in_writeback_wb,
		__in(ch_bit<32>) in_writeback_alu_result,
		__in(ch_bit<32>) in_writeback_mem_data,
		__in(ch_bit<32>) in_writeback_PC_next,

		// OUT SIGNALS
		__out(ch_bit<1>)  out_src1_fwd,
		__out(ch_bit<32>) out_src1_fwd_data,
		__out(ch_bit<1>)  out_src2_fwd,
		__out(ch_bit<32>) out_src2_fwd_data,
		__out(ch_bit<1>)  out_csr_fwd,
		__out(ch_bit<32>) out_csr_fwd_data,
		__out(ch_bit<1>)  out_fwd_stall
	);

	void describe()
	{



		ch_bool exe_mem_read = (io.in_execute_wb.as_uint()   == WB_MEM_int);
		ch_bool mem_mem_read = (io.in_memory_wb.as_uint()    == WB_MEM_int);
		ch_bool wb_mem_read  = (io.in_writeback_wb.as_uint() == WB_MEM_int);

		ch_bool exe_jal = (io.in_execute_wb.as_uint()   == WB_JAL_int);
		ch_bool mem_jal = (io.in_memory_wb.as_uint()    == WB_JAL_int);
		ch_bool wb_jal  = (io.in_writeback_wb.as_uint() == WB_JAL_int);

		ch_bool exe_csr = (io.in_execute_is_csr == TRUE);
		ch_bool mem_csr = (io.in_memory_is_csr == TRUE);


		// SRC1
		ch_bool src1_exe_fwd = ((io.in_decode_src1.as_uint() == io.in_execute_dest.as_uint()) && 
								(io.in_decode_src1.as_uint() != ZERO_REG_int) &&
			                     (io.in_execute_wb.as_uint() != NO_WB_int));

		ch_bool src1_mem_fwd = ((io.in_decode_src1.as_uint() == io.in_memory_dest.as_uint()) &&
							    (io.in_decode_src1.as_uint() != ZERO_REG_int) &&
			                      (io.in_memory_wb.as_uint() != NO_WB_int) &&
			                      (!src1_exe_fwd));

		ch_bool src1_wb_fwd = ((io.in_decode_src1.as_uint() == io.in_writeback_dest.as_uint()) &&
							   (io.in_decode_src1.as_uint() != ZERO_REG_int) &&
			                  (io.in_writeback_wb.as_uint() != NO_WB_int) &&
			                      (!src1_exe_fwd) &&
			                      (!src1_mem_fwd));


		io.out_src1_fwd  = src1_exe_fwd || src1_mem_fwd || src1_wb_fwd; // COMMENT

		io.out_src1_fwd_data = ch_sel( src1_exe_fwd, ch_sel(exe_jal, io.in_execute_PC_next, io.in_execute_alu_result),
			                        ch_sel( src1_mem_fwd, ch_sel(mem_jal, io.in_memory_PC_next, ch_sel(mem_mem_read, io.in_memory_mem_data, io.in_memory_alu_result)),
									    ch_sel( src1_wb_fwd,  ch_sel(wb_jal, io.in_writeback_PC_next, ch_sel(wb_mem_read,  io.in_writeback_mem_data, io.in_writeback_alu_result)),
										 	anything32))); // COMMENT


		// SRC2
		ch_bool src2_exe_fwd = ((io.in_decode_src2.as_uint() == io.in_execute_dest.as_uint()) && 
								(io.in_decode_src2.as_uint() != ZERO_REG_int) &&
			                     (io.in_execute_wb.as_uint() != NO_WB_int));

		ch_bool src2_mem_fwd = ((io.in_decode_src2.as_uint() == io.in_memory_dest.as_uint()) &&
								(io.in_decode_src2.as_uint() != ZERO_REG_int) &&
			                      (io.in_memory_wb.as_uint() != NO_WB_int) &&
			                      (!src2_exe_fwd));

		ch_bool src2_wb_fwd = ((io.in_decode_src2.as_uint() == io.in_writeback_dest.as_uint()) &&
							   (io.in_decode_src2.as_uint() != ZERO_REG_int) &&
			                  (io.in_writeback_wb.as_uint() != NO_WB_int) &&
			                      (!src2_exe_fwd) &&
			                      (!src2_mem_fwd));


		io.out_src2_fwd  = src2_exe_fwd || src2_mem_fwd || src2_wb_fwd; // COMMENT

		io.out_src2_fwd_data = ch_sel( src2_exe_fwd, ch_sel(exe_jal, io.in_execute_PC_next, io.in_execute_alu_result),
			                        ch_sel( src2_mem_fwd, ch_sel(mem_jal, io.in_memory_PC_next, ch_sel(mem_mem_read, io.in_memory_mem_data, io.in_memory_alu_result)),
									    ch_sel( src2_wb_fwd,  ch_sel(wb_jal, io.in_writeback_PC_next, ch_sel(wb_mem_read,  io.in_writeback_mem_data, io.in_writeback_alu_result)),
										 	anything32))); // COMMENT


		// CSR
		ch_bool csr_exe_fwd = (io.in_decode_csr_address.as_uint() == io.in_execute_csr_address.as_uint()) && exe_csr;
		ch_bool csr_mem_fwd = (io.in_decode_csr_address.as_uint() == io.in_memory_csr_address.as_uint())  && mem_csr && !csr_exe_fwd;

		io.out_csr_fwd      = csr_exe_fwd || csr_mem_fwd; // COMMENT
		io.out_csr_fwd_data = ch_sel(csr_exe_fwd, io.in_execute_alu_result,
									 ch_sel(csr_mem_fwd, io.in_memory_csr_result,
									 	    anything32)); // COMMENT


		io.out_fwd_stall = ch_sel((src1_exe_fwd || src2_exe_fwd) && exe_mem_read, STALL, NO_STALL); // comment 


		// io.out_src1_fwd = FALSE;
		// io.out_src1_fwd_data = ch_bit<32>(0);
		// io.out_src2_fwd = FALSE;
		// io.out_src2_fwd_data = ch_bit<32>(0);
		// io.out_csr_fwd = FALSE;
		// io.out_csr_fwd_data = ch_bit<32>(0);
		// io.out_fwd_stall = src1_exe_fwd || src1_mem_fwd || src1_wb_fwd || src2_exe_fwd || src2_mem_fwd || src2_wb_fwd || csr_exe_fwd || csr_mem_fwd;



	}

};

