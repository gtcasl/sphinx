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
	
	rocketchip.simulate("../tests/rv32ui-p-add.hex");
	rocketchip.simulate("../tests/rv32ui-p-addi.hex");
	rocketchip.simulate("../tests/rv32ui-p-and.hex");
	rocketchip.simulate("../tests/rv32ui-p-andi.hex");
	rocketchip.simulate("../tests/rv32ui-p-auipc.hex");
	rocketchip.simulate("../tests/rv32ui-p-beq.hex");
	rocketchip.simulate("../tests/rv32ui-p-bge.hex");
	rocketchip.simulate("../tests/rv32ui-p-bgeu.hex");
	rocketchip.simulate("../tests/rv32ui-p-blt.hex");
	rocketchip.simulate("../tests/rv32ui-p-bltu.hex");
	rocketchip.simulate("../tests/rv32ui-p-bne.hex");
	rocketchip.simulate("../tests/rv32ui-p-fence_i.hex");
	rocketchip.simulate("../tests/rv32ui-p-jal.hex");
	rocketchip.simulate("../tests/rv32ui-p-jalr.hex");
	rocketchip.simulate("../tests/rv32ui-p-lb.hex");
	rocketchip.simulate("../tests/rv32ui-p-lbu.hex");
	rocketchip.simulate("../tests/rv32ui-p-lh.hex");
	rocketchip.simulate("../tests/rv32ui-p-lhu.hex");
	rocketchip.simulate("../tests/rv32ui-p-lui.hex");
	rocketchip.simulate("../tests/rv32ui-p-lui.hex.hex");
	rocketchip.simulate("../tests/rv32ui-p-lw.hex");
	rocketchip.simulate("../tests/rv32ui-p-or.hex");
	rocketchip.simulate("../tests/rv32ui-p-ori.hex");
	rocketchip.simulate("../tests/rv32ui-p-sb.hex");
	rocketchip.simulate("../tests/rv32ui-p-sh.hex");
	rocketchip.simulate("../tests/rv32ui-p-simple.hex");
	rocketchip.simulate("../tests/rv32ui-p-sll.hex");
	rocketchip.simulate("../tests/rv32ui-p-slli.hex");
	rocketchip.simulate("../tests/rv32ui-p-slt.hex");
	rocketchip.simulate("../tests/rv32ui-p-slti.hex");
	rocketchip.simulate("../tests/rv32ui-p-sltiu.hex");
	rocketchip.simulate("../tests/rv32ui-p-sltu.hex");
	rocketchip.simulate("../tests/rv32ui-p-sra.hex");
	rocketchip.simulate("../tests/rv32ui-p-srai.hex");
	rocketchip.simulate("../tests/rv32ui-p-srl.hex");
	rocketchip.simulate("../tests/rv32ui-p-srli.hex");
	rocketchip.simulate("../tests/rv32ui-p-sub.hex");
	rocketchip.simulate("../tests/rv32ui-p-sw.hex");
	rocketchip.simulate("../tests/rv32ui-p-xor.hex");
	rocketchip.simulate("../tests/rv32ui-p-xori.hex");

	// rocketchip.simulate("../tests/rv32um-p-div.hex");
	// rocketchip.simulate("../tests/rv32um-p-divu.hex");
	// rocketchip.simulate("../tests/rv32um-p-mul.hex");
	// rocketchip.simulate("../tests/rv32um-p-mulh.hex");
	// rocketchip.simulate("../tests/rv32um-p-mulhsu.hex");
	// rocketchip.simulate("../tests/rv32um-p-mulhu.hex");
	// rocketchip.simulate("../tests/rv32um-p-rem.hex");
	// rocketchip.simulate("../tests/rv32um-p-remu.hex");
	// rocketchip.simulate("../tests/testA.hex");

	rocketchip.export_model();



}



