//
#include <cash.h>
#include <ioport.h>
#include <htl/queue.h>
#include <htl/decoupled.h>


// Pipeline Hardware definitions
#include "fetch.h"
#include "f_d_register.h"
#include "decode.h"
#include "d_e_register.h"
#include "execute.h"
#include "e_m_register.h"
#include "memory.h"
#include "m_w_register.h"
#include "write_back.h"
#include "forwarding.h"
#include "define.h"


// C++ libraries
#include <utility> 
#include <iostream>
#include <map> 
#include <iterator>
#include <iomanip>
#include <fstream>
#include <unistd.h>
#include <vector>
#include <math.h>

// RAM
#include "ram.h"

using namespace ch::core;
using namespace ch::sim;
using namespace ch::htl;

bool debug = true;
#define IBUS_WIDTH 32
struct Pipeline
{

  __io(
    (ch_enq_io<ch_bit<32>>) in_ibus_data,
    (ch_deq_io<ch_bit<32>>) out_ibus_address,

    __out(ch_bool) out_fwd_stall, // DInst counting
    __out(ch_bool) out_branch_stall, // DInst counting
    __out(ch_bit<32>) actual_change
  );

  void describe()
  {


    // DYNAMIC INSTRUCTION COUNTING:
    io.out_branch_stall = decode.io.out_branch_stall;
    io.out_fwd_stall    = forwarding.io.out_fwd_stall;

    // IBUS I/O
    fetch.io.in_ibus_data(io.in_ibus_data);
    fetch.io.out_ibus_address(io.out_ibus_address);




    // EXE TO FETCH
    fetch.io.in_branch_dir(execute.io.out_branch_dir);
    fetch.io.in_branch_dest(execute.io.out_branch_dest);
    // DECODE TO FETCH
    fetch.io.in_jal(decode.io.out_jal);
    fetch.io.in_jal_dest(decode.io.out_jal_dest);

    // fetch TO f_d_register
    f_d_register.io.in_instruction(fetch.io.out_instruction);
    f_d_register.io.in_PC_next(fetch.io.out_PC_next);

    // f_d_register to decode
    decode.io.in_instruction(f_d_register.io.out_instruction);
    decode.io.in_PC_next(f_d_register.io.out_PC_next);

    // decode to d_e_register
    d_e_register.io.in_rd(decode.io.out_rd);
    d_e_register.io.in_rs1(decode.io.out_rs1);
    d_e_register.io.in_rd1(decode.io.out_rd1);
    d_e_register.io.in_rs2(decode.io.out_rs2);
    d_e_register.io.in_rd2(decode.io.out_rd2);
    d_e_register.io.in_alu_op(decode.io.out_alu_op);
    d_e_register.io.in_PC_next(decode.io.out_PC_next);
    d_e_register.io.in_rs2_src(decode.io.out_rs2_src);
    d_e_register.io.in_itype_immed(decode.io.out_itype_immed);
    d_e_register.io.in_wb(decode.io.out_wb);
    d_e_register.io.in_mem_read(decode.io.out_mem_read);
    d_e_register.io.in_mem_write(decode.io.out_mem_write);
    d_e_register.io.in_branch_type(decode.io.out_branch_type); // branch type
    d_e_register.io.in_upper_immed(decode.io.out_upper_immed);
    // d_e_register.io(decode.io);


    // Decode to f_d_register
    f_d_register.io.in_branch_stall(decode.io.out_branch_stall);
    // Decode to FETCH
    fetch.io.in_branch_stall(decode.io.out_branch_stall);


    // d_e_register to execute
    execute.io.in_rd(d_e_register.io.out_rd);
    execute.io.in_rs1(d_e_register.io.out_rs1);
    execute.io.in_rd1(d_e_register.io.out_rd1);
    execute.io.in_rs2(d_e_register.io.out_rs2);
    execute.io.in_rd2(d_e_register.io.out_rd2);
    execute.io.in_alu_op(d_e_register.io.out_alu_op);
    execute.io.in_PC_next(d_e_register.io.out_PC_next);
    execute.io.in_rs2_src(d_e_register.io.out_rs2_src);
    execute.io.in_itype_immed(d_e_register.io.out_itype_immed);
    execute.io.in_wb(d_e_register.io.out_wb);
    execute.io.in_mem_read(d_e_register.io.out_mem_read);
    execute.io.in_mem_write(d_e_register.io.out_mem_write);
    execute.io.in_branch_type(d_e_register.io.out_branch_type);
    execute.io.in_upper_immed(d_e_register.io.out_upper_immed);

    // execute to e_m_register
    e_m_register.io.in_alu_result(execute.io.out_alu_result);
    e_m_register.io.in_rd(execute.io.out_rd);
    e_m_register.io.in_rs1(execute.io.out_rs1);
    e_m_register.io.in_rs2(execute.io.out_rs2);
    e_m_register.io.in_rd1(execute.io.out_rd1);
    e_m_register.io.in_rd2(execute.io.out_rd2);
    e_m_register.io.in_PC_next(execute.io.out_PC_next);
    e_m_register.io.in_wb(execute.io.out_wb);
    e_m_register.io.in_mem_read(execute.io.out_mem_read);
    e_m_register.io.in_mem_write(execute.io.out_mem_write);

    // e_m_regsiter to memory
    memory.io.in_alu_result(e_m_register.io.out_alu_result);
    memory.io.in_rd(e_m_register.io.out_rd);
    memory.io.in_rs1(e_m_register.io.out_rs1);
    memory.io.in_rd1(e_m_register.io.out_rd1);
    memory.io.in_rs2(e_m_register.io.out_rs2);
    memory.io.in_rd2(e_m_register.io.out_rd2);
    memory.io.in_PC_next(e_m_register.io.out_PC_next);
    memory.io.in_wb(e_m_register.io.out_wb);
    memory.io.in_mem_read(e_m_register.io.out_mem_read);
    memory.io.in_mem_write(e_m_register.io.out_mem_write);


    // memory to m_w_register
    m_w_register.io.in_alu_result(memory.io.out_alu_result);
    m_w_register.io.in_mem_result(memory.io.out_mem_result);
    m_w_register.io.in_rd(memory.io.out_rd);
    m_w_register.io.in_rs1(memory.io.out_rs1);
    m_w_register.io.in_rs2(memory.io.out_rs2);
    m_w_register.io.in_PC_next(memory.io.out_PC_next);
    m_w_register.io.in_wb(memory.io.out_wb);

    // m_w_register to write_back
    write_back.io.in_alu_result(m_w_register.io.out_alu_result);
    write_back.io.in_rd(m_w_register.io.out_rd);
    write_back.io.in_rs1(m_w_register.io.out_rs1);
    write_back.io.in_rs2(m_w_register.io.out_rs2);
    write_back.io.in_PC_next(m_w_register.io.out_PC_next);
    write_back.io.in_wb(m_w_register.io.out_wb);
    write_back.io.in_mem_result(m_w_register.io.out_mem_result);

    // write_back to decode
    decode.io.in_write_data(write_back.io.out_write_data);
    decode.io.in_rd(write_back.io.out_rd);
    decode.io.in_wb(write_back.io.out_wb);


    // Forwarding unit
    forwarding.io.in_decode_src1(decode.io.out_rs1);
    forwarding.io.in_decode_src2(decode.io.out_rs2);

    forwarding.io.in_execute_dest(execute.io.out_rd);
    forwarding.io.in_execute_wb(execute.io.out_wb);
    forwarding.io.in_execute_alu_result(execute.io.out_alu_result);
    forwarding.io.in_execute_PC_next(execute.io.out_PC_next);

    forwarding.io.in_memory_dest(memory.io.out_rd);
    forwarding.io.in_memory_wb(memory.io.out_wb);
    forwarding.io.in_memory_alu_result(memory.io.out_alu_result);
    forwarding.io.in_memory_mem_data(memory.io.out_mem_result);
    forwarding.io.in_memory_PC_next(memory.io.out_PC_next);

    forwarding.io.in_writeback_dest(m_w_register.io.out_rd);
    forwarding.io.in_writeback_wb(m_w_register.io.out_wb);
    forwarding.io.in_writeback_alu_result(m_w_register.io.out_alu_result);
    forwarding.io.in_writeback_mem_data(m_w_register.io.out_mem_result);
    forwarding.io.in_writeback_PC_next(m_w_register.io.out_PC_next);

    decode.io.in_src1_fwd(forwarding.io.out_src1_fwd);
    decode.io.in_src1_fwd_data(forwarding.io.out_src1_fwd_data);
    decode.io.in_src2_fwd(forwarding.io.out_src2_fwd);
    decode.io.in_src2_fwd_data(forwarding.io.out_src2_fwd_data);

    f_d_register.io.in_fwd_stall(forwarding.io.out_fwd_stall);
    d_e_register.io.in_fwd_stall(forwarding.io.out_fwd_stall);
    fetch.io.in_fwd_stall(forwarding.io.out_fwd_stall);
    decode.io.in_stall = (forwarding.io.out_fwd_stall == STALL);

    // debugging registers
    decode.io.actual_change(io.actual_change);

  }

