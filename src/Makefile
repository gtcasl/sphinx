
#CXX = clang-5.0

#CXXFLAGS += -std=c++17 -O3 -DNDEBUG -I$(CASH_HOME)/include -Wall -Wextra -pedantic
# CXXFLAGS += -std=c++17 -O0 -g -I$(CASH_HOME)/include -Wall -Wextra -pedantic
# CASH_HOME = /Users/fareselsabbagh/Documents/cash
CXXFLAGS += -std=c++17 -O3 -I$(CASH_HOME)/include -w
LDFLAGS += -lcash -lstdc++ -L$(CASH_HOME)/build/lib

SRCS = Sphinx.cpp

PROJECTS = $(SRCS:.cpp=.out)
PROJECTS_NAMES = $(SRCS:.cpp=)

all: $(PROJECTS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.out: %.o
	$(CXX) $^ $(LDFLAGS) -o $@

.depend: $(SRCS)
	$(CXX) $(CXXFLAGS) -MM $^ > .depend;

clean:
	rm -f *.out *.o *.vcd *.iv *.fir .depend *~ *\#

clear:
	rm -f *.out *.o *.vcd *.iv *.fir .depend *~ *\#

run: $(PROJECTS)
	$(foreach proj, $(PROJECTS), ./$(proj) || exit;)
	$(foreach proj, $(PROJECTS_NAMES), iverilog $(proj)_tb.v -o $(proj)_tb.iv || exit;)
	$(foreach proj, $(PROJECTS_NAMES), vvp $(proj)_tb.iv || exit;)

ifneq ($(MAKECMDGOALS),clean)
	-include .depend
endif