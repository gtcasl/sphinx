## Description

Sphinx is a RISC-V core implemented in CASH. The following are some of the specs:

- RV32I instruction set
- Pipelined with 5 stages (Fetch, Decode, Execute, Memory, WriteBack)
- Options to enable/disable forwarding, Branches resolving in 2/3 cycles, and jumps resolving in 1/2 cycles.
- Atomic CSR instructions.


## Project Layout

![Alt text](Diagrams/layout.jpg?raw=true "") 



## Maximum Frequency

```
Sphinx with all optimization on:
Device       Slow Model     Fast Model

Arria 10     323.73 MHz     496.52 MHz
Cyclone IV   153.12 MHz     264.90 MHz
Cyclone V    140.19 MHz     263.92 MHz
```

## Dependancies 

Sphinx only depends on [CASH](https://github.com/gtcasl/cash) being installed.


## CPU Generation and simulation

```sh
#To compile the model
>> git clone https://github.com/gtcasl/cash_riscv.git
>> cd cash_riscv/src
>> make
```

To simulate the model with the test cases (optional --exportVerilog to export model to verilog):
```sh
>> ./Sphinx
```

To simulate the model with a specific hex file (optional --exportVerilog to export model to verilog):
```sh
#./Sphinx --test <relative location>
>> ./Sphinx  --test ../tests/rv32ui-p-bltu.hex
```

To add breakpoints to the simulation, use the --breakpoint flag (optional --exportVerilog to export model to verilog). When a breakpoint is reached, the values of the registers will be printed after the breakpoint instruction is executed and the user will have the option to continue or exit simulation. 
```sh
#./Sphinx --test <relative location> --breakpoint <breakpoint PC value 1> <breakpoint PC value 2> ... <<breakpoint PC value N>
>> ./Sphinx --test ../tests/rv32ui-p-sra.hex --breakpoint 80000130 80000188 
```


To simulate the model a specific number of cycles (optional --exportVerilog to export model to verilog):
```sh
#./Sphinx --numCycles <num>
>>./Sphinx --numCycles 1000000
```


For options in config.h:
- #define FORWARDING   enables forwarding otherwise stalls
- #define BRNACH_WB    branches resolve in WB instead of MEM
- #define JAL_MEM      jumps are resolved in mem instead of EXE

All simulations export the verilog model.
