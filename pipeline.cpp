#include <cash.h>
#include <ioport.h>

#include "fetch.h"
#include "f_d_register.h"

using namespace ch::core;
using namespace ch::sim;


struct Pipeline
{

  __io(
    __out(ch_bit<7>) opcode,
    __out(ch_bit<5>) rd,
    __out(ch_bit<5>) rs1,
    __out(ch_bit<5>) rs2,
    __out(ch_bit<3>) func3,
    __out(ch_bit<7>) func7,
    __out(ch_bit<2>) PC_next

  );

  void describe()
  {

    f_d_register.io.instruction(fetch.io.instruction);
    f_d_register.io.PC_next_in(fetch.io.PC_next);

    f_d_register.io.opcode(io.opcode);
    f_d_register.io.rd(io.rd);
    f_d_register.io.rs1(io.rs1);
    f_d_register.io.rs2(io.rs2);
    f_d_register.io.func3(io.func3);
    f_d_register.io.func7(io.func7);
    f_d_register.io.PC_next_out(io.PC_next);



  }

  ch_module<Fetch> fetch;
  ch_module<F_D_Register> f_d_register;
  
};




int main()
{

  ch_device<Pipeline> pipeline;
  ch_simulator sim(pipeline);
  sim.run([&](ch_tick t)->bool {

    std::cout << "t: " << t << std::endl;
    std::cout << "PC_next: " << pipeline.io.PC_next << std::endl;
    std::cout << "opcode  : " << pipeline.io.opcode  << std::endl;
    std::cout << "rd: " << pipeline.io.rd << std::endl;
    std::cout << "func3: " << pipeline.io.func3 << std::endl;
    std::cout << "rs1: " << pipeline.io.rs1 << std::endl;
    std::cout << "rs2: " << pipeline.io.rs2 << std::endl;
    std::cout << "func7: " << pipeline.io.func7 << std::endl;

    return (t != 6);
  });


}



