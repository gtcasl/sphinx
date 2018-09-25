SIM_SRC  = file.S
SIM_OBJS = $(SIM_SRC:.S=.o)

%.run: %.S
	/opt/riscv/bin/riscv32-unknown-linux-gnu-gcc ../traces/$@ -o ../Workspace/$<

%.hex: %.run
	g++ -o $@ $^
	/usr/bin/bin/elf2hex 64 4096 ../Workspace/$@ >> ../Workspace/$<