#include "Sphinx.h"

static volatile int keepRunning = 1;

bool debug = false;

void intHandler(int /*signo*/) {
  keepRunning = 0;
}

static void loadHexImpl(std::string path, RAM* mem) {
  mem->clear();
  FILE* fp = fopen(&path[0], "r");
  if (fp == 0) {
    std::cout << path << " not found" << std::endl;
  }
  // Preload 0x0 <-> 0x80000000 jumps
  ((uint32_t*)mem->get(0))[1] = 0xf1401073;

  // ((uint32_t*)mem->get(0))[1] = 0xf1401073;
  ((uint32_t*)mem->get(0))[2] = 0x30101073;

  ((uint32_t*)mem->get(0))[3] = 0x800000b7;
  ((uint32_t*)mem->get(0))[4] = 0x000080e7;

  ((uint32_t*)mem->get(0x80000000))[0] = 0x00000097;

  ((uint32_t*)mem->get(0xb0000000))[0] = 0x01C02023;
  // F00FFF10
  ((uint32_t*)mem->get(0xf00fff10))[0] = 0x12345678;

  fseek(fp, 0, SEEK_END);
  uint32_t size = ftell(fp);
  fseek(fp, 0, SEEK_SET);
  char* content = new char[size];
  fread(content, 1, size, fp);

  int offset = 0;
  char* line = content;
  // std::cout << "WHTA\n";
  while (1) {
    if (line[0] == ':') {
      uint32_t byteCount = hToI(line + 1, 2);
      uint32_t nextAddr = hToI(line + 3, 4) + offset;
      uint32_t key = hToI(line + 7, 2);
      switch (key) {
        case 0:
          for (uint32_t i = 0; i < byteCount; i++) {
            unsigned add = nextAddr + i;

            *(mem->get(add)) = hToI(line + 9 + i * 2, 2);
            // std::cout << "Address: " << std::hex <<(add) << "\tValue: " <<
            // std::hex << hToI(line + 9 + i * 2, 2) << std::endl;
          }
          break;
        case 2:
          //              cout << offset << endl;
          offset = hToI(line + 9, 4) << 4;
          break;
        case 4:
          //              cout << offset << endl;
          offset = hToI(line + 9, 4) << 16;
          break;
        default:
          //              cout << "??? " << key << endl;
          break;
      }
    }

    while (*line != '\n' && size != 0) {
      line++;
      size--;
    }
    if (size <= 1) break;
    line++;
    size--;
  }

  if (content)
    delete[] content;
}

Sphinx::Sphinx(bool use_trace)
    : start_pc(0),
      curr_cycle(0),
      stop(true),
      unit_test(true),
      stats_static_inst(0),
      stats_dynamic_inst(-1),
      stats_total_cycles(0),
      stats_fwd_stalls(0),
      stats_branch_stalls(0),
      debug_state(0),
      ibus_state(0),
      dbus_state(0),
      debug_return(0),
      debug_wait_num(0),
      debug_inst_num(0),
      debug_end_wait(0),
      debug_debugAddr(0) {
  if (use_trace) {
    this->sim = new ch_tracer(this->pipeline);
  } else {
    this->sim = new ch_simulator(this->pipeline);
  }
  this->results.open("../results/results.txt");

#ifdef SIM
  initscr();
  cbreak();
  noecho();
  scrollok(stdscr, 1);
  keypad(stdscr, 1);
  nodelay(stdscr, 1);
#endif
}

Sphinx::~Sphinx() {
  if (sim) {
    delete sim;
  }
#ifdef SIM
  endwin();
#endif
  this->results.close();
}

