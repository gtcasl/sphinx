#include <cash.h>
#include <ioport.h>
#include "buses.h"

#include "literals.h"
#include <math.h>

using namespace ch::logic;
using namespace ch::system;

#include <iostream>



__inout(WAY_I, (
	__in(ch_bit<3> )  in_control,
	__in(ch_bool   )  in_rw,

	__in(ch_bit<32>)  in_address,
	__in(ch_bit<32>)  in_data,
	__in(ch_bool   )  in_valid
));

template<unsigned cache_size, unsigned line_size, unsigned num_ways, unsigned way_id>
struct Way
{

	static const unsigned ID_BITS = (log2(num_ways) == 0) ? 1 : log2(num_ways);

	__io(
		    (WAY_I)           way_i, 
		__in(ch_bit<ID_BITS>) in_id,
		__in(ch_bool)         in_dbus_valid,
		__in(ch_bit<32>)      in_dbus_data,

		__out(ch_bit<32>)     out_data,
		__out(ch_bool)        out_delay,
		__out(ch_bool)        out_miss
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


		auto in_tag   = ch_slice<tag_bits>(io.way_i.in_address >> way_bits);
		auto in_index = ch_slice<index_bits>(io.way_i.in_address >> line_bits);
		auto in_addr  = ch_slice<way_bits>(io.way_i.in_address);

		auto curr_tag   = tag_cache.read(in_index);
		auto curr_valid = valid_cache.read(in_index);

		auto miss     = (in_tag != curr_tag)  && curr_valid && io.way_i.in_valid;
		auto copying  = miss                  || io.in_dbus_valid;


		in_data_validity->next = io.in_dbus_valid;
		

		auto new_miss_addr  = ch_cat(in_index, ch_bit<line_bits>(0));
		auto next_miss_addr = miss_addr.as_uint() + ch_uint<way_bits>(4);


		miss_addr->next = ch_sel(io.in_dbus_valid, next_miss_addr, new_miss_addr);

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
		__switch(io.way_i.in_control)
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
		io.out_delay  = (copying || in_data_validity) && (io.in_id == way_id);
		io.out_miss   = miss;

		tag_cache.write(  in_index , in_tag, miss && (io.in_id == way_id) );
		valid_cache.write(in_index , TRUE  , miss && (io.in_id == way_id) );



		auto data_to_write = ch_sel(copying, io.in_dbus_data, io.way_i.in_data);

		data_cache.write(Abyte0, ch_slice<8>(data_to_write)      , (copying && io.in_id == way_id) || (io.way_i.in_rw && Wbyte0));
		data_cache.write(Abyte1, ch_slice<8>(data_to_write >> 8) , (copying && io.in_id == way_id) || (io.way_i.in_rw && Wbyte1));
		data_cache.write(Abyte2, ch_slice<8>(data_to_write >> 16), (copying && io.in_id == way_id) || (io.way_i.in_rw && Wbyte2));
		data_cache.write(Abyte3, ch_slice<8>(data_to_write >> 24), (copying && io.in_id == way_id) || (io.way_i.in_rw && Wbyte3));





	}

};


	// __in(ch_bit<3> )  in_control,
	// __in(ch_bool   )  in_rw,

	// __in(ch_bit<32>)  in_address,
	// __in(ch_bit<32>)  in_data,
	// __in(ch_bool   )  in_valid

template<unsigned cache_size, unsigned line_size, unsigned num_ways>
struct Cache
{

	static const unsigned ID_BITS = log2(num_ways);


	__io(
		(DBUS_io)         DBUS,
		(WAY_I)           way_i,

		__out(ch_bit<32>) out_data,
		__out(ch_bool)    out_delay
	);

