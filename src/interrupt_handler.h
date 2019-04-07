#pragma once

#include <cash.h>
#include <ioport.h>
#include "define.h"
#include "buses.h"

using namespace ch::logic;
using namespace ch::system;
using namespace ch::htl;


struct Interrupt_Handler
{

	__io(

		(INTERRUPT_io)    INTERRUPT,

		__out(ch_bool)    out_interrupt,
		__out(ch_bit<32>) out_interrupt_pc
	);

	void describe()
	{


		// ch_reg<ch_bit<32>> counter(0);
		// counter->next = counter + 1;

		// ch_reg<ch_uint<7>> save(0);

		// ch_bool interrupt;

		// __if (save == ch_uint<7>(100))
		// {
		// 	save->next = 0;
		// 	interrupt = ch_bool(true);
		// } __else
		// {
		// 	save->next = save->next + 1;
		// 	interrupt = ch_bool(false);
		// }

		io.INTERRUPT.in_interrupt_id.ready = io.INTERRUPT.in_interrupt_id.valid;

		ch_rom<ch_bit<32>, 2> ivt({0x70000000, 0xdeadbeef});

		__if(io.INTERRUPT.in_interrupt_id.valid)
		{
			io.out_interrupt_pc = ivt.read(io.INTERRUPT.in_interrupt_id.data);
		} __else
		{
			io.out_interrupt_pc = ch_bit<32>(0xdeadbeef);
		};

		io.out_interrupt    = io.INTERRUPT.in_interrupt_id.valid;

		// io.out_interrupt    = interrupt;
		// io.out_interrupt_pc = vt.read(ch_bit<1>(0));

		// To implement I must just JUMP without affecting the registers, then store all the values of the register, do whatever I wanna do, then load, then return
		// but then the question is return to what? 

	}



};