  ch_module<Fetch> fetch;
  ch_module<F_D_Register> f_d_register;
  ch_module<Decode> decode;
  ch_module<D_E_Register> d_e_register;
  ch_module<Execute> execute;
  ch_module<E_M_Register> e_m_register;
  ch_module<Memory> memory;
  ch_module<M_W_Register> m_w_register;
  ch_module<Write_Back> write_back;
  ch_module<Forwarding> forwarding;
};


class RocketChip
{
    public:
        RocketChip(std::string);
        ~RocketChip();
        void simulate();
        void export_model(void);
    private:

        void ProcessFile(void);
        void print_stats(void);

        std::map<unsigned,unsigned> inst_map;
        RAM ram;

        unsigned start_pc;
        ch_device<Pipeline> pipeline;
        ch_tracer sim;
        std::string instruction_file_name;
        int stats_static_inst;
        int stats_dynamic_inst;
        int stats_total_cycles;
        int stats_fwd_stalls;
        int stats_branch_stalls;
        clock_diff stats_sim_time;
};


RocketChip::RocketChip(std::string instruction_file_name) : start_pc(0), stats_static_inst(0), stats_dynamic_inst(-1), stats_total_cycles(0),
                                                                stats_fwd_stalls(0), stats_branch_stalls(0)
{
    system("rm ../Workspace/*");

    sim = ch_tracer(this->pipeline);
    this->instruction_file_name = instruction_file_name;
    this->ProcessFile();
}

