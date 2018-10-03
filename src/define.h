

#ifndef __DEFINITIONS__
#define __DEFINITIONS__

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


// WRITEBACK
#define WB_ALU ch_bit<2>(1)
#define WB_MEM ch_bit<2>(2)
#define NO_WB  ch_bit<2>(0)

#define WB_ALU_int (1)
#define WB_MEM_int (2)
#define NO_WB_int  (0)

// RS2 SRC
#define RS2_IMMED ch_bit<1>(1)
#define RS2_REG ch_bit<1>(0)


// FORWARDING
#define NO_FWD ch_bit<1>(0)
#define FWD ch_bit<1>(1)


// IMMEDIATES 
#define ZERO 0
#define CH_ZERO(x) ch_bit<x>(0)
#define ONES_24BITS 16777215
#define ONES_16BITS 65535
#define anything ch_bit<12>(123)
#define anything32 ch_bit<32>(123)


#endif