void Sphinx::ProcessFile(void) {
  loadHexImpl(this->instruction_file_name, &this->ram);

  // std::cout<< "$$$$$$$$$$$$$$$$$$$$$$$" << std::endl;
  // exit(0);
  // uint32_t address = 0x80000038;
  // // uint32_t * data = new uint32_t[64];
  // // ram.getBlock(address,data);

  // if(debug) std::cout << "GOT BLOCK" << std::endl;

  // for (uint32_t new_address = (address&0xffffff00); new_address <
  // ((address&0xffffff00) + 256); new_address += 4 )
  // {

  //     uint32_t curr_word;
  //     ram.getWord(new_address, &curr_word);

  //     if(debug) std::cout << std::setfill('0');
  //     if(debug) std::cout << std::hex << new_address << ": " << std::hex <<
  //     std::setw(8) << curr_word; if(debug) std::cout << std::endl;

  // }

  // if(debug) std::cout << "***********************" << std::endl;
}

bool Sphinx::ibus_driver(bool debug_mode, const std::vector<unsigned>& debugAddress) {
  static int store_state[31] = {
      0x00102023, 0x00202223, 0x00302423, 0x00402623, 0x00502823, 0x00602a23,
      0x00702c23, 0x00802e23, 0x02902023, 0x02a02223, 0x02b02423, 0x02c02623,
      0x02d02823, 0x02e02a23, 0x02f02c23, 0x03002e23, 0x05102023, 0x05202223,
      0x05302423, 0x05402623, 0x05502823, 0x05602a23, 0x05702c23, 0x05802e23,
      0x07902023, 0x07a02223, 0x07b02423, 0x07c02623, 0x07d02823, 0x07e02a23,
      0x07f02c23};

  ////////////////////// IBUS //////////////////////
  unsigned new_PC;
  bool stop = false;
  uint32_t curr_inst = 0;
  if (!debug_mode) {
    stop = false;
    curr_inst = 0xdeadbeef;

#ifndef ICACHE_ENABLE

    pipeline.io.IBUS.out_address.ready = pipeline.io.IBUS.out_address.valid;
    new_PC = (unsigned)pipeline.io.IBUS.out_address.data;
    ram.getWord(new_PC, &curr_inst);
    pipeline.io.IBUS.in_data.data = curr_inst;
    pipeline.io.IBUS.in_data.valid = true;
    pipeline.io.in_debug = false;
    // std::cout << "ADDR: " << std::hex << new_PC << "\tINST: " << curr_inst <<
    // "\n";

#else

    static unsigned address = 0;
    static unsigned min = 0;
    if (this->ibus_state == 0) {
      // std::cout << "IBUS STATE 0\n";
      pipeline.io.IBUS.in_data.valid = false;
      pipeline.io.in_debug = false;
      pipeline.io.IBUS.in_data.data = 0x0000000;
      pipeline.io.IBUS.out_address.ready = true;

      if (pipeline.io.IBUS.out_address.valid) {
        this->ibus_state = 1;
        unsigned curr_add = (unsigned)pipeline.io.IBUS.out_address.data;
        address = (curr_add | (ILINE_SIZE - 1)) - 3;  //

        min = (curr_add | (ILINE_SIZE - 1)) - (ILINE_SIZE - 1);
      }
    } else {
      // std::cout << "IBUS STATE 1\n";
      // std::cout << "ADDRESS: " << std::hex << address << " < min: " <<
      // std::hex << min << "? ";
      if ((address < min) || ((min == 0) && (address == 0xfffffffc))) {
        // std::cout << "Y \n";
        this->ibus_state = 0;
        pipeline.io.IBUS.in_data.valid = false;
        pipeline.io.in_debug = false;
        pipeline.io.IBUS.in_data.data = 0x0000000;
        pipeline.io.IBUS.out_address.ready = true;
        address = 0;
        // std::cout << "EXITING MOVE\n";
      } else {
        // std::cout << "N \n";
        pipeline.io.IBUS.in_data.valid = true;

        // std::cout << "getting address: " << std::hex << address << "\n";

        ram.getWord(address, &curr_inst);
        pipeline.io.IBUS.in_data.data = curr_inst;
        pipeline.io.IBUS.out_address.ready = true;

        // std::cout << "Sent number: " << std::hex << address << "\n";

        address -= 4;
      }
    }

#endif
  } else {
    stop = false;
    curr_inst = 0;

    pipeline.io.IBUS.out_address.ready = pipeline.io.IBUS.out_address.valid;
    new_PC = (unsigned)pipeline.io.IBUS.out_address.data;

    // std::cout << "curr_PC: " << std::hex << new_PC << "\n";
    if (this->debug_state == 0) {
      // if (( (int) new_PC) == debugAddress)
      if (std::find(debugAddress.begin(), debugAddress.end(), (int)new_PC) !=
          debugAddress.end()) {
        // std::cout << "REACHED: " << std::hex << new_PC << "\n";
        this->debug_state = 1;
        this->debug_debugAddr = new_PC;
        // std::cout <<  RED << "BREAKPOINT REACHED  -  " << DEFAULT "Cycle: "
        // << std::dec << this->stats_total_cycles << "\n"; std::cout <<
        // "Register state at instructtion address: 0x" << std::hex << new_PC <<
        // "\n";
      }
      ram.getWord(new_PC, &curr_inst);
      pipeline.io.in_debug = false;
    } else if (this->debug_state == 1) {
      this->debug_return = new_PC;
      this->debug_state = 2;
      pipeline.io.in_debug = true;
    } else if (this->debug_state == 2) {
      if (this->debug_wait_num > 5) this->debug_state = 3;
      ++this->debug_wait_num;
      pipeline.io.in_debug = true;
    } else if (this->debug_state == 3) {
      if (this->debug_inst_num < 31) {
        curr_inst = (uint32_t)store_state[this->debug_inst_num];
        this->debug_inst_num++;
        pipeline.io.in_debug = true;
      } else {
        this->debug_state = 4;
        pipeline.io.in_debug = true;
      }
    } else if (this->debug_state == 4) {
      if (this->debug_end_wait > 5) {
        this->debug_state = 5;
        pipeline.io.in_debug = true;
      } else {
        pipeline.io.in_debug = true;
      }
      ++this->debug_end_wait;
    }

    pipeline.io.IBUS.in_data.data = curr_inst;
    pipeline.io.IBUS.in_data.valid = true;
  }

  // std::cout << "new_PC: " << std::hex << new_PC << "\n";
  std::cout << std::dec;

  ////////////////////// IBUS //////////////////////

  ////////////////////// STATS //////////////////////
  if (pipeline.io.out_fwd_stall || pipeline.io.out_branch_stall) {
    --stats_dynamic_inst;
    if (pipeline.io.out_fwd_stall) ++this->stats_fwd_stalls;
    if (pipeline.io.out_branch_stall) ++this->stats_branch_stalls;
  }
  ++stats_total_cycles;

  if (debug) std::cout << "new_PC: " << new_PC << std::endl;
    // if(this->curr_cycle%1000 == 0) std::cout << "new_PC: " << std::hex <<
    // new_PC << "\n";

#ifdef ICACHE_ENABLE

  new_PC = (unsigned)pipeline.io.IBUS.out_address.data;
  ram.getWord(new_PC, &curr_inst);

#endif

  // std::cout << "new_PC: " << std::hex << new_PC << "\tcurr_inst: " <<
  // std::hex << curr_inst << "\n";

  // std::cout << "MAIN_PC: " << std::hex << new_PC << "\t" << "MAIN_isnt: " <<
  // curr_inst << "\n";
  if (((((unsigned int)curr_inst) != 0) &&
       (((unsigned int)curr_inst) != 0xffffffff)) ||
      (this->ibus_state == 1) || (this->dbus_state == 1)) {
    ++stats_dynamic_inst;
    if (debug)
      std::cout << "new_PC: " << new_PC << "  inst_going_in: " << std::hex
                << curr_inst << std::endl;
    stop = false;
  } else {
    stop = true;
  }

  if (debug) std::cout << "------------------------------------------";
  if (debug) std::cout << std::endl << std::endl << std::endl << std::endl;
  ////////////////////// STATS //////////////////////

  // JUST FOR DEBUGGING CLOCK
  if ((((unsigned int)new_PC) == 0x8000043c) && (!this->unit_test)) {
    // CHANGES CLOCK
    uint32_t data = 0x1ff45678;
    ram.writeWord(0xf00fff10, &data);
  }

  if ((((unsigned int)new_PC) == 0x80000118) && (!this->unit_test)) {
    this->stop = false;
  }

  return stop;
}

