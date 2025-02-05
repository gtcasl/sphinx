#pragma once

#include <algorithm>
#include <string>
#include <vector>

struct Execution_State {
  int state;
  unsigned numCycles;
  std::string file_to_simulate;
  std::vector<unsigned> debugAddress;
  bool exportVerilog;
  bool exportTrace;
  bool print;
  int printEvery;
  int numRuns;
};

typedef struct Execution_State execution_state;

execution_state parseArguments(int argc, char** argv) {
  execution_state es;
  es.state = 0;
  es.numCycles = -1;
  es.file_to_simulate = "";
  es.exportVerilog = false;
  es.exportTrace = false;
  es.debugAddress = std::vector<unsigned>();
  es.numRuns = 1;
  std::string::size_type sz;
  int ii = 1;
  while (ii < argc) {
    std::string curr_command = argv[ii];
    if (es.state == 0) {
      if (curr_command == "--numCycles") {
        ++ii;
        es.state = 1;
        es.numCycles = std::stoi(argv[ii], &sz);
      }
    }

    if (es.state != 1) {
      if (curr_command == "--test") {
        es.state = 2;
        ++ii;
        es.file_to_simulate = argv[ii];
      }

      if (es.state == 2) {
        if (curr_command == "--breakpoint") {
          es.state = 3;
          ++ii;
          while ((ii < argc) && (curr_command != "--exportVerilog")) {
            unsigned curr = (unsigned)hToI(argv[ii], 8);
            es.debugAddress.push_back(curr);
            ++ii;
          }
        }
      }
    }

    if (curr_command == "--numRuns") {
      ++ii;
      es.numRuns = std::stoi(argv[ii], &sz);
    }

    if (curr_command == "--printEvery") {
      es.print = true;
      ++ii;
      es.printEvery = std::stoi(argv[ii], &sz);
    }

    if (curr_command == "--exportVerilog")
      es.exportVerilog = true;

    if (curr_command == "--exportTrace")
      es.exportTrace = true;

    ++ii;
  }

  return es;
}
