#pragma once

#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::logic;
using namespace ch::system;

struct CSR_Handler {
  __io (
    __in(ch_bit<12>) in_decode_csr_address,  // done
    __in(ch_bit<12>) in_mem_csr_address,
    __in(ch_bit<1>) in_mem_is_csr,
    __in(ch_bit<32>) in_mem_csr_result,
    __out(ch_bit<32>) out_decode_csr_data  // done
  );

  void describe() {
    ch_mem<ch_bit<12>, 4096> CSR;

    ch_reg<ch_uint<64>> cycle(0);
    ch_reg<ch_uint<64>> instret(0);

    cycle->next = cycle + ch_uint<64>(1);
    instret->next = instret + ch_uint<64>(1);

    ch_reg<ch_bit<12>> decode_csr_address(0);
    decode_csr_address->next = io.in_decode_csr_address;

    ch_bit<12> write_data;
    ch_bit<12> write_register;
    ch_bool enable;

    write_data = ch_slice<12>(io.in_mem_csr_result);

    CSR.write(io.in_mem_csr_address, write_data, io.in_mem_is_csr);

    // ch_resize<32>(CSR.read(decode_csr_address))

    ch_bool read_cycle = decode_csr_address == ch_bit<12>(0xC00);
    ch_bool read_cycleh = decode_csr_address == ch_bit<12>(0xC80);
    ch_bool read_instret = decode_csr_address == ch_bit<12>(0xC02);
    ch_bool read_instreth = decode_csr_address == ch_bit<12>(0xC82);

    io.out_decode_csr_data = ch_sel(
        read_cycle, ch_slice<32>(cycle),
        ch_sel(read_cycleh, ch_slice<32>(cycle >> 32),
               ch_sel(read_instret, ch_slice<32>(instret),
                      ch_sel(read_instreth, ch_slice<32>(instret >> 32),
                             ch_resize<32>(CSR.read(decode_csr_address))))));

    // io.out_decode_csr_data = ch_bit<32>(0x0);
  }
};
