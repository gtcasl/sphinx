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

using namespace ch::core;
using namespace ch::sim;

struct Pipeline
{

  __io(
    __in(ch_bit<32>) in_din,
    __in(ch_bool) in_push,
    __out(ch_bit<32>) actual_change
  );

  void describe()
  {



    // Host to fetch
    fetch.io.in_din(io.in_din);
    fetch.io.in_push(io.in_push);

    // fetch TO f_d_register
    f_d_register.io.in_instruction(fetch.io.out_instruction);
    f_d_register.io.in_PC_next(fetch.io.out_PC_next);

    // f_d_register to decode
    decode.io.in_instruction(f_d_register.io.out_instruction);
    decode.io.in_PC_next(f_d_register.io.out_PC_next);

    // decode to d_e_register
    d_e_register.io.in_opcode(decode.io.out_opcode);
    d_e_register.io.in_rd(decode.io.out_rd);
    d_e_register.io.in_rs1(decode.io.out_rs1);
    d_e_register.io.in_rd1(decode.io.out_rd1);
    d_e_register.io.in_rs2(decode.io.out_rs2);
    d_e_register.io.in_rd2(decode.io.out_rd2);
    d_e_register.io.in_alu_op(decode.io.out_alu_op);
    d_e_register.io.in_PC_next(decode.io.out_PC_next);
    d_e_register.io.in_wb(decode.io.out_wb);
    // d_e_register.io(decode.io);

    // d_e_register to execute
    execute.io.in_opcode(d_e_register.io.out_opcode);
    execute.io.in_rd(d_e_register.io.out_rd);
    execute.io.in_rs1(d_e_register.io.out_rs1);
    execute.io.in_rd1(d_e_register.io.out_rd1);
    execute.io.in_rs2(d_e_register.io.out_rs2);
    execute.io.in_rd2(d_e_register.io.out_rd2);
    execute.io.in_alu_op(d_e_register.io.out_alu_op);
    execute.io.in_PC_next(d_e_register.io.out_PC_next);
    execute.io.in_wb(d_e_register.io.out_wb);

    // execute to e_m_register
    e_m_register.io.in_alu_result(execute.io.out_alu_result);
    e_m_register.io.in_rd(execute.io.out_rd);
    e_m_register.io.in_rs1(execute.io.out_rs1);
    e_m_register.io.in_rs2(execute.io.out_rs2);
    e_m_register.io.in_PC_next(execute.io.out_PC_next);
    e_m_register.io.in_wb(execute.io.out_wb);

    // e_m_regsiter to memory
    memory.io.in_alu_result(e_m_register.io.out_alu_result);
    memory.io.in_rd(e_m_register.io.out_rd);
    memory.io.in_rs1(e_m_register.io.out_rs1);
    memory.io.in_rs2(e_m_register.io.out_rs2);
    memory.io.in_PC_next(e_m_register.io.out_PC_next);
    memory.io.in_wb(e_m_register.io.out_wb);


    // memory to m_w_register
    m_w_register.io.in_alu_result(memory.io.out_alu_result);
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

    // write_back to decode
    decode.io.in_alu_result(write_back.io.out_alu_result);
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

// 01000000010100110000001000110011
// 0x00530233
// 0x00330233
// 0x00628233
// 0x00420233
// 0x00530233
// 0x00000000
class RocketChip
{
    public:
        RocketChip(std::string);
        void simulate();
        void export_model(void);
    private:
        ch_device<Pipeline> pipeline;
        ch_tracer sim;
        std::ifstream instruction_file;
};


RocketChip::RocketChip(std::string instruction_file_name)
{
    sim = ch_tracer(this->pipeline);
    instruction_file.open(instruction_file_name);
    if (!instruction_file) {
        std::cout << "Unable to open file";
        exit(1); // terminate with error
    }
}

void RocketChip::simulate()
{

    sim.run([&](ch_tick t)->bool {

        int inst;

        if (this->instruction_file >> std::hex >> inst)
        {
            std::cout << "inst: " << std::hex << inst << std::endl;
            pipeline.io.in_din = inst;
            pipeline.io.in_push = true;
        }
        else
        {
            pipeline.io.in_din = 0x00000000;
            pipeline.io.in_push = false;
        }

        std::cout << "\n-------------------------------------t: " << (t) << std::endl;
        std::cout << "actual_change: " << pipeline.io.actual_change << std::endl;

        return (t != 30);
    });

}

void RocketChip::export_model()
{
    ch_toVerilog("pipeline.v", pipeline);
    sim.toVCD("pipeline.vcd");
}

