#include <cash.h>
#include <ioport.h>
#include "define.h"
#include <htl/decoupled.h>

using namespace ch::core;
using namespace ch::sim;
using namespace ch::htl;

const std::string& init_file = "../traces/rv32ui-p-andi.hex";

struct Fetch
{
	__io(
		// Communication with HOST
		(ch_enq_io<ch_bit<32>>) in_ibus_data,
		(ch_deq_io<ch_bit<32>>) out_ibus_address,

		__in(ch_bit<1>) in_branch_dir,
		__in(ch_bit<32>) in_branch_dest,
		__in(ch_bit<1>) in_branch_stall,
		__in(ch_bit<1>) in_fwd_stall,
		__in(ch_bit<1>) in_jal,
		__in(ch_bit<32>) in_jal_dest,

		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>)  out_PC_next
	);

	void describe()
	{

		ch_reg<ch_bit<32>> PC(0);
		io.in_ibus_data.ready = io.in_ibus_data.valid;
		
		ch_bool stall      = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL);
		io.out_instruction = ch_sel(stall, CH_ZERO(32), io.in_ibus_data.data);


		ch_bit<32> out_PC = ch_sel(io.in_jal == JUMP, io.in_jal_dest, ch_sel(io.in_branch_dir == TAKEN, io.in_branch_dest, PC));
		io.out_ibus_address.data = out_PC;
		io.out_ibus_address.valid = TRUE;


		io.out_PC_next = out_PC.as_uint() + 4;
		
		PC->next       = ch_sel(stall, out_PC, io.out_PC_next);


		ch_print("Inst_in: {0}", io.in_ibus_data.data);
		ch_print("JAL: {0}\tBRANCH_DIR: {1}", io.in_jal, io.in_branch_dir);
		ch_print("BRANCH DEST: {0}", io.in_branch_dest);
		ch_print("io.in_branch_stall IS: {0}\tio.in_fwd_stall IS: {1}", io.in_branch_stall, io.in_fwd_stall);

	}

};

