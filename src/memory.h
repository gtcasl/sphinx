#include <cash.h>
#include <ioport.h>
#include "buses.h"

// using namespace ch::logic;
// using namespace ch::system;


struct Cache
{
	__io(
		(DBUS_io) DBUS,

		__in(ch_bit<32>) in_address,
		__in(ch_bit<3>) in_mem_read,
		__in(ch_bit<3>) in_mem_write,
		__in(ch_bit<32>) in_data,

		__out(ch_bit<32>) out_data
	);

	void describe()
	{


		// ch_print("****************");
		// ch_print("CACHE");
		// ch_print("****************");		

		// ch_mem<ch_bit<32>, 16777216> mem_module;







		//  READING MEMORY
		io.DBUS.out_address.data  = io.in_address;
		io.DBUS.out_address.valid = (io.in_mem_read.as_uint() < NO_MEM_WRITE_int) || (io.in_mem_write.as_uint() < NO_MEM_WRITE_int);


		ch_bool read_word_enable  = (io.in_mem_read.as_uint()  <  NO_MEM_READ_int);

		ch_bool write_word_enable = (io.in_mem_write.as_uint() == SW_MEM_WRITE_int);
		ch_bool write_byte_enable = (io.in_mem_write.as_uint() == SB_MEM_WRITE_int);
		ch_bool write_half_enable = (io.in_mem_write.as_uint() == SH_MEM_WRITE_int);

		ch_bool no_rw_enable      = (io.in_mem_read.as_uint()  == NO_MEM_READ_int) && (io.in_mem_write.as_uint() == NO_MEM_WRITE_int);
		
		io.DBUS.out_control.data  = ch_sel(read_word_enable, DBUS_READ,
			                               ch_sel(write_word_enable, DBUS_WRITE,
			                                      ch_sel(no_rw_enable, DBUS_NONE, DBUS_RW)));
		io.DBUS.out_control.valid = TRUE;

		io.DBUS.in_data.ready     = read_word_enable || (!no_rw_enable && !write_word_enable);


		ch_bit<32> mem_result;
		__switch(io.in_mem_read.as_uint())
			__case(0) 
			{
				ch_bit<24> ones(ONES_24BITS);
				ch_bit<24> zeros(ZERO);
				
				// LB sign extend
				ch_bit<8> byte = ch_slice<8>(io.DBUS.in_data.data);
        mem_result = ch_sel(byte[7] == 1, ch_cat(ones, byte), ch_pad<32>(byte));
			}
			__case(1)
			{
				// LH sign extend
				ch_bit<16> ones(ONES_16BITS);
				ch_bit<16> zeros(ZERO);
				
				ch_bit<16> half = ch_slice<16>(io.DBUS.in_data.data);
        mem_result = ch_sel(half[15] == 1, ch_cat(ones, half), ch_pad<32>(half));
			}
			__case(2)
			{
				// LW
				mem_result = io.DBUS.in_data.data;
				// ch_print("Reading Addr: {0}, Value: {1}", io.in_address, mem_result);
			}
			__case(4)
			{
				ch_bit<24> zeros(ZERO);
				// LBU
				ch_bit<8> byte = ch_slice<8>(io.DBUS.in_data.data);
        mem_result = ch_pad<32>(byte);
			}
			__case(5)
			{
				ch_bit<16> zeros(0);

				// LHU
				ch_bit<16> half = ch_slice<16>(io.DBUS.in_data.data);
        mem_result = ch_pad<32>(half);
			}
			__default
			{
				mem_result = ch_bit<32>(0); 
			};

		io.out_data = mem_result;

		// ch_bit<24> writing_address(0);
		// ch_bit<32> writing_data(0);
		// ch_bool should_write(false);

		// __switch(io.in_mem_write.as_uint())
		// 	__case(0)
		// 	{
		// 		// SB
		// 		ch_bit<24> zeros(0);

		// 		writing_data    = ch_cat(zeros, ch_slice<8>(io.in_data)) | io.DBUS.in_data.data;
		// 		writing_address = ch_slice<24>(io.in_address); 
		// 		should_write    = TRUE;       

		// 	}
		// 	__case(1)
		// 	{
		// 		// SH
		// 		ch_bit<16> zeros(0);
				
		// 		writing_data    = ch_cat(zeros, ch_slice<16>(io.in_data)) | io.DBUS.in_data.data;
		// 		writing_address = ch_slice<24>(io.in_address);
		// 		should_write    = TRUE;
				

		// 	}
		// 	__case(2)
		// 	{
		// 		// SW
				
		// 		writing_data    = io.in_data;
		// 		writing_address = ch_slice<24>(io.in_address);
		// 		should_write    = TRUE;;

		// 		ch_print("Storing in address: {0}, value: {1}", ch_slice<24>(io.in_address), io.in_data);
		// 		ch_print("!!!!!!!!!!WARNING");
		// 	}
		// 	__default
		// 	{
		// 		should_write = FALSE;
		// 		ch_print("$$$$$$$$$$$WARNING");
		// 	};


		io.DBUS.out_data.data     = io.in_data;
		io.DBUS.out_data.valid    = (io.in_mem_write.as_uint() < NO_MEM_WRITE_int);

	}
};


