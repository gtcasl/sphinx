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
  wire proxy_io_IBUS_out_address_valid_95, proxy_io_out_delay_101, proxy_ch_bool_104, proxy_ch_bool_105;

  assign proxy_io_IBUS_out_address_valid_95 = proxy_ch_bool_104;
  assign proxy_io_out_delay_101 = proxy_ch_bool_105;
  assign proxy_ch_bool_104 = 1'h1;
  assign proxy_ch_bool_105 = 1'h0;

  assign io_IBUS_in_data_ready = 1'h1;
  assign io_IBUS_out_address_data = io_in_address;
  assign io_IBUS_out_address_valid = proxy_io_IBUS_out_address_valid_95;
  assign io_out_instruction = io_IBUS_in_data_data;
  assign io_out_delay = proxy_io_out_delay_101;

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
  wire proxy_io_IBUS_in_data_ready_65, proxy_io_IBUS_out_address_valid_69, proxy_io_out_delay_85, proxy_ICACHE_io_IBUS_in_data_ready_112, proxy_ICACHE_io_IBUS_out_address_valid_116, proxy_ICACHE_io_out_delay_124, proxy_ch_bool_167, op_notl_171, op_andl_172, op_eq_176, op_eq_178, op_orl_179, op_orl_180, op_orl_181, op_orl_182, op_orl_183, op_orl_184, op_notl_187, op_eq_189, op_andl_190, op_notl_192, op_eq_194, op_andl_195, op_eq_201, op_eq_205, ICACHE_107_io_IBUS_in_data_valid, ICACHE_107_io_IBUS_in_data_ready, ICACHE_107_io_IBUS_out_address_valid, ICACHE_107_io_IBUS_out_address_ready, ICACHE_107_io_out_delay;
  wire[31:0] proxy_io_IBUS_out_address_data_67, proxy_io_out_curr_PC_87, proxy_ICACHE_io_IBUS_out_address_data_114, proxy_ICACHE_io_in_address_120, proxy_ch_bit_32u_138, proxy_ch_bit_32u_197, sel_168, sel_169, sel_170, sel_173, sel_186, sel_191, sel_196, op_add_215, op_add_217, op_add_219, ICACHE_107_io_IBUS_in_data_data, ICACHE_107_io_IBUS_out_address_data, ICACHE_107_io_in_address, ICACHE_107_io_out_instruction;
  wire[4:0] sel_202, sel_206, sel_208, sel_210, sel_212;

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
      reg_ch_bit_32u_139 <= proxy_ch_bit_32u_138;
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
  assign proxy_io_IBUS_in_data_ready_65 = proxy_ICACHE_io_IBUS_in_data_ready_112;
  assign proxy_io_IBUS_out_address_data_67 = proxy_ICACHE_io_IBUS_out_address_data_114;
  assign proxy_io_IBUS_out_address_valid_69 = proxy_ICACHE_io_IBUS_out_address_valid_116;
  assign proxy_io_out_delay_85 = proxy_ICACHE_io_out_delay_124;
  assign proxy_io_out_curr_PC_87 = proxy_ch_bit_32u_197;
  assign proxy_ICACHE_io_IBUS_in_data_ready_112 = ICACHE_107_io_IBUS_in_data_ready;
  assign proxy_ICACHE_io_IBUS_out_address_data_114 = ICACHE_107_io_IBUS_out_address_data;
  assign proxy_ICACHE_io_IBUS_out_address_valid_116 = ICACHE_107_io_IBUS_out_address_valid;
  assign proxy_ICACHE_io_in_address_120 = proxy_ch_bit_32u_197;
  assign proxy_ICACHE_io_out_delay_124 = ICACHE_107_io_out_delay;
  assign proxy_ch_bit_32u_138 = proxy_ch_bit_32u_197;
  assign proxy_ch_bool_167 = proxy_ICACHE_io_out_delay_124;
  assign proxy_ch_bit_32u_197 = sel_196;
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
  assign sel_202 = op_eq_201 ? 5'h2 : 5'h0;
  assign sel_206 = op_eq_205 ? 5'h1 : sel_202;
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
  assign op_orl_182 = op_orl_181 || proxy_ch_bool_167;
  assign op_orl_183 = op_orl_182 || io_in_freeze;
  assign op_orl_184 = proxy_ch_bool_167 || io_in_freeze;
  assign op_notl_187 = !reg_ch_bool_135;
  assign op_eq_189 = io_in_branch_dir == 1'h1;
  assign op_andl_190 = op_eq_189 && op_notl_187;
  assign op_notl_192 = !reg_ch_bool_135;
  assign op_eq_194 = io_in_jal == 1'h1;
  assign op_andl_195 = op_eq_194 && op_notl_192;
  assign op_eq_201 = io_in_branch_dir == 1'h1;
  assign op_eq_205 = io_in_jal == 1'h1;
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
  assign ICACHE_107_io_in_address = proxy_ICACHE_io_in_address_120;

  assign io_IBUS_in_data_ready = proxy_io_IBUS_in_data_ready_65;
  assign io_IBUS_out_address_data = proxy_io_IBUS_out_address_data_67;
  assign io_IBUS_out_address_valid = proxy_io_IBUS_out_address_valid_69;
  assign io_out_instruction = sel_186;
  assign io_out_delay = proxy_io_out_delay_85;
  assign io_out_curr_PC = proxy_io_out_curr_PC_87;

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
  wire[31:0] sel_299, sel_300;
  wire op_eq_298;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_283 <= 32'h0;
    else
      reg_ch_bit_32u_283 <= sel_300;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_286 <= 32'h0;
    else
      reg_ch_bit_32u_286 <= sel_299;
  end
  assign sel_299 = op_eq_298 ? io_in_curr_PC : reg_ch_bit_32u_286;
  assign sel_300 = op_eq_298 ? io_in_instruction : reg_ch_bit_32u_283;
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
  wire[4:0] proxy_ch_bit_5u_381, proxy_ch_uint_5u_387, proxy_ch_uint_5u_391, proxy_ch_uint_5u_398;
  wire op_ne_385, op_andl_386, op_eq_396, op_eq_402;

  assign marport_ch_bit_32u_392 = mem_ch_bit_32u_379[proxy_ch_uint_5u_391];
  assign marport_ch_bit_32u_399 = mem_ch_bit_32u_379[proxy_ch_uint_5u_398];
  always @ (posedge clk) begin
    if (op_andl_386) begin
      mem_ch_bit_32u_379[proxy_ch_uint_5u_387] <= io_in_data;
    end
  end
  assign proxy_ch_bit_5u_381 = io_in_rd;
  assign proxy_ch_uint_5u_387 = proxy_ch_bit_5u_381;
  assign proxy_ch_uint_5u_391 = io_in_src1;
  assign proxy_ch_uint_5u_398 = io_in_src2;
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
  wire proxy_io_out_is_csr_332, proxy_ch_bool_437, proxy_slice_sliceref_510, proxy_slice_562, proxy_ch_uint_1u_563, proxy_slice_568, proxy_ch_uint_1u_569, proxy_ch_bit_1u_570, proxy_cat_sliceref_587, proxy_ch_bit_12u_sliceref_635, proxy_ch_bit_12u_sliceref_644, proxy_slice_sliceref_654, proxy_slice_658, proxy_ch_uint_1u_659, proxy_slice_660, proxy_ch_uint_1u_661, sel_447, sel_548, sel_608, op_ne_446, op_eq_477, op_eq_480, op_eq_483, op_orl_484, op_eq_487, op_eq_490, op_eq_493, op_eq_496, op_eq_499, op_eq_502, op_ne_505, op_eq_508, op_andl_509, op_eq_512, op_andl_513, op_eq_515, op_eq_517, op_andl_518, op_eq_520, op_eq_524, op_orl_532, op_orl_533, op_orl_534, op_orl_535, op_orl_542, op_orl_543, op_orl_547, op_eq_578, op_eq_589, op_eq_593, op_lt_596, op_andl_597, op_ne_611, op_ge_613, op_eq_614, op_andl_617, op_andl_618, op_eq_623, op_eq_626, op_orl_627, op_eq_637, op_eq_646, op_eq_656, op_eq_675, op_eq_703, op_eq_709, op_eq_726, op_eq_739, op_eq_744, op_eq_749, op_orl_752, op_lt_765, RegisterFile_404_clk, RegisterFile_404_io_in_write_register;
  wire[4:0] proxy_io_out_rd_336, proxy_io_out_rs1_338, proxy_io_out_rs2_342, proxy_RegisterFile_io_in_src1_414, proxy_RegisterFile_io_in_src2_416, proxy_slice_452, proxy_slice_456, proxy_slice_460, RegisterFile_404_io_in_rd, RegisterFile_404_io_in_src1, RegisterFile_404_io_in_src2;
  wire[31:0] proxy_RegisterFile_io_out_src1_data_418, proxy_RegisterFile_io_out_src2_data_420, proxy_ch_bit_32u_426, proxy_ch_bit_32u_427, proxy_cat_576, proxy_cat_586, proxy_cat_634, proxy_cat_643, proxy_cat_653, proxy_cat_673, sel_521, sel_522, sel_525, sel_528, sel_579, sel_590, sel_606, sel_638, sel_647, sel_657, sel_676, op_shr_451, op_shr_455, op_shr_459, op_shr_463, op_shr_467, op_shr_470, op_add_474, op_pad_527, op_shr_560, op_shr_566, op_pad_573, op_pad_583, op_pad_632, op_pad_641, op_pad_651, op_shr_664, op_shr_667, op_pad_671, RegisterFile_404_io_in_data, RegisterFile_404_io_out_src1_data, RegisterFile_404_io_out_src2_data;
  wire[6:0] proxy_ch_bit_7u_422, proxy_slice_448, proxy_slice_468;
  wire[2:0] proxy_slice_464, sel_551, sel_553;
  wire[11:0] proxy_slice_471, proxy_cat_581, proxy_ch_bit_12u_620, proxy_cat_639, proxy_cat_669, sel_619, sel_630, op_pad_629;
  wire[19:0] proxy_cat_554, proxy_cat_555, proxy_ch_bit_20u_584, proxy_ch_bit_20u_633, proxy_ch_bit_20u_642, proxy_ch_bit_20u_652, proxy_ch_bit_20u_672;
  wire[7:0] proxy_slice_561;
  wire[9:0] proxy_slice_567;
  wire[20:0] proxy_cat_571;
  wire[10:0] proxy_ch_bit_11u_574;
  wire[3:0] proxy_slice_665, sel_710, sel_712, sel_727, sel_740, sel_745, sel_750, sel_753, sel_754, sel_757, sel_760, sel_766, sel_767;
  wire[5:0] proxy_slice_668;
  wire[1:0] proxy_slice_735, sel_536, sel_539, sel_544;
  reg[19:0] sel_558;
  reg[31:0] sel_607, sel_679;
  reg sel_609, sel_701;
  reg[11:0] sel_680;
  reg[2:0] sel_699, sel_700;
  reg[3:0] sel_734;

  assign proxy_io_out_is_csr_332 = proxy_ch_bool_437;
  assign proxy_io_out_rd_336 = proxy_slice_452;
  assign proxy_io_out_rs1_338 = proxy_slice_456;
  assign proxy_io_out_rs2_342 = proxy_slice_460;
  assign proxy_RegisterFile_io_in_src1_414 = proxy_io_out_rs1_338;
  assign proxy_RegisterFile_io_in_src2_416 = proxy_io_out_rs2_342;
  assign proxy_RegisterFile_io_out_src1_data_418 = RegisterFile_404_io_out_src1_data;
  assign proxy_RegisterFile_io_out_src2_data_420 = RegisterFile_404_io_out_src2_data;
  assign proxy_ch_bit_7u_422 = proxy_slice_448;
  assign proxy_ch_bit_32u_426 = proxy_RegisterFile_io_out_src1_data_418;
  assign proxy_ch_bit_32u_427 = proxy_RegisterFile_io_out_src2_data_420;
  assign proxy_ch_bool_437 = op_andl_509;
  assign proxy_slice_448 = io_in_instruction[6:0];
  assign proxy_slice_452 = op_shr_451[4:0];
  assign proxy_slice_456 = op_shr_455[4:0];
  assign proxy_slice_460 = op_shr_459[4:0];
  assign proxy_slice_464 = op_shr_463[2:0];
  assign proxy_slice_468 = op_shr_467[6:0];
  assign proxy_slice_471 = op_shr_470[11:0];
  assign proxy_slice_sliceref_510 = proxy_slice_464[2];
  assign proxy_cat_554 = {proxy_slice_468, proxy_io_out_rs2_342, proxy_io_out_rs1_338, proxy_slice_464};
  assign proxy_cat_555 = {proxy_slice_468, proxy_io_out_rs2_342, proxy_io_out_rs1_338, proxy_slice_464};
  assign proxy_slice_561 = op_shr_560[7:0];
  assign proxy_slice_562 = io_in_instruction[20];
  assign proxy_ch_uint_1u_563 = proxy_slice_562;
  assign proxy_slice_567 = op_shr_566[9:0];
  assign proxy_slice_568 = io_in_instruction[31];
  assign proxy_ch_uint_1u_569 = proxy_slice_568;
  assign proxy_ch_bit_1u_570 = 1'h0;
  assign proxy_cat_571 = {proxy_ch_uint_1u_569, proxy_slice_561, proxy_ch_uint_1u_563, proxy_slice_567, proxy_ch_bit_1u_570};
  assign proxy_ch_bit_11u_574 = 11'h7ff;
  assign proxy_cat_576 = {proxy_ch_bit_11u_574, proxy_cat_571};
  assign proxy_cat_581 = {proxy_slice_468, proxy_io_out_rs2_342};
  assign proxy_ch_bit_20u_584 = 20'hfffff;
  assign proxy_cat_586 = {proxy_ch_bit_20u_584, proxy_cat_581};
  assign proxy_cat_sliceref_587 = proxy_cat_581[11];
  assign proxy_ch_bit_12u_620 = sel_680;
  assign proxy_ch_bit_20u_633 = 20'hfffff;
  assign proxy_cat_634 = {proxy_ch_bit_20u_633, proxy_ch_bit_12u_620};
  assign proxy_ch_bit_12u_sliceref_635 = proxy_ch_bit_12u_620[11];
  assign proxy_cat_639 = {proxy_slice_468, proxy_io_out_rd_336};
  assign proxy_ch_bit_20u_642 = 20'hfffff;
  assign proxy_cat_643 = {proxy_ch_bit_20u_642, proxy_ch_bit_12u_620};
  assign proxy_ch_bit_12u_sliceref_644 = proxy_ch_bit_12u_620[11];
  assign proxy_ch_bit_20u_652 = 20'hfffff;
  assign proxy_cat_653 = {proxy_ch_bit_20u_652, proxy_slice_471};
  assign proxy_slice_sliceref_654 = proxy_slice_471[11];
  assign proxy_slice_658 = io_in_instruction[31];
  assign proxy_ch_uint_1u_659 = proxy_slice_658;
  assign proxy_slice_660 = io_in_instruction[7];
  assign proxy_ch_uint_1u_661 = proxy_slice_660;
  assign proxy_slice_665 = op_shr_664[3:0];
  assign proxy_slice_668 = op_shr_667[5:0];
  assign proxy_cat_669 = {proxy_ch_uint_1u_659, proxy_ch_uint_1u_661, proxy_slice_668, proxy_slice_665};
  assign proxy_ch_bit_20u_672 = 20'hfffff;
  assign proxy_cat_673 = {proxy_ch_bit_20u_672, proxy_ch_bit_12u_620};
  assign proxy_slice_735 = proxy_slice_464[1:0];
  assign sel_447 = op_ne_446 ? 1'h1 : 1'h0;
  assign sel_521 = op_eq_520 ? io_in_src1_fwd_data : proxy_ch_bit_32u_426;
  assign sel_522 = op_eq_493 ? io_in_curr_PC : sel_521;
  assign sel_525 = op_eq_524 ? io_in_src2_fwd_data : proxy_ch_bit_32u_427;
  assign sel_528 = op_andl_513 ? op_pad_527 : sel_522;
  assign sel_536 = op_orl_535 ? 2'h1 : 2'h0;
  assign sel_539 = op_eq_480 ? 2'h2 : sel_536;
  assign sel_544 = op_orl_543 ? 2'h3 : sel_539;
  assign sel_548 = op_orl_547 ? 1'h1 : 1'h0;
  assign sel_551 = op_eq_480 ? proxy_slice_464 : 3'h7;
  assign sel_553 = op_eq_487 ? proxy_slice_464 : 3'h7;
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h17: sel_558 = proxy_cat_555;
      7'h37: sel_558 = proxy_cat_554;
      default: sel_558 = 20'h7b;
    endcase
  end
  assign sel_579 = op_eq_578 ? proxy_cat_576 : op_pad_573;
  assign sel_590 = op_eq_589 ? proxy_cat_586 : op_pad_583;
  assign sel_606 = op_andl_597 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h67: sel_607 = sel_590;
      7'h6f: sel_607 = sel_579;
      7'h73: sel_607 = sel_606;
      default: sel_607 = 32'h7b;
    endcase
  end
  assign sel_608 = op_andl_597 ? 1'h1 : 1'h0;
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h67: sel_609 = 1'h1;
      7'h6f: sel_609 = 1'h1;
      7'h73: sel_609 = sel_608;
      default: sel_609 = 1'h0;
    endcase
  end
  assign sel_619 = op_andl_618 ? proxy_slice_471 : 12'h7b;
  assign sel_630 = op_orl_627 ? op_pad_629 : proxy_slice_471;
  assign sel_638 = op_eq_637 ? proxy_cat_634 : op_pad_632;
  assign sel_647 = op_eq_646 ? proxy_cat_643 : op_pad_641;
  assign sel_657 = op_eq_656 ? proxy_cat_653 : op_pad_651;
  assign sel_676 = op_eq_675 ? proxy_cat_673 : op_pad_671;
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h03: sel_679 = sel_657;
      7'h13: sel_679 = sel_638;
      7'h23: sel_679 = sel_647;
      7'h63: sel_679 = sel_676;
      default: sel_679 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h03: sel_680 = 12'h0;
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
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h63: sel_700 = sel_699;
      7'h67: sel_700 = 3'h0;
      7'h6f: sel_700 = 3'h0;
      default: sel_700 = 3'h0;
    endcase
  end
  always @(*) begin
    case (proxy_ch_bit_7u_422)
      7'h63: sel_701 = 1'h1;
      7'h67: sel_701 = 1'h1;
      7'h6f: sel_701 = 1'h1;
      default: sel_701 = 1'h0;
    endcase
  end
  assign sel_710 = op_eq_709 ? 4'h0 : 4'h1;
  assign sel_712 = op_eq_703 ? 4'h0 : sel_710;
  assign sel_727 = op_eq_726 ? 4'h6 : 4'h7;
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
  assign sel_740 = op_eq_739 ? 4'hf : 4'hf;
  assign sel_745 = op_eq_744 ? 4'he : sel_740;
  assign sel_750 = op_eq_749 ? 4'hd : sel_745;
  assign sel_753 = op_orl_752 ? 4'h0 : sel_734;
  assign sel_754 = proxy_ch_bool_437 ? sel_750 : sel_753;
  assign sel_757 = op_eq_502 ? 4'hc : sel_754;
  assign sel_760 = op_eq_499 ? 4'hb : sel_757;
  assign sel_766 = op_lt_765 ? 4'h1 : 4'ha;
  assign sel_767 = op_eq_490 ? sel_766 : sel_760;
  assign op_ne_446 = io_in_wb != 2'h0;
  assign op_shr_451 = io_in_instruction >> 32'h7;
  assign op_shr_455 = io_in_instruction >> 32'hf;
  assign op_shr_459 = io_in_instruction >> 32'h14;
  assign op_shr_463 = io_in_instruction >> 32'hc;
  assign op_shr_467 = io_in_instruction >> 32'h19;
  assign op_shr_470 = io_in_instruction >> 32'h14;
  assign op_add_474 = io_in_curr_PC + 32'h4;
  assign op_eq_477 = proxy_ch_bit_7u_422 == 7'h33;
  assign op_eq_480 = proxy_ch_bit_7u_422 == 7'h3;
  assign op_eq_483 = proxy_ch_bit_7u_422 == 7'h13;
  assign op_orl_484 = op_eq_483 || op_eq_480;
  assign op_eq_487 = proxy_ch_bit_7u_422 == 7'h23;
  assign op_eq_490 = proxy_ch_bit_7u_422 == 7'h63;
  assign op_eq_493 = proxy_ch_bit_7u_422 == 7'h6f;
  assign op_eq_496 = proxy_ch_bit_7u_422 == 7'h67;
  assign op_eq_499 = proxy_ch_bit_7u_422 == 7'h37;
  assign op_eq_502 = proxy_ch_bit_7u_422 == 7'h17;
  assign op_ne_505 = proxy_slice_464 != 3'h0;
  assign op_eq_508 = proxy_ch_bit_7u_422 == 7'h73;
  assign op_andl_509 = op_eq_508 && op_ne_505;
  assign op_eq_512 = proxy_slice_sliceref_510 == 1'h1;
  assign op_andl_513 = proxy_ch_bool_437 && op_eq_512;
  assign op_eq_515 = proxy_slice_464 == 3'h0;
  assign op_eq_517 = proxy_ch_bit_7u_422 == 7'h73;
  assign op_andl_518 = op_eq_517 && op_eq_515;
  assign op_eq_520 = io_in_src1_fwd == 1'h1;
  assign op_eq_524 = io_in_src2_fwd == 1'h1;
  assign op_pad_527 = {{27{1'b0}}, proxy_io_out_rs1_338};
  assign op_orl_532 = op_orl_484 || op_eq_477;
  assign op_orl_533 = op_orl_532 || op_eq_499;
  assign op_orl_534 = op_orl_533 || op_eq_502;
  assign op_orl_535 = op_orl_534 || proxy_ch_bool_437;
  assign op_orl_542 = op_eq_493 || op_eq_496;
  assign op_orl_543 = op_orl_542 || op_andl_518;
  assign op_orl_547 = op_orl_484 || op_eq_487;
  assign op_shr_560 = io_in_instruction >> 32'hc;
  assign op_shr_566 = io_in_instruction >> 32'h15;
  assign op_pad_573 = {{11{1'b0}}, proxy_cat_571};
  assign op_eq_578 = proxy_ch_uint_1u_569 == 1'h1;
  assign op_pad_583 = {{20{1'b0}}, proxy_cat_581};
  assign op_eq_589 = proxy_cat_sliceref_587 == 1'h1;
  assign op_eq_593 = proxy_slice_464 == 3'h0;
  assign op_lt_596 = proxy_slice_471 < 12'h2;
  assign op_andl_597 = op_eq_593 && op_lt_596;
  assign op_ne_611 = proxy_slice_464 != 3'h0;
  assign op_ge_613 = proxy_slice_471 >= 12'h2;
  assign op_eq_614 = proxy_ch_bit_7u_422 == proxy_ch_bit_7u_422;
  assign op_andl_617 = op_ne_611 && op_ge_613;
  assign op_andl_618 = op_andl_617 && op_eq_614;
  assign op_eq_623 = proxy_slice_464 == 3'h5;
  assign op_eq_626 = proxy_slice_464 == 3'h1;
  assign op_orl_627 = op_eq_626 || op_eq_623;
  assign op_pad_629 = {{7{1'b0}}, proxy_io_out_rs2_342};
  assign op_pad_632 = {{20{1'b0}}, proxy_ch_bit_12u_620};
  assign op_eq_637 = proxy_ch_bit_12u_sliceref_635 == 1'h1;
  assign op_pad_641 = {{20{1'b0}}, proxy_ch_bit_12u_620};
  assign op_eq_646 = proxy_ch_bit_12u_sliceref_644 == 1'h1;
  assign op_pad_651 = {{20{1'b0}}, proxy_slice_471};
  assign op_eq_656 = proxy_slice_sliceref_654 == 1'h1;
  assign op_shr_664 = io_in_instruction >> 32'h8;
  assign op_shr_667 = io_in_instruction >> 32'h19;
  assign op_pad_671 = {{20{1'b0}}, proxy_ch_bit_12u_620};
  assign op_eq_675 = proxy_ch_uint_1u_659 == 1'h1;
  assign op_eq_703 = proxy_ch_bit_7u_422 == 7'h13;
  assign op_eq_709 = proxy_slice_468 == 7'h0;
  assign op_eq_726 = proxy_slice_468 == 7'h0;
  assign op_eq_739 = proxy_slice_735 == 2'h3;
  assign op_eq_744 = proxy_slice_735 == 2'h2;
  assign op_eq_749 = proxy_slice_735 == 2'h1;
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
  assign RegisterFile_404_io_in_write_register = sel_447;
  assign RegisterFile_404_io_in_rd = io_in_rd;
  assign RegisterFile_404_io_in_data = io_in_write_data;
  assign RegisterFile_404_io_in_src1 = proxy_RegisterFile_io_in_src1_414;
  assign RegisterFile_404_io_in_src2 = proxy_RegisterFile_io_in_src2_416;

  assign io_out_csr_address = sel_619;
  assign io_out_is_csr = proxy_io_out_is_csr_332;
  assign io_out_csr_mask = sel_528;
  assign io_out_rd = proxy_io_out_rd_336;
  assign io_out_rs1 = proxy_io_out_rs1_338;
  assign io_out_rd1 = sel_522;
  assign io_out_rs2 = proxy_io_out_rs2_342;
  assign io_out_rd2 = sel_525;
  assign io_out_wb = sel_544;
  assign io_out_alu_op = sel_767;
  assign io_out_rs2_src = sel_548;
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
  reg[4:0] reg_ch_bit_5u_902, reg_ch_bit_5u_905, reg_ch_bit_5u_912;
  reg[31:0] reg_ch_bit_32u_909, reg_ch_bit_32u_915, reg_ch_bit_32u_926, reg_ch_bit_32u_933, reg_ch_bit_32u_958, reg_ch_bit_32u_961, reg_ch_bit_32u_967;
  reg[3:0] reg_ch_bit_4u_919;
  reg[1:0] reg_ch_bit_2u_923;
  reg reg_ch_bit_1u_930, reg_ch_bit_1u_955, reg_ch_bit_1u_964;
  reg[2:0] reg_ch_bit_3u_937, reg_ch_bit_3u_940, reg_ch_bit_3u_944;
  reg[19:0] reg_ch_bit_20u_948;
  reg[11:0] reg_ch_bit_12u_952;
  wire[4:0] sel_975, sel_977, sel_981;
  wire[31:0] sel_979, sel_983, sel_990, sel_995, sel_1009, sel_1013, sel_1015;
  wire[3:0] sel_986;
  wire[1:0] sel_988;
  wire sel_992, sel_1007, sel_1011, op_eq_970, op_eq_972, op_orl_973;
  wire[2:0] sel_997, sel_999, sel_1001;
  wire[19:0] sel_1003;
  wire[11:0] sel_1005;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_902 <= 5'h0;
    else
      reg_ch_bit_5u_902 <= sel_975;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_905 <= 5'h0;
    else
      reg_ch_bit_5u_905 <= sel_977;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_909 <= 32'h0;
    else
      reg_ch_bit_32u_909 <= sel_979;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_912 <= 5'h0;
    else
      reg_ch_bit_5u_912 <= sel_981;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_915 <= 32'h0;
    else
      reg_ch_bit_32u_915 <= sel_983;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_4u_919 <= 4'h0;
    else
      reg_ch_bit_4u_919 <= sel_986;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_923 <= 2'h0;
    else
      reg_ch_bit_2u_923 <= sel_988;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_926 <= 32'h0;
    else
      reg_ch_bit_32u_926 <= sel_990;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_930 <= 1'h0;
    else
      reg_ch_bit_1u_930 <= sel_992;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_933 <= 32'h0;
    else
      reg_ch_bit_32u_933 <= sel_995;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_937 <= 3'h7;
    else
      reg_ch_bit_3u_937 <= sel_997;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_940 <= 3'h7;
    else
      reg_ch_bit_3u_940 <= sel_999;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_944 <= 3'h0;
    else
      reg_ch_bit_3u_944 <= sel_1001;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_20u_948 <= 20'h0;
    else
      reg_ch_bit_20u_948 <= sel_1003;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_952 <= 12'h0;
    else
      reg_ch_bit_12u_952 <= sel_1005;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_955 <= 1'h0;
    else
      reg_ch_bit_1u_955 <= sel_1007;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_958 <= 32'h0;
    else
      reg_ch_bit_32u_958 <= sel_1009;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_961 <= 32'h0;
    else
      reg_ch_bit_32u_961 <= sel_1015;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_964 <= 1'h0;
    else
      reg_ch_bit_1u_964 <= sel_1011;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_967 <= 32'h0;
    else
      reg_ch_bit_32u_967 <= sel_1013;
  end
  assign sel_975 = op_orl_973 ? 5'h0 : io_in_rd;
  assign sel_977 = op_orl_973 ? 5'h0 : io_in_rs1;
  assign sel_979 = op_orl_973 ? 32'h0 : io_in_rd1;
  assign sel_981 = op_orl_973 ? 5'h0 : io_in_rs2;
  assign sel_983 = op_orl_973 ? 32'h0 : io_in_rd2;
  assign sel_986 = op_orl_973 ? 4'hf : io_in_alu_op;
  assign sel_988 = op_orl_973 ? 2'h0 : io_in_wb;
  assign sel_990 = op_orl_973 ? 32'h0 : io_in_PC_next;
  assign sel_992 = op_orl_973 ? 1'h0 : io_in_rs2_src;
  assign sel_995 = op_orl_973 ? 32'h7b : io_in_itype_immed;
  assign sel_997 = op_orl_973 ? 3'h7 : io_in_mem_read;
  assign sel_999 = op_orl_973 ? 3'h7 : io_in_mem_write;
  assign sel_1001 = op_orl_973 ? 3'h0 : io_in_branch_type;
  assign sel_1003 = op_orl_973 ? 20'h0 : io_in_upper_immed;
  assign sel_1005 = op_orl_973 ? 12'h0 : io_in_csr_address;
  assign sel_1007 = op_orl_973 ? 1'h0 : io_in_is_csr;
  assign sel_1009 = op_orl_973 ? 32'h0 : io_in_csr_mask;
  assign sel_1011 = op_orl_973 ? 1'h0 : io_in_jal;
  assign sel_1013 = op_orl_973 ? 32'h0 : io_in_jal_offset;
  assign sel_1015 = op_orl_973 ? 32'h0 : io_in_curr_PC;
  assign op_eq_970 = io_in_branch_stall == 1'h1;
  assign op_eq_972 = io_in_fwd_stall == 1'h1;
  assign op_orl_973 = op_eq_972 || op_eq_970;

  assign io_out_csr_address = reg_ch_bit_12u_952;
  assign io_out_is_csr = reg_ch_bit_1u_955;
  assign io_out_csr_mask = reg_ch_bit_32u_958;
  assign io_out_rd = reg_ch_bit_5u_902;
  assign io_out_rs1 = reg_ch_bit_5u_905;
  assign io_out_rd1 = reg_ch_bit_32u_909;
  assign io_out_rs2 = reg_ch_bit_5u_912;
  assign io_out_rd2 = reg_ch_bit_32u_915;
  assign io_out_alu_op = reg_ch_bit_4u_919;
  assign io_out_wb = reg_ch_bit_2u_923;
  assign io_out_rs2_src = reg_ch_bit_1u_930;
  assign io_out_itype_immed = reg_ch_bit_32u_933;
  assign io_out_mem_read = reg_ch_bit_3u_937;
  assign io_out_mem_write = reg_ch_bit_3u_940;
  assign io_out_branch_type = reg_ch_bit_3u_944;
  assign io_out_upper_immed = reg_ch_bit_20u_948;
  assign io_out_curr_PC = reg_ch_bit_32u_961;
  assign io_out_jal = reg_ch_bit_1u_964;
  assign io_out_jal_offset = reg_ch_bit_32u_967;
  assign io_out_PC_next = reg_ch_bit_32u_926;

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
  wire[11:0] proxy_ch_bit_12u_1163;
  wire[31:0] proxy_cat_1165, sel_1162, sel_1185, sel_1191, sel_1229, op_add_1166, op_add_1168, op_sub_1172, op_shl_1177, op_xorb_1194, op_shr_1199, op_shr_1204, op_orb_1207, op_andb_1210, op_add_1219, op_orb_1223, op_sub_1225, op_andb_1226;
  wire[4:0] proxy_slice_1175, proxy_ch_uint_5u_1176, proxy_slice_1197, proxy_ch_uint_5u_1198, proxy_slice_1202, proxy_ch_uint_5u_1203;
  reg[31:0] sel_1228, sel_1230;
  wire sel_1237, op_eq_1160, op_lt_1184, op_lt_1190, op_ge_1213, op_ne_1236;

  assign proxy_ch_bit_12u_1163 = 12'h0;
  assign proxy_cat_1165 = {io_in_upper_immed, proxy_ch_bit_12u_1163};
  assign proxy_slice_1175 = sel_1162[4:0];
  assign proxy_ch_uint_5u_1176 = proxy_slice_1175;
  assign proxy_slice_1197 = sel_1162[4:0];
  assign proxy_ch_uint_5u_1198 = proxy_slice_1197;
  assign proxy_slice_1202 = sel_1162[4:0];
  assign proxy_ch_uint_5u_1203 = proxy_slice_1202;
  assign sel_1162 = op_eq_1160 ? io_in_itype_immed : io_in_rd2;
  assign sel_1185 = op_lt_1184 ? 32'h1 : 32'h0;
  assign sel_1191 = op_lt_1190 ? 32'h1 : 32'h0;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel_1228 = 32'h7b;
      4'h1: sel_1228 = 32'h7b;
      4'h2: sel_1228 = 32'h7b;
      4'h3: sel_1228 = 32'h7b;
      4'h4: sel_1228 = 32'h7b;
      4'h5: sel_1228 = 32'h7b;
      4'h6: sel_1228 = 32'h7b;
      4'h7: sel_1228 = 32'h7b;
      4'h8: sel_1228 = 32'h7b;
      4'h9: sel_1228 = 32'h7b;
      4'ha: sel_1228 = 32'h7b;
      4'hb: sel_1228 = 32'h7b;
      4'hc: sel_1228 = 32'h7b;
      4'hd: sel_1228 = io_in_csr_mask;
      4'he: sel_1228 = op_orb_1223;
      4'hf: sel_1228 = op_andb_1226;
      default: sel_1228 = 32'h7b;
    endcase
  end
  assign sel_1229 = op_ge_1213 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel_1230 = op_add_1168;
      4'h1: sel_1230 = op_sub_1172;
      4'h2: sel_1230 = op_shl_1177;
      4'h3: sel_1230 = sel_1185;
      4'h4: sel_1230 = sel_1191;
      4'h5: sel_1230 = op_xorb_1194;
      4'h6: sel_1230 = op_shr_1199;
      4'h7: sel_1230 = op_shr_1204;
      4'h8: sel_1230 = op_orb_1207;
      4'h9: sel_1230 = op_andb_1210;
      4'ha: sel_1230 = sel_1229;
      4'hb: sel_1230 = proxy_cat_1165;
      4'hc: sel_1230 = op_add_1219;
      4'hd: sel_1230 = io_in_csr_data;
      4'he: sel_1230 = io_in_csr_data;
      4'hf: sel_1230 = io_in_csr_data;
      default: sel_1230 = 32'h0;
    endcase
  end
  assign sel_1237 = op_ne_1236 ? 1'h1 : 1'h0;
  assign op_eq_1160 = io_in_rs2_src == 1'h1;
  assign op_add_1166 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign op_add_1168 = $signed(io_in_rd1) + $signed(sel_1162);
  assign op_sub_1172 = $signed(io_in_rd1) - $signed(sel_1162);
  assign op_shl_1177 = io_in_rd1 << proxy_ch_uint_5u_1176;
  assign op_lt_1184 = $signed(io_in_rd1) < $signed(sel_1162);
  assign op_lt_1190 = io_in_rd1 < sel_1162;
  assign op_xorb_1194 = io_in_rd1 ^ sel_1162;
  assign op_shr_1199 = io_in_rd1 >> proxy_ch_uint_5u_1198;
  assign op_shr_1204 = $signed(io_in_rd1) >> proxy_ch_uint_5u_1203;
  assign op_orb_1207 = io_in_rd1 | sel_1162;
  assign op_andb_1210 = sel_1162 & io_in_rd1;
  assign op_ge_1213 = io_in_rd1 >= sel_1162;
  assign op_add_1219 = $signed(io_in_curr_PC) + $signed(proxy_cat_1165);
  assign op_orb_1223 = io_in_csr_data | io_in_csr_mask;
  assign op_sub_1225 = 32'hffffffff - io_in_csr_mask;
  assign op_andb_1226 = io_in_csr_data & op_sub_1225;
  assign op_ne_1236 = io_in_branch_type != 3'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel_1228;
  assign io_out_alu_result = sel_1230;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = op_add_1166;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = sel_1237;
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
  reg[31:0] reg_ch_bit_32u_1369, reg_ch_bit_32u_1379, reg_ch_bit_32u_1385, reg_ch_bit_32u_1392, reg_ch_bit_32u_1410, reg_ch_bit_32u_1413, reg_ch_bit_32u_1416;
  reg[4:0] reg_ch_bit_5u_1373, reg_ch_bit_5u_1376, reg_ch_bit_5u_1382;
  reg[1:0] reg_ch_bit_2u_1389;
  reg[2:0] reg_ch_bit_3u_1396, reg_ch_bit_3u_1399, reg_ch_bit_3u_1420;
  reg[11:0] reg_ch_bit_12u_1403;
  reg reg_ch_bit_1u_1407;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1369 <= 32'h0;
    else
      reg_ch_bit_32u_1369 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1373 <= 5'h0;
    else
      reg_ch_bit_5u_1373 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1376 <= 5'h0;
    else
      reg_ch_bit_5u_1376 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1379 <= 32'h0;
    else
      reg_ch_bit_32u_1379 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1382 <= 5'h0;
    else
      reg_ch_bit_5u_1382 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1385 <= 32'h0;
    else
      reg_ch_bit_32u_1385 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1389 <= 2'h0;
    else
      reg_ch_bit_2u_1389 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1392 <= 32'h0;
    else
      reg_ch_bit_32u_1392 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1396 <= 3'h7;
    else
      reg_ch_bit_3u_1396 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1399 <= 3'h7;
    else
      reg_ch_bit_3u_1399 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_1403 <= 12'h0;
    else
      reg_ch_bit_12u_1403 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_1407 <= 1'h0;
    else
      reg_ch_bit_1u_1407 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1410 <= 32'h0;
    else
      reg_ch_bit_32u_1410 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1413 <= 32'h0;
    else
      reg_ch_bit_32u_1413 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1416 <= 32'h0;
    else
      reg_ch_bit_32u_1416 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1420 <= 3'h0;
    else
      reg_ch_bit_3u_1420 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg_ch_bit_12u_1403;
  assign io_out_is_csr = reg_ch_bit_1u_1407;
  assign io_out_csr_result = reg_ch_bit_32u_1410;
  assign io_out_alu_result = reg_ch_bit_32u_1369;
  assign io_out_rd = reg_ch_bit_5u_1373;
  assign io_out_wb = reg_ch_bit_2u_1389;
  assign io_out_rs1 = reg_ch_bit_5u_1376;
  assign io_out_rd1 = reg_ch_bit_32u_1379;
  assign io_out_rd2 = reg_ch_bit_32u_1385;
  assign io_out_rs2 = reg_ch_bit_5u_1382;
  assign io_out_mem_read = reg_ch_bit_3u_1396;
  assign io_out_mem_write = reg_ch_bit_3u_1399;
  assign io_out_curr_PC = reg_ch_bit_32u_1413;
  assign io_out_branch_offset = reg_ch_bit_32u_1416;
  assign io_out_branch_type = reg_ch_bit_3u_1420;
  assign io_out_PC_next = reg_ch_bit_32u_1392;

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
  wire proxy_io_DBUS_out_miss_1544, proxy_io_DBUS_out_control_valid_1564, proxy_io_out_delay_1571, proxy_ch_bool_1582, proxy_ch_bool_1586, proxy_ch_bool_1588, op_lt_1577, op_lt_1579, op_orl_1580, op_orl_1584, op_orl_1585;
  wire[2:0] sel_1581;

  assign proxy_io_DBUS_out_miss_1544 = proxy_ch_bool_1586;
  assign proxy_io_DBUS_out_control_valid_1564 = proxy_ch_bool_1582;
  assign proxy_io_out_delay_1571 = proxy_ch_bool_1588;
  assign proxy_ch_bool_1582 = 1'h1;
  assign proxy_ch_bool_1586 = 1'h0;
  assign proxy_ch_bool_1588 = 1'h0;
  assign sel_1581 = op_lt_1577 ? io_in_mem_write : io_in_mem_read;
  assign op_lt_1577 = io_in_mem_write < 3'h7;
  assign op_lt_1579 = io_in_mem_read < 3'h7;
  assign op_orl_1580 = op_lt_1577 || op_lt_1579;
  assign op_orl_1584 = op_lt_1577 || op_lt_1579;
  assign op_orl_1585 = op_lt_1577 || op_lt_1579;

  assign io_DBUS_out_miss = proxy_io_DBUS_out_miss_1544;
  assign io_DBUS_out_rw = op_lt_1577;
  assign io_DBUS_in_data_ready = op_orl_1585;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = op_orl_1584;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = op_orl_1580;
  assign io_DBUS_out_control_data = sel_1581;
  assign io_DBUS_out_control_valid = proxy_io_DBUS_out_control_valid_1564;
  assign io_out_delay = proxy_io_out_delay_1571;
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
  wire proxy_io_DBUS_out_miss_1488, proxy_io_DBUS_out_rw_1490, proxy_io_DBUS_in_data_ready_1494, proxy_io_DBUS_out_data_valid_1498, proxy_io_DBUS_out_address_valid_1503, proxy_io_DBUS_out_control_valid_1508, proxy_io_out_delay_1540, proxy_Cache_driver_io_DBUS_out_miss_1590, proxy_Cache_driver_io_DBUS_out_rw_1592, proxy_Cache_driver_io_DBUS_in_data_ready_1598, proxy_Cache_driver_io_DBUS_out_data_valid_1602, proxy_Cache_driver_io_DBUS_out_address_valid_1608, proxy_Cache_driver_io_DBUS_out_control_valid_1614, proxy_Cache_driver_io_out_delay_1626, sel_1642, sel_1648, sel_1655, sel_1662, sel_1669, sel_1676, op_eq_1641, op_eq_1647, op_eq_1654, op_eq_1661, op_eq_1668, op_eq_1675, Cache_driver_1589_io_DBUS_out_miss, Cache_driver_1589_io_DBUS_out_rw, Cache_driver_1589_io_DBUS_in_data_valid, Cache_driver_1589_io_DBUS_in_data_ready, Cache_driver_1589_io_DBUS_out_data_valid, Cache_driver_1589_io_DBUS_out_data_ready, Cache_driver_1589_io_DBUS_out_address_valid, Cache_driver_1589_io_DBUS_out_address_ready, Cache_driver_1589_io_DBUS_out_control_valid, Cache_driver_1589_io_DBUS_out_control_ready, Cache_driver_1589_io_out_delay;
  wire[31:0] proxy_io_DBUS_out_data_data_1496, proxy_io_DBUS_out_address_data_1501, proxy_io_out_mem_result_1526, proxy_Cache_driver_io_DBUS_out_data_data_1600, proxy_Cache_driver_io_DBUS_out_address_data_1606, proxy_Cache_driver_io_out_data_1628, op_shl_1632, op_add_1633, Cache_driver_1589_io_DBUS_in_data_data, Cache_driver_1589_io_DBUS_out_data_data, Cache_driver_1589_io_DBUS_out_address_data, Cache_driver_1589_io_in_address, Cache_driver_1589_io_in_data, Cache_driver_1589_io_out_data;
  wire[2:0] proxy_io_DBUS_out_control_data_1506, proxy_Cache_driver_io_DBUS_out_control_data_1612, Cache_driver_1589_io_DBUS_out_control_data, Cache_driver_1589_io_in_mem_read, Cache_driver_1589_io_in_mem_write;
  reg sel_1680;

  assign proxy_io_DBUS_out_miss_1488 = proxy_Cache_driver_io_DBUS_out_miss_1590;
  assign proxy_io_DBUS_out_rw_1490 = proxy_Cache_driver_io_DBUS_out_rw_1592;
  assign proxy_io_DBUS_in_data_ready_1494 = proxy_Cache_driver_io_DBUS_in_data_ready_1598;
  assign proxy_io_DBUS_out_data_data_1496 = proxy_Cache_driver_io_DBUS_out_data_data_1600;
  assign proxy_io_DBUS_out_data_valid_1498 = proxy_Cache_driver_io_DBUS_out_data_valid_1602;
  assign proxy_io_DBUS_out_address_data_1501 = proxy_Cache_driver_io_DBUS_out_address_data_1606;
  assign proxy_io_DBUS_out_address_valid_1503 = proxy_Cache_driver_io_DBUS_out_address_valid_1608;
  assign proxy_io_DBUS_out_control_data_1506 = proxy_Cache_driver_io_DBUS_out_control_data_1612;
  assign proxy_io_DBUS_out_control_valid_1508 = proxy_Cache_driver_io_DBUS_out_control_valid_1614;
  assign proxy_io_out_mem_result_1526 = proxy_Cache_driver_io_out_data_1628;
  assign proxy_io_out_delay_1540 = proxy_Cache_driver_io_out_delay_1626;
  assign proxy_Cache_driver_io_DBUS_out_miss_1590 = Cache_driver_1589_io_DBUS_out_miss;
  assign proxy_Cache_driver_io_DBUS_out_rw_1592 = Cache_driver_1589_io_DBUS_out_rw;
  assign proxy_Cache_driver_io_DBUS_in_data_ready_1598 = Cache_driver_1589_io_DBUS_in_data_ready;
  assign proxy_Cache_driver_io_DBUS_out_data_data_1600 = Cache_driver_1589_io_DBUS_out_data_data;
  assign proxy_Cache_driver_io_DBUS_out_data_valid_1602 = Cache_driver_1589_io_DBUS_out_data_valid;
  assign proxy_Cache_driver_io_DBUS_out_address_data_1606 = Cache_driver_1589_io_DBUS_out_address_data;
  assign proxy_Cache_driver_io_DBUS_out_address_valid_1608 = Cache_driver_1589_io_DBUS_out_address_valid;
  assign proxy_Cache_driver_io_DBUS_out_control_data_1612 = Cache_driver_1589_io_DBUS_out_control_data;
  assign proxy_Cache_driver_io_DBUS_out_control_valid_1614 = Cache_driver_1589_io_DBUS_out_control_valid;
  assign proxy_Cache_driver_io_out_delay_1626 = Cache_driver_1589_io_out_delay;
  assign proxy_Cache_driver_io_out_data_1628 = Cache_driver_1589_io_out_data;
  assign sel_1642 = op_eq_1641 ? 1'h1 : 1'h0;
  assign sel_1648 = op_eq_1647 ? 1'h0 : 1'h1;
  assign sel_1655 = op_eq_1654 ? 1'h0 : 1'h1;
  assign sel_1662 = op_eq_1661 ? 1'h1 : 1'h0;
  assign sel_1669 = op_eq_1668 ? 1'h0 : 1'h1;
  assign sel_1676 = op_eq_1675 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h0: sel_1680 = 1'h0;
      3'h1: sel_1680 = sel_1642;
      3'h2: sel_1680 = sel_1648;
      3'h3: sel_1680 = sel_1655;
      3'h4: sel_1680 = sel_1662;
      3'h5: sel_1680 = sel_1669;
      3'h6: sel_1680 = sel_1676;
      default: sel_1680 = 1'h0;
    endcase
  end
  assign op_shl_1632 = io_in_branch_offset << 32'h1;
  assign op_add_1633 = $signed(io_in_curr_PC) + $signed(op_shl_1632);
  assign op_eq_1641 = io_in_alu_result == 32'h0;
  assign op_eq_1647 = io_in_alu_result == 32'h0;
  assign op_eq_1654 = io_in_alu_result[31] == 1'h0;
  assign op_eq_1661 = io_in_alu_result[31] == 1'h0;
  assign op_eq_1668 = io_in_alu_result[31] == 1'h0;
  assign op_eq_1675 = io_in_alu_result[31] == 1'h0;
  Cache_driver Cache_driver_1589(
    .io_DBUS_in_data_data(Cache_driver_1589_io_DBUS_in_data_data),
    .io_DBUS_in_data_valid(Cache_driver_1589_io_DBUS_in_data_valid),
    .io_DBUS_out_data_ready(Cache_driver_1589_io_DBUS_out_data_ready),
    .io_DBUS_out_address_ready(Cache_driver_1589_io_DBUS_out_address_ready),
    .io_DBUS_out_control_ready(Cache_driver_1589_io_DBUS_out_control_ready),
    .io_in_address(Cache_driver_1589_io_in_address),
    .io_in_mem_read(Cache_driver_1589_io_in_mem_read),
    .io_in_mem_write(Cache_driver_1589_io_in_mem_write),
    .io_in_data(Cache_driver_1589_io_in_data),
    .io_DBUS_out_miss(Cache_driver_1589_io_DBUS_out_miss),
    .io_DBUS_out_rw(Cache_driver_1589_io_DBUS_out_rw),
    .io_DBUS_in_data_ready(Cache_driver_1589_io_DBUS_in_data_ready),
    .io_DBUS_out_data_data(Cache_driver_1589_io_DBUS_out_data_data),
    .io_DBUS_out_data_valid(Cache_driver_1589_io_DBUS_out_data_valid),
    .io_DBUS_out_address_data(Cache_driver_1589_io_DBUS_out_address_data),
    .io_DBUS_out_address_valid(Cache_driver_1589_io_DBUS_out_address_valid),
    .io_DBUS_out_control_data(Cache_driver_1589_io_DBUS_out_control_data),
    .io_DBUS_out_control_valid(Cache_driver_1589_io_DBUS_out_control_valid),
    .io_out_delay(Cache_driver_1589_io_out_delay),
    .io_out_data(Cache_driver_1589_io_out_data));
  assign Cache_driver_1589_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Cache_driver_1589_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Cache_driver_1589_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Cache_driver_1589_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Cache_driver_1589_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Cache_driver_1589_io_in_address = io_in_alu_result;
  assign Cache_driver_1589_io_in_mem_read = io_in_mem_read;
  assign Cache_driver_1589_io_in_mem_write = io_in_mem_write;
  assign Cache_driver_1589_io_in_data = io_in_rd2;

  assign io_DBUS_out_miss = proxy_io_DBUS_out_miss_1488;
  assign io_DBUS_out_rw = proxy_io_DBUS_out_rw_1490;
  assign io_DBUS_in_data_ready = proxy_io_DBUS_in_data_ready_1494;
  assign io_DBUS_out_data_data = proxy_io_DBUS_out_data_data_1496;
  assign io_DBUS_out_data_valid = proxy_io_DBUS_out_data_valid_1498;
  assign io_DBUS_out_address_data = proxy_io_DBUS_out_address_data_1501;
  assign io_DBUS_out_address_valid = proxy_io_DBUS_out_address_valid_1503;
  assign io_DBUS_out_control_data = proxy_io_DBUS_out_control_data_1506;
  assign io_DBUS_out_control_valid = proxy_io_DBUS_out_control_valid_1508;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = proxy_io_out_mem_result_1526;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel_1680;
  assign io_out_branch_dest = op_add_1633;
  assign io_out_delay = proxy_io_out_delay_1540;
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
  reg[31:0] reg_ch_bit_32u_1783, reg_ch_bit_32u_1786, reg_ch_bit_32u_1803;
  reg[4:0] reg_ch_bit_5u_1790, reg_ch_bit_5u_1793, reg_ch_bit_5u_1796;
  reg[1:0] reg_ch_bit_2u_1800;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1783 <= 32'h0;
    else
      reg_ch_bit_32u_1783 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1786 <= 32'h0;
    else
      reg_ch_bit_32u_1786 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1790 <= 5'h0;
    else
      reg_ch_bit_5u_1790 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1793 <= 5'h0;
    else
      reg_ch_bit_5u_1793 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1796 <= 5'h0;
    else
      reg_ch_bit_5u_1796 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1800 <= 2'h0;
    else
      reg_ch_bit_2u_1800 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1803 <= 32'h0;
    else
      reg_ch_bit_32u_1803 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg_ch_bit_32u_1783;
  assign io_out_mem_result = reg_ch_bit_32u_1786;
  assign io_out_rd = reg_ch_bit_5u_1790;
  assign io_out_wb = reg_ch_bit_2u_1800;
  assign io_out_rs1 = reg_ch_bit_5u_1793;
  assign io_out_rs2 = reg_ch_bit_5u_1796;
  assign io_out_PC_next = reg_ch_bit_32u_1803;

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
  wire[31:0] sel_1854, sel_1855;
  wire op_eq_1850, op_eq_1853;

  assign sel_1854 = op_eq_1853 ? io_in_alu_result : io_in_mem_result;
  assign sel_1855 = op_eq_1850 ? io_in_PC_next : sel_1854;
  assign op_eq_1850 = io_in_wb == 2'h3;
  assign op_eq_1853 = io_in_wb == 2'h1;

  assign io_out_write_data = sel_1855;
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
  wire sel_2005, op_eq_1916, op_eq_1918, op_eq_1920, op_eq_1923, op_eq_1925, op_eq_1927, op_eq_1930, op_eq_1932, op_ne_1935, op_ne_1938, op_eq_1939, op_andl_1940, op_andl_1941, op_notl_1942, op_ne_1944, op_ne_1946, op_eq_1947, op_andl_1948, op_andl_1949, op_andl_1950, op_notl_1951, op_notl_1952, op_ne_1954, op_ne_1956, op_eq_1957, op_andl_1958, op_andl_1959, op_andl_1960, op_andl_1961, op_orl_1962, op_orl_1963, op_ne_1965, op_ne_1967, op_eq_1968, op_andl_1969, op_andl_1970, op_notl_1971, op_ne_1973, op_ne_1975, op_eq_1976, op_andl_1977, op_andl_1978, op_andl_1979, op_notl_1980, op_notl_1981, op_ne_1983, op_ne_1985, op_eq_1986, op_andl_1987, op_andl_1988, op_andl_1989, op_andl_1990, op_orl_1991, op_orl_1992, op_eq_1993, op_andl_1994, op_notl_1995, op_eq_1996, op_andl_1997, op_andl_1998, op_orl_1999, op_orl_2003, op_andl_2004;
  wire[31:0] sel_2008, sel_2009, sel_2010, sel_2011, sel_2012, sel_2013, sel_2014, sel_2015, sel_2017, sel_2018, sel_2019, sel_2020, sel_2021, sel_2022, sel_2023, sel_2024, sel_2026, sel_2027;

  assign sel_2005 = op_andl_2004 ? 1'h1 : 1'h0;
  assign sel_2008 = op_eq_1920 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel_2009 = op_eq_1927 ? io_in_writeback_PC_next : sel_2008;
  assign sel_2010 = op_andl_1961 ? sel_2009 : 32'h7b;
  assign sel_2011 = op_eq_1918 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel_2012 = op_eq_1925 ? io_in_memory_PC_next : sel_2011;
  assign sel_2013 = op_andl_1950 ? sel_2012 : sel_2010;
  assign sel_2014 = op_eq_1923 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel_2015 = op_andl_1941 ? sel_2014 : sel_2013;
  assign sel_2017 = op_eq_1920 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel_2018 = op_eq_1927 ? io_in_writeback_PC_next : sel_2017;
  assign sel_2019 = op_andl_1990 ? sel_2018 : 32'h7b;
  assign sel_2020 = op_eq_1918 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel_2021 = op_eq_1925 ? io_in_memory_PC_next : sel_2020;
  assign sel_2022 = op_andl_1979 ? sel_2021 : sel_2019;
  assign sel_2023 = op_eq_1923 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel_2024 = op_andl_1970 ? sel_2023 : sel_2022;
  assign sel_2026 = op_andl_1998 ? io_in_memory_csr_result : 32'h7b;
  assign sel_2027 = op_andl_1994 ? io_in_execute_alu_result : sel_2026;
  assign op_eq_1916 = io_in_execute_wb == 2'h2;
  assign op_eq_1918 = io_in_memory_wb == 2'h2;
  assign op_eq_1920 = io_in_writeback_wb == 2'h2;
  assign op_eq_1923 = io_in_execute_wb == 2'h3;
  assign op_eq_1925 = io_in_memory_wb == 2'h3;
  assign op_eq_1927 = io_in_writeback_wb == 2'h3;
  assign op_eq_1930 = io_in_execute_is_csr == 1'h1;
  assign op_eq_1932 = io_in_memory_is_csr == 1'h1;
  assign op_ne_1935 = io_in_execute_wb != 2'h0;
  assign op_ne_1938 = io_in_decode_src1 != 5'h0;
  assign op_eq_1939 = io_in_decode_src1 == io_in_execute_dest;
  assign op_andl_1940 = op_eq_1939 && op_ne_1938;
  assign op_andl_1941 = op_andl_1940 && op_ne_1935;
  assign op_notl_1942 = !op_andl_1941;
  assign op_ne_1944 = io_in_memory_wb != 2'h0;
  assign op_ne_1946 = io_in_decode_src1 != 5'h0;
  assign op_eq_1947 = io_in_decode_src1 == io_in_memory_dest;
  assign op_andl_1948 = op_eq_1947 && op_ne_1946;
  assign op_andl_1949 = op_andl_1948 && op_ne_1944;
  assign op_andl_1950 = op_andl_1949 && op_notl_1942;
  assign op_notl_1951 = !op_andl_1950;
  assign op_notl_1952 = !op_andl_1941;
  assign op_ne_1954 = io_in_writeback_wb != 2'h0;
  assign op_ne_1956 = io_in_decode_src1 != 5'h0;
  assign op_eq_1957 = io_in_decode_src1 == io_in_writeback_dest;
  assign op_andl_1958 = op_eq_1957 && op_ne_1956;
  assign op_andl_1959 = op_andl_1958 && op_ne_1954;
  assign op_andl_1960 = op_andl_1959 && op_notl_1952;
  assign op_andl_1961 = op_andl_1960 && op_notl_1951;
  assign op_orl_1962 = op_andl_1941 || op_andl_1950;
  assign op_orl_1963 = op_orl_1962 || op_andl_1961;
  assign op_ne_1965 = io_in_execute_wb != 2'h0;
  assign op_ne_1967 = io_in_decode_src2 != 5'h0;
  assign op_eq_1968 = io_in_decode_src2 == io_in_execute_dest;
  assign op_andl_1969 = op_eq_1968 && op_ne_1967;
  assign op_andl_1970 = op_andl_1969 && op_ne_1965;
  assign op_notl_1971 = !op_andl_1970;
  assign op_ne_1973 = io_in_memory_wb != 2'h0;
  assign op_ne_1975 = io_in_decode_src2 != 5'h0;
  assign op_eq_1976 = io_in_decode_src2 == io_in_memory_dest;
  assign op_andl_1977 = op_eq_1976 && op_ne_1975;
  assign op_andl_1978 = op_andl_1977 && op_ne_1973;
  assign op_andl_1979 = op_andl_1978 && op_notl_1971;
  assign op_notl_1980 = !op_andl_1979;
  assign op_notl_1981 = !op_andl_1970;
  assign op_ne_1983 = io_in_writeback_wb != 2'h0;
  assign op_ne_1985 = io_in_decode_src2 != 5'h0;
  assign op_eq_1986 = io_in_decode_src2 == io_in_writeback_dest;
  assign op_andl_1987 = op_eq_1986 && op_ne_1985;
  assign op_andl_1988 = op_andl_1987 && op_ne_1983;
  assign op_andl_1989 = op_andl_1988 && op_notl_1981;
  assign op_andl_1990 = op_andl_1989 && op_notl_1980;
  assign op_orl_1991 = op_andl_1970 || op_andl_1979;
  assign op_orl_1992 = op_orl_1991 || op_andl_1990;
  assign op_eq_1993 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign op_andl_1994 = op_eq_1993 && op_eq_1930;
  assign op_notl_1995 = !op_andl_1994;
  assign op_eq_1996 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign op_andl_1997 = op_eq_1996 && op_eq_1932;
  assign op_andl_1998 = op_andl_1997 && op_notl_1995;
  assign op_orl_1999 = op_andl_1994 || op_andl_1998;
  assign op_orl_2003 = op_andl_1941 || op_andl_1970;
  assign op_andl_2004 = op_orl_2003 && op_eq_1916;

  assign io_out_src1_fwd = op_orl_1963;
  assign io_out_src2_fwd = op_orl_1992;
  assign io_out_csr_fwd = op_orl_1999;
  assign io_out_src1_fwd_data = sel_2015;
  assign io_out_src2_fwd_data = sel_2024;
  assign io_out_csr_fwd_data = sel_2027;
  assign io_out_fwd_stall = sel_2005;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem_ch_bit_32u_2098 [0:1];
  wire[31:0] marport_ch_bit_32u_2100, sel_2103;
  wire proxy_ch_uint_1u_2099;

  initial begin
    mem_ch_bit_32u_2098[0] = 32'h70000000;
    mem_ch_bit_32u_2098[1] = 32'hdeadbeef;
  end
  assign marport_ch_bit_32u_2100 = mem_ch_bit_32u_2098[proxy_ch_uint_1u_2099];
  assign proxy_ch_uint_1u_2099 = io_INTERRUPT_in_interrupt_id_data;
  assign sel_2103 = io_INTERRUPT_in_interrupt_id_valid ? marport_ch_bit_32u_2100 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = 1'h1;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel_2103;

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
  reg[3:0] reg_ch_bit_4u_2157, sel_2225;
  wire[3:0] sel_2165, sel_2169, sel_2174, sel_2179, sel_2182, sel_2187, sel_2191, sel_2194, sel_2197, sel_2201, sel_2206, sel_2209, sel_2214, sel_2218, sel_2221, sel_2224, sel_2226, sel_2234, sel_2235, sel_2236, sel_2237;
  wire op_eq_2160, op_andl_2227, op_eq_2229, op_andl_2231, op_eq_2233;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_4u_2157 <= 4'h0;
    else
      reg_ch_bit_4u_2157 <= sel_2237;
  end
  assign sel_2165 = op_eq_2160 ? 4'h0 : 4'h1;
  assign sel_2169 = op_eq_2160 ? 4'h2 : 4'h1;
  assign sel_2174 = op_eq_2160 ? 4'h9 : 4'h3;
  assign sel_2179 = op_eq_2160 ? 4'h5 : 4'h4;
  assign sel_2182 = op_eq_2160 ? 4'h5 : 4'h4;
  assign sel_2187 = op_eq_2160 ? 4'h8 : 4'h6;
  assign sel_2191 = op_eq_2160 ? 4'h7 : 4'h6;
  assign sel_2194 = op_eq_2160 ? 4'h4 : 4'h8;
  assign sel_2197 = op_eq_2160 ? 4'h2 : 4'h1;
  assign sel_2201 = op_eq_2160 ? 4'h0 : 4'ha;
  assign sel_2206 = op_eq_2160 ? 4'hc : 4'hb;
  assign sel_2209 = op_eq_2160 ? 4'hc : 4'hb;
  assign sel_2214 = op_eq_2160 ? 4'hf : 4'hd;
  assign sel_2218 = op_eq_2160 ? 4'he : 4'hd;
  assign sel_2221 = op_eq_2160 ? 4'hf : 4'hb;
  assign sel_2224 = op_eq_2160 ? 4'h2 : 4'h1;
  always @(*) begin
    case (reg_ch_bit_4u_2157)
      4'h0: sel_2225 = sel_2165;
      4'h1: sel_2225 = sel_2169;
      4'h2: sel_2225 = sel_2174;
      4'h3: sel_2225 = sel_2179;
      4'h4: sel_2225 = sel_2182;
      4'h5: sel_2225 = sel_2187;
      4'h6: sel_2225 = sel_2191;
      4'h7: sel_2225 = sel_2194;
      4'h8: sel_2225 = sel_2197;
      4'h9: sel_2225 = sel_2201;
      4'ha: sel_2225 = sel_2206;
      4'hb: sel_2225 = sel_2209;
      4'hc: sel_2225 = sel_2214;
      4'hd: sel_2225 = sel_2218;
      4'he: sel_2225 = sel_2221;
      4'hf: sel_2225 = sel_2224;
      default: sel_2225 = reg_ch_bit_4u_2157;
    endcase
  end
  assign sel_2226 = io_JTAG_TAP_in_mode_select_valid ? sel_2225 : 4'h0;
  assign sel_2234 = op_eq_2229 ? 4'h0 : reg_ch_bit_4u_2157;
  assign sel_2235 = op_eq_2233 ? sel_2226 : reg_ch_bit_4u_2157;
  assign sel_2236 = op_andl_2231 ? sel_2235 : reg_ch_bit_4u_2157;
  assign sel_2237 = op_andl_2227 ? sel_2234 : sel_2236;
  assign op_eq_2160 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign op_andl_2227 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_reset_valid;
  assign op_eq_2229 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign op_andl_2231 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_clock_valid;
  assign op_eq_2233 = io_JTAG_TAP_in_clock_data == 1'h1;

  assign io_JTAG_TAP_in_mode_select_ready = 1'h1;
  assign io_JTAG_TAP_in_clock_ready = 1'h1;
  assign io_JTAG_TAP_in_reset_ready = 1'h1;
  assign io_out_curr_state = reg_ch_bit_4u_2157;

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
  reg[31:0] reg_ch_bit_32u_2267, reg_ch_bit_32u_2271, reg_ch_bit_32u_2275, reg_ch_bit_32u_2280, sel_2322, sel_2324, sel_2325, sel_2326;
  wire proxy_io_JTAG_JTAG_TAP_in_mode_select_ready_2117, proxy_io_JTAG_JTAG_TAP_in_clock_ready_2121, proxy_io_JTAG_JTAG_TAP_in_reset_ready_2125, proxy_TAP_io_JTAG_TAP_in_mode_select_ready_2248, proxy_TAP_io_JTAG_TAP_in_clock_ready_2254, proxy_TAP_io_JTAG_TAP_in_reset_ready_2260, sel_2327, sel_2328, sel_2329, sel_2330, sel_2331, sel_2333, sel_2334, sel_2335, sel_2336, sel_2337, op_eq_2283, op_eq_2287, op_eq_2290, op_eq_2302, op_eq_2304, op_eq_2306, op_eq_2309, op_eq_2317, op_eq_2319, TAP_2238_clk, TAP_2238_reset, TAP_2238_io_JTAG_TAP_in_mode_select_data, TAP_2238_io_JTAG_TAP_in_mode_select_valid, TAP_2238_io_JTAG_TAP_in_mode_select_ready, TAP_2238_io_JTAG_TAP_in_clock_data, TAP_2238_io_JTAG_TAP_in_clock_valid, TAP_2238_io_JTAG_TAP_in_clock_ready, TAP_2238_io_JTAG_TAP_in_reset_data, TAP_2238_io_JTAG_TAP_in_reset_valid, TAP_2238_io_JTAG_TAP_in_reset_ready;
  wire[3:0] proxy_TAP_io_out_curr_state_2262, proxy_ch_bit_4u_2277, TAP_2238_io_out_curr_state;
  wire[30:0] proxy_slice_2298, proxy_slice_2313;
  wire[31:0] proxy_cat_2299, proxy_cat_2314, sel_2292, sel_2293, sel_2320, sel_2321, sel_2323, op_shr_2297, op_shr_2312;
  reg sel_2332, sel_2338;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2267 <= 32'h0;
    else
      reg_ch_bit_32u_2267 <= sel_2326;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2271 <= 32'h1234;
    else
      reg_ch_bit_32u_2271 <= sel_2322;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2275 <= 32'h5678;
    else
      reg_ch_bit_32u_2275 <= sel_2324;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2280 <= 32'h0;
    else
      reg_ch_bit_32u_2280 <= sel_2325;
  end
  assign proxy_io_JTAG_JTAG_TAP_in_mode_select_ready_2117 = proxy_TAP_io_JTAG_TAP_in_mode_select_ready_2248;
  assign proxy_io_JTAG_JTAG_TAP_in_clock_ready_2121 = proxy_TAP_io_JTAG_TAP_in_clock_ready_2254;
  assign proxy_io_JTAG_JTAG_TAP_in_reset_ready_2125 = proxy_TAP_io_JTAG_TAP_in_reset_ready_2260;
  assign proxy_TAP_io_JTAG_TAP_in_mode_select_ready_2248 = TAP_2238_io_JTAG_TAP_in_mode_select_ready;
  assign proxy_TAP_io_JTAG_TAP_in_clock_ready_2254 = TAP_2238_io_JTAG_TAP_in_clock_ready;
  assign proxy_TAP_io_JTAG_TAP_in_reset_ready_2260 = TAP_2238_io_JTAG_TAP_in_reset_ready;
  assign proxy_TAP_io_out_curr_state_2262 = TAP_2238_io_out_curr_state;
  assign proxy_ch_bit_4u_2277 = proxy_TAP_io_out_curr_state_2262;
  assign proxy_slice_2298 = op_shr_2297[30:0];
  assign proxy_cat_2299 = {io_JTAG_in_data_data, proxy_slice_2298};
  assign proxy_slice_2313 = op_shr_2312[30:0];
  assign proxy_cat_2314 = {io_JTAG_in_data_data, proxy_slice_2313};
  assign sel_2292 = op_eq_2290 ? reg_ch_bit_32u_2271 : 32'hdeadbeef;
  assign sel_2293 = op_eq_2287 ? reg_ch_bit_32u_2275 : sel_2292;
  assign sel_2320 = op_eq_2306 ? reg_ch_bit_32u_2280 : reg_ch_bit_32u_2271;
  assign sel_2321 = op_eq_2304 ? reg_ch_bit_32u_2271 : sel_2320;
  always @(*) begin
    case (proxy_ch_bit_4u_2277)
      4'h3: sel_2322 = reg_ch_bit_32u_2271;
      4'h4: sel_2322 = reg_ch_bit_32u_2271;
      4'h8: sel_2322 = sel_2321;
      4'ha: sel_2322 = reg_ch_bit_32u_2271;
      4'hb: sel_2322 = reg_ch_bit_32u_2271;
      4'hf: sel_2322 = reg_ch_bit_32u_2271;
      default: sel_2322 = reg_ch_bit_32u_2271;
    endcase
  end
  assign sel_2323 = op_eq_2304 ? reg_ch_bit_32u_2280 : reg_ch_bit_32u_2275;
  always @(*) begin
    case (proxy_ch_bit_4u_2277)
      4'h3: sel_2324 = reg_ch_bit_32u_2275;
      4'h4: sel_2324 = reg_ch_bit_32u_2275;
      4'h8: sel_2324 = sel_2323;
      4'ha: sel_2324 = reg_ch_bit_32u_2275;
      4'hb: sel_2324 = reg_ch_bit_32u_2275;
      4'hf: sel_2324 = reg_ch_bit_32u_2275;
      default: sel_2324 = reg_ch_bit_32u_2275;
    endcase
  end
  always @(*) begin
    case (proxy_ch_bit_4u_2277)
      4'h3: sel_2325 = sel_2293;
      4'h4: sel_2325 = proxy_cat_2299;
      4'h8: sel_2325 = reg_ch_bit_32u_2280;
      4'ha: sel_2325 = reg_ch_bit_32u_2267;
      4'hb: sel_2325 = proxy_cat_2314;
      4'hf: sel_2325 = reg_ch_bit_32u_2280;
      default: sel_2325 = reg_ch_bit_32u_2280;
    endcase
  end
  always @(*) begin
    case (proxy_ch_bit_4u_2277)
      4'h3: sel_2326 = reg_ch_bit_32u_2267;
      4'h4: sel_2326 = reg_ch_bit_32u_2267;
      4'h8: sel_2326 = reg_ch_bit_32u_2267;
      4'ha: sel_2326 = reg_ch_bit_32u_2267;
      4'hb: sel_2326 = reg_ch_bit_32u_2267;
      4'hf: sel_2326 = reg_ch_bit_32u_2280;
      default: sel_2326 = reg_ch_bit_32u_2267;
    endcase
  end
  assign sel_2327 = op_eq_2283 ? 1'h1 : 1'h0;
  assign sel_2328 = op_eq_2302 ? 1'h1 : 1'h0;
  assign sel_2329 = op_eq_2309 ? 1'h1 : 1'h0;
  assign sel_2330 = op_eq_2317 ? 1'h1 : 1'h0;
  assign sel_2331 = op_eq_2319 ? 1'h1 : 1'h0;
  always @(*) begin
    case (proxy_ch_bit_4u_2277)
      4'h3: sel_2332 = sel_2327;
      4'h4: sel_2332 = 1'h1;
      4'h8: sel_2332 = sel_2328;
      4'ha: sel_2332 = sel_2329;
      4'hb: sel_2332 = 1'h1;
      4'hf: sel_2332 = sel_2330;
      default: sel_2332 = sel_2331;
    endcase
  end
  assign sel_2333 = op_eq_2283 ? 1'h0 : 1'h0;
  assign sel_2334 = op_eq_2302 ? 1'h0 : 1'h0;
  assign sel_2335 = op_eq_2309 ? 1'h0 : 1'h0;
  assign sel_2336 = op_eq_2317 ? 1'h0 : 1'h0;
  assign sel_2337 = op_eq_2319 ? 1'h0 : 1'h0;
  always @(*) begin
    case (proxy_ch_bit_4u_2277)
      4'h3: sel_2338 = sel_2333;
      4'h4: sel_2338 = reg_ch_bit_32u_2280[0];
      4'h8: sel_2338 = sel_2334;
      4'ha: sel_2338 = sel_2335;
      4'hb: sel_2338 = 1'h0;
      4'hf: sel_2338 = sel_2336;
      default: sel_2338 = sel_2337;
    endcase
  end
  assign op_eq_2283 = reg_ch_bit_32u_2267 == 32'h0;
  assign op_eq_2287 = reg_ch_bit_32u_2267 == 32'h1;
  assign op_eq_2290 = reg_ch_bit_32u_2267 == 32'h2;
  assign op_shr_2297 = reg_ch_bit_32u_2280 >> 32'h1;
  assign op_eq_2302 = reg_ch_bit_32u_2267 == 32'h0;
  assign op_eq_2304 = reg_ch_bit_32u_2267 == 32'h1;
  assign op_eq_2306 = reg_ch_bit_32u_2267 == 32'h2;
  assign op_eq_2309 = reg_ch_bit_32u_2267 == 32'h0;
  assign op_shr_2312 = reg_ch_bit_32u_2280 >> 32'h1;
  assign op_eq_2317 = reg_ch_bit_32u_2267 == 32'h0;
  assign op_eq_2319 = reg_ch_bit_32u_2267 == 32'h0;
  TAP TAP_2238(
    .io_JTAG_TAP_in_mode_select_data(TAP_2238_io_JTAG_TAP_in_mode_select_data),
    .io_JTAG_TAP_in_mode_select_valid(TAP_2238_io_JTAG_TAP_in_mode_select_valid),
    .io_JTAG_TAP_in_clock_data(TAP_2238_io_JTAG_TAP_in_clock_data),
    .io_JTAG_TAP_in_clock_valid(TAP_2238_io_JTAG_TAP_in_clock_valid),
    .io_JTAG_TAP_in_reset_data(TAP_2238_io_JTAG_TAP_in_reset_data),
    .io_JTAG_TAP_in_reset_valid(TAP_2238_io_JTAG_TAP_in_reset_valid),
    .clk(TAP_2238_clk),
    .reset(TAP_2238_reset),
    .io_JTAG_TAP_in_mode_select_ready(TAP_2238_io_JTAG_TAP_in_mode_select_ready),
    .io_JTAG_TAP_in_clock_ready(TAP_2238_io_JTAG_TAP_in_clock_ready),
    .io_JTAG_TAP_in_reset_ready(TAP_2238_io_JTAG_TAP_in_reset_ready),
    .io_out_curr_state(TAP_2238_io_out_curr_state));
  assign TAP_2238_clk = clk;
  assign TAP_2238_reset = reset;
  assign TAP_2238_io_JTAG_TAP_in_mode_select_data = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign TAP_2238_io_JTAG_TAP_in_mode_select_valid = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign TAP_2238_io_JTAG_TAP_in_clock_data = io_JTAG_JTAG_TAP_in_clock_data;
  assign TAP_2238_io_JTAG_TAP_in_clock_valid = io_JTAG_JTAG_TAP_in_clock_valid;
  assign TAP_2238_io_JTAG_TAP_in_reset_data = io_JTAG_JTAG_TAP_in_reset_data;
  assign TAP_2238_io_JTAG_TAP_in_reset_valid = io_JTAG_JTAG_TAP_in_reset_valid;

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = proxy_io_JTAG_JTAG_TAP_in_mode_select_ready_2117;
  assign io_JTAG_JTAG_TAP_in_clock_ready = proxy_io_JTAG_JTAG_TAP_in_clock_ready_2121;
  assign io_JTAG_JTAG_TAP_in_reset_ready = proxy_io_JTAG_JTAG_TAP_in_reset_ready_2125;
  assign io_JTAG_in_data_ready = 1'h1;
  assign io_JTAG_out_data_data = sel_2338;
  assign io_JTAG_out_data_valid = sel_2332;

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
  reg[11:0] mem_ch_bit_12u_2378 [0:4095], reg_ch_bit_12u_2397;
  wire[11:0] marport_ch_bit_12u_2417, proxy_ch_bit_12u_2398, proxy_slice_2401, proxy_ch_uint_12u_2416;
  reg[63:0] reg_ch_uint_64u_2385, reg_ch_uint_64u_2388;
  wire[31:0] sel_2424, sel_2426, sel_2430, sel_2432, op_pad_2419;
  wire[63:0] op_add_2391, op_add_2393, op_shr_2422, op_shr_2428;
  wire op_eq_2406, op_eq_2409, op_eq_2412, op_eq_2415;

  assign marport_ch_bit_12u_2417 = mem_ch_bit_12u_2378[proxy_ch_uint_12u_2416];
  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem_ch_bit_12u_2378[io_in_mem_csr_address] <= proxy_ch_bit_12u_2398;
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_uint_64u_2385 <= 64'h0;
    else
      reg_ch_uint_64u_2385 <= op_add_2391;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_uint_64u_2388 <= 64'h0;
    else
      reg_ch_uint_64u_2388 <= op_add_2393;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_2397 <= 12'h0;
    else
      reg_ch_bit_12u_2397 <= io_in_decode_csr_address;
  end
  assign proxy_ch_bit_12u_2398 = proxy_slice_2401;
  assign proxy_slice_2401 = io_in_mem_csr_result[11:0];
  assign proxy_ch_uint_12u_2416 = reg_ch_bit_12u_2397;
  assign sel_2424 = op_eq_2415 ? op_shr_2422[31:0] : op_pad_2419;
  assign sel_2426 = op_eq_2412 ? reg_ch_uint_64u_2388[31:0] : sel_2424;
  assign sel_2430 = op_eq_2409 ? op_shr_2428[31:0] : sel_2426;
  assign sel_2432 = op_eq_2406 ? reg_ch_uint_64u_2385[31:0] : sel_2430;
  assign op_add_2391 = reg_ch_uint_64u_2385 + 64'h1;
  assign op_add_2393 = reg_ch_uint_64u_2388 + 64'h1;
  assign op_eq_2406 = reg_ch_bit_12u_2397 == 12'hc00;
  assign op_eq_2409 = reg_ch_bit_12u_2397 == 12'hc80;
  assign op_eq_2412 = reg_ch_bit_12u_2397 == 12'hc02;
  assign op_eq_2415 = reg_ch_bit_12u_2397 == 12'hc82;
  assign op_pad_2419 = {{20{1'b0}}, marport_ch_bit_12u_2417};
  assign op_shr_2422 = reg_ch_uint_64u_2388 >> 32'h20;
  assign op_shr_2428 = reg_ch_uint_64u_2385 >> 32'h20;

  assign io_out_decode_csr_data = sel_2432;

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
  wire proxy_io_IBUS_in_data_ready_3, proxy_io_IBUS_out_address_valid_7, proxy_io_DBUS_out_miss_10, proxy_io_DBUS_out_rw_12, proxy_io_DBUS_in_data_ready_16, proxy_io_DBUS_out_data_valid_20, proxy_io_DBUS_out_address_valid_25, proxy_io_DBUS_out_control_valid_30, proxy_io_INTERRUPT_in_interrupt_id_ready_35, proxy_io_jtag_JTAG_TAP_in_mode_select_ready_39, proxy_io_jtag_JTAG_TAP_in_clock_ready_43, proxy_io_jtag_JTAG_TAP_in_reset_ready_47, proxy_io_jtag_in_data_ready_51, proxy_io_jtag_out_data_data_53, proxy_io_jtag_out_data_valid_55, proxy_io_out_fwd_stall_59, proxy_Fetch_io_IBUS_in_data_ready_232, proxy_Fetch_io_IBUS_out_address_valid_236, proxy_Fetch_io_in_branch_dir_240, proxy_Fetch_io_in_freeze_242, proxy_Fetch_io_in_branch_stall_246, proxy_Fetch_io_in_fwd_stall_248, proxy_Fetch_io_in_branch_stall_exe_250, proxy_Fetch_io_in_jal_252, proxy_Fetch_io_in_interrupt_256, proxy_F_D_Register_io_in_branch_stall_308, proxy_F_D_Register_io_in_branch_stall_exe_310, proxy_F_D_Register_io_in_fwd_stall_312, proxy_Decode_io_in_src1_fwd_782, proxy_Decode_io_in_src2_fwd_786, proxy_Decode_io_in_csr_fwd_790, proxy_Decode_io_out_is_csr_796, proxy_Decode_io_out_rs2_src_814, proxy_Decode_io_out_branch_stall_824, proxy_Decode_io_out_jal_826, proxy_D_E_Register_io_in_rs2_src_1033, proxy_D_E_Register_io_in_fwd_stall_1045, proxy_D_E_Register_io_in_branch_stall_1047, proxy_D_E_Register_io_in_is_csr_1053, proxy_D_E_Register_io_in_jal_1059, proxy_D_E_Register_io_out_is_csr_1065, proxy_D_E_Register_io_out_rs2_src_1083, proxy_D_E_Register_io_out_jal_1097, proxy_Execute_io_in_rs2_src_1253, proxy_Execute_io_in_is_csr_1269, proxy_Execute_io_in_jal_1275, proxy_Execute_io_out_is_csr_1283, proxy_Execute_io_out_jal_1305, proxy_Execute_io_out_branch_stall_1311, proxy_E_M_Register_io_in_is_csr_1446, proxy_E_M_Register_io_out_is_csr_1458, proxy_Memory_io_DBUS_out_miss_1682, proxy_Memory_io_DBUS_out_rw_1684, proxy_Memory_io_DBUS_in_data_ready_1690, proxy_Memory_io_DBUS_out_data_valid_1694, proxy_Memory_io_DBUS_out_address_valid_1700, proxy_Memory_io_DBUS_out_control_valid_1706, proxy_Memory_io_out_branch_dir_1748, proxy_Forwarding_io_in_execute_is_csr_2043, proxy_Forwarding_io_in_memory_is_csr_2059, proxy_Forwarding_io_out_src1_fwd_2075, proxy_Forwarding_io_out_src2_fwd_2077, proxy_Forwarding_io_out_csr_fwd_2079, proxy_Forwarding_io_out_fwd_stall_2087, proxy_Interrupt_Handler_io_INTERRUPT_in_interrupt_id_ready_2109, proxy_Interrupt_Handler_io_out_interrupt_2111, proxy_JTAG_io_JTAG_JTAG_TAP_in_mode_select_ready_2346, proxy_JTAG_io_JTAG_JTAG_TAP_in_clock_ready_2352, proxy_JTAG_io_JTAG_JTAG_TAP_in_reset_ready_2358, proxy_JTAG_io_JTAG_in_data_ready_2364, proxy_JTAG_io_JTAG_out_data_data_2366, proxy_JTAG_io_JTAG_out_data_valid_2368, proxy_CSR_Handler_io_in_mem_is_csr_2440, proxy_ch_bool_2451, op_orl_2446, op_eq_2450, Fetch_222_clk, Fetch_222_reset, Fetch_222_io_IBUS_in_data_valid, Fetch_222_io_IBUS_in_data_ready, Fetch_222_io_IBUS_out_address_valid, Fetch_222_io_IBUS_out_address_ready, Fetch_222_io_in_branch_dir, Fetch_222_io_in_freeze, Fetch_222_io_in_branch_stall, Fetch_222_io_in_fwd_stall, Fetch_222_io_in_branch_stall_exe, Fetch_222_io_in_jal, Fetch_222_io_in_interrupt, Fetch_222_io_in_debug, F_D_Register_301_clk, F_D_Register_301_reset, F_D_Register_301_io_in_branch_stall, F_D_Register_301_io_in_branch_stall_exe, F_D_Register_301_io_in_fwd_stall, Decode_768_clk, Decode_768_io_in_stall, Decode_768_io_in_src1_fwd, Decode_768_io_in_src2_fwd, Decode_768_io_in_csr_fwd, Decode_768_io_out_is_csr, Decode_768_io_out_rs2_src, Decode_768_io_out_branch_stall, Decode_768_io_out_jal, D_E_Register_1016_clk, D_E_Register_1016_reset, D_E_Register_1016_io_in_rs2_src, D_E_Register_1016_io_in_fwd_stall, D_E_Register_1016_io_in_branch_stall, D_E_Register_1016_io_in_is_csr, D_E_Register_1016_io_in_jal, D_E_Register_1016_io_out_is_csr, D_E_Register_1016_io_out_rs2_src, D_E_Register_1016_io_out_jal, Execute_1238_io_in_rs2_src, Execute_1238_io_in_is_csr, Execute_1238_io_in_jal, Execute_1238_io_out_is_csr, Execute_1238_io_out_jal, Execute_1238_io_out_branch_stall, E_M_Register_1421_clk, E_M_Register_1421_reset, E_M_Register_1421_io_in_is_csr, E_M_Register_1421_io_out_is_csr, Memory_1681_io_DBUS_out_miss, Memory_1681_io_DBUS_out_rw, Memory_1681_io_DBUS_in_data_valid, Memory_1681_io_DBUS_in_data_ready, Memory_1681_io_DBUS_out_data_valid, Memory_1681_io_DBUS_out_data_ready, Memory_1681_io_DBUS_out_address_valid, Memory_1681_io_DBUS_out_address_ready, Memory_1681_io_DBUS_out_control_valid, Memory_1681_io_DBUS_out_control_ready, Memory_1681_io_out_branch_dir, M_W_Register_1804_clk, M_W_Register_1804_reset, Forwarding_2028_io_in_execute_is_csr, Forwarding_2028_io_in_memory_is_csr, Forwarding_2028_io_out_src1_fwd, Forwarding_2028_io_out_src2_fwd, Forwarding_2028_io_out_csr_fwd, Forwarding_2028_io_out_fwd_stall, Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_data, Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_valid, Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_ready, Interrupt_Handler_2104_io_out_interrupt, JTAG_2339_clk, JTAG_2339_reset, JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_data, JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_valid, JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_ready, JTAG_2339_io_JTAG_JTAG_TAP_in_clock_data, JTAG_2339_io_JTAG_JTAG_TAP_in_clock_valid, JTAG_2339_io_JTAG_JTAG_TAP_in_clock_ready, JTAG_2339_io_JTAG_JTAG_TAP_in_reset_data, JTAG_2339_io_JTAG_JTAG_TAP_in_reset_valid, JTAG_2339_io_JTAG_JTAG_TAP_in_reset_ready, JTAG_2339_io_JTAG_in_data_data, JTAG_2339_io_JTAG_in_data_valid, JTAG_2339_io_JTAG_in_data_ready, JTAG_2339_io_JTAG_out_data_data, JTAG_2339_io_JTAG_out_data_valid, JTAG_2339_io_JTAG_out_data_ready, CSR_Handler_2433_clk, CSR_Handler_2433_reset, CSR_Handler_2433_io_in_mem_is_csr;
  wire[31:0] proxy_io_IBUS_out_address_data_5, proxy_io_DBUS_out_data_data_18, proxy_io_DBUS_out_address_data_23, proxy_Fetch_io_IBUS_out_address_data_234, proxy_Fetch_io_in_branch_dest_244, proxy_Fetch_io_in_jal_dest_254, proxy_Fetch_io_in_interrupt_pc_258, proxy_Fetch_io_out_instruction_262, proxy_Fetch_io_out_curr_PC_266, proxy_F_D_Register_io_in_instruction_304, proxy_F_D_Register_io_in_curr_PC_306, proxy_F_D_Register_io_out_instruction_314, proxy_F_D_Register_io_out_curr_PC_316, proxy_Decode_io_in_instruction_770, proxy_Decode_io_in_curr_PC_772, proxy_Decode_io_in_write_data_776, proxy_Decode_io_in_src1_fwd_data_784, proxy_Decode_io_in_src2_fwd_data_788, proxy_Decode_io_in_csr_fwd_data_792, proxy_Decode_io_out_csr_mask_798, proxy_Decode_io_out_rd1_804, proxy_Decode_io_out_rd2_808, proxy_Decode_io_out_itype_immed_816, proxy_Decode_io_out_jal_offset_828, proxy_Decode_io_out_PC_next_832, proxy_D_E_Register_io_in_rd1_1023, proxy_D_E_Register_io_in_rd2_1027, proxy_D_E_Register_io_in_itype_immed_1035, proxy_D_E_Register_io_in_PC_next_1041, proxy_D_E_Register_io_in_csr_mask_1055, proxy_D_E_Register_io_in_curr_PC_1057, proxy_D_E_Register_io_in_jal_offset_1061, proxy_D_E_Register_io_out_csr_mask_1067, proxy_D_E_Register_io_out_rd1_1073, proxy_D_E_Register_io_out_rd2_1077, proxy_D_E_Register_io_out_itype_immed_1085, proxy_D_E_Register_io_out_curr_PC_1095, proxy_D_E_Register_io_out_jal_offset_1099, proxy_D_E_Register_io_out_PC_next_1101, proxy_Execute_io_in_rd1_1243, proxy_Execute_io_in_rd2_1247, proxy_Execute_io_in_itype_immed_1255, proxy_Execute_io_in_PC_next_1261, proxy_Execute_io_in_csr_data_1271, proxy_Execute_io_in_csr_mask_1273, proxy_Execute_io_in_jal_offset_1277, proxy_Execute_io_in_curr_PC_1279, proxy_Execute_io_out_csr_result_1285, proxy_Execute_io_out_alu_result_1287, proxy_Execute_io_out_rd1_1295, proxy_Execute_io_out_rd2_1299, proxy_Execute_io_out_jal_dest_1307, proxy_Execute_io_out_branch_offset_1309, proxy_Execute_io_out_PC_next_1313, proxy_E_M_Register_io_in_alu_result_1424, proxy_E_M_Register_io_in_rd1_1432, proxy_E_M_Register_io_in_rd2_1436, proxy_E_M_Register_io_in_PC_next_1442, proxy_E_M_Register_io_in_csr_result_1448, proxy_E_M_Register_io_in_curr_PC_1450, proxy_E_M_Register_io_in_branch_offset_1452, proxy_E_M_Register_io_out_csr_result_1460, proxy_E_M_Register_io_out_alu_result_1462, proxy_E_M_Register_io_out_rd1_1470, proxy_E_M_Register_io_out_rd2_1472, proxy_E_M_Register_io_out_curr_PC_1480, proxy_E_M_Register_io_out_branch_offset_1482, proxy_E_M_Register_io_out_PC_next_1486, proxy_Memory_io_DBUS_out_data_data_1692, proxy_Memory_io_DBUS_out_address_data_1698, proxy_Memory_io_in_alu_result_1710, proxy_Memory_io_in_rd1_1722, proxy_Memory_io_in_rd2_1726, proxy_Memory_io_in_PC_next_1728, proxy_Memory_io_in_curr_PC_1730, proxy_Memory_io_in_branch_offset_1732, proxy_Memory_io_out_alu_result_1736, proxy_Memory_io_out_mem_result_1738, proxy_Memory_io_out_branch_dest_1750, proxy_Memory_io_out_PC_next_1754, proxy_M_W_Register_io_in_alu_result_1807, proxy_M_W_Register_io_in_mem_result_1809, proxy_M_W_Register_io_in_PC_next_1819, proxy_M_W_Register_io_out_alu_result_1821, proxy_M_W_Register_io_out_mem_result_1823, proxy_M_W_Register_io_out_PC_next_1833, proxy_Write_Back_io_in_alu_result_1857, proxy_Write_Back_io_in_mem_result_1859, proxy_Write_Back_io_in_PC_next_1869, proxy_Write_Back_io_out_write_data_1871, proxy_Forwarding_io_in_execute_alu_result_2039, proxy_Forwarding_io_in_execute_PC_next_2041, proxy_Forwarding_io_in_execute_csr_result_2047, proxy_Forwarding_io_in_memory_alu_result_2053, proxy_Forwarding_io_in_memory_mem_data_2055, proxy_Forwarding_io_in_memory_PC_next_2057, proxy_Forwarding_io_in_memory_csr_result_2063, proxy_Forwarding_io_in_writeback_alu_result_2069, proxy_Forwarding_io_in_writeback_mem_data_2071, proxy_Forwarding_io_in_writeback_PC_next_2073, proxy_Forwarding_io_out_src1_fwd_data_2081, proxy_Forwarding_io_out_src2_fwd_data_2083, proxy_Forwarding_io_out_csr_fwd_data_2085, proxy_Interrupt_Handler_io_out_interrupt_pc_2113, proxy_CSR_Handler_io_in_mem_csr_result_2442, proxy_CSR_Handler_io_out_decode_csr_data_2444, Fetch_222_io_IBUS_in_data_data, Fetch_222_io_IBUS_out_address_data, Fetch_222_io_in_branch_dest, Fetch_222_io_in_jal_dest, Fetch_222_io_in_interrupt_pc, Fetch_222_io_out_instruction, Fetch_222_io_out_curr_PC, F_D_Register_301_io_in_instruction, F_D_Register_301_io_in_curr_PC, F_D_Register_301_io_out_instruction, F_D_Register_301_io_out_curr_PC, Decode_768_io_in_instruction, Decode_768_io_in_curr_PC, Decode_768_io_in_write_data, Decode_768_io_in_src1_fwd_data, Decode_768_io_in_src2_fwd_data, Decode_768_io_in_csr_fwd_data, Decode_768_io_out_csr_mask, Decode_768_io_out_rd1, Decode_768_io_out_rd2, Decode_768_io_out_itype_immed, Decode_768_io_out_jal_offset, Decode_768_io_out_PC_next, D_E_Register_1016_io_in_rd1, D_E_Register_1016_io_in_rd2, D_E_Register_1016_io_in_itype_immed, D_E_Register_1016_io_in_PC_next, D_E_Register_1016_io_in_csr_mask, D_E_Register_1016_io_in_curr_PC, D_E_Register_1016_io_in_jal_offset, D_E_Register_1016_io_out_csr_mask, D_E_Register_1016_io_out_rd1, D_E_Register_1016_io_out_rd2, D_E_Register_1016_io_out_itype_immed, D_E_Register_1016_io_out_curr_PC, D_E_Register_1016_io_out_jal_offset, D_E_Register_1016_io_out_PC_next, Execute_1238_io_in_rd1, Execute_1238_io_in_rd2, Execute_1238_io_in_itype_immed, Execute_1238_io_in_PC_next, Execute_1238_io_in_csr_data, Execute_1238_io_in_csr_mask, Execute_1238_io_in_jal_offset, Execute_1238_io_in_curr_PC, Execute_1238_io_out_csr_result, Execute_1238_io_out_alu_result, Execute_1238_io_out_rd1, Execute_1238_io_out_rd2, Execute_1238_io_out_jal_dest, Execute_1238_io_out_branch_offset, Execute_1238_io_out_PC_next, E_M_Register_1421_io_in_alu_result, E_M_Register_1421_io_in_rd1, E_M_Register_1421_io_in_rd2, E_M_Register_1421_io_in_PC_next, E_M_Register_1421_io_in_csr_result, E_M_Register_1421_io_in_curr_PC, E_M_Register_1421_io_in_branch_offset, E_M_Register_1421_io_out_csr_result, E_M_Register_1421_io_out_alu_result, E_M_Register_1421_io_out_rd1, E_M_Register_1421_io_out_rd2, E_M_Register_1421_io_out_curr_PC, E_M_Register_1421_io_out_branch_offset, E_M_Register_1421_io_out_PC_next, Memory_1681_io_DBUS_in_data_data, Memory_1681_io_DBUS_out_data_data, Memory_1681_io_DBUS_out_address_data, Memory_1681_io_in_alu_result, Memory_1681_io_in_rd1, Memory_1681_io_in_rd2, Memory_1681_io_in_PC_next, Memory_1681_io_in_curr_PC, Memory_1681_io_in_branch_offset, Memory_1681_io_out_alu_result, Memory_1681_io_out_mem_result, Memory_1681_io_out_branch_dest, Memory_1681_io_out_PC_next, M_W_Register_1804_io_in_alu_result, M_W_Register_1804_io_in_mem_result, M_W_Register_1804_io_in_PC_next, M_W_Register_1804_io_out_alu_result, M_W_Register_1804_io_out_mem_result, M_W_Register_1804_io_out_PC_next, Write_Back_1856_io_in_alu_result, Write_Back_1856_io_in_mem_result, Write_Back_1856_io_in_PC_next, Write_Back_1856_io_out_write_data, Forwarding_2028_io_in_execute_alu_result, Forwarding_2028_io_in_execute_PC_next, Forwarding_2028_io_in_execute_csr_result, Forwarding_2028_io_in_memory_alu_result, Forwarding_2028_io_in_memory_mem_data, Forwarding_2028_io_in_memory_PC_next, Forwarding_2028_io_in_memory_csr_result, Forwarding_2028_io_in_writeback_alu_result, Forwarding_2028_io_in_writeback_mem_data, Forwarding_2028_io_in_writeback_PC_next, Forwarding_2028_io_out_src1_fwd_data, Forwarding_2028_io_out_src2_fwd_data, Forwarding_2028_io_out_csr_fwd_data, Interrupt_Handler_2104_io_out_interrupt_pc, CSR_Handler_2433_io_in_mem_csr_result, CSR_Handler_2433_io_out_decode_csr_data;
  wire[2:0] proxy_io_DBUS_out_control_data_28, proxy_Decode_io_out_mem_read_818, proxy_Decode_io_out_mem_write_820, proxy_Decode_io_out_branch_type_822, proxy_D_E_Register_io_in_mem_read_1037, proxy_D_E_Register_io_in_mem_write_1039, proxy_D_E_Register_io_in_branch_type_1043, proxy_D_E_Register_io_out_mem_read_1087, proxy_D_E_Register_io_out_mem_write_1089, proxy_D_E_Register_io_out_branch_type_1091, proxy_Execute_io_in_mem_read_1257, proxy_Execute_io_in_mem_write_1259, proxy_Execute_io_in_branch_type_1263, proxy_Execute_io_out_mem_read_1301, proxy_Execute_io_out_mem_write_1303, proxy_E_M_Register_io_in_mem_read_1438, proxy_E_M_Register_io_in_mem_write_1440, proxy_E_M_Register_io_in_branch_type_1454, proxy_E_M_Register_io_out_mem_read_1476, proxy_E_M_Register_io_out_mem_write_1478, proxy_E_M_Register_io_out_branch_type_1484, proxy_Memory_io_DBUS_out_control_data_1704, proxy_Memory_io_in_mem_read_1712, proxy_Memory_io_in_mem_write_1714, proxy_Memory_io_in_branch_type_1734, Decode_768_io_out_mem_read, Decode_768_io_out_mem_write, Decode_768_io_out_branch_type, D_E_Register_1016_io_in_mem_read, D_E_Register_1016_io_in_mem_write, D_E_Register_1016_io_in_branch_type, D_E_Register_1016_io_out_mem_read, D_E_Register_1016_io_out_mem_write, D_E_Register_1016_io_out_branch_type, Execute_1238_io_in_mem_read, Execute_1238_io_in_mem_write, Execute_1238_io_in_branch_type, Execute_1238_io_out_mem_read, Execute_1238_io_out_mem_write, E_M_Register_1421_io_in_mem_read, E_M_Register_1421_io_in_mem_write, E_M_Register_1421_io_in_branch_type, E_M_Register_1421_io_out_mem_read, E_M_Register_1421_io_out_mem_write, E_M_Register_1421_io_out_branch_type, Memory_1681_io_DBUS_out_control_data, Memory_1681_io_in_mem_read, Memory_1681_io_in_mem_write, Memory_1681_io_in_branch_type;
  wire[4:0] proxy_Decode_io_in_rd_778, proxy_Decode_io_out_rd_800, proxy_Decode_io_out_rs1_802, proxy_Decode_io_out_rs2_806, proxy_D_E_Register_io_in_rd_1019, proxy_D_E_Register_io_in_rs1_1021, proxy_D_E_Register_io_in_rs2_1025, proxy_D_E_Register_io_out_rd_1069, proxy_D_E_Register_io_out_rs1_1071, proxy_D_E_Register_io_out_rs2_1075, proxy_Execute_io_in_rd_1239, proxy_Execute_io_in_rs1_1241, proxy_Execute_io_in_rs2_1245, proxy_Execute_io_out_rd_1289, proxy_Execute_io_out_rs1_1293, proxy_Execute_io_out_rs2_1297, proxy_E_M_Register_io_in_rd_1426, proxy_E_M_Register_io_in_rs1_1430, proxy_E_M_Register_io_in_rs2_1434, proxy_E_M_Register_io_out_rd_1464, proxy_E_M_Register_io_out_rs1_1468, proxy_E_M_Register_io_out_rs2_1474, proxy_Memory_io_in_rd_1716, proxy_Memory_io_in_rs1_1720, proxy_Memory_io_in_rs2_1724, proxy_Memory_io_out_rd_1740, proxy_Memory_io_out_rs1_1744, proxy_Memory_io_out_rs2_1746, proxy_M_W_Register_io_in_rd_1811, proxy_M_W_Register_io_in_rs1_1815, proxy_M_W_Register_io_in_rs2_1817, proxy_M_W_Register_io_out_rd_1825, proxy_M_W_Register_io_out_rs1_1829, proxy_M_W_Register_io_out_rs2_1831, proxy_Write_Back_io_in_rd_1861, proxy_Write_Back_io_in_rs1_1865, proxy_Write_Back_io_in_rs2_1867, proxy_Write_Back_io_out_rd_1873, proxy_Forwarding_io_in_decode_src1_2029, proxy_Forwarding_io_in_decode_src2_2031, proxy_Forwarding_io_in_execute_dest_2035, proxy_Forwarding_io_in_memory_dest_2049, proxy_Forwarding_io_in_writeback_dest_2065, Decode_768_io_in_rd, Decode_768_io_out_rd, Decode_768_io_out_rs1, Decode_768_io_out_rs2, D_E_Register_1016_io_in_rd, D_E_Register_1016_io_in_rs1, D_E_Register_1016_io_in_rs2, D_E_Register_1016_io_out_rd, D_E_Register_1016_io_out_rs1, D_E_Register_1016_io_out_rs2, Execute_1238_io_in_rd, Execute_1238_io_in_rs1, Execute_1238_io_in_rs2, Execute_1238_io_out_rd, Execute_1238_io_out_rs1, Execute_1238_io_out_rs2, E_M_Register_1421_io_in_rd, E_M_Register_1421_io_in_rs1, E_M_Register_1421_io_in_rs2, E_M_Register_1421_io_out_rd, E_M_Register_1421_io_out_rs1, E_M_Register_1421_io_out_rs2, Memory_1681_io_in_rd, Memory_1681_io_in_rs1, Memory_1681_io_in_rs2, Memory_1681_io_out_rd, Memory_1681_io_out_rs1, Memory_1681_io_out_rs2, M_W_Register_1804_io_in_rd, M_W_Register_1804_io_in_rs1, M_W_Register_1804_io_in_rs2, M_W_Register_1804_io_out_rd, M_W_Register_1804_io_out_rs1, M_W_Register_1804_io_out_rs2, Write_Back_1856_io_in_rd, Write_Back_1856_io_in_rs1, Write_Back_1856_io_in_rs2, Write_Back_1856_io_out_rd, Forwarding_2028_io_in_decode_src1, Forwarding_2028_io_in_decode_src2, Forwarding_2028_io_in_execute_dest, Forwarding_2028_io_in_memory_dest, Forwarding_2028_io_in_writeback_dest;
  wire[1:0] proxy_Decode_io_in_wb_780, proxy_Decode_io_out_wb_810, proxy_D_E_Register_io_in_wb_1031, proxy_D_E_Register_io_out_wb_1081, proxy_Execute_io_in_wb_1251, proxy_Execute_io_out_wb_1291, proxy_E_M_Register_io_in_wb_1428, proxy_E_M_Register_io_out_wb_1466, proxy_Memory_io_in_wb_1718, proxy_Memory_io_out_wb_1742, proxy_M_W_Register_io_in_wb_1813, proxy_M_W_Register_io_out_wb_1827, proxy_Write_Back_io_in_wb_1863, proxy_Write_Back_io_out_wb_1875, proxy_Forwarding_io_in_execute_wb_2037, proxy_Forwarding_io_in_memory_wb_2051, proxy_Forwarding_io_in_writeback_wb_2067, Decode_768_io_in_wb, Decode_768_io_out_wb, D_E_Register_1016_io_in_wb, D_E_Register_1016_io_out_wb, Execute_1238_io_in_wb, Execute_1238_io_out_wb, E_M_Register_1421_io_in_wb, E_M_Register_1421_io_out_wb, Memory_1681_io_in_wb, Memory_1681_io_out_wb, M_W_Register_1804_io_in_wb, M_W_Register_1804_io_out_wb, Write_Back_1856_io_in_wb, Write_Back_1856_io_out_wb, Forwarding_2028_io_in_execute_wb, Forwarding_2028_io_in_memory_wb, Forwarding_2028_io_in_writeback_wb;
  wire[11:0] proxy_Decode_io_out_csr_address_794, proxy_D_E_Register_io_in_csr_address_1051, proxy_D_E_Register_io_out_csr_address_1063, proxy_Execute_io_in_csr_address_1267, proxy_Execute_io_out_csr_address_1281, proxy_E_M_Register_io_in_csr_address_1444, proxy_E_M_Register_io_out_csr_address_1456, proxy_Forwarding_io_in_decode_csr_address_2033, proxy_Forwarding_io_in_execute_csr_address_2045, proxy_Forwarding_io_in_memory_csr_address_2061, proxy_CSR_Handler_io_in_decode_csr_address_2436, proxy_CSR_Handler_io_in_mem_csr_address_2438, Decode_768_io_out_csr_address, D_E_Register_1016_io_in_csr_address, D_E_Register_1016_io_out_csr_address, Execute_1238_io_in_csr_address, Execute_1238_io_out_csr_address, E_M_Register_1421_io_in_csr_address, E_M_Register_1421_io_out_csr_address, Forwarding_2028_io_in_decode_csr_address, Forwarding_2028_io_in_execute_csr_address, Forwarding_2028_io_in_memory_csr_address, CSR_Handler_2433_io_in_decode_csr_address, CSR_Handler_2433_io_in_mem_csr_address;
  wire[3:0] proxy_Decode_io_out_alu_op_812, proxy_D_E_Register_io_in_alu_op_1029, proxy_D_E_Register_io_out_alu_op_1079, proxy_Execute_io_in_alu_op_1249, Decode_768_io_out_alu_op, D_E_Register_1016_io_in_alu_op, D_E_Register_1016_io_out_alu_op, Execute_1238_io_in_alu_op;
  wire[19:0] proxy_Decode_io_out_upper_immed_830, proxy_D_E_Register_io_in_upper_immed_1049, proxy_D_E_Register_io_out_upper_immed_1093, proxy_Execute_io_in_upper_immed_1265, Decode_768_io_out_upper_immed, D_E_Register_1016_io_in_upper_immed, D_E_Register_1016_io_out_upper_immed, Execute_1238_io_in_upper_immed;

  assign proxy_io_IBUS_in_data_ready_3 = proxy_Fetch_io_IBUS_in_data_ready_232;
  assign proxy_io_IBUS_out_address_data_5 = proxy_Fetch_io_IBUS_out_address_data_234;
  assign proxy_io_IBUS_out_address_valid_7 = proxy_Fetch_io_IBUS_out_address_valid_236;
  assign proxy_io_DBUS_out_miss_10 = proxy_Memory_io_DBUS_out_miss_1682;
  assign proxy_io_DBUS_out_rw_12 = proxy_Memory_io_DBUS_out_rw_1684;
  assign proxy_io_DBUS_in_data_ready_16 = proxy_Memory_io_DBUS_in_data_ready_1690;
  assign proxy_io_DBUS_out_data_data_18 = proxy_Memory_io_DBUS_out_data_data_1692;
  assign proxy_io_DBUS_out_data_valid_20 = proxy_Memory_io_DBUS_out_data_valid_1694;
  assign proxy_io_DBUS_out_address_data_23 = proxy_Memory_io_DBUS_out_address_data_1698;
  assign proxy_io_DBUS_out_address_valid_25 = proxy_Memory_io_DBUS_out_address_valid_1700;
  assign proxy_io_DBUS_out_control_data_28 = proxy_Memory_io_DBUS_out_control_data_1704;
  assign proxy_io_DBUS_out_control_valid_30 = proxy_Memory_io_DBUS_out_control_valid_1706;
  assign proxy_io_INTERRUPT_in_interrupt_id_ready_35 = proxy_Interrupt_Handler_io_INTERRUPT_in_interrupt_id_ready_2109;
  assign proxy_io_jtag_JTAG_TAP_in_mode_select_ready_39 = proxy_JTAG_io_JTAG_JTAG_TAP_in_mode_select_ready_2346;
  assign proxy_io_jtag_JTAG_TAP_in_clock_ready_43 = proxy_JTAG_io_JTAG_JTAG_TAP_in_clock_ready_2352;
  assign proxy_io_jtag_JTAG_TAP_in_reset_ready_47 = proxy_JTAG_io_JTAG_JTAG_TAP_in_reset_ready_2358;
  assign proxy_io_jtag_in_data_ready_51 = proxy_JTAG_io_JTAG_in_data_ready_2364;
  assign proxy_io_jtag_out_data_data_53 = proxy_JTAG_io_JTAG_out_data_data_2366;
  assign proxy_io_jtag_out_data_valid_55 = proxy_JTAG_io_JTAG_out_data_valid_2368;
  assign proxy_io_out_fwd_stall_59 = proxy_Forwarding_io_out_fwd_stall_2087;
  assign proxy_Fetch_io_IBUS_in_data_ready_232 = Fetch_222_io_IBUS_in_data_ready;
  assign proxy_Fetch_io_IBUS_out_address_data_234 = Fetch_222_io_IBUS_out_address_data;
  assign proxy_Fetch_io_IBUS_out_address_valid_236 = Fetch_222_io_IBUS_out_address_valid;
  assign proxy_Fetch_io_in_branch_dir_240 = proxy_Memory_io_out_branch_dir_1748;
  assign proxy_Fetch_io_in_freeze_242 = proxy_ch_bool_2451;
  assign proxy_Fetch_io_in_branch_dest_244 = proxy_Memory_io_out_branch_dest_1750;
  assign proxy_Fetch_io_in_branch_stall_246 = proxy_Decode_io_out_branch_stall_824;
  assign proxy_Fetch_io_in_fwd_stall_248 = proxy_Forwarding_io_out_fwd_stall_2087;
  assign proxy_Fetch_io_in_branch_stall_exe_250 = proxy_Execute_io_out_branch_stall_1311;
  assign proxy_Fetch_io_in_jal_252 = proxy_Execute_io_out_jal_1305;
  assign proxy_Fetch_io_in_jal_dest_254 = proxy_Execute_io_out_jal_dest_1307;
  assign proxy_Fetch_io_in_interrupt_256 = proxy_Interrupt_Handler_io_out_interrupt_2111;
  assign proxy_Fetch_io_in_interrupt_pc_258 = proxy_Interrupt_Handler_io_out_interrupt_pc_2113;
  assign proxy_Fetch_io_out_instruction_262 = Fetch_222_io_out_instruction;
  assign proxy_Fetch_io_out_curr_PC_266 = Fetch_222_io_out_curr_PC;
  assign proxy_F_D_Register_io_in_instruction_304 = proxy_Fetch_io_out_instruction_262;
  assign proxy_F_D_Register_io_in_curr_PC_306 = proxy_Fetch_io_out_curr_PC_266;
  assign proxy_F_D_Register_io_in_branch_stall_308 = proxy_Decode_io_out_branch_stall_824;
  assign proxy_F_D_Register_io_in_branch_stall_exe_310 = proxy_Execute_io_out_branch_stall_1311;
  assign proxy_F_D_Register_io_in_fwd_stall_312 = proxy_Forwarding_io_out_fwd_stall_2087;
  assign proxy_F_D_Register_io_out_instruction_314 = F_D_Register_301_io_out_instruction;
  assign proxy_F_D_Register_io_out_curr_PC_316 = F_D_Register_301_io_out_curr_PC;
  assign proxy_Decode_io_in_instruction_770 = proxy_F_D_Register_io_out_instruction_314;
  assign proxy_Decode_io_in_curr_PC_772 = proxy_F_D_Register_io_out_curr_PC_316;
  assign proxy_Decode_io_in_write_data_776 = proxy_Write_Back_io_out_write_data_1871;
  assign proxy_Decode_io_in_rd_778 = proxy_Write_Back_io_out_rd_1873;
  assign proxy_Decode_io_in_wb_780 = proxy_Write_Back_io_out_wb_1875;
  assign proxy_Decode_io_in_src1_fwd_782 = proxy_Forwarding_io_out_src1_fwd_2075;
  assign proxy_Decode_io_in_src1_fwd_data_784 = proxy_Forwarding_io_out_src1_fwd_data_2081;
  assign proxy_Decode_io_in_src2_fwd_786 = proxy_Forwarding_io_out_src2_fwd_2077;
  assign proxy_Decode_io_in_src2_fwd_data_788 = proxy_Forwarding_io_out_src2_fwd_data_2083;
  assign proxy_Decode_io_in_csr_fwd_790 = proxy_Forwarding_io_out_csr_fwd_2079;
  assign proxy_Decode_io_in_csr_fwd_data_792 = proxy_Forwarding_io_out_csr_fwd_data_2085;
  assign proxy_Decode_io_out_csr_address_794 = Decode_768_io_out_csr_address;
  assign proxy_Decode_io_out_is_csr_796 = Decode_768_io_out_is_csr;
  assign proxy_Decode_io_out_csr_mask_798 = Decode_768_io_out_csr_mask;
  assign proxy_Decode_io_out_rd_800 = Decode_768_io_out_rd;
  assign proxy_Decode_io_out_rs1_802 = Decode_768_io_out_rs1;
  assign proxy_Decode_io_out_rd1_804 = Decode_768_io_out_rd1;
  assign proxy_Decode_io_out_rs2_806 = Decode_768_io_out_rs2;
  assign proxy_Decode_io_out_rd2_808 = Decode_768_io_out_rd2;
  assign proxy_Decode_io_out_wb_810 = Decode_768_io_out_wb;
  assign proxy_Decode_io_out_alu_op_812 = Decode_768_io_out_alu_op;
  assign proxy_Decode_io_out_rs2_src_814 = Decode_768_io_out_rs2_src;
  assign proxy_Decode_io_out_itype_immed_816 = Decode_768_io_out_itype_immed;
  assign proxy_Decode_io_out_mem_read_818 = Decode_768_io_out_mem_read;
  assign proxy_Decode_io_out_mem_write_820 = Decode_768_io_out_mem_write;
  assign proxy_Decode_io_out_branch_type_822 = Decode_768_io_out_branch_type;
  assign proxy_Decode_io_out_branch_stall_824 = Decode_768_io_out_branch_stall;
  assign proxy_Decode_io_out_jal_826 = Decode_768_io_out_jal;
  assign proxy_Decode_io_out_jal_offset_828 = Decode_768_io_out_jal_offset;
  assign proxy_Decode_io_out_upper_immed_830 = Decode_768_io_out_upper_immed;
  assign proxy_Decode_io_out_PC_next_832 = Decode_768_io_out_PC_next;
  assign proxy_D_E_Register_io_in_rd_1019 = proxy_Decode_io_out_rd_800;
  assign proxy_D_E_Register_io_in_rs1_1021 = proxy_Decode_io_out_rs1_802;
  assign proxy_D_E_Register_io_in_rd1_1023 = proxy_Decode_io_out_rd1_804;
  assign proxy_D_E_Register_io_in_rs2_1025 = proxy_Decode_io_out_rs2_806;
  assign proxy_D_E_Register_io_in_rd2_1027 = proxy_Decode_io_out_rd2_808;
  assign proxy_D_E_Register_io_in_alu_op_1029 = proxy_Decode_io_out_alu_op_812;
  assign proxy_D_E_Register_io_in_wb_1031 = proxy_Decode_io_out_wb_810;
  assign proxy_D_E_Register_io_in_rs2_src_1033 = proxy_Decode_io_out_rs2_src_814;
  assign proxy_D_E_Register_io_in_itype_immed_1035 = proxy_Decode_io_out_itype_immed_816;
  assign proxy_D_E_Register_io_in_mem_read_1037 = proxy_Decode_io_out_mem_read_818;
  assign proxy_D_E_Register_io_in_mem_write_1039 = proxy_Decode_io_out_mem_write_820;
  assign proxy_D_E_Register_io_in_PC_next_1041 = proxy_Decode_io_out_PC_next_832;
  assign proxy_D_E_Register_io_in_branch_type_1043 = proxy_Decode_io_out_branch_type_822;
  assign proxy_D_E_Register_io_in_fwd_stall_1045 = proxy_Forwarding_io_out_fwd_stall_2087;
  assign proxy_D_E_Register_io_in_branch_stall_1047 = proxy_Execute_io_out_branch_stall_1311;
  assign proxy_D_E_Register_io_in_upper_immed_1049 = proxy_Decode_io_out_upper_immed_830;
  assign proxy_D_E_Register_io_in_csr_address_1051 = proxy_Decode_io_out_csr_address_794;
  assign proxy_D_E_Register_io_in_is_csr_1053 = proxy_Decode_io_out_is_csr_796;
  assign proxy_D_E_Register_io_in_csr_mask_1055 = proxy_Decode_io_out_csr_mask_798;
  assign proxy_D_E_Register_io_in_curr_PC_1057 = proxy_F_D_Register_io_out_curr_PC_316;
  assign proxy_D_E_Register_io_in_jal_1059 = proxy_Decode_io_out_jal_826;
  assign proxy_D_E_Register_io_in_jal_offset_1061 = proxy_Decode_io_out_jal_offset_828;
  assign proxy_D_E_Register_io_out_csr_address_1063 = D_E_Register_1016_io_out_csr_address;
  assign proxy_D_E_Register_io_out_is_csr_1065 = D_E_Register_1016_io_out_is_csr;
  assign proxy_D_E_Register_io_out_csr_mask_1067 = D_E_Register_1016_io_out_csr_mask;
  assign proxy_D_E_Register_io_out_rd_1069 = D_E_Register_1016_io_out_rd;
  assign proxy_D_E_Register_io_out_rs1_1071 = D_E_Register_1016_io_out_rs1;
  assign proxy_D_E_Register_io_out_rd1_1073 = D_E_Register_1016_io_out_rd1;
  assign proxy_D_E_Register_io_out_rs2_1075 = D_E_Register_1016_io_out_rs2;
  assign proxy_D_E_Register_io_out_rd2_1077 = D_E_Register_1016_io_out_rd2;
  assign proxy_D_E_Register_io_out_alu_op_1079 = D_E_Register_1016_io_out_alu_op;
  assign proxy_D_E_Register_io_out_wb_1081 = D_E_Register_1016_io_out_wb;
  assign proxy_D_E_Register_io_out_rs2_src_1083 = D_E_Register_1016_io_out_rs2_src;
  assign proxy_D_E_Register_io_out_itype_immed_1085 = D_E_Register_1016_io_out_itype_immed;
  assign proxy_D_E_Register_io_out_mem_read_1087 = D_E_Register_1016_io_out_mem_read;
  assign proxy_D_E_Register_io_out_mem_write_1089 = D_E_Register_1016_io_out_mem_write;
  assign proxy_D_E_Register_io_out_branch_type_1091 = D_E_Register_1016_io_out_branch_type;
  assign proxy_D_E_Register_io_out_upper_immed_1093 = D_E_Register_1016_io_out_upper_immed;
  assign proxy_D_E_Register_io_out_curr_PC_1095 = D_E_Register_1016_io_out_curr_PC;
  assign proxy_D_E_Register_io_out_jal_1097 = D_E_Register_1016_io_out_jal;
  assign proxy_D_E_Register_io_out_jal_offset_1099 = D_E_Register_1016_io_out_jal_offset;
  assign proxy_D_E_Register_io_out_PC_next_1101 = D_E_Register_1016_io_out_PC_next;
  assign proxy_Execute_io_in_rd_1239 = proxy_D_E_Register_io_out_rd_1069;
  assign proxy_Execute_io_in_rs1_1241 = proxy_D_E_Register_io_out_rs1_1071;
  assign proxy_Execute_io_in_rd1_1243 = proxy_D_E_Register_io_out_rd1_1073;
  assign proxy_Execute_io_in_rs2_1245 = proxy_D_E_Register_io_out_rs2_1075;
  assign proxy_Execute_io_in_rd2_1247 = proxy_D_E_Register_io_out_rd2_1077;
  assign proxy_Execute_io_in_alu_op_1249 = proxy_D_E_Register_io_out_alu_op_1079;
  assign proxy_Execute_io_in_wb_1251 = proxy_D_E_Register_io_out_wb_1081;
  assign proxy_Execute_io_in_rs2_src_1253 = proxy_D_E_Register_io_out_rs2_src_1083;
  assign proxy_Execute_io_in_itype_immed_1255 = proxy_D_E_Register_io_out_itype_immed_1085;
  assign proxy_Execute_io_in_mem_read_1257 = proxy_D_E_Register_io_out_mem_read_1087;
  assign proxy_Execute_io_in_mem_write_1259 = proxy_D_E_Register_io_out_mem_write_1089;
  assign proxy_Execute_io_in_PC_next_1261 = proxy_D_E_Register_io_out_PC_next_1101;
  assign proxy_Execute_io_in_branch_type_1263 = proxy_D_E_Register_io_out_branch_type_1091;
  assign proxy_Execute_io_in_upper_immed_1265 = proxy_D_E_Register_io_out_upper_immed_1093;
  assign proxy_Execute_io_in_csr_address_1267 = proxy_D_E_Register_io_out_csr_address_1063;
  assign proxy_Execute_io_in_is_csr_1269 = proxy_D_E_Register_io_out_is_csr_1065;
  assign proxy_Execute_io_in_csr_data_1271 = proxy_CSR_Handler_io_out_decode_csr_data_2444;
  assign proxy_Execute_io_in_csr_mask_1273 = proxy_D_E_Register_io_out_csr_mask_1067;
  assign proxy_Execute_io_in_jal_1275 = proxy_D_E_Register_io_out_jal_1097;
  assign proxy_Execute_io_in_jal_offset_1277 = proxy_D_E_Register_io_out_jal_offset_1099;
  assign proxy_Execute_io_in_curr_PC_1279 = proxy_D_E_Register_io_out_curr_PC_1095;
  assign proxy_Execute_io_out_csr_address_1281 = Execute_1238_io_out_csr_address;
  assign proxy_Execute_io_out_is_csr_1283 = Execute_1238_io_out_is_csr;
  assign proxy_Execute_io_out_csr_result_1285 = Execute_1238_io_out_csr_result;
  assign proxy_Execute_io_out_alu_result_1287 = Execute_1238_io_out_alu_result;
  assign proxy_Execute_io_out_rd_1289 = Execute_1238_io_out_rd;
  assign proxy_Execute_io_out_wb_1291 = Execute_1238_io_out_wb;
  assign proxy_Execute_io_out_rs1_1293 = Execute_1238_io_out_rs1;
  assign proxy_Execute_io_out_rd1_1295 = Execute_1238_io_out_rd1;
  assign proxy_Execute_io_out_rs2_1297 = Execute_1238_io_out_rs2;
  assign proxy_Execute_io_out_rd2_1299 = Execute_1238_io_out_rd2;
  assign proxy_Execute_io_out_mem_read_1301 = Execute_1238_io_out_mem_read;
  assign proxy_Execute_io_out_mem_write_1303 = Execute_1238_io_out_mem_write;
  assign proxy_Execute_io_out_jal_1305 = Execute_1238_io_out_jal;
  assign proxy_Execute_io_out_jal_dest_1307 = Execute_1238_io_out_jal_dest;
  assign proxy_Execute_io_out_branch_offset_1309 = Execute_1238_io_out_branch_offset;
  assign proxy_Execute_io_out_branch_stall_1311 = Execute_1238_io_out_branch_stall;
  assign proxy_Execute_io_out_PC_next_1313 = Execute_1238_io_out_PC_next;
  assign proxy_E_M_Register_io_in_alu_result_1424 = proxy_Execute_io_out_alu_result_1287;
  assign proxy_E_M_Register_io_in_rd_1426 = proxy_Execute_io_out_rd_1289;
  assign proxy_E_M_Register_io_in_wb_1428 = proxy_Execute_io_out_wb_1291;
  assign proxy_E_M_Register_io_in_rs1_1430 = proxy_Execute_io_out_rs1_1293;
  assign proxy_E_M_Register_io_in_rd1_1432 = proxy_Execute_io_out_rd1_1295;
  assign proxy_E_M_Register_io_in_rs2_1434 = proxy_Execute_io_out_rs2_1297;
  assign proxy_E_M_Register_io_in_rd2_1436 = proxy_Execute_io_out_rd2_1299;
  assign proxy_E_M_Register_io_in_mem_read_1438 = proxy_Execute_io_out_mem_read_1301;
  assign proxy_E_M_Register_io_in_mem_write_1440 = proxy_Execute_io_out_mem_write_1303;
  assign proxy_E_M_Register_io_in_PC_next_1442 = proxy_Execute_io_out_PC_next_1313;
  assign proxy_E_M_Register_io_in_csr_address_1444 = proxy_Execute_io_out_csr_address_1281;
  assign proxy_E_M_Register_io_in_is_csr_1446 = proxy_Execute_io_out_is_csr_1283;
  assign proxy_E_M_Register_io_in_csr_result_1448 = proxy_Execute_io_out_csr_result_1285;
  assign proxy_E_M_Register_io_in_curr_PC_1450 = proxy_D_E_Register_io_out_curr_PC_1095;
  assign proxy_E_M_Register_io_in_branch_offset_1452 = proxy_Execute_io_out_branch_offset_1309;
  assign proxy_E_M_Register_io_in_branch_type_1454 = proxy_D_E_Register_io_out_branch_type_1091;
  assign proxy_E_M_Register_io_out_csr_address_1456 = E_M_Register_1421_io_out_csr_address;
  assign proxy_E_M_Register_io_out_is_csr_1458 = E_M_Register_1421_io_out_is_csr;
  assign proxy_E_M_Register_io_out_csr_result_1460 = E_M_Register_1421_io_out_csr_result;
  assign proxy_E_M_Register_io_out_alu_result_1462 = E_M_Register_1421_io_out_alu_result;
  assign proxy_E_M_Register_io_out_rd_1464 = E_M_Register_1421_io_out_rd;
  assign proxy_E_M_Register_io_out_wb_1466 = E_M_Register_1421_io_out_wb;
  assign proxy_E_M_Register_io_out_rs1_1468 = E_M_Register_1421_io_out_rs1;
  assign proxy_E_M_Register_io_out_rd1_1470 = E_M_Register_1421_io_out_rd1;
  assign proxy_E_M_Register_io_out_rd2_1472 = E_M_Register_1421_io_out_rd2;
  assign proxy_E_M_Register_io_out_rs2_1474 = E_M_Register_1421_io_out_rs2;
  assign proxy_E_M_Register_io_out_mem_read_1476 = E_M_Register_1421_io_out_mem_read;
  assign proxy_E_M_Register_io_out_mem_write_1478 = E_M_Register_1421_io_out_mem_write;
  assign proxy_E_M_Register_io_out_curr_PC_1480 = E_M_Register_1421_io_out_curr_PC;
  assign proxy_E_M_Register_io_out_branch_offset_1482 = E_M_Register_1421_io_out_branch_offset;
  assign proxy_E_M_Register_io_out_branch_type_1484 = E_M_Register_1421_io_out_branch_type;
  assign proxy_E_M_Register_io_out_PC_next_1486 = E_M_Register_1421_io_out_PC_next;
  assign proxy_Memory_io_DBUS_out_miss_1682 = Memory_1681_io_DBUS_out_miss;
  assign proxy_Memory_io_DBUS_out_rw_1684 = Memory_1681_io_DBUS_out_rw;
  assign proxy_Memory_io_DBUS_in_data_ready_1690 = Memory_1681_io_DBUS_in_data_ready;
  assign proxy_Memory_io_DBUS_out_data_data_1692 = Memory_1681_io_DBUS_out_data_data;
  assign proxy_Memory_io_DBUS_out_data_valid_1694 = Memory_1681_io_DBUS_out_data_valid;
  assign proxy_Memory_io_DBUS_out_address_data_1698 = Memory_1681_io_DBUS_out_address_data;
  assign proxy_Memory_io_DBUS_out_address_valid_1700 = Memory_1681_io_DBUS_out_address_valid;
  assign proxy_Memory_io_DBUS_out_control_data_1704 = Memory_1681_io_DBUS_out_control_data;
  assign proxy_Memory_io_DBUS_out_control_valid_1706 = Memory_1681_io_DBUS_out_control_valid;
  assign proxy_Memory_io_in_alu_result_1710 = proxy_E_M_Register_io_out_alu_result_1462;
  assign proxy_Memory_io_in_mem_read_1712 = proxy_E_M_Register_io_out_mem_read_1476;
  assign proxy_Memory_io_in_mem_write_1714 = proxy_E_M_Register_io_out_mem_write_1478;
  assign proxy_Memory_io_in_rd_1716 = proxy_E_M_Register_io_out_rd_1464;
  assign proxy_Memory_io_in_wb_1718 = proxy_E_M_Register_io_out_wb_1466;
  assign proxy_Memory_io_in_rs1_1720 = proxy_E_M_Register_io_out_rs1_1468;
  assign proxy_Memory_io_in_rd1_1722 = proxy_E_M_Register_io_out_rd1_1470;
  assign proxy_Memory_io_in_rs2_1724 = proxy_E_M_Register_io_out_rs2_1474;
  assign proxy_Memory_io_in_rd2_1726 = proxy_E_M_Register_io_out_rd2_1472;
  assign proxy_Memory_io_in_PC_next_1728 = proxy_E_M_Register_io_out_PC_next_1486;
  assign proxy_Memory_io_in_curr_PC_1730 = proxy_E_M_Register_io_out_curr_PC_1480;
  assign proxy_Memory_io_in_branch_offset_1732 = proxy_E_M_Register_io_out_branch_offset_1482;
  assign proxy_Memory_io_in_branch_type_1734 = proxy_E_M_Register_io_out_branch_type_1484;
  assign proxy_Memory_io_out_alu_result_1736 = Memory_1681_io_out_alu_result;
  assign proxy_Memory_io_out_mem_result_1738 = Memory_1681_io_out_mem_result;
  assign proxy_Memory_io_out_rd_1740 = Memory_1681_io_out_rd;
  assign proxy_Memory_io_out_wb_1742 = Memory_1681_io_out_wb;
  assign proxy_Memory_io_out_rs1_1744 = Memory_1681_io_out_rs1;
  assign proxy_Memory_io_out_rs2_1746 = Memory_1681_io_out_rs2;
  assign proxy_Memory_io_out_branch_dir_1748 = Memory_1681_io_out_branch_dir;
  assign proxy_Memory_io_out_branch_dest_1750 = Memory_1681_io_out_branch_dest;
  assign proxy_Memory_io_out_PC_next_1754 = Memory_1681_io_out_PC_next;
  assign proxy_M_W_Register_io_in_alu_result_1807 = proxy_Memory_io_out_alu_result_1736;
  assign proxy_M_W_Register_io_in_mem_result_1809 = proxy_Memory_io_out_mem_result_1738;
  assign proxy_M_W_Register_io_in_rd_1811 = proxy_Memory_io_out_rd_1740;
  assign proxy_M_W_Register_io_in_wb_1813 = proxy_Memory_io_out_wb_1742;
  assign proxy_M_W_Register_io_in_rs1_1815 = proxy_Memory_io_out_rs1_1744;
  assign proxy_M_W_Register_io_in_rs2_1817 = proxy_Memory_io_out_rs2_1746;
  assign proxy_M_W_Register_io_in_PC_next_1819 = proxy_Memory_io_out_PC_next_1754;
  assign proxy_M_W_Register_io_out_alu_result_1821 = M_W_Register_1804_io_out_alu_result;
  assign proxy_M_W_Register_io_out_mem_result_1823 = M_W_Register_1804_io_out_mem_result;
  assign proxy_M_W_Register_io_out_rd_1825 = M_W_Register_1804_io_out_rd;
  assign proxy_M_W_Register_io_out_wb_1827 = M_W_Register_1804_io_out_wb;
  assign proxy_M_W_Register_io_out_rs1_1829 = M_W_Register_1804_io_out_rs1;
  assign proxy_M_W_Register_io_out_rs2_1831 = M_W_Register_1804_io_out_rs2;
  assign proxy_M_W_Register_io_out_PC_next_1833 = M_W_Register_1804_io_out_PC_next;
  assign proxy_Write_Back_io_in_alu_result_1857 = proxy_M_W_Register_io_out_alu_result_1821;
  assign proxy_Write_Back_io_in_mem_result_1859 = proxy_M_W_Register_io_out_mem_result_1823;
  assign proxy_Write_Back_io_in_rd_1861 = proxy_M_W_Register_io_out_rd_1825;
  assign proxy_Write_Back_io_in_wb_1863 = proxy_M_W_Register_io_out_wb_1827;
  assign proxy_Write_Back_io_in_rs1_1865 = proxy_M_W_Register_io_out_rs1_1829;
  assign proxy_Write_Back_io_in_rs2_1867 = proxy_M_W_Register_io_out_rs2_1831;
  assign proxy_Write_Back_io_in_PC_next_1869 = proxy_M_W_Register_io_out_PC_next_1833;
  assign proxy_Write_Back_io_out_write_data_1871 = Write_Back_1856_io_out_write_data;
  assign proxy_Write_Back_io_out_rd_1873 = Write_Back_1856_io_out_rd;
  assign proxy_Write_Back_io_out_wb_1875 = Write_Back_1856_io_out_wb;
  assign proxy_Forwarding_io_in_decode_src1_2029 = proxy_Decode_io_out_rs1_802;
  assign proxy_Forwarding_io_in_decode_src2_2031 = proxy_Decode_io_out_rs2_806;
  assign proxy_Forwarding_io_in_decode_csr_address_2033 = proxy_Decode_io_out_csr_address_794;
  assign proxy_Forwarding_io_in_execute_dest_2035 = proxy_Execute_io_out_rd_1289;
  assign proxy_Forwarding_io_in_execute_wb_2037 = proxy_Execute_io_out_wb_1291;
  assign proxy_Forwarding_io_in_execute_alu_result_2039 = proxy_Execute_io_out_alu_result_1287;
  assign proxy_Forwarding_io_in_execute_PC_next_2041 = proxy_Execute_io_out_PC_next_1313;
  assign proxy_Forwarding_io_in_execute_is_csr_2043 = proxy_Execute_io_out_is_csr_1283;
  assign proxy_Forwarding_io_in_execute_csr_address_2045 = proxy_Execute_io_out_csr_address_1281;
  assign proxy_Forwarding_io_in_execute_csr_result_2047 = proxy_Execute_io_out_csr_result_1285;
  assign proxy_Forwarding_io_in_memory_dest_2049 = proxy_Memory_io_out_rd_1740;
  assign proxy_Forwarding_io_in_memory_wb_2051 = proxy_Memory_io_out_wb_1742;
  assign proxy_Forwarding_io_in_memory_alu_result_2053 = proxy_Memory_io_out_alu_result_1736;
  assign proxy_Forwarding_io_in_memory_mem_data_2055 = proxy_Memory_io_out_mem_result_1738;
  assign proxy_Forwarding_io_in_memory_PC_next_2057 = proxy_Memory_io_out_PC_next_1754;
  assign proxy_Forwarding_io_in_memory_is_csr_2059 = proxy_E_M_Register_io_out_is_csr_1458;
  assign proxy_Forwarding_io_in_memory_csr_address_2061 = proxy_E_M_Register_io_out_csr_address_1456;
  assign proxy_Forwarding_io_in_memory_csr_result_2063 = proxy_E_M_Register_io_out_csr_result_1460;
  assign proxy_Forwarding_io_in_writeback_dest_2065 = proxy_M_W_Register_io_out_rd_1825;
  assign proxy_Forwarding_io_in_writeback_wb_2067 = proxy_M_W_Register_io_out_wb_1827;
  assign proxy_Forwarding_io_in_writeback_alu_result_2069 = proxy_M_W_Register_io_out_alu_result_1821;
  assign proxy_Forwarding_io_in_writeback_mem_data_2071 = proxy_M_W_Register_io_out_mem_result_1823;
  assign proxy_Forwarding_io_in_writeback_PC_next_2073 = proxy_M_W_Register_io_out_PC_next_1833;
  assign proxy_Forwarding_io_out_src1_fwd_2075 = Forwarding_2028_io_out_src1_fwd;
  assign proxy_Forwarding_io_out_src2_fwd_2077 = Forwarding_2028_io_out_src2_fwd;
  assign proxy_Forwarding_io_out_csr_fwd_2079 = Forwarding_2028_io_out_csr_fwd;
  assign proxy_Forwarding_io_out_src1_fwd_data_2081 = Forwarding_2028_io_out_src1_fwd_data;
  assign proxy_Forwarding_io_out_src2_fwd_data_2083 = Forwarding_2028_io_out_src2_fwd_data;
  assign proxy_Forwarding_io_out_csr_fwd_data_2085 = Forwarding_2028_io_out_csr_fwd_data;
  assign proxy_Forwarding_io_out_fwd_stall_2087 = Forwarding_2028_io_out_fwd_stall;
  assign proxy_Interrupt_Handler_io_INTERRUPT_in_interrupt_id_ready_2109 = Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_ready;
  assign proxy_Interrupt_Handler_io_out_interrupt_2111 = Interrupt_Handler_2104_io_out_interrupt;
  assign proxy_Interrupt_Handler_io_out_interrupt_pc_2113 = Interrupt_Handler_2104_io_out_interrupt_pc;
  assign proxy_JTAG_io_JTAG_JTAG_TAP_in_mode_select_ready_2346 = JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_ready;
  assign proxy_JTAG_io_JTAG_JTAG_TAP_in_clock_ready_2352 = JTAG_2339_io_JTAG_JTAG_TAP_in_clock_ready;
  assign proxy_JTAG_io_JTAG_JTAG_TAP_in_reset_ready_2358 = JTAG_2339_io_JTAG_JTAG_TAP_in_reset_ready;
  assign proxy_JTAG_io_JTAG_in_data_ready_2364 = JTAG_2339_io_JTAG_in_data_ready;
  assign proxy_JTAG_io_JTAG_out_data_data_2366 = JTAG_2339_io_JTAG_out_data_data;
  assign proxy_JTAG_io_JTAG_out_data_valid_2368 = JTAG_2339_io_JTAG_out_data_valid;
  assign proxy_CSR_Handler_io_in_decode_csr_address_2436 = proxy_Decode_io_out_csr_address_794;
  assign proxy_CSR_Handler_io_in_mem_csr_address_2438 = proxy_E_M_Register_io_out_csr_address_1456;
  assign proxy_CSR_Handler_io_in_mem_is_csr_2440 = proxy_E_M_Register_io_out_is_csr_1458;
  assign proxy_CSR_Handler_io_in_mem_csr_result_2442 = proxy_E_M_Register_io_out_csr_result_1460;
  assign proxy_CSR_Handler_io_out_decode_csr_data_2444 = CSR_Handler_2433_io_out_decode_csr_data;
  assign proxy_ch_bool_2451 = 1'h0;
  assign op_orl_2446 = proxy_Decode_io_out_branch_stall_824 || proxy_Execute_io_out_branch_stall_1311;
  assign op_eq_2450 = proxy_Execute_io_out_branch_stall_1311 == 1'h1;
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
  Decode Decode_768(
    .io_in_instruction(Decode_768_io_in_instruction),
    .io_in_curr_PC(Decode_768_io_in_curr_PC),
    .io_in_stall(Decode_768_io_in_stall),
    .io_in_write_data(Decode_768_io_in_write_data),
    .io_in_rd(Decode_768_io_in_rd),
    .io_in_wb(Decode_768_io_in_wb),
    .io_in_src1_fwd(Decode_768_io_in_src1_fwd),
    .io_in_src1_fwd_data(Decode_768_io_in_src1_fwd_data),
    .io_in_src2_fwd(Decode_768_io_in_src2_fwd),
    .io_in_src2_fwd_data(Decode_768_io_in_src2_fwd_data),
    .io_in_csr_fwd(Decode_768_io_in_csr_fwd),
    .io_in_csr_fwd_data(Decode_768_io_in_csr_fwd_data),
    .clk(Decode_768_clk),
    .io_out_csr_address(Decode_768_io_out_csr_address),
    .io_out_is_csr(Decode_768_io_out_is_csr),
    .io_out_csr_mask(Decode_768_io_out_csr_mask),
    .io_out_rd(Decode_768_io_out_rd),
    .io_out_rs1(Decode_768_io_out_rs1),
    .io_out_rd1(Decode_768_io_out_rd1),
    .io_out_rs2(Decode_768_io_out_rs2),
    .io_out_rd2(Decode_768_io_out_rd2),
    .io_out_wb(Decode_768_io_out_wb),
    .io_out_alu_op(Decode_768_io_out_alu_op),
    .io_out_rs2_src(Decode_768_io_out_rs2_src),
    .io_out_itype_immed(Decode_768_io_out_itype_immed),
    .io_out_mem_read(Decode_768_io_out_mem_read),
    .io_out_mem_write(Decode_768_io_out_mem_write),
    .io_out_branch_type(Decode_768_io_out_branch_type),
    .io_out_branch_stall(Decode_768_io_out_branch_stall),
    .io_out_jal(Decode_768_io_out_jal),
    .io_out_jal_offset(Decode_768_io_out_jal_offset),
    .io_out_upper_immed(Decode_768_io_out_upper_immed),
    .io_out_PC_next(Decode_768_io_out_PC_next));
  D_E_Register D_E_Register_1016(
    .io_in_rd(D_E_Register_1016_io_in_rd),
    .io_in_rs1(D_E_Register_1016_io_in_rs1),
    .io_in_rd1(D_E_Register_1016_io_in_rd1),
    .io_in_rs2(D_E_Register_1016_io_in_rs2),
    .io_in_rd2(D_E_Register_1016_io_in_rd2),
    .io_in_alu_op(D_E_Register_1016_io_in_alu_op),
    .io_in_wb(D_E_Register_1016_io_in_wb),
    .io_in_rs2_src(D_E_Register_1016_io_in_rs2_src),
    .io_in_itype_immed(D_E_Register_1016_io_in_itype_immed),
    .io_in_mem_read(D_E_Register_1016_io_in_mem_read),
    .io_in_mem_write(D_E_Register_1016_io_in_mem_write),
    .io_in_PC_next(D_E_Register_1016_io_in_PC_next),
    .io_in_branch_type(D_E_Register_1016_io_in_branch_type),
    .io_in_fwd_stall(D_E_Register_1016_io_in_fwd_stall),
    .io_in_branch_stall(D_E_Register_1016_io_in_branch_stall),
    .io_in_upper_immed(D_E_Register_1016_io_in_upper_immed),
    .io_in_csr_address(D_E_Register_1016_io_in_csr_address),
    .io_in_is_csr(D_E_Register_1016_io_in_is_csr),
    .io_in_csr_mask(D_E_Register_1016_io_in_csr_mask),
    .io_in_curr_PC(D_E_Register_1016_io_in_curr_PC),
    .io_in_jal(D_E_Register_1016_io_in_jal),
    .io_in_jal_offset(D_E_Register_1016_io_in_jal_offset),
    .clk(D_E_Register_1016_clk),
    .reset(D_E_Register_1016_reset),
    .io_out_csr_address(D_E_Register_1016_io_out_csr_address),
    .io_out_is_csr(D_E_Register_1016_io_out_is_csr),
    .io_out_csr_mask(D_E_Register_1016_io_out_csr_mask),
    .io_out_rd(D_E_Register_1016_io_out_rd),
    .io_out_rs1(D_E_Register_1016_io_out_rs1),
    .io_out_rd1(D_E_Register_1016_io_out_rd1),
    .io_out_rs2(D_E_Register_1016_io_out_rs2),
    .io_out_rd2(D_E_Register_1016_io_out_rd2),
    .io_out_alu_op(D_E_Register_1016_io_out_alu_op),
    .io_out_wb(D_E_Register_1016_io_out_wb),
    .io_out_rs2_src(D_E_Register_1016_io_out_rs2_src),
    .io_out_itype_immed(D_E_Register_1016_io_out_itype_immed),
    .io_out_mem_read(D_E_Register_1016_io_out_mem_read),
    .io_out_mem_write(D_E_Register_1016_io_out_mem_write),
    .io_out_branch_type(D_E_Register_1016_io_out_branch_type),
    .io_out_upper_immed(D_E_Register_1016_io_out_upper_immed),
    .io_out_curr_PC(D_E_Register_1016_io_out_curr_PC),
    .io_out_jal(D_E_Register_1016_io_out_jal),
    .io_out_jal_offset(D_E_Register_1016_io_out_jal_offset),
    .io_out_PC_next(D_E_Register_1016_io_out_PC_next));
  Execute Execute_1238(
    .io_in_rd(Execute_1238_io_in_rd),
    .io_in_rs1(Execute_1238_io_in_rs1),
    .io_in_rd1(Execute_1238_io_in_rd1),
    .io_in_rs2(Execute_1238_io_in_rs2),
    .io_in_rd2(Execute_1238_io_in_rd2),
    .io_in_alu_op(Execute_1238_io_in_alu_op),
    .io_in_wb(Execute_1238_io_in_wb),
    .io_in_rs2_src(Execute_1238_io_in_rs2_src),
    .io_in_itype_immed(Execute_1238_io_in_itype_immed),
    .io_in_mem_read(Execute_1238_io_in_mem_read),
    .io_in_mem_write(Execute_1238_io_in_mem_write),
    .io_in_PC_next(Execute_1238_io_in_PC_next),
    .io_in_branch_type(Execute_1238_io_in_branch_type),
    .io_in_upper_immed(Execute_1238_io_in_upper_immed),
    .io_in_csr_address(Execute_1238_io_in_csr_address),
    .io_in_is_csr(Execute_1238_io_in_is_csr),
    .io_in_csr_data(Execute_1238_io_in_csr_data),
    .io_in_csr_mask(Execute_1238_io_in_csr_mask),
    .io_in_jal(Execute_1238_io_in_jal),
    .io_in_jal_offset(Execute_1238_io_in_jal_offset),
    .io_in_curr_PC(Execute_1238_io_in_curr_PC),
    .io_out_csr_address(Execute_1238_io_out_csr_address),
    .io_out_is_csr(Execute_1238_io_out_is_csr),
    .io_out_csr_result(Execute_1238_io_out_csr_result),
    .io_out_alu_result(Execute_1238_io_out_alu_result),
    .io_out_rd(Execute_1238_io_out_rd),
    .io_out_wb(Execute_1238_io_out_wb),
    .io_out_rs1(Execute_1238_io_out_rs1),
    .io_out_rd1(Execute_1238_io_out_rd1),
    .io_out_rs2(Execute_1238_io_out_rs2),
    .io_out_rd2(Execute_1238_io_out_rd2),
    .io_out_mem_read(Execute_1238_io_out_mem_read),
    .io_out_mem_write(Execute_1238_io_out_mem_write),
    .io_out_jal(Execute_1238_io_out_jal),
    .io_out_jal_dest(Execute_1238_io_out_jal_dest),
    .io_out_branch_offset(Execute_1238_io_out_branch_offset),
    .io_out_branch_stall(Execute_1238_io_out_branch_stall),
    .io_out_PC_next(Execute_1238_io_out_PC_next));
  E_M_Register E_M_Register_1421(
    .io_in_alu_result(E_M_Register_1421_io_in_alu_result),
    .io_in_rd(E_M_Register_1421_io_in_rd),
    .io_in_wb(E_M_Register_1421_io_in_wb),
    .io_in_rs1(E_M_Register_1421_io_in_rs1),
    .io_in_rd1(E_M_Register_1421_io_in_rd1),
    .io_in_rs2(E_M_Register_1421_io_in_rs2),
    .io_in_rd2(E_M_Register_1421_io_in_rd2),
    .io_in_mem_read(E_M_Register_1421_io_in_mem_read),
    .io_in_mem_write(E_M_Register_1421_io_in_mem_write),
    .io_in_PC_next(E_M_Register_1421_io_in_PC_next),
    .io_in_csr_address(E_M_Register_1421_io_in_csr_address),
    .io_in_is_csr(E_M_Register_1421_io_in_is_csr),
    .io_in_csr_result(E_M_Register_1421_io_in_csr_result),
    .io_in_curr_PC(E_M_Register_1421_io_in_curr_PC),
    .io_in_branch_offset(E_M_Register_1421_io_in_branch_offset),
    .io_in_branch_type(E_M_Register_1421_io_in_branch_type),
    .clk(E_M_Register_1421_clk),
    .reset(E_M_Register_1421_reset),
    .io_out_csr_address(E_M_Register_1421_io_out_csr_address),
    .io_out_is_csr(E_M_Register_1421_io_out_is_csr),
    .io_out_csr_result(E_M_Register_1421_io_out_csr_result),
    .io_out_alu_result(E_M_Register_1421_io_out_alu_result),
    .io_out_rd(E_M_Register_1421_io_out_rd),
    .io_out_wb(E_M_Register_1421_io_out_wb),
    .io_out_rs1(E_M_Register_1421_io_out_rs1),
    .io_out_rd1(E_M_Register_1421_io_out_rd1),
    .io_out_rd2(E_M_Register_1421_io_out_rd2),
    .io_out_rs2(E_M_Register_1421_io_out_rs2),
    .io_out_mem_read(E_M_Register_1421_io_out_mem_read),
    .io_out_mem_write(E_M_Register_1421_io_out_mem_write),
    .io_out_curr_PC(E_M_Register_1421_io_out_curr_PC),
    .io_out_branch_offset(E_M_Register_1421_io_out_branch_offset),
    .io_out_branch_type(E_M_Register_1421_io_out_branch_type),
    .io_out_PC_next(E_M_Register_1421_io_out_PC_next));
  Memory Memory_1681(
    .io_DBUS_in_data_data(Memory_1681_io_DBUS_in_data_data),
    .io_DBUS_in_data_valid(Memory_1681_io_DBUS_in_data_valid),
    .io_DBUS_out_data_ready(Memory_1681_io_DBUS_out_data_ready),
    .io_DBUS_out_address_ready(Memory_1681_io_DBUS_out_address_ready),
    .io_DBUS_out_control_ready(Memory_1681_io_DBUS_out_control_ready),
    .io_in_alu_result(Memory_1681_io_in_alu_result),
    .io_in_mem_read(Memory_1681_io_in_mem_read),
    .io_in_mem_write(Memory_1681_io_in_mem_write),
    .io_in_rd(Memory_1681_io_in_rd),
    .io_in_wb(Memory_1681_io_in_wb),
    .io_in_rs1(Memory_1681_io_in_rs1),
    .io_in_rd1(Memory_1681_io_in_rd1),
    .io_in_rs2(Memory_1681_io_in_rs2),
    .io_in_rd2(Memory_1681_io_in_rd2),
    .io_in_PC_next(Memory_1681_io_in_PC_next),
    .io_in_curr_PC(Memory_1681_io_in_curr_PC),
    .io_in_branch_offset(Memory_1681_io_in_branch_offset),
    .io_in_branch_type(Memory_1681_io_in_branch_type),
    .io_DBUS_out_miss(Memory_1681_io_DBUS_out_miss),
    .io_DBUS_out_rw(Memory_1681_io_DBUS_out_rw),
    .io_DBUS_in_data_ready(Memory_1681_io_DBUS_in_data_ready),
    .io_DBUS_out_data_data(Memory_1681_io_DBUS_out_data_data),
    .io_DBUS_out_data_valid(Memory_1681_io_DBUS_out_data_valid),
    .io_DBUS_out_address_data(Memory_1681_io_DBUS_out_address_data),
    .io_DBUS_out_address_valid(Memory_1681_io_DBUS_out_address_valid),
    .io_DBUS_out_control_data(Memory_1681_io_DBUS_out_control_data),
    .io_DBUS_out_control_valid(Memory_1681_io_DBUS_out_control_valid),
    .io_out_alu_result(Memory_1681_io_out_alu_result),
    .io_out_mem_result(Memory_1681_io_out_mem_result),
    .io_out_rd(Memory_1681_io_out_rd),
    .io_out_wb(Memory_1681_io_out_wb),
    .io_out_rs1(Memory_1681_io_out_rs1),
    .io_out_rs2(Memory_1681_io_out_rs2),
    .io_out_branch_dir(Memory_1681_io_out_branch_dir),
    .io_out_branch_dest(Memory_1681_io_out_branch_dest),
    .io_out_delay(),
    .io_out_PC_next(Memory_1681_io_out_PC_next));
  M_W_Register M_W_Register_1804(
    .io_in_alu_result(M_W_Register_1804_io_in_alu_result),
    .io_in_mem_result(M_W_Register_1804_io_in_mem_result),
    .io_in_rd(M_W_Register_1804_io_in_rd),
    .io_in_wb(M_W_Register_1804_io_in_wb),
    .io_in_rs1(M_W_Register_1804_io_in_rs1),
    .io_in_rs2(M_W_Register_1804_io_in_rs2),
    .io_in_PC_next(M_W_Register_1804_io_in_PC_next),
    .clk(M_W_Register_1804_clk),
    .reset(M_W_Register_1804_reset),
    .io_out_alu_result(M_W_Register_1804_io_out_alu_result),
    .io_out_mem_result(M_W_Register_1804_io_out_mem_result),
    .io_out_rd(M_W_Register_1804_io_out_rd),
    .io_out_wb(M_W_Register_1804_io_out_wb),
    .io_out_rs1(M_W_Register_1804_io_out_rs1),
    .io_out_rs2(M_W_Register_1804_io_out_rs2),
    .io_out_PC_next(M_W_Register_1804_io_out_PC_next));
  Write_Back Write_Back_1856(
    .io_in_alu_result(Write_Back_1856_io_in_alu_result),
    .io_in_mem_result(Write_Back_1856_io_in_mem_result),
    .io_in_rd(Write_Back_1856_io_in_rd),
    .io_in_wb(Write_Back_1856_io_in_wb),
    .io_in_rs1(Write_Back_1856_io_in_rs1),
    .io_in_rs2(Write_Back_1856_io_in_rs2),
    .io_in_PC_next(Write_Back_1856_io_in_PC_next),
    .io_out_write_data(Write_Back_1856_io_out_write_data),
    .io_out_rd(Write_Back_1856_io_out_rd),
    .io_out_wb(Write_Back_1856_io_out_wb));
  Forwarding Forwarding_2028(
    .io_in_decode_src1(Forwarding_2028_io_in_decode_src1),
    .io_in_decode_src2(Forwarding_2028_io_in_decode_src2),
    .io_in_decode_csr_address(Forwarding_2028_io_in_decode_csr_address),
    .io_in_execute_dest(Forwarding_2028_io_in_execute_dest),
    .io_in_execute_wb(Forwarding_2028_io_in_execute_wb),
    .io_in_execute_alu_result(Forwarding_2028_io_in_execute_alu_result),
    .io_in_execute_PC_next(Forwarding_2028_io_in_execute_PC_next),
    .io_in_execute_is_csr(Forwarding_2028_io_in_execute_is_csr),
    .io_in_execute_csr_address(Forwarding_2028_io_in_execute_csr_address),
    .io_in_execute_csr_result(Forwarding_2028_io_in_execute_csr_result),
    .io_in_memory_dest(Forwarding_2028_io_in_memory_dest),
    .io_in_memory_wb(Forwarding_2028_io_in_memory_wb),
    .io_in_memory_alu_result(Forwarding_2028_io_in_memory_alu_result),
    .io_in_memory_mem_data(Forwarding_2028_io_in_memory_mem_data),
    .io_in_memory_PC_next(Forwarding_2028_io_in_memory_PC_next),
    .io_in_memory_is_csr(Forwarding_2028_io_in_memory_is_csr),
    .io_in_memory_csr_address(Forwarding_2028_io_in_memory_csr_address),
    .io_in_memory_csr_result(Forwarding_2028_io_in_memory_csr_result),
    .io_in_writeback_dest(Forwarding_2028_io_in_writeback_dest),
    .io_in_writeback_wb(Forwarding_2028_io_in_writeback_wb),
    .io_in_writeback_alu_result(Forwarding_2028_io_in_writeback_alu_result),
    .io_in_writeback_mem_data(Forwarding_2028_io_in_writeback_mem_data),
    .io_in_writeback_PC_next(Forwarding_2028_io_in_writeback_PC_next),
    .io_out_src1_fwd(Forwarding_2028_io_out_src1_fwd),
    .io_out_src2_fwd(Forwarding_2028_io_out_src2_fwd),
    .io_out_csr_fwd(Forwarding_2028_io_out_csr_fwd),
    .io_out_src1_fwd_data(Forwarding_2028_io_out_src1_fwd_data),
    .io_out_src2_fwd_data(Forwarding_2028_io_out_src2_fwd_data),
    .io_out_csr_fwd_data(Forwarding_2028_io_out_csr_fwd_data),
    .io_out_fwd_stall(Forwarding_2028_io_out_fwd_stall));
  Interrupt_Handler Interrupt_Handler_2104(
    .io_INTERRUPT_in_interrupt_id_data(Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_data),
    .io_INTERRUPT_in_interrupt_id_valid(Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_valid),
    .io_INTERRUPT_in_interrupt_id_ready(Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_ready),
    .io_out_interrupt(Interrupt_Handler_2104_io_out_interrupt),
    .io_out_interrupt_pc(Interrupt_Handler_2104_io_out_interrupt_pc));
  JTAG JTAG_2339(
    .io_JTAG_JTAG_TAP_in_mode_select_data(JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_data),
    .io_JTAG_JTAG_TAP_in_mode_select_valid(JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_valid),
    .io_JTAG_JTAG_TAP_in_clock_data(JTAG_2339_io_JTAG_JTAG_TAP_in_clock_data),
    .io_JTAG_JTAG_TAP_in_clock_valid(JTAG_2339_io_JTAG_JTAG_TAP_in_clock_valid),
    .io_JTAG_JTAG_TAP_in_reset_data(JTAG_2339_io_JTAG_JTAG_TAP_in_reset_data),
    .io_JTAG_JTAG_TAP_in_reset_valid(JTAG_2339_io_JTAG_JTAG_TAP_in_reset_valid),
    .io_JTAG_in_data_data(JTAG_2339_io_JTAG_in_data_data),
    .io_JTAG_in_data_valid(JTAG_2339_io_JTAG_in_data_valid),
    .io_JTAG_out_data_ready(JTAG_2339_io_JTAG_out_data_ready),
    .clk(JTAG_2339_clk),
    .reset(JTAG_2339_reset),
    .io_JTAG_JTAG_TAP_in_mode_select_ready(JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_ready),
    .io_JTAG_JTAG_TAP_in_clock_ready(JTAG_2339_io_JTAG_JTAG_TAP_in_clock_ready),
    .io_JTAG_JTAG_TAP_in_reset_ready(JTAG_2339_io_JTAG_JTAG_TAP_in_reset_ready),
    .io_JTAG_in_data_ready(JTAG_2339_io_JTAG_in_data_ready),
    .io_JTAG_out_data_data(JTAG_2339_io_JTAG_out_data_data),
    .io_JTAG_out_data_valid(JTAG_2339_io_JTAG_out_data_valid));
  CSR_Handler CSR_Handler_2433(
    .io_in_decode_csr_address(CSR_Handler_2433_io_in_decode_csr_address),
    .io_in_mem_csr_address(CSR_Handler_2433_io_in_mem_csr_address),
    .io_in_mem_is_csr(CSR_Handler_2433_io_in_mem_is_csr),
    .io_in_mem_csr_result(CSR_Handler_2433_io_in_mem_csr_result),
    .clk(CSR_Handler_2433_clk),
    .reset(CSR_Handler_2433_reset),
    .io_out_decode_csr_data(CSR_Handler_2433_io_out_decode_csr_data));
  assign Fetch_222_clk = clk;
  assign Fetch_222_reset = reset;
  assign Fetch_222_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign Fetch_222_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign Fetch_222_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign Fetch_222_io_in_branch_dir = proxy_Fetch_io_in_branch_dir_240;
  assign Fetch_222_io_in_freeze = proxy_Fetch_io_in_freeze_242;
  assign Fetch_222_io_in_branch_dest = proxy_Fetch_io_in_branch_dest_244;
  assign Fetch_222_io_in_branch_stall = proxy_Fetch_io_in_branch_stall_246;
  assign Fetch_222_io_in_fwd_stall = proxy_Fetch_io_in_fwd_stall_248;
  assign Fetch_222_io_in_branch_stall_exe = proxy_Fetch_io_in_branch_stall_exe_250;
  assign Fetch_222_io_in_jal = proxy_Fetch_io_in_jal_252;
  assign Fetch_222_io_in_jal_dest = proxy_Fetch_io_in_jal_dest_254;
  assign Fetch_222_io_in_interrupt = proxy_Fetch_io_in_interrupt_256;
  assign Fetch_222_io_in_interrupt_pc = proxy_Fetch_io_in_interrupt_pc_258;
  assign Fetch_222_io_in_debug = 1'h0;
  assign F_D_Register_301_clk = clk;
  assign F_D_Register_301_reset = reset;
  assign F_D_Register_301_io_in_instruction = proxy_F_D_Register_io_in_instruction_304;
  assign F_D_Register_301_io_in_curr_PC = proxy_F_D_Register_io_in_curr_PC_306;
  assign F_D_Register_301_io_in_branch_stall = proxy_F_D_Register_io_in_branch_stall_308;
  assign F_D_Register_301_io_in_branch_stall_exe = proxy_F_D_Register_io_in_branch_stall_exe_310;
  assign F_D_Register_301_io_in_fwd_stall = proxy_F_D_Register_io_in_fwd_stall_312;
  assign Decode_768_clk = clk;
  assign Decode_768_io_in_instruction = proxy_Decode_io_in_instruction_770;
  assign Decode_768_io_in_curr_PC = proxy_Decode_io_in_curr_PC_772;
  assign Decode_768_io_in_stall = op_eq_2450;
  assign Decode_768_io_in_write_data = proxy_Decode_io_in_write_data_776;
  assign Decode_768_io_in_rd = proxy_Decode_io_in_rd_778;
  assign Decode_768_io_in_wb = proxy_Decode_io_in_wb_780;
  assign Decode_768_io_in_src1_fwd = proxy_Decode_io_in_src1_fwd_782;
  assign Decode_768_io_in_src1_fwd_data = proxy_Decode_io_in_src1_fwd_data_784;
  assign Decode_768_io_in_src2_fwd = proxy_Decode_io_in_src2_fwd_786;
  assign Decode_768_io_in_src2_fwd_data = proxy_Decode_io_in_src2_fwd_data_788;
  assign Decode_768_io_in_csr_fwd = proxy_Decode_io_in_csr_fwd_790;
  assign Decode_768_io_in_csr_fwd_data = proxy_Decode_io_in_csr_fwd_data_792;
  assign D_E_Register_1016_clk = clk;
  assign D_E_Register_1016_reset = reset;
  assign D_E_Register_1016_io_in_rd = proxy_D_E_Register_io_in_rd_1019;
  assign D_E_Register_1016_io_in_rs1 = proxy_D_E_Register_io_in_rs1_1021;
  assign D_E_Register_1016_io_in_rd1 = proxy_D_E_Register_io_in_rd1_1023;
  assign D_E_Register_1016_io_in_rs2 = proxy_D_E_Register_io_in_rs2_1025;
  assign D_E_Register_1016_io_in_rd2 = proxy_D_E_Register_io_in_rd2_1027;
  assign D_E_Register_1016_io_in_alu_op = proxy_D_E_Register_io_in_alu_op_1029;
  assign D_E_Register_1016_io_in_wb = proxy_D_E_Register_io_in_wb_1031;
  assign D_E_Register_1016_io_in_rs2_src = proxy_D_E_Register_io_in_rs2_src_1033;
  assign D_E_Register_1016_io_in_itype_immed = proxy_D_E_Register_io_in_itype_immed_1035;
  assign D_E_Register_1016_io_in_mem_read = proxy_D_E_Register_io_in_mem_read_1037;
  assign D_E_Register_1016_io_in_mem_write = proxy_D_E_Register_io_in_mem_write_1039;
  assign D_E_Register_1016_io_in_PC_next = proxy_D_E_Register_io_in_PC_next_1041;
  assign D_E_Register_1016_io_in_branch_type = proxy_D_E_Register_io_in_branch_type_1043;
  assign D_E_Register_1016_io_in_fwd_stall = proxy_D_E_Register_io_in_fwd_stall_1045;
  assign D_E_Register_1016_io_in_branch_stall = proxy_D_E_Register_io_in_branch_stall_1047;
  assign D_E_Register_1016_io_in_upper_immed = proxy_D_E_Register_io_in_upper_immed_1049;
  assign D_E_Register_1016_io_in_csr_address = proxy_D_E_Register_io_in_csr_address_1051;
  assign D_E_Register_1016_io_in_is_csr = proxy_D_E_Register_io_in_is_csr_1053;
  assign D_E_Register_1016_io_in_csr_mask = proxy_D_E_Register_io_in_csr_mask_1055;
  assign D_E_Register_1016_io_in_curr_PC = proxy_D_E_Register_io_in_curr_PC_1057;
  assign D_E_Register_1016_io_in_jal = proxy_D_E_Register_io_in_jal_1059;
  assign D_E_Register_1016_io_in_jal_offset = proxy_D_E_Register_io_in_jal_offset_1061;
  assign Execute_1238_io_in_rd = proxy_Execute_io_in_rd_1239;
  assign Execute_1238_io_in_rs1 = proxy_Execute_io_in_rs1_1241;
  assign Execute_1238_io_in_rd1 = proxy_Execute_io_in_rd1_1243;
  assign Execute_1238_io_in_rs2 = proxy_Execute_io_in_rs2_1245;
  assign Execute_1238_io_in_rd2 = proxy_Execute_io_in_rd2_1247;
  assign Execute_1238_io_in_alu_op = proxy_Execute_io_in_alu_op_1249;
  assign Execute_1238_io_in_wb = proxy_Execute_io_in_wb_1251;
  assign Execute_1238_io_in_rs2_src = proxy_Execute_io_in_rs2_src_1253;
  assign Execute_1238_io_in_itype_immed = proxy_Execute_io_in_itype_immed_1255;
  assign Execute_1238_io_in_mem_read = proxy_Execute_io_in_mem_read_1257;
  assign Execute_1238_io_in_mem_write = proxy_Execute_io_in_mem_write_1259;
  assign Execute_1238_io_in_PC_next = proxy_Execute_io_in_PC_next_1261;
  assign Execute_1238_io_in_branch_type = proxy_Execute_io_in_branch_type_1263;
  assign Execute_1238_io_in_upper_immed = proxy_Execute_io_in_upper_immed_1265;
  assign Execute_1238_io_in_csr_address = proxy_Execute_io_in_csr_address_1267;
  assign Execute_1238_io_in_is_csr = proxy_Execute_io_in_is_csr_1269;
  assign Execute_1238_io_in_csr_data = proxy_Execute_io_in_csr_data_1271;
  assign Execute_1238_io_in_csr_mask = proxy_Execute_io_in_csr_mask_1273;
  assign Execute_1238_io_in_jal = proxy_Execute_io_in_jal_1275;
  assign Execute_1238_io_in_jal_offset = proxy_Execute_io_in_jal_offset_1277;
  assign Execute_1238_io_in_curr_PC = proxy_Execute_io_in_curr_PC_1279;
  assign E_M_Register_1421_clk = clk;
  assign E_M_Register_1421_reset = reset;
  assign E_M_Register_1421_io_in_alu_result = proxy_E_M_Register_io_in_alu_result_1424;
  assign E_M_Register_1421_io_in_rd = proxy_E_M_Register_io_in_rd_1426;
  assign E_M_Register_1421_io_in_wb = proxy_E_M_Register_io_in_wb_1428;
  assign E_M_Register_1421_io_in_rs1 = proxy_E_M_Register_io_in_rs1_1430;
  assign E_M_Register_1421_io_in_rd1 = proxy_E_M_Register_io_in_rd1_1432;
  assign E_M_Register_1421_io_in_rs2 = proxy_E_M_Register_io_in_rs2_1434;
  assign E_M_Register_1421_io_in_rd2 = proxy_E_M_Register_io_in_rd2_1436;
  assign E_M_Register_1421_io_in_mem_read = proxy_E_M_Register_io_in_mem_read_1438;
  assign E_M_Register_1421_io_in_mem_write = proxy_E_M_Register_io_in_mem_write_1440;
  assign E_M_Register_1421_io_in_PC_next = proxy_E_M_Register_io_in_PC_next_1442;
  assign E_M_Register_1421_io_in_csr_address = proxy_E_M_Register_io_in_csr_address_1444;
  assign E_M_Register_1421_io_in_is_csr = proxy_E_M_Register_io_in_is_csr_1446;
  assign E_M_Register_1421_io_in_csr_result = proxy_E_M_Register_io_in_csr_result_1448;
  assign E_M_Register_1421_io_in_curr_PC = proxy_E_M_Register_io_in_curr_PC_1450;
  assign E_M_Register_1421_io_in_branch_offset = proxy_E_M_Register_io_in_branch_offset_1452;
  assign E_M_Register_1421_io_in_branch_type = proxy_E_M_Register_io_in_branch_type_1454;
  assign Memory_1681_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Memory_1681_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Memory_1681_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Memory_1681_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Memory_1681_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Memory_1681_io_in_alu_result = proxy_Memory_io_in_alu_result_1710;
  assign Memory_1681_io_in_mem_read = proxy_Memory_io_in_mem_read_1712;
  assign Memory_1681_io_in_mem_write = proxy_Memory_io_in_mem_write_1714;
  assign Memory_1681_io_in_rd = proxy_Memory_io_in_rd_1716;
  assign Memory_1681_io_in_wb = proxy_Memory_io_in_wb_1718;
  assign Memory_1681_io_in_rs1 = proxy_Memory_io_in_rs1_1720;
  assign Memory_1681_io_in_rd1 = proxy_Memory_io_in_rd1_1722;
  assign Memory_1681_io_in_rs2 = proxy_Memory_io_in_rs2_1724;
  assign Memory_1681_io_in_rd2 = proxy_Memory_io_in_rd2_1726;
  assign Memory_1681_io_in_PC_next = proxy_Memory_io_in_PC_next_1728;
  assign Memory_1681_io_in_curr_PC = proxy_Memory_io_in_curr_PC_1730;
  assign Memory_1681_io_in_branch_offset = proxy_Memory_io_in_branch_offset_1732;
  assign Memory_1681_io_in_branch_type = proxy_Memory_io_in_branch_type_1734;
  assign M_W_Register_1804_clk = clk;
  assign M_W_Register_1804_reset = reset;
  assign M_W_Register_1804_io_in_alu_result = proxy_M_W_Register_io_in_alu_result_1807;
  assign M_W_Register_1804_io_in_mem_result = proxy_M_W_Register_io_in_mem_result_1809;
  assign M_W_Register_1804_io_in_rd = proxy_M_W_Register_io_in_rd_1811;
  assign M_W_Register_1804_io_in_wb = proxy_M_W_Register_io_in_wb_1813;
  assign M_W_Register_1804_io_in_rs1 = proxy_M_W_Register_io_in_rs1_1815;
  assign M_W_Register_1804_io_in_rs2 = proxy_M_W_Register_io_in_rs2_1817;
  assign M_W_Register_1804_io_in_PC_next = proxy_M_W_Register_io_in_PC_next_1819;
  assign Write_Back_1856_io_in_alu_result = proxy_Write_Back_io_in_alu_result_1857;
  assign Write_Back_1856_io_in_mem_result = proxy_Write_Back_io_in_mem_result_1859;
  assign Write_Back_1856_io_in_rd = proxy_Write_Back_io_in_rd_1861;
  assign Write_Back_1856_io_in_wb = proxy_Write_Back_io_in_wb_1863;
  assign Write_Back_1856_io_in_rs1 = proxy_Write_Back_io_in_rs1_1865;
  assign Write_Back_1856_io_in_rs2 = proxy_Write_Back_io_in_rs2_1867;
  assign Write_Back_1856_io_in_PC_next = proxy_Write_Back_io_in_PC_next_1869;
  assign Forwarding_2028_io_in_decode_src1 = proxy_Forwarding_io_in_decode_src1_2029;
  assign Forwarding_2028_io_in_decode_src2 = proxy_Forwarding_io_in_decode_src2_2031;
  assign Forwarding_2028_io_in_decode_csr_address = proxy_Forwarding_io_in_decode_csr_address_2033;
  assign Forwarding_2028_io_in_execute_dest = proxy_Forwarding_io_in_execute_dest_2035;
  assign Forwarding_2028_io_in_execute_wb = proxy_Forwarding_io_in_execute_wb_2037;
  assign Forwarding_2028_io_in_execute_alu_result = proxy_Forwarding_io_in_execute_alu_result_2039;
  assign Forwarding_2028_io_in_execute_PC_next = proxy_Forwarding_io_in_execute_PC_next_2041;
  assign Forwarding_2028_io_in_execute_is_csr = proxy_Forwarding_io_in_execute_is_csr_2043;
  assign Forwarding_2028_io_in_execute_csr_address = proxy_Forwarding_io_in_execute_csr_address_2045;
  assign Forwarding_2028_io_in_execute_csr_result = proxy_Forwarding_io_in_execute_csr_result_2047;
  assign Forwarding_2028_io_in_memory_dest = proxy_Forwarding_io_in_memory_dest_2049;
  assign Forwarding_2028_io_in_memory_wb = proxy_Forwarding_io_in_memory_wb_2051;
  assign Forwarding_2028_io_in_memory_alu_result = proxy_Forwarding_io_in_memory_alu_result_2053;
  assign Forwarding_2028_io_in_memory_mem_data = proxy_Forwarding_io_in_memory_mem_data_2055;
  assign Forwarding_2028_io_in_memory_PC_next = proxy_Forwarding_io_in_memory_PC_next_2057;
  assign Forwarding_2028_io_in_memory_is_csr = proxy_Forwarding_io_in_memory_is_csr_2059;
  assign Forwarding_2028_io_in_memory_csr_address = proxy_Forwarding_io_in_memory_csr_address_2061;
  assign Forwarding_2028_io_in_memory_csr_result = proxy_Forwarding_io_in_memory_csr_result_2063;
  assign Forwarding_2028_io_in_writeback_dest = proxy_Forwarding_io_in_writeback_dest_2065;
  assign Forwarding_2028_io_in_writeback_wb = proxy_Forwarding_io_in_writeback_wb_2067;
  assign Forwarding_2028_io_in_writeback_alu_result = proxy_Forwarding_io_in_writeback_alu_result_2069;
  assign Forwarding_2028_io_in_writeback_mem_data = proxy_Forwarding_io_in_writeback_mem_data_2071;
  assign Forwarding_2028_io_in_writeback_PC_next = proxy_Forwarding_io_in_writeback_PC_next_2073;
  assign Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_data = io_INTERRUPT_in_interrupt_id_data;
  assign Interrupt_Handler_2104_io_INTERRUPT_in_interrupt_id_valid = io_INTERRUPT_in_interrupt_id_valid;
  assign JTAG_2339_clk = clk;
  assign JTAG_2339_reset = reset;
  assign JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_data = io_jtag_JTAG_TAP_in_mode_select_data;
  assign JTAG_2339_io_JTAG_JTAG_TAP_in_mode_select_valid = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign JTAG_2339_io_JTAG_JTAG_TAP_in_clock_data = io_jtag_JTAG_TAP_in_clock_data;
  assign JTAG_2339_io_JTAG_JTAG_TAP_in_clock_valid = io_jtag_JTAG_TAP_in_clock_valid;
  assign JTAG_2339_io_JTAG_JTAG_TAP_in_reset_data = io_jtag_JTAG_TAP_in_reset_data;
  assign JTAG_2339_io_JTAG_JTAG_TAP_in_reset_valid = io_jtag_JTAG_TAP_in_reset_valid;
  assign JTAG_2339_io_JTAG_in_data_data = io_jtag_in_data_data;
  assign JTAG_2339_io_JTAG_in_data_valid = io_jtag_in_data_valid;
  assign JTAG_2339_io_JTAG_out_data_ready = io_jtag_out_data_ready;
  assign CSR_Handler_2433_clk = clk;
  assign CSR_Handler_2433_reset = reset;
  assign CSR_Handler_2433_io_in_decode_csr_address = proxy_CSR_Handler_io_in_decode_csr_address_2436;
  assign CSR_Handler_2433_io_in_mem_csr_address = proxy_CSR_Handler_io_in_mem_csr_address_2438;
  assign CSR_Handler_2433_io_in_mem_is_csr = proxy_CSR_Handler_io_in_mem_is_csr_2440;
  assign CSR_Handler_2433_io_in_mem_csr_result = proxy_CSR_Handler_io_in_mem_csr_result_2442;

  assign io_IBUS_in_data_ready = proxy_io_IBUS_in_data_ready_3;
  assign io_IBUS_out_address_data = proxy_io_IBUS_out_address_data_5;
  assign io_IBUS_out_address_valid = proxy_io_IBUS_out_address_valid_7;
  assign io_DBUS_out_miss = proxy_io_DBUS_out_miss_10;
  assign io_DBUS_out_rw = proxy_io_DBUS_out_rw_12;
  assign io_DBUS_in_data_ready = proxy_io_DBUS_in_data_ready_16;
  assign io_DBUS_out_data_data = proxy_io_DBUS_out_data_data_18;
  assign io_DBUS_out_data_valid = proxy_io_DBUS_out_data_valid_20;
  assign io_DBUS_out_address_data = proxy_io_DBUS_out_address_data_23;
  assign io_DBUS_out_address_valid = proxy_io_DBUS_out_address_valid_25;
  assign io_DBUS_out_control_data = proxy_io_DBUS_out_control_data_28;
  assign io_DBUS_out_control_valid = proxy_io_DBUS_out_control_valid_30;
  assign io_INTERRUPT_in_interrupt_id_ready = proxy_io_INTERRUPT_in_interrupt_id_ready_35;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = proxy_io_jtag_JTAG_TAP_in_mode_select_ready_39;
  assign io_jtag_JTAG_TAP_in_clock_ready = proxy_io_jtag_JTAG_TAP_in_clock_ready_43;
  assign io_jtag_JTAG_TAP_in_reset_ready = proxy_io_jtag_JTAG_TAP_in_reset_ready_47;
  assign io_jtag_in_data_ready = proxy_io_jtag_in_data_ready_51;
  assign io_jtag_out_data_data = proxy_io_jtag_out_data_data_53;
  assign io_jtag_out_data_valid = proxy_io_jtag_out_data_valid_55;
  assign io_out_fwd_stall = proxy_io_out_fwd_stall_59;
  assign io_out_branch_stall = op_orl_2446;

endmodule
