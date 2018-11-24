#include <cash.h>
#include <ioport.h>
#include "define.h"
#include "buses.h"

// using namespace ch::logic;
// using namespace ch::system;
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

		io.INTERRUPT.in_interrupt_id.ready = io.INTERRUPT.in_interrupt_id.valid;

		ch_rom<ch_bit<32>, 2> ivt({0xdeadbeef, 0xdeadbeef});

		__if(io.INTERRUPT.in_interrupt_id.valid)
		{
			io.out_interrupt_pc = ivt.read(io.INTERRUPT.in_interrupt_id.data);
		} __else
		{
			io.out_interrupt_pc = ch_bit<32>(0xdeadbeef);
		};

		io.out_interrupt    = io.INTERRUPT.in_interrupt_id.valid;

	}



};