bool Sphinx::dbus_driver() {
  uint32_t data_read;
  uint32_t data_write;
  uint32_t addr;
  int ch;
  // std::cout << "DBUS DRIVER\n" << std::endl;
  ////////////////////// DBUS //////////////////////

#ifndef DCACHE_ENABLE

  pipeline.io.DBUS.out_data.ready = pipeline.io.DBUS.out_data.valid;
  pipeline.io.DBUS.out_address.ready = pipeline.io.DBUS.out_address.valid;
  pipeline.io.DBUS.out_control.ready = pipeline.io.DBUS.out_control.valid;

  if ((pipeline.io.DBUS.out_rw) && (pipeline.io.DBUS.out_address.valid)) {
    data_write = (uint32_t)pipeline.io.DBUS.out_data.data;
    addr = (uint32_t)pipeline.io.DBUS.out_address.data;

#ifdef SIM

    if ((((int)data_write) < 256) && ((int)data_write > -1) &&
        (addr == 0xFF000000)) {
      // std::cout << (char) (data_write & 0xFF);
      ch = data_write;
      if (ch != '\r') {
        waddch(stdscr, data_write);
      }
    }

#endif

    if (pipeline.io.DBUS.out_control.data == 0) {
      data_write = (data_write)&0xFF;

      // std::cout << "STORE BYTE\t" << std::hex << (uint32_t)
      // pipeline.io.DBUS.out_address.data << " = " << (char) data_write <<
      // "\n";

      ram.writeByte(addr, &data_write);
    } else if (pipeline.io.DBUS.out_control.data == 1) {
      data_write = (data_write)&0xFFFF;
      // std::cout << "ST0RE HALF\t" << std::hex << addr << " = " << (char)
      // data_write << "\n";
      ram.writeHalf(addr, &data_write);
    } else if (pipeline.io.DBUS.out_control.data == 2) {
      data_write = data_write;
      ram.writeWord(addr, &data_write);
    }
  }

  if ((pipeline.io.DBUS.out_rw == 0) &&
      (pipeline.io.DBUS.out_address.valid == 1)) {
    addr = (uint32_t)pipeline.io.DBUS.out_address.data;

#ifdef SIM

    if (addr == 0xFF000000) {
      ch = getch();
      if (ch == ERR) {
        // std::cout << "PRINTINTG -1\n";
        data_read = 0xFFFFFFFF;
      } else {
        // std::cout << "SEDNIGN : " << (char) ch << "\n";
        data_read = ch & 0XFF;
        waddch(stdscr, data_read);
      }
    } else {
      // std::cout << "NOTHING SPECIAL\n";
      ram.getWord(addr, &data_read);
    }

#else

    ram.getWord(addr, &data_read);

#endif

    // if(debug) std::cout << "ABOUT TO: " << addr << " read from data: " <<
    // data_read << "\n"; std::cout << "\n";
    if (pipeline.io.DBUS.out_control.data == 0) {
      // std::cout << "LOAD BYTE: " << std::hex << (data_read & 0xFF) << "
      // from address: " << addr << " \n";
      pipeline.io.DBUS.in_data.data =
          (data_read & 0x80) ? (data_read | 0xFFFFFF00) : (data_read & 0xFF);
    } else if (pipeline.io.DBUS.out_control.data == 1) {
      // std::cout << "LOAD HALF: " << std::hex << (data_read & 0xFFFF) << "
      // from address: " << addr << " \n";
      pipeline.io.DBUS.in_data.data = (data_read & 0x8000)
                                          ? (data_read | 0xFFFF0000)
                                          : (data_read & 0xFFFF);
    } else if (pipeline.io.DBUS.out_control.data == 2) {
      // std::cout << "LOAD WORD: " << std::hex << (data_read) << "   from
      // address: " << addr << " \n";
      pipeline.io.DBUS.in_data.data = data_read;
    } else if (pipeline.io.DBUS.out_control.data == 4) {
      // std::cout << "LOAD BYTE unsigned: " << std::hex << (data_read & 0xFF)
      // << "   from address: " << addr << " \n";
      pipeline.io.DBUS.in_data.data = (data_read & 0xFF);
    } else if (pipeline.io.DBUS.out_control.data == 5) {
      // std::cout << "LOAD HALF UNSIGNED: " << std::hex << (data_read & 0xFFFF)
      // << "   from address: " << addr << " \n";
      pipeline.io.DBUS.in_data.data = (data_read & 0xFFFF);
    } else {
      std::cout << "WTF\n";
      pipeline.io.DBUS.in_data.data = 0xbabebabe;
    }

    pipeline.io.DBUS.in_data.valid = true;
  } else {
    pipeline.io.DBUS.in_data.data = 0x123;
    pipeline.io.DBUS.in_data.valid = false;
  }

#ifdef SIM
  wrefresh(stdscr);
#endif

  return false;

#else

  static unsigned address, initial = 0;
  static unsigned max = 0;
  static bool first = true;
  if (this->dbus_state == 0) {
    // std::cout << "DBUS STATE 0\n";

    pipeline.io.DBUS.out_data.ready = pipeline.io.DBUS.out_data.valid;
    pipeline.io.DBUS.out_address.ready = pipeline.io.DBUS.out_address.valid;
    pipeline.io.DBUS.out_control.ready = pipeline.io.DBUS.out_control.valid;

    // std::cout << std::hex << (unsigned) pipeline.io.DBUS.out_address.data <<
    // "\n";

    if (pipeline.io.DBUS.out_rw) {
      // if (( (unsigned) pipeline.io.DBUS.out_address.data) == 0xFF000000)
      // {
      //     std::cout << "HI\n";
      //     uint32_t data_to_write = (uint32_t) pipeline.io.DBUS.out_data.data;
      //     std::cout << (char) data_to_write;
      // } else
      {
        // std::cout << "ABOUT TO: " << (uint32_t)
        // pipeline.io.DBUS.out_address.data << "write to data: " << (uint32_t)
        // pipeline.io.DBUS.out_data.data << "\n";
        uint32_t data_to_write = (uint32_t)pipeline.io.DBUS.out_data.data;
        if (pipeline.io.DBUS.out_control.data == 0) {
          ram.writeByte((uint32_t)pipeline.io.DBUS.out_address.data,
                        &data_to_write);
        } else if (pipeline.io.DBUS.out_control.data == 1) {
          ram.writeHalf((uint32_t)pipeline.io.DBUS.out_address.data,
                        &data_to_write);
        } else {
          ram.writeWord((uint32_t)pipeline.io.DBUS.out_address.data,
                        &data_to_write);
        }
        // std::cout << "CACHE ABOUT TO WRITE TO RAM - Address: " << std::hex <<
        // (uint32_t) pipeline.io.DBUS.out_address.data << "\t DATA: " <<
        // data_to_write << "\n";
      }
    }

    pipeline.io.DBUS.in_data.data = 0xFFFFFFFF;

    if (((bool)pipeline.io.DBUS.out_miss && !first) &&
        (((unsigned)pipeline.io.DBUS.out_address.data) != 0xFF000000)) {
      this->dbus_state = 1;
      unsigned curr_add = (unsigned)pipeline.io.DBUS.out_address.data;

      address = (curr_add | (DLINE_SIZE - 1)) - (DLINE_SIZE - 1);
      initial = address;
      max = (curr_add | (DLINE_SIZE - 1));

      // std::cout << "OUT MISS IS 1 with address: \n";
      // std::cout << "curr_address: " << std::hex << curr_add << "\n";
      // std::cout << "line addr to copy: " << std::hex << address << "\n";
      // std::cout << "MIN ADDR is: " << std::hex << min << "\n";
    }
    pipeline.io.DBUS.in_data.valid = false;
    if (first) first = false;
  } else {
    if (initial == address) {
      std::cout << "DBUS STATE 1\n";
      std::cout << "Sening block: " << std::hex << initial << "\n";
    }
    // std::cout << "ADDRESS: " << std::hex << address << " > max: " << std::hex
    // << max << "? ";
    if ((address > max) || (address == 0xfffffffc)) {
      // std::cout << std::hex << "finalized address: " << max << "\n";
      // std::cout << "Y \n";
      this->dbus_state = 0;
      pipeline.io.DBUS.in_data.valid = false;
      pipeline.io.in_debug = false;
      pipeline.io.DBUS.in_data.data = 0x0000000;
      pipeline.io.DBUS.out_address.ready = true;
      address = 0;
      // std::cout << "EXITING MOVE\n";
    } else {
      // std::cout << "N \n";
      pipeline.io.DBUS.in_data.valid = true;

      // std::cout << "getting address: " << std::hex << address << "\n";

      ram.getWord(address, &data_read);
      pipeline.io.DBUS.in_data.data = data_read;
      pipeline.io.DBUS.out_address.ready = true;
      // std::cout << "sending address : " << std::hex << address << "  data: "
      // << data_read << "\n";

      address += 4;
    }
  }

  return (this->dbus_state == 1);

#endif
  ////////////////////// DBUS //////////////////////
}