RocketChip::~RocketChip()
{
    // system("rm ../Workspace/*");
}

void RocketChip::ProcessFile(void)
{

    loadHexImpl(this->instruction_file_name, &this->ram);

    // Printing state

    std::cout << "$$$$$$$$$$$$$$$$$$$$$$$" << std::endl;

    uint32_t address = 0x80000038;
    // uint32_t * data = new uint32_t[64];
    // ram.getBlock(address,data);

    std::cout << "GOT BLOCK" << std::endl;

    for (uint32_t new_address = (address&0xffffff00); new_address < ((address&0xffffff00) + 256); new_address += 4 )
    {

        uint32_t curr_word;
        ram.getWord(new_address, &curr_word);

        std::cout << std::setfill('0');
        std::cout << std::hex << new_address << ": " << std::hex << std::setw(8) << curr_word;
        std::cout << std::endl;
        // std::cout << std::hex << (new_address + (address&0xffffff00)) << ": " << std::setw(2) << (unsigned) data[new_address + 3] << std::setw(2) << (unsigned) data[new_address + 2];
        // std::cout << std::setw(2) << (unsigned) data[new_address + 1] << std::setw(2) << (unsigned) data[new_address + 0] << std::endl;

        // std::cout << "total words: " << total_words << std::endl;

    }


    std::cout << "***********************" << std::endl;

}

void RocketChip::simulate(void) {

    std::cout << "***********************************" << std::endl;
    uint32_t curr_inst;
    unsigned new_PC;

    clock_time start_time = std::chrono::high_resolution_clock::now();
    sim.run([&](ch_tick t)->bool {        



        static bool stop = false;
        static int count = 0;

        // STATS START
        if (pipeline.io.out_fwd_stall || pipeline.io.out_branch_stall)
        {
            --stats_dynamic_inst;
            if (count > 0) --count;
            if (pipeline.io.out_fwd_stall) ++this->stats_fwd_stalls;
            if (pipeline.io.out_branch_stall) ++this->stats_branch_stalls;
        }
        ++stats_total_cycles;
        // STATS END

        pipeline.io.out_ibus_address.ready = pipeline.io.out_ibus_address.valid;

        new_PC = (unsigned) pipeline.io.out_ibus_address.data;


        ram.getWord(new_PC, &curr_inst);
        pipeline.io.in_ibus_data.data  = curr_inst;
        pipeline.io.in_ibus_data.valid = true;


        std::cout << "\nStep: " << t/2 << std::endl;
        std::cout << "new_PC: " << new_PC << std::endl;

        if ((curr_inst != 0) || (curr_inst != 0xffffffff))
        {
            ++stats_dynamic_inst;
            if (debug) std::cout << "new_PC: " << new_PC << "  inst_going_in: " << std::hex << curr_inst << std::endl;
            stop = false;
        } else
        {
            stop = true;
        }

            std::cout << "------------------------------------------";
            std::cout << std::endl << std::endl << std::endl << std::endl;
            
            return !stop;
            // return (new_PC < (this->inst_vec.size() + 6));
    });
    {
        using namespace std::chrono;
        this->stats_sim_time = duration_cast<microseconds>(high_resolution_clock::now() - start_time);
    }
    this->print_stats();
}


void RocketChip::print_stats(void)
{
    std::cout << std::left;
    // std::cout << "# Static Instructions:\t" << std::dec << this->stats_static_inst << std::endl;
    std::cout << std::setw(24) << "# Dynamic Instructions:" << std::dec << this->stats_dynamic_inst << std::endl;
    std::cout << std::setw(24) << "# of total cycles:" << std::dec << this->stats_total_cycles << std::endl;
    std::cout << std::setw(24) << "# of forwarding stalls:" << std::dec << this->stats_fwd_stalls << std::endl;
    std::cout << std::setw(24) << "# of branch stalls:" << std::dec << this->stats_branch_stalls << std::endl;
    std::cout << std::setw(24) << "# CPI:" << std::dec << (double) this->stats_total_cycles / (double) this->stats_dynamic_inst << std::endl;
    std::cout << std::setw(24) << "# time to simulate: " << std::dec << this->stats_sim_time.count() << " ms" << std::endl;
}

void RocketChip::export_model()
{
    ch_toVerilog("pipeline.v", pipeline);
    sim.toVCD("pipeline.vcd");
}

