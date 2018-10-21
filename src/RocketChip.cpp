////
#include "RocketChip.h"

int main(int argc, char ** argv)
{

  if (argc > 1)
  {
    RocketChip rocketchip(argv[1]);
    rocketchip.simulate();
    rocketchip.export_model();
  } else
  {
  	std::cout << "Please input a file name" << std::endl;
  }
}



