module ICACHE(
  input wire clk,
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
  wire[8191:0] lit181 = 8192'h0;
  reg[8191:0] mem132 [0:31];
  reg[31:0] mem133 [0:31];
  wire[31:0] shr136, andb142, marport150, sel171;
  wire[4:0] proxy139;
  wire[12:0] shl148;
  wire ne153, orl156, notl168;
  wire[8191:0] marport160, shr163, pad173, shl177, orb179, sel183;

  assign marport160 = mem132[proxy139];
  always @ (posedge clk) begin
    if (orl156) begin
      mem132[proxy139] <= sel183;
    end
  end
  assign marport150 = mem133[proxy139];
  always @ (posedge clk) begin
    if (ne153) begin
      mem133[proxy139] <= andb142;
    end
  end
  assign shr136 = io_in_address >> 32'ha;
  assign proxy139 = shr136[4:0];
  assign andb142 = io_in_address & 32'hffff8000;
  assign shl148 = io_in_address[12:0] << 32'h3;
  assign ne153 = andb142 != marport150;
  assign orl156 = ne153 || io_IBUS_in_data_valid;
  assign shr163 = marport160 >> shl148;
  assign notl168 = !orl156;
  assign sel171 = notl168 ? shr163[31:0] : 32'h0;
  assign pad173 = {{8160{1'b0}}, io_IBUS_in_data_data};
  assign shl177 = marport160 << 32'h20;
  assign orb179 = shl177 | pad173;
  assign sel183 = ne153 ? lit181 : orb179;

  assign io_IBUS_in_data_ready = 1'h1;
  assign io_IBUS_out_address_data = io_in_address;
  assign io_IBUS_out_address_valid = ne153;
  assign io_out_instruction = sel171;
  assign io_out_delay = orl156;

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
  wire ICACHE191_clk, ICACHE191_io_IBUS_in_data_valid, ICACHE191_io_IBUS_in_data_ready, ICACHE191_io_IBUS_out_address_valid, ICACHE191_io_IBUS_out_address_ready, ICACHE191_io_out_delay, notl296, andl299, eq306, eq310, orl312, orl314, orl316, orl318, orl320, orl323, notl329, eq333, andl335, eq344, andl346;
  wire[31:0] ICACHE191_io_IBUS_in_data_data, ICACHE191_io_IBUS_out_address_data, ICACHE191_io_in_address, ICACHE191_io_out_instruction, sel289, sel291, sel293, sel301, sel326, sel337, sel348, add377, add380, add383;
  reg reg225, reg232, reg276;
  reg[31:0] reg239, reg252, reg258, reg264, sel287;
  reg[4:0] reg246;
  wire[4:0] sel357, sel364, sel367, sel370, sel373;

  assign ICACHE191_clk = clk;
  ICACHE ICACHE191(.clk(ICACHE191_clk), .io_IBUS_in_data_data(ICACHE191_io_IBUS_in_data_data), .io_IBUS_in_data_valid(ICACHE191_io_IBUS_in_data_valid), .io_IBUS_out_address_ready(ICACHE191_io_IBUS_out_address_ready), .io_in_address(ICACHE191_io_in_address), .io_IBUS_in_data_ready(ICACHE191_io_IBUS_in_data_ready), .io_IBUS_out_address_data(ICACHE191_io_IBUS_out_address_data), .io_IBUS_out_address_valid(ICACHE191_io_IBUS_out_address_valid), .io_out_instruction(ICACHE191_io_out_instruction), .io_out_delay(ICACHE191_io_out_delay));
  assign ICACHE191_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign ICACHE191_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign ICACHE191_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign ICACHE191_io_in_address = sel348;
  always @ (posedge clk) begin
    if (reset)
      reg225 <= 1'h0;
    else
      reg225 <= orl320;
  end
  always @ (posedge clk) begin
    if (reset)
      reg232 <= 1'h0;
    else
      reg232 <= orl323;
  end
  always @ (posedge clk) begin
    if (reset)
      reg239 <= 32'h0;
    else
      reg239 <= sel348;
  end
  always @ (posedge clk) begin
    if (reset)
      reg246 <= 5'h0;
    else
      reg246 <= sel373;
  end
  always @ (posedge clk) begin
    if (reset)
      reg252 <= 32'h0;
    else
      reg252 <= add377;
  end
  always @ (posedge clk) begin
    if (reset)
      reg258 <= 32'h0;
    else
      reg258 <= add380;
  end
  always @ (posedge clk) begin
    if (reset)
      reg264 <= 32'h0;
    else
      reg264 <= add383;
  end
  always @ (posedge clk) begin
    if (reset)
      reg276 <= 1'h0;
    else
      reg276 <= io_in_debug;
  end
  always @(*) begin
    case (reg246)
      5'h00: sel287 = reg252;
      5'h01: sel287 = reg258;
      5'h02: sel287 = reg264;
      5'h03: sel287 = reg252;
      5'h04: sel287 = reg239;
      default: sel287 = 32'h0;
    endcase
  end
  assign sel289 = reg225 ? reg239 : sel287;
  assign sel291 = reg276 ? reg239 : reg252;
  assign sel293 = io_in_debug ? sel291 : sel289;
  assign notl296 = !io_in_freeze;
  assign andl299 = reg232 && notl296;
  assign sel301 = andl299 ? reg239 : sel293;
  assign eq306 = io_in_fwd_stall == 1'h1;
  assign eq310 = io_in_branch_stall == 1'h1;
  assign orl312 = eq310 || eq306;
  assign orl314 = orl312 || io_in_branch_stall_exe;
  assign orl316 = orl314 || io_in_interrupt;
  assign orl318 = orl316 || ICACHE191_io_out_delay;
  assign orl320 = orl318 || io_in_freeze;
  assign orl323 = ICACHE191_io_out_delay || io_in_freeze;
  assign sel326 = orl320 ? 32'h0 : ICACHE191_io_out_instruction;
  assign notl329 = !reg232;
  assign eq333 = io_in_branch_dir == 1'h1;
  assign andl335 = eq333 && notl329;
  assign sel337 = andl335 ? io_in_branch_dest : sel301;
  assign eq344 = io_in_jal == 1'h1;
  assign andl346 = eq344 && notl329;
  assign sel348 = andl346 ? io_in_jal_dest : sel337;
  assign sel357 = eq333 ? 5'h2 : 5'h0;
  assign sel364 = eq344 ? 5'h1 : sel357;
  assign sel367 = io_in_interrupt ? 5'h3 : sel364;
  assign sel370 = reg276 ? 5'h4 : sel367;
  assign sel373 = io_in_debug ? 5'h3 : sel370;
  assign add377 = sel301 + 32'h4;
  assign add380 = io_in_jal_dest + 32'h4;
  assign add383 = io_in_branch_dest + 32'h4;

  assign io_IBUS_in_data_ready = ICACHE191_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = ICACHE191_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = ICACHE191_io_IBUS_out_address_valid;
  assign io_out_instruction = sel326;
  assign io_out_delay = ICACHE191_io_out_delay;
  assign io_out_curr_PC = sel348;

endmodule

module F_D_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_branch_stall,
  input wire io_in_branch_stall_exe,
  input wire io_in_fwd_stall,
  input wire io_in_freeze,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC
);
  reg[31:0] reg471, reg480;
  wire notl500, eq505, andl507;
  wire[31:0] sel509, sel510;

  always @ (posedge clk) begin
    if (reset)
      reg471 <= 32'h0;
    else
      reg471 <= sel510;
  end
  always @ (posedge clk) begin
    if (reset)
      reg480 <= 32'h0;
    else
      reg480 <= sel509;
  end
  assign notl500 = !io_in_freeze;
  assign eq505 = io_in_fwd_stall == 1'h0;
  assign andl507 = eq505 && notl500;
  assign sel509 = andl507 ? io_in_curr_PC : reg480;
  assign sel510 = andl507 ? io_in_instruction : reg471;

  assign io_out_instruction = reg471;
  assign io_out_curr_PC = reg480;

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
  reg[31:0] mem621 [0:31];
  wire ne631, andl634, eq644, eq652;
  wire[31:0] marport639, sel646, marport648, sel654;

  assign marport639 = mem621[io_in_src1];
  assign marport648 = mem621[io_in_src2];
  always @ (posedge clk) begin
    if (andl634) begin
      mem621[io_in_rd] <= io_in_data;
    end
  end
  assign ne631 = io_in_rd != 5'h0;
  assign andl634 = io_in_write_register && ne631;
  assign eq644 = io_in_src1 == 5'h0;
  assign sel646 = eq644 ? 32'h0 : marport639;
  assign eq652 = io_in_src2 == 5'h0;
  assign sel654 = eq652 ? 32'h0 : marport648;

  assign io_out_src1_data = sel646;
  assign io_out_src2_data = sel654;

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
  wire RegisterFile658_clk, RegisterFile658_io_in_write_register, ne721, sel723, eq775, eq780, eq785, orl787, eq792, eq797, eq802, eq807, eq812, eq817, ne822, eq827, andl829, eq833, andl836, eq840, andl846, eq850, eq858, orl869, orl871, orl873, orl875, orl886, orl888, orl895, sel897, proxy933, eq950, eq967, lt977, andl980, sel992, ge998, eq1001, andl1006, andl1008, eq1017, eq1022, orl1024, eq1037, eq1066, eq1139, eq1176, eq1184, eq1192, orl1198, lt1216;
  wire[4:0] RegisterFile658_io_in_rd, RegisterFile658_io_in_src1, RegisterFile658_io_in_src2, proxy733, proxy740, proxy747;
  wire[31:0] RegisterFile658_io_in_data, RegisterFile658_io_out_src1_data, RegisterFile658_io_out_src2_data, shr730, shr737, shr744, shr751, shr758, add770, sel852, sel854, sel860, pad862, sel863, shr928, pad942, proxy946, sel952, pad958, proxy962, sel969, sel990, pad1029, proxy1032, sel1039, pad1058, proxy1061, sel1068, shr1077, sel1103;
  wire[2:0] proxy754, sel901, sel904;
  wire[6:0] proxy761;
  wire[11:0] proxy767, proxy956, sel1010, pad1026, sel1027, proxy1042, proxy1088;
  wire[1:0] sel877, sel881, sel890;
  wire[19:0] proxy907;
  reg[19:0] sel916;
  wire[20:0] proxy936;
  reg[31:0] sel991, sel1107;
  reg sel993, sel1129;
  reg[11:0] sel1108;
  reg[2:0] sel1127, sel1128;
  wire[3:0] sel1141, sel1144, sel1161, sel1178, sel1186, sel1194, sel1200, sel1202, sel1206, sel1210, sel1218, sel1220;
  reg[3:0] sel1169;

  assign RegisterFile658_clk = clk;
  RegisterFile RegisterFile658(.clk(RegisterFile658_clk), .io_in_write_register(RegisterFile658_io_in_write_register), .io_in_rd(RegisterFile658_io_in_rd), .io_in_data(RegisterFile658_io_in_data), .io_in_src1(RegisterFile658_io_in_src1), .io_in_src2(RegisterFile658_io_in_src2), .io_out_src1_data(RegisterFile658_io_out_src1_data), .io_out_src2_data(RegisterFile658_io_out_src2_data));
  assign RegisterFile658_io_in_write_register = sel723;
  assign RegisterFile658_io_in_rd = io_in_rd;
  assign RegisterFile658_io_in_data = io_in_write_data;
  assign RegisterFile658_io_in_src1 = proxy740;
  assign RegisterFile658_io_in_src2 = proxy747;
  assign ne721 = io_in_wb != 2'h0;
  assign sel723 = ne721 ? 1'h1 : 1'h0;
  assign shr730 = io_in_instruction >> 32'h7;
  assign proxy733 = shr730[4:0];
  assign shr737 = io_in_instruction >> 32'hf;
  assign proxy740 = shr737[4:0];
  assign shr744 = io_in_instruction >> 32'h14;
  assign proxy747 = shr744[4:0];
  assign shr751 = io_in_instruction >> 32'hc;
  assign proxy754 = shr751[2:0];
  assign shr758 = io_in_instruction >> 32'h19;
  assign proxy761 = shr758[6:0];
  assign proxy767 = shr744[11:0];
  assign add770 = io_in_curr_PC + 32'h4;
  assign eq775 = io_in_instruction[6:0] == 7'h33;
  assign eq780 = io_in_instruction[6:0] == 7'h3;
  assign eq785 = io_in_instruction[6:0] == 7'h13;
  assign orl787 = eq785 || eq780;
  assign eq792 = io_in_instruction[6:0] == 7'h23;
  assign eq797 = io_in_instruction[6:0] == 7'h63;
  assign eq802 = io_in_instruction[6:0] == 7'h6f;
  assign eq807 = io_in_instruction[6:0] == 7'h67;
  assign eq812 = io_in_instruction[6:0] == 7'h37;
  assign eq817 = io_in_instruction[6:0] == 7'h17;
  assign ne822 = proxy754 != 3'h0;
  assign eq827 = io_in_instruction[6:0] == 7'h73;
  assign andl829 = eq827 && ne822;
  assign eq833 = shr751[2] == 1'h1;
  assign andl836 = andl829 && eq833;
  assign eq840 = proxy754 == 3'h0;
  assign andl846 = eq827 && eq840;
  assign eq850 = io_in_src1_fwd == 1'h1;
  assign sel852 = eq850 ? io_in_src1_fwd_data : RegisterFile658_io_out_src1_data;
  assign sel854 = eq802 ? io_in_curr_PC : sel852;
  assign eq858 = io_in_src2_fwd == 1'h1;
  assign sel860 = eq858 ? io_in_src2_fwd_data : RegisterFile658_io_out_src2_data;
  assign pad862 = {{27{1'b0}}, proxy740};
  assign sel863 = andl836 ? pad862 : sel854;
  assign orl869 = orl787 || eq775;
  assign orl871 = orl869 || eq812;
  assign orl873 = orl871 || eq817;
  assign orl875 = orl873 || andl829;
  assign sel877 = orl875 ? 2'h1 : 2'h0;
  assign sel881 = eq780 ? 2'h2 : sel877;
  assign orl886 = eq802 || eq807;
  assign orl888 = orl886 || andl846;
  assign sel890 = orl888 ? 2'h3 : sel881;
  assign orl895 = orl787 || eq792;
  assign sel897 = orl895 ? 1'h1 : 1'h0;
  assign sel901 = eq780 ? proxy754 : 3'h7;
  assign sel904 = eq792 ? proxy754 : 3'h7;
  assign proxy907 = {proxy761, proxy747, proxy740, proxy754};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h37: sel916 = proxy907;
      7'h17: sel916 = proxy907;
      default: sel916 = 20'h7b;
    endcase
  end
  assign shr928 = io_in_instruction >> 32'h15;
  assign proxy933 = io_in_instruction[31];
  assign proxy936 = {proxy933, shr751[7:0], io_in_instruction[20], shr928[9:0], 1'h0};
  assign pad942 = {{11{1'b0}}, proxy936};
  assign proxy946 = {11'h7ff, proxy936};
  assign eq950 = proxy933 == 1'h1;
  assign sel952 = eq950 ? proxy946 : pad942;
  assign proxy956 = {proxy761, proxy747};
  assign pad958 = {{20{1'b0}}, proxy956};
  assign proxy962 = {20'hfffff, proxy956};
  assign eq967 = shr758[6] == 1'h1;
  assign sel969 = eq967 ? proxy962 : pad958;
  assign lt977 = proxy767 < 12'h2;
  assign andl980 = eq840 && lt977;
  assign sel990 = andl980 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel991 = sel952;
      7'h67: sel991 = sel969;
      7'h73: sel991 = sel990;
      default: sel991 = 32'h7b;
    endcase
  end
  assign sel992 = andl980 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel993 = 1'h1;
      7'h67: sel993 = 1'h1;
      7'h73: sel993 = sel992;
      default: sel993 = 1'h0;
    endcase
  end
  assign ge998 = proxy767 >= 12'h2;
  assign eq1001 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign andl1006 = ne822 && ge998;
  assign andl1008 = andl1006 && eq1001;
  assign sel1010 = andl1008 ? proxy767 : 12'h7b;
  assign eq1017 = proxy754 == 3'h5;
  assign eq1022 = proxy754 == 3'h1;
  assign orl1024 = eq1022 || eq1017;
  assign pad1026 = {{7{1'b0}}, proxy747};
  assign sel1027 = orl1024 ? pad1026 : proxy767;
  assign pad1029 = {{20{1'b0}}, sel1108};
  assign proxy1032 = {20'hfffff, sel1108};
  assign eq1037 = sel1108[11] == 1'h1;
  assign sel1039 = eq1037 ? proxy1032 : pad1029;
  assign proxy1042 = {proxy761, proxy733};
  assign pad1058 = {{20{1'b0}}, proxy767};
  assign proxy1061 = {20'hfffff, proxy767};
  assign eq1066 = shr744[11] == 1'h1;
  assign sel1068 = eq1066 ? proxy1061 : pad1058;
  assign shr1077 = io_in_instruction >> 32'h8;
  assign proxy1088 = {proxy933, io_in_instruction[7], shr758[5:0], shr1077[3:0]};
  assign sel1103 = eq950 ? proxy1032 : pad1029;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel1107 = sel1039;
      7'h23: sel1107 = sel1039;
      7'h03: sel1107 = sel1068;
      7'h63: sel1107 = sel1103;
      default: sel1107 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel1108 = sel1027;
      7'h23: sel1108 = proxy1042;
      7'h03: sel1108 = 12'h0;
      7'h63: sel1108 = proxy1088;
      default: sel1108 = 12'h0;
    endcase
  end
  always @(*) begin
    case (proxy754)
      3'h0: sel1127 = 3'h1;
      3'h1: sel1127 = 3'h2;
      3'h4: sel1127 = 3'h3;
      3'h5: sel1127 = 3'h4;
      3'h6: sel1127 = 3'h5;
      3'h7: sel1127 = 3'h6;
      default: sel1127 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel1128 = sel1127;
      7'h6f: sel1128 = 3'h0;
      7'h67: sel1128 = 3'h0;
      default: sel1128 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel1129 = 1'h1;
      7'h6f: sel1129 = 1'h1;
      7'h67: sel1129 = 1'h1;
      default: sel1129 = 1'h0;
    endcase
  end
  assign eq1139 = proxy761 == 7'h0;
  assign sel1141 = eq1139 ? 4'h0 : 4'h1;
  assign sel1144 = eq785 ? 4'h0 : sel1141;
  assign sel1161 = eq1139 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy754)
      3'h0: sel1169 = sel1144;
      3'h1: sel1169 = 4'h2;
      3'h2: sel1169 = 4'h3;
      3'h3: sel1169 = 4'h4;
      3'h4: sel1169 = 4'h5;
      3'h5: sel1169 = sel1161;
      3'h6: sel1169 = 4'h8;
      3'h7: sel1169 = 4'h9;
      default: sel1169 = 4'hf;
    endcase
  end
  assign eq1176 = shr751[1:0] == 2'h3;
  assign sel1178 = eq1176 ? 4'hf : 4'hf;
  assign eq1184 = shr751[1:0] == 2'h2;
  assign sel1186 = eq1184 ? 4'he : sel1178;
  assign eq1192 = shr751[1:0] == 2'h1;
  assign sel1194 = eq1192 ? 4'hd : sel1186;
  assign orl1198 = eq792 || eq780;
  assign sel1200 = orl1198 ? 4'h0 : sel1169;
  assign sel1202 = andl829 ? sel1194 : sel1200;
  assign sel1206 = eq817 ? 4'hc : sel1202;
  assign sel1210 = eq812 ? 4'hb : sel1206;
  assign lt1216 = sel1128 < 3'h5;
  assign sel1218 = lt1216 ? 4'h1 : 4'ha;
  assign sel1220 = eq797 ? sel1218 : sel1210;

  assign io_out_csr_address = sel1010;
  assign io_out_is_csr = andl829;
  assign io_out_csr_mask = sel863;
  assign io_out_rd = proxy733;
  assign io_out_rs1 = proxy740;
  assign io_out_rd1 = sel854;
  assign io_out_rs2 = proxy747;
  assign io_out_rd2 = sel860;
  assign io_out_wb = sel890;
  assign io_out_alu_op = sel1220;
  assign io_out_rs2_src = sel897;
  assign io_out_itype_immed = sel1107;
  assign io_out_mem_read = sel901;
  assign io_out_mem_write = sel904;
  assign io_out_branch_type = sel1128;
  assign io_out_branch_stall = sel1129;
  assign io_out_jal = sel993;
  assign io_out_jal_offset = sel991;
  assign io_out_upper_immed = sel916;
  assign io_out_PC_next = add770;

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
  input wire io_in_freeze,
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
  reg[4:0] reg1408, reg1417, reg1430;
  reg[31:0] reg1424, reg1436, reg1456, reg1469, reg1515, reg1521, reg1533;
  reg[3:0] reg1443;
  reg[1:0] reg1450;
  reg reg1463, reg1509, reg1527;
  reg[2:0] reg1476, reg1482, reg1489;
  reg[19:0] reg1496;
  reg[11:0] reg1503;
  wire eq1538, eq1542, orl1544, notl1547, sel1575, sel1597, sel1603, sel1613, sel1626, sel1630;
  wire[4:0] sel1550, sel1553, sel1559, sel1617, sel1618, sel1621;
  wire[31:0] sel1556, sel1562, sel1572, sel1579, sel1600, sel1606, sel1609, sel1611, sel1612, sel1614, sel1615, sel1620, sel1622, sel1623;
  wire[3:0] sel1566, sel1629;
  wire[1:0] sel1569, sel1616;
  wire[2:0] sel1582, sel1585, sel1588, sel1619, sel1624, sel1625;
  wire[19:0] sel1591, sel1627;
  wire[11:0] sel1594, sel1628;

  always @ (posedge clk) begin
    if (reset)
      reg1408 <= 5'h0;
    else
      reg1408 <= sel1617;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1417 <= 5'h0;
    else
      reg1417 <= sel1621;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1424 <= 32'h0;
    else
      reg1424 <= sel1620;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1430 <= 5'h0;
    else
      reg1430 <= sel1618;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1436 <= 32'h0;
    else
      reg1436 <= sel1615;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1443 <= 4'h0;
    else
      reg1443 <= sel1629;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1450 <= 2'h0;
    else
      reg1450 <= sel1616;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1456 <= 32'h0;
    else
      reg1456 <= sel1622;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1463 <= 1'h0;
    else
      reg1463 <= sel1626;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1469 <= 32'h0;
    else
      reg1469 <= sel1623;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1476 <= 3'h7;
    else
      reg1476 <= sel1624;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1482 <= 3'h7;
    else
      reg1482 <= sel1619;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1489 <= 3'h0;
    else
      reg1489 <= sel1625;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1496 <= 20'h0;
    else
      reg1496 <= sel1627;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1503 <= 12'h0;
    else
      reg1503 <= sel1628;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1509 <= 1'h0;
    else
      reg1509 <= sel1630;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1515 <= 32'h0;
    else
      reg1515 <= sel1614;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1521 <= 32'h0;
    else
      reg1521 <= sel1611;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1527 <= 1'h0;
    else
      reg1527 <= sel1613;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1533 <= 32'h0;
    else
      reg1533 <= sel1612;
  end
  assign eq1538 = io_in_branch_stall == 1'h1;
  assign eq1542 = io_in_fwd_stall == 1'h1;
  assign orl1544 = eq1542 || eq1538;
  assign notl1547 = !io_in_freeze;
  assign sel1550 = orl1544 ? 5'h0 : io_in_rd;
  assign sel1553 = orl1544 ? 5'h0 : io_in_rs1;
  assign sel1556 = orl1544 ? 32'h0 : io_in_rd1;
  assign sel1559 = orl1544 ? 5'h0 : io_in_rs2;
  assign sel1562 = orl1544 ? 32'h0 : io_in_rd2;
  assign sel1566 = orl1544 ? 4'hf : io_in_alu_op;
  assign sel1569 = orl1544 ? 2'h0 : io_in_wb;
  assign sel1572 = orl1544 ? 32'h0 : io_in_PC_next;
  assign sel1575 = orl1544 ? 1'h0 : io_in_rs2_src;
  assign sel1579 = orl1544 ? 32'h7b : io_in_itype_immed;
  assign sel1582 = orl1544 ? 3'h7 : io_in_mem_read;
  assign sel1585 = orl1544 ? 3'h7 : io_in_mem_write;
  assign sel1588 = orl1544 ? 3'h0 : io_in_branch_type;
  assign sel1591 = orl1544 ? 20'h0 : io_in_upper_immed;
  assign sel1594 = orl1544 ? 12'h0 : io_in_csr_address;
  assign sel1597 = orl1544 ? 1'h0 : io_in_is_csr;
  assign sel1600 = orl1544 ? 32'h0 : io_in_csr_mask;
  assign sel1603 = orl1544 ? 1'h0 : io_in_jal;
  assign sel1606 = orl1544 ? 32'h0 : io_in_jal_offset;
  assign sel1609 = orl1544 ? 32'h0 : io_in_curr_PC;
  assign sel1611 = notl1547 ? sel1609 : reg1521;
  assign sel1612 = notl1547 ? sel1606 : reg1533;
  assign sel1613 = notl1547 ? sel1603 : reg1527;
  assign sel1614 = notl1547 ? sel1600 : reg1515;
  assign sel1615 = notl1547 ? sel1562 : reg1436;
  assign sel1616 = notl1547 ? sel1569 : reg1450;
  assign sel1617 = notl1547 ? sel1550 : reg1408;
  assign sel1618 = notl1547 ? sel1559 : reg1430;
  assign sel1619 = notl1547 ? sel1585 : reg1482;
  assign sel1620 = notl1547 ? sel1556 : reg1424;
  assign sel1621 = notl1547 ? sel1553 : reg1417;
  assign sel1622 = notl1547 ? sel1572 : reg1456;
  assign sel1623 = notl1547 ? sel1579 : reg1469;
  assign sel1624 = notl1547 ? sel1582 : reg1476;
  assign sel1625 = notl1547 ? sel1588 : reg1489;
  assign sel1626 = notl1547 ? sel1575 : reg1463;
  assign sel1627 = notl1547 ? sel1591 : reg1496;
  assign sel1628 = notl1547 ? sel1594 : reg1503;
  assign sel1629 = notl1547 ? sel1566 : reg1443;
  assign sel1630 = notl1547 ? sel1597 : reg1509;

  assign io_out_csr_address = reg1503;
  assign io_out_is_csr = reg1509;
  assign io_out_csr_mask = reg1515;
  assign io_out_rd = reg1408;
  assign io_out_rs1 = reg1417;
  assign io_out_rd1 = reg1424;
  assign io_out_rs2 = reg1430;
  assign io_out_rd2 = reg1436;
  assign io_out_alu_op = reg1443;
  assign io_out_wb = reg1450;
  assign io_out_rs2_src = reg1463;
  assign io_out_itype_immed = reg1469;
  assign io_out_mem_read = reg1476;
  assign io_out_mem_write = reg1482;
  assign io_out_branch_type = reg1489;
  assign io_out_upper_immed = reg1496;
  assign io_out_curr_PC = reg1521;
  assign io_out_jal = reg1527;
  assign io_out_jal_offset = reg1533;
  assign io_out_PC_next = reg1456;

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
  wire eq1838, lt1869, lt1878, ge1908, ne1942, orl1944, sel1946;
  wire[31:0] sel1841, proxy1846, add1849, add1852, sub1857, shl1861, sel1871, sel1880, xorb1885, shr1889, shr1894, orb1899, andb1904, add1917, orb1923, sub1927, andb1930, sel1935;
  reg[31:0] sel1934, sel1936;

  assign eq1838 = io_in_rs2_src == 1'h1;
  assign sel1841 = eq1838 ? io_in_itype_immed : io_in_rd2;
  assign proxy1846 = {io_in_upper_immed, 12'h0};
  assign add1849 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1852 = $signed(io_in_rd1) + $signed(sel1841);
  assign sub1857 = $signed(io_in_rd1) - $signed(sel1841);
  assign shl1861 = io_in_rd1 << sel1841;
  assign lt1869 = $signed(io_in_rd1) < $signed(sel1841);
  assign sel1871 = lt1869 ? 32'h1 : 32'h0;
  assign lt1878 = io_in_rd1 < sel1841;
  assign sel1880 = lt1878 ? 32'h1 : 32'h0;
  assign xorb1885 = io_in_rd1 ^ sel1841;
  assign shr1889 = io_in_rd1 >> sel1841;
  assign shr1894 = $signed(io_in_rd1) >> sel1841;
  assign orb1899 = io_in_rd1 | sel1841;
  assign andb1904 = sel1841 & io_in_rd1;
  assign ge1908 = io_in_rd1 >= sel1841;
  assign add1917 = $signed(io_in_curr_PC) + $signed(proxy1846);
  assign orb1923 = io_in_csr_data | io_in_csr_mask;
  assign sub1927 = 32'hffffffff - io_in_csr_mask;
  assign andb1930 = io_in_csr_data & sub1927;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1934 = 32'h7b;
      4'h1: sel1934 = 32'h7b;
      4'h2: sel1934 = 32'h7b;
      4'h3: sel1934 = 32'h7b;
      4'h4: sel1934 = 32'h7b;
      4'h5: sel1934 = 32'h7b;
      4'h6: sel1934 = 32'h7b;
      4'h7: sel1934 = 32'h7b;
      4'h8: sel1934 = 32'h7b;
      4'h9: sel1934 = 32'h7b;
      4'ha: sel1934 = 32'h7b;
      4'hb: sel1934 = 32'h7b;
      4'hc: sel1934 = 32'h7b;
      4'hd: sel1934 = io_in_csr_mask;
      4'he: sel1934 = orb1923;
      4'hf: sel1934 = andb1930;
      default: sel1934 = 32'h7b;
    endcase
  end
  assign sel1935 = ge1908 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1936 = add1852;
      4'h1: sel1936 = sub1857;
      4'h2: sel1936 = shl1861;
      4'h3: sel1936 = sel1871;
      4'h4: sel1936 = sel1880;
      4'h5: sel1936 = xorb1885;
      4'h6: sel1936 = shr1889;
      4'h7: sel1936 = shr1894;
      4'h8: sel1936 = orb1899;
      4'h9: sel1936 = andb1904;
      4'ha: sel1936 = sel1935;
      4'hb: sel1936 = proxy1846;
      4'hc: sel1936 = add1917;
      4'hd: sel1936 = io_in_csr_data;
      4'he: sel1936 = io_in_csr_data;
      4'hf: sel1936 = io_in_csr_data;
      default: sel1936 = 32'h0;
    endcase
  end
  assign ne1942 = io_in_branch_type != 3'h0;
  assign orl1944 = ne1942 || io_in_jal;
  assign sel1946 = orl1944 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1934;
  assign io_out_alu_result = sel1936;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1849;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = sel1946;
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
  input wire io_in_jal,
  input wire[31:0] io_in_jal_dest,
  input wire io_in_freeze,
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
  output wire io_out_jal,
  output wire[31:0] io_out_jal_dest,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg2141, reg2163, reg2175, reg2188, reg2221, reg2227, reg2233, reg2251;
  reg[4:0] reg2151, reg2157, reg2169;
  reg[1:0] reg2182;
  reg[2:0] reg2195, reg2201, reg2239;
  reg[11:0] reg2208;
  reg reg2215, reg2245;
  wire notl2254, sel2263, sel2272;
  wire[1:0] sel2256;
  wire[4:0] sel2257, sel2259, sel2261;
  wire[31:0] sel2258, sel2260, sel2262, sel2265, sel2267, sel2268, sel2269, sel2273;
  wire[2:0] sel2264, sel2266, sel2271;
  wire[11:0] sel2270;

  always @ (posedge clk) begin
    if (reset)
      reg2141 <= 32'h0;
    else
      reg2141 <= sel2262;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2151 <= 5'h0;
    else
      reg2151 <= sel2259;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2157 <= 5'h0;
    else
      reg2157 <= sel2261;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2163 <= 32'h0;
    else
      reg2163 <= sel2267;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2169 <= 5'h0;
    else
      reg2169 <= sel2257;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2175 <= 32'h0;
    else
      reg2175 <= sel2268;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2182 <= 2'h0;
    else
      reg2182 <= sel2256;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2188 <= 32'h0;
    else
      reg2188 <= sel2265;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2195 <= 3'h0;
    else
      reg2195 <= sel2266;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2201 <= 3'h0;
    else
      reg2201 <= sel2264;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2208 <= 12'h0;
    else
      reg2208 <= sel2270;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2215 <= 1'h0;
    else
      reg2215 <= sel2272;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2221 <= 32'h0;
    else
      reg2221 <= sel2273;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2227 <= 32'h0;
    else
      reg2227 <= sel2260;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2233 <= 32'h0;
    else
      reg2233 <= sel2269;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2239 <= 3'h0;
    else
      reg2239 <= sel2271;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2245 <= 1'h0;
    else
      reg2245 <= sel2263;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2251 <= 32'h0;
    else
      reg2251 <= sel2258;
  end
  assign notl2254 = !io_in_freeze;
  assign sel2256 = notl2254 ? io_in_wb : reg2182;
  assign sel2257 = notl2254 ? io_in_rs2 : reg2169;
  assign sel2258 = notl2254 ? io_in_jal_dest : reg2251;
  assign sel2259 = notl2254 ? io_in_rd : reg2151;
  assign sel2260 = notl2254 ? io_in_curr_PC : reg2227;
  assign sel2261 = notl2254 ? io_in_rs1 : reg2157;
  assign sel2262 = notl2254 ? io_in_alu_result : reg2141;
  assign sel2263 = notl2254 ? io_in_jal : reg2245;
  assign sel2264 = notl2254 ? io_in_mem_write : reg2201;
  assign sel2265 = notl2254 ? io_in_PC_next : reg2188;
  assign sel2266 = notl2254 ? io_in_mem_read : reg2195;
  assign sel2267 = notl2254 ? io_in_rd1 : reg2163;
  assign sel2268 = notl2254 ? io_in_rd2 : reg2175;
  assign sel2269 = notl2254 ? io_in_branch_offset : reg2233;
  assign sel2270 = notl2254 ? io_in_csr_address : reg2208;
  assign sel2271 = notl2254 ? io_in_branch_type : reg2239;
  assign sel2272 = notl2254 ? io_in_is_csr : reg2215;
  assign sel2273 = notl2254 ? io_in_csr_result : reg2221;

  assign io_out_csr_address = reg2208;
  assign io_out_is_csr = reg2215;
  assign io_out_csr_result = reg2221;
  assign io_out_alu_result = reg2141;
  assign io_out_rd = reg2151;
  assign io_out_wb = reg2182;
  assign io_out_rs1 = reg2157;
  assign io_out_rd1 = reg2163;
  assign io_out_rd2 = reg2175;
  assign io_out_rs2 = reg2169;
  assign io_out_mem_read = reg2195;
  assign io_out_mem_write = reg2201;
  assign io_out_curr_PC = reg2227;
  assign io_out_branch_offset = reg2233;
  assign io_out_branch_type = reg2239;
  assign io_out_jal = reg2245;
  assign io_out_jal_dest = reg2251;
  assign io_out_PC_next = reg2188;

endmodule

module DCACHE(
  input wire clk,
  input wire reset,
  output wire io_DBUS_out_miss,
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[1:0] io_DBUS_out_control_data,
  output wire io_DBUS_out_control_valid,
  input wire io_DBUS_out_control_ready,
  input wire[1:0] io_in_control,
  input wire[31:0] io_in_data,
  input wire io_in_data_valid,
  input wire io_in_data_ready,
  input wire[31:0] io_in_address,
  input wire io_in_address_valid,
  output wire[31:0] io_out_data,
  output wire io_out_delay
);
  wire[8191:0] lit2619 = 8192'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
  wire[8191:0] lit2636 = 8192'h0;
  reg reg2549, reg2590;
  reg[8191:0] mem2556 [0:31];
  reg[31:0] mem2557 [0:31];
  wire[31:0] shr2560, andb2566, marport2574, sel2609;
  wire[4:0] proxy2563;
  wire[12:0] shl2572;
  wire notl2577, ne2580, andl2582, andl2584, orl2593, orl2596, notl2606, eq2644, eq2649, orl2652, orl2654;
  wire[8191:0] marport2598, shr2601, pad2611, shl2615, orb2617, shl2621, pad2623, shl2624, xorb2627, andb2629, xorb2632, sel2634, sel2638;

  always @ (posedge clk) begin
    if (reset)
      reg2549 <= 1'h1;
    else
      reg2549 <= 1'h0;
  end
  assign marport2598 = mem2556[proxy2563];
  always @ (posedge clk) begin
    if (orl2654) begin
      mem2556[proxy2563] <= sel2638;
    end
  end
  assign marport2574 = mem2557[proxy2563];
  always @ (posedge clk) begin
    if (andl2584) begin
      mem2557[proxy2563] <= andb2566;
    end
  end
  assign shr2560 = io_in_address >> 32'ha;
  assign proxy2563 = shr2560[4:0];
  assign andb2566 = io_in_address & 32'hffff8000;
  assign shl2572 = io_in_address[12:0] << 32'h3;
  assign notl2577 = !reg2549;
  assign ne2580 = andb2566 != marport2574;
  assign andl2582 = ne2580 && notl2577;
  assign andl2584 = andl2582 && io_in_address_valid;
  always @ (posedge clk) begin
    if (reset)
      reg2590 <= 1'h0;
    else
      reg2590 <= io_DBUS_in_data_valid;
  end
  assign orl2593 = andl2584 || io_DBUS_in_data_valid;
  assign orl2596 = orl2593 || reg2590;
  assign shr2601 = marport2598 >> shl2572;
  assign notl2606 = !orl2593;
  assign sel2609 = notl2606 ? shr2601[31:0] : 32'h0;
  assign pad2611 = {{8160{1'b0}}, io_DBUS_in_data_data};
  assign shl2615 = marport2598 << 32'h20;
  assign orb2617 = shl2615 | pad2611;
  assign shl2621 = lit2619 << shl2572;
  assign pad2623 = {{8160{1'b0}}, io_in_data};
  assign shl2624 = pad2623 << shl2572;
  assign xorb2627 = marport2598 ^ shl2624;
  assign andb2629 = xorb2627 & shl2621;
  assign xorb2632 = marport2598 ^ andb2629;
  assign sel2634 = orl2593 ? orb2617 : xorb2632;
  assign sel2638 = andl2584 ? lit2636 : sel2634;
  assign eq2644 = io_in_control == 2'h2;
  assign eq2649 = io_in_control == 2'h3;
  assign orl2652 = orl2593 || eq2649;
  assign orl2654 = orl2652 || eq2644;

  assign io_DBUS_out_miss = andl2584;
  assign io_DBUS_in_data_ready = io_in_data_ready;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = io_in_data_valid;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = io_in_address_valid;
  assign io_DBUS_out_control_data = io_in_control;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2609;
  assign io_out_delay = orl2596;

endmodule

module Cache(
  input wire clk,
  input wire reset,
  output wire io_DBUS_out_miss,
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[1:0] io_DBUS_out_control_data,
  output wire io_DBUS_out_control_valid,
  input wire io_DBUS_out_control_ready,
  input wire[31:0] io_in_address,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[31:0] io_in_data,
  output wire io_out_delay,
  output wire[31:0] io_out_data
);
  wire DCACHE2659_clk, DCACHE2659_reset, DCACHE2659_io_DBUS_out_miss, DCACHE2659_io_DBUS_in_data_valid, DCACHE2659_io_DBUS_in_data_ready, DCACHE2659_io_DBUS_out_data_valid, DCACHE2659_io_DBUS_out_data_ready, DCACHE2659_io_DBUS_out_address_valid, DCACHE2659_io_DBUS_out_address_ready, DCACHE2659_io_DBUS_out_control_valid, DCACHE2659_io_DBUS_out_control_ready, DCACHE2659_io_in_data_valid, DCACHE2659_io_in_data_ready, DCACHE2659_io_in_address_valid, DCACHE2659_io_out_delay, lt2728, lt2731, orl2733, eq2740, eq2743, eq2746, andl2748, notl2765, notl2768, andl2770, orl2773, eq2792, eq2810;
  wire[31:0] DCACHE2659_io_DBUS_in_data_data, DCACHE2659_io_DBUS_out_data_data, DCACHE2659_io_DBUS_out_address_data, DCACHE2659_io_in_data, DCACHE2659_io_in_address, DCACHE2659_io_out_data, pad2784, proxy2786, sel2794, pad2803, proxy2805, sel2812;
  wire[1:0] DCACHE2659_io_DBUS_out_control_data, DCACHE2659_io_in_control, sel2754, sel2758, sel2762;
  wire[7:0] proxy2783;
  wire[15:0] proxy2802;
  reg[31:0] sel2826;

  assign DCACHE2659_clk = clk;
  assign DCACHE2659_reset = reset;
  DCACHE DCACHE2659(.clk(DCACHE2659_clk), .reset(DCACHE2659_reset), .io_DBUS_in_data_data(DCACHE2659_io_DBUS_in_data_data), .io_DBUS_in_data_valid(DCACHE2659_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(DCACHE2659_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(DCACHE2659_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(DCACHE2659_io_DBUS_out_control_ready), .io_in_control(DCACHE2659_io_in_control), .io_in_data(DCACHE2659_io_in_data), .io_in_data_valid(DCACHE2659_io_in_data_valid), .io_in_data_ready(DCACHE2659_io_in_data_ready), .io_in_address(DCACHE2659_io_in_address), .io_in_address_valid(DCACHE2659_io_in_address_valid), .io_DBUS_out_miss(DCACHE2659_io_DBUS_out_miss), .io_DBUS_in_data_ready(DCACHE2659_io_DBUS_in_data_ready), .io_DBUS_out_data_data(DCACHE2659_io_DBUS_out_data_data), .io_DBUS_out_data_valid(DCACHE2659_io_DBUS_out_data_valid), .io_DBUS_out_address_data(DCACHE2659_io_DBUS_out_address_data), .io_DBUS_out_address_valid(DCACHE2659_io_DBUS_out_address_valid), .io_DBUS_out_control_data(DCACHE2659_io_DBUS_out_control_data), .io_DBUS_out_control_valid(DCACHE2659_io_DBUS_out_control_valid), .io_out_data(DCACHE2659_io_out_data), .io_out_delay(DCACHE2659_io_out_delay));
  assign DCACHE2659_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign DCACHE2659_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign DCACHE2659_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign DCACHE2659_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign DCACHE2659_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign DCACHE2659_io_in_control = sel2762;
  assign DCACHE2659_io_in_data = io_in_data;
  assign DCACHE2659_io_in_data_valid = lt2728;
  assign DCACHE2659_io_in_data_ready = orl2773;
  assign DCACHE2659_io_in_address = io_in_address;
  assign DCACHE2659_io_in_address_valid = orl2733;
  assign lt2728 = io_in_mem_write < 3'h7;
  assign lt2731 = io_in_mem_read < 3'h7;
  assign orl2733 = lt2731 || lt2728;
  assign eq2740 = io_in_mem_write == 3'h2;
  assign eq2743 = io_in_mem_write == 3'h7;
  assign eq2746 = io_in_mem_read == 3'h7;
  assign andl2748 = eq2746 && eq2743;
  assign sel2754 = andl2748 ? 2'h0 : 2'h3;
  assign sel2758 = eq2740 ? 2'h2 : sel2754;
  assign sel2762 = lt2731 ? 2'h1 : sel2758;
  assign notl2765 = !eq2740;
  assign notl2768 = !andl2748;
  assign andl2770 = notl2768 && notl2765;
  assign orl2773 = lt2731 || andl2770;
  assign proxy2783 = DCACHE2659_io_out_data[7:0];
  assign pad2784 = {{24{1'b0}}, proxy2783};
  assign proxy2786 = {24'hffffff, proxy2783};
  assign eq2792 = DCACHE2659_io_out_data[7] == 1'h1;
  assign sel2794 = eq2792 ? proxy2786 : pad2784;
  assign proxy2802 = DCACHE2659_io_out_data[15:0];
  assign pad2803 = {{16{1'b0}}, proxy2802};
  assign proxy2805 = {16'hffff, proxy2802};
  assign eq2810 = DCACHE2659_io_out_data[15] == 1'h1;
  assign sel2812 = eq2810 ? proxy2805 : pad2803;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2826 = sel2794;
      3'h1: sel2826 = sel2812;
      3'h2: sel2826 = DCACHE2659_io_out_data;
      3'h4: sel2826 = pad2784;
      3'h5: sel2826 = pad2803;
      default: sel2826 = 32'h0;
    endcase
  end

  assign io_DBUS_out_miss = DCACHE2659_io_DBUS_out_miss;
  assign io_DBUS_in_data_ready = DCACHE2659_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = DCACHE2659_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = DCACHE2659_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = DCACHE2659_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = DCACHE2659_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = DCACHE2659_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = DCACHE2659_io_DBUS_out_control_valid;
  assign io_out_delay = DCACHE2659_io_out_delay;
  assign io_out_data = sel2826;

endmodule

module Memory(
  input wire clk,
  input wire reset,
  output wire io_DBUS_out_miss,
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[1:0] io_DBUS_out_control_data,
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
  output wire io_out_branch_stall,
  output wire[31:0] io_out_PC_next
);
  wire Cache2832_clk, Cache2832_reset, Cache2832_io_DBUS_out_miss, Cache2832_io_DBUS_in_data_valid, Cache2832_io_DBUS_in_data_ready, Cache2832_io_DBUS_out_data_valid, Cache2832_io_DBUS_out_data_ready, Cache2832_io_DBUS_out_address_valid, Cache2832_io_DBUS_out_address_ready, Cache2832_io_DBUS_out_control_valid, Cache2832_io_DBUS_out_control_ready, Cache2832_io_out_delay, eq2906, sel2908, sel2916, eq2924, sel2926, sel2936, eq2965, sel2967;
  wire[31:0] Cache2832_io_DBUS_in_data_data, Cache2832_io_DBUS_out_data_data, Cache2832_io_DBUS_out_address_data, Cache2832_io_in_address, Cache2832_io_in_data, Cache2832_io_out_data, shl2895, add2897;
  wire[1:0] Cache2832_io_DBUS_out_control_data;
  wire[2:0] Cache2832_io_in_mem_read, Cache2832_io_in_mem_write;
  reg sel2961;

  assign Cache2832_clk = clk;
  assign Cache2832_reset = reset;
  Cache Cache2832(.clk(Cache2832_clk), .reset(Cache2832_reset), .io_DBUS_in_data_data(Cache2832_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Cache2832_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Cache2832_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Cache2832_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Cache2832_io_DBUS_out_control_ready), .io_in_address(Cache2832_io_in_address), .io_in_mem_read(Cache2832_io_in_mem_read), .io_in_mem_write(Cache2832_io_in_mem_write), .io_in_data(Cache2832_io_in_data), .io_DBUS_out_miss(Cache2832_io_DBUS_out_miss), .io_DBUS_in_data_ready(Cache2832_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Cache2832_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Cache2832_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Cache2832_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Cache2832_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Cache2832_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Cache2832_io_DBUS_out_control_valid), .io_out_delay(Cache2832_io_out_delay), .io_out_data(Cache2832_io_out_data));
  assign Cache2832_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Cache2832_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Cache2832_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Cache2832_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Cache2832_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Cache2832_io_in_address = io_in_alu_result;
  assign Cache2832_io_in_mem_read = io_in_mem_read;
  assign Cache2832_io_in_mem_write = io_in_mem_write;
  assign Cache2832_io_in_data = io_in_rd2;
  assign shl2895 = $signed(io_in_branch_offset) << 32'h1;
  assign add2897 = $signed(io_in_curr_PC) + $signed(shl2895);
  assign eq2906 = io_in_alu_result == 32'h0;
  assign sel2908 = eq2906 ? 1'h1 : 1'h0;
  assign sel2916 = eq2906 ? 1'h0 : 1'h1;
  assign eq2924 = io_in_alu_result[31] == 1'h0;
  assign sel2926 = eq2924 ? 1'h0 : 1'h1;
  assign sel2936 = eq2924 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2961 = sel2908;
      3'h2: sel2961 = sel2916;
      3'h3: sel2961 = sel2926;
      3'h4: sel2961 = sel2936;
      3'h5: sel2961 = sel2926;
      3'h6: sel2961 = sel2936;
      3'h0: sel2961 = 1'h0;
      default: sel2961 = 1'h0;
    endcase
  end
  assign eq2965 = io_in_branch_type == 3'h0;
  assign sel2967 = eq2965 ? 1'h0 : 1'h1;

  assign io_DBUS_out_miss = Cache2832_io_DBUS_out_miss;
  assign io_DBUS_in_data_ready = Cache2832_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Cache2832_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Cache2832_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Cache2832_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Cache2832_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Cache2832_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Cache2832_io_DBUS_out_control_valid;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = Cache2832_io_out_data;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2961;
  assign io_out_branch_dest = add2897;
  assign io_out_delay = Cache2832_io_out_delay;
  assign io_out_branch_stall = sel2967;
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
  input wire io_in_freeze,
  input wire io_in_branch_dir,
  input wire[31:0] io_in_branch_dest,
  output wire[31:0] io_out_alu_result,
  output wire[31:0] io_out_mem_result,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb,
  output wire[4:0] io_out_rs1,
  output wire[4:0] io_out_rs2,
  output wire io_out_branch_dir,
  output wire[31:0] io_out_branch_dest,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg3125, reg3134, reg3166, reg3179;
  reg[4:0] reg3141, reg3147, reg3153;
  reg[1:0] reg3160;
  reg reg3173;
  wire notl3182, sel3187;
  wire[31:0] sel3184, sel3185, sel3186, sel3188;
  wire[4:0] sel3189, sel3190, sel3191;
  wire[1:0] sel3192;

  always @ (posedge clk) begin
    if (reset)
      reg3125 <= 32'h0;
    else
      reg3125 <= sel3188;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3134 <= 32'h0;
    else
      reg3134 <= sel3186;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3141 <= 5'h0;
    else
      reg3141 <= sel3189;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3147 <= 5'h0;
    else
      reg3147 <= sel3190;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3153 <= 5'h0;
    else
      reg3153 <= sel3191;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3160 <= 2'h0;
    else
      reg3160 <= sel3192;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3166 <= 32'h0;
    else
      reg3166 <= sel3185;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3173 <= 1'h0;
    else
      reg3173 <= sel3187;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3179 <= 32'h0;
    else
      reg3179 <= sel3184;
  end
  assign notl3182 = !io_in_freeze;
  assign sel3184 = notl3182 ? io_in_branch_dest : reg3179;
  assign sel3185 = notl3182 ? io_in_PC_next : reg3166;
  assign sel3186 = notl3182 ? io_in_mem_result : reg3134;
  assign sel3187 = notl3182 ? io_in_branch_dir : reg3173;
  assign sel3188 = notl3182 ? io_in_alu_result : reg3125;
  assign sel3189 = notl3182 ? io_in_rd : reg3141;
  assign sel3190 = notl3182 ? io_in_rs1 : reg3147;
  assign sel3191 = notl3182 ? io_in_rs2 : reg3153;
  assign sel3192 = notl3182 ? io_in_wb : reg3160;

  assign io_out_alu_result = reg3125;
  assign io_out_mem_result = reg3134;
  assign io_out_rd = reg3141;
  assign io_out_wb = reg3160;
  assign io_out_rs1 = reg3147;
  assign io_out_rs2 = reg3153;
  assign io_out_branch_dir = reg3173;
  assign io_out_branch_dest = reg3179;
  assign io_out_PC_next = reg3166;

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
  wire eq3271, eq3275;
  wire[31:0] sel3277, sel3279;

  assign eq3271 = io_in_wb == 2'h3;
  assign eq3275 = io_in_wb == 2'h1;
  assign sel3277 = eq3275 ? io_in_alu_result : io_in_mem_result;
  assign sel3279 = eq3271 ? io_in_PC_next : sel3277;

  assign io_out_write_data = sel3279;
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
  wire eq3358, eq3361, eq3364, eq3368, eq3371, eq3374, eq3379, eq3383, ne3387, ne3391, eq3393, andl3395, andl3397, notl3400, ne3403, eq3408, andl3410, andl3412, andl3414, notl3417, ne3423, eq3428, andl3430, andl3432, andl3434, andl3436, orl3439, orl3441, ne3447, eq3449, andl3451, andl3453, notl3456, eq3464, andl3466, andl3468, andl3470, notl3473, eq3484, andl3486, andl3488, andl3490, andl3492, orl3495, orl3497, eq3499, andl3501, notl3504, eq3506, andl3508, andl3510, orl3513, orl3519, andl3521, sel3523;
  wire[31:0] sel3527, sel3529, sel3531, sel3533, sel3535, sel3537, sel3539, sel3541, sel3548, sel3554, sel3558, sel3561, sel3563;

  assign eq3358 = io_in_execute_wb == 2'h2;
  assign eq3361 = io_in_memory_wb == 2'h2;
  assign eq3364 = io_in_writeback_wb == 2'h2;
  assign eq3368 = io_in_execute_wb == 2'h3;
  assign eq3371 = io_in_memory_wb == 2'h3;
  assign eq3374 = io_in_writeback_wb == 2'h3;
  assign eq3379 = io_in_execute_is_csr == 1'h1;
  assign eq3383 = io_in_memory_is_csr == 1'h1;
  assign ne3387 = io_in_execute_wb != 2'h0;
  assign ne3391 = io_in_decode_src1 != 5'h0;
  assign eq3393 = io_in_decode_src1 == io_in_execute_dest;
  assign andl3395 = eq3393 && ne3391;
  assign andl3397 = andl3395 && ne3387;
  assign notl3400 = !andl3397;
  assign ne3403 = io_in_memory_wb != 2'h0;
  assign eq3408 = io_in_decode_src1 == io_in_memory_dest;
  assign andl3410 = eq3408 && ne3391;
  assign andl3412 = andl3410 && ne3403;
  assign andl3414 = andl3412 && notl3400;
  assign notl3417 = !andl3414;
  assign ne3423 = io_in_writeback_wb != 2'h0;
  assign eq3428 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl3430 = eq3428 && ne3391;
  assign andl3432 = andl3430 && ne3423;
  assign andl3434 = andl3432 && notl3400;
  assign andl3436 = andl3434 && notl3417;
  assign orl3439 = andl3397 || andl3414;
  assign orl3441 = orl3439 || andl3436;
  assign ne3447 = io_in_decode_src2 != 5'h0;
  assign eq3449 = io_in_decode_src2 == io_in_execute_dest;
  assign andl3451 = eq3449 && ne3447;
  assign andl3453 = andl3451 && ne3387;
  assign notl3456 = !andl3453;
  assign eq3464 = io_in_decode_src2 == io_in_memory_dest;
  assign andl3466 = eq3464 && ne3447;
  assign andl3468 = andl3466 && ne3403;
  assign andl3470 = andl3468 && notl3456;
  assign notl3473 = !andl3470;
  assign eq3484 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl3486 = eq3484 && ne3447;
  assign andl3488 = andl3486 && ne3423;
  assign andl3490 = andl3488 && notl3456;
  assign andl3492 = andl3490 && notl3473;
  assign orl3495 = andl3453 || andl3470;
  assign orl3497 = orl3495 || andl3492;
  assign eq3499 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3501 = eq3499 && eq3379;
  assign notl3504 = !andl3501;
  assign eq3506 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3508 = eq3506 && eq3383;
  assign andl3510 = andl3508 && notl3504;
  assign orl3513 = andl3501 || andl3510;
  assign orl3519 = andl3397 || andl3453;
  assign andl3521 = orl3519 && eq3358;
  assign sel3523 = andl3521 ? 1'h1 : 1'h0;
  assign sel3527 = eq3364 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel3529 = eq3374 ? io_in_writeback_PC_next : sel3527;
  assign sel3531 = andl3436 ? sel3529 : 32'h7b;
  assign sel3533 = eq3361 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel3535 = eq3371 ? io_in_memory_PC_next : sel3533;
  assign sel3537 = andl3414 ? sel3535 : sel3531;
  assign sel3539 = eq3368 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel3541 = andl3397 ? sel3539 : sel3537;
  assign sel3548 = andl3492 ? sel3529 : 32'h7b;
  assign sel3554 = andl3470 ? sel3535 : sel3548;
  assign sel3558 = andl3453 ? sel3539 : sel3554;
  assign sel3561 = andl3510 ? io_in_memory_csr_result : 32'h7b;
  assign sel3563 = andl3501 ? io_in_execute_alu_result : sel3561;

  assign io_out_src1_fwd = orl3441;
  assign io_out_src2_fwd = orl3497;
  assign io_out_csr_fwd = orl3513;
  assign io_out_src1_fwd_data = sel3541;
  assign io_out_src2_fwd_data = sel3558;
  assign io_out_csr_fwd_data = sel3563;
  assign io_out_fwd_stall = sel3523;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3667 [0:1];
  wire[31:0] marport3668, sel3672;

  initial begin
    mem3667[0] = 32'h70000000;
    mem3667[1] = 32'hdeadbeef;
  end
  assign marport3668 = mem3667[io_INTERRUPT_in_interrupt_id_data];
  assign sel3672 = io_INTERRUPT_in_interrupt_id_valid ? marport3668 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3672;

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
  reg[3:0] reg3739, sel3830;
  wire eq3748, andl3833, eq3837, andl3841, eq3845, andb3849;
  wire[3:0] sel3754, sel3759, sel3765, sel3771, sel3781, sel3786, sel3790, sel3799, sel3805, sel3815, sel3820, sel3824, sel3831, sel3847, sel3848, sel3850;

  always @ (posedge clk) begin
    if (reset)
      reg3739 <= 4'h0;
    else
      reg3739 <= sel3850;
  end
  assign eq3748 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3754 = eq3748 ? 4'h0 : 4'h1;
  assign sel3759 = eq3748 ? 4'h2 : 4'h1;
  assign sel3765 = eq3748 ? 4'h9 : 4'h3;
  assign sel3771 = eq3748 ? 4'h5 : 4'h4;
  assign sel3781 = eq3748 ? 4'h8 : 4'h6;
  assign sel3786 = eq3748 ? 4'h7 : 4'h6;
  assign sel3790 = eq3748 ? 4'h4 : 4'h8;
  assign sel3799 = eq3748 ? 4'h0 : 4'ha;
  assign sel3805 = eq3748 ? 4'hc : 4'hb;
  assign sel3815 = eq3748 ? 4'hf : 4'hd;
  assign sel3820 = eq3748 ? 4'he : 4'hd;
  assign sel3824 = eq3748 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3739)
      4'h0: sel3830 = sel3754;
      4'h1: sel3830 = sel3759;
      4'h2: sel3830 = sel3765;
      4'h3: sel3830 = sel3771;
      4'h4: sel3830 = sel3771;
      4'h5: sel3830 = sel3781;
      4'h6: sel3830 = sel3786;
      4'h7: sel3830 = sel3790;
      4'h8: sel3830 = sel3759;
      4'h9: sel3830 = sel3799;
      4'ha: sel3830 = sel3805;
      4'hb: sel3830 = sel3805;
      4'hc: sel3830 = sel3815;
      4'hd: sel3830 = sel3820;
      4'he: sel3830 = sel3824;
      4'hf: sel3830 = sel3759;
      default: sel3830 = reg3739;
    endcase
  end
  assign sel3831 = io_JTAG_TAP_in_mode_select_valid ? sel3830 : 4'h0;
  assign andl3833 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_reset_valid;
  assign eq3837 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3841 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_clock_valid;
  assign eq3845 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3847 = eq3837 ? 4'h0 : reg3739;
  assign sel3848 = andb3849 ? sel3831 : reg3739;
  assign andb3849 = andl3841 & eq3845;
  assign sel3850 = andl3833 ? sel3847 : sel3848;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3739;

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
  wire TAP3853_clk, TAP3853_reset, TAP3853_io_JTAG_TAP_in_mode_select_data, TAP3853_io_JTAG_TAP_in_mode_select_valid, TAP3853_io_JTAG_TAP_in_mode_select_ready, TAP3853_io_JTAG_TAP_in_clock_data, TAP3853_io_JTAG_TAP_in_clock_valid, TAP3853_io_JTAG_TAP_in_clock_ready, TAP3853_io_JTAG_TAP_in_reset_data, TAP3853_io_JTAG_TAP_in_reset_valid, TAP3853_io_JTAG_TAP_in_reset_ready, eq3918, eq3927, eq3931, eq4000, andb4001, sel4007, sel4013;
  wire[3:0] TAP3853_io_out_curr_state;
  reg[31:0] reg3893, reg3900, reg3907, reg3914, sel4005;
  wire[31:0] sel3934, sel3936, shr3944, proxy3949, sel3999, sel4002, sel4003, sel4004, sel4006;
  reg sel4012, sel4018;

  assign TAP3853_clk = clk;
  assign TAP3853_reset = reset;
  TAP TAP3853(.clk(TAP3853_clk), .reset(TAP3853_reset), .io_JTAG_TAP_in_mode_select_data(TAP3853_io_JTAG_TAP_in_mode_select_data), .io_JTAG_TAP_in_mode_select_valid(TAP3853_io_JTAG_TAP_in_mode_select_valid), .io_JTAG_TAP_in_clock_data(TAP3853_io_JTAG_TAP_in_clock_data), .io_JTAG_TAP_in_clock_valid(TAP3853_io_JTAG_TAP_in_clock_valid), .io_JTAG_TAP_in_reset_data(TAP3853_io_JTAG_TAP_in_reset_data), .io_JTAG_TAP_in_reset_valid(TAP3853_io_JTAG_TAP_in_reset_valid), .io_JTAG_TAP_in_mode_select_ready(TAP3853_io_JTAG_TAP_in_mode_select_ready), .io_JTAG_TAP_in_clock_ready(TAP3853_io_JTAG_TAP_in_clock_ready), .io_JTAG_TAP_in_reset_ready(TAP3853_io_JTAG_TAP_in_reset_ready), .io_out_curr_state(TAP3853_io_out_curr_state));
  assign TAP3853_io_JTAG_TAP_in_mode_select_data = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign TAP3853_io_JTAG_TAP_in_mode_select_valid = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign TAP3853_io_JTAG_TAP_in_clock_data = io_JTAG_JTAG_TAP_in_clock_data;
  assign TAP3853_io_JTAG_TAP_in_clock_valid = io_JTAG_JTAG_TAP_in_clock_valid;
  assign TAP3853_io_JTAG_TAP_in_reset_data = io_JTAG_JTAG_TAP_in_reset_data;
  assign TAP3853_io_JTAG_TAP_in_reset_valid = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3893 <= 32'h0;
    else
      reg3893 <= sel4006;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3900 <= 32'h1234;
    else
      reg3900 <= sel4004;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3907 <= 32'h5678;
    else
      reg3907 <= sel3999;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3914 <= 32'h0;
    else
      reg3914 <= sel4005;
  end
  assign eq3918 = reg3893 == 32'h0;
  assign eq3927 = reg3893 == 32'h1;
  assign eq3931 = reg3893 == 32'h2;
  assign sel3934 = eq3931 ? reg3900 : 32'hdeadbeef;
  assign sel3936 = eq3927 ? reg3907 : sel3934;
  assign shr3944 = reg3914 >> 32'h1;
  assign proxy3949 = {io_JTAG_in_data_data, shr3944[30:0]};
  assign sel3999 = andb4001 ? reg3914 : reg3907;
  assign eq4000 = TAP3853_io_out_curr_state == 4'h8;
  assign andb4001 = eq4000 & eq3927;
  assign sel4002 = eq3931 ? reg3914 : reg3900;
  assign sel4003 = eq3927 ? reg3900 : sel4002;
  assign sel4004 = (TAP3853_io_out_curr_state == 4'h8) ? sel4003 : reg3900;
  always @(*) begin
    case (TAP3853_io_out_curr_state)
      4'h3: sel4005 = sel3936;
      4'h4: sel4005 = proxy3949;
      4'ha: sel4005 = reg3893;
      4'hb: sel4005 = proxy3949;
      default: sel4005 = reg3914;
    endcase
  end
  assign sel4006 = (TAP3853_io_out_curr_state == 4'hf) ? reg3914 : reg3893;
  assign sel4007 = eq3918 ? 1'h1 : 1'h0;
  always @(*) begin
    case (TAP3853_io_out_curr_state)
      4'h3: sel4012 = sel4007;
      4'h4: sel4012 = 1'h1;
      4'h8: sel4012 = sel4007;
      4'ha: sel4012 = sel4007;
      4'hb: sel4012 = 1'h1;
      4'hf: sel4012 = sel4007;
      default: sel4012 = sel4007;
    endcase
  end
  assign sel4013 = eq3918 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (TAP3853_io_out_curr_state)
      4'h3: sel4018 = sel4013;
      4'h4: sel4018 = reg3914[0];
      4'h8: sel4018 = sel4013;
      4'ha: sel4018 = sel4013;
      4'hb: sel4018 = reg3914[0];
      4'hf: sel4018 = sel4013;
      default: sel4018 = sel4013;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = TAP3853_io_JTAG_TAP_in_mode_select_ready;
  assign io_JTAG_JTAG_TAP_in_clock_ready = TAP3853_io_JTAG_TAP_in_clock_ready;
  assign io_JTAG_JTAG_TAP_in_reset_ready = TAP3853_io_JTAG_TAP_in_reset_ready;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel4018;
  assign io_JTAG_out_data_valid = sel4012;

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
  reg[11:0] mem4074 [0:4095];
  reg[11:0] reg4080;
  wire[11:0] marport4094;
  wire[31:0] pad4096;

  assign marport4094 = mem4074[reg4080];
  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem4074[io_in_mem_csr_address] <= io_in_mem_csr_result[11:0];
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg4080 <= 12'h0;
    else
      reg4080 <= io_in_decode_csr_address;
  end
  assign pad4096 = {{20{1'b0}}, marport4094};

  assign io_out_decode_csr_data = pad4096;

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
  input wire[31:0] io_DBUS_in_data_data,
  input wire io_DBUS_in_data_valid,
  output wire io_DBUS_in_data_ready,
  output wire[31:0] io_DBUS_out_data_data,
  output wire io_DBUS_out_data_valid,
  input wire io_DBUS_out_data_ready,
  output wire[31:0] io_DBUS_out_address_data,
  output wire io_DBUS_out_address_valid,
  input wire io_DBUS_out_address_ready,
  output wire[1:0] io_DBUS_out_control_data,
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
  wire Fetch390_clk, Fetch390_reset, Fetch390_io_IBUS_in_data_valid, Fetch390_io_IBUS_in_data_ready, Fetch390_io_IBUS_out_address_valid, Fetch390_io_IBUS_out_address_ready, Fetch390_io_in_branch_dir, Fetch390_io_in_freeze, Fetch390_io_in_branch_stall, Fetch390_io_in_fwd_stall, Fetch390_io_in_branch_stall_exe, Fetch390_io_in_jal, Fetch390_io_in_interrupt, Fetch390_io_in_debug, Fetch390_io_out_delay, F_D_Register513_clk, F_D_Register513_reset, F_D_Register513_io_in_branch_stall, F_D_Register513_io_in_branch_stall_exe, F_D_Register513_io_in_fwd_stall, F_D_Register513_io_in_freeze, Decode1224_clk, Decode1224_io_in_stall, Decode1224_io_in_src1_fwd, Decode1224_io_in_src2_fwd, Decode1224_io_in_csr_fwd, Decode1224_io_out_is_csr, Decode1224_io_out_rs2_src, Decode1224_io_out_branch_stall, Decode1224_io_out_jal, D_E_Register1633_clk, D_E_Register1633_reset, D_E_Register1633_io_in_rs2_src, D_E_Register1633_io_in_fwd_stall, D_E_Register1633_io_in_branch_stall, D_E_Register1633_io_in_is_csr, D_E_Register1633_io_in_jal, D_E_Register1633_io_in_freeze, D_E_Register1633_io_out_is_csr, D_E_Register1633_io_out_rs2_src, D_E_Register1633_io_out_jal, Execute1950_io_in_rs2_src, Execute1950_io_in_is_csr, Execute1950_io_in_jal, Execute1950_io_out_is_csr, Execute1950_io_out_jal, Execute1950_io_out_branch_stall, E_M_Register2276_clk, E_M_Register2276_reset, E_M_Register2276_io_in_is_csr, E_M_Register2276_io_in_jal, E_M_Register2276_io_in_freeze, E_M_Register2276_io_out_is_csr, E_M_Register2276_io_out_jal, Memory2971_clk, Memory2971_reset, Memory2971_io_DBUS_out_miss, Memory2971_io_DBUS_in_data_valid, Memory2971_io_DBUS_in_data_ready, Memory2971_io_DBUS_out_data_valid, Memory2971_io_DBUS_out_data_ready, Memory2971_io_DBUS_out_address_valid, Memory2971_io_DBUS_out_address_ready, Memory2971_io_DBUS_out_control_valid, Memory2971_io_DBUS_out_control_ready, Memory2971_io_out_branch_dir, Memory2971_io_out_delay, Memory2971_io_out_branch_stall, M_W_Register3195_clk, M_W_Register3195_reset, M_W_Register3195_io_in_freeze, M_W_Register3195_io_in_branch_dir, M_W_Register3195_io_out_branch_dir, Forwarding3567_io_in_execute_is_csr, Forwarding3567_io_in_memory_is_csr, Forwarding3567_io_out_src1_fwd, Forwarding3567_io_out_src2_fwd, Forwarding3567_io_out_csr_fwd, Forwarding3567_io_out_fwd_stall, Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_data, Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_valid, Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_ready, Interrupt_Handler3675_io_out_interrupt, JTAG4021_clk, JTAG4021_reset, JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_data, JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_valid, JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_ready, JTAG4021_io_JTAG_JTAG_TAP_in_clock_data, JTAG4021_io_JTAG_JTAG_TAP_in_clock_valid, JTAG4021_io_JTAG_JTAG_TAP_in_clock_ready, JTAG4021_io_JTAG_JTAG_TAP_in_reset_data, JTAG4021_io_JTAG_JTAG_TAP_in_reset_valid, JTAG4021_io_JTAG_JTAG_TAP_in_reset_ready, JTAG4021_io_JTAG_in_data_data, JTAG4021_io_JTAG_in_data_valid, JTAG4021_io_JTAG_in_data_ready, JTAG4021_io_JTAG_out_data_data, JTAG4021_io_JTAG_out_data_valid, JTAG4021_io_JTAG_out_data_ready, CSR_Handler4099_clk, CSR_Handler4099_reset, CSR_Handler4099_io_in_mem_is_csr, orl4116, orl4118, eq4123, orl4125, orl4128, orl4137;
  wire[31:0] Fetch390_io_IBUS_in_data_data, Fetch390_io_IBUS_out_address_data, Fetch390_io_in_branch_dest, Fetch390_io_in_jal_dest, Fetch390_io_in_interrupt_pc, Fetch390_io_out_instruction, Fetch390_io_out_curr_PC, F_D_Register513_io_in_instruction, F_D_Register513_io_in_curr_PC, F_D_Register513_io_out_instruction, F_D_Register513_io_out_curr_PC, Decode1224_io_in_instruction, Decode1224_io_in_curr_PC, Decode1224_io_in_write_data, Decode1224_io_in_src1_fwd_data, Decode1224_io_in_src2_fwd_data, Decode1224_io_in_csr_fwd_data, Decode1224_io_out_csr_mask, Decode1224_io_out_rd1, Decode1224_io_out_rd2, Decode1224_io_out_itype_immed, Decode1224_io_out_jal_offset, Decode1224_io_out_PC_next, D_E_Register1633_io_in_rd1, D_E_Register1633_io_in_rd2, D_E_Register1633_io_in_itype_immed, D_E_Register1633_io_in_PC_next, D_E_Register1633_io_in_csr_mask, D_E_Register1633_io_in_curr_PC, D_E_Register1633_io_in_jal_offset, D_E_Register1633_io_out_csr_mask, D_E_Register1633_io_out_rd1, D_E_Register1633_io_out_rd2, D_E_Register1633_io_out_itype_immed, D_E_Register1633_io_out_curr_PC, D_E_Register1633_io_out_jal_offset, D_E_Register1633_io_out_PC_next, Execute1950_io_in_rd1, Execute1950_io_in_rd2, Execute1950_io_in_itype_immed, Execute1950_io_in_PC_next, Execute1950_io_in_csr_data, Execute1950_io_in_csr_mask, Execute1950_io_in_jal_offset, Execute1950_io_in_curr_PC, Execute1950_io_out_csr_result, Execute1950_io_out_alu_result, Execute1950_io_out_rd1, Execute1950_io_out_rd2, Execute1950_io_out_jal_dest, Execute1950_io_out_branch_offset, Execute1950_io_out_PC_next, E_M_Register2276_io_in_alu_result, E_M_Register2276_io_in_rd1, E_M_Register2276_io_in_rd2, E_M_Register2276_io_in_PC_next, E_M_Register2276_io_in_csr_result, E_M_Register2276_io_in_curr_PC, E_M_Register2276_io_in_branch_offset, E_M_Register2276_io_in_jal_dest, E_M_Register2276_io_out_csr_result, E_M_Register2276_io_out_alu_result, E_M_Register2276_io_out_rd1, E_M_Register2276_io_out_rd2, E_M_Register2276_io_out_curr_PC, E_M_Register2276_io_out_branch_offset, E_M_Register2276_io_out_jal_dest, E_M_Register2276_io_out_PC_next, Memory2971_io_DBUS_in_data_data, Memory2971_io_DBUS_out_data_data, Memory2971_io_DBUS_out_address_data, Memory2971_io_in_alu_result, Memory2971_io_in_rd1, Memory2971_io_in_rd2, Memory2971_io_in_PC_next, Memory2971_io_in_curr_PC, Memory2971_io_in_branch_offset, Memory2971_io_out_alu_result, Memory2971_io_out_mem_result, Memory2971_io_out_branch_dest, Memory2971_io_out_PC_next, M_W_Register3195_io_in_alu_result, M_W_Register3195_io_in_mem_result, M_W_Register3195_io_in_PC_next, M_W_Register3195_io_in_branch_dest, M_W_Register3195_io_out_alu_result, M_W_Register3195_io_out_mem_result, M_W_Register3195_io_out_branch_dest, M_W_Register3195_io_out_PC_next, Write_Back3283_io_in_alu_result, Write_Back3283_io_in_mem_result, Write_Back3283_io_in_PC_next, Write_Back3283_io_out_write_data, Forwarding3567_io_in_execute_alu_result, Forwarding3567_io_in_execute_PC_next, Forwarding3567_io_in_execute_csr_result, Forwarding3567_io_in_memory_alu_result, Forwarding3567_io_in_memory_mem_data, Forwarding3567_io_in_memory_PC_next, Forwarding3567_io_in_memory_csr_result, Forwarding3567_io_in_writeback_alu_result, Forwarding3567_io_in_writeback_mem_data, Forwarding3567_io_in_writeback_PC_next, Forwarding3567_io_out_src1_fwd_data, Forwarding3567_io_out_src2_fwd_data, Forwarding3567_io_out_csr_fwd_data, Interrupt_Handler3675_io_out_interrupt_pc, CSR_Handler4099_io_in_mem_csr_result, CSR_Handler4099_io_out_decode_csr_data;
  wire[4:0] Decode1224_io_in_rd, Decode1224_io_out_rd, Decode1224_io_out_rs1, Decode1224_io_out_rs2, D_E_Register1633_io_in_rd, D_E_Register1633_io_in_rs1, D_E_Register1633_io_in_rs2, D_E_Register1633_io_out_rd, D_E_Register1633_io_out_rs1, D_E_Register1633_io_out_rs2, Execute1950_io_in_rd, Execute1950_io_in_rs1, Execute1950_io_in_rs2, Execute1950_io_out_rd, Execute1950_io_out_rs1, Execute1950_io_out_rs2, E_M_Register2276_io_in_rd, E_M_Register2276_io_in_rs1, E_M_Register2276_io_in_rs2, E_M_Register2276_io_out_rd, E_M_Register2276_io_out_rs1, E_M_Register2276_io_out_rs2, Memory2971_io_in_rd, Memory2971_io_in_rs1, Memory2971_io_in_rs2, Memory2971_io_out_rd, Memory2971_io_out_rs1, Memory2971_io_out_rs2, M_W_Register3195_io_in_rd, M_W_Register3195_io_in_rs1, M_W_Register3195_io_in_rs2, M_W_Register3195_io_out_rd, M_W_Register3195_io_out_rs1, M_W_Register3195_io_out_rs2, Write_Back3283_io_in_rd, Write_Back3283_io_in_rs1, Write_Back3283_io_in_rs2, Write_Back3283_io_out_rd, Forwarding3567_io_in_decode_src1, Forwarding3567_io_in_decode_src2, Forwarding3567_io_in_execute_dest, Forwarding3567_io_in_memory_dest, Forwarding3567_io_in_writeback_dest;
  wire[1:0] Decode1224_io_in_wb, Decode1224_io_out_wb, D_E_Register1633_io_in_wb, D_E_Register1633_io_out_wb, Execute1950_io_in_wb, Execute1950_io_out_wb, E_M_Register2276_io_in_wb, E_M_Register2276_io_out_wb, Memory2971_io_DBUS_out_control_data, Memory2971_io_in_wb, Memory2971_io_out_wb, M_W_Register3195_io_in_wb, M_W_Register3195_io_out_wb, Write_Back3283_io_in_wb, Write_Back3283_io_out_wb, Forwarding3567_io_in_execute_wb, Forwarding3567_io_in_memory_wb, Forwarding3567_io_in_writeback_wb;
  wire[11:0] Decode1224_io_out_csr_address, D_E_Register1633_io_in_csr_address, D_E_Register1633_io_out_csr_address, Execute1950_io_in_csr_address, Execute1950_io_out_csr_address, E_M_Register2276_io_in_csr_address, E_M_Register2276_io_out_csr_address, Forwarding3567_io_in_decode_csr_address, Forwarding3567_io_in_execute_csr_address, Forwarding3567_io_in_memory_csr_address, CSR_Handler4099_io_in_decode_csr_address, CSR_Handler4099_io_in_mem_csr_address;
  wire[3:0] Decode1224_io_out_alu_op, D_E_Register1633_io_in_alu_op, D_E_Register1633_io_out_alu_op, Execute1950_io_in_alu_op;
  wire[2:0] Decode1224_io_out_mem_read, Decode1224_io_out_mem_write, Decode1224_io_out_branch_type, D_E_Register1633_io_in_mem_read, D_E_Register1633_io_in_mem_write, D_E_Register1633_io_in_branch_type, D_E_Register1633_io_out_mem_read, D_E_Register1633_io_out_mem_write, D_E_Register1633_io_out_branch_type, Execute1950_io_in_mem_read, Execute1950_io_in_mem_write, Execute1950_io_in_branch_type, Execute1950_io_out_mem_read, Execute1950_io_out_mem_write, E_M_Register2276_io_in_mem_read, E_M_Register2276_io_in_mem_write, E_M_Register2276_io_in_branch_type, E_M_Register2276_io_out_mem_read, E_M_Register2276_io_out_mem_write, E_M_Register2276_io_out_branch_type, Memory2971_io_in_mem_read, Memory2971_io_in_mem_write, Memory2971_io_in_branch_type;
  wire[19:0] Decode1224_io_out_upper_immed, D_E_Register1633_io_in_upper_immed, D_E_Register1633_io_out_upper_immed, Execute1950_io_in_upper_immed;

  assign Fetch390_clk = clk;
  assign Fetch390_reset = reset;
  Fetch Fetch390(.clk(Fetch390_clk), .reset(Fetch390_reset), .io_IBUS_in_data_data(Fetch390_io_IBUS_in_data_data), .io_IBUS_in_data_valid(Fetch390_io_IBUS_in_data_valid), .io_IBUS_out_address_ready(Fetch390_io_IBUS_out_address_ready), .io_in_branch_dir(Fetch390_io_in_branch_dir), .io_in_freeze(Fetch390_io_in_freeze), .io_in_branch_dest(Fetch390_io_in_branch_dest), .io_in_branch_stall(Fetch390_io_in_branch_stall), .io_in_fwd_stall(Fetch390_io_in_fwd_stall), .io_in_branch_stall_exe(Fetch390_io_in_branch_stall_exe), .io_in_jal(Fetch390_io_in_jal), .io_in_jal_dest(Fetch390_io_in_jal_dest), .io_in_interrupt(Fetch390_io_in_interrupt), .io_in_interrupt_pc(Fetch390_io_in_interrupt_pc), .io_in_debug(Fetch390_io_in_debug), .io_IBUS_in_data_ready(Fetch390_io_IBUS_in_data_ready), .io_IBUS_out_address_data(Fetch390_io_IBUS_out_address_data), .io_IBUS_out_address_valid(Fetch390_io_IBUS_out_address_valid), .io_out_instruction(Fetch390_io_out_instruction), .io_out_delay(Fetch390_io_out_delay), .io_out_curr_PC(Fetch390_io_out_curr_PC));
  assign Fetch390_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign Fetch390_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign Fetch390_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign Fetch390_io_in_branch_dir = M_W_Register3195_io_out_branch_dir;
  assign Fetch390_io_in_freeze = Memory2971_io_out_delay;
  assign Fetch390_io_in_branch_dest = M_W_Register3195_io_out_branch_dest;
  assign Fetch390_io_in_branch_stall = Decode1224_io_out_branch_stall;
  assign Fetch390_io_in_fwd_stall = Forwarding3567_io_out_fwd_stall;
  assign Fetch390_io_in_branch_stall_exe = orl4128;
  assign Fetch390_io_in_jal = E_M_Register2276_io_out_jal;
  assign Fetch390_io_in_jal_dest = E_M_Register2276_io_out_jal_dest;
  assign Fetch390_io_in_interrupt = Interrupt_Handler3675_io_out_interrupt;
  assign Fetch390_io_in_interrupt_pc = Interrupt_Handler3675_io_out_interrupt_pc;
  assign Fetch390_io_in_debug = io_in_debug;
  assign F_D_Register513_clk = clk;
  assign F_D_Register513_reset = reset;
  F_D_Register F_D_Register513(.clk(F_D_Register513_clk), .reset(F_D_Register513_reset), .io_in_instruction(F_D_Register513_io_in_instruction), .io_in_curr_PC(F_D_Register513_io_in_curr_PC), .io_in_branch_stall(F_D_Register513_io_in_branch_stall), .io_in_branch_stall_exe(F_D_Register513_io_in_branch_stall_exe), .io_in_fwd_stall(F_D_Register513_io_in_fwd_stall), .io_in_freeze(F_D_Register513_io_in_freeze), .io_out_instruction(F_D_Register513_io_out_instruction), .io_out_curr_PC(F_D_Register513_io_out_curr_PC));
  assign F_D_Register513_io_in_instruction = Fetch390_io_out_instruction;
  assign F_D_Register513_io_in_curr_PC = Fetch390_io_out_curr_PC;
  assign F_D_Register513_io_in_branch_stall = Decode1224_io_out_branch_stall;
  assign F_D_Register513_io_in_branch_stall_exe = orl4128;
  assign F_D_Register513_io_in_fwd_stall = Forwarding3567_io_out_fwd_stall;
  assign F_D_Register513_io_in_freeze = orl4137;
  assign Decode1224_clk = clk;
  Decode Decode1224(.clk(Decode1224_clk), .io_in_instruction(Decode1224_io_in_instruction), .io_in_curr_PC(Decode1224_io_in_curr_PC), .io_in_stall(Decode1224_io_in_stall), .io_in_write_data(Decode1224_io_in_write_data), .io_in_rd(Decode1224_io_in_rd), .io_in_wb(Decode1224_io_in_wb), .io_in_src1_fwd(Decode1224_io_in_src1_fwd), .io_in_src1_fwd_data(Decode1224_io_in_src1_fwd_data), .io_in_src2_fwd(Decode1224_io_in_src2_fwd), .io_in_src2_fwd_data(Decode1224_io_in_src2_fwd_data), .io_in_csr_fwd(Decode1224_io_in_csr_fwd), .io_in_csr_fwd_data(Decode1224_io_in_csr_fwd_data), .io_out_csr_address(Decode1224_io_out_csr_address), .io_out_is_csr(Decode1224_io_out_is_csr), .io_out_csr_mask(Decode1224_io_out_csr_mask), .io_out_rd(Decode1224_io_out_rd), .io_out_rs1(Decode1224_io_out_rs1), .io_out_rd1(Decode1224_io_out_rd1), .io_out_rs2(Decode1224_io_out_rs2), .io_out_rd2(Decode1224_io_out_rd2), .io_out_wb(Decode1224_io_out_wb), .io_out_alu_op(Decode1224_io_out_alu_op), .io_out_rs2_src(Decode1224_io_out_rs2_src), .io_out_itype_immed(Decode1224_io_out_itype_immed), .io_out_mem_read(Decode1224_io_out_mem_read), .io_out_mem_write(Decode1224_io_out_mem_write), .io_out_branch_type(Decode1224_io_out_branch_type), .io_out_branch_stall(Decode1224_io_out_branch_stall), .io_out_jal(Decode1224_io_out_jal), .io_out_jal_offset(Decode1224_io_out_jal_offset), .io_out_upper_immed(Decode1224_io_out_upper_immed), .io_out_PC_next(Decode1224_io_out_PC_next));
  assign Decode1224_io_in_instruction = F_D_Register513_io_out_instruction;
  assign Decode1224_io_in_curr_PC = F_D_Register513_io_out_curr_PC;
  assign Decode1224_io_in_stall = orl4125;
  assign Decode1224_io_in_write_data = Write_Back3283_io_out_write_data;
  assign Decode1224_io_in_rd = Write_Back3283_io_out_rd;
  assign Decode1224_io_in_wb = Write_Back3283_io_out_wb;
  assign Decode1224_io_in_src1_fwd = Forwarding3567_io_out_src1_fwd;
  assign Decode1224_io_in_src1_fwd_data = Forwarding3567_io_out_src1_fwd_data;
  assign Decode1224_io_in_src2_fwd = Forwarding3567_io_out_src2_fwd;
  assign Decode1224_io_in_src2_fwd_data = Forwarding3567_io_out_src2_fwd_data;
  assign Decode1224_io_in_csr_fwd = Forwarding3567_io_out_csr_fwd;
  assign Decode1224_io_in_csr_fwd_data = Forwarding3567_io_out_csr_fwd_data;
  assign D_E_Register1633_clk = clk;
  assign D_E_Register1633_reset = reset;
  D_E_Register D_E_Register1633(.clk(D_E_Register1633_clk), .reset(D_E_Register1633_reset), .io_in_rd(D_E_Register1633_io_in_rd), .io_in_rs1(D_E_Register1633_io_in_rs1), .io_in_rd1(D_E_Register1633_io_in_rd1), .io_in_rs2(D_E_Register1633_io_in_rs2), .io_in_rd2(D_E_Register1633_io_in_rd2), .io_in_alu_op(D_E_Register1633_io_in_alu_op), .io_in_wb(D_E_Register1633_io_in_wb), .io_in_rs2_src(D_E_Register1633_io_in_rs2_src), .io_in_itype_immed(D_E_Register1633_io_in_itype_immed), .io_in_mem_read(D_E_Register1633_io_in_mem_read), .io_in_mem_write(D_E_Register1633_io_in_mem_write), .io_in_PC_next(D_E_Register1633_io_in_PC_next), .io_in_branch_type(D_E_Register1633_io_in_branch_type), .io_in_fwd_stall(D_E_Register1633_io_in_fwd_stall), .io_in_branch_stall(D_E_Register1633_io_in_branch_stall), .io_in_upper_immed(D_E_Register1633_io_in_upper_immed), .io_in_csr_address(D_E_Register1633_io_in_csr_address), .io_in_is_csr(D_E_Register1633_io_in_is_csr), .io_in_csr_mask(D_E_Register1633_io_in_csr_mask), .io_in_curr_PC(D_E_Register1633_io_in_curr_PC), .io_in_jal(D_E_Register1633_io_in_jal), .io_in_jal_offset(D_E_Register1633_io_in_jal_offset), .io_in_freeze(D_E_Register1633_io_in_freeze), .io_out_csr_address(D_E_Register1633_io_out_csr_address), .io_out_is_csr(D_E_Register1633_io_out_is_csr), .io_out_csr_mask(D_E_Register1633_io_out_csr_mask), .io_out_rd(D_E_Register1633_io_out_rd), .io_out_rs1(D_E_Register1633_io_out_rs1), .io_out_rd1(D_E_Register1633_io_out_rd1), .io_out_rs2(D_E_Register1633_io_out_rs2), .io_out_rd2(D_E_Register1633_io_out_rd2), .io_out_alu_op(D_E_Register1633_io_out_alu_op), .io_out_wb(D_E_Register1633_io_out_wb), .io_out_rs2_src(D_E_Register1633_io_out_rs2_src), .io_out_itype_immed(D_E_Register1633_io_out_itype_immed), .io_out_mem_read(D_E_Register1633_io_out_mem_read), .io_out_mem_write(D_E_Register1633_io_out_mem_write), .io_out_branch_type(D_E_Register1633_io_out_branch_type), .io_out_upper_immed(D_E_Register1633_io_out_upper_immed), .io_out_curr_PC(D_E_Register1633_io_out_curr_PC), .io_out_jal(D_E_Register1633_io_out_jal), .io_out_jal_offset(D_E_Register1633_io_out_jal_offset), .io_out_PC_next(D_E_Register1633_io_out_PC_next));
  assign D_E_Register1633_io_in_rd = Decode1224_io_out_rd;
  assign D_E_Register1633_io_in_rs1 = Decode1224_io_out_rs1;
  assign D_E_Register1633_io_in_rd1 = Decode1224_io_out_rd1;
  assign D_E_Register1633_io_in_rs2 = Decode1224_io_out_rs2;
  assign D_E_Register1633_io_in_rd2 = Decode1224_io_out_rd2;
  assign D_E_Register1633_io_in_alu_op = Decode1224_io_out_alu_op;
  assign D_E_Register1633_io_in_wb = Decode1224_io_out_wb;
  assign D_E_Register1633_io_in_rs2_src = Decode1224_io_out_rs2_src;
  assign D_E_Register1633_io_in_itype_immed = Decode1224_io_out_itype_immed;
  assign D_E_Register1633_io_in_mem_read = Decode1224_io_out_mem_read;
  assign D_E_Register1633_io_in_mem_write = Decode1224_io_out_mem_write;
  assign D_E_Register1633_io_in_PC_next = Decode1224_io_out_PC_next;
  assign D_E_Register1633_io_in_branch_type = Decode1224_io_out_branch_type;
  assign D_E_Register1633_io_in_fwd_stall = Forwarding3567_io_out_fwd_stall;
  assign D_E_Register1633_io_in_branch_stall = orl4128;
  assign D_E_Register1633_io_in_upper_immed = Decode1224_io_out_upper_immed;
  assign D_E_Register1633_io_in_csr_address = Decode1224_io_out_csr_address;
  assign D_E_Register1633_io_in_is_csr = Decode1224_io_out_is_csr;
  assign D_E_Register1633_io_in_csr_mask = Decode1224_io_out_csr_mask;
  assign D_E_Register1633_io_in_curr_PC = F_D_Register513_io_out_curr_PC;
  assign D_E_Register1633_io_in_jal = Decode1224_io_out_jal;
  assign D_E_Register1633_io_in_jal_offset = Decode1224_io_out_jal_offset;
  assign D_E_Register1633_io_in_freeze = orl4137;
  Execute Execute1950(.io_in_rd(Execute1950_io_in_rd), .io_in_rs1(Execute1950_io_in_rs1), .io_in_rd1(Execute1950_io_in_rd1), .io_in_rs2(Execute1950_io_in_rs2), .io_in_rd2(Execute1950_io_in_rd2), .io_in_alu_op(Execute1950_io_in_alu_op), .io_in_wb(Execute1950_io_in_wb), .io_in_rs2_src(Execute1950_io_in_rs2_src), .io_in_itype_immed(Execute1950_io_in_itype_immed), .io_in_mem_read(Execute1950_io_in_mem_read), .io_in_mem_write(Execute1950_io_in_mem_write), .io_in_PC_next(Execute1950_io_in_PC_next), .io_in_branch_type(Execute1950_io_in_branch_type), .io_in_upper_immed(Execute1950_io_in_upper_immed), .io_in_csr_address(Execute1950_io_in_csr_address), .io_in_is_csr(Execute1950_io_in_is_csr), .io_in_csr_data(Execute1950_io_in_csr_data), .io_in_csr_mask(Execute1950_io_in_csr_mask), .io_in_jal(Execute1950_io_in_jal), .io_in_jal_offset(Execute1950_io_in_jal_offset), .io_in_curr_PC(Execute1950_io_in_curr_PC), .io_out_csr_address(Execute1950_io_out_csr_address), .io_out_is_csr(Execute1950_io_out_is_csr), .io_out_csr_result(Execute1950_io_out_csr_result), .io_out_alu_result(Execute1950_io_out_alu_result), .io_out_rd(Execute1950_io_out_rd), .io_out_wb(Execute1950_io_out_wb), .io_out_rs1(Execute1950_io_out_rs1), .io_out_rd1(Execute1950_io_out_rd1), .io_out_rs2(Execute1950_io_out_rs2), .io_out_rd2(Execute1950_io_out_rd2), .io_out_mem_read(Execute1950_io_out_mem_read), .io_out_mem_write(Execute1950_io_out_mem_write), .io_out_jal(Execute1950_io_out_jal), .io_out_jal_dest(Execute1950_io_out_jal_dest), .io_out_branch_offset(Execute1950_io_out_branch_offset), .io_out_branch_stall(Execute1950_io_out_branch_stall), .io_out_PC_next(Execute1950_io_out_PC_next));
  assign Execute1950_io_in_rd = D_E_Register1633_io_out_rd;
  assign Execute1950_io_in_rs1 = D_E_Register1633_io_out_rs1;
  assign Execute1950_io_in_rd1 = D_E_Register1633_io_out_rd1;
  assign Execute1950_io_in_rs2 = D_E_Register1633_io_out_rs2;
  assign Execute1950_io_in_rd2 = D_E_Register1633_io_out_rd2;
  assign Execute1950_io_in_alu_op = D_E_Register1633_io_out_alu_op;
  assign Execute1950_io_in_wb = D_E_Register1633_io_out_wb;
  assign Execute1950_io_in_rs2_src = D_E_Register1633_io_out_rs2_src;
  assign Execute1950_io_in_itype_immed = D_E_Register1633_io_out_itype_immed;
  assign Execute1950_io_in_mem_read = D_E_Register1633_io_out_mem_read;
  assign Execute1950_io_in_mem_write = D_E_Register1633_io_out_mem_write;
  assign Execute1950_io_in_PC_next = D_E_Register1633_io_out_PC_next;
  assign Execute1950_io_in_branch_type = D_E_Register1633_io_out_branch_type;
  assign Execute1950_io_in_upper_immed = D_E_Register1633_io_out_upper_immed;
  assign Execute1950_io_in_csr_address = D_E_Register1633_io_out_csr_address;
  assign Execute1950_io_in_is_csr = D_E_Register1633_io_out_is_csr;
  assign Execute1950_io_in_csr_data = CSR_Handler4099_io_out_decode_csr_data;
  assign Execute1950_io_in_csr_mask = D_E_Register1633_io_out_csr_mask;
  assign Execute1950_io_in_jal = D_E_Register1633_io_out_jal;
  assign Execute1950_io_in_jal_offset = D_E_Register1633_io_out_jal_offset;
  assign Execute1950_io_in_curr_PC = D_E_Register1633_io_out_curr_PC;
  assign E_M_Register2276_clk = clk;
  assign E_M_Register2276_reset = reset;
  E_M_Register E_M_Register2276(.clk(E_M_Register2276_clk), .reset(E_M_Register2276_reset), .io_in_alu_result(E_M_Register2276_io_in_alu_result), .io_in_rd(E_M_Register2276_io_in_rd), .io_in_wb(E_M_Register2276_io_in_wb), .io_in_rs1(E_M_Register2276_io_in_rs1), .io_in_rd1(E_M_Register2276_io_in_rd1), .io_in_rs2(E_M_Register2276_io_in_rs2), .io_in_rd2(E_M_Register2276_io_in_rd2), .io_in_mem_read(E_M_Register2276_io_in_mem_read), .io_in_mem_write(E_M_Register2276_io_in_mem_write), .io_in_PC_next(E_M_Register2276_io_in_PC_next), .io_in_csr_address(E_M_Register2276_io_in_csr_address), .io_in_is_csr(E_M_Register2276_io_in_is_csr), .io_in_csr_result(E_M_Register2276_io_in_csr_result), .io_in_curr_PC(E_M_Register2276_io_in_curr_PC), .io_in_branch_offset(E_M_Register2276_io_in_branch_offset), .io_in_branch_type(E_M_Register2276_io_in_branch_type), .io_in_jal(E_M_Register2276_io_in_jal), .io_in_jal_dest(E_M_Register2276_io_in_jal_dest), .io_in_freeze(E_M_Register2276_io_in_freeze), .io_out_csr_address(E_M_Register2276_io_out_csr_address), .io_out_is_csr(E_M_Register2276_io_out_is_csr), .io_out_csr_result(E_M_Register2276_io_out_csr_result), .io_out_alu_result(E_M_Register2276_io_out_alu_result), .io_out_rd(E_M_Register2276_io_out_rd), .io_out_wb(E_M_Register2276_io_out_wb), .io_out_rs1(E_M_Register2276_io_out_rs1), .io_out_rd1(E_M_Register2276_io_out_rd1), .io_out_rd2(E_M_Register2276_io_out_rd2), .io_out_rs2(E_M_Register2276_io_out_rs2), .io_out_mem_read(E_M_Register2276_io_out_mem_read), .io_out_mem_write(E_M_Register2276_io_out_mem_write), .io_out_curr_PC(E_M_Register2276_io_out_curr_PC), .io_out_branch_offset(E_M_Register2276_io_out_branch_offset), .io_out_branch_type(E_M_Register2276_io_out_branch_type), .io_out_jal(E_M_Register2276_io_out_jal), .io_out_jal_dest(E_M_Register2276_io_out_jal_dest), .io_out_PC_next(E_M_Register2276_io_out_PC_next));
  assign E_M_Register2276_io_in_alu_result = Execute1950_io_out_alu_result;
  assign E_M_Register2276_io_in_rd = Execute1950_io_out_rd;
  assign E_M_Register2276_io_in_wb = Execute1950_io_out_wb;
  assign E_M_Register2276_io_in_rs1 = Execute1950_io_out_rs1;
  assign E_M_Register2276_io_in_rd1 = Execute1950_io_out_rd1;
  assign E_M_Register2276_io_in_rs2 = Execute1950_io_out_rs2;
  assign E_M_Register2276_io_in_rd2 = Execute1950_io_out_rd2;
  assign E_M_Register2276_io_in_mem_read = Execute1950_io_out_mem_read;
  assign E_M_Register2276_io_in_mem_write = Execute1950_io_out_mem_write;
  assign E_M_Register2276_io_in_PC_next = Execute1950_io_out_PC_next;
  assign E_M_Register2276_io_in_csr_address = Execute1950_io_out_csr_address;
  assign E_M_Register2276_io_in_is_csr = Execute1950_io_out_is_csr;
  assign E_M_Register2276_io_in_csr_result = Execute1950_io_out_csr_result;
  assign E_M_Register2276_io_in_curr_PC = D_E_Register1633_io_out_curr_PC;
  assign E_M_Register2276_io_in_branch_offset = Execute1950_io_out_branch_offset;
  assign E_M_Register2276_io_in_branch_type = D_E_Register1633_io_out_branch_type;
  assign E_M_Register2276_io_in_jal = Execute1950_io_out_jal;
  assign E_M_Register2276_io_in_jal_dest = Execute1950_io_out_jal_dest;
  assign E_M_Register2276_io_in_freeze = orl4137;
  assign Memory2971_clk = clk;
  assign Memory2971_reset = reset;
  Memory Memory2971(.clk(Memory2971_clk), .reset(Memory2971_reset), .io_DBUS_in_data_data(Memory2971_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Memory2971_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Memory2971_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Memory2971_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Memory2971_io_DBUS_out_control_ready), .io_in_alu_result(Memory2971_io_in_alu_result), .io_in_mem_read(Memory2971_io_in_mem_read), .io_in_mem_write(Memory2971_io_in_mem_write), .io_in_rd(Memory2971_io_in_rd), .io_in_wb(Memory2971_io_in_wb), .io_in_rs1(Memory2971_io_in_rs1), .io_in_rd1(Memory2971_io_in_rd1), .io_in_rs2(Memory2971_io_in_rs2), .io_in_rd2(Memory2971_io_in_rd2), .io_in_PC_next(Memory2971_io_in_PC_next), .io_in_curr_PC(Memory2971_io_in_curr_PC), .io_in_branch_offset(Memory2971_io_in_branch_offset), .io_in_branch_type(Memory2971_io_in_branch_type), .io_DBUS_out_miss(Memory2971_io_DBUS_out_miss), .io_DBUS_in_data_ready(Memory2971_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Memory2971_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Memory2971_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Memory2971_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Memory2971_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Memory2971_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Memory2971_io_DBUS_out_control_valid), .io_out_alu_result(Memory2971_io_out_alu_result), .io_out_mem_result(Memory2971_io_out_mem_result), .io_out_rd(Memory2971_io_out_rd), .io_out_wb(Memory2971_io_out_wb), .io_out_rs1(Memory2971_io_out_rs1), .io_out_rs2(Memory2971_io_out_rs2), .io_out_branch_dir(Memory2971_io_out_branch_dir), .io_out_branch_dest(Memory2971_io_out_branch_dest), .io_out_delay(Memory2971_io_out_delay), .io_out_branch_stall(Memory2971_io_out_branch_stall), .io_out_PC_next(Memory2971_io_out_PC_next));
  assign Memory2971_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Memory2971_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Memory2971_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Memory2971_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Memory2971_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Memory2971_io_in_alu_result = E_M_Register2276_io_out_alu_result;
  assign Memory2971_io_in_mem_read = E_M_Register2276_io_out_mem_read;
  assign Memory2971_io_in_mem_write = E_M_Register2276_io_out_mem_write;
  assign Memory2971_io_in_rd = E_M_Register2276_io_out_rd;
  assign Memory2971_io_in_wb = E_M_Register2276_io_out_wb;
  assign Memory2971_io_in_rs1 = E_M_Register2276_io_out_rs1;
  assign Memory2971_io_in_rd1 = E_M_Register2276_io_out_rd1;
  assign Memory2971_io_in_rs2 = E_M_Register2276_io_out_rs2;
  assign Memory2971_io_in_rd2 = E_M_Register2276_io_out_rd2;
  assign Memory2971_io_in_PC_next = E_M_Register2276_io_out_PC_next;
  assign Memory2971_io_in_curr_PC = E_M_Register2276_io_out_curr_PC;
  assign Memory2971_io_in_branch_offset = E_M_Register2276_io_out_branch_offset;
  assign Memory2971_io_in_branch_type = E_M_Register2276_io_out_branch_type;
  assign M_W_Register3195_clk = clk;
  assign M_W_Register3195_reset = reset;
  M_W_Register M_W_Register3195(.clk(M_W_Register3195_clk), .reset(M_W_Register3195_reset), .io_in_alu_result(M_W_Register3195_io_in_alu_result), .io_in_mem_result(M_W_Register3195_io_in_mem_result), .io_in_rd(M_W_Register3195_io_in_rd), .io_in_wb(M_W_Register3195_io_in_wb), .io_in_rs1(M_W_Register3195_io_in_rs1), .io_in_rs2(M_W_Register3195_io_in_rs2), .io_in_PC_next(M_W_Register3195_io_in_PC_next), .io_in_freeze(M_W_Register3195_io_in_freeze), .io_in_branch_dir(M_W_Register3195_io_in_branch_dir), .io_in_branch_dest(M_W_Register3195_io_in_branch_dest), .io_out_alu_result(M_W_Register3195_io_out_alu_result), .io_out_mem_result(M_W_Register3195_io_out_mem_result), .io_out_rd(M_W_Register3195_io_out_rd), .io_out_wb(M_W_Register3195_io_out_wb), .io_out_rs1(M_W_Register3195_io_out_rs1), .io_out_rs2(M_W_Register3195_io_out_rs2), .io_out_branch_dir(M_W_Register3195_io_out_branch_dir), .io_out_branch_dest(M_W_Register3195_io_out_branch_dest), .io_out_PC_next(M_W_Register3195_io_out_PC_next));
  assign M_W_Register3195_io_in_alu_result = Memory2971_io_out_alu_result;
  assign M_W_Register3195_io_in_mem_result = Memory2971_io_out_mem_result;
  assign M_W_Register3195_io_in_rd = Memory2971_io_out_rd;
  assign M_W_Register3195_io_in_wb = Memory2971_io_out_wb;
  assign M_W_Register3195_io_in_rs1 = Memory2971_io_out_rs1;
  assign M_W_Register3195_io_in_rs2 = Memory2971_io_out_rs2;
  assign M_W_Register3195_io_in_PC_next = Memory2971_io_out_PC_next;
  assign M_W_Register3195_io_in_freeze = orl4137;
  assign M_W_Register3195_io_in_branch_dir = Memory2971_io_out_branch_dir;
  assign M_W_Register3195_io_in_branch_dest = Memory2971_io_out_branch_dest;
  Write_Back Write_Back3283(.io_in_alu_result(Write_Back3283_io_in_alu_result), .io_in_mem_result(Write_Back3283_io_in_mem_result), .io_in_rd(Write_Back3283_io_in_rd), .io_in_wb(Write_Back3283_io_in_wb), .io_in_rs1(Write_Back3283_io_in_rs1), .io_in_rs2(Write_Back3283_io_in_rs2), .io_in_PC_next(Write_Back3283_io_in_PC_next), .io_out_write_data(Write_Back3283_io_out_write_data), .io_out_rd(Write_Back3283_io_out_rd), .io_out_wb(Write_Back3283_io_out_wb));
  assign Write_Back3283_io_in_alu_result = M_W_Register3195_io_out_alu_result;
  assign Write_Back3283_io_in_mem_result = M_W_Register3195_io_out_mem_result;
  assign Write_Back3283_io_in_rd = M_W_Register3195_io_out_rd;
  assign Write_Back3283_io_in_wb = M_W_Register3195_io_out_wb;
  assign Write_Back3283_io_in_rs1 = M_W_Register3195_io_out_rs1;
  assign Write_Back3283_io_in_rs2 = M_W_Register3195_io_out_rs2;
  assign Write_Back3283_io_in_PC_next = M_W_Register3195_io_out_PC_next;
  Forwarding Forwarding3567(.io_in_decode_src1(Forwarding3567_io_in_decode_src1), .io_in_decode_src2(Forwarding3567_io_in_decode_src2), .io_in_decode_csr_address(Forwarding3567_io_in_decode_csr_address), .io_in_execute_dest(Forwarding3567_io_in_execute_dest), .io_in_execute_wb(Forwarding3567_io_in_execute_wb), .io_in_execute_alu_result(Forwarding3567_io_in_execute_alu_result), .io_in_execute_PC_next(Forwarding3567_io_in_execute_PC_next), .io_in_execute_is_csr(Forwarding3567_io_in_execute_is_csr), .io_in_execute_csr_address(Forwarding3567_io_in_execute_csr_address), .io_in_execute_csr_result(Forwarding3567_io_in_execute_csr_result), .io_in_memory_dest(Forwarding3567_io_in_memory_dest), .io_in_memory_wb(Forwarding3567_io_in_memory_wb), .io_in_memory_alu_result(Forwarding3567_io_in_memory_alu_result), .io_in_memory_mem_data(Forwarding3567_io_in_memory_mem_data), .io_in_memory_PC_next(Forwarding3567_io_in_memory_PC_next), .io_in_memory_is_csr(Forwarding3567_io_in_memory_is_csr), .io_in_memory_csr_address(Forwarding3567_io_in_memory_csr_address), .io_in_memory_csr_result(Forwarding3567_io_in_memory_csr_result), .io_in_writeback_dest(Forwarding3567_io_in_writeback_dest), .io_in_writeback_wb(Forwarding3567_io_in_writeback_wb), .io_in_writeback_alu_result(Forwarding3567_io_in_writeback_alu_result), .io_in_writeback_mem_data(Forwarding3567_io_in_writeback_mem_data), .io_in_writeback_PC_next(Forwarding3567_io_in_writeback_PC_next), .io_out_src1_fwd(Forwarding3567_io_out_src1_fwd), .io_out_src2_fwd(Forwarding3567_io_out_src2_fwd), .io_out_csr_fwd(Forwarding3567_io_out_csr_fwd), .io_out_src1_fwd_data(Forwarding3567_io_out_src1_fwd_data), .io_out_src2_fwd_data(Forwarding3567_io_out_src2_fwd_data), .io_out_csr_fwd_data(Forwarding3567_io_out_csr_fwd_data), .io_out_fwd_stall(Forwarding3567_io_out_fwd_stall));
  assign Forwarding3567_io_in_decode_src1 = Decode1224_io_out_rs1;
  assign Forwarding3567_io_in_decode_src2 = Decode1224_io_out_rs2;
  assign Forwarding3567_io_in_decode_csr_address = Decode1224_io_out_csr_address;
  assign Forwarding3567_io_in_execute_dest = Execute1950_io_out_rd;
  assign Forwarding3567_io_in_execute_wb = Execute1950_io_out_wb;
  assign Forwarding3567_io_in_execute_alu_result = Execute1950_io_out_alu_result;
  assign Forwarding3567_io_in_execute_PC_next = Execute1950_io_out_PC_next;
  assign Forwarding3567_io_in_execute_is_csr = Execute1950_io_out_is_csr;
  assign Forwarding3567_io_in_execute_csr_address = Execute1950_io_out_csr_address;
  assign Forwarding3567_io_in_execute_csr_result = Execute1950_io_out_csr_result;
  assign Forwarding3567_io_in_memory_dest = Memory2971_io_out_rd;
  assign Forwarding3567_io_in_memory_wb = Memory2971_io_out_wb;
  assign Forwarding3567_io_in_memory_alu_result = Memory2971_io_out_alu_result;
  assign Forwarding3567_io_in_memory_mem_data = Memory2971_io_out_mem_result;
  assign Forwarding3567_io_in_memory_PC_next = Memory2971_io_out_PC_next;
  assign Forwarding3567_io_in_memory_is_csr = E_M_Register2276_io_out_is_csr;
  assign Forwarding3567_io_in_memory_csr_address = E_M_Register2276_io_out_csr_address;
  assign Forwarding3567_io_in_memory_csr_result = E_M_Register2276_io_out_csr_result;
  assign Forwarding3567_io_in_writeback_dest = M_W_Register3195_io_out_rd;
  assign Forwarding3567_io_in_writeback_wb = M_W_Register3195_io_out_wb;
  assign Forwarding3567_io_in_writeback_alu_result = M_W_Register3195_io_out_alu_result;
  assign Forwarding3567_io_in_writeback_mem_data = M_W_Register3195_io_out_mem_result;
  assign Forwarding3567_io_in_writeback_PC_next = M_W_Register3195_io_out_PC_next;
  Interrupt_Handler Interrupt_Handler3675(.io_INTERRUPT_in_interrupt_id_data(Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_data), .io_INTERRUPT_in_interrupt_id_valid(Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_valid), .io_INTERRUPT_in_interrupt_id_ready(Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_ready), .io_out_interrupt(Interrupt_Handler3675_io_out_interrupt), .io_out_interrupt_pc(Interrupt_Handler3675_io_out_interrupt_pc));
  assign Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_data = io_INTERRUPT_in_interrupt_id_data;
  assign Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_valid = io_INTERRUPT_in_interrupt_id_valid;
  assign JTAG4021_clk = clk;
  assign JTAG4021_reset = reset;
  JTAG JTAG4021(.clk(JTAG4021_clk), .reset(JTAG4021_reset), .io_JTAG_JTAG_TAP_in_mode_select_data(JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_data), .io_JTAG_JTAG_TAP_in_mode_select_valid(JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_valid), .io_JTAG_JTAG_TAP_in_clock_data(JTAG4021_io_JTAG_JTAG_TAP_in_clock_data), .io_JTAG_JTAG_TAP_in_clock_valid(JTAG4021_io_JTAG_JTAG_TAP_in_clock_valid), .io_JTAG_JTAG_TAP_in_reset_data(JTAG4021_io_JTAG_JTAG_TAP_in_reset_data), .io_JTAG_JTAG_TAP_in_reset_valid(JTAG4021_io_JTAG_JTAG_TAP_in_reset_valid), .io_JTAG_in_data_data(JTAG4021_io_JTAG_in_data_data), .io_JTAG_in_data_valid(JTAG4021_io_JTAG_in_data_valid), .io_JTAG_out_data_ready(JTAG4021_io_JTAG_out_data_ready), .io_JTAG_JTAG_TAP_in_mode_select_ready(JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_ready), .io_JTAG_JTAG_TAP_in_clock_ready(JTAG4021_io_JTAG_JTAG_TAP_in_clock_ready), .io_JTAG_JTAG_TAP_in_reset_ready(JTAG4021_io_JTAG_JTAG_TAP_in_reset_ready), .io_JTAG_in_data_ready(JTAG4021_io_JTAG_in_data_ready), .io_JTAG_out_data_data(JTAG4021_io_JTAG_out_data_data), .io_JTAG_out_data_valid(JTAG4021_io_JTAG_out_data_valid));
  assign JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_data = io_jtag_JTAG_TAP_in_mode_select_data;
  assign JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_valid = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign JTAG4021_io_JTAG_JTAG_TAP_in_clock_data = io_jtag_JTAG_TAP_in_clock_data;
  assign JTAG4021_io_JTAG_JTAG_TAP_in_clock_valid = io_jtag_JTAG_TAP_in_clock_valid;
  assign JTAG4021_io_JTAG_JTAG_TAP_in_reset_data = io_jtag_JTAG_TAP_in_reset_data;
  assign JTAG4021_io_JTAG_JTAG_TAP_in_reset_valid = io_jtag_JTAG_TAP_in_reset_valid;
  assign JTAG4021_io_JTAG_in_data_data = io_jtag_in_data_data;
  assign JTAG4021_io_JTAG_in_data_valid = io_jtag_in_data_valid;
  assign JTAG4021_io_JTAG_out_data_ready = io_jtag_out_data_ready;
  assign CSR_Handler4099_clk = clk;
  assign CSR_Handler4099_reset = reset;
  CSR_Handler CSR_Handler4099(.clk(CSR_Handler4099_clk), .reset(CSR_Handler4099_reset), .io_in_decode_csr_address(CSR_Handler4099_io_in_decode_csr_address), .io_in_mem_csr_address(CSR_Handler4099_io_in_mem_csr_address), .io_in_mem_is_csr(CSR_Handler4099_io_in_mem_is_csr), .io_in_mem_csr_result(CSR_Handler4099_io_in_mem_csr_result), .io_out_decode_csr_data(CSR_Handler4099_io_out_decode_csr_data));
  assign CSR_Handler4099_io_in_decode_csr_address = Decode1224_io_out_csr_address;
  assign CSR_Handler4099_io_in_mem_csr_address = E_M_Register2276_io_out_csr_address;
  assign CSR_Handler4099_io_in_mem_is_csr = E_M_Register2276_io_out_is_csr;
  assign CSR_Handler4099_io_in_mem_csr_result = E_M_Register2276_io_out_csr_result;
  assign orl4116 = Decode1224_io_out_branch_stall || Execute1950_io_out_branch_stall;
  assign orl4118 = orl4116 || Memory2971_io_out_branch_stall;
  assign eq4123 = Execute1950_io_out_branch_stall == 1'h1;
  assign orl4125 = eq4123 || Memory2971_io_out_branch_stall;
  assign orl4128 = Execute1950_io_out_branch_stall || Memory2971_io_out_branch_stall;
  assign orl4137 = Fetch390_io_out_delay || Memory2971_io_out_delay;

  assign io_IBUS_in_data_ready = Fetch390_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = Fetch390_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = Fetch390_io_IBUS_out_address_valid;
  assign io_DBUS_out_miss = Memory2971_io_DBUS_out_miss;
  assign io_DBUS_in_data_ready = Memory2971_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Memory2971_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Memory2971_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Memory2971_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Memory2971_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Memory2971_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Memory2971_io_DBUS_out_control_valid;
  assign io_INTERRUPT_in_interrupt_id_ready = Interrupt_Handler3675_io_INTERRUPT_in_interrupt_id_ready;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = JTAG4021_io_JTAG_JTAG_TAP_in_mode_select_ready;
  assign io_jtag_JTAG_TAP_in_clock_ready = JTAG4021_io_JTAG_JTAG_TAP_in_clock_ready;
  assign io_jtag_JTAG_TAP_in_reset_ready = JTAG4021_io_JTAG_JTAG_TAP_in_reset_ready;
  assign io_jtag_in_data_ready = JTAG4021_io_JTAG_in_data_ready;
  assign io_jtag_out_data_data = JTAG4021_io_JTAG_out_data_data;
  assign io_jtag_out_data_valid = JTAG4021_io_JTAG_out_data_valid;
  assign io_out_fwd_stall = Forwarding3567_io_out_fwd_stall;
  assign io_out_branch_stall = orl4118;

endmodule