	void describe()
	{

		if constexpr (num_ways == 1)
		{


			ch_module<Way<cache_size, line_size, num_ways, 0>> way0;


			io.DBUS.out_rw            = io.way_i.in_rw;
			io.DBUS.out_address.data  = io.way_i.in_address;
			io.DBUS.out_address.valid = io.way_i.in_valid;

			io.DBUS.out_control.data  = io.way_i.in_control;
			io.DBUS.out_control.valid = TRUE;

			io.DBUS.out_data.data     = io.way_i.in_data;
			io.DBUS.out_data.valid    = io.way_i.in_valid;

			io.DBUS.in_data.ready     = io.way_i.in_valid;



			way0.io.in_id         = ch_uint<1>(0);
			way0.io.in_dbus_data  = io.DBUS.in_data.data;
			way0.io.in_dbus_valid = io.DBUS.in_data.valid;
			way0.io.way_i(io.way_i);



			ch_bool big_miss;
			ch_bool big_delay;
			ch_bit<32> data;

			big_miss  = way0.io.out_miss;
			big_delay = way0.io.out_delay;
			data      = way0.io.out_data;


			io.out_data      = data;
			io.out_delay     = big_delay;
			io.DBUS.out_miss = big_miss;

		} else if constexpr (num_ways == 2)
		{

			ch_module<Way<cache_size, line_size, num_ways, 0>> way0;


			ch_module<Way<cache_size, line_size, num_ways, 1>> way1;


			ch_reg<ch_uint<ID_BITS>> kick_out(0);
			ch_reg<ch_bool> delay_hist(false);



			io.DBUS.out_rw            = io.way_i.in_rw;
			io.DBUS.out_address.data  = io.way_i.in_address;
			io.DBUS.out_address.valid = io.way_i.in_valid;

			io.DBUS.out_control.data  = io.way_i.in_control;
			io.DBUS.out_control.valid = TRUE;

			io.DBUS.out_data.data     = io.way_i.in_data;
			io.DBUS.out_data.valid    = io.way_i.in_valid;

			io.DBUS.in_data.ready     = io.way_i.in_valid;



			way0.io.in_id         = kick_out;
			way0.io.in_dbus_data  = io.DBUS.in_data.data;
			way0.io.in_dbus_valid = io.DBUS.in_data.valid;
			way0.io.way_i(io.way_i);

			way1.io.in_id         = kick_out;
			way1.io.in_dbus_data  = io.DBUS.in_data.data;
			way1.io.in_dbus_valid = io.DBUS.in_data.valid;
			way1.io.way_i(io.way_i);



			ch_bool big_miss;
			ch_bool big_delay;
			ch_bit<32> data;

			big_delay = way0.io.out_delay || way1.io.out_delay;
			big_miss  = way0.io.out_miss  || way1.io.out_miss;
			data = ch_sel(!way0.io.out_miss, way0.io.out_data, way1.io.out_data);



			delay_hist->next = big_delay;
			kick_out->next = ch_sel(delay_hist && !big_delay, kick_out + ch_uint<ID_BITS>(1), kick_out); 
			


			io.out_data  = data;


			io.out_delay     = big_delay;
			io.DBUS.out_miss = big_miss;
		} else if constexpr (num_ways == 4)
		{

			ch_module<Way<cache_size, line_size, num_ways, 0>> way0;
			ch_module<Way<cache_size, line_size, num_ways, 1>> way1;
			ch_module<Way<cache_size, line_size, num_ways, 2>> way2;
			ch_module<Way<cache_size, line_size, num_ways, 3>> way3;


			ch_reg<ch_uint<ID_BITS>> kick_out(0);
			ch_reg<ch_bool> delay_hist(false);



			io.DBUS.out_rw            = io.way_i.in_rw;
			io.DBUS.out_address.data  = io.way_i.in_address;
			io.DBUS.out_address.valid = io.way_i.in_valid;

			io.DBUS.out_control.data  = io.way_i.in_control;
			io.DBUS.out_control.valid = TRUE;

			io.DBUS.out_data.data     = io.way_i.in_data;
			io.DBUS.out_data.valid    = io.way_i.in_valid;

			io.DBUS.in_data.ready     = io.way_i.in_valid;



			way0.io.in_id         = kick_out;
			way0.io.in_dbus_data  = io.DBUS.in_data.data;
			way0.io.in_dbus_valid = io.DBUS.in_data.valid;
			way0.io.way_i(io.way_i);

			way1.io.in_id         = kick_out;
			way1.io.in_dbus_data  = io.DBUS.in_data.data;
			way1.io.in_dbus_valid = io.DBUS.in_data.valid;
			way1.io.way_i(io.way_i);

			way2.io.in_id         = kick_out;
			way2.io.in_dbus_data  = io.DBUS.in_data.data;
			way2.io.in_dbus_valid = io.DBUS.in_data.valid;
			way2.io.way_i(io.way_i);

			way3.io.in_id         = kick_out;
			way3.io.in_dbus_data  = io.DBUS.in_data.data;
			way3.io.in_dbus_valid = io.DBUS.in_data.valid;
			way3.io.way_i(io.way_i);

			ch_bool big_miss;
			ch_bool big_delay;
			ch_bit<32> data;

			big_delay = way0.io.out_delay || way1.io.out_delay || way2.io.out_delay || way3.io.out_delay;
			big_miss  = way0.io.out_miss  || way1.io.out_miss  || way2.io.out_miss  || way3.io.out_miss;
			
			data = ch_sel(!way0.io.out_miss, way0.io.out_data,
										    ch_sel(!way1.io.out_miss, way1.io.out_data,
										                              ch_sel(!way2.io.out_miss, way2.io.out_data,
										                              							way3.io.out_data)));



			delay_hist->next = big_delay;
			kick_out->next = ch_sel(delay_hist && !big_delay, kick_out + ch_uint<ID_BITS>(1), kick_out); 
			


			io.out_data  = data;


			io.out_delay     = big_delay;
			io.DBUS.out_miss = big_miss;
		}

	}

};