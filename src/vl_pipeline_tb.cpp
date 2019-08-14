#include <cstdlib>
#include <iostream>
#include <stdlib.h>
#include <complex>
#include <vector>
#include <chrono>
#include "VPipeline.h"
#include "../vl_pipeline_tb.h"

int main(int argc, char **argv) {
  // Initialize Verilators variables
  Verilated::commandArgs(argc, argv);

  vl_testbench tb;

  double kernel_time = 0;
  auto start_time = std::chrono::system_clock::now();

  // run simulation
  unsigned long ticks = tb.reset(0);
  for (;tb.eval(ticks);) {

    auto t1 = std::chrono::system_clock::now();

    // advance clock
    ticks = tb.step(ticks);

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
