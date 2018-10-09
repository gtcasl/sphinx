#include <cash.h>
#include <ioport.h>
#include "define.h"

using namespace ch::core;
using namespace ch::sim;


const std::string& init_file = "../Workspace/file.hex";

struct Fetch
{
	__io(
		__in(ch_bit<32>) in_din,
		__in(ch_bool) in_push,
		__in(ch_bit<1>) in_branch_dir,
		__in(ch_bit<32>) in_branch_dest,
		__in(ch_bit<1>) in_branch_stall,
		__in(ch_bit<1>) in_fwd_stall,
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit<32>) out_PC,
		__out(ch_bit<32>)  out_PC_next
	);

	void describe()
	{



		ch_reg<ch_bit<32>> PC(0);
		ch_bool stall = (io.in_branch_stall == STALL) || (io.in_fwd_stall == STALL);
		
		io.out_instruction = ch_sel(stall, CH_ZERO(32), io.in_din);

		ch_print("INSTRUCTION GOING OUT OF FETCH: {0}", io.out_instruction);

		__if(io.in_branch_dir.as_uint() == TAKEN_int)
		{
			ch_print("Branch_dest: {0}", io.in_branch_dest);
		};

		io.out_PC = ch_sel(io.in_branch_dir.as_uint() == TAKEN_int, io.in_branch_dest, PC.as_uint());

		io.out_PC_next = io.out_PC.as_uint() + 1;



		//ch_print("DIR: {0}\tDEST{1}",io.in_branch_dir, io.in_branch_dest);
		//ch_print("STALL: {0}", io.in_branch_stall);

		// io.out_PC_next = PC.as_uint();

		// io.out_PC = ch_sel(io.in_branch_dir.as_uint() == 1, io.in_branch_dest, PC.as_uint());
		// io.out_PC_next = ch_sel(io.in_branch_dir.as_uint() == 1, io.in_branch_dest.as_uint() + 1, PC.as_uint() + 1);
		// PC->next       = ch_sel(io.in_branch_dir.as_uint() == 1, io.in_branch_dest.as_uint() + 1, PC.as_uint() + 1);
		
		PC->next       = ch_sel(stall, io.out_PC, io.out_PC_next);
	}

};

