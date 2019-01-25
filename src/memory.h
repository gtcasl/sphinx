#include <cash.h>
#include <ioport.h>
#include "buses.h"

#include "literals.h"
#include "cache.h"

#include <math.h>

using namespace ch::logic;
using namespace ch::system;


struct Cache_driver
{
	__io(
		(DBUS_io) DBUS,

		__in(ch_bit<32>)  in_address,
		__in(ch_bit<3>)   in_mem_read,
		__in(ch_bit<3>)   in_mem_write,
		__in(ch_bit<32>)  in_data,

		__out(ch_bool)    out_delay,
		__out(ch_bit<32>) out_data
	);

	void describe()
	{


		// ch_print("****************");
		// ch_print("CACHE");
		// ch_print("****************");		


		ch_bool mem_write_enable = io.in_mem_write.as_uint() < NO_MEM_WRITE_int;
		ch_bool mem_read_enable  = io.in_mem_read.as_uint() < NO_MEM_WRITE_int;

		// ch_print("io.in_mem_write: {0}\tio.in_mem_read: {1}", io.in_mem_write, io.in_mem_read);


		//  READING MEMORY

		#ifdef DCACHE_ENABLE

			cache.io.DBUS(io.DBUS);
			cache.io.way_i.in_address = io.in_address;
			cache.io.way_i.in_data    = io.in_data;
			cache.io.way_i.in_rw      = mem_write_enable;
			cache.io.way_i.in_valid   = mem_write_enable || mem_read_enable;
			cache.io.way_i.in_control = ch_sel(mem_write_enable, io.in_mem_write, io.in_mem_read);
			

			// ch_print("io.out_delay: {0}", cache.io.out_delay);

			io.out_data  = cache.io.out_data;
			io.out_delay = cache.io.out_delay;

		#else


			io.DBUS.out_rw            = mem_write_enable;
			io.DBUS.out_address.data  = io.in_address;
			io.DBUS.out_address.valid = mem_write_enable || mem_read_enable;

			io.DBUS.out_control.data  = ch_sel(mem_write_enable, io.in_mem_write, io.in_mem_read);;
			io.DBUS.out_control.valid = TRUE;

			io.DBUS.out_data.data     = io.in_data;
			io.DBUS.out_data.valid    = mem_write_enable || mem_read_enable;

			io.DBUS.in_data.ready     = mem_write_enable || mem_read_enable;

			io.DBUS.out_miss          = FALSE;

			// ch_print("io.out_delay: {0}", cache.io.out_delay);

			io.out_data  = io.DBUS.in_data.data;
			
			io.out_delay = FALSE;

		#endif

	}

	#ifdef DCACHE_ENABLE
	ch_module<Cache<DCACHE_SIZE, DLINE_SIZE, DNUM_WAYS>> cache;
	#endif
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
		__out(ch_bool)    out_delay,
		#ifdef BRANCH_WB
		__out(ch_bit<1>)  out_branch_stall,
		#endif
		__out(ch_bit<32>)   out_PC_next
	);

	void describe()
	{

		// ch_print("****************");
		// ch_print("MEMORY");
		// ch_print("****************");		

		io.out_delay = cache_driver.io.out_delay;



		// ch_print("rd: {0}, alu_result: {1}, mem_result: {2}, in_data: {3}, mem_write: {4}, mem_read: {5}", io.in_rd, io.in_alu_result, io.out_mem_result, io.in_rd2, io.in_mem_write, io.in_mem_read);

		cache_driver.io.DBUS(io.DBUS);
		cache_driver.io.in_address = io.in_alu_result.as_uint();
		cache_driver.io.in_mem_read = io.in_mem_read;
		cache_driver.io.in_mem_write = io.in_mem_write;
		cache_driver.io.in_data = io.in_rd2;



		// __if(io.in_mem_read.as_uint() < NO_MEM_WRITE_int)
		// {
		// 	ch_print("--------------------------> {0} = {1}", io.in_alu_result, cache_driver.io.out_data);
		// } __else
		// {
		// 	ch_print("**************************> PC: {0}", io.in_curr_PC);
		// };

		// ch_print("io.in_curr_PC: {0}", io.in_curr_PC);


		io.out_mem_result = cache_driver.io.out_data;

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

		#ifdef BRANCH_WB
		io.out_branch_stall = ch_sel(io.in_branch_type.as_uint() == NO_BRANCH_int, NO_STALL, STALL);
		#endif
	}

	ch_module<Cache_driver> cache_driver;

};
