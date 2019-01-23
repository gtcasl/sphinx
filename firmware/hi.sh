gcc -c -Wl,-Bstatic,-T,--strip-debug -nostdlib firmware.c -o firmware.o
 # /opt/riscv-nommu/bin/riscv32-unknown-linux-gnu-objdump -d firmware.o > firmware.dump
 # /opt/riscv-nommu/bin/riscv32-unknown-linux-gnu-objcopy -I ihex firmware.o firmware.hex
objdump -d --adjust-vma=0x80000000 firmware.o > firmware.dump
 # /opt/riscv-nommu/bin/riscv32-unknown-linux-gnu-objcopy --change-addresses 0x80000000 --only-section .text -O ihex firmware.o firmware.hex