struct Memory
{
	__io(
		(DBUS_io) DBUS,


		__in(ch_bit<32>)  in_alu_result,
		__in(ch_bit<3>)   in_mem_read, 
		__in(ch_bit<3>)   in_mem_write,
		__in(ch_bit<5>)   in_rd,
		__in(ch_bit<2>)   in_wb,
		__in(ch_bit<5>)   in_rs1,
		__in(ch_bit<32>)  in_rd1,
		__in(ch_bit<5>)   in_rs2,
		__in(ch_bit<32>)  in_rd2,
		__in(ch_bit<32>)  in_PC_next,
		__in(ch_bit<32>)  in_curr_PC,
		__in(ch_bit<32>)  in_branch_offset,
		__in(ch_bit<3>)   in_branch_type, 

		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<32>) out_mem_result,
		__out(ch_bit<5>)  out_rd,
		__out(ch_bit<2>)  out_wb,
		__out(ch_bit<5>)  out_rs1,
		__out(ch_bit<5>)  out_rs2,
		__out(ch_bit<1>)  out_branch_dir,
		__out(ch_bit<32>) out_branch_dest,


		__out(ch_bit<32>)   out_PC_next
	);

	void describe()
	{

		// ch_print("****************");
		// ch_print("MEMORY");
		// ch_print("****************");		


		// ch_print("rd: {0}, alu_result: {1}, mem_result: {2}, in_data: {3}, mem_write: {4}, mem_read: {5}", io.in_rd, io.in_alu_result, io.out_mem_result, io.in_rd2, io.in_mem_write, io.in_mem_read);

		cache.io.DBUS(io.DBUS);
		cache.io.in_address = io.in_alu_result.as_uint();
		cache.io.in_mem_read = io.in_mem_read;
		cache.io.in_mem_write = io.in_mem_write;
		cache.io.in_data = io.in_rd2;




		io.out_mem_result = cache.io.out_data;

		io.out_alu_result = io.in_alu_result;
		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;
		io.out_rs1 = io.in_rs1;
		io.out_rs2 = io.in_rs2;
		io.out_PC_next = io.in_PC_next;


		io.out_branch_dest = io.in_curr_PC.as_int() + (io.in_branch_offset.as_int() << 1);
		__switch(io.in_branch_type.as_uint())
			__case(BEQ_int)
			{
				//ch_print("BEQ INSTRUCTION IN EXE");
				//ch_print("RS1: {0}, RD1: {1}", io.in_rs1, io.in_rd1);
				//ch_print("RS2: {0}, RD2: {1}", io.in_rs2, io.in_rd2);
				//ch_print("ALU Result: {0}", io.out_alu_result);

				io.out_branch_dir = ch_sel(io.in_alu_result.as_uint() == 0, TAKEN, NOT_TAKEN);
				//ch_print("BEQ_int");
			}
			__case(BNE_int)
			{
				io.out_branch_dir = ch_sel(io.in_alu_result.as_uint() == 0, NOT_TAKEN, TAKEN);
			}
			__case(BLT_int)
			{
				io.out_branch_dir = ch_sel(io.in_alu_result[31] == 0, NOT_TAKEN, TAKEN);
				//ch_print("BRANCH: is {0} < {1}? The answer is: {2}, ALU_RESULT: {3}", ALU_in1, ALU_in2, io.out_branch_dir, io.in_alu_result);
			}
			__case(BGT_int)
			{
				io.out_branch_dir = ch_sel(io.in_alu_result[31] == 0, TAKEN, NOT_TAKEN);
				//ch_print("BGT_int");
				//ch_print("BRANCH: sr1 {0}, src2: {1}", io.in_rs1, io.in_rs2);
				//ch_print("BRANCH: is {0} > {1}? The answer is: {2}, ALU_RESULT: {3}", ALU_in1, ALU_in2, io.out_branch_dir, io.in_alu_result);
			}
			__case(BLTU_int)
			{
				io.out_branch_dir = ch_sel(io.in_alu_result[31] == 0, NOT_TAKEN, TAKEN);
				//ch_print("BLTU_int: {0}", io.out_branch_dir);
			}
			__case(BGTU_int)
			{
				io.out_branch_dir = ch_sel(io.in_alu_result[31] == 0, TAKEN, NOT_TAKEN);
				//ch_print("BGTU_int: RESULT: {0}", io.out_branch_dir);
			}
			__case(NO_BRANCH_int)
			{
				io.out_branch_dir = NOT_TAKEN;
				//ch_print("NO_B_int");
			}
			__default
			{
				io.out_branch_dir = NOT_TAKEN;
				//ch_print("Default_b_int");
			};
	}

	ch_module<Cache> cache;

};
