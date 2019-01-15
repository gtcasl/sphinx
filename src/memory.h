#include <cash.h>
#include <ioport.h>
#include "buses.h"

#include "utils.h"
#include <math.h>

using namespace ch::logic;
using namespace ch::system;

template<unsigned cache_size, unsigned line_size, unsigned num_ways>
struct Cache
{

	__io(
		(DBUS_io)         DBUS,
		__in(ch_bit<3> )  in_control,
		__in(ch_bool   )  in_rw,

		__in(ch_bit<32>)  in_address,
		__in(ch_bit<32>)  in_data,
		__in(ch_bool   )  in_valid,


		__out(ch_bit<32>) out_data,
		__out(ch_bool)    out_delay
	);

	void describe()
	{


		constexpr unsigned way_size    = cache_size / num_ways; // in bytes
		constexpr unsigned way_bits    = log2(way_size);
		constexpr unsigned num_lines   = way_size / line_size;

		constexpr unsigned tag_bits    = 32 - way_bits;

		constexpr unsigned line_bits   = log2(line_size);
		constexpr unsigned index_bits  = log2(num_lines);



		ch_mem<ch_bit<8>        , way_size  > data_cache;
		ch_mem<ch_bit<tag_bits> , num_lines > tag_cache;
		ch_mem<ch_bool          , num_lines > valid_cache;

		ch_reg<ch_bit<way_bits>> miss_addr(0);
		ch_reg<ch_bool> in_data_validity(false);


		auto in_tag   = ch_slice<tag_bits>(io.in_address >> way_bits);
		auto in_index = ch_slice<index_bits>(io.in_address >> line_bits);
		auto in_addr  = ch_slice<way_bits>(io.in_address);

		auto curr_tag   = tag_cache.read(in_index);
		auto curr_valid = valid_cache.read(in_index);


		auto miss     = (in_tag != curr_tag)  && curr_valid && io.in_valid;
		auto copying  = miss                  || io.DBUS.in_data.valid;


		in_data_validity->next = io.DBUS.in_data.valid;
		

		auto new_miss_addr  = ch_cat(in_index, ch_bit<line_bits>(0));
		auto next_miss_addr = miss_addr.as_uint() + ch_uint<way_bits>(4);


		miss_addr->next = ch_sel(io.DBUS.in_data.valid, next_miss_addr, new_miss_addr);

		auto data_w_indx = ch_sel(copying, miss_addr, in_addr);
		
		auto Abyte0 = data_w_indx;
		auto Abyte1 = data_w_indx.as_uint() + ch_uint<way_bits>(1);
		auto Abyte2 = data_w_indx.as_uint() + ch_uint<way_bits>(2);
		auto Abyte3 = data_w_indx.as_uint() + ch_uint<way_bits>(3);

		auto byte0 = data_cache.read(Abyte0);
		auto byte1 = data_cache.read(Abyte1);
		auto byte2 = data_cache.read(Abyte2);
		auto byte3 = data_cache.read(Abyte3);

		// LB_SB = 0
		// LH_SH = 1
		// LW_SW = 2
		// LBU   = 3
		// LHU   = 4

		ch_bool Wbyte0;
		ch_bool Wbyte1;
		ch_bool Wbyte2;
		ch_bool Wbyte3;
		ch_bit<32> mem_out;
		__switch(io.in_control)
			__case(0)
			{
				// LB
				ch_bit<24> ones(ONES_24BITS);
				ch_bit<24> zeros(ZERO);
					
				mem_out =  ch_sel(byte0[7] == 1, ch_cat(ones, byte0), ch_resize<32>(byte0));
				Wbyte0 = TRUE;
				Wbyte1 = FALSE;
				Wbyte2 = FALSE;
				Wbyte3 = FALSE;
			}
			__case(1)
			{
				// LH sign extend
				ch_bit<16> ones(ONES_16BITS);
				ch_bit<16> zeros(ZERO);
				
				ch_bit<16> half = ch_cat(byte1, byte0);
				mem_out = ch_sel(half[15] == 1, ch_cat(ones, half), ch_resize<32>(half));
				Wbyte0 = TRUE;
				Wbyte1 = TRUE;
				Wbyte2 = FALSE;
				Wbyte3 = FALSE;
			}
			__case(2)
			{
				mem_out = ch_cat(byte3, byte2, byte1, byte0);
				Wbyte0 = TRUE;
				Wbyte1 = TRUE;
				Wbyte2 = TRUE;
				Wbyte3 = TRUE;
			}
			__case(4)
			{
				mem_out = ch_resize<32>(byte0);
				Wbyte0 = FALSE;
				Wbyte1 = FALSE;
				Wbyte2 = FALSE;
				Wbyte3 = FALSE;
			}
			__case(5)
			{
				mem_out = ch_resize<32>(ch_cat(byte1, byte0));
				Wbyte0 = FALSE;
				Wbyte1 = FALSE;
				Wbyte2 = FALSE;
				Wbyte3 = FALSE;
			}
			__default
			{
				mem_out  = ch_bit<32>(0xdeadbeef);
				Wbyte0 = FALSE;
				Wbyte1 = FALSE;
				Wbyte2 = FALSE;
				Wbyte3 = FALSE;
			};

		io.out_data   = mem_out;
		io.out_delay  = copying || in_data_validity;


		tag_cache.write(  in_index , in_tag, miss );
		valid_cache.write(in_index , TRUE  , miss );



		auto data_to_write = ch_sel(copying, io.DBUS.in_data.data, io.in_data);

		data_cache.write(Abyte0, ch_slice<8>(data_to_write)      , copying || (io.in_rw && Wbyte0));
		data_cache.write(Abyte1, ch_slice<8>(data_to_write >> 8) , copying || (io.in_rw && Wbyte1));
		data_cache.write(Abyte2, ch_slice<8>(data_to_write >> 16), copying || (io.in_rw && Wbyte2));
		data_cache.write(Abyte3, ch_slice<8>(data_to_write >> 24), copying || (io.in_rw && Wbyte3));


		io.DBUS.out_rw            = io.in_rw;
		io.DBUS.out_address.data  = io.in_address;
		io.DBUS.out_address.valid = io.in_valid;

		io.DBUS.out_control.data  = io.in_control;
		io.DBUS.out_control.valid = TRUE;

		io.DBUS.out_data.data     = io.in_data;
		io.DBUS.out_data.valid    = io.in_valid;

		io.DBUS.in_data.ready     = io.in_valid;
		io.DBUS.out_miss          = miss;


	}

};

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



		//  READING MEMORY

		cache.io.DBUS(io.DBUS);
		cache.io.in_address = io.in_address;
		cache.io.in_data    = io.in_data;
		cache.io.in_rw      = mem_write_enable;
		cache.io.in_valid   = mem_write_enable || mem_read_enable;
		cache.io.in_control = ch_sel(mem_write_enable, io.in_mem_write, io.in_mem_read);
		
		

		io.out_data  = cache.io.out_data;
		io.out_delay = cache.io.out_delay;

	}

	ch_module<Cache<32KB, 256, 1>> cache;
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


			// io.DBUS.out_address.data  = io.in_address;
			// io.DBUS.out_address.valid = io.in_address_valid;

			// io.DBUS.out_control.data  = io.in_control;
			// io.DBUS.out_control.valid = TRUE;

			// io.DBUS.out_data.data     = io.in_data;
			// io.DBUS.out_data.valid    = io.in_data_valid;

			// io.DBUS.in_data.ready     = io.in_data_ready;


			// ch_mem<ch_bit<DLINE_BIT_SIZE>, DNUM_LINES> data_cache;
			// ch_mem<ch_uint<32>           , DNUM_LINES> tag_cache;
			// ch_mem<ch_bool               , DNUM_LINES> valid_cache;



			// ch_bool flush(FALSE);




			// // Getting infro from the address
			// auto line_index  = ch_resize<DNUM_BITS>(io.in_address.as_uint() >> DLINE_BITS);
			// auto line_offset = ch_resize<DOFFSET_BITS>(io.in_address).as_uint() << 3;
			// auto line_tag    = io.in_address.as_uint() & ch_uint<32>(DTAG_MASK);


			// // Getting info from cache
			// auto real_line  = data_cache.read(line_index);
			// auto real_valid = valid_cache.read(line_index);
			// auto real_tag   = tag_cache.read(line_index);




			// // checking if there is a cache miss or if cache is currently receiving data from RAM




			// // Telling RAM if it was a miss
			// io.DBUS.out_miss    = dcache_miss;
			// // Telling the pipeline if it's a miss or if currently copying a line into cache
			// auto dcache_miss = (line_tag != real_tag)  && real_valid && io.in_address_valid;
			// auto copying     = dcache_miss             || io.DBUS.in_data.valid;
			// ch_reg<ch_bool> in_data_validity(false);
			// in_data_validity->next = io.DBUS.in_data.valid;
			// io.out_delay        = copying || in_data_validity;

			// // outputting data if it's a load operation
			// io.out_data         = ch_sel( !copying, ch_resize<32>(real_line >> line_offset), 0x0);


			// auto bus_data      = (real_line << ch_uint(32)) | ch_pad<DLINE_BIT_SIZE - 32>(io.DBUS.in_data.data);


			// // Blending the current line
			// auto mask          =    ch_bit<DLINE_BIT_SIZE>(GENERIC_DMASK) << line_offset;
			// auto input_word    = ch_resize<DLINE_BIT_SIZE>(io.in_data)    << line_offset;
			// auto load_data     = real_line ^ ((real_line ^ input_word) & mask);


			// auto data_to_write = ch_sel(dcache_miss, ch_bit<DLINE_BIT_SIZE>(0), ch_sel(copying, bus_data, load_data));


			// tag_cache.write(  line_index , line_tag      , dcache_miss);
			// valid_cache.write(line_index , !flush        , dcache_miss || flush);
			// data_cache.write( line_index , data_to_write , copying     || (io.in_control == DBUS_RW) || (io.in_control == DBUS_WRITE));