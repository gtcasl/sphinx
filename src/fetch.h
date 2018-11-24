#include <cash.h>
#include <ioport.h>
#include "define.h"
#include "buses.h"

// using namespace ch::logic;
// using namespace ch::system;
using namespace ch::htl;

const std::string& init_file = "../traces/rv32ui-p-andi.hex";

struct Fetch
{
	__io(
		// Communication with HOST
		
		(IBUS_io) IBUS,

		__in(ch_bit<1>)   in_branch_dir,
		__in(ch_bit<32>)  in_branch_dest,
		__in(ch_bit<1>)   in_branch_stall,
		__in(ch_bit<1>)   in_fwd_stall,
		__in(ch_bit<1>)   in_branch_stall_exe,
		__in(ch_bit<1>)   in_jal,
		__in(ch_bit<32>)  in_jal_dest,
		__in(ch_bool)     in_interrupt,
		__in(ch_bit<32>)  in_interrupt_pc,

		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>) out_curr_PC,
		__out(ch_bit<32>) out_PC_next
	);

	void describe()
	{


		ch_reg<ch_bit<32>> PC(0);
		io.IBUS.in_data.ready = io.IBUS.in_data.valid;
		
		ch_bool stall      = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL) || (io.in_branch_stall_exe);
		io.out_instruction = ch_sel(stall, CH_ZERO(32), io.IBUS.in_data.data);


		ch_bit<32> temp_PC = ch_sel(io.in_jal == JUMP, io.in_jal_dest, ch_sel(io.in_branch_dir == TAKEN, io.in_branch_dest, PC));
		ch_bit<32> out_PC  = ch_sel(io.in_interrupt, io.in_interrupt_pc, temp_PC);

		io.IBUS.out_address.data = out_PC;
		io.IBUS.out_address.valid = TRUE;

		io.out_curr_PC = out_PC;
		io.out_PC_next = out_PC.as_uint() + 4;
		
		PC->next       = ch_sel(stall, out_PC, io.out_PC_next);


		// ch_print("Inst_in: {0}", io.IBUS.in_data.data);
		// ch_print("JAL: {0}\tBRANCH_DIR: {1}", io.in_jal, io.in_branch_dir);
		// ch_print("BRANCH DEST: {0}", io.in_branch_dest);
		// ch_print("io.in_branch_stall IS: {0}\tio.in_fwd_stall IS: {1}", io.in_branch_stall, io.in_fwd_stall);

	}

};

