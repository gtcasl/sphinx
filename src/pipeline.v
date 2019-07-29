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
  reg reg_ch_bit_1u_131, reg_ch_bit_1u_133, reg_ch_bit_1u_149;
  reg[31:0] reg_ch_bit_32u_136, reg_ch_bit_32u_141, reg_ch_bit_32u_143, reg_ch_bit_32u_145, sel_158;
  reg[4:0] reg_ch_bit_5u_139;
  wire[31:0] sel_160, sel_162, sel_164, sel_170, sel_192, sel_201, sel_210, op_add_237, op_add_240, op_add_243, ICACHE_107_io_IBUS_in_data_data, ICACHE_107_io_IBUS_out_address_data, ICACHE_107_io_in_address, ICACHE_107_io_out_instruction;
  wire[4:0] sel_218, sel_224, sel_227, sel_230, sel_233;
  wire op_notl_166, op_andl_168, op_eq_174, op_eq_177, op_orl_179, op_orl_181, op_orl_183, op_orl_185, op_orl_187, op_orl_189, op_notl_194, op_eq_197, op_andl_199, op_eq_206, op_andl_208, ICACHE_107_io_IBUS_in_data_valid, ICACHE_107_io_IBUS_in_data_ready, ICACHE_107_io_IBUS_out_address_valid, ICACHE_107_io_IBUS_out_address_ready, ICACHE_107_io_out_delay;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_131 <= 1'h0;
    else
      reg_ch_bit_1u_131 <= op_orl_187;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_133 <= 1'h0;
    else
      reg_ch_bit_1u_133 <= op_orl_189;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_136 <= 32'h0;
    else
      reg_ch_bit_32u_136 <= sel_210;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_139 <= 5'h0;
    else
      reg_ch_bit_5u_139 <= sel_233;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_141 <= 32'h0;
    else
      reg_ch_bit_32u_141 <= op_add_237;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_143 <= 32'h0;
    else
      reg_ch_bit_32u_143 <= op_add_240;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_145 <= 32'h0;
    else
      reg_ch_bit_32u_145 <= op_add_243;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_149 <= 1'h0;
    else
      reg_ch_bit_1u_149 <= io_in_debug;
  end
  always @(*) begin
    case (reg_ch_bit_5u_139)
      5'h00: sel_158 = reg_ch_bit_32u_141;
      5'h01: sel_158 = reg_ch_bit_32u_143;
      5'h02: sel_158 = reg_ch_bit_32u_145;
      5'h03: sel_158 = reg_ch_bit_32u_141;
      5'h04: sel_158 = reg_ch_bit_32u_136;
      default: sel_158 = 32'h0;
    endcase
  end
  assign sel_160 = reg_ch_bit_1u_131 ? reg_ch_bit_32u_136 : sel_158;
  assign sel_162 = reg_ch_bit_1u_149 ? reg_ch_bit_32u_136 : reg_ch_bit_32u_141;
  assign sel_164 = io_in_debug ? sel_162 : sel_160;
  assign sel_170 = op_andl_168 ? reg_ch_bit_32u_136 : sel_164;
  assign sel_192 = op_orl_187 ? 32'h0 : ICACHE_107_io_out_instruction;
  assign sel_201 = op_andl_199 ? io_in_branch_dest : sel_170;
  assign sel_210 = op_andl_208 ? io_in_jal_dest : sel_201;
  assign sel_218 = op_eq_197 ? 5'h2 : 5'h0;
  assign sel_224 = op_eq_206 ? 5'h1 : sel_218;
  assign sel_227 = io_in_interrupt ? 5'h3 : sel_224;
  assign sel_230 = reg_ch_bit_1u_149 ? 5'h4 : sel_227;
  assign sel_233 = io_in_debug ? 5'h3 : sel_230;
  assign op_notl_166 = !io_in_freeze;
  assign op_andl_168 = reg_ch_bit_1u_133 && op_notl_166;
  assign op_eq_174 = io_in_fwd_stall == 1'h1;
  assign op_eq_177 = io_in_branch_stall == 1'h1;
  assign op_orl_179 = op_eq_177 || op_eq_174;
  assign op_orl_181 = op_orl_179 || io_in_branch_stall_exe;
  assign op_orl_183 = op_orl_181 || io_in_interrupt;
  assign op_orl_185 = op_orl_183 || ICACHE_107_io_out_delay;
  assign op_orl_187 = op_orl_185 || io_in_freeze;
  assign op_orl_189 = ICACHE_107_io_out_delay || io_in_freeze;
  assign op_notl_194 = !reg_ch_bit_1u_133;
  assign op_eq_197 = io_in_branch_dir == 1'h1;
  assign op_andl_199 = op_eq_197 && op_notl_194;
  assign op_eq_206 = io_in_jal == 1'h1;
  assign op_andl_208 = op_eq_206 && op_notl_194;
  assign op_add_237 = sel_170 + 32'h4;
  assign op_add_240 = io_in_jal_dest + 32'h4;
  assign op_add_243 = io_in_branch_dest + 32'h4;
  ICACHE ICACHE_107(.io_IBUS_in_data_data(ICACHE_107_io_IBUS_in_data_data), .io_IBUS_in_data_valid(ICACHE_107_io_IBUS_in_data_valid), .io_IBUS_out_address_ready(ICACHE_107_io_IBUS_out_address_ready), .io_in_address(ICACHE_107_io_in_address), .io_IBUS_in_data_ready(ICACHE_107_io_IBUS_in_data_ready), .io_IBUS_out_address_data(ICACHE_107_io_IBUS_out_address_data), .io_IBUS_out_address_valid(ICACHE_107_io_IBUS_out_address_valid), .io_out_instruction(ICACHE_107_io_out_instruction), .io_out_delay(ICACHE_107_io_out_delay));
  assign ICACHE_107_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign ICACHE_107_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign ICACHE_107_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign ICACHE_107_io_in_address = sel_210;

  assign io_IBUS_in_data_ready = ICACHE_107_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = ICACHE_107_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = ICACHE_107_io_IBUS_out_address_valid;
  assign io_out_instruction = sel_192;
  assign io_out_delay = ICACHE_107_io_out_delay;
  assign io_out_curr_PC = sel_210;

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
  reg[31:0] reg_ch_bit_32u_308, reg_ch_bit_32u_310;
  wire[31:0] sel_329, sel_330;
  wire op_eq_327;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_308 <= 32'h0;
    else
      reg_ch_bit_32u_308 <= sel_330;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_310 <= 32'h0;
    else
      reg_ch_bit_32u_310 <= sel_329;
  end
  assign sel_329 = op_eq_327 ? io_in_curr_PC : reg_ch_bit_32u_310;
  assign sel_330 = op_eq_327 ? io_in_instruction : reg_ch_bit_32u_308;
  assign op_eq_327 = io_in_fwd_stall == 1'h0;

  assign io_out_instruction = reg_ch_bit_32u_308;
  assign io_out_curr_PC = reg_ch_bit_32u_310;

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
  reg[31:0] mem_ch_bit_32u_409 [0:31];
  wire[31:0] marport_ch_bit_32u_422, marport_ch_bit_32u_430, sel_428, sel_435;
  wire op_ne_415, op_andl_417, op_notl_426, op_notl_433;

  assign marport_ch_bit_32u_422 = mem_ch_bit_32u_409[io_in_src1];
  assign marport_ch_bit_32u_430 = mem_ch_bit_32u_409[io_in_src2];
  always @ (posedge clk) begin
    if (op_andl_417) begin
      mem_ch_bit_32u_409[io_in_rd] <= io_in_data;
    end
  end
  assign sel_428 = op_notl_426 ? 32'h0 : marport_ch_bit_32u_422;
  assign sel_435 = op_notl_433 ? 32'h0 : marport_ch_bit_32u_430;
  assign op_ne_415 = io_in_rd != 5'h0;
  assign op_andl_417 = io_in_write_register && op_ne_415;
  assign op_notl_426 = !io_in_src1;
  assign op_notl_433 = !io_in_src2;

  assign io_out_src1_data = sel_428;
  assign io_out_src2_data = sel_435;

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
  wire[4:0] proxy_slice_486, proxy_slice_490, proxy_slice_494, RegisterFile_437_io_in_rd, RegisterFile_437_io_in_src1, RegisterFile_437_io_in_src2;
  wire[2:0] proxy_slice_498, sel_607, sel_610, sel_806;
  wire[6:0] proxy_slice_502;
  wire[11:0] proxy_slice_505, proxy_cat_654, proxy_cat_729, proxy_cat_765, sel_703, sel_716, op_pad_715;
  wire[19:0] proxy_cat_612;
  wire proxy_io_in_instruction_sliceref_634, op_orr_478, op_eq_511, op_eq_514, op_eq_517, op_orl_519, op_eq_522, op_eq_525, op_eq_528, op_eq_531, op_eq_534, op_eq_537, op_orr_540, op_eq_543, op_andl_545, op_eq_548, op_andl_550, op_notl_552, op_andl_556, op_eq_559, op_eq_566, op_orl_577, op_orl_579, op_orl_581, op_orl_583, op_orl_593, op_orl_595, op_orl_601, op_eq_649, op_eq_665, op_lt_673, op_andl_675, op_ge_693, op_eq_695, op_andl_699, op_andl_701, op_eq_707, op_eq_710, op_orl_712, op_eq_725, op_eq_752, op_notl_815, op_eq_849, op_eq_855, op_eq_861, op_orl_866, op_lt_883, op_eq_889, RegisterFile_437_clk, RegisterFile_437_io_in_write_register;
  wire[20:0] proxy_cat_636;
  wire[31:0] proxy_cat_646, proxy_cat_661, proxy_cat_721, proxy_cat_748, sel_561, sel_563, sel_568, sel_572, sel_651, sel_667, sel_686, sel_727, sel_754, sel_778, op_shr_484, op_shr_488, op_shr_492, op_shr_496, op_shr_500, op_add_508, op_pad_571, op_shr_631, op_pad_643, op_pad_658, op_pad_719, op_pad_746, op_shr_759, RegisterFile_437_io_in_data, RegisterFile_437_io_out_src1_data, RegisterFile_437_io_out_src2_data;
  wire[1:0] sel_585, sel_589, sel_597;
  reg[19:0] sel_625;
  reg[31:0] sel_687, sel_783;
  reg sel_690, sel_808;
  reg[11:0] sel_785;
  reg[2:0] sel_805;
  wire[3:0] sel_817, sel_820, sel_836, sel_857, sel_863, sel_868, sel_870, sel_874, sel_878, sel_885, sel_887;
  reg[3:0] sel_845;

  assign proxy_slice_486 = op_shr_484[4:0];
  assign proxy_slice_490 = op_shr_488[4:0];
  assign proxy_slice_494 = op_shr_492[4:0];
  assign proxy_slice_498 = op_shr_496[2:0];
  assign proxy_slice_502 = op_shr_500[6:0];
  assign proxy_slice_505 = op_shr_492[11:0];
  assign proxy_cat_612 = {proxy_slice_502, proxy_slice_494, proxy_slice_490, proxy_slice_498};
  assign proxy_io_in_instruction_sliceref_634 = io_in_instruction[31];
  assign proxy_cat_636 = {proxy_io_in_instruction_sliceref_634, op_shr_496[7:0], io_in_instruction[20], op_shr_631[9:0], 1'h0};
  assign proxy_cat_646 = {11'h7ff, proxy_cat_636};
  assign proxy_cat_654 = {proxy_slice_502, proxy_slice_494};
  assign proxy_cat_661 = {20'hfffff, proxy_cat_654};
  assign proxy_cat_721 = {20'hfffff, sel_785};
  assign proxy_cat_729 = {proxy_slice_502, proxy_slice_486};
  assign proxy_cat_748 = {20'hfffff, proxy_slice_505};
  assign proxy_cat_765 = {proxy_io_in_instruction_sliceref_634, io_in_instruction[7], op_shr_500[5:0], op_shr_759[3:0]};
  assign sel_561 = op_eq_559 ? io_in_src1_fwd_data : RegisterFile_437_io_out_src1_data;
  assign sel_563 = op_eq_528 ? io_in_curr_PC : sel_561;
  assign sel_568 = op_eq_566 ? io_in_src2_fwd_data : RegisterFile_437_io_out_src2_data;
  assign sel_572 = op_andl_550 ? op_pad_571 : sel_563;
  assign sel_585 = op_orl_583 ? 2'h1 : 2'h0;
  assign sel_589 = op_eq_514 ? 2'h2 : sel_585;
  assign sel_597 = op_orl_595 ? 2'h3 : sel_589;
  assign sel_607 = op_eq_514 ? proxy_slice_498 : 3'h7;
  assign sel_610 = op_eq_522 ? proxy_slice_498 : 3'h7;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h17: sel_625 = proxy_cat_612;
      7'h37: sel_625 = proxy_cat_612;
      default: sel_625 = 20'h7b;
    endcase
  end
  assign sel_651 = op_eq_649 ? proxy_cat_646 : op_pad_643;
  assign sel_667 = op_eq_665 ? proxy_cat_661 : op_pad_658;
  assign sel_686 = op_andl_675 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h67: sel_687 = sel_667;
      7'h6f: sel_687 = sel_651;
      7'h73: sel_687 = sel_686;
      default: sel_687 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h67: sel_690 = 1'h1;
      7'h6f: sel_690 = 1'h1;
      7'h73: sel_690 = op_andl_675;
      default: sel_690 = 1'h0;
    endcase
  end
  assign sel_703 = op_andl_701 ? proxy_slice_505 : 12'h7b;
  assign sel_716 = op_orl_712 ? op_pad_715 : proxy_slice_505;
  assign sel_727 = op_eq_725 ? proxy_cat_721 : op_pad_719;
  assign sel_754 = op_eq_752 ? proxy_cat_748 : op_pad_746;
  assign sel_778 = op_eq_649 ? proxy_cat_721 : op_pad_719;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h03: sel_783 = sel_754;
      7'h13: sel_783 = sel_727;
      7'h23: sel_783 = sel_727;
      7'h63: sel_783 = sel_778;
      default: sel_783 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel_785 = sel_716;
      7'h23: sel_785 = proxy_cat_729;
      7'h63: sel_785 = proxy_cat_765;
      default: sel_785 = 12'h0;
    endcase
  end
  always @(*) begin
    case (proxy_slice_498)
      3'h0: sel_805 = 3'h1;
      3'h1: sel_805 = 3'h2;
      3'h4: sel_805 = 3'h3;
      3'h5: sel_805 = 3'h4;
      3'h6: sel_805 = 3'h5;
      3'h7: sel_805 = 3'h6;
      default: sel_805 = 3'h0;
    endcase
  end
  assign sel_806 = op_eq_889 ? sel_805 : 3'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel_808 = 1'h1;
      7'h67: sel_808 = 1'h1;
      7'h6f: sel_808 = 1'h1;
      default: sel_808 = 1'h0;
    endcase
  end
  assign sel_817 = op_notl_815 ? 4'h0 : 4'h1;
  assign sel_820 = op_eq_517 ? 4'h0 : sel_817;
  assign sel_836 = op_notl_815 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy_slice_498)
      3'h0: sel_845 = sel_820;
      3'h1: sel_845 = 4'h2;
      3'h2: sel_845 = 4'h3;
      3'h3: sel_845 = 4'h4;
      3'h4: sel_845 = 4'h5;
      3'h5: sel_845 = sel_836;
      3'h6: sel_845 = 4'h8;
      3'h7: sel_845 = 4'h9;
      default: sel_845 = 4'hf;
    endcase
  end
  assign sel_857 = op_eq_855 ? 4'he : 4'hf;
  assign sel_863 = op_eq_861 ? 4'hd : sel_857;
  assign sel_868 = op_orl_866 ? 4'h0 : sel_845;
  assign sel_870 = op_andl_545 ? sel_863 : sel_868;
  assign sel_874 = op_eq_537 ? 4'hc : sel_870;
  assign sel_878 = op_eq_534 ? 4'hb : sel_874;
  assign sel_885 = op_lt_883 ? 4'h1 : 4'ha;
  assign sel_887 = op_eq_525 ? sel_885 : sel_878;
  assign op_orr_478 = |io_in_wb;
  assign op_shr_484 = io_in_instruction >> 32'h7;
  assign op_shr_488 = io_in_instruction >> 32'hf;
  assign op_shr_492 = io_in_instruction >> 32'h14;
  assign op_shr_496 = io_in_instruction >> 32'hc;
  assign op_shr_500 = io_in_instruction >> 32'h19;
  assign op_add_508 = io_in_curr_PC + 32'h4;
  assign op_eq_511 = io_in_instruction[6:0] == 7'h33;
  assign op_eq_514 = io_in_instruction[6:0] == 7'h3;
  assign op_eq_517 = io_in_instruction[6:0] == 7'h13;
  assign op_orl_519 = op_eq_517 || op_eq_514;
  assign op_eq_522 = io_in_instruction[6:0] == 7'h23;
  assign op_eq_525 = io_in_instruction[6:0] == 7'h63;
  assign op_eq_528 = io_in_instruction[6:0] == 7'h6f;
  assign op_eq_531 = io_in_instruction[6:0] == 7'h67;
  assign op_eq_534 = io_in_instruction[6:0] == 7'h37;
  assign op_eq_537 = io_in_instruction[6:0] == 7'h17;
  assign op_orr_540 = |proxy_slice_498;
  assign op_eq_543 = io_in_instruction[6:0] == 7'h73;
  assign op_andl_545 = op_eq_543 && op_orr_540;
  assign op_eq_548 = op_shr_496[2] == 1'h1;
  assign op_andl_550 = op_andl_545 && op_eq_548;
  assign op_notl_552 = !proxy_slice_498;
  assign op_andl_556 = op_eq_543 && op_notl_552;
  assign op_eq_559 = io_in_src1_fwd == 1'h1;
  assign op_eq_566 = io_in_src2_fwd == 1'h1;
  assign op_pad_571 = {{27{1'b0}}, proxy_slice_490};
  assign op_orl_577 = op_orl_519 || op_eq_511;
  assign op_orl_579 = op_orl_577 || op_eq_534;
  assign op_orl_581 = op_orl_579 || op_eq_537;
  assign op_orl_583 = op_orl_581 || op_andl_545;
  assign op_orl_593 = op_eq_528 || op_eq_531;
  assign op_orl_595 = op_orl_593 || op_andl_556;
  assign op_orl_601 = op_orl_519 || op_eq_522;
  assign op_shr_631 = io_in_instruction >> 32'h15;
  assign op_pad_643 = {{11{1'b0}}, proxy_cat_636};
  assign op_eq_649 = proxy_io_in_instruction_sliceref_634 == 1'h1;
  assign op_pad_658 = {{20{1'b0}}, proxy_cat_654};
  assign op_eq_665 = op_shr_500[6] == 1'h1;
  assign op_lt_673 = proxy_slice_505 < 12'h2;
  assign op_andl_675 = op_notl_552 && op_lt_673;
  assign op_ge_693 = proxy_slice_505 >= 12'h2;
  assign op_eq_695 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign op_andl_699 = op_orr_540 && op_ge_693;
  assign op_andl_701 = op_andl_699 && op_eq_695;
  assign op_eq_707 = proxy_slice_498 == 3'h5;
  assign op_eq_710 = proxy_slice_498 == 3'h1;
  assign op_orl_712 = op_eq_710 || op_eq_707;
  assign op_pad_715 = {{7{1'b0}}, proxy_slice_494};
  assign op_pad_719 = {{20{1'b0}}, sel_785};
  assign op_eq_725 = sel_785[11] == 1'h1;
  assign op_pad_746 = {{20{1'b0}}, proxy_slice_505};
  assign op_eq_752 = op_shr_492[11] == 1'h1;
  assign op_shr_759 = io_in_instruction >> 32'h8;
  assign op_notl_815 = !proxy_slice_502;
  assign op_eq_849 = op_shr_496[1:0] == 2'h3;
  assign op_eq_855 = op_shr_496[1:0] == 2'h2;
  assign op_eq_861 = op_shr_496[1:0] == 2'h1;
  assign op_orl_866 = op_eq_522 || op_eq_514;
  assign op_lt_883 = sel_806 < 3'h5;
  assign op_eq_889 = io_in_instruction[6:0] == 7'h63;
  RegisterFile RegisterFile_437(.clk(RegisterFile_437_clk), .io_in_write_register(RegisterFile_437_io_in_write_register), .io_in_rd(RegisterFile_437_io_in_rd), .io_in_data(RegisterFile_437_io_in_data), .io_in_src1(RegisterFile_437_io_in_src1), .io_in_src2(RegisterFile_437_io_in_src2), .io_out_src1_data(RegisterFile_437_io_out_src1_data), .io_out_src2_data(RegisterFile_437_io_out_src2_data));
  assign RegisterFile_437_clk = clk;
  assign RegisterFile_437_io_in_write_register = op_orr_478;
  assign RegisterFile_437_io_in_rd = io_in_rd;
  assign RegisterFile_437_io_in_data = io_in_write_data;
  assign RegisterFile_437_io_in_src1 = proxy_slice_490;
  assign RegisterFile_437_io_in_src2 = proxy_slice_494;

  assign io_out_csr_address = sel_703;
  assign io_out_is_csr = op_andl_545;
  assign io_out_csr_mask = sel_572;
  assign io_out_rd = proxy_slice_486;
  assign io_out_rs1 = proxy_slice_490;
  assign io_out_rd1 = sel_563;
  assign io_out_rs2 = proxy_slice_494;
  assign io_out_rd2 = sel_568;
  assign io_out_wb = sel_597;
  assign io_out_alu_op = sel_887;
  assign io_out_rs2_src = op_orl_601;
  assign io_out_itype_immed = sel_783;
  assign io_out_mem_read = sel_607;
  assign io_out_mem_write = sel_610;
  assign io_out_branch_type = sel_806;
  assign io_out_branch_stall = sel_808;
  assign io_out_jal = sel_690;
  assign io_out_jal_offset = sel_687;
  assign io_out_upper_immed = sel_625;
  assign io_out_PC_next = op_add_508;

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
  reg[4:0] reg_ch_bit_5u_1023, reg_ch_bit_5u_1025, reg_ch_bit_5u_1030;
  reg[31:0] reg_ch_bit_32u_1028, reg_ch_bit_32u_1032, reg_ch_bit_32u_1040, reg_ch_bit_32u_1045, reg_ch_bit_32u_1063, reg_ch_bit_32u_1065, reg_ch_bit_32u_1069;
  reg[3:0] reg_ch_bit_4u_1035;
  reg[1:0] reg_ch_bit_2u_1038;
  reg reg_ch_bit_1u_1043, reg_ch_bit_1u_1061, reg_ch_bit_1u_1067;
  reg[2:0] reg_ch_bit_3u_1048, reg_ch_bit_3u_1050, reg_ch_bit_3u_1053;
  reg[19:0] reg_ch_bit_20u_1056;
  reg[11:0] reg_ch_bit_12u_1059;
  wire[4:0] sel_1080, sel_1083, sel_1089;
  wire[31:0] sel_1086, sel_1092, sel_1102, sel_1109, sel_1130, sel_1136, sel_1139;
  wire[3:0] sel_1096;
  wire[1:0] sel_1099;
  wire sel_1105, sel_1127, sel_1133, op_eq_1072, op_eq_1075, op_orl_1077;
  wire[2:0] sel_1112, sel_1115, sel_1118;
  wire[19:0] sel_1121;
  wire[11:0] sel_1124;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1023 <= 5'h0;
    else
      reg_ch_bit_5u_1023 <= sel_1080;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1025 <= 5'h0;
    else
      reg_ch_bit_5u_1025 <= sel_1083;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1028 <= 32'h0;
    else
      reg_ch_bit_32u_1028 <= sel_1086;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1030 <= 5'h0;
    else
      reg_ch_bit_5u_1030 <= sel_1089;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1032 <= 32'h0;
    else
      reg_ch_bit_32u_1032 <= sel_1092;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_4u_1035 <= 4'h0;
    else
      reg_ch_bit_4u_1035 <= sel_1096;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1038 <= 2'h0;
    else
      reg_ch_bit_2u_1038 <= sel_1099;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1040 <= 32'h0;
    else
      reg_ch_bit_32u_1040 <= sel_1102;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_1043 <= 1'h0;
    else
      reg_ch_bit_1u_1043 <= sel_1105;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1045 <= 32'h0;
    else
      reg_ch_bit_32u_1045 <= sel_1109;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1048 <= 3'h7;
    else
      reg_ch_bit_3u_1048 <= sel_1112;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1050 <= 3'h7;
    else
      reg_ch_bit_3u_1050 <= sel_1115;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1053 <= 3'h0;
    else
      reg_ch_bit_3u_1053 <= sel_1118;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_20u_1056 <= 20'h0;
    else
      reg_ch_bit_20u_1056 <= sel_1121;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_1059 <= 12'h0;
    else
      reg_ch_bit_12u_1059 <= sel_1124;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_1061 <= 1'h0;
    else
      reg_ch_bit_1u_1061 <= sel_1127;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1063 <= 32'h0;
    else
      reg_ch_bit_32u_1063 <= sel_1130;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1065 <= 32'h0;
    else
      reg_ch_bit_32u_1065 <= sel_1139;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_1067 <= 1'h0;
    else
      reg_ch_bit_1u_1067 <= sel_1133;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1069 <= 32'h0;
    else
      reg_ch_bit_32u_1069 <= sel_1136;
  end
  assign sel_1080 = op_orl_1077 ? 5'h0 : io_in_rd;
  assign sel_1083 = op_orl_1077 ? 5'h0 : io_in_rs1;
  assign sel_1086 = op_orl_1077 ? 32'h0 : io_in_rd1;
  assign sel_1089 = op_orl_1077 ? 5'h0 : io_in_rs2;
  assign sel_1092 = op_orl_1077 ? 32'h0 : io_in_rd2;
  assign sel_1096 = op_orl_1077 ? 4'hf : io_in_alu_op;
  assign sel_1099 = op_orl_1077 ? 2'h0 : io_in_wb;
  assign sel_1102 = op_orl_1077 ? 32'h0 : io_in_PC_next;
  assign sel_1105 = op_orl_1077 ? 1'h0 : io_in_rs2_src;
  assign sel_1109 = op_orl_1077 ? 32'h7b : io_in_itype_immed;
  assign sel_1112 = op_orl_1077 ? 3'h7 : io_in_mem_read;
  assign sel_1115 = op_orl_1077 ? 3'h7 : io_in_mem_write;
  assign sel_1118 = op_orl_1077 ? 3'h0 : io_in_branch_type;
  assign sel_1121 = op_orl_1077 ? 20'h0 : io_in_upper_immed;
  assign sel_1124 = op_orl_1077 ? 12'h0 : io_in_csr_address;
  assign sel_1127 = op_orl_1077 ? 1'h0 : io_in_is_csr;
  assign sel_1130 = op_orl_1077 ? 32'h0 : io_in_csr_mask;
  assign sel_1133 = op_orl_1077 ? 1'h0 : io_in_jal;
  assign sel_1136 = op_orl_1077 ? 32'h0 : io_in_jal_offset;
  assign sel_1139 = op_orl_1077 ? 32'h0 : io_in_curr_PC;
  assign op_eq_1072 = io_in_branch_stall == 1'h1;
  assign op_eq_1075 = io_in_fwd_stall == 1'h1;
  assign op_orl_1077 = op_eq_1075 || op_eq_1072;

  assign io_out_csr_address = reg_ch_bit_12u_1059;
  assign io_out_is_csr = reg_ch_bit_1u_1061;
  assign io_out_csr_mask = reg_ch_bit_32u_1063;
  assign io_out_rd = reg_ch_bit_5u_1023;
  assign io_out_rs1 = reg_ch_bit_5u_1025;
  assign io_out_rd1 = reg_ch_bit_32u_1028;
  assign io_out_rs2 = reg_ch_bit_5u_1030;
  assign io_out_rd2 = reg_ch_bit_32u_1032;
  assign io_out_alu_op = reg_ch_bit_4u_1035;
  assign io_out_wb = reg_ch_bit_2u_1038;
  assign io_out_rs2_src = reg_ch_bit_1u_1043;
  assign io_out_itype_immed = reg_ch_bit_32u_1045;
  assign io_out_mem_read = reg_ch_bit_3u_1048;
  assign io_out_mem_write = reg_ch_bit_3u_1050;
  assign io_out_branch_type = reg_ch_bit_3u_1053;
  assign io_out_upper_immed = reg_ch_bit_20u_1056;
  assign io_out_curr_PC = reg_ch_bit_32u_1065;
  assign io_out_jal = reg_ch_bit_1u_1067;
  assign io_out_jal_offset = reg_ch_bit_32u_1069;
  assign io_out_PC_next = reg_ch_bit_32u_1040;

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
  wire[31:0] proxy_cat_1291, sel_1287, sel_1317, sel_1325, sel_1374, op_add_1294, op_add_1297, op_sub_1302, op_shl_1307, op_xorb_1329, op_shr_1334, op_shr_1339, op_orb_1343, op_andb_1347, op_add_1358, op_orb_1363, op_sub_1366, op_andb_1368;
  reg[31:0] sel_1372, sel_1375;
  wire op_eq_1284, op_lt_1315, op_lt_1323, op_ge_1351, op_orr_1380;

  assign proxy_cat_1291 = {io_in_upper_immed, 12'h0};
  assign sel_1287 = op_eq_1284 ? io_in_itype_immed : io_in_rd2;
  assign sel_1317 = op_lt_1315 ? 32'h1 : 32'h0;
  assign sel_1325 = op_lt_1323 ? 32'h1 : 32'h0;
  always @(*) begin
    case (io_in_alu_op)
      4'hd: sel_1372 = io_in_csr_mask;
      4'he: sel_1372 = op_orb_1363;
      4'hf: sel_1372 = op_andb_1368;
      default: sel_1372 = 32'h7b;
    endcase
  end
  assign sel_1374 = op_ge_1351 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel_1375 = op_add_1297;
      4'h1: sel_1375 = op_sub_1302;
      4'h2: sel_1375 = op_shl_1307;
      4'h3: sel_1375 = sel_1317;
      4'h4: sel_1375 = sel_1325;
      4'h5: sel_1375 = op_xorb_1329;
      4'h6: sel_1375 = op_shr_1334;
      4'h7: sel_1375 = op_shr_1339;
      4'h8: sel_1375 = op_orb_1343;
      4'h9: sel_1375 = op_andb_1347;
      4'ha: sel_1375 = sel_1374;
      4'hb: sel_1375 = proxy_cat_1291;
      4'hc: sel_1375 = op_add_1358;
      4'hd: sel_1375 = io_in_csr_data;
      4'he: sel_1375 = io_in_csr_data;
      4'hf: sel_1375 = io_in_csr_data;
      default: sel_1375 = 32'h0;
    endcase
  end
  assign op_eq_1284 = io_in_rs2_src == 1'h1;
  assign op_add_1294 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign op_add_1297 = $signed(io_in_rd1) + $signed(sel_1287);
  assign op_sub_1302 = $signed(io_in_rd1) - $signed(sel_1287);
  assign op_shl_1307 = io_in_rd1 << sel_1287[4:0];
  assign op_lt_1315 = $signed(io_in_rd1) < $signed(sel_1287);
  assign op_lt_1323 = io_in_rd1 < sel_1287;
  assign op_xorb_1329 = io_in_rd1 ^ sel_1287;
  assign op_shr_1334 = io_in_rd1 >> sel_1287[4:0];
  assign op_shr_1339 = $signed(io_in_rd1) >> sel_1287[4:0];
  assign op_orb_1343 = io_in_rd1 | sel_1287;
  assign op_andb_1347 = sel_1287 & io_in_rd1;
  assign op_ge_1351 = io_in_rd1 >= sel_1287;
  assign op_add_1358 = $signed(io_in_curr_PC) + $signed(proxy_cat_1291);
  assign op_orb_1363 = io_in_csr_data | io_in_csr_mask;
  assign op_sub_1366 = 32'hffffffff - io_in_csr_mask;
  assign op_andb_1368 = io_in_csr_data & op_sub_1366;
  assign op_orr_1380 = |io_in_branch_type;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel_1372;
  assign io_out_alu_result = sel_1375;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = op_add_1294;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = op_orr_1380;
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
  reg[31:0] reg_ch_bit_32u_1514, reg_ch_bit_32u_1521, reg_ch_bit_32u_1525, reg_ch_bit_32u_1530, reg_ch_bit_32u_1543, reg_ch_bit_32u_1545, reg_ch_bit_32u_1547;
  reg[4:0] reg_ch_bit_5u_1517, reg_ch_bit_5u_1519, reg_ch_bit_5u_1523;
  reg[1:0] reg_ch_bit_2u_1528;
  reg[2:0] reg_ch_bit_3u_1533, reg_ch_bit_3u_1535, reg_ch_bit_3u_1550;
  reg[11:0] reg_ch_bit_12u_1538;
  reg reg_ch_bit_1u_1541;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1514 <= 32'h0;
    else
      reg_ch_bit_32u_1514 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1517 <= 5'h0;
    else
      reg_ch_bit_5u_1517 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1519 <= 5'h0;
    else
      reg_ch_bit_5u_1519 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1521 <= 32'h0;
    else
      reg_ch_bit_32u_1521 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1523 <= 5'h0;
    else
      reg_ch_bit_5u_1523 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1525 <= 32'h0;
    else
      reg_ch_bit_32u_1525 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1528 <= 2'h0;
    else
      reg_ch_bit_2u_1528 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1530 <= 32'h0;
    else
      reg_ch_bit_32u_1530 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1533 <= 3'h7;
    else
      reg_ch_bit_3u_1533 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1535 <= 3'h7;
    else
      reg_ch_bit_3u_1535 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_1538 <= 12'h0;
    else
      reg_ch_bit_12u_1538 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_1u_1541 <= 1'h0;
    else
      reg_ch_bit_1u_1541 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1543 <= 32'h0;
    else
      reg_ch_bit_32u_1543 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1545 <= 32'h0;
    else
      reg_ch_bit_32u_1545 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1547 <= 32'h0;
    else
      reg_ch_bit_32u_1547 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_3u_1550 <= 3'h0;
    else
      reg_ch_bit_3u_1550 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg_ch_bit_12u_1538;
  assign io_out_is_csr = reg_ch_bit_1u_1541;
  assign io_out_csr_result = reg_ch_bit_32u_1543;
  assign io_out_alu_result = reg_ch_bit_32u_1514;
  assign io_out_rd = reg_ch_bit_5u_1517;
  assign io_out_wb = reg_ch_bit_2u_1528;
  assign io_out_rs1 = reg_ch_bit_5u_1519;
  assign io_out_rd1 = reg_ch_bit_32u_1521;
  assign io_out_rd2 = reg_ch_bit_32u_1525;
  assign io_out_rs2 = reg_ch_bit_5u_1523;
  assign io_out_mem_read = reg_ch_bit_3u_1533;
  assign io_out_mem_write = reg_ch_bit_3u_1535;
  assign io_out_curr_PC = reg_ch_bit_32u_1545;
  assign io_out_branch_offset = reg_ch_bit_32u_1547;
  assign io_out_branch_type = reg_ch_bit_3u_1550;
  assign io_out_PC_next = reg_ch_bit_32u_1530;

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
  wire[2:0] sel_1712;
  wire op_lt_1706, op_lt_1708, op_orl_1710;

  assign sel_1712 = op_lt_1706 ? io_in_mem_write : io_in_mem_read;
  assign op_lt_1706 = io_in_mem_write < 3'h7;
  assign op_lt_1708 = io_in_mem_read < 3'h7;
  assign op_orl_1710 = op_lt_1706 || op_lt_1708;

  assign io_DBUS_out_miss = 1'h0;
  assign io_DBUS_out_rw = op_lt_1706;
  assign io_DBUS_in_data_ready = op_orl_1710;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = op_orl_1710;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = op_orl_1710;
  assign io_DBUS_out_control_data = sel_1712;
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
  reg sel_1822;
  wire[31:0] op_shl_1765, op_add_1767, Cache_driver_1723_io_DBUS_in_data_data, Cache_driver_1723_io_DBUS_out_data_data, Cache_driver_1723_io_DBUS_out_address_data, Cache_driver_1723_io_in_address, Cache_driver_1723_io_in_data, Cache_driver_1723_io_out_data;
  wire op_notl_1775, op_notl_1790, op_inv_1823, op_inv_1824, Cache_driver_1723_io_DBUS_out_miss, Cache_driver_1723_io_DBUS_out_rw, Cache_driver_1723_io_DBUS_in_data_valid, Cache_driver_1723_io_DBUS_in_data_ready, Cache_driver_1723_io_DBUS_out_data_valid, Cache_driver_1723_io_DBUS_out_data_ready, Cache_driver_1723_io_DBUS_out_address_valid, Cache_driver_1723_io_DBUS_out_address_ready, Cache_driver_1723_io_DBUS_out_control_valid, Cache_driver_1723_io_DBUS_out_control_ready, Cache_driver_1723_io_out_delay;
  wire[2:0] Cache_driver_1723_io_DBUS_out_control_data, Cache_driver_1723_io_in_mem_read, Cache_driver_1723_io_in_mem_write;

  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel_1822 = op_notl_1775;
      3'h2: sel_1822 = op_inv_1823;
      3'h3: sel_1822 = op_inv_1824;
      3'h4: sel_1822 = op_notl_1790;
      3'h5: sel_1822 = op_inv_1824;
      3'h6: sel_1822 = op_notl_1790;
      default: sel_1822 = 1'h0;
    endcase
  end
  assign op_shl_1765 = io_in_branch_offset << 32'h1;
  assign op_add_1767 = $signed(io_in_curr_PC) + $signed(op_shl_1765);
  assign op_notl_1775 = !io_in_alu_result;
  assign op_notl_1790 = !io_in_alu_result[31];
  assign op_inv_1823 = ~op_notl_1775;
  assign op_inv_1824 = ~op_notl_1790;
  Cache_driver Cache_driver_1723(.io_DBUS_in_data_data(Cache_driver_1723_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Cache_driver_1723_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Cache_driver_1723_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Cache_driver_1723_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Cache_driver_1723_io_DBUS_out_control_ready), .io_in_address(Cache_driver_1723_io_in_address), .io_in_mem_read(Cache_driver_1723_io_in_mem_read), .io_in_mem_write(Cache_driver_1723_io_in_mem_write), .io_in_data(Cache_driver_1723_io_in_data), .io_DBUS_out_miss(Cache_driver_1723_io_DBUS_out_miss), .io_DBUS_out_rw(Cache_driver_1723_io_DBUS_out_rw), .io_DBUS_in_data_ready(Cache_driver_1723_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Cache_driver_1723_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Cache_driver_1723_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Cache_driver_1723_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Cache_driver_1723_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Cache_driver_1723_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Cache_driver_1723_io_DBUS_out_control_valid), .io_out_delay(Cache_driver_1723_io_out_delay), .io_out_data(Cache_driver_1723_io_out_data));
  assign Cache_driver_1723_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Cache_driver_1723_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Cache_driver_1723_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Cache_driver_1723_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Cache_driver_1723_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Cache_driver_1723_io_in_address = io_in_alu_result;
  assign Cache_driver_1723_io_in_mem_read = io_in_mem_read;
  assign Cache_driver_1723_io_in_mem_write = io_in_mem_write;
  assign Cache_driver_1723_io_in_data = io_in_rd2;

  assign io_DBUS_out_miss = Cache_driver_1723_io_DBUS_out_miss;
  assign io_DBUS_out_rw = Cache_driver_1723_io_DBUS_out_rw;
  assign io_DBUS_in_data_ready = Cache_driver_1723_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Cache_driver_1723_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Cache_driver_1723_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Cache_driver_1723_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Cache_driver_1723_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Cache_driver_1723_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Cache_driver_1723_io_DBUS_out_control_valid;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = Cache_driver_1723_io_out_data;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel_1822;
  assign io_out_branch_dest = op_add_1767;
  assign io_out_delay = Cache_driver_1723_io_out_delay;
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
  reg[31:0] reg_ch_bit_32u_1927, reg_ch_bit_32u_1929, reg_ch_bit_32u_1941;
  reg[4:0] reg_ch_bit_5u_1932, reg_ch_bit_5u_1934, reg_ch_bit_5u_1936;
  reg[1:0] reg_ch_bit_2u_1939;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1927 <= 32'h0;
    else
      reg_ch_bit_32u_1927 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1929 <= 32'h0;
    else
      reg_ch_bit_32u_1929 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1932 <= 5'h0;
    else
      reg_ch_bit_5u_1932 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1934 <= 5'h0;
    else
      reg_ch_bit_5u_1934 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_5u_1936 <= 5'h0;
    else
      reg_ch_bit_5u_1936 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_2u_1939 <= 2'h0;
    else
      reg_ch_bit_2u_1939 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_1941 <= 32'h0;
    else
      reg_ch_bit_32u_1941 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg_ch_bit_32u_1927;
  assign io_out_mem_result = reg_ch_bit_32u_1929;
  assign io_out_rd = reg_ch_bit_5u_1932;
  assign io_out_wb = reg_ch_bit_2u_1939;
  assign io_out_rs1 = reg_ch_bit_5u_1934;
  assign io_out_rs2 = reg_ch_bit_5u_1936;
  assign io_out_PC_next = reg_ch_bit_32u_1941;

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
  wire[31:0] sel_1992, sel_1994;
  wire op_eq_1987, op_eq_1990;

  assign sel_1992 = op_eq_1990 ? io_in_alu_result : io_in_mem_result;
  assign sel_1994 = op_eq_1987 ? io_in_PC_next : sel_1992;
  assign op_eq_1987 = io_in_wb == 2'h3;
  assign op_eq_1990 = io_in_wb == 2'h1;

  assign io_out_write_data = sel_1994;
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
  wire[31:0] sel_2194, sel_2196, sel_2198, sel_2200, sel_2202, sel_2204, sel_2206, sel_2208, sel_2215, sel_2221, sel_2225, sel_2228, sel_2230;
  wire op_eq_2055, op_eq_2057, op_eq_2059, op_eq_2062, op_eq_2064, op_eq_2066, op_eq_2070, op_eq_2073, op_orr_2076, op_orr_2079, op_eq_2081, op_andl_2083, op_andl_2085, op_notl_2087, op_orr_2089, op_eq_2093, op_andl_2095, op_andl_2097, op_andl_2099, op_notl_2101, op_orr_2105, op_eq_2109, op_andl_2111, op_andl_2113, op_andl_2115, op_andl_2117, op_orl_2119, op_orl_2121, op_orr_2125, op_eq_2127, op_andl_2129, op_andl_2131, op_notl_2133, op_eq_2139, op_andl_2141, op_andl_2143, op_andl_2145, op_notl_2147, op_eq_2155, op_andl_2157, op_andl_2159, op_andl_2161, op_andl_2163, op_orl_2165, op_orl_2167, op_eq_2169, op_andl_2171, op_notl_2173, op_eq_2175, op_andl_2177, op_andl_2179, op_orl_2181, op_orl_2186, op_andl_2188;

  assign sel_2194 = op_eq_2059 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel_2196 = op_eq_2066 ? io_in_writeback_PC_next : sel_2194;
  assign sel_2198 = op_andl_2117 ? sel_2196 : 32'h7b;
  assign sel_2200 = op_eq_2057 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel_2202 = op_eq_2064 ? io_in_memory_PC_next : sel_2200;
  assign sel_2204 = op_andl_2099 ? sel_2202 : sel_2198;
  assign sel_2206 = op_eq_2062 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel_2208 = op_andl_2085 ? sel_2206 : sel_2204;
  assign sel_2215 = op_andl_2163 ? sel_2196 : 32'h7b;
  assign sel_2221 = op_andl_2145 ? sel_2202 : sel_2215;
  assign sel_2225 = op_andl_2131 ? sel_2206 : sel_2221;
  assign sel_2228 = op_andl_2179 ? io_in_memory_csr_result : 32'h7b;
  assign sel_2230 = op_andl_2171 ? io_in_execute_alu_result : sel_2228;
  assign op_eq_2055 = io_in_execute_wb == 2'h2;
  assign op_eq_2057 = io_in_memory_wb == 2'h2;
  assign op_eq_2059 = io_in_writeback_wb == 2'h2;
  assign op_eq_2062 = io_in_execute_wb == 2'h3;
  assign op_eq_2064 = io_in_memory_wb == 2'h3;
  assign op_eq_2066 = io_in_writeback_wb == 2'h3;
  assign op_eq_2070 = io_in_execute_is_csr == 1'h1;
  assign op_eq_2073 = io_in_memory_is_csr == 1'h1;
  assign op_orr_2076 = |io_in_execute_wb;
  assign op_orr_2079 = |io_in_decode_src1;
  assign op_eq_2081 = io_in_decode_src1 == io_in_execute_dest;
  assign op_andl_2083 = op_eq_2081 && op_orr_2079;
  assign op_andl_2085 = op_andl_2083 && op_orr_2076;
  assign op_notl_2087 = !op_andl_2085;
  assign op_orr_2089 = |io_in_memory_wb;
  assign op_eq_2093 = io_in_decode_src1 == io_in_memory_dest;
  assign op_andl_2095 = op_eq_2093 && op_orr_2079;
  assign op_andl_2097 = op_andl_2095 && op_orr_2089;
  assign op_andl_2099 = op_andl_2097 && op_notl_2087;
  assign op_notl_2101 = !op_andl_2099;
  assign op_orr_2105 = |io_in_writeback_wb;
  assign op_eq_2109 = io_in_decode_src1 == io_in_writeback_dest;
  assign op_andl_2111 = op_eq_2109 && op_orr_2079;
  assign op_andl_2113 = op_andl_2111 && op_orr_2105;
  assign op_andl_2115 = op_andl_2113 && op_notl_2087;
  assign op_andl_2117 = op_andl_2115 && op_notl_2101;
  assign op_orl_2119 = op_andl_2085 || op_andl_2099;
  assign op_orl_2121 = op_orl_2119 || op_andl_2117;
  assign op_orr_2125 = |io_in_decode_src2;
  assign op_eq_2127 = io_in_decode_src2 == io_in_execute_dest;
  assign op_andl_2129 = op_eq_2127 && op_orr_2125;
  assign op_andl_2131 = op_andl_2129 && op_orr_2076;
  assign op_notl_2133 = !op_andl_2131;
  assign op_eq_2139 = io_in_decode_src2 == io_in_memory_dest;
  assign op_andl_2141 = op_eq_2139 && op_orr_2125;
  assign op_andl_2143 = op_andl_2141 && op_orr_2089;
  assign op_andl_2145 = op_andl_2143 && op_notl_2133;
  assign op_notl_2147 = !op_andl_2145;
  assign op_eq_2155 = io_in_decode_src2 == io_in_writeback_dest;
  assign op_andl_2157 = op_eq_2155 && op_orr_2125;
  assign op_andl_2159 = op_andl_2157 && op_orr_2105;
  assign op_andl_2161 = op_andl_2159 && op_notl_2133;
  assign op_andl_2163 = op_andl_2161 && op_notl_2147;
  assign op_orl_2165 = op_andl_2131 || op_andl_2145;
  assign op_orl_2167 = op_orl_2165 || op_andl_2163;
  assign op_eq_2169 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign op_andl_2171 = op_eq_2169 && op_eq_2070;
  assign op_notl_2173 = !op_andl_2171;
  assign op_eq_2175 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign op_andl_2177 = op_eq_2175 && op_eq_2073;
  assign op_andl_2179 = op_andl_2177 && op_notl_2173;
  assign op_orl_2181 = op_andl_2171 || op_andl_2179;
  assign op_orl_2186 = op_andl_2085 || op_andl_2131;
  assign op_andl_2188 = op_orl_2186 && op_eq_2055;

  assign io_out_src1_fwd = op_orl_2121;
  assign io_out_src2_fwd = op_orl_2167;
  assign io_out_csr_fwd = op_orl_2181;
  assign io_out_src1_fwd_data = sel_2208;
  assign io_out_src2_fwd_data = sel_2225;
  assign io_out_csr_fwd_data = sel_2230;
  assign io_out_fwd_stall = op_andl_2188;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem_ch_bit_32u_2302 [0:1];
  wire[31:0] marport_ch_bit_32u_2303, sel_2308;

  initial begin
    mem_ch_bit_32u_2302[0] = 32'h70000000;
    mem_ch_bit_32u_2302[1] = 32'hdeadbeef;
  end
  assign marport_ch_bit_32u_2303 = mem_ch_bit_32u_2302[io_INTERRUPT_in_interrupt_id_data];
  assign sel_2308 = io_INTERRUPT_in_interrupt_id_valid ? marport_ch_bit_32u_2303 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = 1'h1;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel_2308;

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
  reg[3:0] reg_ch_bit_4u_2361, sel_2445;
  wire[3:0] sel_2369, sel_2374, sel_2380, sel_2386, sel_2396, sel_2401, sel_2405, sel_2414, sel_2420, sel_2430, sel_2435, sel_2439, sel_2446, sel_2456, sel_2457, sel_2459;
  wire op_eq_2363, op_andl_2447, op_eq_2449, op_andl_2452, op_eq_2454, op_andb_2460;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_4u_2361 <= 4'h0;
    else
      reg_ch_bit_4u_2361 <= sel_2459;
  end
  assign sel_2369 = op_eq_2363 ? 4'h0 : 4'h1;
  assign sel_2374 = op_eq_2363 ? 4'h2 : 4'h1;
  assign sel_2380 = op_eq_2363 ? 4'h9 : 4'h3;
  assign sel_2386 = op_eq_2363 ? 4'h5 : 4'h4;
  assign sel_2396 = op_eq_2363 ? 4'h8 : 4'h6;
  assign sel_2401 = op_eq_2363 ? 4'h7 : 4'h6;
  assign sel_2405 = op_eq_2363 ? 4'h4 : 4'h8;
  assign sel_2414 = op_eq_2363 ? 4'h0 : 4'ha;
  assign sel_2420 = op_eq_2363 ? 4'hc : 4'hb;
  assign sel_2430 = op_eq_2363 ? 4'hf : 4'hd;
  assign sel_2435 = op_eq_2363 ? 4'he : 4'hd;
  assign sel_2439 = op_eq_2363 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg_ch_bit_4u_2361)
      4'h0: sel_2445 = sel_2369;
      4'h1: sel_2445 = sel_2374;
      4'h2: sel_2445 = sel_2380;
      4'h3: sel_2445 = sel_2386;
      4'h4: sel_2445 = sel_2386;
      4'h5: sel_2445 = sel_2396;
      4'h6: sel_2445 = sel_2401;
      4'h7: sel_2445 = sel_2405;
      4'h8: sel_2445 = sel_2374;
      4'h9: sel_2445 = sel_2414;
      4'ha: sel_2445 = sel_2420;
      4'hb: sel_2445 = sel_2420;
      4'hc: sel_2445 = sel_2430;
      4'hd: sel_2445 = sel_2435;
      4'he: sel_2445 = sel_2439;
      4'hf: sel_2445 = sel_2374;
      default: sel_2445 = reg_ch_bit_4u_2361;
    endcase
  end
  assign sel_2446 = io_JTAG_TAP_in_mode_select_valid ? sel_2445 : 4'h0;
  assign sel_2456 = op_eq_2449 ? 4'h0 : reg_ch_bit_4u_2361;
  assign sel_2457 = op_andb_2460 ? sel_2446 : reg_ch_bit_4u_2361;
  assign sel_2459 = op_andl_2447 ? sel_2456 : sel_2457;
  assign op_eq_2363 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign op_andl_2447 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_reset_valid;
  assign op_eq_2449 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign op_andl_2452 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_clock_valid;
  assign op_eq_2454 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign op_andb_2460 = op_andl_2452 & op_eq_2454;

  assign io_JTAG_TAP_in_mode_select_ready = 1'h1;
  assign io_JTAG_TAP_in_clock_ready = 1'h1;
  assign io_JTAG_TAP_in_reset_ready = 1'h1;
  assign io_out_curr_state = reg_ch_bit_4u_2361;

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
  reg[31:0] reg_ch_bit_32u_2490, reg_ch_bit_32u_2493, reg_ch_bit_32u_2496, reg_ch_bit_32u_2500, sel_2552;
  wire[31:0] proxy_cat_2521, sel_2512, sel_2514, sel_2546, sel_2547, sel_2548, sel_2549, sel_2550, op_shr_2518;
  reg sel_2559;
  wire sel_2566, op_notl_2502, op_eq_2506, op_eq_2509, op_eq_2567, op_eq_2568, op_andb_2570, op_eq_2571, TAP_2461_clk, TAP_2461_reset, TAP_2461_io_JTAG_TAP_in_mode_select_data, TAP_2461_io_JTAG_TAP_in_mode_select_valid, TAP_2461_io_JTAG_TAP_in_mode_select_ready, TAP_2461_io_JTAG_TAP_in_clock_data, TAP_2461_io_JTAG_TAP_in_clock_valid, TAP_2461_io_JTAG_TAP_in_clock_ready, TAP_2461_io_JTAG_TAP_in_reset_data, TAP_2461_io_JTAG_TAP_in_reset_valid, TAP_2461_io_JTAG_TAP_in_reset_ready;
  wire[3:0] TAP_2461_io_out_curr_state;

  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2490 <= 32'h0;
    else
      reg_ch_bit_32u_2490 <= sel_2546;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2493 <= 32'h1234;
    else
      reg_ch_bit_32u_2493 <= sel_2549;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2496 <= 32'h5678;
    else
      reg_ch_bit_32u_2496 <= sel_2550;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_32u_2500 <= 32'h0;
    else
      reg_ch_bit_32u_2500 <= sel_2552;
  end
  assign proxy_cat_2521 = {io_JTAG_in_data_data, op_shr_2518[30:0]};
  assign sel_2512 = op_eq_2509 ? reg_ch_bit_32u_2493 : 32'hdeadbeef;
  assign sel_2514 = op_eq_2506 ? reg_ch_bit_32u_2496 : sel_2512;
  assign sel_2546 = op_eq_2567 ? reg_ch_bit_32u_2500 : reg_ch_bit_32u_2490;
  assign sel_2547 = op_eq_2509 ? reg_ch_bit_32u_2500 : reg_ch_bit_32u_2493;
  assign sel_2548 = op_eq_2506 ? reg_ch_bit_32u_2493 : sel_2547;
  assign sel_2549 = op_eq_2568 ? sel_2548 : reg_ch_bit_32u_2493;
  assign sel_2550 = op_andb_2570 ? reg_ch_bit_32u_2500 : reg_ch_bit_32u_2496;
  always @(*) begin
    case (TAP_2461_io_out_curr_state)
      4'h3: sel_2552 = sel_2514;
      4'h4: sel_2552 = proxy_cat_2521;
      4'ha: sel_2552 = reg_ch_bit_32u_2490;
      4'hb: sel_2552 = proxy_cat_2521;
      default: sel_2552 = reg_ch_bit_32u_2500;
    endcase
  end
  always @(*) begin
    case (TAP_2461_io_out_curr_state)
      4'h4: sel_2559 = 1'h1;
      4'hb: sel_2559 = 1'h1;
      default: sel_2559 = op_notl_2502;
    endcase
  end
  assign sel_2566 = op_eq_2571 ? reg_ch_bit_32u_2500[0] : 1'h0;
  assign op_notl_2502 = !reg_ch_bit_32u_2490;
  assign op_eq_2506 = reg_ch_bit_32u_2490 == 32'h1;
  assign op_eq_2509 = reg_ch_bit_32u_2490 == 32'h2;
  assign op_shr_2518 = reg_ch_bit_32u_2500 >> 32'h1;
  assign op_eq_2567 = TAP_2461_io_out_curr_state == 4'hf;
  assign op_eq_2568 = TAP_2461_io_out_curr_state == 4'h8;
  assign op_andb_2570 = op_eq_2568 & op_eq_2506;
  assign op_eq_2571 = TAP_2461_io_out_curr_state == 4'h4;
  TAP TAP_2461(.clk(TAP_2461_clk), .reset(TAP_2461_reset), .io_JTAG_TAP_in_mode_select_data(TAP_2461_io_JTAG_TAP_in_mode_select_data), .io_JTAG_TAP_in_mode_select_valid(TAP_2461_io_JTAG_TAP_in_mode_select_valid), .io_JTAG_TAP_in_clock_data(TAP_2461_io_JTAG_TAP_in_clock_data), .io_JTAG_TAP_in_clock_valid(TAP_2461_io_JTAG_TAP_in_clock_valid), .io_JTAG_TAP_in_reset_data(TAP_2461_io_JTAG_TAP_in_reset_data), .io_JTAG_TAP_in_reset_valid(TAP_2461_io_JTAG_TAP_in_reset_valid), .io_JTAG_TAP_in_mode_select_ready(TAP_2461_io_JTAG_TAP_in_mode_select_ready), .io_JTAG_TAP_in_clock_ready(TAP_2461_io_JTAG_TAP_in_clock_ready), .io_JTAG_TAP_in_reset_ready(TAP_2461_io_JTAG_TAP_in_reset_ready), .io_out_curr_state(TAP_2461_io_out_curr_state));
  assign TAP_2461_clk = clk;
  assign TAP_2461_reset = reset;
  assign TAP_2461_io_JTAG_TAP_in_mode_select_data = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign TAP_2461_io_JTAG_TAP_in_mode_select_valid = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign TAP_2461_io_JTAG_TAP_in_clock_data = io_JTAG_JTAG_TAP_in_clock_data;
  assign TAP_2461_io_JTAG_TAP_in_clock_valid = io_JTAG_JTAG_TAP_in_clock_valid;
  assign TAP_2461_io_JTAG_TAP_in_reset_data = io_JTAG_JTAG_TAP_in_reset_data;
  assign TAP_2461_io_JTAG_TAP_in_reset_valid = io_JTAG_JTAG_TAP_in_reset_valid;

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = TAP_2461_io_JTAG_TAP_in_mode_select_ready;
  assign io_JTAG_JTAG_TAP_in_clock_ready = TAP_2461_io_JTAG_TAP_in_clock_ready;
  assign io_JTAG_JTAG_TAP_in_reset_ready = TAP_2461_io_JTAG_TAP_in_reset_ready;
  assign io_JTAG_in_data_ready = 1'h1;
  assign io_JTAG_out_data_data = sel_2566;
  assign io_JTAG_out_data_valid = sel_2559;

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
  reg[11:0] mem_ch_bit_12u_2611 [0:4095];
  wire[11:0] marport_ch_bit_12u_2651;
  reg[63:0] reg_ch_uint_64u_2617, reg_ch_uint_64u_2619;
  reg[11:0] reg_ch_bit_12u_2629;
  wire[31:0] sel_2659, sel_2662, sel_2667, sel_2670, op_pad_2654;
  wire[63:0] op_add_2622, op_add_2625, op_shr_2656, op_shr_2664;
  wire op_eq_2637, op_eq_2641, op_eq_2645, op_eq_2649;

  assign marport_ch_bit_12u_2651 = mem_ch_bit_12u_2611[reg_ch_bit_12u_2629];
  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem_ch_bit_12u_2611[io_in_mem_csr_address] <= io_in_mem_csr_result[11:0];
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_uint_64u_2617 <= 64'h0;
    else
      reg_ch_uint_64u_2617 <= op_add_2622;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_uint_64u_2619 <= 64'h0;
    else
      reg_ch_uint_64u_2619 <= op_add_2625;
  end
  always @ (posedge clk) begin
    if (reset)
      reg_ch_bit_12u_2629 <= 12'h0;
    else
      reg_ch_bit_12u_2629 <= io_in_decode_csr_address;
  end
  assign sel_2659 = op_eq_2649 ? op_shr_2656[31:0] : op_pad_2654;
  assign sel_2662 = op_eq_2645 ? reg_ch_uint_64u_2619[31:0] : sel_2659;
  assign sel_2667 = op_eq_2641 ? op_shr_2664[31:0] : sel_2662;
  assign sel_2670 = op_eq_2637 ? reg_ch_uint_64u_2617[31:0] : sel_2667;
  assign op_add_2622 = reg_ch_uint_64u_2617 + 64'h1;
  assign op_add_2625 = reg_ch_uint_64u_2619 + 64'h1;
  assign op_eq_2637 = reg_ch_bit_12u_2629 == 12'hc00;
  assign op_eq_2641 = reg_ch_bit_12u_2629 == 12'hc80;
  assign op_eq_2645 = reg_ch_bit_12u_2629 == 12'hc02;
  assign op_eq_2649 = reg_ch_bit_12u_2629 == 12'hc82;
  assign op_pad_2654 = {{20{1'b0}}, marport_ch_bit_12u_2651};
  assign op_shr_2656 = reg_ch_uint_64u_2619 >> 32'h20;
  assign op_shr_2664 = reg_ch_uint_64u_2617 >> 32'h20;

  assign io_out_decode_csr_data = sel_2670;

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
  wire op_orl_2685, op_eq_2690, Fetch_248_clk, Fetch_248_reset, Fetch_248_io_IBUS_in_data_valid, Fetch_248_io_IBUS_in_data_ready, Fetch_248_io_IBUS_out_address_valid, Fetch_248_io_IBUS_out_address_ready, Fetch_248_io_in_branch_dir, Fetch_248_io_in_freeze, Fetch_248_io_in_branch_stall, Fetch_248_io_in_fwd_stall, Fetch_248_io_in_branch_stall_exe, Fetch_248_io_in_jal, Fetch_248_io_in_interrupt, Fetch_248_io_in_debug, F_D_Register_331_clk, F_D_Register_331_reset, F_D_Register_331_io_in_branch_stall, F_D_Register_331_io_in_branch_stall_exe, F_D_Register_331_io_in_fwd_stall, Decode_890_clk, Decode_890_io_in_stall, Decode_890_io_in_src1_fwd, Decode_890_io_in_src2_fwd, Decode_890_io_in_csr_fwd, Decode_890_io_out_is_csr, Decode_890_io_out_rs2_src, Decode_890_io_out_branch_stall, Decode_890_io_out_jal, D_E_Register_1141_clk, D_E_Register_1141_reset, D_E_Register_1141_io_in_rs2_src, D_E_Register_1141_io_in_fwd_stall, D_E_Register_1141_io_in_branch_stall, D_E_Register_1141_io_in_is_csr, D_E_Register_1141_io_in_jal, D_E_Register_1141_io_out_is_csr, D_E_Register_1141_io_out_rs2_src, D_E_Register_1141_io_out_jal, Execute_1384_io_in_rs2_src, Execute_1384_io_in_is_csr, Execute_1384_io_in_jal, Execute_1384_io_out_is_csr, Execute_1384_io_out_jal, Execute_1384_io_out_branch_stall, E_M_Register_1551_clk, E_M_Register_1551_reset, E_M_Register_1551_io_in_is_csr, E_M_Register_1551_io_out_is_csr, Memory_1826_io_DBUS_out_miss, Memory_1826_io_DBUS_out_rw, Memory_1826_io_DBUS_in_data_valid, Memory_1826_io_DBUS_in_data_ready, Memory_1826_io_DBUS_out_data_valid, Memory_1826_io_DBUS_out_data_ready, Memory_1826_io_DBUS_out_address_valid, Memory_1826_io_DBUS_out_address_ready, Memory_1826_io_DBUS_out_control_valid, Memory_1826_io_DBUS_out_control_ready, Memory_1826_io_out_branch_dir, M_W_Register_1942_clk, M_W_Register_1942_reset, Forwarding_2232_io_in_execute_is_csr, Forwarding_2232_io_in_memory_is_csr, Forwarding_2232_io_out_src1_fwd, Forwarding_2232_io_out_src2_fwd, Forwarding_2232_io_out_csr_fwd, Forwarding_2232_io_out_fwd_stall, Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_data, Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_valid, Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_ready, Interrupt_Handler_2309_io_out_interrupt, JTAG_2572_clk, JTAG_2572_reset, JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_data, JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_valid, JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_ready, JTAG_2572_io_JTAG_JTAG_TAP_in_clock_data, JTAG_2572_io_JTAG_JTAG_TAP_in_clock_valid, JTAG_2572_io_JTAG_JTAG_TAP_in_clock_ready, JTAG_2572_io_JTAG_JTAG_TAP_in_reset_data, JTAG_2572_io_JTAG_JTAG_TAP_in_reset_valid, JTAG_2572_io_JTAG_JTAG_TAP_in_reset_ready, JTAG_2572_io_JTAG_in_data_data, JTAG_2572_io_JTAG_in_data_valid, JTAG_2572_io_JTAG_in_data_ready, JTAG_2572_io_JTAG_out_data_data, JTAG_2572_io_JTAG_out_data_valid, JTAG_2572_io_JTAG_out_data_ready, CSR_Handler_2672_clk, CSR_Handler_2672_reset, CSR_Handler_2672_io_in_mem_is_csr;
  wire[31:0] Fetch_248_io_IBUS_in_data_data, Fetch_248_io_IBUS_out_address_data, Fetch_248_io_in_branch_dest, Fetch_248_io_in_jal_dest, Fetch_248_io_in_interrupt_pc, Fetch_248_io_out_instruction, Fetch_248_io_out_curr_PC, F_D_Register_331_io_in_instruction, F_D_Register_331_io_in_curr_PC, F_D_Register_331_io_out_instruction, F_D_Register_331_io_out_curr_PC, Decode_890_io_in_instruction, Decode_890_io_in_curr_PC, Decode_890_io_in_write_data, Decode_890_io_in_src1_fwd_data, Decode_890_io_in_src2_fwd_data, Decode_890_io_in_csr_fwd_data, Decode_890_io_out_csr_mask, Decode_890_io_out_rd1, Decode_890_io_out_rd2, Decode_890_io_out_itype_immed, Decode_890_io_out_jal_offset, Decode_890_io_out_PC_next, D_E_Register_1141_io_in_rd1, D_E_Register_1141_io_in_rd2, D_E_Register_1141_io_in_itype_immed, D_E_Register_1141_io_in_PC_next, D_E_Register_1141_io_in_csr_mask, D_E_Register_1141_io_in_curr_PC, D_E_Register_1141_io_in_jal_offset, D_E_Register_1141_io_out_csr_mask, D_E_Register_1141_io_out_rd1, D_E_Register_1141_io_out_rd2, D_E_Register_1141_io_out_itype_immed, D_E_Register_1141_io_out_curr_PC, D_E_Register_1141_io_out_jal_offset, D_E_Register_1141_io_out_PC_next, Execute_1384_io_in_rd1, Execute_1384_io_in_rd2, Execute_1384_io_in_itype_immed, Execute_1384_io_in_PC_next, Execute_1384_io_in_csr_data, Execute_1384_io_in_csr_mask, Execute_1384_io_in_jal_offset, Execute_1384_io_in_curr_PC, Execute_1384_io_out_csr_result, Execute_1384_io_out_alu_result, Execute_1384_io_out_rd1, Execute_1384_io_out_rd2, Execute_1384_io_out_jal_dest, Execute_1384_io_out_branch_offset, Execute_1384_io_out_PC_next, E_M_Register_1551_io_in_alu_result, E_M_Register_1551_io_in_rd1, E_M_Register_1551_io_in_rd2, E_M_Register_1551_io_in_PC_next, E_M_Register_1551_io_in_csr_result, E_M_Register_1551_io_in_curr_PC, E_M_Register_1551_io_in_branch_offset, E_M_Register_1551_io_out_csr_result, E_M_Register_1551_io_out_alu_result, E_M_Register_1551_io_out_rd1, E_M_Register_1551_io_out_rd2, E_M_Register_1551_io_out_curr_PC, E_M_Register_1551_io_out_branch_offset, E_M_Register_1551_io_out_PC_next, Memory_1826_io_DBUS_in_data_data, Memory_1826_io_DBUS_out_data_data, Memory_1826_io_DBUS_out_address_data, Memory_1826_io_in_alu_result, Memory_1826_io_in_rd1, Memory_1826_io_in_rd2, Memory_1826_io_in_PC_next, Memory_1826_io_in_curr_PC, Memory_1826_io_in_branch_offset, Memory_1826_io_out_alu_result, Memory_1826_io_out_mem_result, Memory_1826_io_out_branch_dest, Memory_1826_io_out_PC_next, M_W_Register_1942_io_in_alu_result, M_W_Register_1942_io_in_mem_result, M_W_Register_1942_io_in_PC_next, M_W_Register_1942_io_out_alu_result, M_W_Register_1942_io_out_mem_result, M_W_Register_1942_io_out_PC_next, Write_Back_1996_io_in_alu_result, Write_Back_1996_io_in_mem_result, Write_Back_1996_io_in_PC_next, Write_Back_1996_io_out_write_data, Forwarding_2232_io_in_execute_alu_result, Forwarding_2232_io_in_execute_PC_next, Forwarding_2232_io_in_execute_csr_result, Forwarding_2232_io_in_memory_alu_result, Forwarding_2232_io_in_memory_mem_data, Forwarding_2232_io_in_memory_PC_next, Forwarding_2232_io_in_memory_csr_result, Forwarding_2232_io_in_writeback_alu_result, Forwarding_2232_io_in_writeback_mem_data, Forwarding_2232_io_in_writeback_PC_next, Forwarding_2232_io_out_src1_fwd_data, Forwarding_2232_io_out_src2_fwd_data, Forwarding_2232_io_out_csr_fwd_data, Interrupt_Handler_2309_io_out_interrupt_pc, CSR_Handler_2672_io_in_mem_csr_result, CSR_Handler_2672_io_out_decode_csr_data;
  wire[4:0] Decode_890_io_in_rd, Decode_890_io_out_rd, Decode_890_io_out_rs1, Decode_890_io_out_rs2, D_E_Register_1141_io_in_rd, D_E_Register_1141_io_in_rs1, D_E_Register_1141_io_in_rs2, D_E_Register_1141_io_out_rd, D_E_Register_1141_io_out_rs1, D_E_Register_1141_io_out_rs2, Execute_1384_io_in_rd, Execute_1384_io_in_rs1, Execute_1384_io_in_rs2, Execute_1384_io_out_rd, Execute_1384_io_out_rs1, Execute_1384_io_out_rs2, E_M_Register_1551_io_in_rd, E_M_Register_1551_io_in_rs1, E_M_Register_1551_io_in_rs2, E_M_Register_1551_io_out_rd, E_M_Register_1551_io_out_rs1, E_M_Register_1551_io_out_rs2, Memory_1826_io_in_rd, Memory_1826_io_in_rs1, Memory_1826_io_in_rs2, Memory_1826_io_out_rd, Memory_1826_io_out_rs1, Memory_1826_io_out_rs2, M_W_Register_1942_io_in_rd, M_W_Register_1942_io_in_rs1, M_W_Register_1942_io_in_rs2, M_W_Register_1942_io_out_rd, M_W_Register_1942_io_out_rs1, M_W_Register_1942_io_out_rs2, Write_Back_1996_io_in_rd, Write_Back_1996_io_in_rs1, Write_Back_1996_io_in_rs2, Write_Back_1996_io_out_rd, Forwarding_2232_io_in_decode_src1, Forwarding_2232_io_in_decode_src2, Forwarding_2232_io_in_execute_dest, Forwarding_2232_io_in_memory_dest, Forwarding_2232_io_in_writeback_dest;
  wire[1:0] Decode_890_io_in_wb, Decode_890_io_out_wb, D_E_Register_1141_io_in_wb, D_E_Register_1141_io_out_wb, Execute_1384_io_in_wb, Execute_1384_io_out_wb, E_M_Register_1551_io_in_wb, E_M_Register_1551_io_out_wb, Memory_1826_io_in_wb, Memory_1826_io_out_wb, M_W_Register_1942_io_in_wb, M_W_Register_1942_io_out_wb, Write_Back_1996_io_in_wb, Write_Back_1996_io_out_wb, Forwarding_2232_io_in_execute_wb, Forwarding_2232_io_in_memory_wb, Forwarding_2232_io_in_writeback_wb;
  wire[11:0] Decode_890_io_out_csr_address, D_E_Register_1141_io_in_csr_address, D_E_Register_1141_io_out_csr_address, Execute_1384_io_in_csr_address, Execute_1384_io_out_csr_address, E_M_Register_1551_io_in_csr_address, E_M_Register_1551_io_out_csr_address, Forwarding_2232_io_in_decode_csr_address, Forwarding_2232_io_in_execute_csr_address, Forwarding_2232_io_in_memory_csr_address, CSR_Handler_2672_io_in_decode_csr_address, CSR_Handler_2672_io_in_mem_csr_address;
  wire[3:0] Decode_890_io_out_alu_op, D_E_Register_1141_io_in_alu_op, D_E_Register_1141_io_out_alu_op, Execute_1384_io_in_alu_op;
  wire[2:0] Decode_890_io_out_mem_read, Decode_890_io_out_mem_write, Decode_890_io_out_branch_type, D_E_Register_1141_io_in_mem_read, D_E_Register_1141_io_in_mem_write, D_E_Register_1141_io_in_branch_type, D_E_Register_1141_io_out_mem_read, D_E_Register_1141_io_out_mem_write, D_E_Register_1141_io_out_branch_type, Execute_1384_io_in_mem_read, Execute_1384_io_in_mem_write, Execute_1384_io_in_branch_type, Execute_1384_io_out_mem_read, Execute_1384_io_out_mem_write, E_M_Register_1551_io_in_mem_read, E_M_Register_1551_io_in_mem_write, E_M_Register_1551_io_in_branch_type, E_M_Register_1551_io_out_mem_read, E_M_Register_1551_io_out_mem_write, E_M_Register_1551_io_out_branch_type, Memory_1826_io_DBUS_out_control_data, Memory_1826_io_in_mem_read, Memory_1826_io_in_mem_write, Memory_1826_io_in_branch_type;
  wire[19:0] Decode_890_io_out_upper_immed, D_E_Register_1141_io_in_upper_immed, D_E_Register_1141_io_out_upper_immed, Execute_1384_io_in_upper_immed;

  assign op_orl_2685 = Decode_890_io_out_branch_stall || Execute_1384_io_out_branch_stall;
  assign op_eq_2690 = Execute_1384_io_out_branch_stall == 1'h1;
  Fetch Fetch_248(.clk(Fetch_248_clk), .reset(Fetch_248_reset), .io_IBUS_in_data_data(Fetch_248_io_IBUS_in_data_data), .io_IBUS_in_data_valid(Fetch_248_io_IBUS_in_data_valid), .io_IBUS_out_address_ready(Fetch_248_io_IBUS_out_address_ready), .io_in_branch_dir(Fetch_248_io_in_branch_dir), .io_in_freeze(Fetch_248_io_in_freeze), .io_in_branch_dest(Fetch_248_io_in_branch_dest), .io_in_branch_stall(Fetch_248_io_in_branch_stall), .io_in_fwd_stall(Fetch_248_io_in_fwd_stall), .io_in_branch_stall_exe(Fetch_248_io_in_branch_stall_exe), .io_in_jal(Fetch_248_io_in_jal), .io_in_jal_dest(Fetch_248_io_in_jal_dest), .io_in_interrupt(Fetch_248_io_in_interrupt), .io_in_interrupt_pc(Fetch_248_io_in_interrupt_pc), .io_in_debug(Fetch_248_io_in_debug), .io_IBUS_in_data_ready(Fetch_248_io_IBUS_in_data_ready), .io_IBUS_out_address_data(Fetch_248_io_IBUS_out_address_data), .io_IBUS_out_address_valid(Fetch_248_io_IBUS_out_address_valid), .io_out_instruction(Fetch_248_io_out_instruction), .io_out_curr_PC(Fetch_248_io_out_curr_PC));
  F_D_Register F_D_Register_331(.clk(F_D_Register_331_clk), .reset(F_D_Register_331_reset), .io_in_instruction(F_D_Register_331_io_in_instruction), .io_in_curr_PC(F_D_Register_331_io_in_curr_PC), .io_in_branch_stall(F_D_Register_331_io_in_branch_stall), .io_in_branch_stall_exe(F_D_Register_331_io_in_branch_stall_exe), .io_in_fwd_stall(F_D_Register_331_io_in_fwd_stall), .io_out_instruction(F_D_Register_331_io_out_instruction), .io_out_curr_PC(F_D_Register_331_io_out_curr_PC));
  Decode Decode_890(.clk(Decode_890_clk), .io_in_instruction(Decode_890_io_in_instruction), .io_in_curr_PC(Decode_890_io_in_curr_PC), .io_in_stall(Decode_890_io_in_stall), .io_in_write_data(Decode_890_io_in_write_data), .io_in_rd(Decode_890_io_in_rd), .io_in_wb(Decode_890_io_in_wb), .io_in_src1_fwd(Decode_890_io_in_src1_fwd), .io_in_src1_fwd_data(Decode_890_io_in_src1_fwd_data), .io_in_src2_fwd(Decode_890_io_in_src2_fwd), .io_in_src2_fwd_data(Decode_890_io_in_src2_fwd_data), .io_in_csr_fwd(Decode_890_io_in_csr_fwd), .io_in_csr_fwd_data(Decode_890_io_in_csr_fwd_data), .io_out_csr_address(Decode_890_io_out_csr_address), .io_out_is_csr(Decode_890_io_out_is_csr), .io_out_csr_mask(Decode_890_io_out_csr_mask), .io_out_rd(Decode_890_io_out_rd), .io_out_rs1(Decode_890_io_out_rs1), .io_out_rd1(Decode_890_io_out_rd1), .io_out_rs2(Decode_890_io_out_rs2), .io_out_rd2(Decode_890_io_out_rd2), .io_out_wb(Decode_890_io_out_wb), .io_out_alu_op(Decode_890_io_out_alu_op), .io_out_rs2_src(Decode_890_io_out_rs2_src), .io_out_itype_immed(Decode_890_io_out_itype_immed), .io_out_mem_read(Decode_890_io_out_mem_read), .io_out_mem_write(Decode_890_io_out_mem_write), .io_out_branch_type(Decode_890_io_out_branch_type), .io_out_branch_stall(Decode_890_io_out_branch_stall), .io_out_jal(Decode_890_io_out_jal), .io_out_jal_offset(Decode_890_io_out_jal_offset), .io_out_upper_immed(Decode_890_io_out_upper_immed), .io_out_PC_next(Decode_890_io_out_PC_next));
  D_E_Register D_E_Register_1141(.clk(D_E_Register_1141_clk), .reset(D_E_Register_1141_reset), .io_in_rd(D_E_Register_1141_io_in_rd), .io_in_rs1(D_E_Register_1141_io_in_rs1), .io_in_rd1(D_E_Register_1141_io_in_rd1), .io_in_rs2(D_E_Register_1141_io_in_rs2), .io_in_rd2(D_E_Register_1141_io_in_rd2), .io_in_alu_op(D_E_Register_1141_io_in_alu_op), .io_in_wb(D_E_Register_1141_io_in_wb), .io_in_rs2_src(D_E_Register_1141_io_in_rs2_src), .io_in_itype_immed(D_E_Register_1141_io_in_itype_immed), .io_in_mem_read(D_E_Register_1141_io_in_mem_read), .io_in_mem_write(D_E_Register_1141_io_in_mem_write), .io_in_PC_next(D_E_Register_1141_io_in_PC_next), .io_in_branch_type(D_E_Register_1141_io_in_branch_type), .io_in_fwd_stall(D_E_Register_1141_io_in_fwd_stall), .io_in_branch_stall(D_E_Register_1141_io_in_branch_stall), .io_in_upper_immed(D_E_Register_1141_io_in_upper_immed), .io_in_csr_address(D_E_Register_1141_io_in_csr_address), .io_in_is_csr(D_E_Register_1141_io_in_is_csr), .io_in_csr_mask(D_E_Register_1141_io_in_csr_mask), .io_in_curr_PC(D_E_Register_1141_io_in_curr_PC), .io_in_jal(D_E_Register_1141_io_in_jal), .io_in_jal_offset(D_E_Register_1141_io_in_jal_offset), .io_out_csr_address(D_E_Register_1141_io_out_csr_address), .io_out_is_csr(D_E_Register_1141_io_out_is_csr), .io_out_csr_mask(D_E_Register_1141_io_out_csr_mask), .io_out_rd(D_E_Register_1141_io_out_rd), .io_out_rs1(D_E_Register_1141_io_out_rs1), .io_out_rd1(D_E_Register_1141_io_out_rd1), .io_out_rs2(D_E_Register_1141_io_out_rs2), .io_out_rd2(D_E_Register_1141_io_out_rd2), .io_out_alu_op(D_E_Register_1141_io_out_alu_op), .io_out_wb(D_E_Register_1141_io_out_wb), .io_out_rs2_src(D_E_Register_1141_io_out_rs2_src), .io_out_itype_immed(D_E_Register_1141_io_out_itype_immed), .io_out_mem_read(D_E_Register_1141_io_out_mem_read), .io_out_mem_write(D_E_Register_1141_io_out_mem_write), .io_out_branch_type(D_E_Register_1141_io_out_branch_type), .io_out_upper_immed(D_E_Register_1141_io_out_upper_immed), .io_out_curr_PC(D_E_Register_1141_io_out_curr_PC), .io_out_jal(D_E_Register_1141_io_out_jal), .io_out_jal_offset(D_E_Register_1141_io_out_jal_offset), .io_out_PC_next(D_E_Register_1141_io_out_PC_next));
  Execute Execute_1384(.io_in_rd(Execute_1384_io_in_rd), .io_in_rs1(Execute_1384_io_in_rs1), .io_in_rd1(Execute_1384_io_in_rd1), .io_in_rs2(Execute_1384_io_in_rs2), .io_in_rd2(Execute_1384_io_in_rd2), .io_in_alu_op(Execute_1384_io_in_alu_op), .io_in_wb(Execute_1384_io_in_wb), .io_in_rs2_src(Execute_1384_io_in_rs2_src), .io_in_itype_immed(Execute_1384_io_in_itype_immed), .io_in_mem_read(Execute_1384_io_in_mem_read), .io_in_mem_write(Execute_1384_io_in_mem_write), .io_in_PC_next(Execute_1384_io_in_PC_next), .io_in_branch_type(Execute_1384_io_in_branch_type), .io_in_upper_immed(Execute_1384_io_in_upper_immed), .io_in_csr_address(Execute_1384_io_in_csr_address), .io_in_is_csr(Execute_1384_io_in_is_csr), .io_in_csr_data(Execute_1384_io_in_csr_data), .io_in_csr_mask(Execute_1384_io_in_csr_mask), .io_in_jal(Execute_1384_io_in_jal), .io_in_jal_offset(Execute_1384_io_in_jal_offset), .io_in_curr_PC(Execute_1384_io_in_curr_PC), .io_out_csr_address(Execute_1384_io_out_csr_address), .io_out_is_csr(Execute_1384_io_out_is_csr), .io_out_csr_result(Execute_1384_io_out_csr_result), .io_out_alu_result(Execute_1384_io_out_alu_result), .io_out_rd(Execute_1384_io_out_rd), .io_out_wb(Execute_1384_io_out_wb), .io_out_rs1(Execute_1384_io_out_rs1), .io_out_rd1(Execute_1384_io_out_rd1), .io_out_rs2(Execute_1384_io_out_rs2), .io_out_rd2(Execute_1384_io_out_rd2), .io_out_mem_read(Execute_1384_io_out_mem_read), .io_out_mem_write(Execute_1384_io_out_mem_write), .io_out_jal(Execute_1384_io_out_jal), .io_out_jal_dest(Execute_1384_io_out_jal_dest), .io_out_branch_offset(Execute_1384_io_out_branch_offset), .io_out_branch_stall(Execute_1384_io_out_branch_stall), .io_out_PC_next(Execute_1384_io_out_PC_next));
  E_M_Register E_M_Register_1551(.clk(E_M_Register_1551_clk), .reset(E_M_Register_1551_reset), .io_in_alu_result(E_M_Register_1551_io_in_alu_result), .io_in_rd(E_M_Register_1551_io_in_rd), .io_in_wb(E_M_Register_1551_io_in_wb), .io_in_rs1(E_M_Register_1551_io_in_rs1), .io_in_rd1(E_M_Register_1551_io_in_rd1), .io_in_rs2(E_M_Register_1551_io_in_rs2), .io_in_rd2(E_M_Register_1551_io_in_rd2), .io_in_mem_read(E_M_Register_1551_io_in_mem_read), .io_in_mem_write(E_M_Register_1551_io_in_mem_write), .io_in_PC_next(E_M_Register_1551_io_in_PC_next), .io_in_csr_address(E_M_Register_1551_io_in_csr_address), .io_in_is_csr(E_M_Register_1551_io_in_is_csr), .io_in_csr_result(E_M_Register_1551_io_in_csr_result), .io_in_curr_PC(E_M_Register_1551_io_in_curr_PC), .io_in_branch_offset(E_M_Register_1551_io_in_branch_offset), .io_in_branch_type(E_M_Register_1551_io_in_branch_type), .io_out_csr_address(E_M_Register_1551_io_out_csr_address), .io_out_is_csr(E_M_Register_1551_io_out_is_csr), .io_out_csr_result(E_M_Register_1551_io_out_csr_result), .io_out_alu_result(E_M_Register_1551_io_out_alu_result), .io_out_rd(E_M_Register_1551_io_out_rd), .io_out_wb(E_M_Register_1551_io_out_wb), .io_out_rs1(E_M_Register_1551_io_out_rs1), .io_out_rd1(E_M_Register_1551_io_out_rd1), .io_out_rd2(E_M_Register_1551_io_out_rd2), .io_out_rs2(E_M_Register_1551_io_out_rs2), .io_out_mem_read(E_M_Register_1551_io_out_mem_read), .io_out_mem_write(E_M_Register_1551_io_out_mem_write), .io_out_curr_PC(E_M_Register_1551_io_out_curr_PC), .io_out_branch_offset(E_M_Register_1551_io_out_branch_offset), .io_out_branch_type(E_M_Register_1551_io_out_branch_type), .io_out_PC_next(E_M_Register_1551_io_out_PC_next));
  Memory Memory_1826(.io_DBUS_in_data_data(Memory_1826_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Memory_1826_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Memory_1826_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Memory_1826_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Memory_1826_io_DBUS_out_control_ready), .io_in_alu_result(Memory_1826_io_in_alu_result), .io_in_mem_read(Memory_1826_io_in_mem_read), .io_in_mem_write(Memory_1826_io_in_mem_write), .io_in_rd(Memory_1826_io_in_rd), .io_in_wb(Memory_1826_io_in_wb), .io_in_rs1(Memory_1826_io_in_rs1), .io_in_rd1(Memory_1826_io_in_rd1), .io_in_rs2(Memory_1826_io_in_rs2), .io_in_rd2(Memory_1826_io_in_rd2), .io_in_PC_next(Memory_1826_io_in_PC_next), .io_in_curr_PC(Memory_1826_io_in_curr_PC), .io_in_branch_offset(Memory_1826_io_in_branch_offset), .io_in_branch_type(Memory_1826_io_in_branch_type), .io_DBUS_out_miss(Memory_1826_io_DBUS_out_miss), .io_DBUS_out_rw(Memory_1826_io_DBUS_out_rw), .io_DBUS_in_data_ready(Memory_1826_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Memory_1826_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Memory_1826_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Memory_1826_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Memory_1826_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Memory_1826_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Memory_1826_io_DBUS_out_control_valid), .io_out_alu_result(Memory_1826_io_out_alu_result), .io_out_mem_result(Memory_1826_io_out_mem_result), .io_out_rd(Memory_1826_io_out_rd), .io_out_wb(Memory_1826_io_out_wb), .io_out_rs1(Memory_1826_io_out_rs1), .io_out_rs2(Memory_1826_io_out_rs2), .io_out_branch_dir(Memory_1826_io_out_branch_dir), .io_out_branch_dest(Memory_1826_io_out_branch_dest), .io_out_PC_next(Memory_1826_io_out_PC_next));
  M_W_Register M_W_Register_1942(.clk(M_W_Register_1942_clk), .reset(M_W_Register_1942_reset), .io_in_alu_result(M_W_Register_1942_io_in_alu_result), .io_in_mem_result(M_W_Register_1942_io_in_mem_result), .io_in_rd(M_W_Register_1942_io_in_rd), .io_in_wb(M_W_Register_1942_io_in_wb), .io_in_rs1(M_W_Register_1942_io_in_rs1), .io_in_rs2(M_W_Register_1942_io_in_rs2), .io_in_PC_next(M_W_Register_1942_io_in_PC_next), .io_out_alu_result(M_W_Register_1942_io_out_alu_result), .io_out_mem_result(M_W_Register_1942_io_out_mem_result), .io_out_rd(M_W_Register_1942_io_out_rd), .io_out_wb(M_W_Register_1942_io_out_wb), .io_out_rs1(M_W_Register_1942_io_out_rs1), .io_out_rs2(M_W_Register_1942_io_out_rs2), .io_out_PC_next(M_W_Register_1942_io_out_PC_next));
  Write_Back Write_Back_1996(.io_in_alu_result(Write_Back_1996_io_in_alu_result), .io_in_mem_result(Write_Back_1996_io_in_mem_result), .io_in_rd(Write_Back_1996_io_in_rd), .io_in_wb(Write_Back_1996_io_in_wb), .io_in_rs1(Write_Back_1996_io_in_rs1), .io_in_rs2(Write_Back_1996_io_in_rs2), .io_in_PC_next(Write_Back_1996_io_in_PC_next), .io_out_write_data(Write_Back_1996_io_out_write_data), .io_out_rd(Write_Back_1996_io_out_rd), .io_out_wb(Write_Back_1996_io_out_wb));
  Forwarding Forwarding_2232(.io_in_decode_src1(Forwarding_2232_io_in_decode_src1), .io_in_decode_src2(Forwarding_2232_io_in_decode_src2), .io_in_decode_csr_address(Forwarding_2232_io_in_decode_csr_address), .io_in_execute_dest(Forwarding_2232_io_in_execute_dest), .io_in_execute_wb(Forwarding_2232_io_in_execute_wb), .io_in_execute_alu_result(Forwarding_2232_io_in_execute_alu_result), .io_in_execute_PC_next(Forwarding_2232_io_in_execute_PC_next), .io_in_execute_is_csr(Forwarding_2232_io_in_execute_is_csr), .io_in_execute_csr_address(Forwarding_2232_io_in_execute_csr_address), .io_in_execute_csr_result(Forwarding_2232_io_in_execute_csr_result), .io_in_memory_dest(Forwarding_2232_io_in_memory_dest), .io_in_memory_wb(Forwarding_2232_io_in_memory_wb), .io_in_memory_alu_result(Forwarding_2232_io_in_memory_alu_result), .io_in_memory_mem_data(Forwarding_2232_io_in_memory_mem_data), .io_in_memory_PC_next(Forwarding_2232_io_in_memory_PC_next), .io_in_memory_is_csr(Forwarding_2232_io_in_memory_is_csr), .io_in_memory_csr_address(Forwarding_2232_io_in_memory_csr_address), .io_in_memory_csr_result(Forwarding_2232_io_in_memory_csr_result), .io_in_writeback_dest(Forwarding_2232_io_in_writeback_dest), .io_in_writeback_wb(Forwarding_2232_io_in_writeback_wb), .io_in_writeback_alu_result(Forwarding_2232_io_in_writeback_alu_result), .io_in_writeback_mem_data(Forwarding_2232_io_in_writeback_mem_data), .io_in_writeback_PC_next(Forwarding_2232_io_in_writeback_PC_next), .io_out_src1_fwd(Forwarding_2232_io_out_src1_fwd), .io_out_src2_fwd(Forwarding_2232_io_out_src2_fwd), .io_out_csr_fwd(Forwarding_2232_io_out_csr_fwd), .io_out_src1_fwd_data(Forwarding_2232_io_out_src1_fwd_data), .io_out_src2_fwd_data(Forwarding_2232_io_out_src2_fwd_data), .io_out_csr_fwd_data(Forwarding_2232_io_out_csr_fwd_data), .io_out_fwd_stall(Forwarding_2232_io_out_fwd_stall));
  Interrupt_Handler Interrupt_Handler_2309(.io_INTERRUPT_in_interrupt_id_data(Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_data), .io_INTERRUPT_in_interrupt_id_valid(Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_valid), .io_INTERRUPT_in_interrupt_id_ready(Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_ready), .io_out_interrupt(Interrupt_Handler_2309_io_out_interrupt), .io_out_interrupt_pc(Interrupt_Handler_2309_io_out_interrupt_pc));
  JTAG JTAG_2572(.clk(JTAG_2572_clk), .reset(JTAG_2572_reset), .io_JTAG_JTAG_TAP_in_mode_select_data(JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_data), .io_JTAG_JTAG_TAP_in_mode_select_valid(JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_valid), .io_JTAG_JTAG_TAP_in_clock_data(JTAG_2572_io_JTAG_JTAG_TAP_in_clock_data), .io_JTAG_JTAG_TAP_in_clock_valid(JTAG_2572_io_JTAG_JTAG_TAP_in_clock_valid), .io_JTAG_JTAG_TAP_in_reset_data(JTAG_2572_io_JTAG_JTAG_TAP_in_reset_data), .io_JTAG_JTAG_TAP_in_reset_valid(JTAG_2572_io_JTAG_JTAG_TAP_in_reset_valid), .io_JTAG_in_data_data(JTAG_2572_io_JTAG_in_data_data), .io_JTAG_in_data_valid(JTAG_2572_io_JTAG_in_data_valid), .io_JTAG_out_data_ready(JTAG_2572_io_JTAG_out_data_ready), .io_JTAG_JTAG_TAP_in_mode_select_ready(JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_ready), .io_JTAG_JTAG_TAP_in_clock_ready(JTAG_2572_io_JTAG_JTAG_TAP_in_clock_ready), .io_JTAG_JTAG_TAP_in_reset_ready(JTAG_2572_io_JTAG_JTAG_TAP_in_reset_ready), .io_JTAG_in_data_ready(JTAG_2572_io_JTAG_in_data_ready), .io_JTAG_out_data_data(JTAG_2572_io_JTAG_out_data_data), .io_JTAG_out_data_valid(JTAG_2572_io_JTAG_out_data_valid));
  CSR_Handler CSR_Handler_2672(.clk(CSR_Handler_2672_clk), .reset(CSR_Handler_2672_reset), .io_in_decode_csr_address(CSR_Handler_2672_io_in_decode_csr_address), .io_in_mem_csr_address(CSR_Handler_2672_io_in_mem_csr_address), .io_in_mem_is_csr(CSR_Handler_2672_io_in_mem_is_csr), .io_in_mem_csr_result(CSR_Handler_2672_io_in_mem_csr_result), .io_out_decode_csr_data(CSR_Handler_2672_io_out_decode_csr_data));
  assign Fetch_248_clk = clk;
  assign Fetch_248_reset = reset;
  assign Fetch_248_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign Fetch_248_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign Fetch_248_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign Fetch_248_io_in_branch_dir = Memory_1826_io_out_branch_dir;
  assign Fetch_248_io_in_freeze = 1'h0;
  assign Fetch_248_io_in_branch_dest = Memory_1826_io_out_branch_dest;
  assign Fetch_248_io_in_branch_stall = Decode_890_io_out_branch_stall;
  assign Fetch_248_io_in_fwd_stall = Forwarding_2232_io_out_fwd_stall;
  assign Fetch_248_io_in_branch_stall_exe = Execute_1384_io_out_branch_stall;
  assign Fetch_248_io_in_jal = Execute_1384_io_out_jal;
  assign Fetch_248_io_in_jal_dest = Execute_1384_io_out_jal_dest;
  assign Fetch_248_io_in_interrupt = Interrupt_Handler_2309_io_out_interrupt;
  assign Fetch_248_io_in_interrupt_pc = Interrupt_Handler_2309_io_out_interrupt_pc;
  assign Fetch_248_io_in_debug = 1'h0;
  assign F_D_Register_331_clk = clk;
  assign F_D_Register_331_reset = reset;
  assign F_D_Register_331_io_in_instruction = Fetch_248_io_out_instruction;
  assign F_D_Register_331_io_in_curr_PC = Fetch_248_io_out_curr_PC;
  assign F_D_Register_331_io_in_branch_stall = Decode_890_io_out_branch_stall;
  assign F_D_Register_331_io_in_branch_stall_exe = Execute_1384_io_out_branch_stall;
  assign F_D_Register_331_io_in_fwd_stall = Forwarding_2232_io_out_fwd_stall;
  assign Decode_890_clk = clk;
  assign Decode_890_io_in_instruction = F_D_Register_331_io_out_instruction;
  assign Decode_890_io_in_curr_PC = F_D_Register_331_io_out_curr_PC;
  assign Decode_890_io_in_stall = op_eq_2690;
  assign Decode_890_io_in_write_data = Write_Back_1996_io_out_write_data;
  assign Decode_890_io_in_rd = Write_Back_1996_io_out_rd;
  assign Decode_890_io_in_wb = Write_Back_1996_io_out_wb;
  assign Decode_890_io_in_src1_fwd = Forwarding_2232_io_out_src1_fwd;
  assign Decode_890_io_in_src1_fwd_data = Forwarding_2232_io_out_src1_fwd_data;
  assign Decode_890_io_in_src2_fwd = Forwarding_2232_io_out_src2_fwd;
  assign Decode_890_io_in_src2_fwd_data = Forwarding_2232_io_out_src2_fwd_data;
  assign Decode_890_io_in_csr_fwd = Forwarding_2232_io_out_csr_fwd;
  assign Decode_890_io_in_csr_fwd_data = Forwarding_2232_io_out_csr_fwd_data;
  assign D_E_Register_1141_clk = clk;
  assign D_E_Register_1141_reset = reset;
  assign D_E_Register_1141_io_in_rd = Decode_890_io_out_rd;
  assign D_E_Register_1141_io_in_rs1 = Decode_890_io_out_rs1;
  assign D_E_Register_1141_io_in_rd1 = Decode_890_io_out_rd1;
  assign D_E_Register_1141_io_in_rs2 = Decode_890_io_out_rs2;
  assign D_E_Register_1141_io_in_rd2 = Decode_890_io_out_rd2;
  assign D_E_Register_1141_io_in_alu_op = Decode_890_io_out_alu_op;
  assign D_E_Register_1141_io_in_wb = Decode_890_io_out_wb;
  assign D_E_Register_1141_io_in_rs2_src = Decode_890_io_out_rs2_src;
  assign D_E_Register_1141_io_in_itype_immed = Decode_890_io_out_itype_immed;
  assign D_E_Register_1141_io_in_mem_read = Decode_890_io_out_mem_read;
  assign D_E_Register_1141_io_in_mem_write = Decode_890_io_out_mem_write;
  assign D_E_Register_1141_io_in_PC_next = Decode_890_io_out_PC_next;
  assign D_E_Register_1141_io_in_branch_type = Decode_890_io_out_branch_type;
  assign D_E_Register_1141_io_in_fwd_stall = Forwarding_2232_io_out_fwd_stall;
  assign D_E_Register_1141_io_in_branch_stall = Execute_1384_io_out_branch_stall;
  assign D_E_Register_1141_io_in_upper_immed = Decode_890_io_out_upper_immed;
  assign D_E_Register_1141_io_in_csr_address = Decode_890_io_out_csr_address;
  assign D_E_Register_1141_io_in_is_csr = Decode_890_io_out_is_csr;
  assign D_E_Register_1141_io_in_csr_mask = Decode_890_io_out_csr_mask;
  assign D_E_Register_1141_io_in_curr_PC = F_D_Register_331_io_out_curr_PC;
  assign D_E_Register_1141_io_in_jal = Decode_890_io_out_jal;
  assign D_E_Register_1141_io_in_jal_offset = Decode_890_io_out_jal_offset;
  assign Execute_1384_io_in_rd = D_E_Register_1141_io_out_rd;
  assign Execute_1384_io_in_rs1 = D_E_Register_1141_io_out_rs1;
  assign Execute_1384_io_in_rd1 = D_E_Register_1141_io_out_rd1;
  assign Execute_1384_io_in_rs2 = D_E_Register_1141_io_out_rs2;
  assign Execute_1384_io_in_rd2 = D_E_Register_1141_io_out_rd2;
  assign Execute_1384_io_in_alu_op = D_E_Register_1141_io_out_alu_op;
  assign Execute_1384_io_in_wb = D_E_Register_1141_io_out_wb;
  assign Execute_1384_io_in_rs2_src = D_E_Register_1141_io_out_rs2_src;
  assign Execute_1384_io_in_itype_immed = D_E_Register_1141_io_out_itype_immed;
  assign Execute_1384_io_in_mem_read = D_E_Register_1141_io_out_mem_read;
  assign Execute_1384_io_in_mem_write = D_E_Register_1141_io_out_mem_write;
  assign Execute_1384_io_in_PC_next = D_E_Register_1141_io_out_PC_next;
  assign Execute_1384_io_in_branch_type = D_E_Register_1141_io_out_branch_type;
  assign Execute_1384_io_in_upper_immed = D_E_Register_1141_io_out_upper_immed;
  assign Execute_1384_io_in_csr_address = D_E_Register_1141_io_out_csr_address;
  assign Execute_1384_io_in_is_csr = D_E_Register_1141_io_out_is_csr;
  assign Execute_1384_io_in_csr_data = CSR_Handler_2672_io_out_decode_csr_data;
  assign Execute_1384_io_in_csr_mask = D_E_Register_1141_io_out_csr_mask;
  assign Execute_1384_io_in_jal = D_E_Register_1141_io_out_jal;
  assign Execute_1384_io_in_jal_offset = D_E_Register_1141_io_out_jal_offset;
  assign Execute_1384_io_in_curr_PC = D_E_Register_1141_io_out_curr_PC;
  assign E_M_Register_1551_clk = clk;
  assign E_M_Register_1551_reset = reset;
  assign E_M_Register_1551_io_in_alu_result = Execute_1384_io_out_alu_result;
  assign E_M_Register_1551_io_in_rd = Execute_1384_io_out_rd;
  assign E_M_Register_1551_io_in_wb = Execute_1384_io_out_wb;
  assign E_M_Register_1551_io_in_rs1 = Execute_1384_io_out_rs1;
  assign E_M_Register_1551_io_in_rd1 = Execute_1384_io_out_rd1;
  assign E_M_Register_1551_io_in_rs2 = Execute_1384_io_out_rs2;
  assign E_M_Register_1551_io_in_rd2 = Execute_1384_io_out_rd2;
  assign E_M_Register_1551_io_in_mem_read = Execute_1384_io_out_mem_read;
  assign E_M_Register_1551_io_in_mem_write = Execute_1384_io_out_mem_write;
  assign E_M_Register_1551_io_in_PC_next = Execute_1384_io_out_PC_next;
  assign E_M_Register_1551_io_in_csr_address = Execute_1384_io_out_csr_address;
  assign E_M_Register_1551_io_in_is_csr = Execute_1384_io_out_is_csr;
  assign E_M_Register_1551_io_in_csr_result = Execute_1384_io_out_csr_result;
  assign E_M_Register_1551_io_in_curr_PC = D_E_Register_1141_io_out_curr_PC;
  assign E_M_Register_1551_io_in_branch_offset = Execute_1384_io_out_branch_offset;
  assign E_M_Register_1551_io_in_branch_type = D_E_Register_1141_io_out_branch_type;
  assign Memory_1826_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Memory_1826_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Memory_1826_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Memory_1826_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Memory_1826_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Memory_1826_io_in_alu_result = E_M_Register_1551_io_out_alu_result;
  assign Memory_1826_io_in_mem_read = E_M_Register_1551_io_out_mem_read;
  assign Memory_1826_io_in_mem_write = E_M_Register_1551_io_out_mem_write;
  assign Memory_1826_io_in_rd = E_M_Register_1551_io_out_rd;
  assign Memory_1826_io_in_wb = E_M_Register_1551_io_out_wb;
  assign Memory_1826_io_in_rs1 = E_M_Register_1551_io_out_rs1;
  assign Memory_1826_io_in_rd1 = E_M_Register_1551_io_out_rd1;
  assign Memory_1826_io_in_rs2 = E_M_Register_1551_io_out_rs2;
  assign Memory_1826_io_in_rd2 = E_M_Register_1551_io_out_rd2;
  assign Memory_1826_io_in_PC_next = E_M_Register_1551_io_out_PC_next;
  assign Memory_1826_io_in_curr_PC = E_M_Register_1551_io_out_curr_PC;
  assign Memory_1826_io_in_branch_offset = E_M_Register_1551_io_out_branch_offset;
  assign Memory_1826_io_in_branch_type = E_M_Register_1551_io_out_branch_type;
  assign M_W_Register_1942_clk = clk;
  assign M_W_Register_1942_reset = reset;
  assign M_W_Register_1942_io_in_alu_result = Memory_1826_io_out_alu_result;
  assign M_W_Register_1942_io_in_mem_result = Memory_1826_io_out_mem_result;
  assign M_W_Register_1942_io_in_rd = Memory_1826_io_out_rd;
  assign M_W_Register_1942_io_in_wb = Memory_1826_io_out_wb;
  assign M_W_Register_1942_io_in_rs1 = Memory_1826_io_out_rs1;
  assign M_W_Register_1942_io_in_rs2 = Memory_1826_io_out_rs2;
  assign M_W_Register_1942_io_in_PC_next = Memory_1826_io_out_PC_next;
  assign Write_Back_1996_io_in_alu_result = M_W_Register_1942_io_out_alu_result;
  assign Write_Back_1996_io_in_mem_result = M_W_Register_1942_io_out_mem_result;
  assign Write_Back_1996_io_in_rd = M_W_Register_1942_io_out_rd;
  assign Write_Back_1996_io_in_wb = M_W_Register_1942_io_out_wb;
  assign Write_Back_1996_io_in_rs1 = M_W_Register_1942_io_out_rs1;
  assign Write_Back_1996_io_in_rs2 = M_W_Register_1942_io_out_rs2;
  assign Write_Back_1996_io_in_PC_next = M_W_Register_1942_io_out_PC_next;
  assign Forwarding_2232_io_in_decode_src1 = Decode_890_io_out_rs1;
  assign Forwarding_2232_io_in_decode_src2 = Decode_890_io_out_rs2;
  assign Forwarding_2232_io_in_decode_csr_address = Decode_890_io_out_csr_address;
  assign Forwarding_2232_io_in_execute_dest = Execute_1384_io_out_rd;
  assign Forwarding_2232_io_in_execute_wb = Execute_1384_io_out_wb;
  assign Forwarding_2232_io_in_execute_alu_result = Execute_1384_io_out_alu_result;
  assign Forwarding_2232_io_in_execute_PC_next = Execute_1384_io_out_PC_next;
  assign Forwarding_2232_io_in_execute_is_csr = Execute_1384_io_out_is_csr;
  assign Forwarding_2232_io_in_execute_csr_address = Execute_1384_io_out_csr_address;
  assign Forwarding_2232_io_in_execute_csr_result = Execute_1384_io_out_csr_result;
  assign Forwarding_2232_io_in_memory_dest = Memory_1826_io_out_rd;
  assign Forwarding_2232_io_in_memory_wb = Memory_1826_io_out_wb;
  assign Forwarding_2232_io_in_memory_alu_result = Memory_1826_io_out_alu_result;
  assign Forwarding_2232_io_in_memory_mem_data = Memory_1826_io_out_mem_result;
  assign Forwarding_2232_io_in_memory_PC_next = Memory_1826_io_out_PC_next;
  assign Forwarding_2232_io_in_memory_is_csr = E_M_Register_1551_io_out_is_csr;
  assign Forwarding_2232_io_in_memory_csr_address = E_M_Register_1551_io_out_csr_address;
  assign Forwarding_2232_io_in_memory_csr_result = E_M_Register_1551_io_out_csr_result;
  assign Forwarding_2232_io_in_writeback_dest = M_W_Register_1942_io_out_rd;
  assign Forwarding_2232_io_in_writeback_wb = M_W_Register_1942_io_out_wb;
  assign Forwarding_2232_io_in_writeback_alu_result = M_W_Register_1942_io_out_alu_result;
  assign Forwarding_2232_io_in_writeback_mem_data = M_W_Register_1942_io_out_mem_result;
  assign Forwarding_2232_io_in_writeback_PC_next = M_W_Register_1942_io_out_PC_next;
  assign Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_data = io_INTERRUPT_in_interrupt_id_data;
  assign Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_valid = io_INTERRUPT_in_interrupt_id_valid;
  assign JTAG_2572_clk = clk;
  assign JTAG_2572_reset = reset;
  assign JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_data = io_jtag_JTAG_TAP_in_mode_select_data;
  assign JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_valid = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign JTAG_2572_io_JTAG_JTAG_TAP_in_clock_data = io_jtag_JTAG_TAP_in_clock_data;
  assign JTAG_2572_io_JTAG_JTAG_TAP_in_clock_valid = io_jtag_JTAG_TAP_in_clock_valid;
  assign JTAG_2572_io_JTAG_JTAG_TAP_in_reset_data = io_jtag_JTAG_TAP_in_reset_data;
  assign JTAG_2572_io_JTAG_JTAG_TAP_in_reset_valid = io_jtag_JTAG_TAP_in_reset_valid;
  assign JTAG_2572_io_JTAG_in_data_data = io_jtag_in_data_data;
  assign JTAG_2572_io_JTAG_in_data_valid = io_jtag_in_data_valid;
  assign JTAG_2572_io_JTAG_out_data_ready = io_jtag_out_data_ready;
  assign CSR_Handler_2672_clk = clk;
  assign CSR_Handler_2672_reset = reset;
  assign CSR_Handler_2672_io_in_decode_csr_address = Decode_890_io_out_csr_address;
  assign CSR_Handler_2672_io_in_mem_csr_address = E_M_Register_1551_io_out_csr_address;
  assign CSR_Handler_2672_io_in_mem_is_csr = E_M_Register_1551_io_out_is_csr;
  assign CSR_Handler_2672_io_in_mem_csr_result = E_M_Register_1551_io_out_csr_result;

  assign io_IBUS_in_data_ready = Fetch_248_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = Fetch_248_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = Fetch_248_io_IBUS_out_address_valid;
  assign io_DBUS_out_miss = Memory_1826_io_DBUS_out_miss;
  assign io_DBUS_out_rw = Memory_1826_io_DBUS_out_rw;
  assign io_DBUS_in_data_ready = Memory_1826_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Memory_1826_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Memory_1826_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Memory_1826_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Memory_1826_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Memory_1826_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Memory_1826_io_DBUS_out_control_valid;
  assign io_INTERRUPT_in_interrupt_id_ready = Interrupt_Handler_2309_io_INTERRUPT_in_interrupt_id_ready;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = JTAG_2572_io_JTAG_JTAG_TAP_in_mode_select_ready;
  assign io_jtag_JTAG_TAP_in_clock_ready = JTAG_2572_io_JTAG_JTAG_TAP_in_clock_ready;
  assign io_jtag_JTAG_TAP_in_reset_ready = JTAG_2572_io_JTAG_JTAG_TAP_in_reset_ready;
  assign io_jtag_in_data_ready = JTAG_2572_io_JTAG_in_data_ready;
  assign io_jtag_out_data_data = JTAG_2572_io_JTAG_out_data_data;
  assign io_jtag_out_data_valid = JTAG_2572_io_JTAG_out_data_valid;
  assign io_out_fwd_stall = Forwarding_2232_io_out_fwd_stall;
  assign io_out_branch_stall = op_orl_2685;

endmodule
