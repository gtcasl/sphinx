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
	
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-add.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-addi.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-and.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-andi.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-auipc.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-beq.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-bge.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-bgeu.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-blt.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-bltu.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-bne.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-jal.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-jalr.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lb.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lbu.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lh.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lhu.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lui.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lui.hex.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-lw.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-or.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-ori.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sb.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sh.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-simple.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sll.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-slli.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-slt.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-slti.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sltiu.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sltu.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sra.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-srai.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-srl.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-srli.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sub.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-sw.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-xor.hex");
	passed = passed && rocketchip.simulate("../tests/rv32ui-p-xori.hex");


	rocketchip.export_model();

	if (passed) return 0;
	return -1;



	// rocketchip.simulate("../tests/debugPluginExternal.hex");
	// rocketchip.simulate("../tests/debugPlugin.hex");
	// rocketchip.simulate("../tests/dhrystoneO3C.hex");
	// rocketchip.simulate("../tests/dhrystoneO3.hex");
	// rocketchip.simulate("../tests/dhrystoneO3MC.hex");
	// rocketchip.simulate("../tests/dhrystoneO3M.hex");
	// rocketchip.simulate("../tests/freeRTOS_demo.hex");
	// rocketchip.simulate("../tests/machineCsrCompressed.hex");
	// rocketchip.simulate("../tests/machineCsr.hex");
	// rocketchip.simulate("../tests/mmu.hex");
	// rocketchip.simulate("../tests/rv32uc-p-rvc.hex");
	// rocketchip.simulate("../tests/rv32ui-p-fence_i.hex");


	// rocketchip.simulate("../tests/rv32um-p-div.hex");
	// rocketchip.simulate("../tests/rv32um-p-divu.hex");
	// rocketchip.simulate("../tests/rv32um-p-mul.hex");
	// rocketchip.simulate("../tests/rv32um-p-mulh.hex");
	// rocketchip.simulate("../tests/rv32um-p-mulhsu.hex");
	// rocketchip.simulate("../tests/rv32um-p-mulhu.hex");
	// rocketchip.simulate("../tests/rv32um-p-rem.hex");
	// rocketchip.simulate("../tests/rv32um-p-remu.hex");
	// rocketchip.simulate("../tests/testA.hex");

}



