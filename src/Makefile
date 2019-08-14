#CXXFLAGS += -std=c++17 -O3 -DNDEBUG -I$(CASH_HOME)/include -Wall -Wextra -pedantic
CXXFLAGS += -std=c++17 -O0 -g -I$(CASH_HOME)/include -Wall -Wextra -pedantic
LDFLAGS += -lcash -L$(CASH_HOME)/build/lib

PROJECT = Sphinx.out

SRCS = Sphinx.cpp main.cpp

OBJS := $(SRCS:.cpp=.o)

all: $(PROJECT)

$(PROJECT): $(OBJS)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

.depend: $(SRCS)
	$(CXX) $(CXXFLAGS) -MM $^ > .depend;

clean:
	rm -rf *.out *.o *.vcd *.iv *.fir .depend *~ *\# vl_pipeline sc_pipeline sc2_pipeline

run: $(PROJECT)
	./$(PROJECT) --test ../riscv-benchmarks/dhrystone.riscv.hex

perf: $(PROJECT)
	./$(PROJECT) --test ../tests/dhrystoneO3.hex || true
	cat ../results/results.txt

verilog: $(PROJECT)
	./$(PROJECT) --test ../riscv-benchmarks/dhrystone.riscv.hex --exportVerilog --exportTrace
	
build-vcs: 
	vcs -cpp /usr/bin/gcc -o vsim pipeline_tb.v
	
run-vcs: 
	./vsim
	
build-iverilog: 
	iverilog pipeline_tb.v -o pipeline_tb.iv
	
run-iverilog: 
	vvp -v pipeline_tb.iv
	
build-verilator: 
	verilator --cc pipeline.v --top-module Pipeline -Wno-WIDTH -CFLAGS "-I$(CASH_HOME)/include" --exe vl_pipeline_tb.cpp --Mdir vl_pipeline
	make -j -C vl_pipeline -f VPipeline.mk VPipeline

run-verilator: 
	./vl_pipeline/VPipeline

build-systemc: 
	verilator --sc pipeline.v --top-module Pipeline -Wno-WIDTH -CFLAGS "-I$(CASH_HOME)/include" --exe sc_pipeline_tb.cpp --Mdir sc_pipeline
	make -j -C sc_pipeline -f VPipeline.mk VPipeline
	verilator --sc pipeline.v --threads 2 --top-module Pipeline -Wno-WIDTH -CFLAGS "-I$(CASH_HOME)/include" --exe sc_pipeline_tb.cpp --Mdir sc2_pipeline
	make -j -C sc2_pipeline -f VPipeline.mk VPipeline

run-systemc: 
	./sc_pipeline/VPipeline
	./sc2_pipeline/VPipeline

ifneq ($(MAKECMDGOALS),clean)
	-include .depend
endif
