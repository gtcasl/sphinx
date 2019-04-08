#include <cstdlib>
#include <iostream>
#include <stdlib.h>
#include <complex>
#include <vector>
#include <chrono>
#include "VPipeline.h"
#include "../Vpipeline_tb.h"
#undef VM_TRACE
#if VM_TRACE
# include <verilated_vcd_c.h>	// Trace file format header
#endif

using Device = VPipeline;

template <typename T>
class simulator {
public:
  simulator() {
    top_ = new T();
    top_->clk = 0;
  #if VM_TRACE
    Verilated::traceEverOn(true);
    tfp_ = new VerilatedVcdC;
    top_->trace (tfp_, 99);
    tfp_->open ("vlt_dump.vcd");
  #endif
  }

  ~simulator() {
#if VM_TRACE
    if (tfp_) tfp_->close();
#endif
    top_->final();
    delete top_;
  }

  unsigned long reset(unsigned long ticks) {
    top_->reset = 1;
    ticks = tick(ticks);
    ticks = tick(ticks);
    top_->reset = 0;
    return ticks;
  }

  unsigned long step(unsigned long ticks) {
    ticks = tick(ticks);
    ticks = tick(ticks);
    return ticks;
  }

  auto operator->() {
    return top_;
  }

  auto device() {
    return top_;
  }

private:

  unsigned long tick(unsigned long ticks) {
    top_->eval();
  #if VM_TRACE
    tfp_->dump(ticks);
  #endif
    top_->clk = ~top_->clk;
    return ticks + 1;
  }

  T* top_;
#if VM_TRACE
  VerilatedVcdC* tfp_;
#endif
};

int main(int argc, char **argv) {
  // Initialize Verilators variables
  Verilated::commandArgs(argc, argv);

  simulator<Device> sim;

  double kernel_time = 0;
  auto start_time = std::chrono::system_clock::now();

  // run simulation
  unsigned long ticks = sim.reset(0);
  for (;eval(sim.device(), ticks);) {

    auto t1 = std::chrono::system_clock::now();

    // advance clock
    ticks = sim.step(ticks);

    auto t2 = std::chrono::system_clock::now();
    kernel_time += std::chrono::duration<double, std::milli>(t2 - t1).count();
  }

  auto end_time = std::chrono::system_clock::now();
  auto elasped_time = std::chrono::duration<double, std::milli>(end_time - start_time).count();
  std::cout << "Kernel latency = " << kernel_time << " ms" << std::endl;
  std::cout << "Total elapsed time = " << elasped_time << " ms" << std::endl;
  std::cout << "Run time overhead: " << std::dec << (elasped_time - kernel_time) << " ms" << std::endl;
  std::cout << "Simulation run time: " << std::dec << ticks/2 << " cycles" << std::endl;

  return 0;
}
