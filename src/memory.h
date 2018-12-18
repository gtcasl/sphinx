#include <cash.h>
#include <ioport.h>
#include "buses.h"

using namespace ch::logic;
using namespace ch::system;


struct DCACHE
{

	__io(
		(DBUS_io) DBUS,
		__in(ch_bit<2> )  in_control,
		__in(ch_bit<32>)  in_data,
		__in(ch_bool   )  in_data_valid,

		__in(ch_bool   )  in_data_ready,
		__in(ch_bit<32>)  in_address,
		__in(ch_bool   )  in_address_valid,


		__out(ch_bit<32>) out_data,
		__out(ch_bool)    out_delay
	);

	void describe()
	{

		

		#ifndef DCACHE_ENABLE

			io.DBUS.out_address.data  = io.in_address;
			io.DBUS.out_address.valid = io.in_address_valid;
			
			io.DBUS.out_control.data  = io.in_control;
			io.DBUS.out_control.valid = TRUE;

			io.DBUS.out_data.data     = io.in_data;
			io.DBUS.out_data.valid    = io.in_data_valid;

			io.DBUS.out_miss          = FALSE;


			io.DBUS.in_data.ready     = io.in_data_ready;
			io.out_data               = io.DBUS.in_data.data;

			io.out_delay              = FALSE;

		#else

				// ch_print("****************");
			ch_reg<ch_bool> first_cycle(true);
			first_cycle->next = FALSE;

			// ch_print("ADDRESS: {0} <- {1}", io.in_address, io.in_address_valid);

			ch_mem<ch_bit<DLINE_BIT_SIZE>, DNUM_LINES> data_cache;
			ch_mem<ch_uint<32>           , DNUM_LINES> tag_cache;
			

			io.DBUS.out_address.data  = io.in_address;


			// ch_print("DCACHE OUTPUT ADDRESS: {0}", io.in_address);

			// ch_print("ITAG_BITS: {0}, INUM_LINES: {1}", ch_uint(ITAG_BITS), ch_uint(INUM_LINES));

			auto line_index  = ch_resize<DNUM_BITS>(io.in_address.as_uint()    >> DLINE_BITS);
			// auto curr_tag    = ch_resize<32>(io.in_address.as_uint()    >> IG_TAG_BITS) >> 20;
			ch_uint<32> curr_tag    = io.in_address.as_uint() & ch_uint<32>(DTAG_MASK);
			auto data_offset = ch_resize<DOFFSET_BITS>(io.in_address).as_uint() << 3;


	


			io.DBUS.out_data.data     = io.in_data;

			auto cache_tag      = tag_cache.read(line_index);
			ch_bool dcache_miss = (curr_tag != cache_tag) && !first_cycle && io.in_address_valid;

			// ch_print("tags: {0} != {1}", curr_tag, cache_tag);

			io.DBUS.out_miss = dcache_miss;
			

			io.DBUS.out_address.valid = io.in_address_valid;

			ch_reg<ch_bool> in_data_validity(false);

			in_data_validity->next = (io.DBUS.in_data.valid);

			ch_bool copying           = dcache_miss || (io.DBUS.in_data.valid);

			io.out_delay              = copying || in_data_validity;


			io.DBUS.in_data.ready     = TRUE;

			ch_bit<DLINE_BIT_SIZE> real_line = data_cache.read(line_index);
			io.out_data                      = ch_sel( !copying, ch_resize<32>(real_line >> data_offset), 0x0);

			// ch_print("dcache_miss {1}, actul_copying: {2}, out_delay: {0}", copying, dcache_miss, io.DBUS.in_data.valid);

			ch_bit<DLINE_BIT_SIZE> new_data      = (real_line << ch_uint(32)) | ch_pad<DLINE_BIT_SIZE - 32>(io.DBUS.in_data.data);


			// ch_bit<DLINE_BIT_SIZE> what          = ch_bit<DLINE_BIT_SIZE>(1).as_bit();
			// ch_bit<DLINE_BIT_SIZE> whatt         = (ch_int<DLINE_BIT_SIZE>(-1) & (ch_cat(ch_int<DLINE_BIT_SIZE - 32>(-1), io.in_data) << data_offset));
			// ch_bit<DLINE_BIT_SIZE> mask          = whatt | ((what << data_offset).as_int() - 1);

			// ch_bit<DLINE_BIT_SIZE> write_data    = (real_line | mask ) & mask;


			// __if(io.in_control == DBUS_WRITE)
			// {
			// 	ch_print("----------------------");
			// 	ch_print("io.in_data: {0}", io.in_data);
			// 	ch_print("BEFORE: {0}", real_line);
			// 	ch_print("MASK: {0}", mask);
			// 	ch_print("data_offset: {0}", data_offset);
			// 	ch_print("AFTER: {0}", write_data);
			// 	ch_print("----------------------");

			// };

			ch_bit<DLINE_BIT_SIZE> data_to_write = ch_sel(dcache_miss, ch_bit<DLINE_BIT_SIZE>(0), new_data);

			// ch_bit<DLINE_BIT_SIZE> data_to_write = ch_sel(io.in_control == DBUS_WRITE, write_data, ch_sel(dcache_miss, ch_bit<DLINE_BIT_SIZE>(0), new_data));





			tag_cache.write(line_index , curr_tag      , dcache_miss);
			data_cache.write(line_index, data_to_write , copying);

			// ch_print("[0] {0}", data_to_write);




			// __if(dcache_miss)
			// {
			// 	ch_print("writing {0} to {1}", curr_tag, line_index);
			// };

			
			io.DBUS.out_control.data  = io.in_control;
			io.DBUS.out_control.valid = TRUE;

			io.DBUS.out_data.valid    = io.in_data_valid;


			io.DBUS.in_data.ready     = io.in_data_ready;


		#endif

	}

};

