#pragma once

#define TEST_LOGIC_RESET ch_bit<4>(0) 
#define RUN_TEST_IDLE ch_bit<4>(1)

#define SELECT_DR_SCAN ch_bit<4>(2)
#define CAPTURE_DR ch_bit<4>(3)
#define SHIFT_DR ch_bit<4>(4)
#define EXIT1_DR ch_bit<4>(5)
#define PAUSE_DR ch_bit<4>(6)
#define EXIT2_DR ch_bit<4>(7)
#define UPDATE_DR ch_bit<4>(8)

#define SELECT_IR_SCAN ch_bit<4>(9)
#define CAPTURE_IR ch_bit<4>(10)
#define SHIFT_IR ch_bit<4>(11)
#define EXIT1_IR ch_bit<4>(12)
#define PAUSE_IR ch_bit<4>(13)
#define EXIT2_IR ch_bit<4>(14)
#define UPDATE_IR ch_bit<4>(15)

#define TEST_LOGIC_RESET_int (0) 
#define RUN_TEST_IDLE_int (1)

#define SELECT_DR_SCAN_int (2)
#define CAPTURE_DR_int (3)
#define SHIFT_DR_int (4)
#define EXIT1_DR_int (5)
#define PAUSE_DR_int (6)
#define EXIT2_DR_int (7)
#define UPDATE_DR_int (8)

#define SELECT_IR_SCAN_int (9)
#define CAPTURE_IR_int (10)
#define SHIFT_IR_int (11)
#define EXIT1_IR_int (12)
#define PAUSE_IR_int (13)
#define EXIT2_IR_int (14)
#define UPDATE_IR_int (15)



#define BYPASS_INST ch_bit<32>(0)
#define ID_INST ch_bit<32>(1)
#define DATA_INST ch_bit<32>(2)

#define BYPASS_INST_int (0)
#define ID_INST_int (1)
#define DATA_INST_int (2)

