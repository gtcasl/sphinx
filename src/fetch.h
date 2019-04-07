#pragma once

#include <cash.h>
#include <ioport.h>
#include "buses.h"
#include "define.h"

using namespace ch::logic;
using namespace ch::system;
using namespace ch::htl;

struct ICACHE {
  __io (
    (IBUS_io)IBUS,
    __in(ch_bit<32>) in_address,
    __out(ch_bit<32>) out_instruction,
    __out(ch_bool) out_delay
  );

  void describe() {
#ifndef ICACHE_ENABLE

    io.IBUS.in_data.ready = io.IBUS.in_data.valid;

    io.IBUS.out_address.data = io.in_address;
    io.IBUS.out_address.valid = TRUE;

    io.out_instruction = io.IBUS.in_data.data;
    io.out_delay = FALSE;

#else

    // ch_print("****************");

    ch_mem<ch_bit<LINE_BIT_SIZE>, INUM_LINES> data_cache;
    ch_mem<ch_uint<32>, INUM_LINES> tag_cache;

    // ch_print("ITAG_BITS: {0}, INUM_LINES: {1}", ch_uint(ITAG_BITS),
    // ch_uint(INUM_LINES));

    auto line_index =
        ch_resize<INUM_BITS>(io.in_address.as_uint() >> ILINE_BITS);

    // auto curr_tag    = ch_resize<32>(io.in_address.as_uint()    >>
    // IG_TAG_BITS) >> 20;

    ch_uint<32> curr_tag = io.in_address.as_uint() & ch_uint<32>(ITAG_MASK);
    auto data_offset = ch_resize<OFFSET_BITS>(io.in_address).as_uint() << 3;

    io.IBUS.out_address.data = io.in_address;

    auto cache_tag = tag_cache.read(line_index);
    ch_bool icache_miss = curr_tag != cache_tag;

    io.IBUS.out_address.valid = icache_miss;

    ch_bool copying = icache_miss || (io.IBUS.in_data.valid);
    io.out_delay = copying;

    io.IBUS.in_data.ready = TRUE;

    ch_bit<LINE_BIT_SIZE> real_line = data_cache.read(line_index);
    io.out_instruction =
        ch_sel(!copying, ch_resize<32>(real_line >> data_offset), 0x0);

    ch_bit<LINE_BIT_SIZE> new_data =
        (real_line << ch_uint(32)) |
        ch_pad<LINE_BIT_SIZE - 32>(io.IBUS.in_data.data);
    ch_bit<LINE_BIT_SIZE> data_to_write =
        ch_sel(icache_miss, ch_bit<LINE_BIT_SIZE>(0), new_data);

    // ch_print("ADDRESS: {0}, instruction: {1}, DELAY: {2}", io.in_address,
    // io.out_instruction, copying);

    // ch_print("[0] {0}", data_to_write);

    // __if (icache_miss)
    // {
    // 	ch_print("writing {0} to {1}", curr_tag, line_index);
    // };

    tag_cache.write(line_index, curr_tag, icache_miss);
    data_cache.write(line_index, data_to_write, copying);

    // ch_print("-----------------");

#endif
  }
};

struct Fetch {
  __io (
    // Communication with HOST
    (IBUS_io)IBUS,
    __in(ch_bit<1>) in_branch_dir,
    __in(ch_bool) in_freeze,
    __in(ch_bit<32>) in_branch_dest,
    __in(ch_bit<1>) in_branch_stall,
    __in(ch_bit<1>) in_fwd_stall,
    __in(ch_bit<1>) in_branch_stall_exe,
    __in(ch_bit<1>) in_jal,
    __in(ch_bit<32>) in_jal_dest,
    __in(ch_bool) in_interrupt,
    __in(ch_bit<32>) in_interrupt_pc,
    __in(ch_bool) in_debug,

    __out(ch_bit<32>) out_instruction,
    __out(ch_bool) out_delay,
    __out(ch_bit<32>) out_curr_PC
    // __out(ch_bit<32>) out_PC_next
  );

