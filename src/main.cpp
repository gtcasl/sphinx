// #define SIM
#include "Sphinx.h"
#include "parse.h"

// #define NUM_TESTS 39
#define NUM_TESTS 7

int main(int argc, char** argv) {
  execution_state es = parseArguments(argc, argv);

  Sphinx sphinx(es.exportTrace);

  bool passed = true;
  // std::string tests[NUM_TESTS] = {
  // 	"../tests/rv32ui-p-add.hex",
  // 	"../tests/rv32ui-p-addi.hex",
  // 	"../tests/rv32ui-p-and.hex",
  // 	"../tests/rv32ui-p-andi.hex",
  // 	"../tests/rv32ui-p-auipc.hex",
  // 	"../tests/rv32ui-p-beq.hex",
  // 	"../tests/rv32ui-p-bge.hex",
  // 	"../tests/rv32ui-p-bgeu.hex",
  // 	"../tests/rv32ui-p-blt.hex",
  // 	"../tests/rv32ui-p-bltu.hex",
  // 	"../tests/rv32ui-p-bne.hex",
  // 	"../tests/rv32ui-p-jal.hex",
  // 	"../tests/rv32ui-p-jalr.hex",
  // 	"../tests/rv32ui-p-lb.hex",
  // 	"../tests/rv32ui-p-lbu.hex",
  // 	"../tests/rv32ui-p-lh.hex",
  // 	"../tests/rv32ui-p-lhu.hex",
  // 	"../tests/rv32ui-p-lui.hex",
  // 	"../tests/rv32ui-p-lui.hex.hex",
  // 	"../tests/rv32ui-p-lw.hex",
  // 	"../tests/rv32ui-p-or.hex",
  // 	"../tests/rv32ui-p-ori.hex",
  // 	"../tests/rv32ui-p-sb.hex",
  // 	"../tests/rv32ui-p-sh.hex",
  // 	"../tests/rv32ui-p-simple.hex",
  // 	"../tests/rv32ui-p-sll.hex",
  // 	"../tests/rv32ui-p-slli.hex",
  // 	"../tests/rv32ui-p-slt.hex",
  // 	"../tests/rv32ui-p-slti.hex",
  // 	"../tests/rv32ui-p-sltiu.hex",
  // 	"../tests/rv32ui-p-sltu.hex",
  // 	"../tests/rv32ui-p-sra.hex",
  // 	"../tests/rv32ui-p-srai.hex",
  // 	"../tests/rv32ui-p-srl.hex",
  // 	"../tests/rv32ui-p-srli.hex",
  // 	"../tests/rv32ui-p-sub.hex",
  // 	"../tests/rv32ui-p-sw.hex",
  // 	"../tests/rv32ui-p-xor.hex",
  // 	"../tests/rv32ui-p-xori.hex",
  // 	// "../tests/I-CSRRC-01.elf.hex",
  // 	// "../tests/I-CSRRCI-01.elf.hex",
  // 	// "../tests/I-CSRRS-01.elf.hex",
  // 	// "../tests/I-CSRRSI-01.elf.hex",
  // 	// "../tests/I-CSRRW-01.elf.hex",
  // 	// "../tests/I-CSRRWI-01.elf.hex",
  //  //       "../tests/I-DELAY_SLOTS-01.elf.hex",
  //  //       "../tests/I-EBREAK-01.elf.hex",
  //  //       "../tests/I-ECALL-01.elf.hex",
  //  //       "../tests/I-ENDIANESS-01.elf.hex"
  // 	// "tests/dhrystoneO3.hex","
  // };

  std::string bench[NUM_TESTS] = {"../riscv-benchmarks/dhrystone.riscv.hex",
                                  "../riscv-benchmarks/vvadd.riscv.hex",
                                  "../riscv-benchmarks/towers.riscv.hex",
                                  "../riscv-benchmarks/spmv.riscv.hex",
                                  "../riscv-benchmarks/median.riscv.hex",
                                  "../riscv-benchmarks/qsort.riscv.hex",
                                  "../riscv-benchmarks/multiply.riscv.hex"};

  if (es.state == 0) {
    for (int ii = 0; ii < NUM_TESTS; ii++)
    // for (int ii = 0; ii < NUM_TESTS - 1; ii++)
    {
      bool curr = sphinx.simulate(bench[ii]);

      std::cout << GREEN << "Benchmarked: " << bench[ii] << std::endl;

      std::cout << DEFAULT;
    }

    // for (int ii = 0; ii < NUM_TESTS; ii++)
    // // for (int ii = 0; ii < NUM_TESTS - 1; ii++)
    // {
    // 	bool curr = sphinx.simulate(tests[ii]);

    // 	if ( curr) std::cout << GREEN << "Test Passed: " << tests[ii] <<
    // std::endl; 	if (!curr) std::cout << RED   << "Test Failed: " <<
    // tests[ii] << std::endl; 	passed = passed && curr;

    // 	std::cout << DEFAULT;
    // }

    // if( passed) std::cout << DEFAULT << "PASSED ALL TESTS\n";
    // if(!passed) std::cout << DEFAULT << "Failed one or more tests\n";
  } else if (es.state == 1) {
    std::cout << DEFAULT << "Going to run " << es.numCycles << " cycles\n";
    sphinx.simulate_numCycles(es.numCycles, es.print, es.printEvery,
                              es.numRuns);

  } else if (es.state == 2) {
    std::cout << DEFAULT << "Running: " << es.file_to_simulate << "\t";
    passed = sphinx.simulate(es.file_to_simulate);
    if (es.file_to_simulate != "tests/dhrystoneO3.hex") {
      if (passed) std::cout << GREEN << "Passed\n";
      if (!passed) std::cout << RED << "Failed\n";
    } else {
      std::cout << RED << "Not a Test\n";
    }
  } else if (es.state == 3) {
    std::cout << DEFAULT << "Running: " << es.file_to_simulate
              << " with debugging enabled\n";
    passed = sphinx.simulate_debug(es.file_to_simulate, es.debugAddress);
    if (es.file_to_simulate != "tests/dhrystoneO3.hex") {
      if (passed) std::cout << GREEN << "Passed\n";
      if (!passed) std::cout << RED << "Failed\n";
    } else {
      std::cout << RED << "Not a Test\n";
    }
  }

  if (es.exportVerilog) {
    std::cout << DEFAULT << "\nExporting model to Verilog... ";
    sphinx.export_verilog();
  }

  if (es.exportTrace) {
    std::cout << DEFAULT << "\nExporting simulation trace... ";
    sphinx.export_trace();
  }

  std::cout << DEFAULT;
  if (passed) return 0;
  return -1;
}
