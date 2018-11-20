#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::logic;
using namespace ch::system;


struct CSR_Handler
{
	__io(
		__in(ch_bit<12>)  in_decode_csr_address, // done
		__in(ch_bit<12>)  in_mem_csr_address,
		__in(ch_bit<1>)   in_mem_is_csr,
		__in(ch_bit<32>)  in_mem_csr_result,

		__out(ch_bit<32>) out_decode_csr_data // done
	);


	void describe()
	{
		ch_mem<ch_bit<12>, 4096> CSR;

		ch_reg<ch_bit<2>> curr_state(0);

		ch_bit<12> write_data;
		ch_bit<12> write_register;
		ch_bool enable;

		__if(curr_state == 0)
		{
			write_data        = ch_bit<12>(0);
			write_register   = 0xf14;
			enable     = TRUE;
			curr_state->next = 1;

		} __elif (curr_state == 1)
		{
			write_data        = ch_bit<12>(0);
			write_register   = 0x301;
			enable     = TRUE;
			curr_state->next = 3;
		} __else
		{
			write_data     = ch_slice<12>(io.in_mem_csr_result);
			write_register = io.in_mem_csr_address;
			enable         = io.in_mem_is_csr.as_uint() == 1;
		};

		CSR.write(write_register, write_data, enable);

    io.out_decode_csr_data = ch_resize<32>(CSR.aread(io.in_decode_csr_address));


		// io.out_decode_csr_data = ch_bit<32>(0x0);

	}

};
