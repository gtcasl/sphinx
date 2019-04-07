#pragma once

#include <cash.h>
#include <ioport.h>

#include "../define.h"
#include "../buses.h"

#include "jtag_define.h"

using namespace ch::logic;
using namespace ch::system;
using namespace ch::htl;




struct TAP
{
	__io(

		(TAP_io) JTAG_TAP,

		__out(ch_bit<4>) out_curr_state
	);

	void describe()
	{
		io.JTAG_TAP.in_mode_select.ready = io.JTAG_TAP.in_mode_select.valid;
		io.JTAG_TAP.in_clock.ready       = io.JTAG_TAP.in_clock.valid;
		io.JTAG_TAP.in_reset.ready       = io.JTAG_TAP.in_reset.valid;

		ch_reg<ch_bit<4>> curr_state(TEST_LOGIC_RESET_int);



		ch_bool mode_change  = io.JTAG_TAP.in_mode_select.valid;
		ch_bool mode_select  = io.JTAG_TAP.in_mode_select.data == 1;


		ch_bit<4> next_state(0);
		__if(mode_change)
		{
			__switch(curr_state.as_uint())
				__case(TEST_LOGIC_RESET_int)
				{
					next_state = ch_sel(mode_select, TEST_LOGIC_RESET, RUN_TEST_IDLE);
				}
				__case(RUN_TEST_IDLE_int)
				{
					next_state = ch_sel(mode_select, SELECT_DR_SCAN, RUN_TEST_IDLE);
				}
				__case(SELECT_DR_SCAN_int)
				{
					next_state = ch_sel(mode_select, SELECT_IR_SCAN, CAPTURE_DR);
				}
				__case(CAPTURE_DR_int)
				{
					next_state = ch_sel(mode_select, EXIT1_DR, SHIFT_DR);
				}
				__case(SHIFT_DR_int)
				{
					next_state = ch_sel(mode_select, EXIT1_DR, SHIFT_DR);
				}
				__case(EXIT1_DR_int)
				{
					next_state = ch_sel(mode_select, UPDATE_DR, PAUSE_DR);
				}
				__case(PAUSE_DR_int)
				{
					next_state = ch_sel(mode_select, EXIT2_DR, PAUSE_DR);
				}
				__case(EXIT2_DR_int)
				{
					next_state = ch_sel(mode_select, SHIFT_DR, UPDATE_DR);
				}
				__case(UPDATE_DR_int)
				{
					next_state = ch_sel(mode_select, SELECT_DR_SCAN, RUN_TEST_IDLE);
				}
				__case(SELECT_IR_SCAN_int)
				{
					next_state = ch_sel(mode_select, TEST_LOGIC_RESET, CAPTURE_IR);
				}
				__case(CAPTURE_IR_int)
				{
					next_state = ch_sel(mode_select, EXIT1_IR, SHIFT_IR);
				}
				__case(SHIFT_IR_int)
				{
					next_state = ch_sel(mode_select, EXIT1_IR, SHIFT_IR);
				}
				__case(EXIT1_IR_int)
				{
					next_state = ch_sel(mode_select, UPDATE_IR, PAUSE_IR);
				}
				__case(PAUSE_IR_int)
				{
					next_state = ch_sel(mode_select, EXIT2_IR, PAUSE_IR);
				}
				__case(EXIT2_IR_int)
				{
					next_state = ch_sel(mode_select, UPDATE_IR, SHIFT_IR);
				}
				__case(UPDATE_IR_int)
				{
					next_state = ch_sel(mode_select, SELECT_DR_SCAN, RUN_TEST_IDLE);
				}
				__default
				{
				    next_state = curr_state;
				};
		};



		__if(mode_change && io.JTAG_TAP.in_reset.valid)
		{
			__if(io.JTAG_TAP.in_reset.data == 1)
			{
				curr_state->next = TEST_LOGIC_RESET;
			};
		} __else
		{
			__if(mode_change && io.JTAG_TAP.in_clock.valid)
			{
				__if(io.JTAG_TAP.in_clock.data == 1)
				{
					curr_state->next = next_state;
				};
			};
		};

		io.out_curr_state = curr_state;

	}
};