  void describe() {
    // ch_reg<ch_bit<32>> PC(0);
    // ch_reg<ch_bool> start(true);
    ch_reg<ch_bool> stall_reg(false);
    ch_reg<ch_bool> delay_reg(false);

    ch_reg<ch_bit<32>> old(0);
    ch_reg<ch_bit<5>> state(0);
    ch_reg<ch_bit<32>> PC(0);
    ch_reg<ch_bit<32>> JAL_reg(0);
    ch_reg<ch_bit<32>> BR_reg(0);
    ch_reg<ch_bit<32>> I_reg(0);
    ch_reg<ch_bool> prev_debug(false);

    ch_bit<32> PC_to_use;
    ch_bit<32> PC_to_use_temp;

    // PC_to_use = PC;
    __switch (state)
    __case (P_STATE_int) { PC_to_use_temp = PC; }
    __case (J_STATE_int) { PC_to_use_temp = JAL_reg; }
    __case (B_STATE_int) { PC_to_use_temp = BR_reg; }
    __case (I_STATE_int) {
      // PC_to_use_temp = I_reg;
      // PC_to_use_temp = old;
      PC_to_use_temp = PC;
    }
    __case (S_STATE_int) { PC_to_use_temp = old; }
    __default { PC_to_use_temp = ch_bit<32>(0); };

    icache.io.IBUS(io.IBUS);

    io.out_delay = icache.io.out_delay;
    ch_bool delay = (icache.io.out_delay);
    // ch_print("PC: {0}, JAL_reg: {1}, BR_reg: {2}, old: {3}, state: {4},
    // stall_reg: {5}", PC, JAL_reg, BR_reg, old, state, stall_reg);

    PC_to_use = ch_sel(delay_reg && !(io.in_freeze), old,
                       ch_sel(io.in_debug, ch_sel(prev_debug, old, PC),
                              ch_sel(stall_reg, old, PC_to_use_temp)));

    // __if (io.in_branch_stall)
    // {
    // 	ch_print("BRANCHING STALL");
    // };

    // __if (io.in_fwd_stall)
    // {
    // 	ch_print("FORAWARD STALL");
    // };

    // __if (io.in_branch_stall_exe)
    // {
    // 	ch_print("BRANCH STALL EXE");
    // };

    // __if (io.in_jal)
    // {
    // 	ch_print("JUMPING TO {0}", io.in_jal_dest);
    // };

    // __if (io.in_freeze)
    // {
    // 	ch_print("FREEZING");
    // };

    // __if (delay)
    // {
    // 	ch_print("DELAYING");
    // };

    ch_bool stall = (io.in_branch_stall == STALL) ||
                    (io.in_fwd_stall == STALL) || (io.in_branch_stall_exe) ||
                    (io.in_interrupt) || delay || io.in_freeze;
    stall_reg->next = stall;
    delay_reg->next = delay || io.in_freeze;

    // ch_print("FETCH STALL : {0}, DELAY: {1}, FREEZE: {2}", stall, delay,
    // io.in_freeze);

    io.out_instruction = ch_sel(stall, CH_ZERO(32), icache.io.out_instruction);

    ch_bit<32> temp_PC =
        ch_sel((io.in_jal == JUMP) && !delay_reg, io.in_jal_dest,
               ch_sel((io.in_branch_dir == TAKEN) && !delay_reg,
                      io.in_branch_dest, PC_to_use));

    // ch_print("in_jal_dest: {0}, in_branch_dest: {1}", io.in_jal_dest,
    // io.in_branch_dest); ch_bit<32> out_PC    = ch_sel(io.in_interrupt,
    // io.in_interrupt_pc, temp_PC);
    ch_bit<32> out_PC = temp_PC;

    icache.io.in_address = out_PC;
    // ch_print("instruction in pipeline: {0}, PC: {1}", io.out_instruction,
    // out_PC);

    ch_bit<5> temp_state =
        ch_sel(io.in_jal == JUMP, J_STATE,
               ch_sel(io.in_branch_dir == TAKEN, B_STATE, P_STATE));
    ch_bit<5> tempp_state = ch_sel(io.in_interrupt, I_STATE, temp_state);
    state->next =
        ch_sel(io.in_debug, I_STATE, ch_sel(prev_debug, S_STATE, tempp_state));

    io.out_curr_PC = out_PC;

    old->next = out_PC;
    PC->next = PC_to_use.as_uint() + ch_uint<32>(4);
    JAL_reg->next = io.in_jal_dest.as_uint() + ch_uint<32>(4);
    BR_reg->next = io.in_branch_dest.as_uint() + ch_uint<32>(4);
    I_reg->next = io.in_interrupt_pc.as_uint() + ch_uint<32>(4);
    prev_debug->next = io.in_debug;
    // PC->next       = ch_sel(stall, out_PC.as_int(), pc_next.as_int());

    // ch_print("out_PC: {0}, out_instruction: {1}, stall: {2}", out_PC,
    // io.out_instruction, stall);

    // ch_print("actual PC: {1}, old: {0}", old, out_PC);

    // PC->next = ch_sel(stall, out_PC, PC_to_use);

    // ch_print("Inst_in: {0}", io.IBUS.in_data.data);
    // ch_print("JAL: {0}\tBRANCH_DIR: {1}", io.in_jal, io.in_branch_dir);
    // ch_print("BRANCH DEST: {0}", io.in_branch_dest);
    // ch_print("io.in_branch_stall IS: {0}\tio.in_fwd_stall IS: {1}",
    // io.in_branch_stall, io.in_fwd_stall);
  }

  ch_module<ICACHE> icache;
};