void Sphinx::interrupt_driver() {
  ////////////////////// INTERRUPT //////////////////////

  if (this->debug_state == 0) {
    pipeline.io.INTERRUPT.in_interrupt_id.valid = false;
  } else {
    pipeline.io.INTERRUPT.in_interrupt_id.valid = false;
  }
  pipeline.io.INTERRUPT.in_interrupt_id.data = 0;

  ////////////////////// INTERRUPT //////////////////////
}

void Sphinx::jtag_driver() {
  ////////////////////// JATG //////////////////////

  pipeline.io.jtag.JTAG_TAP.in_mode_select.valid = false;
  pipeline.io.jtag.JTAG_TAP.in_mode_select.data = 0;

  pipeline.io.jtag.JTAG_TAP.in_clock.valid = false;
  pipeline.io.jtag.JTAG_TAP.in_clock.data = 0;

  pipeline.io.jtag.JTAG_TAP.in_reset.valid = false;
  pipeline.io.jtag.JTAG_TAP.in_reset.data = 0;

  pipeline.io.jtag.in_data.valid = false;
  pipeline.io.jtag.in_data.data = 0;

  pipeline.io.jtag.out_data.ready = false;

  ////////////////////// JATG //////////////////////
}

bool Sphinx::simulate(const std::string& file_to_simulate) {
  this->unit_test = true;
  if (file_to_simulate == "../tests/dhrystoneO3.hex") {
    this->unit_test = false;
  }

  this->instruction_file_name = file_to_simulate;
  this->results << "\n****************\t" << file_to_simulate
                << "\t****************\n";

  this->ProcessFile();

  // auto start_time = std::chrono::high_resolution_clock::now();

  static bool stop = false;
  static int counter = 0;
  counter = 0;
  stop = false;

  auto start_time = std::chrono::high_resolution_clock::now();

  std::chrono::duration<double> overhead;

  sim->run([&](ch_tick t) -> bool {
    auto k_start_time = std::chrono::high_resolution_clock::now();

    long int cycle = t / 2;

    this->curr_cycle = cycle;

    if (debug) std::cout << "Cycle: " << cycle << std::endl;
    // if(cycle%1000 == 0) std::cout << "Cycle: " << std::dec << cycle << "\n";

    // std::cout << "aaCycle: " << std::dec << cycle << "\n";

    bool istop = ibus_driver(false, std::vector<unsigned>());
    bool dstop = !dbus_driver();
    stop = istop && dstop;
    interrupt_driver();
    jtag_driver();

    if (stop) {
      counter++;
    } else {
      counter = 0;
    }

    // RETURNS FALSE TO STOP
    // return (!(stop && (counter > 5)) || true);

    overhead += (std::chrono::high_resolution_clock::now() - k_start_time);

    return this->stop && (!(stop && (counter > 5)));
  }, 2);

  // {
  //     using namespace std::chrono;
  //     this->stats_sim_time =
  //     duration_cast<milliseconds>(high_resolution_clock::now() -
  //     start_time).count();
  // }

  std::chrono::duration<double> total_time =
      std::chrono::high_resolution_clock::now() - start_time;

  this->stats_sim_time = total_time.count() * 1000;
  this->stats_kernel_time = this->stats_sim_time - (overhead.count() * 1000);

  uint32_t status;
  ram.getWord(0, &status);

  this->print_stats();
#ifdef SIM
  signal(SIGINT, intHandler);
  while (keepRunning) {
  }
#endif
  return (status == 1);
}

