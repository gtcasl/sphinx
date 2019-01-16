

#ifndef __DEFINITIONS__
#define __DEFINITIONS__

#include "config.h"

// SIZES
#define INST_SIZE 32
#define INST_BUFF_SIZE
#define WORD_SIZE 32
#define CACHE_SIZE 4096


//BOOL
#define TRUE ch_bool(true)
#define FALSE ch_bool(false)


// OPCODES
#define R_INST 51
#define L_INST 3
#define ALU_INST 19
#define S_INST 35
#define B_INST 99
#define LUI_INST 55
#define AUIPC_INST 23
#define JAL_INST 111
#define JALR_INST 103
#define SYS_INST 115



// BRANCH
#define NO_BRANCH ch_bit<3>(0)
#define BEQ ch_bit<3>(1)
#define BNE ch_bit<3>(2)
#define BLT ch_bit<3>(3)
#define BGT ch_bit<3>(4)
#define BLTU ch_bit<3>(5)
#define BGTU ch_bit<3>(6)

#define NO_BRANCH_int (0)
#define BEQ_int (1)
#define BNE_int (2)
#define BLT_int (3)
#define BGT_int (4)
#define BLTU_int (5)
#define BGTU_int (6)

#define TAKEN ch_bit<1>(1)
#define NOT_TAKEN ch_bit<1>(0)

#define TAKEN_int (1)
#define NOT_TAKEN_int (0)


// STALLS
#define STALL ch_bit<1>(1)
#define NO_STALL ch_bit<1>(0)

#define STALL_int (1)
#define NO_STALL_int (0)


// VALID
#define VALID ch_bit<1>(1)
#define NO_VALID ch_bit<1>(0)

#define VALID_int (1)
#define NO_VALID_int (0)

// ALU OPS
#define NO_ALU ch_bit<4>(15)
#define ADD ch_bit<4>(0)
#define SUB ch_bit<4>(1)
#define SLLA ch_bit<4>(2)
#define SLT ch_bit<4>(3)
#define SLTU ch_bit<4>(4)
#define XOR ch_bit<4>(5)
#define SRL ch_bit<4>(6)
#define SRA ch_bit<4>(7)
#define OR ch_bit<4>(8)
#define AND ch_bit<4>(9)
#define SUBU ch_bit<4>(10)
#define LUI_ALU ch_bit<4>(11)
#define AUIPC_ALU ch_bit<4>(12)
#define CSR_ALU_RW ch_bit<4>(13)
#define CSR_ALU_RS ch_bit<4>(14)
#define CSR_ALU_RC ch_bit<4>(15)


#define NO_ALU_int (15)
#define ADD_int (0)
#define SUB_int (1)
#define SLLA_int (2)
#define SLT_int (3)
#define SLTU_int (4)
#define XOR_int (5)
#define SRL_int (6)
#define SRA_int (7)
#define OR_int (8)
#define AND_int (9)
#define SUBU_int (10)
#define LUI_ALU_int (11)
#define AUIPC_ALU_int (12)
#define CSR_ALU_RW_int (13)
#define CSR_ALU_RS_int (14)
#define CSR_ALU_RC_int (15)

// WRITEBACK
#define WB_ALU ch_bit<2>(1)
#define WB_MEM ch_bit<2>(2)
#define WB_JAL ch_bit<2>(3)
#define NO_WB  ch_bit<2>(0)

#define WB_ALU_int (1)
#define WB_MEM_int (2)
#define WB_JAL_int (3)
#define NO_WB_int  (0)

// JAL
#define JUMP ch_bit<1>(1)
#define NO_JUMP ch_bit<1>(0)

#define JUMP_int (1)
#define NO_JUMP_int (0)

// RS2 SRC
#define RS2_IMMED ch_bit<1>(1)
#define RS2_REG ch_bit<1>(0)

#define RS2_IMMED_int (1)
#define RS2_REG_int (0)


// FORWARDING
#define NO_FWD ch_bit<1>(0)
#define FWD ch_bit<1>(1)


// FORWARDING CODES
#define NO_FWD_ ch_bit<4>(0)
#define EXE_PC_NEXT ch_bit<4>(1)
#define EXE_ALU ch_bit<4>(2)
#define MEM_PC_NEXT ch_bit<4>(3)
#define MEM_MEM_DATA ch_bit<4>(4)
#define MEM_ALU ch_bit<4>(5)
#define WB_PC_NEXT ch_bit<4>(6)
#define WB_MEM_DATA ch_bit<4>(7)
#define WB_ALU_ ch_bit<4>(8)


