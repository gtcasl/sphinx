

/opt/riscv/bin/riscv32-unknown-linux-gnu-gcc -march=rv32ifd -S ../traces/add.c -o ../traces/add.S
/opt/riscv/bin/riscv32-unknown-linux-gnu-gcc -march=rv32ifd ../traces/add.S -o ../Workspace/add.run
/opt/riscv/bin/riscv32-unknown-linux-gnu-objdump -d ../Workspace/add.run > ../Workspace/add.dump
python ../scripts/filter.py
/usr/bin/bin/elf2hex 64 4096 ../Workspace/add.run > ../Workspace/add.bin