void Sphinx::simulate_numCycles(unsigned numCycles, bool print, int mod,
                                int numRuns) {
  // auto start_time = std::chrono::high_resolution_clock::now();

  this->unit_test = false;
  this->stats_sim_time = 0;

  auto start_time = clock();

  for (int i = 0; i < numRuns; ++i) {
    sim->run([&](ch_tick t) -> bool {

      pipeline.io.IBUS.out_address.ready = pipeline.io.IBUS.out_address.valid;
      pipeline.io.IBUS.in_data.data = 0x0;
      pipeline.io.IBUS.in_data.valid = true;
      pipeline.io.in_debug = false;

      pipeline.io.DBUS.in_data.data = 0x123;
      pipeline.io.DBUS.in_data.valid = false;

      pipeline.io.INTERRUPT.in_interrupt_id.valid = false;

      pipeline.io.INTERRUPT.in_interrupt_id.data = 0;

      pipeline.io.jtag.JTAG_TAP.in_mode_select.valid = false;
      pipeline.io.jtag.JTAG_TAP.in_mode_select.data = 0;

      pipeline.io.jtag.JTAG_TAP.in_clock.valid = false;
      pipeline.io.jtag.JTAG_TAP.in_clock.data = 0;

      pipeline.io.jtag.JTAG_TAP.in_reset.valid = false;
      pipeline.io.jtag.JTAG_TAP.in_reset.data = 0;

      pipeline.io.jtag.in_data.valid = false;
      pipeline.io.jtag.in_data.data = 0;

      pipeline.io.jtag.out_data.ready = false;

      if (print)
        if (this->stats_total_cycles % mod == 0)
          std::cout << "Cycle: " << this->stats_total_cycles << "\n";

      // RETURNS FALSE TO STOP
      // return (!(stop && (counter > 5)) || true);
      return ((t / 2) != numCycles);
    }, 2);
  }

  auto end_time = clock();

  this->stats_total_cycles = numCycles;
  this->stats_sim_time =
      ((end_time - start_time) * 1000) / (CLOCKS_PER_SEC * numRuns);

  // {
  //     using namespace std::chrono;
  //     this->stats_sim_time =
  //     duration_cast<milliseconds>(high_resolution_clock::now() -
  //     start_time).count() / numRuns;
  // }

  // this->stats_sim_time = (this->stats_sim_time / numRuns);

  this->print_stats(false);
}

