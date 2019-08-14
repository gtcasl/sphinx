module ICACHE(
  input wire[31:0] io_IBUS_in_data_data,
  input wire io_IBUS_in_data_valid,
  output wire io_IBUS_in_data_ready,
  output wire[31:0] io_IBUS_out_address_data,
  output wire io_IBUS_out_address_valid,
  input wire io_IBUS_out_address_ready,
  input wire[31:0] io_in_address,
  output wire[31:0] io_out_instruction,
  output wire io_out_delay
);
  assign io_IBUS_in_data_ready = 1'h1;
  assign io_IBUS_out_address_data = io_in_address;
  assign io_IBUS_out_address_valid = 1'h1;
  assign io_out_instruction = io_IBUS_in_data_data;
  assign io_out_delay = 1'h0;

endmodule

module Fetch(
  input wire clk,
  input wire reset,
  input wire[31:0] io_IBUS_in_data_data,
  input wire io_IBUS_in_data_valid,
  output wire io_IBUS_in_data_ready,
  output wire[31:0] io_IBUS_out_address_data,
  output wire io_IBUS_out_address_valid,
  input wire io_IBUS_out_address_ready,
  input wire io_in_branch_dir,
  input wire io_in_freeze,
  input wire[31:0] io_in_branch_dest,
  input wire io_in_branch_stall,
  input wire io_in_fwd_stall,
  input wire io_in_branch_stall_exe,
  input wire io_in_jal,
  input wire[31:0] io_in_jal_dest,
  input wire io_in_interrupt,
  input wire[31:0] io_in_interrupt_pc,
  input wire io_in_debug,
  output wire[31:0] io_out_instruction,
  output wire io_out_delay,
  output wire[31:0] io_out_curr_PC
);
  reg reg_ch_bool_132, reg_ch_bool_135, reg_ch_bool_158;
  reg[31:0] reg_ch_bit_32u_139, reg_ch_bit_32u_146, reg_ch_bit_32u_149, reg_ch_bit_32u_152, sel_166;
  reg[4:0] reg_ch_bit_5u_143;
  wire[31:0] sel_168, sel_169, sel_170, sel_173, sel_186, sel_191, sel_196, op_add_215, op_add_217, op_add_219, ICACHE_107_io_IBUS_in_data_data, ICACHE_107_io_IBUS_out_address_data, ICACHE_107_io_in_address, ICACHE_107_io_out_instruction;
  wire[4:0] sel_202, sel_206, sel_208, sel_210, sel_212;
  wire op_notl_171, op_andl_172, op_eq_176, op_eq_178, op_orl_179, op_orl_180, op_orl_181, op_orl_182, op_orl_183, op_orl_184, op_eq_189, op_andl_190, op_notl_192, op_eq_194, op_andl_195, ICACHE_107_io_IBUS_in_data_valid, ICACHE_107_io_IBUS_in_data_ready, ICACHE_107_io_IBUS_out_address_valid, ICACHE_107_io_IBUS_out_address_ready, ICACHE_107_io_out_delay;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bool_132 <= 1'h0;
    else
      reg_ch_bool_132 <= op_orl_183;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bool_135 <= 1'h0;
    else
      reg_ch_bool_135 <= op_orl_184;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_139 <= 32'h0;
    else
      reg_ch_bit_32u_139 <= sel_196;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_143 <= 5'h0;
    else
      reg_ch_bit_5u_143 <= sel_212;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_146 <= 32'h0;
    else
      reg_ch_bit_32u_146 <= op_add_215;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_149 <= 32'h0;
    else
      reg_ch_bit_32u_149 <= op_add_217;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_152 <= 32'h0;
    else
      reg_ch_bit_32u_152 <= op_add_219;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bool_158 <= 1'h0;
    else
      reg_ch_bool_158 <= io_in_debug;
  end
  always @(*) begin
    case (reg_ch_bit_5u_143)
      5'h00: sel_166 = reg_ch_bit_32u_146;
      5'h01: sel_166 = reg_ch_bit_32u_149;
      5'h02: sel_166 = reg_ch_bit_32u_152;
      5'h03: sel_166 = reg_ch_bit_32u_146;
      5'h04: sel_166 = reg_ch_bit_32u_139;
      default: sel_166 = 32'h0;
    endcase
  end
  assign sel_168 = reg_ch_bool_132 ? reg_ch_bit_32u_139 : sel_166;
  assign sel_169 = reg_ch_bool_158 ? reg_ch_bit_32u_139 : reg_ch_bit_32u_146;
  assign sel_170 = io_in_debug ? sel_169 : sel_168;
  assign sel_173 = op_andl_172 ? reg_ch_bit_32u_139 : sel_170;
  assign sel_186 = op_orl_183 ? 32'h0 : ICACHE_107_io_out_instruction;
  assign sel_191 = op_andl_190 ? io_in_branch_dest : sel_173;
  assign sel_196 = op_andl_195 ? io_in_jal_dest : sel_191;
  assign sel_202 = op_eq_189 ? 5'h2 : 5'h0;
  assign sel_206 = op_eq_194 ? 5'h1 : sel_202;
  assign sel_208 = io_in_interrupt ? 5'h3 : sel_206;
  assign sel_210 = reg_ch_bool_158 ? 5'h4 : sel_208;
  assign sel_212 = io_in_debug ? 5'h3 : sel_210;
  assign op_notl_171 = !io_in_freeze;
  assign op_andl_172 = reg_ch_bool_135 && op_notl_171;
  assign op_eq_176 = io_in_fwd_stall == 1'h1;
  assign op_eq_178 = io_in_branch_stall == 1'h1;
  assign op_orl_179 = op_eq_178 || op_eq_176;
  assign op_orl_180 = op_orl_179 || io_in_branch_stall_exe;
  assign op_orl_181 = op_orl_180 || io_in_interrupt;
  assign op_orl_182 = op_orl_181 || ICACHE_107_io_out_delay;
  assign op_orl_183 = op_orl_182 || io_in_freeze;
  assign op_orl_184 = ICACHE_107_io_out_delay || io_in_freeze;
  assign op_eq_189 = io_in_branch_dir == 1'h1;
  assign op_andl_190 = op_eq_189 && op_notl_192;
  assign op_notl_192 = !reg_ch_bool_135;
  assign op_eq_194 = io_in_jal == 1'h1;
  assign op_andl_195 = op_eq_194 && op_notl_192;
  assign op_add_215 = sel_173 + 32'h4;
  assign op_add_217 = io_in_jal_dest + 32'h4;
  assign op_add_219 = io_in_branch_dest + 32'h4;
  ICACHE ICACHE_107(
    .io_IBUS_in_data_data(ICACHE_107_io_IBUS_in_data_data),
    .io_IBUS_in_data_valid(ICACHE_107_io_IBUS_in_data_valid),
    .io_IBUS_out_address_ready(ICACHE_107_io_IBUS_out_address_ready),
    .io_in_address(ICACHE_107_io_in_address),
    .io_IBUS_in_data_ready(ICACHE_107_io_IBUS_in_data_ready),
    .io_IBUS_out_address_data(ICACHE_107_io_IBUS_out_address_data),
    .io_IBUS_out_address_valid(ICACHE_107_io_IBUS_out_address_valid),
    .io_out_instruction(ICACHE_107_io_out_instruction),
    .io_out_delay(ICACHE_107_io_out_delay));
  assign ICACHE_107_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign ICACHE_107_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign ICACHE_107_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign ICACHE_107_io_in_address = sel_196;

  assign io_IBUS_in_data_ready = ICACHE_107_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = ICACHE_107_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = ICACHE_107_io_IBUS_out_address_valid;
  assign io_out_instruction = sel_186;
  assign io_out_delay = ICACHE_107_io_out_delay;
  assign io_out_curr_PC = sel_196;

endmodule

module F_D_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_branch_stall,
  input wire io_in_branch_stall_exe,
  input wire io_in_fwd_stall,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC
);
  reg[31:0] reg_ch_bit_32u_283, reg_ch_bit_32u_286;
  wire op_eq_298;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_283 <= 32'h0;
    else
    if (op_eq_298)
      reg_ch_bit_32u_283 <= io_in_instruction;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_286 <= 32'h0;
    else
    if (op_eq_298)
      reg_ch_bit_32u_286 <= io_in_curr_PC;
  end
  assign op_eq_298 = io_in_fwd_stall == 1'h0;

  assign io_out_instruction = reg_ch_bit_32u_283;
  assign io_out_curr_PC = reg_ch_bit_32u_286;

endmodule

module RegisterFile(
  input wire clk,
  input wire io_in_write_register,
  input wire[4:0] io_in_rd,
  input wire[31:0] io_in_data,
  input wire[4:0] io_in_src1,
  input wire[4:0] io_in_src2,
  output wire[31:0] io_out_src1_data,
  output wire[31:0] io_out_src2_data
);
  reg[31:0] mem_ch_bit_32u_379 [0:31];
  wire[31:0] marport_ch_bit_32u_392, marport_ch_bit_32u_399, sel_397, sel_403;
  wire op_ne_385, op_andl_386, op_eq_396, op_eq_402;

  assign marport_ch_bit_32u_392 = mem_ch_bit_32u_379[io_in_src1];
  assign marport_ch_bit_32u_399 = mem_ch_bit_32u_379[io_in_src2];
  always @ (posedge clk) begin
    if (op_andl_386) begin
      mem_ch_bit_32u_379[io_in_rd] <= io_in_data;
    end
  end
  assign sel_397 = op_eq_396 ? 32'h0 : marport_ch_bit_32u_392;
  assign sel_403 = op_eq_402 ? 32'h0 : marport_ch_bit_32u_399;
  assign op_ne_385 = io_in_rd != 5'h0;
  assign op_andl_386 = io_in_write_register && op_ne_385;
  assign op_eq_396 = io_in_src1 == 5'h0;
  assign op_eq_402 = io_in_src2 == 5'h0;

  assign io_out_src1_data = sel_397;
  assign io_out_src2_data = sel_403;

endmodule

