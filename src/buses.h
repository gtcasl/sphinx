
#ifndef __BUSES__
#define __BUSES__

#include <cash.h>
#include <ioport.h>
#include <htl/decoupled.h>
#include "define.h"


using namespace ch::logic;
using namespace ch::system;
using namespace ch::htl;

__inout(IBUS_io, (
	(ch_enq_io<ch_bit<32>>) in_data,
	(ch_deq_io<ch_bit<32>>) out_address
));


__inout(DBUS_io, (
	(ch_enq_io<ch_bit<32>>) in_data,
	(ch_deq_io<ch_bit<32>>) out_data,
	(ch_deq_io<ch_bit<32>>) out_address,
  (ch_deq_io<ch_bit<2>>)  out_control
));


__inout(INTERRUPT_io, (
	(ch_enq_io<ch_bit<1>>) in_interrupt_id
));

__inout(TAP_io, (
	(ch_enq_io<ch_bit<1>>) in_mode_select,
	(ch_enq_io<ch_bit<1>>) in_clock,
	(ch_enq_io<ch_bit<1>>) in_reset
));

__inout(JTAG_io, (
	(TAP_io)                 JTAG_TAP,
	(ch_enq_io<ch_bit<1>>)   in_data,        // JTAG test data input pad
	(ch_deq_io<ch_bit<1>>)   out_data        // JTAG test data output pad
));

#endif
