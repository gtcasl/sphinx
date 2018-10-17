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

		// INFO FROM EXE
		__in(ch_bit<5>)  in_execute_dest,
		__in(ch_bit<2>)  in_execute_wb,
		__in(ch_bit<32>) in_execute_alu_result,
		__in(ch_bit<32>) in_execute_PC_next,

		// INFO FROM MEM
		__in(ch_bit<5>)  in_memory_dest,
		__in(ch_bit<2>)  in_memory_wb,
		__in(ch_bit<32>) in_memory_alu_result,
		__in(ch_bit<32>) in_memory_mem_data,
		__in(ch_bit<32>) in_memory_PC_next,

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


		io.out_src1_fwd  = src1_exe_fwd || src1_mem_fwd || src1_wb_fwd;

		io.out_src1_fwd_data = ch_sel( src1_exe_fwd, ch_sel(exe_jal, io.in_execute_PC_next, io.in_execute_alu_result),
			                        ch_sel( src1_mem_fwd, ch_sel(mem_jal, io.in_memory_PC_next, ch_sel(mem_mem_read, io.in_memory_mem_data, io.in_memory_alu_result)),
									    ch_sel( src1_wb_fwd,  ch_sel(wb_jal, io.in_writeback_PC_next, ch_sel(wb_mem_read,  io.in_writeback_mem_data, io.in_writeback_alu_result)),
										 	anything32)));


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


		io.out_src2_fwd  = src2_exe_fwd || src2_mem_fwd || src2_wb_fwd;

		io.out_src2_fwd_data = ch_sel( src2_exe_fwd, ch_sel(exe_jal, io.in_execute_PC_next, io.in_execute_alu_result),
			                        ch_sel( src2_mem_fwd, ch_sel(mem_jal, io.in_memory_PC_next, ch_sel(mem_mem_read, io.in_memory_mem_data, io.in_memory_alu_result)),
									    ch_sel( src2_wb_fwd,  ch_sel(wb_jal, io.in_writeback_PC_next, ch_sel(wb_mem_read,  io.in_writeback_mem_data, io.in_writeback_alu_result)),
										 	anything32)));



		io.out_fwd_stall = ch_sel((src1_exe_fwd || src2_exe_fwd) && exe_mem_read, STALL, NO_STALL);

		__if(io.out_fwd_stall.as_uint() == STALL)
		{
			ch_print("###############FWD STALL");
		};

	}

};