module Decode(
  input wire clk,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_stall,
  input wire[31:0] io_in_write_data,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
  input wire io_in_src1_fwd,
  input wire[31:0] io_in_src1_fwd_data,
  input wire io_in_src2_fwd,
  input wire[31:0] io_in_src2_fwd_data,
  input wire io_in_csr_fwd,
  input wire[31:0] io_in_csr_fwd_data,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_mask,
  output wire[4:0] io_out_rd,
  output wire[4:0] io_out_rs1,
  output wire[31:0] io_out_rd1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_rd2,
  output wire[1:0] io_out_wb,
  output wire[3:0] io_out_alu_op,
  output wire io_out_rs2_src,
  output wire[31:0] io_out_itype_immed,
  output wire[2:0] io_out_mem_read,
  output wire[2:0] io_out_mem_write,
  output wire[2:0] io_out_branch_type,
  output wire io_out_branch_stall,
  output wire io_out_jal,
  output wire[31:0] io_out_jal_offset,
  output wire[19:0] io_out_upper_immed,
  output wire[31:0] io_out_PC_next
);
  wire[4:0] proxy_slice_452, proxy_slice_456, proxy_slice_460, RegisterFile_404_io_in_rd, RegisterFile_404_io_in_src1, RegisterFile_404_io_in_src2;
  wire[2:0] proxy_slice_464, sel_551, sel_553, sel_700;
  wire[6:0] proxy_slice_468;
  wire[11:0] proxy_slice_471, proxy_cat_581, proxy_cat_639, proxy_cat_669, sel_619, sel_630, op_pad_629;
  wire[19:0] proxy_cat_555;
  wire[7:0] proxy_slice_561;
  wire proxy_slice_562, proxy_slice_658, proxy_slice_660, op_ne_446, op_eq_477, op_eq_480, op_eq_483, op_orl_484, op_eq_487, op_eq_490, op_eq_493, op_eq_496, op_eq_499, op_eq_502, op_eq_508, op_andl_509, op_eq_512, op_andl_513, op_eq_515, op_andl_518, op_eq_520, op_eq_524, op_orl_532, op_orl_533, op_orl_534, op_orl_535, op_orl_542, op_orl_543, op_orl_547, op_eq_589, op_lt_596, op_andl_597, op_ne_611, op_ge_613, op_eq_614, op_andl_617, op_andl_618, op_eq_623, op_eq_626, op_orl_627, op_eq_637, op_eq_656, op_eq_675, op_eq_709, op_eq_744, op_eq_749, op_orl_752, op_lt_765, RegisterFile_404_clk, RegisterFile_404_io_in_write_register;
  wire[9:0] proxy_slice_567;
  wire[20:0] proxy_cat_571;
  wire[31:0] proxy_cat_576, proxy_cat_586, proxy_cat_634, proxy_cat_653, sel_521, sel_522, sel_525, sel_528, sel_579, sel_590, sel_606, sel_638, sel_657, sel_676, op_shr_451, op_shr_455, op_shr_463, op_shr_467, op_shr_470, op_add_474, op_pad_527, op_shr_566, op_pad_573, op_pad_583, op_pad_632, op_pad_651, op_shr_664, RegisterFile_404_io_in_data, RegisterFile_404_io_out_src1_data, RegisterFile_404_io_out_src2_data;
  wire[3:0] proxy_slice_665, sel_710, sel_712, sel_727, sel_745, sel_750, sel_753, sel_754, sel_757, sel_760, sel_766, sel_767;
  wire[5:0] proxy_slice_668;
  wire[1:0] sel_536, sel_539, sel_544;
  reg[19:0] sel_558;
  reg[31:0] sel_607, sel_679;
  reg sel_609, sel_701;
  reg[11:0] sel_680;
  reg[2:0] sel_699;
  reg[3:0] sel_734;

  assign proxy_slice_452 = op_shr_451[4:0];
  assign proxy_slice_456 = op_shr_455[4:0];
  assign proxy_slice_460 = op_shr_470[4:0];
  assign proxy_slice_464 = op_shr_463[2:0];
  assign proxy_slice_468 = op_shr_467[6:0];
  assign proxy_slice_471 = op_shr_470[11:0];
  assign proxy_cat_555 = {proxy_slice_468, proxy_slice_460, proxy_slice_456, proxy_slice_464};
  assign proxy_slice_561 = op_shr_463[7:0];
  assign proxy_slice_562 = io_in_instruction[20];
  assign proxy_slice_567 = op_shr_566[9:0];
  assign proxy_cat_571 = {proxy_slice_658, proxy_slice_561, proxy_slice_562, proxy_slice_567, 1'h0};
  assign proxy_cat_576 = {11'h7ff, proxy_cat_571};
  assign proxy_cat_581 = {proxy_slice_468, proxy_slice_460};
  assign proxy_cat_586 = {20'hfffff, proxy_cat_581};
  assign proxy_cat_634 = {20'hfffff, sel_680};
  assign proxy_cat_639 = {proxy_slice_468, proxy_slice_452};
  assign proxy_cat_653 = {20'hfffff, proxy_slice_471};
  assign proxy_slice_658 = io_in_instruction[31];
  assign proxy_slice_660 = io_in_instruction[7];
  assign proxy_slice_665 = op_shr_664[3:0];
  assign proxy_slice_668 = op_shr_467[5:0];
  assign proxy_cat_669 = {proxy_slice_658, proxy_slice_660, proxy_slice_668, proxy_slice_665};
  assign sel_521 = op_eq_520 ? io_in_src1_fwd_data : RegisterFile_404_io_out_src1_data;
  assign sel_522 = op_eq_493 ? io_in_curr_PC : sel_521;
  assign sel_525 = op_eq_524 ? io_in_src2_fwd_data : RegisterFile_404_io_out_src2_data;
  assign sel_528 = op_andl_513 ? op_pad_527 : sel_522;
  assign sel_536 = op_orl_535 ? 2'h1 : 2'h0;
  assign sel_539 = op_eq_480 ? 2'h2 : sel_536;
  assign sel_544 = op_orl_543 ? 2'h3 : sel_539;
  assign sel_551 = op_eq_480 ? proxy_slice_464 : 3'h7;
  assign sel_553 = op_eq_487 ? proxy_slice_464 : 3'h7;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h17: sel_558 = proxy_cat_555;
      7'h37: sel_558 = proxy_cat_555;
      default: sel_558 = 20'h7b;
    endcase
  end
  assign sel_579 = op_eq_675 ? proxy_cat_576 : op_pad_573;
  assign sel_590 = op_eq_589 ? proxy_cat_586 : op_pad_583;
  assign sel_606 = op_andl_597 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h67: sel_607 = sel_590;
      7'h6f: sel_607 = sel_579;
      7'h73: sel_607 = sel_606;
      default: sel_607 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h67: sel_609 = 1'h1;
      7'h6f: sel_609 = 1'h1;
      7'h73: sel_609 = op_andl_597;
      default: sel_609 = 1'h0;
    endcase
  end
  assign sel_619 = op_andl_618 ? proxy_slice_471 : 12'h7b;
  assign sel_630 = op_orl_627 ? op_pad_629 : proxy_slice_471;
  assign sel_638 = op_eq_637 ? proxy_cat_634 : op_pad_632;
  assign sel_657 = op_eq_656 ? proxy_cat_653 : op_pad_651;
  assign sel_676 = op_eq_675 ? proxy_cat_634 : op_pad_632;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h03: sel_679 = sel_657;
      7'h13: sel_679 = sel_638;
      7'h23: sel_679 = sel_638;
      7'h63: sel_679 = sel_676;
      default: sel_679 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel_680 = sel_630;
      7'h23: sel_680 = proxy_cat_639;
      7'h63: sel_680 = proxy_cat_669;
      default: sel_680 = 12'h0;
    endcase
  end
  always @(*) begin
    case (proxy_slice_464)
      3'h0: sel_699 = 3'h1;
      3'h1: sel_699 = 3'h2;
      3'h4: sel_699 = 3'h3;
      3'h5: sel_699 = 3'h4;
      3'h6: sel_699 = 3'h5;
      3'h7: sel_699 = 3'h6;
      default: sel_699 = 3'h0;
    endcase
  end
  assign sel_700 = op_eq_490 ? sel_699 : 3'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel_701 = 1'h1;
      7'h67: sel_701 = 1'h1;
      7'h6f: sel_701 = 1'h1;
      default: sel_701 = 1'h0;
    endcase
  end
  assign sel_710 = op_eq_709 ? 4'h0 : 4'h1;
  assign sel_712 = op_eq_483 ? 4'h0 : sel_710;
  assign sel_727 = op_eq_709 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy_slice_464)
      3'h0: sel_734 = sel_712;
      3'h1: sel_734 = 4'h2;
      3'h2: sel_734 = 4'h3;
      3'h3: sel_734 = 4'h4;
      3'h4: sel_734 = 4'h5;
      3'h5: sel_734 = sel_727;
      3'h6: sel_734 = 4'h8;
      3'h7: sel_734 = 4'h9;
      default: sel_734 = 4'hf;
    endcase
  end
  assign sel_745 = op_eq_744 ? 4'he : 4'hf;
  assign sel_750 = op_eq_749 ? 4'hd : sel_745;
  assign sel_753 = op_orl_752 ? 4'h0 : sel_734;
  assign sel_754 = op_andl_509 ? sel_750 : sel_753;
  assign sel_757 = op_eq_502 ? 4'hc : sel_754;
  assign sel_760 = op_eq_499 ? 4'hb : sel_757;
  assign sel_766 = op_lt_765 ? 4'h1 : 4'ha;
  assign sel_767 = op_eq_490 ? sel_766 : sel_760;
  assign op_ne_446 = io_in_wb != 2'h0;
  assign op_shr_451 = io_in_instruction >> 32'h7;
  assign op_shr_455 = io_in_instruction >> 32'hf;
  assign op_shr_463 = io_in_instruction >> 32'hc;
  assign op_shr_467 = io_in_instruction >> 32'h19;
  assign op_shr_470 = io_in_instruction >> 32'h14;
  assign op_add_474 = io_in_curr_PC + 32'h4;
  assign op_eq_477 = io_in_instruction[6:0] == 7'h33;
  assign op_eq_480 = io_in_instruction[6:0] == 7'h3;
  assign op_eq_483 = io_in_instruction[6:0] == 7'h13;
  assign op_orl_484 = op_eq_483 || op_eq_480;
  assign op_eq_487 = io_in_instruction[6:0] == 7'h23;
  assign op_eq_490 = io_in_instruction[6:0] == 7'h63;
  assign op_eq_493 = io_in_instruction[6:0] == 7'h6f;
  assign op_eq_496 = io_in_instruction[6:0] == 7'h67;
  assign op_eq_499 = io_in_instruction[6:0] == 7'h37;
  assign op_eq_502 = io_in_instruction[6:0] == 7'h17;
  assign op_eq_508 = io_in_instruction[6:0] == 7'h73;
  assign op_andl_509 = op_eq_508 && op_ne_611;
  assign op_eq_512 = op_shr_463[2] == 1'h1;
  assign op_andl_513 = op_andl_509 && op_eq_512;
  assign op_eq_515 = proxy_slice_464 == 3'h0;
  assign op_andl_518 = op_eq_508 && op_eq_515;
  assign op_eq_520 = io_in_src1_fwd == 1'h1;
  assign op_eq_524 = io_in_src2_fwd == 1'h1;
  assign op_pad_527 = {{27{1'b0}}, proxy_slice_456};
  assign op_orl_532 = op_orl_484 || op_eq_477;
  assign op_orl_533 = op_orl_532 || op_eq_499;
  assign op_orl_534 = op_orl_533 || op_eq_502;
  assign op_orl_535 = op_orl_534 || op_andl_509;
  assign op_orl_542 = op_eq_493 || op_eq_496;
  assign op_orl_543 = op_orl_542 || op_andl_518;
  assign op_orl_547 = op_orl_484 || op_eq_487;
  assign op_shr_566 = io_in_instruction >> 32'h15;
  assign op_pad_573 = {{11{1'b0}}, proxy_cat_571};
  assign op_pad_583 = {{20{1'b0}}, proxy_cat_581};
  assign op_eq_589 = op_shr_467[6] == 1'h1;
  assign op_lt_596 = proxy_slice_471 < 12'h2;
  assign op_andl_597 = op_eq_515 && op_lt_596;
  assign op_ne_611 = proxy_slice_464 != 3'h0;
  assign op_ge_613 = proxy_slice_471 >= 12'h2;
  assign op_eq_614 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign op_andl_617 = op_ne_611 && op_ge_613;
  assign op_andl_618 = op_andl_617 && op_eq_614;
  assign op_eq_623 = proxy_slice_464 == 3'h5;
  assign op_eq_626 = proxy_slice_464 == 3'h1;
  assign op_orl_627 = op_eq_626 || op_eq_623;
  assign op_pad_629 = {{7{1'b0}}, proxy_slice_460};
  assign op_pad_632 = {{20{1'b0}}, sel_680};
  assign op_eq_637 = sel_680[11] == 1'h1;
  assign op_pad_651 = {{20{1'b0}}, proxy_slice_471};
  assign op_eq_656 = op_shr_470[11] == 1'h1;
  assign op_shr_664 = io_in_instruction >> 32'h8;
  assign op_eq_675 = proxy_slice_658 == 1'h1;
  assign op_eq_709 = proxy_slice_468 == 7'h0;
  assign op_eq_744 = op_shr_463[1:0] == 2'h2;
  assign op_eq_749 = op_shr_463[1:0] == 2'h1;
  assign op_orl_752 = op_eq_487 || op_eq_480;
  assign op_lt_765 = sel_700 < 3'h5;
  RegisterFile RegisterFile_404(
    .io_in_write_register(RegisterFile_404_io_in_write_register),
    .io_in_rd(RegisterFile_404_io_in_rd),
    .io_in_data(RegisterFile_404_io_in_data),
    .io_in_src1(RegisterFile_404_io_in_src1),
    .io_in_src2(RegisterFile_404_io_in_src2),
    .clk(RegisterFile_404_clk),
    .io_out_src1_data(RegisterFile_404_io_out_src1_data),
    .io_out_src2_data(RegisterFile_404_io_out_src2_data));
  assign RegisterFile_404_clk = clk;
  assign RegisterFile_404_io_in_write_register = op_ne_446;
  assign RegisterFile_404_io_in_rd = io_in_rd;
  assign RegisterFile_404_io_in_data = io_in_write_data;
  assign RegisterFile_404_io_in_src1 = proxy_slice_456;
  assign RegisterFile_404_io_in_src2 = proxy_slice_460;

  assign io_out_csr_address = sel_619;
  assign io_out_is_csr = op_andl_509;
  assign io_out_csr_mask = sel_528;
  assign io_out_rd = proxy_slice_452;
  assign io_out_rs1 = proxy_slice_456;
  assign io_out_rd1 = sel_522;
  assign io_out_rs2 = proxy_slice_460;
  assign io_out_rd2 = sel_525;
  assign io_out_wb = sel_544;
  assign io_out_alu_op = sel_767;
  assign io_out_rs2_src = op_orl_547;
  assign io_out_itype_immed = sel_679;
  assign io_out_mem_read = sel_551;
  assign io_out_mem_write = sel_553;
  assign io_out_branch_type = sel_700;
  assign io_out_branch_stall = sel_701;
  assign io_out_jal = sel_609;
  assign io_out_jal_offset = sel_607;
  assign io_out_upper_immed = sel_558;
  assign io_out_PC_next = op_add_474;

endmodule

module D_E_Register(
  input wire clk,
  input wire reset,
  input wire[4:0] io_in_rd,
  input wire[4:0] io_in_rs1,
  input wire[31:0] io_in_rd1,
  input wire[4:0] io_in_rs2,
  input wire[31:0] io_in_rd2,
  input wire[3:0] io_in_alu_op,
  input wire[1:0] io_in_wb,
  input wire io_in_rs2_src,
  input wire[31:0] io_in_itype_immed,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[31:0] io_in_PC_next,
  input wire[2:0] io_in_branch_type,
  input wire io_in_fwd_stall,
  input wire io_in_branch_stall,
  input wire[19:0] io_in_upper_immed,
  input wire[11:0] io_in_csr_address,
  input wire io_in_is_csr,
  input wire[31:0] io_in_csr_mask,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_jal,
  input wire[31:0] io_in_jal_offset,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_mask,
  output wire[4:0] io_out_rd,
  output wire[4:0] io_out_rs1,
  output wire[31:0] io_out_rd1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_rd2,
  output wire[3:0] io_out_alu_op,
  output wire[1:0] io_out_wb,
  output wire io_out_rs2_src,
  output wire[31:0] io_out_itype_immed,
  output wire[2:0] io_out_mem_read,
  output wire[2:0] io_out_mem_write,
  output wire[2:0] io_out_branch_type,
  output wire[19:0] io_out_upper_immed,
  output wire[31:0] io_out_curr_PC,
  output wire io_out_jal,
  output wire[31:0] io_out_jal_offset,
  output wire[31:0] io_out_PC_next
);
  reg[4:0] reg_ch_bit_5u_903, reg_ch_bit_5u_906, reg_ch_bit_5u_913;
  reg[31:0] reg_ch_bit_32u_910, reg_ch_bit_32u_916, reg_ch_bit_32u_927, reg_ch_bit_32u_934, reg_ch_bit_32u_959, reg_ch_bit_32u_962, reg_ch_bit_32u_968;
  reg[3:0] reg_ch_bit_4u_920;
  reg[1:0] reg_ch_bit_2u_924;
  reg reg_ch_bit_1u_931, reg_ch_bit_1u_956, reg_ch_bit_1u_965;
  reg[2:0] reg_ch_bit_3u_938, reg_ch_bit_3u_941, reg_ch_bit_3u_945;
  reg[19:0] reg_ch_bit_20u_949;
  reg[11:0] reg_ch_bit_12u_953;
  wire[4:0] sel_976, sel_978, sel_982;
  wire[31:0] sel_980, sel_984, sel_991, sel_996, sel_1010, sel_1014, sel_1016;
  wire[3:0] sel_987;
  wire[1:0] sel_989;
  wire sel_993, sel_1008, sel_1012, op_eq_971, op_eq_973, op_orl_974;
  wire[2:0] sel_998, sel_1000, sel_1002;
  wire[19:0] sel_1004;
  wire[11:0] sel_1006;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_903 <= 5'h0;
    else
      reg_ch_bit_5u_903 <= sel_976;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_906 <= 5'h0;
    else
      reg_ch_bit_5u_906 <= sel_978;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_910 <= 32'h0;
    else
      reg_ch_bit_32u_910 <= sel_980;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_913 <= 5'h0;
    else
      reg_ch_bit_5u_913 <= sel_982;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_916 <= 32'h0;
    else
      reg_ch_bit_32u_916 <= sel_984;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_4u_920 <= 4'h0;
    else
      reg_ch_bit_4u_920 <= sel_987;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_924 <= 2'h0;
    else
      reg_ch_bit_2u_924 <= sel_989;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_927 <= 32'h0;
    else
      reg_ch_bit_32u_927 <= sel_991;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_931 <= 1'h0;
    else
      reg_ch_bit_1u_931 <= sel_993;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_934 <= 32'h0;
    else
      reg_ch_bit_32u_934 <= sel_996;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_938 <= 3'h7;
    else
      reg_ch_bit_3u_938 <= sel_998;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_941 <= 3'h7;
    else
      reg_ch_bit_3u_941 <= sel_1000;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_945 <= 3'h0;
    else
      reg_ch_bit_3u_945 <= sel_1002;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_20u_949 <= 20'h0;
    else
      reg_ch_bit_20u_949 <= sel_1004;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_953 <= 12'h0;
    else
      reg_ch_bit_12u_953 <= sel_1006;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_956 <= 1'h0;
    else
      reg_ch_bit_1u_956 <= sel_1008;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_959 <= 32'h0;
    else
      reg_ch_bit_32u_959 <= sel_1010;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_962 <= 32'h0;
    else
      reg_ch_bit_32u_962 <= sel_1016;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_965 <= 1'h0;
    else
      reg_ch_bit_1u_965 <= sel_1012;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_968 <= 32'h0;
    else
      reg_ch_bit_32u_968 <= sel_1014;
  end
  assign sel_976 = op_orl_974 ? 5'h0 : io_in_rd;
  assign sel_978 = op_orl_974 ? 5'h0 : io_in_rs1;
  assign sel_980 = op_orl_974 ? 32'h0 : io_in_rd1;
  assign sel_982 = op_orl_974 ? 5'h0 : io_in_rs2;
  assign sel_984 = op_orl_974 ? 32'h0 : io_in_rd2;
  assign sel_987 = op_orl_974 ? 4'hf : io_in_alu_op;
  assign sel_989 = op_orl_974 ? 2'h0 : io_in_wb;
  assign sel_991 = op_orl_974 ? 32'h0 : io_in_PC_next;
  assign sel_993 = op_orl_974 ? 1'h0 : io_in_rs2_src;
  assign sel_996 = op_orl_974 ? 32'h7b : io_in_itype_immed;
  assign sel_998 = op_orl_974 ? 3'h7 : io_in_mem_read;
  assign sel_1000 = op_orl_974 ? 3'h7 : io_in_mem_write;
  assign sel_1002 = op_orl_974 ? 3'h0 : io_in_branch_type;
  assign sel_1004 = op_orl_974 ? 20'h0 : io_in_upper_immed;
  assign sel_1006 = op_orl_974 ? 12'h0 : io_in_csr_address;
  assign sel_1008 = op_orl_974 ? 1'h0 : io_in_is_csr;
  assign sel_1010 = op_orl_974 ? 32'h0 : io_in_csr_mask;
  assign sel_1012 = op_orl_974 ? 1'h0 : io_in_jal;
  assign sel_1014 = op_orl_974 ? 32'h0 : io_in_jal_offset;
  assign sel_1016 = op_orl_974 ? 32'h0 : io_in_curr_PC;
  assign op_eq_971 = io_in_branch_stall == 1'h1;
  assign op_eq_973 = io_in_fwd_stall == 1'h1;
  assign op_orl_974 = op_eq_973 || op_eq_971;

  assign io_out_csr_address = reg_ch_bit_12u_953;
  assign io_out_is_csr = reg_ch_bit_1u_956;
  assign io_out_csr_mask = reg_ch_bit_32u_959;
  assign io_out_rd = reg_ch_bit_5u_903;
  assign io_out_rs1 = reg_ch_bit_5u_906;
  assign io_out_rd1 = reg_ch_bit_32u_910;
  assign io_out_rs2 = reg_ch_bit_5u_913;
  assign io_out_rd2 = reg_ch_bit_32u_916;
  assign io_out_alu_op = reg_ch_bit_4u_920;
  assign io_out_wb = reg_ch_bit_2u_924;
  assign io_out_rs2_src = reg_ch_bit_1u_931;
  assign io_out_itype_immed = reg_ch_bit_32u_934;
  assign io_out_mem_read = reg_ch_bit_3u_938;
  assign io_out_mem_write = reg_ch_bit_3u_941;
  assign io_out_branch_type = reg_ch_bit_3u_945;
  assign io_out_upper_immed = reg_ch_bit_20u_949;
  assign io_out_curr_PC = reg_ch_bit_32u_962;
  assign io_out_jal = reg_ch_bit_1u_965;
  assign io_out_jal_offset = reg_ch_bit_32u_968;
  assign io_out_PC_next = reg_ch_bit_32u_927;

endmodule

module Execute(
  input wire[4:0] io_in_rd,
  input wire[4:0] io_in_rs1,
  input wire[31:0] io_in_rd1,
  input wire[4:0] io_in_rs2,
  input wire[31:0] io_in_rd2,
  input wire[3:0] io_in_alu_op,
  input wire[1:0] io_in_wb,
  input wire io_in_rs2_src,
  input wire[31:0] io_in_itype_immed,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[31:0] io_in_PC_next,
  input wire[2:0] io_in_branch_type,
  input wire[19:0] io_in_upper_immed,
  input wire[11:0] io_in_csr_address,
  input wire io_in_is_csr,
  input wire[31:0] io_in_csr_data,
  input wire[31:0] io_in_csr_mask,
  input wire io_in_jal,
  input wire[31:0] io_in_jal_offset,
  input wire[31:0] io_in_curr_PC,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_result,
  output wire[31:0] io_out_alu_result,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb,
  output wire[4:0] io_out_rs1,
  output wire[31:0] io_out_rd1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_rd2,
  output wire[2:0] io_out_mem_read,
  output wire[2:0] io_out_mem_write,
  output wire io_out_jal,
  output wire[31:0] io_out_jal_dest,
  output wire[31:0] io_out_branch_offset,
  output wire io_out_branch_stall,
  output wire[31:0] io_out_PC_next
);
  wire[31:0] proxy_cat_1166, sel_1163, sel_1186, sel_1192, sel_1230, op_add_1167, op_add_1169, op_sub_1173, op_shl_1178, op_xorb_1195, op_shr_1200, op_shr_1205, op_orb_1208, op_andb_1211, op_add_1220, op_orb_1224, op_sub_1226, op_andb_1227;
  reg[31:0] sel_1229, sel_1231;
  wire op_eq_1161, op_lt_1185, op_lt_1191, op_ge_1214, op_ne_1237;

  assign proxy_cat_1166 = {io_in_upper_immed, 12'h0};
  assign sel_1163 = op_eq_1161 ? io_in_itype_immed : io_in_rd2;
  assign sel_1186 = op_lt_1185 ? 32'h1 : 32'h0;
  assign sel_1192 = op_lt_1191 ? 32'h1 : 32'h0;
  always @(*) begin
    case (io_in_alu_op)
      4'hd: sel_1229 = io_in_csr_mask;
      4'he: sel_1229 = op_orb_1224;
      4'hf: sel_1229 = op_andb_1227;
      default: sel_1229 = 32'h7b;
    endcase
  end
  assign sel_1230 = op_ge_1214 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel_1231 = op_add_1169;
      4'h1: sel_1231 = op_sub_1173;
      4'h2: sel_1231 = op_shl_1178;
      4'h3: sel_1231 = sel_1186;
      4'h4: sel_1231 = sel_1192;
      4'h5: sel_1231 = op_xorb_1195;
      4'h6: sel_1231 = op_shr_1200;
      4'h7: sel_1231 = op_shr_1205;
      4'h8: sel_1231 = op_orb_1208;
      4'h9: sel_1231 = op_andb_1211;
      4'ha: sel_1231 = sel_1230;
      4'hb: sel_1231 = proxy_cat_1166;
      4'hc: sel_1231 = op_add_1220;
      4'hd: sel_1231 = io_in_csr_data;
      4'he: sel_1231 = io_in_csr_data;
      4'hf: sel_1231 = io_in_csr_data;
      default: sel_1231 = 32'h0;
    endcase
  end
  assign op_eq_1161 = io_in_rs2_src == 1'h1;
  assign op_add_1167 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign op_add_1169 = $signed(io_in_rd1) + $signed(sel_1163);
  assign op_sub_1173 = $signed(io_in_rd1) - $signed(sel_1163);
  assign op_shl_1178 = io_in_rd1 << sel_1163[4:0];
  assign op_lt_1185 = $signed(io_in_rd1) < $signed(sel_1163);
  assign op_lt_1191 = io_in_rd1 < sel_1163;
  assign op_xorb_1195 = io_in_rd1 ^ sel_1163;
  assign op_shr_1200 = io_in_rd1 >> sel_1163[4:0];
  assign op_shr_1205 = $signed(io_in_rd1) >> sel_1163[4:0];
  assign op_orb_1208 = io_in_rd1 | sel_1163;
  assign op_andb_1211 = sel_1163 & io_in_rd1;
  assign op_ge_1214 = io_in_rd1 >= sel_1163;
  assign op_add_1220 = $signed(io_in_curr_PC) + $signed(proxy_cat_1166);
  assign op_orb_1224 = io_in_csr_data | io_in_csr_mask;
  assign op_sub_1226 = 32'hffffffff - io_in_csr_mask;
  assign op_andb_1227 = io_in_csr_data & op_sub_1226;
  assign op_ne_1237 = io_in_branch_type != 3'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel_1229;
  assign io_out_alu_result = sel_1231;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = op_add_1167;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = op_ne_1237;
  assign io_out_PC_next = io_in_PC_next;

endmodule

module E_M_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_alu_result,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
  input wire[4:0] io_in_rs1,
  input wire[31:0] io_in_rd1,
  input wire[4:0] io_in_rs2,
  input wire[31:0] io_in_rd2,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[31:0] io_in_PC_next,
  input wire[11:0] io_in_csr_address,
  input wire io_in_is_csr,
  input wire[31:0] io_in_csr_result,
  input wire[31:0] io_in_curr_PC,
  input wire[31:0] io_in_branch_offset,
  input wire[2:0] io_in_branch_type,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_result,
  output wire[31:0] io_out_alu_result,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb,
  output wire[4:0] io_out_rs1,
  output wire[31:0] io_out_rd1,
  output wire[31:0] io_out_rd2,
  output wire[4:0] io_out_rs2,
  output wire[2:0] io_out_mem_read,
  output wire[2:0] io_out_mem_write,
  output wire[31:0] io_out_curr_PC,
  output wire[31:0] io_out_branch_offset,
  output wire[2:0] io_out_branch_type,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg_ch_bit_32u_1370, reg_ch_bit_32u_1380, reg_ch_bit_32u_1386, reg_ch_bit_32u_1393, reg_ch_bit_32u_1411, reg_ch_bit_32u_1414, reg_ch_bit_32u_1417;
  reg[4:0] reg_ch_bit_5u_1374, reg_ch_bit_5u_1377, reg_ch_bit_5u_1383;
  reg[1:0] reg_ch_bit_2u_1390;
  reg[2:0] reg_ch_bit_3u_1397, reg_ch_bit_3u_1400, reg_ch_bit_3u_1421;
  reg[11:0] reg_ch_bit_12u_1404;
  reg reg_ch_bit_1u_1408;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1370 <= 32'h0;
    else
      reg_ch_bit_32u_1370 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1374 <= 5'h0;
    else
      reg_ch_bit_5u_1374 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1377 <= 5'h0;
    else
      reg_ch_bit_5u_1377 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1380 <= 32'h0;
    else
      reg_ch_bit_32u_1380 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1383 <= 5'h0;
    else
      reg_ch_bit_5u_1383 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1386 <= 32'h0;
    else
      reg_ch_bit_32u_1386 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1390 <= 2'h0;
    else
      reg_ch_bit_2u_1390 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1393 <= 32'h0;
    else
      reg_ch_bit_32u_1393 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1397 <= 3'h7;
    else
      reg_ch_bit_3u_1397 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1400 <= 3'h7;
    else
      reg_ch_bit_3u_1400 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_1404 <= 12'h0;
    else
      reg_ch_bit_12u_1404 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_1408 <= 1'h0;
    else
      reg_ch_bit_1u_1408 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1411 <= 32'h0;
    else
      reg_ch_bit_32u_1411 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1414 <= 32'h0;
    else
      reg_ch_bit_32u_1414 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1417 <= 32'h0;
    else
      reg_ch_bit_32u_1417 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1421 <= 3'h0;
    else
      reg_ch_bit_3u_1421 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg_ch_bit_12u_1404;
  assign io_out_is_csr = reg_ch_bit_1u_1408;
  assign io_out_csr_result = reg_ch_bit_32u_1411;
  assign io_out_alu_result = reg_ch_bit_32u_1370;
  assign io_out_rd = reg_ch_bit_5u_1374;
  assign io_out_wb = reg_ch_bit_2u_1390;
  assign io_out_rs1 = reg_ch_bit_5u_1377;
  assign io_out_rd1 = reg_ch_bit_32u_1380;
  assign io_out_rd2 = reg_ch_bit_32u_1386;
  assign io_out_rs2 = reg_ch_bit_5u_1383;
  assign io_out_mem_read = reg_ch_bit_3u_1397;
  assign io_out_mem_write = reg_ch_bit_3u_1400;
  assign io_out_curr_PC = reg_ch_bit_32u_1414;
  assign io_out_branch_offset = reg_ch_bit_32u_1417;
  assign io_out_branch_type = reg_ch_bit_3u_1421;
  assign io_out_PC_next = reg_ch_bit_32u_1393;

endmodule

module Cache_driver(
  output wire io_DBUS_out_miss,
  output wire io_DBUS_out_rw,
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[2:0] io_DBUS_out_control_data,
  output wire io_DBUS_out_control_valid,
  input wire io_DBUS_out_control_ready,
  input wire[31:0] io_in_address,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[31:0] io_in_data,
  output wire io_out_delay,
  output wire[31:0] io_out_data
);
  wire[2:0] sel_1582;
  wire op_lt_1578, op_lt_1580, op_orl_1586;

  assign sel_1582 = op_lt_1578 ? io_in_mem_write : io_in_mem_read;
  assign op_lt_1578 = io_in_mem_write < 3'h7;
  assign op_lt_1580 = io_in_mem_read < 3'h7;
  assign op_orl_1586 = op_lt_1578 || op_lt_1580;

  assign io_DBUS_out_miss = 1'h0;
  assign io_DBUS_out_rw = op_lt_1578;
  assign io_DBUS_in_data_ready = op_orl_1586;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = op_orl_1586;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = op_orl_1586;
  assign io_DBUS_out_control_data = sel_1582;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_delay = 1'h0;
  assign io_out_data = io_DBUS_in_data_data;

endmodule

module Memory(
  output wire io_DBUS_out_miss,
  output wire io_DBUS_out_rw,
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[2:0] io_DBUS_out_control_data,
  output wire io_DBUS_out_control_valid,
  input wire io_DBUS_out_control_ready,
  input wire[31:0] io_in_alu_result,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
  input wire[4:0] io_in_rs1,
  input wire[31:0] io_in_rd1,
  input wire[4:0] io_in_rs2,
  input wire[31:0] io_in_rd2,
  input wire[31:0] io_in_PC_next,
  input wire[31:0] io_in_curr_PC,
  input wire[31:0] io_in_branch_offset,
  input wire[2:0] io_in_branch_type,
  output wire[31:0] io_out_alu_result,
  output wire[31:0] io_out_mem_result,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb,
  output wire[4:0] io_out_rs1,
  output wire[4:0] io_out_rs2,
  output wire io_out_branch_dir,
  output wire[31:0] io_out_branch_dest,
  output wire io_out_delay,
  output wire[31:0] io_out_PC_next
);
  reg sel_1681;
  wire[31:0] op_shl_1633, op_add_1634, Cache_driver_1590_io_DBUS_in_data_data, Cache_driver_1590_io_DBUS_out_data_data, Cache_driver_1590_io_DBUS_out_address_data, Cache_driver_1590_io_in_address, Cache_driver_1590_io_in_data, Cache_driver_1590_io_out_data;
  wire op_eq_1642, op_eq_1655, op_inv_1682, op_inv_1683, Cache_driver_1590_io_DBUS_out_miss, Cache_driver_1590_io_DBUS_out_rw, Cache_driver_1590_io_DBUS_in_data_valid, Cache_driver_1590_io_DBUS_in_data_ready, Cache_driver_1590_io_DBUS_out_data_valid, Cache_driver_1590_io_DBUS_out_data_ready, Cache_driver_1590_io_DBUS_out_address_valid, Cache_driver_1590_io_DBUS_out_address_ready, Cache_driver_1590_io_DBUS_out_control_valid, Cache_driver_1590_io_DBUS_out_control_ready, Cache_driver_1590_io_out_delay;
  wire[2:0] Cache_driver_1590_io_DBUS_out_control_data, Cache_driver_1590_io_in_mem_read, Cache_driver_1590_io_in_mem_write;

  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel_1681 = op_eq_1642;
      3'h2: sel_1681 = op_inv_1682;
      3'h3: sel_1681 = op_inv_1683;
      3'h4: sel_1681 = op_eq_1655;
      3'h5: sel_1681 = op_inv_1683;
      3'h6: sel_1681 = op_eq_1655;
      default: sel_1681 = 1'h0;
    endcase
  end
  assign op_shl_1633 = io_in_branch_offset << 32'h1;
  assign op_add_1634 = $signed(io_in_curr_PC) + $signed(op_shl_1633);
  assign op_eq_1642 = io_in_alu_result == 32'h0;
  assign op_eq_1655 = io_in_alu_result[31] == 1'h0;
  assign op_inv_1682 = ~op_eq_1642;
  assign op_inv_1683 = ~op_eq_1655;
  Cache_driver Cache_driver_1590(
    .io_DBUS_in_data_data(Cache_driver_1590_io_DBUS_in_data_data),
    .io_DBUS_in_data_valid(Cache_driver_1590_io_DBUS_in_data_valid),
    .io_DBUS_out_data_ready(Cache_driver_1590_io_DBUS_out_data_ready),
    .io_DBUS_out_address_ready(Cache_driver_1590_io_DBUS_out_address_ready),
    .io_DBUS_out_control_ready(Cache_driver_1590_io_DBUS_out_control_ready),
    .io_in_address(Cache_driver_1590_io_in_address),
    .io_in_mem_read(Cache_driver_1590_io_in_mem_read),
    .io_in_mem_write(Cache_driver_1590_io_in_mem_write),
    .io_in_data(Cache_driver_1590_io_in_data),
    .io_DBUS_out_miss(Cache_driver_1590_io_DBUS_out_miss),
    .io_DBUS_out_rw(Cache_driver_1590_io_DBUS_out_rw),
    .io_DBUS_in_data_ready(Cache_driver_1590_io_DBUS_in_data_ready),
    .io_DBUS_out_data_data(Cache_driver_1590_io_DBUS_out_data_data),
    .io_DBUS_out_data_valid(Cache_driver_1590_io_DBUS_out_data_valid),
    .io_DBUS_out_address_data(Cache_driver_1590_io_DBUS_out_address_data),
    .io_DBUS_out_address_valid(Cache_driver_1590_io_DBUS_out_address_valid),
    .io_DBUS_out_control_data(Cache_driver_1590_io_DBUS_out_control_data),
    .io_DBUS_out_control_valid(Cache_driver_1590_io_DBUS_out_control_valid),
    .io_out_delay(Cache_driver_1590_io_out_delay),
    .io_out_data(Cache_driver_1590_io_out_data));
  assign Cache_driver_1590_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Cache_driver_1590_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Cache_driver_1590_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Cache_driver_1590_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Cache_driver_1590_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Cache_driver_1590_io_in_address = io_in_alu_result;
  assign Cache_driver_1590_io_in_mem_read = io_in_mem_read;
  assign Cache_driver_1590_io_in_mem_write = io_in_mem_write;
  assign Cache_driver_1590_io_in_data = io_in_rd2;

  assign io_DBUS_out_miss = Cache_driver_1590_io_DBUS_out_miss;
  assign io_DBUS_out_rw = Cache_driver_1590_io_DBUS_out_rw;
  assign io_DBUS_in_data_ready = Cache_driver_1590_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Cache_driver_1590_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Cache_driver_1590_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Cache_driver_1590_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Cache_driver_1590_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Cache_driver_1590_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Cache_driver_1590_io_DBUS_out_control_valid;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = Cache_driver_1590_io_out_data;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel_1681;
  assign io_out_branch_dest = op_add_1634;
  assign io_out_delay = Cache_driver_1590_io_out_delay;
  assign io_out_PC_next = io_in_PC_next;

endmodule

module M_W_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_alu_result,
  input wire[31:0] io_in_mem_result,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
  input wire[4:0] io_in_rs1,
  input wire[4:0] io_in_rs2,
  input wire[31:0] io_in_PC_next,
  output wire[31:0] io_out_alu_result,
  output wire[31:0] io_out_mem_result,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb,
  output wire[4:0] io_out_rs1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg_ch_bit_32u_1786, reg_ch_bit_32u_1789, reg_ch_bit_32u_1806;
  reg[4:0] reg_ch_bit_5u_1793, reg_ch_bit_5u_1796, reg_ch_bit_5u_1799;
  reg[1:0] reg_ch_bit_2u_1803;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1786 <= 32'h0;
    else
      reg_ch_bit_32u_1786 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1789 <= 32'h0;
    else
      reg_ch_bit_32u_1789 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1793 <= 5'h0;
    else
      reg_ch_bit_5u_1793 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1796 <= 5'h0;
    else
      reg_ch_bit_5u_1796 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1799 <= 5'h0;
    else
      reg_ch_bit_5u_1799 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1803 <= 2'h0;
    else
      reg_ch_bit_2u_1803 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1806 <= 32'h0;
    else
      reg_ch_bit_32u_1806 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg_ch_bit_32u_1786;
  assign io_out_mem_result = reg_ch_bit_32u_1789;
  assign io_out_rd = reg_ch_bit_5u_1793;
  assign io_out_wb = reg_ch_bit_2u_1803;
  assign io_out_rs1 = reg_ch_bit_5u_1796;
  assign io_out_rs2 = reg_ch_bit_5u_1799;
  assign io_out_PC_next = reg_ch_bit_32u_1806;

endmodule

module Write_Back(
  input wire[31:0] io_in_alu_result,
  input wire[31:0] io_in_mem_result,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
  input wire[4:0] io_in_rs1,
  input wire[4:0] io_in_rs2,
  input wire[31:0] io_in_PC_next,
  output wire[31:0] io_out_write_data,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb
);
  wire[31:0] sel_1857, sel_1858;
  wire op_eq_1853, op_eq_1856;

  assign sel_1857 = op_eq_1856 ? io_in_alu_result : io_in_mem_result;
  assign sel_1858 = op_eq_1853 ? io_in_PC_next : sel_1857;
  assign op_eq_1853 = io_in_wb == 2'h3;
  assign op_eq_1856 = io_in_wb == 2'h1;

  assign io_out_write_data = sel_1858;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;

endmodule

module Forwarding(
  input wire[4:0] io_in_decode_src1,
  input wire[4:0] io_in_decode_src2,
  input wire[11:0] io_in_decode_csr_address,
  input wire[4:0] io_in_execute_dest,
  input wire[1:0] io_in_execute_wb,
  input wire[31:0] io_in_execute_alu_result,
  input wire[31:0] io_in_execute_PC_next,
  input wire io_in_execute_is_csr,
  input wire[11:0] io_in_execute_csr_address,
  input wire[31:0] io_in_execute_csr_result,
  input wire[4:0] io_in_memory_dest,
  input wire[1:0] io_in_memory_wb,
  input wire[31:0] io_in_memory_alu_result,
  input wire[31:0] io_in_memory_mem_data,
  input wire[31:0] io_in_memory_PC_next,
  input wire io_in_memory_is_csr,
  input wire[11:0] io_in_memory_csr_address,
  input wire[31:0] io_in_memory_csr_result,
  input wire[4:0] io_in_writeback_dest,
  input wire[1:0] io_in_writeback_wb,
  input wire[31:0] io_in_writeback_alu_result,
  input wire[31:0] io_in_writeback_mem_data,
  input wire[31:0] io_in_writeback_PC_next,
  output wire io_out_src1_fwd,
  output wire io_out_src2_fwd,
  output wire io_out_csr_fwd,
  output wire[31:0] io_out_src1_fwd_data,
  output wire[31:0] io_out_src2_fwd_data,
  output wire[31:0] io_out_csr_fwd_data,
  output wire io_out_fwd_stall
);
  wire[31:0] sel_2011, sel_2012, sel_2013, sel_2014, sel_2015, sel_2016, sel_2017, sel_2018, sel_2022, sel_2025, sel_2027, sel_2029, sel_2030;
  wire op_eq_1919, op_eq_1921, op_eq_1923, op_eq_1926, op_eq_1928, op_eq_1930, op_eq_1933, op_eq_1935, op_ne_1938, op_ne_1941, op_eq_1942, op_andl_1943, op_andl_1944, op_notl_1945, op_ne_1947, op_eq_1950, op_andl_1951, op_andl_1952, op_andl_1953, op_notl_1954, op_ne_1957, op_eq_1960, op_andl_1961, op_andl_1962, op_andl_1963, op_andl_1964, op_orl_1965, op_orl_1966, op_ne_1970, op_eq_1971, op_andl_1972, op_andl_1973, op_notl_1974, op_eq_1979, op_andl_1980, op_andl_1981, op_andl_1982, op_notl_1983, op_eq_1989, op_andl_1990, op_andl_1991, op_andl_1992, op_andl_1993, op_orl_1994, op_orl_1995, op_eq_1996, op_andl_1997, op_notl_1998, op_eq_1999, op_andl_2000, op_andl_2001, op_orl_2002, op_orl_2006, op_andl_2007;

  assign sel_2011 = op_eq_1923 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel_2012 = op_eq_1930 ? io_in_writeback_PC_next : sel_2011;
  assign sel_2013 = op_andl_1964 ? sel_2012 : 32'h7b;
  assign sel_2014 = op_eq_1921 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel_2015 = op_eq_1928 ? io_in_memory_PC_next : sel_2014;
  assign sel_2016 = op_andl_1953 ? sel_2015 : sel_2013;
  assign sel_2017 = op_eq_1926 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel_2018 = op_andl_1944 ? sel_2017 : sel_2016;
  assign sel_2022 = op_andl_1993 ? sel_2012 : 32'h7b;
  assign sel_2025 = op_andl_1982 ? sel_2015 : sel_2022;
  assign sel_2027 = op_andl_1973 ? sel_2017 : sel_2025;
  assign sel_2029 = op_andl_2001 ? io_in_memory_csr_result : 32'h7b;
  assign sel_2030 = op_andl_1997 ? io_in_execute_alu_result : sel_2029;
  assign op_eq_1919 = io_in_execute_wb == 2'h2;
  assign op_eq_1921 = io_in_memory_wb == 2'h2;
  assign op_eq_1923 = io_in_writeback_wb == 2'h2;
  assign op_eq_1926 = io_in_execute_wb == 2'h3;
  assign op_eq_1928 = io_in_memory_wb == 2'h3;
  assign op_eq_1930 = io_in_writeback_wb == 2'h3;
  assign op_eq_1933 = io_in_execute_is_csr == 1'h1;
  assign op_eq_1935 = io_in_memory_is_csr == 1'h1;
  assign op_ne_1938 = io_in_execute_wb != 2'h0;
  assign op_ne_1941 = io_in_decode_src1 != 5'h0;
  assign op_eq_1942 = io_in_decode_src1 == io_in_execute_dest;
  assign op_andl_1943 = op_eq_1942 && op_ne_1941;
  assign op_andl_1944 = op_andl_1943 && op_ne_1938;
  assign op_notl_1945 = !op_andl_1944;
  assign op_ne_1947 = io_in_memory_wb != 2'h0;
  assign op_eq_1950 = io_in_decode_src1 == io_in_memory_dest;
  assign op_andl_1951 = op_eq_1950 && op_ne_1941;
  assign op_andl_1952 = op_andl_1951 && op_ne_1947;
  assign op_andl_1953 = op_andl_1952 && op_notl_1945;
  assign op_notl_1954 = !op_andl_1953;
  assign op_ne_1957 = io_in_writeback_wb != 2'h0;
  assign op_eq_1960 = io_in_decode_src1 == io_in_writeback_dest;
  assign op_andl_1961 = op_eq_1960 && op_ne_1941;
  assign op_andl_1962 = op_andl_1961 && op_ne_1957;
  assign op_andl_1963 = op_andl_1962 && op_notl_1945;
  assign op_andl_1964 = op_andl_1963 && op_notl_1954;
  assign op_orl_1965 = op_andl_1944 || op_andl_1953;
  assign op_orl_1966 = op_orl_1965 || op_andl_1964;
  assign op_ne_1970 = io_in_decode_src2 != 5'h0;
  assign op_eq_1971 = io_in_decode_src2 == io_in_execute_dest;
  assign op_andl_1972 = op_eq_1971 && op_ne_1970;
  assign op_andl_1973 = op_andl_1972 && op_ne_1938;
  assign op_notl_1974 = !op_andl_1973;
  assign op_eq_1979 = io_in_decode_src2 == io_in_memory_dest;
  assign op_andl_1980 = op_eq_1979 && op_ne_1970;
  assign op_andl_1981 = op_andl_1980 && op_ne_1947;
  assign op_andl_1982 = op_andl_1981 && op_notl_1974;
  assign op_notl_1983 = !op_andl_1982;
  assign op_eq_1989 = io_in_decode_src2 == io_in_writeback_dest;
  assign op_andl_1990 = op_eq_1989 && op_ne_1970;
  assign op_andl_1991 = op_andl_1990 && op_ne_1957;
  assign op_andl_1992 = op_andl_1991 && op_notl_1974;
  assign op_andl_1993 = op_andl_1992 && op_notl_1983;
  assign op_orl_1994 = op_andl_1973 || op_andl_1982;
  assign op_orl_1995 = op_orl_1994 || op_andl_1993;
  assign op_eq_1996 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign op_andl_1997 = op_eq_1996 && op_eq_1933;
  assign op_notl_1998 = !op_andl_1997;
  assign op_eq_1999 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign op_andl_2000 = op_eq_1999 && op_eq_1935;
  assign op_andl_2001 = op_andl_2000 && op_notl_1998;
  assign op_orl_2002 = op_andl_1997 || op_andl_2001;
  assign op_orl_2006 = op_andl_1944 || op_andl_1973;
  assign op_andl_2007 = op_orl_2006 && op_eq_1919;

  assign io_out_src1_fwd = op_orl_1966;
  assign io_out_src2_fwd = op_orl_1995;
  assign io_out_csr_fwd = op_orl_2002;
  assign io_out_src1_fwd_data = sel_2018;
  assign io_out_src2_fwd_data = sel_2027;
  assign io_out_csr_fwd_data = sel_2030;
  assign io_out_fwd_stall = op_andl_2007;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem_ch_bit_32u_2101 [0:1];
  wire[31:0] marport_ch_bit_32u_2103, sel_2106;

  initial begin
    mem_ch_bit_32u_2101[0] = 32'h70000000;
    mem_ch_bit_32u_2101[1] = 32'hdeadbeef;
  end
  assign marport_ch_bit_32u_2103 = mem_ch_bit_32u_2101[io_INTERRUPT_in_interrupt_id_data];
  assign sel_2106 = io_INTERRUPT_in_interrupt_id_valid ? marport_ch_bit_32u_2103 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = 1'h1;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel_2106;

endmodule

module TAP(
  input wire clk,
  input wire reset,
  input wire io_JTAG_TAP_in_mode_select_data,
  input wire io_JTAG_TAP_in_mode_select_valid,
  output wire io_JTAG_TAP_in_mode_select_ready,
  input wire io_JTAG_TAP_in_clock_data,
  input wire io_JTAG_TAP_in_clock_valid,
  output wire io_JTAG_TAP_in_clock_ready,
  input wire io_JTAG_TAP_in_reset_data,
  input wire io_JTAG_TAP_in_reset_valid,
  output wire io_JTAG_TAP_in_reset_ready,
  output wire[3:0] io_out_curr_state
);
  reg[3:0] reg_ch_bit_4u_2160, sel_2228;
  wire[3:0] sel_2168, sel_2172, sel_2177, sel_2182, sel_2190, sel_2194, sel_2197, sel_2204, sel_2209, sel_2217, sel_2221, sel_2224, sel_2229, sel_2237, sel_2238, sel_2240;
  wire op_eq_2163, op_andl_2230, op_eq_2232, op_andl_2234, op_eq_2236, op_andb_2241;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_4u_2160 <= 4'h0;
    else
      reg_ch_bit_4u_2160 <= sel_2240;
  end
  assign sel_2168 = op_eq_2163 ? 4'h0 : 4'h1;
  assign sel_2172 = op_eq_2163 ? 4'h2 : 4'h1;
  assign sel_2177 = op_eq_2163 ? 4'h9 : 4'h3;
  assign sel_2182 = op_eq_2163 ? 4'h5 : 4'h4;
  assign sel_2190 = op_eq_2163 ? 4'h8 : 4'h6;
  assign sel_2194 = op_eq_2163 ? 4'h7 : 4'h6;
  assign sel_2197 = op_eq_2163 ? 4'h4 : 4'h8;
  assign sel_2204 = op_eq_2163 ? 4'h0 : 4'ha;
  assign sel_2209 = op_eq_2163 ? 4'hc : 4'hb;
  assign sel_2217 = op_eq_2163 ? 4'hf : 4'hd;
  assign sel_2221 = op_eq_2163 ? 4'he : 4'hd;
  assign sel_2224 = op_eq_2163 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg_ch_bit_4u_2160)
      4'h0: sel_2228 = sel_2168;
      4'h1: sel_2228 = sel_2172;
      4'h2: sel_2228 = sel_2177;
      4'h3: sel_2228 = sel_2182;
      4'h4: sel_2228 = sel_2182;
      4'h5: sel_2228 = sel_2190;
      4'h6: sel_2228 = sel_2194;
      4'h7: sel_2228 = sel_2197;
      4'h8: sel_2228 = sel_2172;
      4'h9: sel_2228 = sel_2204;
      4'ha: sel_2228 = sel_2209;
      4'hb: sel_2228 = sel_2209;
      4'hc: sel_2228 = sel_2217;
      4'hd: sel_2228 = sel_2221;
      4'he: sel_2228 = sel_2224;
      4'hf: sel_2228 = sel_2172;
      default: sel_2228 = reg_ch_bit_4u_2160;
    endcase
  end
  assign sel_2229 = io_JTAG_TAP_in_mode_select_valid ? sel_2228 : 4'h0;
  assign sel_2237 = op_eq_2232 ? 4'h0 : reg_ch_bit_4u_2160;
  assign sel_2238 = op_andb_2241 ? sel_2229 : reg_ch_bit_4u_2160;
  assign sel_2240 = op_andl_2230 ? sel_2237 : sel_2238;
  assign op_eq_2163 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign op_andl_2230 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_reset_valid;
  assign op_eq_2232 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign op_andl_2234 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_clock_valid;
  assign op_eq_2236 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign op_andb_2241 = op_andl_2234 & op_eq_2236;

  assign io_JTAG_TAP_in_mode_select_ready = 1'h1;
  assign io_JTAG_TAP_in_clock_ready = 1'h1;
  assign io_JTAG_TAP_in_reset_ready = 1'h1;
  assign io_out_curr_state = reg_ch_bit_4u_2160;

endmodule

module JTAG(
  input wire clk,
  input wire reset,
  input wire io_JTAG_JTAG_TAP_in_mode_select_data,
  input wire io_JTAG_JTAG_TAP_in_mode_select_valid,
  output wire io_JTAG_JTAG_TAP_in_mode_select_ready,
  input wire io_JTAG_JTAG_TAP_in_clock_data,
  input wire io_JTAG_JTAG_TAP_in_clock_valid,
  output wire io_JTAG_JTAG_TAP_in_clock_ready,
  input wire io_JTAG_JTAG_TAP_in_reset_data,
  input wire io_JTAG_JTAG_TAP_in_reset_valid,
  output wire io_JTAG_JTAG_TAP_in_reset_ready,
  input wire io_JTAG_in_data_data,
  input wire io_JTAG_in_data_valid,
  output wire io_JTAG_in_data_ready,
  output wire io_JTAG_out_data_data,
  output wire io_JTAG_out_data_valid,
  input wire io_JTAG_out_data_ready
);
  reg[31:0] reg_ch_bit_32u_2271, reg_ch_bit_32u_2275, reg_ch_bit_32u_2279, reg_ch_bit_32u_2284, sel_2337;
  wire[30:0] proxy_slice_2302;
  wire[31:0] proxy_cat_2303, sel_2296, sel_2297, sel_2340, sel_2341, op_shr_2301;
  wire sel_2330, op_eq_2287, op_eq_2291, op_eq_2294, op_eq_2308, op_eq_2343, op_eq_2344, op_eq_2345, op_andb_2346, TAP_2242_clk, TAP_2242_reset, TAP_2242_io_JTAG_TAP_in_mode_select_data, TAP_2242_io_JTAG_TAP_in_mode_select_valid, TAP_2242_io_JTAG_TAP_in_mode_select_ready, TAP_2242_io_JTAG_TAP_in_clock_data, TAP_2242_io_JTAG_TAP_in_clock_valid, TAP_2242_io_JTAG_TAP_in_clock_ready, TAP_2242_io_JTAG_TAP_in_reset_data, TAP_2242_io_JTAG_TAP_in_reset_valid, TAP_2242_io_JTAG_TAP_in_reset_ready;
  reg sel_2336;
  wire[3:0] TAP_2242_io_out_curr_state;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2271 <= 32'h0;
    else
    if (op_eq_2343)
      reg_ch_bit_32u_2271 <= reg_ch_bit_32u_2284;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2275 <= 32'h1234;
    else
    if (op_eq_2345)
      reg_ch_bit_32u_2275 <= sel_2341;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2279 <= 32'h5678;
    else
    if (op_andb_2346)
      reg_ch_bit_32u_2279 <= reg_ch_bit_32u_2284;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2284 <= 32'h0;
    else
      reg_ch_bit_32u_2284 <= sel_2337;
  end
  assign proxy_slice_2302 = op_shr_2301[30:0];
  assign proxy_cat_2303 = {io_JTAG_in_data_data, proxy_slice_2302};
  assign sel_2296 = op_eq_2294 ? reg_ch_bit_32u_2275 : 32'hdeadbeef;
  assign sel_2297 = op_eq_2291 ? reg_ch_bit_32u_2279 : sel_2296;
  assign sel_2330 = op_eq_2344 ? reg_ch_bit_32u_2284[0] : 1'h0;
  always @(*) begin
    case (TAP_2242_io_out_curr_state)
      4'h4: sel_2336 = 1'h1;
      4'hb: sel_2336 = 1'h1;
      default: sel_2336 = op_eq_2287;
    endcase
  end
  always @(*) begin
    case (TAP_2242_io_out_curr_state)
      4'h3: sel_2337 = sel_2297;
      4'h4: sel_2337 = proxy_cat_2303;
      4'ha: sel_2337 = reg_ch_bit_32u_2271;
      4'hb: sel_2337 = proxy_cat_2303;
      default: sel_2337 = reg_ch_bit_32u_2284;
    endcase
  end
  assign sel_2340 = op_eq_2294 ? reg_ch_bit_32u_2284 : reg_ch_bit_32u_2275;
  assign sel_2341 = op_eq_2308 ? reg_ch_bit_32u_2275 : sel_2340;
  assign op_eq_2287 = reg_ch_bit_32u_2271 == 32'h0;
  assign op_eq_2291 = reg_ch_bit_32u_2271 == 32'h1;
  assign op_eq_2294 = reg_ch_bit_32u_2271 == 32'h2;
  assign op_shr_2301 = reg_ch_bit_32u_2284 >> 32'h1;
  assign op_eq_2308 = reg_ch_bit_32u_2271 == 32'h1;
  assign op_eq_2343 = TAP_2242_io_out_curr_state == 4'hf;
  assign op_eq_2344 = TAP_2242_io_out_curr_state == 4'h4;
  assign op_eq_2345 = TAP_2242_io_out_curr_state == 4'h8;
  assign op_andb_2346 = op_eq_2345 & op_eq_2308;
  TAP TAP_2242(
    .io_JTAG_TAP_in_mode_select_data(TAP_2242_io_JTAG_TAP_in_mode_select_data),
    .io_JTAG_TAP_in_mode_select_valid(TAP_2242_io_JTAG_TAP_in_mode_select_valid),
    .io_JTAG_TAP_in_clock_data(TAP_2242_io_JTAG_TAP_in_clock_data),
    .io_JTAG_TAP_in_clock_valid(TAP_2242_io_JTAG_TAP_in_clock_valid),
    .io_JTAG_TAP_in_reset_data(TAP_2242_io_JTAG_TAP_in_reset_data),
    .io_JTAG_TAP_in_reset_valid(TAP_2242_io_JTAG_TAP_in_reset_valid),
    .clk(TAP_2242_clk),
    .reset(TAP_2242_reset),
    .io_JTAG_TAP_in_mode_select_ready(TAP_2242_io_JTAG_TAP_in_mode_select_ready),
    .io_JTAG_TAP_in_clock_ready(TAP_2242_io_JTAG_TAP_in_clock_ready),
    .io_JTAG_TAP_in_reset_ready(TAP_2242_io_JTAG_TAP_in_reset_ready),
    .io_out_curr_state(TAP_2242_io_out_curr_state));
  assign TAP_2242_clk = clk;
  assign TAP_2242_reset = reset;
  assign TAP_2242_io_JTAG_TAP_in_mode_select_data = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign TAP_2242_io_JTAG_TAP_in_mode_select_valid = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign TAP_2242_io_JTAG_TAP_in_clock_data = io_JTAG_JTAG_TAP_in_clock_data;
  assign TAP_2242_io_JTAG_TAP_in_clock_valid = io_JTAG_JTAG_TAP_in_clock_valid;
  assign TAP_2242_io_JTAG_TAP_in_reset_data = io_JTAG_JTAG_TAP_in_reset_data;
  assign TAP_2242_io_JTAG_TAP_in_reset_valid = io_JTAG_JTAG_TAP_in_reset_valid;

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = TAP_2242_io_JTAG_TAP_in_mode_select_ready;
  assign io_JTAG_JTAG_TAP_in_clock_ready = TAP_2242_io_JTAG_TAP_in_clock_ready;
  assign io_JTAG_JTAG_TAP_in_reset_ready = TAP_2242_io_JTAG_TAP_in_reset_ready;
  assign io_JTAG_in_data_ready = 1'h1;
  assign io_JTAG_out_data_data = sel_2330;
  assign io_JTAG_out_data_valid = sel_2336;

endmodule

module CSR_Handler(
  input wire clk,
  input wire reset,
  input wire[11:0] io_in_decode_csr_address,
  input wire[11:0] io_in_mem_csr_address,
  input wire io_in_mem_is_csr,
  input wire[31:0] io_in_mem_csr_result,
  output wire[31:0] io_out_decode_csr_data
);
  reg[11:0] mem_ch_bit_12u_2387 [0:4095], reg_ch_bit_12u_2406;
  wire[11:0] marport_ch_bit_12u_2426;
  reg[63:0] reg_ch_uint_64u_2394, reg_ch_uint_64u_2397;
  wire[31:0] sel_2433, sel_2435, sel_2439, sel_2441, op_pad_2428;
  wire[63:0] op_add_2400, op_add_2402, op_shr_2431, op_shr_2437;
  wire op_eq_2415, op_eq_2418, op_eq_2421, op_eq_2424;

  assign marport_ch_bit_12u_2426 = mem_ch_bit_12u_2387[reg_ch_bit_12u_2406];
  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem_ch_bit_12u_2387[io_in_mem_csr_address] <= io_in_mem_csr_result[11:0];
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_uint_64u_2394 <= 64'h0;
    else
      reg_ch_uint_64u_2394 <= op_add_2400;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_uint_64u_2397 <= 64'h0;
    else
      reg_ch_uint_64u_2397 <= op_add_2402;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_2406 <= 12'h0;
    else
      reg_ch_bit_12u_2406 <= io_in_decode_csr_address;
  end
  assign sel_2433 = op_eq_2424 ? op_shr_2431[31:0] : op_pad_2428;
  assign sel_2435 = op_eq_2421 ? reg_ch_uint_64u_2397[31:0] : sel_2433;
  assign sel_2439 = op_eq_2418 ? op_shr_2437[31:0] : sel_2435;
  assign sel_2441 = op_eq_2415 ? reg_ch_uint_64u_2394[31:0] : sel_2439;
  assign op_add_2400 = reg_ch_uint_64u_2394 + 64'h1;
  assign op_add_2402 = reg_ch_uint_64u_2397 + 64'h1;
  assign op_eq_2415 = reg_ch_bit_12u_2406 == 12'hc00;
  assign op_eq_2418 = reg_ch_bit_12u_2406 == 12'hc80;
  assign op_eq_2421 = reg_ch_bit_12u_2406 == 12'hc02;
  assign op_eq_2424 = reg_ch_bit_12u_2406 == 12'hc82;
  assign op_pad_2428 = {{20{1'b0}}, marport_ch_bit_12u_2426};
  assign op_shr_2431 = reg_ch_uint_64u_2397 >> 32'h20;
  assign op_shr_2437 = reg_ch_uint_64u_2394 >> 32'h20;

  assign io_out_decode_csr_data = sel_2441;

endmodule

module Pipeline(
  input wire clk,
  input wire reset,
  input wire[31:0] io_IBUS_in_data_data,
  input wire io_IBUS_in_data_valid,
  output wire io_IBUS_in_data_ready,
  output wire[31:0] io_IBUS_out_address_data,
  output wire io_IBUS_out_address_valid,
  input wire io_IBUS_out_address_ready,
  output wire io_DBUS_out_miss,
  output wire io_DBUS_out_rw,
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[2:0] io_DBUS_out_control_data,
  output wire io_DBUS_out_control_valid,
  input wire io_DBUS_out_control_ready,
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  input wire io_jtag_JTAG_TAP_in_mode_select_data,
  input wire io_jtag_JTAG_TAP_in_mode_select_valid,
  output wire io_jtag_JTAG_TAP_in_mode_select_ready,
  input wire io_jtag_JTAG_TAP_in_clock_data,
  input wire io_jtag_JTAG_TAP_in_clock_valid,
  output wire io_jtag_JTAG_TAP_in_clock_ready,
  input wire io_jtag_JTAG_TAP_in_reset_data,
  input wire io_jtag_JTAG_TAP_in_reset_valid,
  output wire io_jtag_JTAG_TAP_in_reset_ready,
  input wire io_jtag_in_data_data,
  input wire io_jtag_in_data_valid,
  output wire io_jtag_in_data_ready,
  output wire io_jtag_out_data_data,
  output wire io_jtag_out_data_valid,
  input wire io_jtag_out_data_ready,
  input wire io_in_debug,
  output wire io_out_fwd_stall,
  output wire io_out_branch_stall
);
  wire op_orl_2455, op_eq_2459, Fetch_222_clk, Fetch_222_reset, Fetch_222_io_IBUS_in_data_valid, Fetch_222_io_IBUS_in_data_ready, Fetch_222_io_IBUS_out_address_valid, Fetch_222_io_IBUS_out_address_ready, Fetch_222_io_in_branch_dir, Fetch_222_io_in_freeze, Fetch_222_io_in_branch_stall, Fetch_222_io_in_fwd_stall, Fetch_222_io_in_branch_stall_exe, Fetch_222_io_in_jal, Fetch_222_io_in_interrupt, Fetch_222_io_in_debug, F_D_Register_301_clk, F_D_Register_301_reset, F_D_Register_301_io_in_branch_stall, F_D_Register_301_io_in_branch_stall_exe, F_D_Register_301_io_in_fwd_stall, Decode_769_clk, Decode_769_io_in_stall, Decode_769_io_in_src1_fwd, Decode_769_io_in_src2_fwd, Decode_769_io_in_csr_fwd, Decode_769_io_out_is_csr, Decode_769_io_out_rs2_src, Decode_769_io_out_branch_stall, Decode_769_io_out_jal, D_E_Register_1017_clk, D_E_Register_1017_reset, D_E_Register_1017_io_in_rs2_src, D_E_Register_1017_io_in_fwd_stall, D_E_Register_1017_io_in_branch_stall, D_E_Register_1017_io_in_is_csr, D_E_Register_1017_io_in_jal, D_E_Register_1017_io_out_is_csr, D_E_Register_1017_io_out_rs2_src, D_E_Register_1017_io_out_jal, Execute_1239_io_in_rs2_src, Execute_1239_io_in_is_csr, Execute_1239_io_in_jal, Execute_1239_io_out_is_csr, Execute_1239_io_out_jal, Execute_1239_io_out_branch_stall, E_M_Register_1422_clk, E_M_Register_1422_reset, E_M_Register_1422_io_in_is_csr, E_M_Register_1422_io_out_is_csr, Memory_1684_io_DBUS_out_miss, Memory_1684_io_DBUS_out_rw, Memory_1684_io_DBUS_in_data_valid, Memory_1684_io_DBUS_in_data_ready, Memory_1684_io_DBUS_out_data_valid, Memory_1684_io_DBUS_out_data_ready, Memory_1684_io_DBUS_out_address_valid, Memory_1684_io_DBUS_out_address_ready, Memory_1684_io_DBUS_out_control_valid, Memory_1684_io_DBUS_out_control_ready, Memory_1684_io_out_branch_dir, M_W_Register_1807_clk, M_W_Register_1807_reset, Forwarding_2031_io_in_execute_is_csr, Forwarding_2031_io_in_memory_is_csr, Forwarding_2031_io_out_src1_fwd, Forwarding_2031_io_out_src2_fwd, Forwarding_2031_io_out_csr_fwd, Forwarding_2031_io_out_fwd_stall, Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_data, Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_valid, Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_ready, Interrupt_Handler_2107_io_out_interrupt, JTAG_2348_clk, JTAG_2348_reset, JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_data, JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_valid, JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_ready, JTAG_2348_io_JTAG_JTAG_TAP_in_clock_data, JTAG_2348_io_JTAG_JTAG_TAP_in_clock_valid, JTAG_2348_io_JTAG_JTAG_TAP_in_clock_ready, JTAG_2348_io_JTAG_JTAG_TAP_in_reset_data, JTAG_2348_io_JTAG_JTAG_TAP_in_reset_valid, JTAG_2348_io_JTAG_JTAG_TAP_in_reset_ready, JTAG_2348_io_JTAG_in_data_data, JTAG_2348_io_JTAG_in_data_valid, JTAG_2348_io_JTAG_in_data_ready, JTAG_2348_io_JTAG_out_data_data, JTAG_2348_io_JTAG_out_data_valid, JTAG_2348_io_JTAG_out_data_ready, CSR_Handler_2442_clk, CSR_Handler_2442_reset, CSR_Handler_2442_io_in_mem_is_csr;
  wire[31:0] Fetch_222_io_IBUS_in_data_data, Fetch_222_io_IBUS_out_address_data, Fetch_222_io_in_branch_dest, Fetch_222_io_in_jal_dest, Fetch_222_io_in_interrupt_pc, Fetch_222_io_out_instruction, Fetch_222_io_out_curr_PC, F_D_Register_301_io_in_instruction, F_D_Register_301_io_in_curr_PC, F_D_Register_301_io_out_instruction, F_D_Register_301_io_out_curr_PC, Decode_769_io_in_instruction, Decode_769_io_in_curr_PC, Decode_769_io_in_write_data, Decode_769_io_in_src1_fwd_data, Decode_769_io_in_src2_fwd_data, Decode_769_io_in_csr_fwd_data, Decode_769_io_out_csr_mask, Decode_769_io_out_rd1, Decode_769_io_out_rd2, Decode_769_io_out_itype_immed, Decode_769_io_out_jal_offset, Decode_769_io_out_PC_next, D_E_Register_1017_io_in_rd1, D_E_Register_1017_io_in_rd2, D_E_Register_1017_io_in_itype_immed, D_E_Register_1017_io_in_PC_next, D_E_Register_1017_io_in_csr_mask, D_E_Register_1017_io_in_curr_PC, D_E_Register_1017_io_in_jal_offset, D_E_Register_1017_io_out_csr_mask, D_E_Register_1017_io_out_rd1, D_E_Register_1017_io_out_rd2, D_E_Register_1017_io_out_itype_immed, D_E_Register_1017_io_out_curr_PC, D_E_Register_1017_io_out_jal_offset, D_E_Register_1017_io_out_PC_next, Execute_1239_io_in_rd1, Execute_1239_io_in_rd2, Execute_1239_io_in_itype_immed, Execute_1239_io_in_PC_next, Execute_1239_io_in_csr_data, Execute_1239_io_in_csr_mask, Execute_1239_io_in_jal_offset, Execute_1239_io_in_curr_PC, Execute_1239_io_out_csr_result, Execute_1239_io_out_alu_result, Execute_1239_io_out_rd1, Execute_1239_io_out_rd2, Execute_1239_io_out_jal_dest, Execute_1239_io_out_branch_offset, Execute_1239_io_out_PC_next, E_M_Register_1422_io_in_alu_result, E_M_Register_1422_io_in_rd1, E_M_Register_1422_io_in_rd2, E_M_Register_1422_io_in_PC_next, E_M_Register_1422_io_in_csr_result, E_M_Register_1422_io_in_curr_PC, E_M_Register_1422_io_in_branch_offset, E_M_Register_1422_io_out_csr_result, E_M_Register_1422_io_out_alu_result, E_M_Register_1422_io_out_rd1, E_M_Register_1422_io_out_rd2, E_M_Register_1422_io_out_curr_PC, E_M_Register_1422_io_out_branch_offset, E_M_Register_1422_io_out_PC_next, Memory_1684_io_DBUS_in_data_data, Memory_1684_io_DBUS_out_data_data, Memory_1684_io_DBUS_out_address_data, Memory_1684_io_in_alu_result, Memory_1684_io_in_rd1, Memory_1684_io_in_rd2, Memory_1684_io_in_PC_next, Memory_1684_io_in_curr_PC, Memory_1684_io_in_branch_offset, Memory_1684_io_out_alu_result, Memory_1684_io_out_mem_result, Memory_1684_io_out_branch_dest, Memory_1684_io_out_PC_next, M_W_Register_1807_io_in_alu_result, M_W_Register_1807_io_in_mem_result, M_W_Register_1807_io_in_PC_next, M_W_Register_1807_io_out_alu_result, M_W_Register_1807_io_out_mem_result, M_W_Register_1807_io_out_PC_next, Write_Back_1859_io_in_alu_result, Write_Back_1859_io_in_mem_result, Write_Back_1859_io_in_PC_next, Write_Back_1859_io_out_write_data, Forwarding_2031_io_in_execute_alu_result, Forwarding_2031_io_in_execute_PC_next, Forwarding_2031_io_in_execute_csr_result, Forwarding_2031_io_in_memory_alu_result, Forwarding_2031_io_in_memory_mem_data, Forwarding_2031_io_in_memory_PC_next, Forwarding_2031_io_in_memory_csr_result, Forwarding_2031_io_in_writeback_alu_result, Forwarding_2031_io_in_writeback_mem_data, Forwarding_2031_io_in_writeback_PC_next, Forwarding_2031_io_out_src1_fwd_data, Forwarding_2031_io_out_src2_fwd_data, Forwarding_2031_io_out_csr_fwd_data, Interrupt_Handler_2107_io_out_interrupt_pc, CSR_Handler_2442_io_in_mem_csr_result, CSR_Handler_2442_io_out_decode_csr_data;
  wire[4:0] Decode_769_io_in_rd, Decode_769_io_out_rd, Decode_769_io_out_rs1, Decode_769_io_out_rs2, D_E_Register_1017_io_in_rd, D_E_Register_1017_io_in_rs1, D_E_Register_1017_io_in_rs2, D_E_Register_1017_io_out_rd, D_E_Register_1017_io_out_rs1, D_E_Register_1017_io_out_rs2, Execute_1239_io_in_rd, Execute_1239_io_in_rs1, Execute_1239_io_in_rs2, Execute_1239_io_out_rd, Execute_1239_io_out_rs1, Execute_1239_io_out_rs2, E_M_Register_1422_io_in_rd, E_M_Register_1422_io_in_rs1, E_M_Register_1422_io_in_rs2, E_M_Register_1422_io_out_rd, E_M_Register_1422_io_out_rs1, E_M_Register_1422_io_out_rs2, Memory_1684_io_in_rd, Memory_1684_io_in_rs1, Memory_1684_io_in_rs2, Memory_1684_io_out_rd, Memory_1684_io_out_rs1, Memory_1684_io_out_rs2, M_W_Register_1807_io_in_rd, M_W_Register_1807_io_in_rs1, M_W_Register_1807_io_in_rs2, M_W_Register_1807_io_out_rd, M_W_Register_1807_io_out_rs1, M_W_Register_1807_io_out_rs2, Write_Back_1859_io_in_rd, Write_Back_1859_io_in_rs1, Write_Back_1859_io_in_rs2, Write_Back_1859_io_out_rd, Forwarding_2031_io_in_decode_src1, Forwarding_2031_io_in_decode_src2, Forwarding_2031_io_in_execute_dest, Forwarding_2031_io_in_memory_dest, Forwarding_2031_io_in_writeback_dest;
  wire[1:0] Decode_769_io_in_wb, Decode_769_io_out_wb, D_E_Register_1017_io_in_wb, D_E_Register_1017_io_out_wb, Execute_1239_io_in_wb, Execute_1239_io_out_wb, E_M_Register_1422_io_in_wb, E_M_Register_1422_io_out_wb, Memory_1684_io_in_wb, Memory_1684_io_out_wb, M_W_Register_1807_io_in_wb, M_W_Register_1807_io_out_wb, Write_Back_1859_io_in_wb, Write_Back_1859_io_out_wb, Forwarding_2031_io_in_execute_wb, Forwarding_2031_io_in_memory_wb, Forwarding_2031_io_in_writeback_wb;
  wire[11:0] Decode_769_io_out_csr_address, D_E_Register_1017_io_in_csr_address, D_E_Register_1017_io_out_csr_address, Execute_1239_io_in_csr_address, Execute_1239_io_out_csr_address, E_M_Register_1422_io_in_csr_address, E_M_Register_1422_io_out_csr_address, Forwarding_2031_io_in_decode_csr_address, Forwarding_2031_io_in_execute_csr_address, Forwarding_2031_io_in_memory_csr_address, CSR_Handler_2442_io_in_decode_csr_address, CSR_Handler_2442_io_in_mem_csr_address;
  wire[3:0] Decode_769_io_out_alu_op, D_E_Register_1017_io_in_alu_op, D_E_Register_1017_io_out_alu_op, Execute_1239_io_in_alu_op;
  wire[2:0] Decode_769_io_out_mem_read, Decode_769_io_out_mem_write, Decode_769_io_out_branch_type, D_E_Register_1017_io_in_mem_read, D_E_Register_1017_io_in_mem_write, D_E_Register_1017_io_in_branch_type, D_E_Register_1017_io_out_mem_read, D_E_Register_1017_io_out_mem_write, D_E_Register_1017_io_out_branch_type, Execute_1239_io_in_mem_read, Execute_1239_io_in_mem_write, Execute_1239_io_in_branch_type, Execute_1239_io_out_mem_read, Execute_1239_io_out_mem_write, E_M_Register_1422_io_in_mem_read, E_M_Register_1422_io_in_mem_write, E_M_Register_1422_io_in_branch_type, E_M_Register_1422_io_out_mem_read, E_M_Register_1422_io_out_mem_write, E_M_Register_1422_io_out_branch_type, Memory_1684_io_DBUS_out_control_data, Memory_1684_io_in_mem_read, Memory_1684_io_in_mem_write, Memory_1684_io_in_branch_type;
  wire[19:0] Decode_769_io_out_upper_immed, D_E_Register_1017_io_in_upper_immed, D_E_Register_1017_io_out_upper_immed, Execute_1239_io_in_upper_immed;

  assign op_orl_2455 = Decode_769_io_out_branch_stall || Execute_1239_io_out_branch_stall;
  assign op_eq_2459 = Execute_1239_io_out_branch_stall == 1'h1;
  Fetch Fetch_222(
    .io_IBUS_in_data_data(Fetch_222_io_IBUS_in_data_data),
    .io_IBUS_in_data_valid(Fetch_222_io_IBUS_in_data_valid),
    .io_IBUS_out_address_ready(Fetch_222_io_IBUS_out_address_ready),
    .io_in_branch_dir(Fetch_222_io_in_branch_dir),
    .io_in_freeze(Fetch_222_io_in_freeze),
    .io_in_branch_dest(Fetch_222_io_in_branch_dest),
    .io_in_branch_stall(Fetch_222_io_in_branch_stall),
    .io_in_fwd_stall(Fetch_222_io_in_fwd_stall),
    .io_in_branch_stall_exe(Fetch_222_io_in_branch_stall_exe),
    .io_in_jal(Fetch_222_io_in_jal),
    .io_in_jal_dest(Fetch_222_io_in_jal_dest),
    .io_in_interrupt(Fetch_222_io_in_interrupt),
    .io_in_interrupt_pc(Fetch_222_io_in_interrupt_pc),
    .io_in_debug(Fetch_222_io_in_debug),
    .clk(Fetch_222_clk),
    .reset(Fetch_222_reset),
    .io_IBUS_in_data_ready(Fetch_222_io_IBUS_in_data_ready),
    .io_IBUS_out_address_data(Fetch_222_io_IBUS_out_address_data),
    .io_IBUS_out_address_valid(Fetch_222_io_IBUS_out_address_valid),
    .io_out_instruction(Fetch_222_io_out_instruction),
    .io_out_delay(),
    .io_out_curr_PC(Fetch_222_io_out_curr_PC));
  F_D_Register F_D_Register_301(
    .io_in_instruction(F_D_Register_301_io_in_instruction),
    .io_in_curr_PC(F_D_Register_301_io_in_curr_PC),
    .io_in_branch_stall(F_D_Register_301_io_in_branch_stall),
    .io_in_branch_stall_exe(F_D_Register_301_io_in_branch_stall_exe),
    .io_in_fwd_stall(F_D_Register_301_io_in_fwd_stall),
    .clk(F_D_Register_301_clk),
    .reset(F_D_Register_301_reset),
    .io_out_instruction(F_D_Register_301_io_out_instruction),
    .io_out_curr_PC(F_D_Register_301_io_out_curr_PC));
  Decode Decode_769(
    .io_in_instruction(Decode_769_io_in_instruction),
    .io_in_curr_PC(Decode_769_io_in_curr_PC),
    .io_in_stall(Decode_769_io_in_stall),
    .io_in_write_data(Decode_769_io_in_write_data),
    .io_in_rd(Decode_769_io_in_rd),
    .io_in_wb(Decode_769_io_in_wb),
    .io_in_src1_fwd(Decode_769_io_in_src1_fwd),
    .io_in_src1_fwd_data(Decode_769_io_in_src1_fwd_data),
    .io_in_src2_fwd(Decode_769_io_in_src2_fwd),
    .io_in_src2_fwd_data(Decode_769_io_in_src2_fwd_data),
    .io_in_csr_fwd(Decode_769_io_in_csr_fwd),
    .io_in_csr_fwd_data(Decode_769_io_in_csr_fwd_data),
    .clk(Decode_769_clk),
    .io_out_csr_address(Decode_769_io_out_csr_address),
    .io_out_is_csr(Decode_769_io_out_is_csr),
    .io_out_csr_mask(Decode_769_io_out_csr_mask),
    .io_out_rd(Decode_769_io_out_rd),
    .io_out_rs1(Decode_769_io_out_rs1),
    .io_out_rd1(Decode_769_io_out_rd1),
    .io_out_rs2(Decode_769_io_out_rs2),
    .io_out_rd2(Decode_769_io_out_rd2),
    .io_out_wb(Decode_769_io_out_wb),
    .io_out_alu_op(Decode_769_io_out_alu_op),
    .io_out_rs2_src(Decode_769_io_out_rs2_src),
    .io_out_itype_immed(Decode_769_io_out_itype_immed),
    .io_out_mem_read(Decode_769_io_out_mem_read),
    .io_out_mem_write(Decode_769_io_out_mem_write),
    .io_out_branch_type(Decode_769_io_out_branch_type),
    .io_out_branch_stall(Decode_769_io_out_branch_stall),
    .io_out_jal(Decode_769_io_out_jal),
    .io_out_jal_offset(Decode_769_io_out_jal_offset),
    .io_out_upper_immed(Decode_769_io_out_upper_immed),
    .io_out_PC_next(Decode_769_io_out_PC_next));
  D_E_Register D_E_Register_1017(
    .io_in_rd(D_E_Register_1017_io_in_rd),
    .io_in_rs1(D_E_Register_1017_io_in_rs1),
    .io_in_rd1(D_E_Register_1017_io_in_rd1),
    .io_in_rs2(D_E_Register_1017_io_in_rs2),
    .io_in_rd2(D_E_Register_1017_io_in_rd2),
    .io_in_alu_op(D_E_Register_1017_io_in_alu_op),
    .io_in_wb(D_E_Register_1017_io_in_wb),
    .io_in_rs2_src(D_E_Register_1017_io_in_rs2_src),
    .io_in_itype_immed(D_E_Register_1017_io_in_itype_immed),
    .io_in_mem_read(D_E_Register_1017_io_in_mem_read),
    .io_in_mem_write(D_E_Register_1017_io_in_mem_write),
    .io_in_PC_next(D_E_Register_1017_io_in_PC_next),
    .io_in_branch_type(D_E_Register_1017_io_in_branch_type),
    .io_in_fwd_stall(D_E_Register_1017_io_in_fwd_stall),
    .io_in_branch_stall(D_E_Register_1017_io_in_branch_stall),
    .io_in_upper_immed(D_E_Register_1017_io_in_upper_immed),
    .io_in_csr_address(D_E_Register_1017_io_in_csr_address),
    .io_in_is_csr(D_E_Register_1017_io_in_is_csr),
    .io_in_csr_mask(D_E_Register_1017_io_in_csr_mask),
    .io_in_curr_PC(D_E_Register_1017_io_in_curr_PC),
    .io_in_jal(D_E_Register_1017_io_in_jal),
    .io_in_jal_offset(D_E_Register_1017_io_in_jal_offset),
    .clk(D_E_Register_1017_clk),
    .reset(D_E_Register_1017_reset),
    .io_out_csr_address(D_E_Register_1017_io_out_csr_address),
    .io_out_is_csr(D_E_Register_1017_io_out_is_csr),
    .io_out_csr_mask(D_E_Register_1017_io_out_csr_mask),
    .io_out_rd(D_E_Register_1017_io_out_rd),
    .io_out_rs1(D_E_Register_1017_io_out_rs1),
    .io_out_rd1(D_E_Register_1017_io_out_rd1),
    .io_out_rs2(D_E_Register_1017_io_out_rs2),
    .io_out_rd2(D_E_Register_1017_io_out_rd2),
    .io_out_alu_op(D_E_Register_1017_io_out_alu_op),
    .io_out_wb(D_E_Register_1017_io_out_wb),
    .io_out_rs2_src(D_E_Register_1017_io_out_rs2_src),
    .io_out_itype_immed(D_E_Register_1017_io_out_itype_immed),
    .io_out_mem_read(D_E_Register_1017_io_out_mem_read),
    .io_out_mem_write(D_E_Register_1017_io_out_mem_write),
    .io_out_branch_type(D_E_Register_1017_io_out_branch_type),
    .io_out_upper_immed(D_E_Register_1017_io_out_upper_immed),
    .io_out_curr_PC(D_E_Register_1017_io_out_curr_PC),
    .io_out_jal(D_E_Register_1017_io_out_jal),
    .io_out_jal_offset(D_E_Register_1017_io_out_jal_offset),
    .io_out_PC_next(D_E_Register_1017_io_out_PC_next));
  Execute Execute_1239(
    .io_in_rd(Execute_1239_io_in_rd),
    .io_in_rs1(Execute_1239_io_in_rs1),
    .io_in_rd1(Execute_1239_io_in_rd1),
    .io_in_rs2(Execute_1239_io_in_rs2),
    .io_in_rd2(Execute_1239_io_in_rd2),
    .io_in_alu_op(Execute_1239_io_in_alu_op),
    .io_in_wb(Execute_1239_io_in_wb),
    .io_in_rs2_src(Execute_1239_io_in_rs2_src),
    .io_in_itype_immed(Execute_1239_io_in_itype_immed),
    .io_in_mem_read(Execute_1239_io_in_mem_read),
    .io_in_mem_write(Execute_1239_io_in_mem_write),
    .io_in_PC_next(Execute_1239_io_in_PC_next),
    .io_in_branch_type(Execute_1239_io_in_branch_type),
    .io_in_upper_immed(Execute_1239_io_in_upper_immed),
    .io_in_csr_address(Execute_1239_io_in_csr_address),
    .io_in_is_csr(Execute_1239_io_in_is_csr),
    .io_in_csr_data(Execute_1239_io_in_csr_data),
    .io_in_csr_mask(Execute_1239_io_in_csr_mask),
    .io_in_jal(Execute_1239_io_in_jal),
    .io_in_jal_offset(Execute_1239_io_in_jal_offset),
    .io_in_curr_PC(Execute_1239_io_in_curr_PC),
    .io_out_csr_address(Execute_1239_io_out_csr_address),
    .io_out_is_csr(Execute_1239_io_out_is_csr),
    .io_out_csr_result(Execute_1239_io_out_csr_result),
    .io_out_alu_result(Execute_1239_io_out_alu_result),
    .io_out_rd(Execute_1239_io_out_rd),
    .io_out_wb(Execute_1239_io_out_wb),
    .io_out_rs1(Execute_1239_io_out_rs1),
    .io_out_rd1(Execute_1239_io_out_rd1),
    .io_out_rs2(Execute_1239_io_out_rs2),
    .io_out_rd2(Execute_1239_io_out_rd2),
    .io_out_mem_read(Execute_1239_io_out_mem_read),
    .io_out_mem_write(Execute_1239_io_out_mem_write),
    .io_out_jal(Execute_1239_io_out_jal),
    .io_out_jal_dest(Execute_1239_io_out_jal_dest),
    .io_out_branch_offset(Execute_1239_io_out_branch_offset),
    .io_out_branch_stall(Execute_1239_io_out_branch_stall),
    .io_out_PC_next(Execute_1239_io_out_PC_next));
  E_M_Register E_M_Register_1422(
    .io_in_alu_result(E_M_Register_1422_io_in_alu_result),
    .io_in_rd(E_M_Register_1422_io_in_rd),
    .io_in_wb(E_M_Register_1422_io_in_wb),
    .io_in_rs1(E_M_Register_1422_io_in_rs1),
    .io_in_rd1(E_M_Register_1422_io_in_rd1),
    .io_in_rs2(E_M_Register_1422_io_in_rs2),
    .io_in_rd2(E_M_Register_1422_io_in_rd2),
    .io_in_mem_read(E_M_Register_1422_io_in_mem_read),
    .io_in_mem_write(E_M_Register_1422_io_in_mem_write),
    .io_in_PC_next(E_M_Register_1422_io_in_PC_next),
    .io_in_csr_address(E_M_Register_1422_io_in_csr_address),
    .io_in_is_csr(E_M_Register_1422_io_in_is_csr),
    .io_in_csr_result(E_M_Register_1422_io_in_csr_result),
    .io_in_curr_PC(E_M_Register_1422_io_in_curr_PC),
    .io_in_branch_offset(E_M_Register_1422_io_in_branch_offset),
    .io_in_branch_type(E_M_Register_1422_io_in_branch_type),
    .clk(E_M_Register_1422_clk),
    .reset(E_M_Register_1422_reset),
    .io_out_csr_address(E_M_Register_1422_io_out_csr_address),
    .io_out_is_csr(E_M_Register_1422_io_out_is_csr),
    .io_out_csr_result(E_M_Register_1422_io_out_csr_result),
    .io_out_alu_result(E_M_Register_1422_io_out_alu_result),
    .io_out_rd(E_M_Register_1422_io_out_rd),
    .io_out_wb(E_M_Register_1422_io_out_wb),
    .io_out_rs1(E_M_Register_1422_io_out_rs1),
    .io_out_rd1(E_M_Register_1422_io_out_rd1),
    .io_out_rd2(E_M_Register_1422_io_out_rd2),
    .io_out_rs2(E_M_Register_1422_io_out_rs2),
    .io_out_mem_read(E_M_Register_1422_io_out_mem_read),
    .io_out_mem_write(E_M_Register_1422_io_out_mem_write),
    .io_out_curr_PC(E_M_Register_1422_io_out_curr_PC),
    .io_out_branch_offset(E_M_Register_1422_io_out_branch_offset),
    .io_out_branch_type(E_M_Register_1422_io_out_branch_type),
    .io_out_PC_next(E_M_Register_1422_io_out_PC_next));
  Memory Memory_1684(
    .io_DBUS_in_data_data(Memory_1684_io_DBUS_in_data_data),
    .io_DBUS_in_data_valid(Memory_1684_io_DBUS_in_data_valid),
    .io_DBUS_out_data_ready(Memory_1684_io_DBUS_out_data_ready),
    .io_DBUS_out_address_ready(Memory_1684_io_DBUS_out_address_ready),
    .io_DBUS_out_control_ready(Memory_1684_io_DBUS_out_control_ready),
    .io_in_alu_result(Memory_1684_io_in_alu_result),
    .io_in_mem_read(Memory_1684_io_in_mem_read),
    .io_in_mem_write(Memory_1684_io_in_mem_write),
    .io_in_rd(Memory_1684_io_in_rd),
    .io_in_wb(Memory_1684_io_in_wb),
    .io_in_rs1(Memory_1684_io_in_rs1),
    .io_in_rd1(Memory_1684_io_in_rd1),
    .io_in_rs2(Memory_1684_io_in_rs2),
    .io_in_rd2(Memory_1684_io_in_rd2),
    .io_in_PC_next(Memory_1684_io_in_PC_next),
    .io_in_curr_PC(Memory_1684_io_in_curr_PC),
    .io_in_branch_offset(Memory_1684_io_in_branch_offset),
    .io_in_branch_type(Memory_1684_io_in_branch_type),
    .io_DBUS_out_miss(Memory_1684_io_DBUS_out_miss),
    .io_DBUS_out_rw(Memory_1684_io_DBUS_out_rw),
    .io_DBUS_in_data_ready(Memory_1684_io_DBUS_in_data_ready),
    .io_DBUS_out_data_data(Memory_1684_io_DBUS_out_data_data),
    .io_DBUS_out_data_valid(Memory_1684_io_DBUS_out_data_valid),
    .io_DBUS_out_address_data(Memory_1684_io_DBUS_out_address_data),
    .io_DBUS_out_address_valid(Memory_1684_io_DBUS_out_address_valid),
    .io_DBUS_out_control_data(Memory_1684_io_DBUS_out_control_data),
    .io_DBUS_out_control_valid(Memory_1684_io_DBUS_out_control_valid),
    .io_out_alu_result(Memory_1684_io_out_alu_result),
    .io_out_mem_result(Memory_1684_io_out_mem_result),
    .io_out_rd(Memory_1684_io_out_rd),
    .io_out_wb(Memory_1684_io_out_wb),
    .io_out_rs1(Memory_1684_io_out_rs1),
    .io_out_rs2(Memory_1684_io_out_rs2),
    .io_out_branch_dir(Memory_1684_io_out_branch_dir),
    .io_out_branch_dest(Memory_1684_io_out_branch_dest),
    .io_out_delay(),
    .io_out_PC_next(Memory_1684_io_out_PC_next));
  M_W_Register M_W_Register_1807(
    .io_in_alu_result(M_W_Register_1807_io_in_alu_result),
    .io_in_mem_result(M_W_Register_1807_io_in_mem_result),
    .io_in_rd(M_W_Register_1807_io_in_rd),
    .io_in_wb(M_W_Register_1807_io_in_wb),
    .io_in_rs1(M_W_Register_1807_io_in_rs1),
    .io_in_rs2(M_W_Register_1807_io_in_rs2),
    .io_in_PC_next(M_W_Register_1807_io_in_PC_next),
    .clk(M_W_Register_1807_clk),
    .reset(M_W_Register_1807_reset),
    .io_out_alu_result(M_W_Register_1807_io_out_alu_result),
    .io_out_mem_result(M_W_Register_1807_io_out_mem_result),
    .io_out_rd(M_W_Register_1807_io_out_rd),
    .io_out_wb(M_W_Register_1807_io_out_wb),
    .io_out_rs1(M_W_Register_1807_io_out_rs1),
    .io_out_rs2(M_W_Register_1807_io_out_rs2),
    .io_out_PC_next(M_W_Register_1807_io_out_PC_next));
  Write_Back Write_Back_1859(
    .io_in_alu_result(Write_Back_1859_io_in_alu_result),
    .io_in_mem_result(Write_Back_1859_io_in_mem_result),
    .io_in_rd(Write_Back_1859_io_in_rd),
    .io_in_wb(Write_Back_1859_io_in_wb),
    .io_in_rs1(Write_Back_1859_io_in_rs1),
    .io_in_rs2(Write_Back_1859_io_in_rs2),
    .io_in_PC_next(Write_Back_1859_io_in_PC_next),
    .io_out_write_data(Write_Back_1859_io_out_write_data),
    .io_out_rd(Write_Back_1859_io_out_rd),
    .io_out_wb(Write_Back_1859_io_out_wb));
  Forwarding Forwarding_2031(
    .io_in_decode_src1(Forwarding_2031_io_in_decode_src1),
    .io_in_decode_src2(Forwarding_2031_io_in_decode_src2),
    .io_in_decode_csr_address(Forwarding_2031_io_in_decode_csr_address),
    .io_in_execute_dest(Forwarding_2031_io_in_execute_dest),
    .io_in_execute_wb(Forwarding_2031_io_in_execute_wb),
    .io_in_execute_alu_result(Forwarding_2031_io_in_execute_alu_result),
    .io_in_execute_PC_next(Forwarding_2031_io_in_execute_PC_next),
    .io_in_execute_is_csr(Forwarding_2031_io_in_execute_is_csr),
    .io_in_execute_csr_address(Forwarding_2031_io_in_execute_csr_address),
    .io_in_execute_csr_result(Forwarding_2031_io_in_execute_csr_result),
    .io_in_memory_dest(Forwarding_2031_io_in_memory_dest),
    .io_in_memory_wb(Forwarding_2031_io_in_memory_wb),
    .io_in_memory_alu_result(Forwarding_2031_io_in_memory_alu_result),
    .io_in_memory_mem_data(Forwarding_2031_io_in_memory_mem_data),
    .io_in_memory_PC_next(Forwarding_2031_io_in_memory_PC_next),
    .io_in_memory_is_csr(Forwarding_2031_io_in_memory_is_csr),
    .io_in_memory_csr_address(Forwarding_2031_io_in_memory_csr_address),
    .io_in_memory_csr_result(Forwarding_2031_io_in_memory_csr_result),
    .io_in_writeback_dest(Forwarding_2031_io_in_writeback_dest),
    .io_in_writeback_wb(Forwarding_2031_io_in_writeback_wb),
    .io_in_writeback_alu_result(Forwarding_2031_io_in_writeback_alu_result),
    .io_in_writeback_mem_data(Forwarding_2031_io_in_writeback_mem_data),
    .io_in_writeback_PC_next(Forwarding_2031_io_in_writeback_PC_next),
    .io_out_src1_fwd(Forwarding_2031_io_out_src1_fwd),
    .io_out_src2_fwd(Forwarding_2031_io_out_src2_fwd),
    .io_out_csr_fwd(Forwarding_2031_io_out_csr_fwd),
    .io_out_src1_fwd_data(Forwarding_2031_io_out_src1_fwd_data),
    .io_out_src2_fwd_data(Forwarding_2031_io_out_src2_fwd_data),
    .io_out_csr_fwd_data(Forwarding_2031_io_out_csr_fwd_data),
    .io_out_fwd_stall(Forwarding_2031_io_out_fwd_stall));
  Interrupt_Handler Interrupt_Handler_2107(
    .io_INTERRUPT_in_interrupt_id_data(Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_data),
    .io_INTERRUPT_in_interrupt_id_valid(Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_valid),
    .io_INTERRUPT_in_interrupt_id_ready(Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_ready),
    .io_out_interrupt(Interrupt_Handler_2107_io_out_interrupt),
    .io_out_interrupt_pc(Interrupt_Handler_2107_io_out_interrupt_pc));
  JTAG JTAG_2348(
    .io_JTAG_JTAG_TAP_in_mode_select_data(JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_data),
    .io_JTAG_JTAG_TAP_in_mode_select_valid(JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_valid),
    .io_JTAG_JTAG_TAP_in_clock_data(JTAG_2348_io_JTAG_JTAG_TAP_in_clock_data),
    .io_JTAG_JTAG_TAP_in_clock_valid(JTAG_2348_io_JTAG_JTAG_TAP_in_clock_valid),
    .io_JTAG_JTAG_TAP_in_reset_data(JTAG_2348_io_JTAG_JTAG_TAP_in_reset_data),
    .io_JTAG_JTAG_TAP_in_reset_valid(JTAG_2348_io_JTAG_JTAG_TAP_in_reset_valid),
    .io_JTAG_in_data_data(JTAG_2348_io_JTAG_in_data_data),
    .io_JTAG_in_data_valid(JTAG_2348_io_JTAG_in_data_valid),
    .io_JTAG_out_data_ready(JTAG_2348_io_JTAG_out_data_ready),
    .clk(JTAG_2348_clk),
    .reset(JTAG_2348_reset),
    .io_JTAG_JTAG_TAP_in_mode_select_ready(JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_ready),
    .io_JTAG_JTAG_TAP_in_clock_ready(JTAG_2348_io_JTAG_JTAG_TAP_in_clock_ready),
    .io_JTAG_JTAG_TAP_in_reset_ready(JTAG_2348_io_JTAG_JTAG_TAP_in_reset_ready),
    .io_JTAG_in_data_ready(JTAG_2348_io_JTAG_in_data_ready),
    .io_JTAG_out_data_data(JTAG_2348_io_JTAG_out_data_data),
    .io_JTAG_out_data_valid(JTAG_2348_io_JTAG_out_data_valid));
  CSR_Handler CSR_Handler_2442(
    .io_in_decode_csr_address(CSR_Handler_2442_io_in_decode_csr_address),
    .io_in_mem_csr_address(CSR_Handler_2442_io_in_mem_csr_address),
    .io_in_mem_is_csr(CSR_Handler_2442_io_in_mem_is_csr),
    .io_in_mem_csr_result(CSR_Handler_2442_io_in_mem_csr_result),
    .clk(CSR_Handler_2442_clk),
    .reset(CSR_Handler_2442_reset),
    .io_out_decode_csr_data(CSR_Handler_2442_io_out_decode_csr_data));
  assign Fetch_222_clk = clk;
  assign Fetch_222_reset = reset;
  assign Fetch_222_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign Fetch_222_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign Fetch_222_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign Fetch_222_io_in_branch_dir = Memory_1684_io_out_branch_dir;
  assign Fetch_222_io_in_freeze = 1'h0;
  assign Fetch_222_io_in_branch_dest = Memory_1684_io_out_branch_dest;
  assign Fetch_222_io_in_branch_stall = Decode_769_io_out_branch_stall;
  assign Fetch_222_io_in_fwd_stall = Forwarding_2031_io_out_fwd_stall;
  assign Fetch_222_io_in_branch_stall_exe = Execute_1239_io_out_branch_stall;
  assign Fetch_222_io_in_jal = Execute_1239_io_out_jal;
  assign Fetch_222_io_in_jal_dest = Execute_1239_io_out_jal_dest;
  assign Fetch_222_io_in_interrupt = Interrupt_Handler_2107_io_out_interrupt;
  assign Fetch_222_io_in_interrupt_pc = Interrupt_Handler_2107_io_out_interrupt_pc;
  assign Fetch_222_io_in_debug = 1'h0;
  assign F_D_Register_301_clk = clk;
  assign F_D_Register_301_reset = reset;
  assign F_D_Register_301_io_in_instruction = Fetch_222_io_out_instruction;
  assign F_D_Register_301_io_in_curr_PC = Fetch_222_io_out_curr_PC;
  assign F_D_Register_301_io_in_branch_stall = Decode_769_io_out_branch_stall;
  assign F_D_Register_301_io_in_branch_stall_exe = Execute_1239_io_out_branch_stall;
  assign F_D_Register_301_io_in_fwd_stall = Forwarding_2031_io_out_fwd_stall;
  assign Decode_769_clk = clk;
  assign Decode_769_io_in_instruction = F_D_Register_301_io_out_instruction;
  assign Decode_769_io_in_curr_PC = F_D_Register_301_io_out_curr_PC;
  assign Decode_769_io_in_stall = op_eq_2459;
  assign Decode_769_io_in_write_data = Write_Back_1859_io_out_write_data;
  assign Decode_769_io_in_rd = Write_Back_1859_io_out_rd;
  assign Decode_769_io_in_wb = Write_Back_1859_io_out_wb;
  assign Decode_769_io_in_src1_fwd = Forwarding_2031_io_out_src1_fwd;
  assign Decode_769_io_in_src1_fwd_data = Forwarding_2031_io_out_src1_fwd_data;
  assign Decode_769_io_in_src2_fwd = Forwarding_2031_io_out_src2_fwd;
  assign Decode_769_io_in_src2_fwd_data = Forwarding_2031_io_out_src2_fwd_data;
  assign Decode_769_io_in_csr_fwd = Forwarding_2031_io_out_csr_fwd;
  assign Decode_769_io_in_csr_fwd_data = Forwarding_2031_io_out_csr_fwd_data;
  assign D_E_Register_1017_clk = clk;
  assign D_E_Register_1017_reset = reset;
  assign D_E_Register_1017_io_in_rd = Decode_769_io_out_rd;
  assign D_E_Register_1017_io_in_rs1 = Decode_769_io_out_rs1;
  assign D_E_Register_1017_io_in_rd1 = Decode_769_io_out_rd1;
  assign D_E_Register_1017_io_in_rs2 = Decode_769_io_out_rs2;
  assign D_E_Register_1017_io_in_rd2 = Decode_769_io_out_rd2;
  assign D_E_Register_1017_io_in_alu_op = Decode_769_io_out_alu_op;
  assign D_E_Register_1017_io_in_wb = Decode_769_io_out_wb;
  assign D_E_Register_1017_io_in_rs2_src = Decode_769_io_out_rs2_src;
  assign D_E_Register_1017_io_in_itype_immed = Decode_769_io_out_itype_immed;
  assign D_E_Register_1017_io_in_mem_read = Decode_769_io_out_mem_read;
  assign D_E_Register_1017_io_in_mem_write = Decode_769_io_out_mem_write;
  assign D_E_Register_1017_io_in_PC_next = Decode_769_io_out_PC_next;
  assign D_E_Register_1017_io_in_branch_type = Decode_769_io_out_branch_type;
  assign D_E_Register_1017_io_in_fwd_stall = Forwarding_2031_io_out_fwd_stall;
  assign D_E_Register_1017_io_in_branch_stall = Execute_1239_io_out_branch_stall;
  assign D_E_Register_1017_io_in_upper_immed = Decode_769_io_out_upper_immed;
  assign D_E_Register_1017_io_in_csr_address = Decode_769_io_out_csr_address;
  assign D_E_Register_1017_io_in_is_csr = Decode_769_io_out_is_csr;
  assign D_E_Register_1017_io_in_csr_mask = Decode_769_io_out_csr_mask;
  assign D_E_Register_1017_io_in_curr_PC = F_D_Register_301_io_out_curr_PC;
  assign D_E_Register_1017_io_in_jal = Decode_769_io_out_jal;
  assign D_E_Register_1017_io_in_jal_offset = Decode_769_io_out_jal_offset;
  assign Execute_1239_io_in_rd = D_E_Register_1017_io_out_rd;
  assign Execute_1239_io_in_rs1 = D_E_Register_1017_io_out_rs1;
  assign Execute_1239_io_in_rd1 = D_E_Register_1017_io_out_rd1;
  assign Execute_1239_io_in_rs2 = D_E_Register_1017_io_out_rs2;
  assign Execute_1239_io_in_rd2 = D_E_Register_1017_io_out_rd2;
  assign Execute_1239_io_in_alu_op = D_E_Register_1017_io_out_alu_op;
  assign Execute_1239_io_in_wb = D_E_Register_1017_io_out_wb;
  assign Execute_1239_io_in_rs2_src = D_E_Register_1017_io_out_rs2_src;
  assign Execute_1239_io_in_itype_immed = D_E_Register_1017_io_out_itype_immed;
  assign Execute_1239_io_in_mem_read = D_E_Register_1017_io_out_mem_read;
  assign Execute_1239_io_in_mem_write = D_E_Register_1017_io_out_mem_write;
  assign Execute_1239_io_in_PC_next = D_E_Register_1017_io_out_PC_next;
  assign Execute_1239_io_in_branch_type = D_E_Register_1017_io_out_branch_type;
  assign Execute_1239_io_in_upper_immed = D_E_Register_1017_io_out_upper_immed;
  assign Execute_1239_io_in_csr_address = D_E_Register_1017_io_out_csr_address;
  assign Execute_1239_io_in_is_csr = D_E_Register_1017_io_out_is_csr;
  assign Execute_1239_io_in_csr_data = CSR_Handler_2442_io_out_decode_csr_data;
  assign Execute_1239_io_in_csr_mask = D_E_Register_1017_io_out_csr_mask;
  assign Execute_1239_io_in_jal = D_E_Register_1017_io_out_jal;
  assign Execute_1239_io_in_jal_offset = D_E_Register_1017_io_out_jal_offset;
  assign Execute_1239_io_in_curr_PC = D_E_Register_1017_io_out_curr_PC;
  assign E_M_Register_1422_clk = clk;
  assign E_M_Register_1422_reset = reset;
  assign E_M_Register_1422_io_in_alu_result = Execute_1239_io_out_alu_result;
  assign E_M_Register_1422_io_in_rd = Execute_1239_io_out_rd;
  assign E_M_Register_1422_io_in_wb = Execute_1239_io_out_wb;
  assign E_M_Register_1422_io_in_rs1 = Execute_1239_io_out_rs1;
  assign E_M_Register_1422_io_in_rd1 = Execute_1239_io_out_rd1;
  assign E_M_Register_1422_io_in_rs2 = Execute_1239_io_out_rs2;
  assign E_M_Register_1422_io_in_rd2 = Execute_1239_io_out_rd2;
  assign E_M_Register_1422_io_in_mem_read = Execute_1239_io_out_mem_read;
  assign E_M_Register_1422_io_in_mem_write = Execute_1239_io_out_mem_write;
  assign E_M_Register_1422_io_in_PC_next = Execute_1239_io_out_PC_next;
  assign E_M_Register_1422_io_in_csr_address = Execute_1239_io_out_csr_address;
  assign E_M_Register_1422_io_in_is_csr = Execute_1239_io_out_is_csr;
  assign E_M_Register_1422_io_in_csr_result = Execute_1239_io_out_csr_result;
  assign E_M_Register_1422_io_in_curr_PC = D_E_Register_1017_io_out_curr_PC;
  assign E_M_Register_1422_io_in_branch_offset = Execute_1239_io_out_branch_offset;
  assign E_M_Register_1422_io_in_branch_type = D_E_Register_1017_io_out_branch_type;
  assign Memory_1684_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Memory_1684_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Memory_1684_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Memory_1684_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Memory_1684_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Memory_1684_io_in_alu_result = E_M_Register_1422_io_out_alu_result;
  assign Memory_1684_io_in_mem_read = E_M_Register_1422_io_out_mem_read;
  assign Memory_1684_io_in_mem_write = E_M_Register_1422_io_out_mem_write;
  assign Memory_1684_io_in_rd = E_M_Register_1422_io_out_rd;
  assign Memory_1684_io_in_wb = E_M_Register_1422_io_out_wb;
  assign Memory_1684_io_in_rs1 = E_M_Register_1422_io_out_rs1;
  assign Memory_1684_io_in_rd1 = E_M_Register_1422_io_out_rd1;
  assign Memory_1684_io_in_rs2 = E_M_Register_1422_io_out_rs2;
  assign Memory_1684_io_in_rd2 = E_M_Register_1422_io_out_rd2;
  assign Memory_1684_io_in_PC_next = E_M_Register_1422_io_out_PC_next;
  assign Memory_1684_io_in_curr_PC = E_M_Register_1422_io_out_curr_PC;
  assign Memory_1684_io_in_branch_offset = E_M_Register_1422_io_out_branch_offset;
  assign Memory_1684_io_in_branch_type = E_M_Register_1422_io_out_branch_type;
  assign M_W_Register_1807_clk = clk;
  assign M_W_Register_1807_reset = reset;
  assign M_W_Register_1807_io_in_alu_result = Memory_1684_io_out_alu_result;
  assign M_W_Register_1807_io_in_mem_result = Memory_1684_io_out_mem_result;
  assign M_W_Register_1807_io_in_rd = Memory_1684_io_out_rd;
  assign M_W_Register_1807_io_in_wb = Memory_1684_io_out_wb;
  assign M_W_Register_1807_io_in_rs1 = Memory_1684_io_out_rs1;
  assign M_W_Register_1807_io_in_rs2 = Memory_1684_io_out_rs2;
  assign M_W_Register_1807_io_in_PC_next = Memory_1684_io_out_PC_next;
  assign Write_Back_1859_io_in_alu_result = M_W_Register_1807_io_out_alu_result;
  assign Write_Back_1859_io_in_mem_result = M_W_Register_1807_io_out_mem_result;
  assign Write_Back_1859_io_in_rd = M_W_Register_1807_io_out_rd;
  assign Write_Back_1859_io_in_wb = M_W_Register_1807_io_out_wb;
  assign Write_Back_1859_io_in_rs1 = M_W_Register_1807_io_out_rs1;
  assign Write_Back_1859_io_in_rs2 = M_W_Register_1807_io_out_rs2;
  assign Write_Back_1859_io_in_PC_next = M_W_Register_1807_io_out_PC_next;
  assign Forwarding_2031_io_in_decode_src1 = Decode_769_io_out_rs1;
  assign Forwarding_2031_io_in_decode_src2 = Decode_769_io_out_rs2;
  assign Forwarding_2031_io_in_decode_csr_address = Decode_769_io_out_csr_address;
  assign Forwarding_2031_io_in_execute_dest = Execute_1239_io_out_rd;
  assign Forwarding_2031_io_in_execute_wb = Execute_1239_io_out_wb;
  assign Forwarding_2031_io_in_execute_alu_result = Execute_1239_io_out_alu_result;
  assign Forwarding_2031_io_in_execute_PC_next = Execute_1239_io_out_PC_next;
  assign Forwarding_2031_io_in_execute_is_csr = Execute_1239_io_out_is_csr;
  assign Forwarding_2031_io_in_execute_csr_address = Execute_1239_io_out_csr_address;
  assign Forwarding_2031_io_in_execute_csr_result = Execute_1239_io_out_csr_result;
  assign Forwarding_2031_io_in_memory_dest = Memory_1684_io_out_rd;
  assign Forwarding_2031_io_in_memory_wb = Memory_1684_io_out_wb;
  assign Forwarding_2031_io_in_memory_alu_result = Memory_1684_io_out_alu_result;
  assign Forwarding_2031_io_in_memory_mem_data = Memory_1684_io_out_mem_result;
  assign Forwarding_2031_io_in_memory_PC_next = Memory_1684_io_out_PC_next;
  assign Forwarding_2031_io_in_memory_is_csr = E_M_Register_1422_io_out_is_csr;
  assign Forwarding_2031_io_in_memory_csr_address = E_M_Register_1422_io_out_csr_address;
  assign Forwarding_2031_io_in_memory_csr_result = E_M_Register_1422_io_out_csr_result;
  assign Forwarding_2031_io_in_writeback_dest = M_W_Register_1807_io_out_rd;
  assign Forwarding_2031_io_in_writeback_wb = M_W_Register_1807_io_out_wb;
  assign Forwarding_2031_io_in_writeback_alu_result = M_W_Register_1807_io_out_alu_result;
  assign Forwarding_2031_io_in_writeback_mem_data = M_W_Register_1807_io_out_mem_result;
  assign Forwarding_2031_io_in_writeback_PC_next = M_W_Register_1807_io_out_PC_next;
  assign Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_data = io_INTERRUPT_in_interrupt_id_data;
  assign Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_valid = io_INTERRUPT_in_interrupt_id_valid;
  assign JTAG_2348_clk = clk;
  assign JTAG_2348_reset = reset;
  assign JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_data = io_jtag_JTAG_TAP_in_mode_select_data;
  assign JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_valid = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign JTAG_2348_io_JTAG_JTAG_TAP_in_clock_data = io_jtag_JTAG_TAP_in_clock_data;
  assign JTAG_2348_io_JTAG_JTAG_TAP_in_clock_valid = io_jtag_JTAG_TAP_in_clock_valid;
  assign JTAG_2348_io_JTAG_JTAG_TAP_in_reset_data = io_jtag_JTAG_TAP_in_reset_data;
  assign JTAG_2348_io_JTAG_JTAG_TAP_in_reset_valid = io_jtag_JTAG_TAP_in_reset_valid;
  assign JTAG_2348_io_JTAG_in_data_data = io_jtag_in_data_data;
  assign JTAG_2348_io_JTAG_in_data_valid = io_jtag_in_data_valid;
  assign JTAG_2348_io_JTAG_out_data_ready = io_jtag_out_data_ready;
  assign CSR_Handler_2442_clk = clk;
  assign CSR_Handler_2442_reset = reset;
  assign CSR_Handler_2442_io_in_decode_csr_address = Decode_769_io_out_csr_address;
  assign CSR_Handler_2442_io_in_mem_csr_address = E_M_Register_1422_io_out_csr_address;
  assign CSR_Handler_2442_io_in_mem_is_csr = E_M_Register_1422_io_out_is_csr;
  assign CSR_Handler_2442_io_in_mem_csr_result = E_M_Register_1422_io_out_csr_result;

  assign io_IBUS_in_data_ready = Fetch_222_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = Fetch_222_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = Fetch_222_io_IBUS_out_address_valid;
  assign io_DBUS_out_miss = Memory_1684_io_DBUS_out_miss;
  assign io_DBUS_out_rw = Memory_1684_io_DBUS_out_rw;
  assign io_DBUS_in_data_ready = Memory_1684_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Memory_1684_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Memory_1684_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Memory_1684_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Memory_1684_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Memory_1684_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Memory_1684_io_DBUS_out_control_valid;
  assign io_INTERRUPT_in_interrupt_id_ready = Interrupt_Handler_2107_io_INTERRUPT_in_interrupt_id_ready;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = JTAG_2348_io_JTAG_JTAG_TAP_in_mode_select_ready;
  assign io_jtag_JTAG_TAP_in_clock_ready = JTAG_2348_io_JTAG_JTAG_TAP_in_clock_ready;
  assign io_jtag_JTAG_TAP_in_reset_ready = JTAG_2348_io_JTAG_JTAG_TAP_in_reset_ready;
  assign io_jtag_in_data_ready = JTAG_2348_io_JTAG_in_data_ready;
  assign io_jtag_out_data_data = JTAG_2348_io_JTAG_out_data_data;
  assign io_jtag_out_data_valid = JTAG_2348_io_JTAG_out_data_valid;
  assign io_out_fwd_stall = Forwarding_2031_io_out_fwd_stall;
  assign io_out_branch_stall = op_orl_2455;

endmodule
