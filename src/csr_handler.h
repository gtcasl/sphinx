#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;


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
		ch_mem<ch_bit<32>, 4096> CSR;

		ch_reg<ch_bool> first_cycle(true);

		__if(first_cycle)
		{
			first_cycle->next = FALSE;
		};

		CSR.write(0xf14, ch_bit<32>(0), first_cycle);

		io.out_decode_csr_data = CSR.read(io.in_decode_csr_address);

		ch_bool write_enable   = io.in_mem_is_csr.as_uint() == 1;
		CSR.write(io.in_mem_csr_address, io.in_mem_csr_result, write_enable);
	}

};