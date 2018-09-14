////
#include "RocketChip.h"

// WSh

int main()
{

  RocketChip rocketchip("smd");
  rocketchip.simulate();
  rocketchip.export_model();

}



