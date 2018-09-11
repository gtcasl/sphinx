
#include "RocketChip.h"

// WSh

int main()
{

  RocketChip rocketchip("../inst.bin");
  rocketchip.simulate();
  rocketchip.export_model();

}



