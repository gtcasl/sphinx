#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


struct Cache
{
	__io(
		__in(ch_bit<24>) in_address,
		__in(ch_bit<3>) in_mem_read,
		__in(ch_bit<3>) in_mem_write,
		__in(ch_bit<32>) in_data,

		__out(ch_bit<32>) out_data
	);

	void describe()
	{


		ch_print("****************");
		ch_print("CACHE");
		ch_print("****************");		

		ch_mem<ch_bit<32>, 16777216> mem_module;

		ch_print("MEM_VALUE @ 0x35: {0}", mem_module.read(ch_bit<24>(0x35)));

		ch_bit<32> mem_result(0);

		__switch(io.in_mem_read.as_uint())
			__case(0) 
			{
				ch_bit<24> ones(ONES_24BITS);
				ch_bit<24> zeros(ZERO);
				
				// LB sign extend
				ch_bit<8> byte = ch_slice<8>(mem_module.read(ch_slice<24>(io.in_address)));
				mem_result = ch_sel(byte[7] == 1, ch_cat(ones, byte), ch_cat(zeros, byte));
			}
			__case(1)
			{
				// LH sign extend
				ch_bit<16> ones(ONES_16BITS);
				ch_bit<16> zeros(ZERO);
				
				ch_bit<16> half = ch_slice<16>(mem_module.read(ch_slice<24>(io.in_address)));
				mem_result = ch_sel(half[15] == 1, ch_cat(ones, half), ch_cat(zeros, half));
			}
			__case(2)
			{
				// LW
				mem_result = mem_module.read(ch_slice<24>(io.in_address));
				ch_print("Reading Addr: {0}, Value: {1}", io.in_address, mem_result);
			}
			__case(4)
			{
				ch_bit<24> zeros(ZERO);
				// LBU
				ch_bit<8> byte = ch_slice<8>(mem_module.read(ch_slice<24>(io.in_address)));
				mem_result = ch_cat(zeros, byte);
			}
			__case(5)
			{
				ch_bit<16> zeros(0);

				// LHU
				ch_bit<16> half = ch_slice<16>(mem_module.read(ch_slice<24>(io.in_address)));
				mem_result = ch_cat(zeros, half);
			}
			__default
			{
				mem_result = ch_bit<32>(0); 
			};


		__switch(io.in_mem_write.as_uint())
			__case(0)
			{
				// SB
				ch_bit<24> zeros(0);
				ch_bit<32> word = ch_cat(zeros, ch_slice<8>(io.in_data)) | mem_module.read(ch_slice<24>(io.in_address));
				ch_bit<24> address = ch_slice<24>(io.in_address);
				mem_module.write(address.as_uint(), word, TRUE);
				ch_print("!!!!!!!!!!WARNING");
			}
			__case(1)
			{
				// SH
				ch_bit<16> zeros(0);
				ch_bit<32> word = ch_cat(zeros, ch_slice<16>(io.in_data)) | mem_module.read(ch_slice<24>(io.in_address));
				mem_module.write(ch_slice<24>(io.in_address), word, TRUE);
				ch_print("!!!!!!!!!!WARNING");
			}
			__case(2)
			{
				// SW
				mem_module.write(ch_slice<24>(io.in_address), io.in_data, TRUE);
				ch_print("Storing in address: {0}, value: {1}", ch_slice<24>(io.in_address), io.in_data);
				ch_print("!!!!!!!!!!WARNING");
			}
			__default
			{
				// mem_module.write(ch_slice<24>(io.in_address), io.in_data, FALSE);
				ch_print("$$$$$$$$$$$WARNING");
			};

		io.out_data = mem_result;

	}
};


struct Memory
{
	__io(
		__in(ch_bit<32>) in_alu_result,
		__in(ch_bit<3>) in_mem_read, 
		__in(ch_bit<3>) in_mem_write,
		__in(ch_bit<5>) in_rd,
		__in(ch_bit<2>) in_wb,
		__in(ch_bit<5>) in_rs1,
		__in(ch_bit<32>) in_rd1,
		__in(ch_bit<5>) in_rs2,
		__in(ch_bit<32>) in_rd2,
		__in(ch_bit<32>)   in_PC_next,
		__in(ch_bit<32>) in_cache_data, // CACHE REP

		__out(ch_bit<32>) out_alu_result,
		__out(ch_bit<32>) out_mem_result,
		__out(ch_bit<5>) out_rd,
		__out(ch_bit<2>) out_wb,
		__out(ch_bit<5>) out_rs1,
		__out(ch_bit<5>) out_rs2,

		__out(ch_bit<24>) out_cache_address, // CACHE REP
		__out(ch_bit<3>)  out_cache_mem_read, // CACHE REP
		__out(ch_bit<3>) out_cache_mem_write, // CACHE REP
		__out(ch_bit<32>) out_cache_data, // CACHE REP

		__out(ch_bit<32>)   out_PC_next
	);

	void describe()
	{

		ch_print("****************");
		ch_print("MEMORY");
		ch_print("****************");		


		ch_print("rd: {0}, alu_result: {1}, mem_result: {2}, in_data: {3}, mem_write: {4}, mem_read: {5}", io.in_rd, io.in_alu_result, io.out_mem_result, io.in_rd2, io.in_mem_write, io.in_mem_read);

		ch_bit<24> address = ch_slice<24>(io.in_alu_result.as_uint() >> 2);

		// cache.io.in_address = address;
		// cache.io.in_mem_read = io.in_mem_read;
		// cache.io.in_mem_write = io.in_mem_write;
		// cache.io.in_data = io.in_rd2;

		// io.out_mem_result = cache.io.out_data;

		io.out_cache_address = address;
		io.out_cache_mem_write = io.in_mem_write;
		io.out_cache_mem_read = io.in_mem_read;
		io.out_cache_data = io.in_rd2;

		io.out_mem_result = io.in_cache_data;

		io.out_alu_result = io.in_alu_result;
		io.out_rd = io.in_rd;
		io.out_wb = io.in_wb;
		io.out_rs1 = io.in_rs1;
		io.out_rs2 = io.in_rs2;
		io.out_PC_next = io.in_PC_next;


	}

	// ch_module<Cache> cache;

};