
#CXXFLAGS += -std=c++17 -O3 -DNDEBUG -I$(CASH_HOME)/include -Wall -Wextra -pedantic
CXXFLAGS += -std=c++17 -O0 -g -I$(CASH_HOME)/include -Wall -Wextra -pedantic
LDFLAGS += -lcash -lstdc++ -L$(CASH_HOME)/build/lib

PROJECT = Sphinx.out

SRCS = Sphinx.cpp main.cpp

OBJS := $(SRCS:.cpp=.o)

all: $(PROJECT)

$(PROJECT): $(OBJS)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

.depend: $(SRCS)
	$(CXX) $(CXXFLAGS) -MM $^ > .depend;

clean:
	rm -f *.out *.o *.vcd *.iv *.fir .depend *~ *\#

clear:
	rm -f *.out *.o *.vcd *.iv *.fir .depend *~ *\#

run: $(PROJECT)
	./$(PROJECT) --test ../riscv-benchmarks/dhrystone.riscv.hex
	
build-vcs: $(PROJECT)
	vcs -cpp /usr/bin/gcc -o vsim pipeline_tb.v
	
run-vcs: build-vcs
	./vsim
	
build-iverilog: $(PROJECT)
	iverilog pipeline_tb.v -o pipeline_tb.iv
	
run-iverilog: build-iverilog
	vvp -v pipeline_tb.iv
	
verilator: $(PROJECT)
	verilator -Wno-fatal --cc pipeline.v --top-module Pipeline --exe Vpipeline_tb.cpp --Mdir vl_pipeline
	make -j -C vl_pipeline -f VPipeline.mk VPipeline

ifneq ($(MAKECMDGOALS),clean)
	-include .depend
endif
