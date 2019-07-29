#pragma once

// C++ libraries
#include <math.h>
#include <unistd.h>
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <map>
#include <utility>
#include <vector>

// sim
#ifdef SIM
#include <ncurses.h>  
#include <signal.h>   
#include <ctime>
#endif

// Cash libraries
#include <cash.h>
#include <htl/decoupled.h>
#include <htl/queue.h>
#include <ioport.h>

// Pipeline Hardware definitions
#include "pipeline.h"

// RAM
#include "ram.h"

using namespace ch::htl;

class Sphinx {
 public:
  Sphinx(bool use_trace = false);
  ~Sphinx();

  bool simulate(const std::string&);
  void simulate_numCycles(unsigned, bool, int, int);
  bool simulate_debug(const std::string&, const std::vector<unsigned>&);
  void export_verilog();
  void export_trace();

 private:

  void ProcessFile();
  void print_stats(bool = false);
  void reset_debug();

  bool ibus_driver(bool, const std::vector<unsigned>&);
  bool dbus_driver();
  void interrupt_driver();
  void jtag_driver();

  std::map<unsigned, unsigned> inst_map;
  RAM ram;

  unsigned start_pc;

  ch_device<Pipeline> pipeline;

  ch_simulator* sim;
  long int curr_cycle;
  bool stop;
  bool unit_test;
  std::string instruction_file_name;
  std::ofstream results;
  int stats_static_inst;
  int stats_dynamic_inst;
  int stats_total_cycles;
  int stats_fwd_stalls;
  int stats_branch_stalls;
  int debug_state;
  int ibus_state;
  int dbus_state;
  int debug_return;
  int debug_wait_num;
  int debug_inst_num;
  int debug_end_wait;
  int debug_debugAddr;
  double stats_sim_time;
  double stats_kernel_time;
};
