//
#include <cash.h>
#include <ioport.h>

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

#include <utility> 
#include <iostream>
#include <map> 
#include <iterator>
#include <iomanip>
#include <fstream>
#include <unistd.h>
#include <vector>
#include <math.h>


using namespace ch::core;
using namespace ch::sim;

bool debug = true;

struct Pipeline
{

  __io(
    __in(ch_bit<32>) in_din,
    __in(ch_bool) in_push,

    __in(ch_bit<32>) in_cache_data, // CACHE REP

    __out(ch_bit<24>) out_cache_address, // CACHE REP
    __out(ch_bit<3>)  out_cache_mem_read, // CACHE REP
    __out(ch_bit<3>) out_cache_mem_write, // CACHE REP
    __out(ch_bit<32>) out_cache_data, // CACHE REP

    __out(ch_bool) out_fwd_stall, // DInst counting
    __out(ch_bool) out_branch_stall,
    __out(ch_bit<32>) PC,
    __out(ch_bit<32>) actual_change
  );

  void describe()
  {


    // DYNAMIC INSTRUCTION COUNTING:
    io.out_branch_stall = decode.io.out_branch_stall;
    io.out_fwd_stall    = forwarding.io.out_fwd_stall;

    // Host to fetch
    fetch.io.in_din(io.in_din);
    fetch.io.in_push(io.in_push);

    // CACHE REPLACEMENT
    memory.io.out_cache_address(io.out_cache_address);
    memory.io.out_cache_mem_write(io.out_cache_mem_write);
    memory.io.out_cache_mem_read(io.out_cache_mem_read);
    memory.io.out_cache_data(io.out_cache_data);

    memory.io.in_cache_data(io.in_cache_data);

    // FETCH TO HOST
    fetch.io.out_PC(io.PC);

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
        void asmToHex(void);
        void populate_inst_map(void);
        void get_start_address(void);
        void print_stats(void);
        void filterHex(void);

        std::map<unsigned,unsigned> inst_map;
        std::vector<unsigned> cache_vec;
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


RocketChip::RocketChip(std::string instruction_file_name) : stats_static_inst(0), stats_dynamic_inst(-1), stats_total_cycles(0),
                                                                stats_fwd_stalls(0), stats_branch_stalls(0)
{
    system("rm ../Workspace/*");
    this->cache_vec.resize(4096);

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

    this->asmToHex();
    this->populate_inst_map();
    this->get_start_address();
    this->filterHex();
}

void RocketChip::asmToHex(void)
{

    system("../scripts/compile_.sh");
}


// DEBUG
void RocketChip::populate_inst_map(void)
{

    std::ifstream instruction_file("../Workspace/add.hex");
    unsigned address;
    unsigned inst;
    while (instruction_file >> std::dec >> address >> inst)
    {
        inst_map.insert(std::pair<unsigned,unsigned>(address, inst));
        stats_static_inst++;
        if(debug) std::cout << "Address: " << std::hex << address << "\tInst: " << std::hex << inst << std::endl;
        if(debug) std::cout << "Static Inst: " << stats_static_inst << std::endl;
    }
    instruction_file.close();
    // exit(1);


    // inst_map.insert(std::pair<unsigned,unsigned>(0,0x00500113)); // addi $2, $0, 5
    // inst_map.insert(std::pair<unsigned,unsigned>(4,0x00a00193)); // addi $3, $0, 10
    // inst_map.insert(std::pair<unsigned,unsigned>(8,0x00218233)); // add  $4, $3, $2
    // inst_map.insert(std::pair<unsigned,unsigned>(12,0x00402023)); // SW   $4, $0(0)
    // inst_map.insert(std::pair<unsigned,unsigned>(16,0x00002283)); // LW  $5, $0(0) 
    // inst_map.insert(std::pair<unsigned,unsigned>(20,0x00520263)); // beq $4, $5, +4
    // inst_map.insert(std::pair<unsigned,unsigned>(24,0x00200313)); // addi $6, $0, 2
    // inst_map.insert(std::pair<unsigned,unsigned>(28,0x00700413)); // addi $8, $0, 7

    // exit(1);

}


void RocketChip::get_start_address(void)
{
    std::ifstream address_file("../Workspace/tags.hex");
    address_file >> std::dec >> this->start_pc;
    this->start_pc -= 4;
    if(debug) std::cout << "START_PC: " << std::hex << this->start_pc << std::endl;
    address_file.close();

    // exit(1);
}

int ctoh(char c)
{
    if (c == '0') return 0;
    if (c == '1') return 1;
    if (c == '2') return 2;
    if (c == '3') return 3;
    if (c == '4') return 4;
    if (c == '5') return 5;
    if (c == '6') return 6;
    if (c == '7') return 7;
    if (c == '8') return 8;
    if (c == '9') return 9;
    if (c == 'a') return 10;
    if (c == 'b') return 11;
    if (c == 'c') return 12;
    if (c == 'd') return 13;
    if (c == 'e') return 14;
    if (c == 'f') return 15;

    return -1;
}

void RocketChip::filterHex(void)
{



    std::ofstream ofs ("../Workspace/file.hex", std::ofstream::out);
    std::ifstream ifs ("../Workspace/add.bin", std::ifstream::in);
    std::string line;
    std::string curr_inst;

    int addr = 0;
    while (ifs >> line)
    {
        int ii;
        for (ii = 0; ii < 16; ii++)
        {
            curr_inst = line.substr(ii*8,8);


            unsigned jj;

            unsigned inst = 0;
            for (jj = 0; jj < curr_inst.size(); jj++)
            {
                if (curr_inst[jj] != '0')
                {

                    inst += ctoh(curr_inst[jj]) * pow(16, (curr_inst.size() - 1) - jj);
                } else
                {
                }
            }

            // if (inst != 0)
            {
                ofs << std::hex << addr << ": " << inst << std::endl;
                addr += 4;
            }
        }
    }

    ofs.close();
    ifs.close();

}

void RocketChip::simulate(void) {

    std::cout << "***********************************" << std::endl;

    clock_time start_time = std::chrono::high_resolution_clock::now();
    sim.run([&](ch_tick t)->bool {        

        // ******************************************
        // PART THAT REPLACES CACHE MODULE

        std::cout << "******************" << std::endl;
        std::cout << "CACHE MODULE" << std::endl;
        std::cout << "******************" << std::endl;

        unsigned data      = (int) pipeline.io.out_cache_data;
        unsigned address   = (int) pipeline.io.out_cache_address;
        unsigned mem_read  = (int) pipeline.io.out_cache_mem_read;
        unsigned mem_write = (int) pipeline.io.out_cache_mem_write;

        std::cout << "finished getting variables" << std::endl;

        if (mem_read == LW_MEM_READ_int)
        {
            std::cout << "ABOUT TO READ ADDRESS: " << address << std::endl;
            std::cout << "Reading ---> Address: " << address << "    Data: " << this->cache_vec[address] << std::endl;
            pipeline.io.in_cache_data = this->cache_vec[address];
        } else
        {
            std::cout << "Reading ---> N/A" << std::endl;
        }

        std::cout << "FINISHED READING PART" << std::endl;


        if (mem_write == SW_MEM_WRITE_int)
        {
            std::cout << "ABOUT TO WRITE ADDRESS: " << address << std::endl;
            std::cout << "Writing ---> Address: " << address << "    Data: " << data;
            this->cache_vec[address] = data;
        } else
        {
            std::cout << "Writing ---> N/A" << std::endl;
        }

        this->cache_vec[0] = 0;

        std::cout << "MEM_VALUE @ 0x35: " << this->cache_vec[0x35] << std::endl;

        std::cout << "******************" << std::endl;
        std::cout << "END CACHE MODULE" << std::endl;
        std::cout << "******************" << std::endl;

        // END PART THAT REPLACES CACHE MODULE
        // ******************************************

        unsigned new_PC = (int) pipeline.io.PC;
        static bool stop = false;
        static int count = 0;

        std::cout << "\nStep: " << t/2 << std::endl;
        std::cout << "new_PC: " << new_PC << std::endl;


        if (t == 0)
        {
            std::cout << "SETTING START PC: " << start_pc << std::endl;
            pipeline.io.in_din = start_pc;
            pipeline.io.in_push = true;
        }
        else
        {


            if (pipeline.io.out_fwd_stall || pipeline.io.out_branch_stall)
            {
                --stats_dynamic_inst;
                if (count > 0) --count;
                if (pipeline.io.out_fwd_stall) ++this->stats_fwd_stalls;
                if (pipeline.io.out_branch_stall) ++this->stats_branch_stalls;
            }

            ++stats_total_cycles;

            if ((this->inst_map.find(new_PC) != this->inst_map.end()) && !stop)
            {
                ++stats_dynamic_inst;
                if (debug) std::cout << "new_PC: " << new_PC << "  inst_going_in: " << std::hex << this->inst_map[new_PC] << std::endl;
                pipeline.io.in_din = this->inst_map[new_PC];
                pipeline.io.in_push = false;
            }
            else
            {

                if(debug) std::cout << "shutting down! PC: " << std::hex << new_PC << std::endl;
                stop = true;
                ++count;

                pipeline.io.in_din = 0x00000000;
                pipeline.io.in_push = false;
            }
        }

            std::cout << "------------------------------------------";
            std::cout << std::endl << std::endl << std::endl << std::endl;
            
            return (count < 5);
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

