#include <cash.h>
#include <ioport.h>

using namespace ch::core;
using namespace ch::sim;


template <unsigned N>
struct Instruction_Queue {
  static constexpr unsigned addr_width = 5;
  __io(
    __in(ch_bit<32>) din,
    __in(ch_bool)  push,
    __in(ch_bool)  pop,
    __out(ch_bit<32>) dout,
    __out(ch_bool) empty,
    __out(ch_bool) full
  );
  void describe() {
    ch_reg<ch_uint<addr_width+1>> rd_ptr(0), wr_ptr(1);

    auto rd_a = ch_slice<addr_width>(rd_ptr);
    auto wr_a = ch_slice<addr_width>(wr_ptr);

    auto reading = io.pop && !io.empty;
    auto writing = io.push && !io.full;

    rd_ptr->next = ch_sel(reading, rd_ptr + 1, rd_ptr);
    wr_ptr->next = ch_sel(writing, wr_ptr + 1, wr_ptr);

    ch_mem<ch_bit<32>, N> mem;
    mem.write(wr_a, io.din, writing);

    io.dout  = mem.read(rd_a);
    io.empty = (wr_ptr == rd_ptr);
    io.full  = (wr_a == rd_a) && (wr_ptr[addr_width] != rd_ptr[addr_width]);
  }
};

const std::string& init_file = "../Workspace/file.hex";

struct Fetch
{
	__io(
		__in(ch_bit<32>) in_din,
		__in(ch_bool) in_push,
		__out(ch_bit<32>) out_instruction,
		__out(ch_bit2)  out_PC_next
	);

	void describe()
	{

		instruction_queue.io.din(io.in_din);
		instruction_queue.io.push(io.in_push);
		instruction_queue.io.pop = ch_bool(true);
	



		//ch_rom(const std::string& init_file, CH_SLOC)
		ch_rom<ch_bit<32>, 4096> inst_mem(init_file);
		ch_reg<ch_bit2> PC(0);

		
		// io.out_instruction = inst_mem.read(PC.as_uint());

		// instruction_queue.dout(out_instruction.dout);
		io.out_instruction(instruction_queue.io.dout);


		ch_print("out_instruction: {0}", io.out_instruction);


		io.out_PC_next = ch_sel(PC.as_uint() == 3, PC, PC.as_uint() + 1);
		
		PC->next       = io.out_PC_next;
	}

	ch_module<Instruction_Queue<32>> instruction_queue;
};