struct Cache
{
	__io(
		(DBUS_io) DBUS,

		__in(ch_bit<32>) in_address,
		__in(ch_bit<3>) in_mem_read,
		__in(ch_bit<3>) in_mem_write,
		__in(ch_bit<32>) in_data,

		__out(ch_bool) out_delay,
		__out(ch_bit<32>) out_data
	);

	void describe()
	{


		// ch_print("****************");
		// ch_print("CACHE");
		// ch_print("****************");		


		io.out_delay = dcache.io.out_delay;

		//  READING MEMORY

		dcache.io.DBUS(io.DBUS);
		

		dcache.io.in_address       = io.in_address;
		dcache.io.in_address_valid = (io.in_mem_read.as_uint() < NO_MEM_WRITE_int) || (io.in_mem_write.as_uint() < NO_MEM_WRITE_int);


		ch_bool read_word_enable  = (io.in_mem_read.as_uint()  <  NO_MEM_READ_int);

		ch_bool write_word_enable = (io.in_mem_write.as_uint() == SW_MEM_WRITE_int);
		// ch_bool write_byte_enable = (io.in_mem_write.as_uint() == SB_MEM_WRITE_int);
		// ch_bool write_half_enable = (io.in_mem_write.as_uint() == SH_MEM_WRITE_int);

		ch_bool no_rw_enable      = (io.in_mem_read.as_uint()  == NO_MEM_READ_int) && (io.in_mem_write.as_uint() == NO_MEM_WRITE_int);
		
		dcache.io.in_control      = ch_sel(read_word_enable, DBUS_READ,
			                               ch_sel(write_word_enable, DBUS_WRITE,
			                                      ch_sel(no_rw_enable, DBUS_NONE, DBUS_RW)));
		

		dcache.io.in_data_ready   = read_word_enable || (!no_rw_enable && !write_word_enable);


		ch_bit<32> mem_result;
		__switch(io.in_mem_read.as_uint())
			__case(0) 
			{
				ch_bit<24> ones(ONES_24BITS);
				ch_bit<24> zeros(ZERO);
				
				// LB sign extend
				ch_bit<8> byte = ch_slice<8>(dcache.io.out_data);
        		mem_result = ch_sel(byte[7] == 1, ch_cat(ones, byte), ch_resize<32>(byte));
			}
			__case(1)
			{
				// LH sign extend
				ch_bit<16> ones(ONES_16BITS);
				ch_bit<16> zeros(ZERO);
				
				ch_bit<16> half = ch_slice<16>(dcache.io.out_data);
        		mem_result = ch_sel(half[15] == 1, ch_cat(ones, half), ch_resize<32>(half));
			}
			__case(2)
			{
				// LW
				mem_result = dcache.io.out_data;
				// ch_print("Reading Addr: {0}, Value: {1}", io.in_address, mem_result);
			}
			__case(4)
			{
				ch_bit<24> zeros(ZERO);
				// LBU
				ch_bit<8> byte = ch_slice<8>(dcache.io.out_data);
        		mem_result = ch_resize<32>(byte);
			}
			__case(5)
			{
				ch_bit<16> zeros(0);

				// LHU
				ch_bit<16> half = ch_slice<16>(dcache.io.out_data);
        		mem_result = ch_resize<32>(half);
			}
			__default
			{
				mem_result = ch_bit<32>(0); 
			};

		io.out_data = mem_result;


		dcache.io.in_data       = io.in_data;
		dcache.io.in_data_valid = (io.in_mem_write.as_uint() < NO_MEM_WRITE_int);


	}

	ch_module<DCACHE> dcache;
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

		io.out_delay = cache.io.out_delay;


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

		#ifdef BRANCH_WB
		io.out_branch_stall = ch_sel(io.in_branch_type.as_uint() == NO_BRANCH_int, NO_STALL, STALL);
		#endif
	}

	ch_module<Cache> cache;

};
