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
#include "buses.h"
#include "define.h"

// Handlers
#include "interrupt_handler.h"
#include "csr_handler.h"

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

// JTAG
#include "JTAG/jtag.h"

using namespace ch::core;
using namespace ch::sim;
using namespace ch::htl;

bool debug = false;
#define IBUS_WIDTH 32
struct Pipeline
{

  __io(
    (IBUS_io)         IBUS,
    (DBUS_io)         DBUS,
    (INTERRUPT_io)    INTERRUPT,
    (JTAG_io)         jtag,

    __out(ch_bool)    out_fwd_stall, // DInst counting
    __out(ch_bool)    out_branch_stall // DInst counting
  );

  void describe()
  {


    // DYNAMIC INSTRUCTION COUNTING:
    #ifdef BRANCH_WB
        io.out_branch_stall = decode.io.out_branch_stall || execute.io.out_branch_stall || memory.io.out_branch_stall;
    #else
        io.out_branch_stall = decode.io.out_branch_stall || execute.io.out_branch_stall;
    #endif
    io.out_fwd_stall    = forwarding.io.out_fwd_stall;

    // IBUS I/O
    fetch.io.IBUS(io.IBUS);

    // DBUS I/O
    memory.io.DBUS(io.DBUS);

    // JTAG I/O
    jtag_handler.io.JTAG(io.jtag);

    // Interrupt I/O
    interrupt_handler.io.INTERRUPT(io.INTERRUPT);

    // interrupt handler to FETCH
    fetch.io.in_interrupt(interrupt_handler.io.out_interrupt);
    fetch.io.in_interrupt_pc(interrupt_handler.io.out_interrupt_pc);


    // EXE TO FETCH
    #ifdef BRANCH_WB
        m_w_register.io.in_branch_dir(memory.io.out_branch_dir);
        m_w_register.io.in_branch_dest(memory.io.out_branch_dest);

        fetch.io.in_branch_dir(m_w_register.io.out_branch_dir);
        fetch.io.in_branch_dest(m_w_register.io.out_branch_dest);
    #else
        fetch.io.in_branch_dir(memory.io.out_branch_dir);
        fetch.io.in_branch_dest(memory.io.out_branch_dest);
    #endif

    // DECODE TO FETCH
    #ifdef JAL_MEM
    e_m_register.io.in_jal(execute.io.out_jal);
    e_m_register.io.in_jal_dest(execute.io.out_jal_dest);  
    fetch.io.in_jal(e_m_register.io.out_jal);
    fetch.io.in_jal_dest(e_m_register.io.out_jal_dest);  
    #else
    fetch.io.in_jal(execute.io.out_jal);
    fetch.io.in_jal_dest(execute.io.out_jal_dest);
    #endif

    // fetch TO f_d_register
    f_d_register.io.in_instruction(fetch.io.out_instruction);
    // f_d_register.io.in_PC_next(fetch.io.out_PC_next);
    f_d_register.io.in_curr_PC(fetch.io.out_curr_PC);

    // f_d_register to decode
    decode.io.in_instruction(f_d_register.io.out_instruction);
    // decode.io.in_PC_next(f_d_register.io.out_PC_next);
    decode.io.in_curr_PC(f_d_register.io.out_curr_PC);

    // decode.io.in_csr_data(csr_handler.io.out_decode_csr_data);

    // CSR HANDLER
    csr_handler.io.in_decode_csr_address(decode.io.out_csr_address);
    csr_handler.io.in_mem_csr_address(e_m_register.io.out_csr_address);
    csr_handler.io.in_mem_is_csr(e_m_register.io.out_is_csr);
    csr_handler.io.in_mem_csr_result(e_m_register.io.out_csr_result);


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
    d_e_register.io.in_csr_address(decode.io.out_csr_address);
    d_e_register.io.in_is_csr(decode.io.out_is_csr);
    // d_e_register.io.in_csr_data(decode.io.out_csr_data);
    d_e_register.io.in_csr_mask(decode.io.out_csr_mask);
    d_e_register.io.in_jal(decode.io.out_jal);
    d_e_register.io.in_jal_offset(decode.io.out_jal_offset);
    d_e_register.io.in_curr_PC(f_d_register.io.out_curr_PC);
    // d_e_register.io(decode.io);


    // Decode to f_d_register
    f_d_register.io.in_branch_stall = decode.io.out_branch_stall;
    // Decode to FETCH
    fetch.io.in_branch_stall = decode.io.out_branch_stall;


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
    execute.io.in_csr_address(d_e_register.io.out_csr_address);
    execute.io.in_is_csr(d_e_register.io.out_is_csr);
    // execute.io.in_csr_data(d_e_register.io.out_csr_data);
    execute.io.in_csr_data(csr_handler.io.out_decode_csr_data);
    execute.io.in_csr_mask(d_e_register.io.out_csr_mask);
    execute.io.in_jal(d_e_register.io.out_jal);
    execute.io.in_jal_offset(d_e_register.io.out_jal_offset);
    execute.io.in_curr_PC(d_e_register.io.out_curr_PC);

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
    e_m_register.io.in_csr_address(execute.io.out_csr_address);
    e_m_register.io.in_is_csr(execute.io.out_is_csr);
    e_m_register.io.in_csr_result(execute.io.out_csr_result);
    e_m_register.io.in_curr_PC(d_e_register.io.out_curr_PC);
    e_m_register.io.in_branch_type(d_e_register.io.out_branch_type);
    e_m_register.io.in_branch_offset(execute.io.out_branch_offset);

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
    memory.io.in_curr_PC(e_m_register.io.out_curr_PC);
    memory.io.in_branch_offset(e_m_register.io.out_branch_offset);
    memory.io.in_branch_type(e_m_register.io.out_branch_type);


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
    forwarding.io.in_decode_csr_address(decode.io.out_csr_address);

    forwarding.io.in_execute_dest(execute.io.out_rd);
    forwarding.io.in_execute_wb(execute.io.out_wb);
    forwarding.io.in_execute_alu_result(execute.io.out_alu_result);
    forwarding.io.in_execute_PC_next(execute.io.out_PC_next);
    forwarding.io.in_execute_is_csr(execute.io.out_is_csr);
    forwarding.io.in_execute_csr_address(execute.io.out_csr_address);
    forwarding.io.in_execute_csr_result(execute.io.out_csr_result);

    forwarding.io.in_memory_dest(memory.io.out_rd);
    forwarding.io.in_memory_wb(memory.io.out_wb);
    forwarding.io.in_memory_alu_result(memory.io.out_alu_result);
    forwarding.io.in_memory_mem_data(memory.io.out_mem_result);
    forwarding.io.in_memory_PC_next(memory.io.out_PC_next);
    forwarding.io.in_memory_is_csr(e_m_register.io.out_is_csr);
    forwarding.io.in_memory_csr_address(e_m_register.io.out_csr_address);
    forwarding.io.in_memory_csr_result(e_m_register.io.out_csr_result);

    forwarding.io.in_writeback_dest(m_w_register.io.out_rd);
    forwarding.io.in_writeback_wb(m_w_register.io.out_wb);
    forwarding.io.in_writeback_alu_result(m_w_register.io.out_alu_result);
    forwarding.io.in_writeback_mem_data(m_w_register.io.out_mem_result);
    forwarding.io.in_writeback_PC_next(m_w_register.io.out_PC_next);

    #ifdef FORWARDING
        decode.io.in_src1_fwd(forwarding.io.out_src1_fwd);
        decode.io.in_src2_fwd(forwarding.io.out_src2_fwd);
        decode.io.in_csr_fwd(forwarding.io.out_csr_fwd);
        decode.io.in_src1_fwd_data(forwarding.io.out_src1_fwd_data);
        decode.io.in_src2_fwd_data(forwarding.io.out_src2_fwd_data);
        decode.io.in_csr_fwd_data(forwarding.io.out_csr_fwd_data);
    #endif

    #ifdef BRANCH_WB
        decode.io.in_stall = (execute.io.out_branch_stall == STALL) || memory.io.out_branch_stall;

        fetch.io.in_branch_stall_exe = execute.io.out_branch_stall || memory.io.out_branch_stall;
        f_d_register.io.in_branch_stall_exe = execute.io.out_branch_stall || memory.io.out_branch_stall;
        d_e_register.io.in_branch_stall = execute.io.out_branch_stall || memory.io.out_branch_stall;
    #else
        decode.io.in_stall = (execute.io.out_branch_stall == STALL);

        fetch.io.in_branch_stall_exe = execute.io.out_branch_stall;
        f_d_register.io.in_branch_stall_exe = execute.io.out_branch_stall;
        d_e_register.io.in_branch_stall = execute.io.out_branch_stall;
    #endif
    

    fetch.io.in_fwd_stall        = forwarding.io.out_fwd_stall;
    f_d_register.io.in_fwd_stall = forwarding.io.out_fwd_stall;  
    d_e_register.io.in_fwd_stall = forwarding.io.out_fwd_stall;


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
  ch_module<Interrupt_Handler> interrupt_handler;
  ch_module<JTAG> jtag_handler;
  ch_module<CSR_Handler> csr_handler;
};


class Sphinx
{
    public:
        Sphinx();
        ~Sphinx();
        bool simulate(std::string);
        void export_model(void);
    private:

