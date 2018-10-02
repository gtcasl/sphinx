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

#include <iostream>
#include <iomanip>
#include <fstream>
#include <unistd.h>
#include <vector>
#include <math.h>


using namespace ch::core;
using namespace ch::sim;

struct Pipeline
{

  __io(
    __in(ch_bit<32>) in_din,
    __in(ch_bool) in_push,
    __out(ch_bit<32>) PC,
    __out(ch_bit<32>) actual_change
  );

  void describe()
  {



    // Host to fetch
    fetch.io.in_din(io.in_din);
    fetch.io.in_push(io.in_push);

    // FETCH TO HOST
    fetch.io.out_PC_next(io.PC);

    // EXE TO FETCH
    fetch.io.in_branch_dir(execute.io.out_branch_dir);
    fetch.io.in_branch_dest(execute.io.out_branch_dest);

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
    // d_e_register.io(decode.io);

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
        void filterHex(void);
        void populate_inst_vec(void);
        std::vector<unsigned> inst_vec;
        ch_device<Pipeline> pipeline;
        ch_tracer sim;
        std::string instruction_file_name;
};


RocketChip::RocketChip(std::string instruction_file_name)
{
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
    this->filterHex();

}

void RocketChip::asmToHex(void)
{
    system("/opt/riscv/bin/riscv32-unknown-linux-gnu-gcc ../traces/file.S -o ../Workspace/file.run");

    sleep(1);

    system("/usr/bin/bin/elf2hex 64 4096 ../Workspace/file.run >> ../Workspace/file.bin");
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
    std::ifstream ifs ("../Workspace/file.bin", std::ifstream::in);
    std::string line;
    std::string curr_inst;


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

            if (inst != 0)
            {
                ofs << inst << std::endl;
            }
        }
    }

    ofs.close();
    ifs.close();

    this->populate_inst_vec();// DEBUG

}


// DEBUG
void RocketChip::populate_inst_vec(void)
{

    std::cout << "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" << std::endl;

    unsigned inst;
    std::ifstream instruction_file("../Workspace/file.hex");
    int s = 0;
    while (instruction_file >> std::dec >> inst)
    {
        this->inst_vec.push_back(inst);
        s++;
    }


    for (int i = 0; i < this->inst_vec.size(); i++) std::cout << std::hex << this->inst_vec[i] << std::endl;

    std::cout << "END" << std::endl;
    std::cout << "# static instructions = " << this->inst_vec.size() << std::endl;
    std::cout << "# static s = " << s << std::endl;
}



void RocketChip::simulate(void) {


    std::cout << "***********************************" << std::endl;

    sim.run([&](ch_tick t)->bool {        

        std::cout << "t: " << (t) << std::endl;

        unsigned new_PC = (int) pipeline.io.PC;

        std::cout << "PC: " << std::dec <<  new_PC << std::endl;

        if (new_PC < this->inst_vec.size())
        {
            std::cout << "new_PC: " << new_PC << "  inst_going_in: " << std::hex << this->inst_vec[new_PC] << std::endl;
            pipeline.io.in_din = this->inst_vec[new_PC];
            pipeline.io.in_push = true;
        }
        else
        {
            pipeline.io.in_din = 0x00000000;
            pipeline.io.in_push = true;
        }

        std::cout << std::endl;
        
        return (new_PC < (this->inst_vec.size() + 10));
    });

}

void RocketChip::export_model()
{
    ch_toVerilog("pipeline.v", pipeline);
    sim.toVCD("pipeline.vcd");
}

