
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

ifneq ($(MAKECMDGOALS),clean)
	-include .depend
endif