        void ProcessFile(void);
        void print_stats(void);


        bool ibus_driver(ch_device<Pipeline> &);
        void dbus_driver(ch_device<Pipeline> &);
        void interrupt_driver(ch_device<Pipeline> &);
        void jtag_driver(ch_device<Pipeline> &);

        std::map<unsigned,unsigned> inst_map;
        RAM ram;

        unsigned start_pc;

        ch_device<Pipeline> pipeline;

        ch_tracer sim;
        std::string instruction_file_name;
        std::ofstream results;
        int stats_static_inst;
        int stats_dynamic_inst;
        int stats_total_cycles;
        int stats_fwd_stalls;
        int stats_branch_stalls;
        clock_diff stats_sim_time;
};


Sphinx::Sphinx() : start_pc(0), stats_static_inst(0), stats_dynamic_inst(-1), stats_total_cycles(0),
                                                                stats_fwd_stalls(0), stats_branch_stalls(0)
{
    this->sim = ch_tracer(this->pipeline);
    this->results.open("../results/results.txt");
}

Sphinx::~Sphinx()
{
    this->results.close();
}

void Sphinx::ProcessFile(void)
{

    loadHexImpl(this->instruction_file_name, &this->ram);

    // Printing state

    if(debug) std::cout << "$$$$$$$$$$$$$$$$$$$$$$$" << std::endl;

    // uint32_t address = 0x80000038;
    // // uint32_t * data = new uint32_t[64];
    // // ram.getBlock(address,data);

    // if(debug) std::cout << "GOT BLOCK" << std::endl;

    // for (uint32_t new_address = (address&0xffffff00); new_address < ((address&0xffffff00) + 256); new_address += 4 )
    // {

    //     uint32_t curr_word;
    //     ram.getWord(new_address, &curr_word);

    //     if(debug) std::cout << std::setfill('0');
    //     if(debug) std::cout << std::hex << new_address << ": " << std::hex << std::setw(8) << curr_word;
    //     if(debug) std::cout << std::endl;

    // }


    // if(debug) std::cout << "***********************" << std::endl;

}

bool Sphinx::ibus_driver(ch_device<Pipeline> & pipeline)
{
    ////////////////////// IBUS //////////////////////
    unsigned new_PC;
    bool stop = false;
    uint32_t curr_inst = 0xdeadbeef;


    pipeline.io.IBUS.out_address.ready = pipeline.io.IBUS.out_address.valid;
    new_PC                             = (unsigned) pipeline.io.IBUS.out_address.data;
    ram.getWord(new_PC, &curr_inst);
    pipeline.io.IBUS.in_data.data      = curr_inst;
    pipeline.io.IBUS.in_data.valid     = true;

    ////////////////////// IBUS //////////////////////

    ////////////////////// STATS //////////////////////
    if (pipeline.io.out_fwd_stall || pipeline.io.out_branch_stall)
    {
        --stats_dynamic_inst;
        if (pipeline.io.out_fwd_stall) ++this->stats_fwd_stalls;
        if (pipeline.io.out_branch_stall) ++this->stats_branch_stalls;
    }
    ++stats_total_cycles;

    if(debug) std::cout << "new_PC: " << new_PC << std::endl;

    if ((curr_inst != 0) && (curr_inst != 0xffffffff))
    {
        ++stats_dynamic_inst;
        if(debug) std::cout << "new_PC: " << new_PC << "  inst_going_in: " << std::hex << curr_inst << std::endl;
        stop = false;
    } else
    {
        stop = true;
    }

    if(debug) std::cout << "------------------------------------------";
    if(debug) std::cout << std::endl << std::endl << std::endl << std::endl;
   ////////////////////// STATS //////////////////////

    return stop;

}

void Sphinx::dbus_driver(ch_device<Pipeline> & pipeline)
{
    uint32_t data_read;
    ////////////////////// DBUS //////////////////////
    pipeline.io.DBUS.out_data.ready    = pipeline.io.DBUS.out_data.valid;
    pipeline.io.DBUS.out_address.ready = pipeline.io.DBUS.out_address.valid;
    pipeline.io.DBUS.out_control.ready = pipeline.io.DBUS.out_control.valid;

    bool valid_address = false;
    if (pipeline.io.DBUS.out_address.valid)
    {
        valid_address = true;
    }

    bool read_data  = false;
    bool write_data = false;

    if (pipeline.io.DBUS.out_control.ready && pipeline.io.DBUS.out_control.valid)
    {
        if ((pipeline.io.DBUS.out_control.data.as_scint() == DBUS_READ_int) || (pipeline.io.DBUS.out_control.data.as_scint() == DBUS_RW_int))
        {
            if (pipeline.io.DBUS.in_data.ready)
            {
                read_data = true;
            }
        }

        if ((pipeline.io.DBUS.out_control.data.as_scint() == DBUS_WRITE_int) || (pipeline.io.DBUS.out_control.data.as_scint() == DBUS_RW_int))
        {
            if (pipeline.io.DBUS.out_data.valid)
            {
                write_data = true;
            }
        }
    }

    if (read_data && valid_address)
    {
        ram.getWord((uint32_t) pipeline.io.DBUS.out_address.data, &data_read);
        if(debug) std::cout << "ABOUT TO: " << (uint32_t) pipeline.io.DBUS.out_address.data << " read from data: " << data_read << "\n";
        pipeline.io.DBUS.in_data.data = data_read;
        pipeline.io.DBUS.in_data.valid = true;
    } else
    {
        pipeline.io.DBUS.in_data.data  = 0x123;
        pipeline.io.DBUS.in_data.valid = false;
    }


    if (write_data && valid_address)
    {
        if(debug) std::cout << "ABOUT TO: " << (uint32_t) pipeline.io.DBUS.out_address.data << "write to data: " << (uint32_t) pipeline.io.DBUS.out_data.data << "\n";
        uint32_t data_to_write = (uint32_t) pipeline.io.DBUS.out_data.data;
        ram.writeWord((uint32_t) pipeline.io.DBUS.out_address.data, &data_to_write);
    }
    ////////////////////// DBUS //////////////////////
}

void Sphinx::interrupt_driver(ch_device<Pipeline> & pipeline)
{

    ////////////////////// INTERRUPT //////////////////////

    pipeline.io.INTERRUPT.in_interrupt_id.valid = false;
    pipeline.io.INTERRUPT.in_interrupt_id.data  = 0;

    ////////////////////// INTERRUPT //////////////////////

}

void Sphinx::jtag_driver(ch_device<Pipeline> & pipeline)
{

    ////////////////////// JATG //////////////////////

    pipeline.io.jtag.JTAG_TAP.in_mode_select.valid = false;
    pipeline.io.jtag.JTAG_TAP.in_mode_select.data  = 0;

    pipeline.io.jtag.JTAG_TAP.in_clock.valid       = false;
    pipeline.io.jtag.JTAG_TAP.in_clock.data        = 0;

    pipeline.io.jtag.JTAG_TAP.in_reset.valid       = false;
    pipeline.io.jtag.JTAG_TAP.in_reset.data        = 0;

    pipeline.io.jtag.in_data.valid                 = false;
    pipeline.io.jtag.in_data.data                  = 0;

    pipeline.io.jtag.out_data.ready                = false;

    ////////////////////// JATG //////////////////////

}

bool Sphinx::simulate(std::string file_to_simulate) {

    this->instruction_file_name = file_to_simulate;
    this->results << "\n****************\t" << file_to_simulate << "\t****************\n";

    this->ProcessFile();

    clock_time start_time = std::chrono::high_resolution_clock::now();

    sim.run([&](ch_tick t)->bool {

        if(debug) std::cout << "Cycle: " << t/2 << std::endl;


        static bool stop      = false;
        static int counter    = 0;

        stop = ibus_driver(pipeline);
               dbus_driver(pipeline);
               interrupt_driver(pipeline);
               jtag_driver(pipeline);

        if (stop)
        {
            counter++;
        } else
        {
            counter = 0;
        }


        // RETURNS FALSE TO STOP
        return !(stop && (counter > 5));
    });

    {
        using namespace std::chrono;
        this->stats_sim_time = duration_cast<microseconds>(high_resolution_clock::now() - start_time);
    }

    uint32_t status;
    ram.getWord(0, &status);

    this->print_stats();
    return (status == 1);
}


void Sphinx::print_stats(void)
{
    this->results << std::left;
    // this->results << "# Static Instructions:\t" << std::dec << this->stats_static_inst << std::endl;
    this->results << std::setw(24) << "# Dynamic Instructions:" << std::dec << this->stats_dynamic_inst << std::endl;
    this->results << std::setw(24) << "# of total cycles:" << std::dec << this->stats_total_cycles << std::endl;
    this->results << std::setw(24) << "# of forwarding stalls:" << std::dec << this->stats_fwd_stalls << std::endl;
    this->results << std::setw(24) << "# of branch stalls:" << std::dec << this->stats_branch_stalls << std::endl;
    this->results << std::setw(24) << "# CPI:" << std::dec << (double) this->stats_total_cycles / (double) this->stats_dynamic_inst << std::endl;
    this->results << std::setw(24) << "# time to simulate: " << std::dec << this->stats_sim_time.count() << " ms" << std::endl;


    uint32_t status;
    ram.getWord(0, &status);

    if (status == 1)
    {
        this->results << std::setw(24) << "# GRADE:" << " PASSING\n";
    } else
    {
        this->results << std::setw(24) << "# GRADE:" << " Failed on test: " << status << "\n";
    }

    this->stats_static_inst   =  0;
    this->stats_dynamic_inst  = -1;
    this->stats_total_cycles  =  0;
    this->stats_fwd_stalls    =  0;
    this->stats_branch_stalls =  0;

}

void Sphinx::export_model()
{
    ch_toVerilog("pipeline.v", pipeline);
    sim.toVCD("pipeline.vcd");
}

