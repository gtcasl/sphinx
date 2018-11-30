

#ifndef __PARSE__
#define __PARSE__

#include <string>
#include <vector>
#include <algorithm>

struct Execution_State
{

	int state;
	int numCycles;
	std::string file_to_simulate;
	std::vector<int> debugAddress;
	bool exportVerilog;
};


typedef struct Execution_State execution_state;

execution_state parseArguments(int argc, char ** argv)
{
	execution_state es;
	es.state            = 0;
	es.numCycles        = -1;
	es.file_to_simulate = "";
	es.exportVerilog      = false;
	std::string::size_type sz;
	int ii = 1;
	while (ii < argc)
	{

		std::string curr_command = argv[ii];
		if (es.state == 0)
		{
			if (curr_command == "--numCycles")
			{
				++ii; 
				es.state = 1;
				es.numCycles = std::stoi(argv[ii],&sz);
			}
		}

		if (es.state != 1)
		{
			if (curr_command == "--test")
			{
				es.state = 2;
				++ii;
				es.file_to_simulate = argv[ii];
			}

			if (es.state == 2)
			{
				if (curr_command == "--breakpoint")
				{
					es.state = 3;
					while ((ii < argc) && (curr_command != "--exportVerilog"))
					{
						++ii;
						es.debugAddress.append(hToI(argv[ii], 8));
					}
				}
			}
		}

		if (curr_command == "--exportVerilog") es.exportVerilog = true;

		++ii;
	}

	return es;
}

#endif