#define NO_FWD_int (0)
#define EXE_PC_NEXT_int (1)
#define EXE_ALU_int (2)
#define MEM_PC_NEXT_int (3)
#define MEM_MEM_DATA_int (4)
#define MEM_ALU_int (5)
#define WB_PC_NEXT_int (6)
#define WB_MEM_DATA_int (7)
#define WB_ALU_int_ (8)



// Registers
#define REG(x) ch_bit<5>(x)

// IMMEDIATES 
#define ZERO 0
#define CH_ZERO(x) ch_bit<x>(0)
#define ONES_24BITS 16777215
#define ONES_16BITS 65535
#define ONES_11BITS ch_bit<11>(2047)
#define ONES_20BITS ch_bit<20>(1048575)
#define anything ch_bit<12>(123)
#define anything32 ch_bit<32>(123)
#define anything20 ch_bit<20>(123)
#define INT_MAX    0xFFFFFFFF

// MEMORY

#define NO_MEM_READ  ch_bit<3>(7)
#define LB_MEM_READ  ch_bit<3>(0)
#define LH_MEM_READ  ch_bit<3>(1)
#define LW_MEM_READ  ch_bit<3>(2)
#define LBU_MEM_READ ch_bit<3>(4)
#define LHU_MEM_READ ch_bit<3>(5)

#define NO_MEM_READ_int  (7)
#define LB_MEM_READ_int  (0)
#define LH_MEM_READ_int  (1)
#define LW_MEM_READ_int  (2)
#define LBU_MEM_READ_int (4)
#define LHU_MEM_READ_int (5)

#define NO_MEM_WRITE ch_bit<3>(7)
#define SB_MEM_WRITE ch_bit<3>(0)
#define SH_MEM_WRITE ch_bit<3>(1)
#define SW_MEM_WRITE ch_bit<3>(2)

#define NO_MEM_WRITE_int (7)
#define SB_MEM_WRITE_int (0)
#define SH_MEM_WRITE_int (1)
#define SW_MEM_WRITE_int (2)

// DBUS_CONTROL
#define DBUS_NONE ch_bit<3>(0)
#define DBUS_READ ch_bit<3>(1)
#define DBUS_WRITE ch_bit<3>(2)
#define DBUS_RW ch_bit<3>(3)

#define DBUS_NONE_int (0)
#define DBUS_READ_int (1)
#define DBUS_WRITE_int (2)
#define DBUS_RW_int (3)

// REG
#define ZERO_REG ch_bit<5>(0)
#define ZERO_REG_int (0)


// COLORS
#define GREEN "\033[32m"
#define RED "\033[31m"
#define DEFAULT "\033[39m"

// FETCH STATES
#define P_STATE ch_bit<5>(0)
#define J_STATE ch_bit<5>(1)
#define B_STATE ch_bit<5>(2)
#define I_STATE ch_bit<5>(3)
#define S_STATE ch_bit<5>(4)

#define P_STATE_int 0
#define J_STATE_int 1
#define B_STATE_int 2
#define I_STATE_int 3
#define S_STATE_int 4


// ICACHE
#define ICACHE_NORMAL TRUE
#define ICACHE_MISS   FALSE

#ifdef  ICACHE_ENABLE

	#define ILINE_SIZE    (1<<ILINE_BITS)
	#define ICACHE_SIZE   (1<<ICACHE_BITS)
	#define INUM_LINES    (1<<(ICACHE_BITS - ILINE_BITS))
	#define INUM_BITS     (ICACHE_BITS - ILINE_BITS)
	#define IG_TAG_BITS   (ICACHE_BITS)
	#define ITAG_BITS     (32 - ICACHE_BITS)
	#define OFFSET_BITS   (ILINE_BITS + 3)
	#define LINE_BIT_SIZE (ILINE_SIZE << 3)

	#define ITAG_MASK      (((1<<ITAG_BITS) - 1) << ICACHE_BITS)

	#define CACHE_ENABLED

#endif



#ifdef  DCACHE_ENABLE

	// #endif

	#ifndef CACHE_ENABLED

		#define CACHE_ENABLED

	#endif

#endif

#define NUM_TESTS 39

#include <chrono> 
typedef std::chrono::time_point<std::chrono::high_resolution_clock> clock_time;
typedef std::chrono::duration<double> clock_diff;

#define duration(a) std::chrono::duration_cast<std::chrono::nanoseconds>(a).count()
#define timeNow() std::chrono::high_resolution_clock::now()

#endif