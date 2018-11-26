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
		__out(ch_bit<32>) out_curr_PC
		// __out(ch_bit<32>) out_PC_next
	);

	void describe()
	{


		// ch_reg<ch_bit<32>> PC(0);
		// ch_reg<ch_bool> start(true);
		ch_reg<ch_bool> stall_reg(false);

		ch_reg<ch_bit<32>> old(0);
		ch_reg<ch_bit<4>> state(0);
		ch_reg<ch_bit<32>> PC(0);
		ch_reg<ch_bit<32>> JAL_reg(0);
		ch_reg<ch_bit<32>> BR_reg(0);
		ch_reg<ch_bit<32>> I_reg(0);

		ch_bit<32> PC_to_use;
		ch_bit<32> PC_to_use_temp;

		// PC_to_use = PC;
		__switch(state)
			__case(P_STATE_int)
			{
				PC_to_use_temp = PC;
			}
			__case(J_STATE_int)
			{
				PC_to_use_temp = JAL_reg;
			}
			__case(B_STATE_int)
			{
				PC_to_use_temp = BR_reg;
			}
			__case(I_STATE_int)
			{
				PC_to_use_temp = I_reg;
			} __default
			{
				PC_to_use_temp = ch_bit<32>(0);
			};

		PC_to_use = ch_sel(stall_reg, old, PC_to_use_temp);

		// stall_reg->next = true;

		io.IBUS.in_data.ready = io.IBUS.in_data.valid;
		
		ch_bool stall      = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL) || (io.in_branch_stall_exe);
		stall_reg->next    = stall;

		io.out_instruction = ch_sel(stall, CH_ZERO(32), io.IBUS.in_data.data);

		ch_bit<32> temp_PC   = ch_sel(io.in_jal == JUMP, io.in_jal_dest, ch_sel(io.in_branch_dir == TAKEN, io.in_branch_dest, PC_to_use));
		ch_bit<32> out_PC    = ch_sel(io.in_interrupt, io.in_interrupt_pc, temp_PC);

		ch_bit<4> temp_state = ch_sel(io.in_jal == JUMP, J_STATE, ch_sel(io.in_branch_dir == TAKEN, B_STATE, P_STATE));
		state->next          = ch_sel(io.in_interrupt, I_STATE, temp_state);

		io.IBUS.out_address.data = out_PC;
		io.IBUS.out_address.valid = TRUE;

		io.out_curr_PC = out_PC;


		ch_bit<32> pc_next = out_PC.as_uint() + ch_uint<32>(4);
		
		old->next     = out_PC;
		PC->next      = PC_to_use.as_uint()          + ch_uint<32>(4);
		JAL_reg->next = io.in_jal_dest.as_uint()     + ch_uint<32>(4);
		BR_reg->next  = io.in_branch_dest.as_uint()  + ch_uint<32>(4);
		I_reg->next   = io.in_interrupt_pc.as_uint() + ch_uint<32>(4);

		// PC->next       = ch_sel(stall, out_PC.as_int(), pc_next.as_int());


		// ch_print("PC: {0}", out_PC);
		
		// PC->next = ch_sel(stall, out_PC, PC_to_use);


		// ch_print("Inst_in: {0}", io.IBUS.in_data.data);
		// ch_print("JAL: {0}\tBRANCH_DIR: {1}", io.in_jal, io.in_branch_dir);
		// ch_print("BRANCH DEST: {0}", io.in_branch_dest);
		// ch_print("io.in_branch_stall IS: {0}\tio.in_fwd_stall IS: {1}", io.in_branch_stall, io.in_fwd_stall);

	}

};