struct JTAG
{
	__io(
		(JTAG_io) JTAG
	);


	void describe()
	{

		ch_reg<ch_bit<32>> instruction_reg(BYPASS_INST);

		ch_reg<ch_bit<32>> data_reg(0x1234);
		ch_reg<ch_bit<32>> data_id_reg(0x5678);


		io.JTAG.in_data.ready = io.JTAG.in_data.valid;
		
		tap.io.JTAG_TAP(io.JTAG.JTAG_TAP);
		ch_bit<4> curr_state = tap.io.out_curr_state;

		ch_reg<ch_bit<32>> curr_captured(0);

			__switch(curr_state)
				__case(CAPTURE_DR_int)
				{
					ch_bool bypass = instruction_reg.as_uint() == BYPASS_INST_int;
					__if(bypass)
					{
						io.JTAG.out_data.valid = true;
						io.JTAG.out_data.data  = io.JTAG.in_data.data;
					}__else
					{
						io.JTAG.out_data.valid = false;
						io.JTAG.out_data.data  = 0;
					};

					ch_bool ID     = instruction_reg.as_uint() == ID_INST_int;
					ch_bool DATA   = instruction_reg.as_uint() == DATA_INST_int;

					curr_captured->next = ch_sel(ID, data_id_reg, ch_sel(DATA, data_reg, 0xdeadbeef));

				}
				__case(SHIFT_DR_int)
				{
					io.JTAG.out_data.valid = true;
					io.JTAG.out_data.data  = curr_captured[0];

					curr_captured->next = ch_cat(io.JTAG.in_data.data, ch_slice<31>(curr_captured >> 1));

				}
				__case(UPDATE_DR_int)
				{
					ch_bool bypass = instruction_reg.as_uint() == BYPASS_INST_int;
					__if(bypass)
					{
						io.JTAG.out_data.valid = true;
						io.JTAG.out_data.data  = io.JTAG.in_data.data;
					}__else
					{
						io.JTAG.out_data.valid = false;
						io.JTAG.out_data.data  = 0;
					};

					ch_bool ID   = instruction_reg.as_uint() == ID_INST_int;
					ch_bool DATA = instruction_reg.as_uint() == DATA_INST_int;

					__if(ID)
					{
						data_id_reg->next = curr_captured;
					}__else
					{
						__if(DATA)
						{
							data_reg->next = curr_captured;
						};
					};
				}
				__case(CAPTURE_IR_int)
				{
					ch_bool bypass = instruction_reg.as_uint() == BYPASS_INST_int;
					__if(bypass)
					{
						io.JTAG.out_data.valid = true;
						io.JTAG.out_data.data  = io.JTAG.in_data.data;
					}__else
					{
						io.JTAG.out_data.valid = false;
						io.JTAG.out_data.data  = 0;
					};

					curr_captured->next    = instruction_reg.as_uint();
				}
				__case(SHIFT_IR_int)
				{
					io.JTAG.out_data.valid = true;
					io.JTAG.out_data.data  = curr_captured[0];

					curr_captured->next = ch_cat(io.JTAG.in_data.data, ch_slice<31>(curr_captured >> 1));
				}
				__case(UPDATE_IR_int)
				{
					ch_bool bypass = instruction_reg.as_uint() == BYPASS_INST_int;
					__if(bypass)
					{
						io.JTAG.out_data.valid = true;
						io.JTAG.out_data.data  = io.JTAG.in_data.data;
					}__else
					{
						io.JTAG.out_data.valid = false;
						io.JTAG.out_data.data  = 0;
					};

					instruction_reg->next  = curr_captured;
				}
				__default
				{
					ch_bool bypass = instruction_reg.as_uint() == BYPASS_INST_int;
					__if(bypass)
					{
						io.JTAG.out_data.valid = true;
						io.JTAG.out_data.data  = io.JTAG.in_data.data;
					}__else
					{
						io.JTAG.out_data.valid = false;
						io.JTAG.out_data.data  = 0;
					};
				};
	}

	ch_module<TAP> tap;

};