bool Sphinx::simulate_debug(const std::string& file_to_simulate,
                            const std::vector<unsigned>& debugAddress) {
  this->unit_test = true;
  if (file_to_simulate == "../tests/dhrystoneO3.hex") {
    this->unit_test = false;
  }

  this->instruction_file_name = file_to_simulate;
  this->results << "\n****************\t" << file_to_simulate
                << "\t****************\n";

  this->ProcessFile();

  // auto start_time = std::chrono::high_resolution_clock::now();

  static bool stop = false;
  static int counter = 0;
  counter = 0;
  stop = false;
  auto start_time = clock();

  sim->run([&](ch_tick t) -> bool {

    bool alt = true;
    long int cycle = t / 2;

    this->curr_cycle = cycle;

    if (debug) std::cout << "Cycle: " << cycle << std::endl;

    stop = ibus_driver(true, debugAddress);
    dbus_driver();
    interrupt_driver();
    jtag_driver();

    // if (cycle%1000 == 0) std::cout << "Cycle: " << std::dec << cycle << "\n";

    if (this->debug_state == 5) {
      this->reset_debug();
      for (unsigned i = 1; i < 32; ++i) {
        uint32_t value;
        ram.getWord((i - 1) * 4, &value);
        std::cout << "Reg " << std::dec << i << ": 0x" << std::hex << value
                  << "\n";
      }
      std::cout << "\n\n";
      std::cout << "Would you like to continue or the simulation? [y/n]: ";
      char ans;
      std::cin >> ans;
      if (ans == 'y') alt = true;
      if (ans == 'n') alt = false;
    }

    if (stop && (this->debug_state == 0)) {
      counter++;
    } else {
      counter = 0;
    }

    // RETURNS FALSE TO STOP
    // return (!(stop && (counter > 5)) || true);
    bool to_stop = this->stop && (!(stop && (counter > 5)));
    // if ((!to_stop && (this->debug_state == 0))) std::cout << "ABOUT TO
    // EXIT\n";
    return !((!to_stop && (this->debug_state == 0))) && alt;
  }, 2);

  // {
  //     using namespace std::chrono;
  //     this->stats_sim_time =
  //     duration_cast<milliseconds>(high_resolution_clock::now() -
  //     start_time).count();
  // }
  this->stats_sim_time = (((clock() - start_time) * (1000)) / CLOCKS_PER_SEC);

  uint32_t status;
  ram.getWord(0, &status);

  this->print_stats();
  return (status == 1);
}

