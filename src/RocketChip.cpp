////

#include "RocketChip.h"

int main()
{

  // if (argc > 1)
  // {
  //   RocketChip rocketchip(argv[1]);
  //   rocketchip.simulate();
  //   rocketchip.export_model();
  // } else
  // {
  // 	std::cout << "Please input a file name" << std::endl;
  // }

    RocketChip rocketchip;

    bool passed = true;
	std::string tests[NUM_TESTS] = {
		"../tests/rv32ui-p-add.hex",
		"../tests/rv32ui-p-addi.hex",
		"../tests/rv32ui-p-and.hex",
		"../tests/rv32ui-p-andi.hex",
		"../tests/rv32ui-p-auipc.hex",
		"../tests/rv32ui-p-beq.hex",
		"../tests/rv32ui-p-bge.hex",
		"../tests/rv32ui-p-bgeu.hex",
		"../tests/rv32ui-p-blt.hex",
		"../tests/rv32ui-p-bltu.hex",
		"../tests/rv32ui-p-bne.hex",
		"../tests/rv32ui-p-jal.hex",
		"../tests/rv32ui-p-jalr.hex",
		"../tests/rv32ui-p-lb.hex",
		"../tests/rv32ui-p-lbu.hex",
		"../tests/rv32ui-p-lh.hex",
		"../tests/rv32ui-p-lhu.hex",
		"../tests/rv32ui-p-lui.hex",
		"../tests/rv32ui-p-lui.hex.hex",
		"../tests/rv32ui-p-lw.hex",
		"../tests/rv32ui-p-or.hex",
		"../tests/rv32ui-p-ori.hex",
		"../tests/rv32ui-p-sb.hex",
		"../tests/rv32ui-p-sh.hex",
		"../tests/rv32ui-p-simple.hex",
		"../tests/rv32ui-p-sll.hex",
		"../tests/rv32ui-p-slli.hex",
		"../tests/rv32ui-p-slt.hex",
		"../tests/rv32ui-p-slti.hex",
		"../tests/rv32ui-p-sltiu.hex",
		"../tests/rv32ui-p-sltu.hex",
		"../tests/rv32ui-p-sra.hex",
		"../tests/rv32ui-p-srai.hex",
		"../tests/rv32ui-p-srl.hex",
		"../tests/rv32ui-p-srli.hex",
		"../tests/rv32ui-p-sub.hex",
		"../tests/rv32ui-p-sw.hex",
		"../tests/rv32ui-p-xor.hex",
		"../tests/rv32ui-p-xori.hex"
	};

	for (int ii = 0; ii < NUM_TESTS; ii++)
	{
		bool curr = rocketchip.simulate(tests[ii]);
		if (curr)  std::cout << GREEN << "Passed: " << tests[ii] << std::endl;
		if (!curr) std::cout << RED   << "Failed: " << tests[ii] << std::endl;
		std::cout << DEFAULT;
		passed = passed && curr;
	}



	rocketchip.export_model();

	if( passed) std::cout << DEFAULT << "PASSED ALL TESTS\n";
	if(!passed) std::cout << DEFAULT << "Failed one or more tests\n";

	if (passed) return 0;
	return -1;


}



