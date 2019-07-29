#pragma once

#include <cash.h>
#include <htl/decoupled.h>
#include <ioport.h>
#include "define.h"

using namespace ch::logic;
using namespace ch::system;
using namespace ch::htl;

__inout (IBUS_io, (
  (ch_enq_io<ch_bit<32>>) in_data,
  (ch_deq_io<ch_bit<32>>) out_address
));

__inout (DBUS_io, (
  __out(ch_bool) out_miss,
  __out(ch_bool) out_rw,
  (ch_enq_io<ch_bit<32>>) in_data,
  (ch_deq_io<ch_bit<32>>) out_data,
  (ch_deq_io<ch_bit<32>>) out_address,
  (ch_deq_io<ch_bit<3>>)  out_control
));

__inout (INTERRUPT_io, (
  (ch_enq_io<ch_bit<1>>) in_interrupt_id
));

__inout (TAP_io, (
  (ch_enq_io<ch_bit<1>>) in_mode_select,
  (ch_enq_io<ch_bit<1>>) in_clock,
  (ch_enq_io<ch_bit<1>>) in_reset
));

__inout (JTAG_io, (
  (TAP_io)               JTAG_TAP,
  (ch_enq_io<ch_bit<1>>) in_data,  // JTAG test data input pad
  (ch_deq_io<ch_bit<1>>) out_data  // JTAG test data output pad
));
