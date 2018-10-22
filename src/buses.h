
#ifndef __BUSES__
#define __BUSES__

#include <cash.h>
#include <ioport.h>
#include <htl/decoupled.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;
using namespace ch::htl;
// using namespace ch::logic;


__inout(IBUS_io, (
	(ch_enq_io<ch_bit<32>>) in_data,
	(ch_deq_io<ch_bit<32>>) out_address
	));


__inout(DBUS_io, (
	(ch_enq_io<ch_bit<32>>) in_data,
	(ch_deq_io<ch_bit<32>>) out_data,
	(ch_deq_io<ch_bit<32>>) out_address,
	(ch_deq_io<ch_bit<2>>) out_control
	)); 


#endif