void Sphinx::print_stats(bool cycle_test) {
  this->results << std::left;
  this->results << "# Static Instructions:\t" << std::dec
                << this->stats_static_inst << std::endl;
  this->results << std::setw(24) << "# Dynamic Instructions:" << std::dec
                << this->stats_dynamic_inst << std::endl;
  this->results << std::setw(24) << "# of total cycles:" << std::dec
                << this->stats_total_cycles << std::endl;
  this->results << std::setw(24) << "# of forwarding stalls:" << std::dec
                << this->stats_fwd_stalls << std::endl;
  this->results << std::setw(24) << "# of branch stalls:" << std::dec
                << this->stats_branch_stalls << std::endl;
  this->results << std::setw(24) << "# CPI:" << std::dec
                << (double)this->stats_total_cycles /
                       (double)this->stats_dynamic_inst
                << std::endl;
  this->results << std::setw(24) << "# Total time: " << std::dec
                << this->stats_sim_time << " milliseconds" << std::endl;
  this->results << std::setw(24) << "# Kernel Time: " << std::dec
                << this->stats_kernel_time << " milliseconds" << std::endl;

  uint32_t status;
  ram.getWord(0, &status);

  if (this->unit_test) {
    if (status == 1) {
      this->results << std::setw(24) << "# GRADE: PASSING\n";
    } else {
      this->results << std::setw(24) << "# GRADE: Failed on test: " << status << "\n";
    }
  } else {
    this->results << std::setw(24) << "# GRADE: N/A [NOT A UNIT TEST]\n";
  }

  this->stats_static_inst = 0;
  this->stats_dynamic_inst = -1;
  this->stats_total_cycles = 0;
  this->stats_fwd_stalls = 0;
  this->stats_branch_stalls = 0;
}

void Sphinx::export_verilog() {
  ch_toVerilog("pipeline.v", pipeline);
  ch_stats(std::cout, pipeline);
}

void Sphinx::export_trace() {
  auto trace = reinterpret_cast<ch_tracer*>(sim);
  trace->toVerilog("pipeline_tb.v", "pipeline.v", true);
  trace->toVerilator("vl_pipeline_tb.h", "VPipeline");
  trace->toSystemC("sc_pipeline_tb.h", "VPipeline");
  trace->toVCD("pipeline.vcd");
}

void Sphinx::reset_debug() {
  this->debug_state = 0;
  this->debug_return = 0;
  this->debug_wait_num = 0;
  this->debug_inst_num = 0;
  this->debug_end_wait = 0;
}
