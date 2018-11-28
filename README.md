## Description

Sphinx is a RISC-V core implemented in CASH. The following are some of the specs:

- RV32I instruction set
- Pipelined with 5 stages (Fetch, Decode, Execute, Memory, WriteBack)
- Options to enable/disable forwarding, Branches stalling 2/3 cycles, and jumps taking 1/2 cycles.
- Atomic CSR instructions.


## Project Layout

![Alt text](assets/layout.jpg?raw=true "") 



## Maximum Frequency

'''
Sphinx with all optimization on:
Device       Slow Model     Fast Model

Arria 10     323.73 MHz     496.52 MHz
Cyclone IV   153.12 MHz     264.90 MHz
Cyclone V    140.19 MHz     263.92 MHz
'''

## Dependancies 

This model only depends on [CASH](https://github.com/gtcasl/cash) being installed.


## CPU Generation and simulation

'''sh
#To compile the model
git clone https://github.com/gtcasl/cash_riscv.git
cd cash_riscv/src
make
'''

To simulate the model with the test cases:
'''sh
./Sphinx
'''

To simulate the model with a user program, provide the .hex file:
'''sh
./Sphinx <relative location>
'''

For options in config.h:
- #define FORWARDING   enables forwarding otherwise stalls
- #define BRNACH_WB    branches resolve in WB instead of MEM
- #define JAL_MEM      jumps are resolved in mem instead of EXE

