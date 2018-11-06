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
  input wire[31:0] io_in_branch_dest,
  input wire io_in_branch_stall,
  input wire io_in_fwd_stall,
  input wire io_in_branch_stall_exe,
  input wire io_in_jal,
  input wire[31:0] io_in_jal_dest,
  input wire io_in_interrupt,
  input wire[31:0] io_in_interrupt_pc,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg116;
  wire eq123, eq127, orl129, orl131, eq138, eq144;
  wire[31:0] sel134, sel140, sel146, sel148, add153, sel155;

  always @ (posedge clk) begin
    if (reset)
      reg116 <= 32'h0;
    else
      reg116 <= sel155;
  end
  assign eq123 = io_in_fwd_stall == 1'h1;
  assign eq127 = io_in_branch_stall == 1'h1;
  assign orl129 = eq127 | eq123;
  assign orl131 = orl129 | io_in_branch_stall_exe;
  assign sel134 = orl131 ? 32'h0 : io_IBUS_in_data_data;
  assign eq138 = io_in_branch_dir == 1'h1;
  assign sel140 = eq138 ? io_in_branch_dest : reg116;
  assign eq144 = io_in_jal == 1'h1;
  assign sel146 = eq144 ? io_in_jal_dest : sel140;
  assign sel148 = io_in_interrupt ? io_in_interrupt_pc : sel146;
  assign add153 = sel148 + 32'h4;
  assign sel155 = orl131 ? sel148 : add153;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_valid;
  assign io_IBUS_out_address_data = sel148;
  assign io_IBUS_out_address_valid = 1'h1;
  assign io_out_instruction = sel134;
  assign io_out_curr_PC = sel148;
  assign io_out_PC_next = add153;

endmodule

module F_D_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_branch_stall,
  input wire io_in_branch_stall_exe,
  input wire io_in_fwd_stall,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg238, reg247, reg253;
  wire eq274;
  wire[31:0] sel276, sel277, sel278;

  always @ (posedge clk) begin
    if (reset)
      reg238 <= 32'h0;
    else
      reg238 <= sel277;
  end
  always @ (posedge clk) begin
    if (reset)
      reg247 <= 32'h0;
    else
      reg247 <= sel278;
  end
  always @ (posedge clk) begin
    if (reset)
      reg253 <= 32'h0;
    else
      reg253 <= sel276;
  end
  assign eq274 = io_in_fwd_stall == 1'h0;
  assign sel276 = eq274 ? io_in_curr_PC : reg253;
  assign sel277 = eq274 ? io_in_instruction : reg238;
  assign sel278 = eq274 ? io_in_PC_next : reg247;

  assign io_out_instruction = reg238;
  assign io_out_curr_PC = reg253;
  assign io_out_PC_next = reg247;

endmodule

module RegisterFile(
  input wire clk,
  input wire reset,
  input wire io_in_write_register,
  input wire[4:0] io_in_rd,
  input wire[31:0] io_in_data,
  input wire[4:0] io_in_src1,
  input wire[4:0] io_in_src2,
  output wire[31:0] io_out_src1_data,
  output wire[31:0] io_out_src2_data
);
  reg[31:0] mem400 [0:31];
  reg reg408;
  wire eq413, sel417, ne431, andl434, sel436, eq445, eq454;
  wire[31:0] sel437, mrport440, sel447, mrport449, sel456;
  wire[4:0] sel438;

  always @ (posedge clk) begin
    if (sel436) begin
      mem400[sel438] <= sel437;
    end
  end
  assign mrport440 = mem400[io_in_src1];
  assign mrport449 = mem400[io_in_src2];
  always @ (posedge clk) begin
    if (reset)
      reg408 <= 1'h1;
    else
      reg408 <= sel417;
  end
  assign eq413 = reg408 == 1'h1;
  assign sel417 = eq413 ? 1'h0 : reg408;
  assign ne431 = io_in_rd != 5'h0;
  assign andl434 = io_in_write_register & ne431;
  assign sel436 = reg408 ? 1'h1 : andl434;
  assign sel437 = reg408 ? 32'h0 : io_in_data;
  assign sel438 = reg408 ? 5'h0 : io_in_rd;
  assign eq445 = io_in_src1 == 5'h0;
  assign sel447 = eq445 ? 32'h0 : mrport440;
  assign eq454 = io_in_src2 == 5'h0;
  assign sel456 = eq454 ? 32'h0 : mrport449;

  assign io_out_src1_data = sel447;
  assign io_out_src2_data = sel456;

endmodule

module Decode(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
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
  input wire[31:0] io_in_csr_data,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_data,
  output wire[31:0] io_out_csr_mask,
  output wire[31:0] io_actual_change,
  output wire[4:0] io_out_rd,
  output wire[4:0] io_out_rs1,
  output wire[31:0] io_out_rd1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_rd2,
  output wire[1:0] io_out_wb,
  output wire[3:0] io_out_alu_op,
  output wire io_out_rs2_src,
  output wire[11:0] io_out_itype_immed,
  output wire[2:0] io_out_mem_read,
  output wire[2:0] io_out_mem_write,
  output wire[2:0] io_out_branch_type,
  output wire io_out_branch_stall,
  output wire io_out_jal,
  output wire[31:0] io_out_jal_offset,
  output wire[19:0] io_out_upper_immed,
  output wire[31:0] io_out_PC_next
);
  wire bindin483, bindin485, bindin486, ne546, sel548, eq552, eq607, eq612, eq617, orl619, eq624, eq629, eq634, eq639, eq644, eq649, ne654, eq659, andl661, proxy664, eq665, andl668, eq672, andl678, eq682, eq690, eq700, orl708, orl710, orl712, orl714, andl716, andl723, orl730, orl732, andl734, orl741, sel743, andl754, eq771, eq776, orl778, proxy829, proxy830, lt863, proxy935, eq965, proxy992, eq993, sel1008, sel1009, sel1011, sel1012, sel1021, sel1022, eq1039, eq1076, eq1084, eq1092, orl1098, lt1116;
  wire[4:0] bindin489, bindin495, bindin498, sel568, proxy576, proxy583;
  wire[31:0] bindin492, bindout501, bindout504, shr564, shr573, shr580, shr587, shr594, sel684, sel686, sel692, pad694, sel696, sel702, shr834, shr939, proxy955, proxy961, sel967, proxy982, proxy988, sel995, sel1014, sel1015;
  wire[6:0] sel557, proxy597;
  wire[2:0] proxy590, sel750, sel756, sel1018, sel1019;
  wire[1:0] sel718, sel725, sel736, proxy1071;
  wire[11:0] proxy782, sel790, proxy808, proxy845, proxy977, sel1005, sel1006, sel1027, sel1028;
  wire[3:0] proxy837, sel1041, sel1044, sel1061, sel1078, sel1086, sel1094, sel1100, sel1102, sel1106, sel1110, sel1118, sel1120;
  wire[5:0] proxy843;
  wire[19:0] proxy906, sel1024, sel1025;
  wire[7:0] proxy934;
  wire[9:0] proxy942;
  wire[20:0] proxy946;
  reg[11:0] sel1007, sel1029;
  reg sel1010, sel1013, sel1023;
  reg[31:0] sel1016;
  reg[2:0] sel1017, sel1020;
  reg[19:0] sel1026;
  reg[3:0] sel1069;

  assign bindin483 = clk;
  assign bindin485 = reset;
  RegisterFile __module5__(.clk(bindin483), .reset(bindin485), .io_in_write_register(bindin486), .io_in_rd(bindin489), .io_in_data(bindin492), .io_in_src1(bindin495), .io_in_src2(bindin498), .io_out_src1_data(bindout501), .io_out_src2_data(bindout504));
  assign bindin486 = sel548;
  assign bindin489 = io_in_rd;
  assign bindin492 = io_in_write_data;
  assign bindin495 = proxy576;
  assign bindin498 = proxy583;
  assign ne546 = io_in_wb != 2'h0;
  assign sel548 = ne546 ? 1'h1 : 1'h0;
  assign eq552 = io_in_stall == 1'h0;
  assign sel557 = eq552 ? io_in_instruction[6:0] : 7'h0;
  assign shr564 = io_in_instruction >> 32'h7;
  assign sel568 = eq552 ? shr564[4:0] : 5'h0;
  assign shr573 = io_in_instruction >> 32'hf;
  assign proxy576 = shr573[4:0];
  assign shr580 = io_in_instruction >> 32'h14;
  assign proxy583 = shr580[4:0];
  assign shr587 = io_in_instruction >> 32'hc;
  assign proxy590 = shr587[2:0];
  assign shr594 = io_in_instruction >> 32'h19;
  assign proxy597 = shr594[6:0];
  assign eq607 = sel557 == 7'h33;
  assign eq612 = sel557 == 7'h3;
  assign eq617 = sel557 == 7'h13;
  assign orl619 = eq617 | eq612;
  assign eq624 = sel557 == 7'h23;
  assign eq629 = sel557 == 7'h63;
  assign eq634 = sel557 == 7'h6f;
  assign eq639 = sel557 == 7'h67;
  assign eq644 = sel557 == 7'h37;
  assign eq649 = sel557 == 7'h17;
  assign ne654 = proxy590 != 3'h0;
  assign eq659 = sel557 == 7'h73;
  assign andl661 = eq659 & ne654;
  assign proxy664 = proxy590[2];
  assign eq665 = proxy664 == 1'h1;
  assign andl668 = andl661 & eq665;
  assign eq672 = proxy590 == 3'h0;
  assign andl678 = eq659 & eq672;
  assign eq682 = io_in_src1_fwd == 1'h1;
  assign sel684 = eq682 ? io_in_src1_fwd_data : bindout501;
  assign sel686 = eq634 ? io_in_curr_PC : sel684;
  assign eq690 = io_in_src2_fwd == 1'h1;
  assign sel692 = eq690 ? io_in_src2_fwd_data : bindout504;
  assign pad694 = {{27{1'b0}}, proxy583};
  assign sel696 = andl668 ? pad694 : sel692;
  assign eq700 = io_in_csr_fwd == 1'h1;
  assign sel702 = eq700 ? io_in_csr_fwd_data : io_in_csr_data;
  assign orl708 = orl619 | eq607;
  assign orl710 = orl708 | eq644;
  assign orl712 = orl710 | eq649;
  assign orl714 = orl712 | andl661;
  assign andl716 = orl714 & eq552;
  assign sel718 = andl716 ? 2'h1 : 2'h0;
  assign andl723 = eq612 & eq552;
  assign sel725 = andl723 ? 2'h2 : sel718;
  assign orl730 = eq634 | eq639;
  assign orl732 = orl730 | andl678;
  assign andl734 = orl732 & eq552;
  assign sel736 = andl734 ? 2'h3 : sel725;
  assign orl741 = orl619 | eq624;
  assign sel743 = orl741 ? 1'h1 : 1'h0;
  assign sel750 = andl723 ? proxy590 : 3'h7;
  assign andl754 = eq624 & eq552;
  assign sel756 = andl754 ? proxy590 : 3'h7;
  assign eq771 = proxy590 == 3'h5;
  assign eq776 = proxy590 == 3'h1;
  assign orl778 = eq776 | eq771;
  assign proxy782 = {7'h0, proxy583};
  assign sel790 = orl778 ? proxy782 : shr580[11:0];
  assign proxy808 = {proxy597, sel568};
  assign proxy829 = io_in_instruction[31];
  assign proxy830 = io_in_instruction[7];
  assign shr834 = io_in_instruction >> 32'h8;
  assign proxy837 = shr834[3:0];
  assign proxy843 = shr594[5:0];
  assign proxy845 = {proxy829, proxy830, proxy843, proxy837};
  assign lt863 = shr580[11:0] < 12'h2;
  assign proxy906 = {proxy597, proxy583, proxy576, proxy590};
  assign proxy934 = shr587[7:0];
  assign proxy935 = io_in_instruction[20];
  assign shr939 = io_in_instruction >> 32'h15;
  assign proxy942 = shr939[9:0];
  assign proxy946 = {proxy829, proxy934, proxy935, proxy942, 1'h0};
  assign proxy955 = {11'h0, proxy946};
  assign proxy961 = {11'h7ff, proxy946};
  assign eq965 = proxy829 == 1'h1;
  assign sel967 = eq965 ? proxy961 : proxy955;
  assign proxy977 = {proxy597, proxy583};
  assign proxy982 = {20'h0, proxy977};
  assign proxy988 = {20'hfffff, proxy977};
  assign proxy992 = proxy977[11];
  assign eq993 = proxy992 == 1'h1;
  assign sel995 = eq993 ? proxy988 : proxy982;
  assign sel1005 = lt863 ? 12'h7b : 12'h7b;
  assign sel1006 = (proxy590 == 3'h0) ? sel1005 : 12'h7b;
  always @(*) begin
    case (sel557)
      7'h13: sel1007 = sel790;
      7'h33: sel1007 = 12'h7b;
      7'h23: sel1007 = proxy808;
      7'h03: sel1007 = shr580[11:0];
      7'h63: sel1007 = proxy845;
      7'h73: sel1007 = sel1006;
      7'h37: sel1007 = 12'h7b;
      7'h17: sel1007 = 12'h7b;
      7'h6f: sel1007 = 12'h7b;
      7'h67: sel1007 = 12'h7b;
      default: sel1007 = 12'h7b;
    endcase
  end
  assign sel1008 = lt863 ? 1'h0 : 1'h0;
  assign sel1009 = (proxy590 == 3'h0) ? sel1008 : 1'h0;
  always @(*) begin
    case (sel557)
      7'h13: sel1010 = 1'h0;
      7'h33: sel1010 = 1'h0;
      7'h23: sel1010 = 1'h0;
      7'h03: sel1010 = 1'h0;
      7'h63: sel1010 = 1'h1;
      7'h73: sel1010 = sel1009;
      7'h37: sel1010 = 1'h0;
      7'h17: sel1010 = 1'h0;
      7'h6f: sel1010 = 1'h1;
      7'h67: sel1010 = 1'h1;
      default: sel1010 = 1'h0;
    endcase
  end
  assign sel1011 = lt863 ? 1'h0 : 1'h1;
  assign sel1012 = (proxy590 == 3'h0) ? sel1011 : 1'h1;
  always @(*) begin
    case (sel557)
      7'h13: sel1013 = 1'h0;
      7'h33: sel1013 = 1'h0;
      7'h23: sel1013 = 1'h0;
      7'h03: sel1013 = 1'h0;
      7'h63: sel1013 = 1'h0;
      7'h73: sel1013 = sel1012;
      7'h37: sel1013 = 1'h0;
      7'h17: sel1013 = 1'h0;
      7'h6f: sel1013 = 1'h0;
      7'h67: sel1013 = 1'h0;
      default: sel1013 = 1'h0;
    endcase
  end
  assign sel1014 = lt863 ? 32'hb0000000 : 32'h7b;
  assign sel1015 = (proxy590 == 3'h0) ? sel1014 : 32'h7b;
  always @(*) begin
    case (sel557)
      7'h13: sel1016 = 32'h7b;
      7'h33: sel1016 = 32'h7b;
      7'h23: sel1016 = 32'h7b;
      7'h03: sel1016 = 32'h7b;
      7'h63: sel1016 = 32'h7b;
      7'h73: sel1016 = sel1015;
      7'h37: sel1016 = 32'h7b;
      7'h17: sel1016 = 32'h7b;
      7'h6f: sel1016 = sel967;
      7'h67: sel1016 = sel995;
      default: sel1016 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy590)
      3'h0: sel1017 = 3'h1;
      3'h1: sel1017 = 3'h2;
      3'h4: sel1017 = 3'h3;
      3'h5: sel1017 = 3'h4;
      3'h6: sel1017 = 3'h5;
      3'h7: sel1017 = 3'h6;
      default: sel1017 = 3'h0;
    endcase
  end
  assign sel1018 = lt863 ? 3'h0 : 3'h0;
  assign sel1019 = (proxy590 == 3'h0) ? sel1018 : 3'h0;
  always @(*) begin
    case (sel557)
      7'h13: sel1020 = 3'h0;
      7'h33: sel1020 = 3'h0;
      7'h23: sel1020 = 3'h0;
      7'h03: sel1020 = 3'h0;
      7'h63: sel1020 = sel1017;
      7'h73: sel1020 = sel1019;
      7'h37: sel1020 = 3'h0;
      7'h17: sel1020 = 3'h0;
      7'h6f: sel1020 = 3'h0;
      7'h67: sel1020 = 3'h0;
      default: sel1020 = 3'h0;
    endcase
  end
  assign sel1021 = lt863 ? 1'h1 : 1'h0;
  assign sel1022 = (proxy590 == 3'h0) ? sel1021 : 1'h0;
  always @(*) begin
    case (sel557)
      7'h13: sel1023 = 1'h0;
      7'h33: sel1023 = 1'h0;
      7'h23: sel1023 = 1'h0;
      7'h03: sel1023 = 1'h0;
      7'h63: sel1023 = 1'h0;
      7'h73: sel1023 = sel1022;
      7'h37: sel1023 = 1'h0;
      7'h17: sel1023 = 1'h0;
      7'h6f: sel1023 = 1'h1;
      7'h67: sel1023 = 1'h1;
      default: sel1023 = 1'h0;
    endcase
  end
  assign sel1024 = lt863 ? 20'h7b : 20'h7b;
  assign sel1025 = (proxy590 == 3'h0) ? sel1024 : 20'h7b;
  always @(*) begin
    case (sel557)
      7'h13: sel1026 = 20'h7b;
      7'h33: sel1026 = 20'h7b;
      7'h23: sel1026 = 20'h7b;
      7'h03: sel1026 = 20'h7b;
      7'h63: sel1026 = 20'h7b;
      7'h73: sel1026 = sel1025;
      7'h37: sel1026 = proxy906;
      7'h17: sel1026 = proxy906;
      7'h6f: sel1026 = 20'h7b;
      7'h67: sel1026 = 20'h7b;
      default: sel1026 = 20'h7b;
    endcase
  end
  assign sel1027 = lt863 ? 12'h7b : shr580[11:0];
  assign sel1028 = (proxy590 == 3'h0) ? sel1027 : shr580[11:0];
  always @(*) begin
    case (sel557)
      7'h13: sel1029 = 12'h7b;
      7'h33: sel1029 = 12'h7b;
      7'h23: sel1029 = 12'h7b;
      7'h03: sel1029 = 12'h7b;
      7'h63: sel1029 = 12'h7b;
      7'h73: sel1029 = sel1028;
      7'h37: sel1029 = 12'h7b;
      7'h17: sel1029 = 12'h7b;
      7'h6f: sel1029 = 12'h7b;
      7'h67: sel1029 = 12'h7b;
      default: sel1029 = 12'h7b;
    endcase
  end
  assign eq1039 = proxy597 == 7'h0;
  assign sel1041 = eq1039 ? 4'h0 : 4'h1;
  assign sel1044 = eq617 ? 4'h0 : sel1041;
  assign sel1061 = eq1039 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy590)
      3'h0: sel1069 = sel1044;
      3'h1: sel1069 = 4'h2;
      3'h2: sel1069 = 4'h3;
      3'h3: sel1069 = 4'h4;
      3'h4: sel1069 = 4'h5;
      3'h5: sel1069 = sel1061;
      3'h6: sel1069 = 4'h8;
      3'h7: sel1069 = 4'h9;
      default: sel1069 = 4'hf;
    endcase
  end
  assign proxy1071 = proxy590[1:0];
  assign eq1076 = proxy1071 == 2'h3;
  assign sel1078 = eq1076 ? 4'hf : 4'hf;
  assign eq1084 = proxy1071 == 2'h2;
  assign sel1086 = eq1084 ? 4'he : sel1078;
  assign eq1092 = proxy1071 == 2'h1;
  assign sel1094 = eq1092 ? 4'hd : sel1086;
  assign orl1098 = eq624 | eq612;
  assign sel1100 = orl1098 ? 4'h0 : sel1069;
  assign sel1102 = andl661 ? sel1094 : sel1100;
  assign sel1106 = eq649 ? 4'hc : sel1102;
  assign sel1110 = eq644 ? 4'hb : sel1106;
  assign lt1116 = sel1020 < 3'h5;
  assign sel1118 = lt1116 ? 4'h1 : 4'ha;
  assign sel1120 = eq629 ? sel1118 : sel1110;

  assign io_out_csr_address = sel1029;
  assign io_out_is_csr = sel1013;
  assign io_out_csr_data = sel702;
  assign io_out_csr_mask = sel696;
  assign io_actual_change = 32'h1;
  assign io_out_rd = sel568;
  assign io_out_rs1 = proxy576;
  assign io_out_rd1 = sel686;
  assign io_out_rs2 = proxy583;
  assign io_out_rd2 = sel692;
  assign io_out_wb = sel736;
  assign io_out_alu_op = sel1120;
  assign io_out_rs2_src = sel743;
  assign io_out_itype_immed = sel1007;
  assign io_out_mem_read = sel750;
  assign io_out_mem_write = sel756;
  assign io_out_branch_type = sel1020;
  assign io_out_branch_stall = sel1010;
  assign io_out_jal = sel1023;
  assign io_out_jal_offset = sel1016;
  assign io_out_upper_immed = sel1026;
  assign io_out_PC_next = io_in_PC_next;

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
  input wire[11:0] io_in_itype_immed,
  input wire[2:0] io_in_mem_read,
  input wire[2:0] io_in_mem_write,
  input wire[31:0] io_in_PC_next,
  input wire[2:0] io_in_branch_type,
  input wire io_in_fwd_stall,
  input wire io_in_branch_stall,
  input wire[19:0] io_in_upper_immed,
  input wire[11:0] io_in_csr_address,
  input wire io_in_is_csr,
  input wire[31:0] io_in_csr_data,
  input wire[31:0] io_in_csr_mask,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_jal,
  input wire[31:0] io_in_jal_offset,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_data,
  output wire[31:0] io_out_csr_mask,
  output wire[4:0] io_out_rd,
  output wire[4:0] io_out_rs1,
  output wire[31:0] io_out_rd1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_rd2,
  output wire[3:0] io_out_alu_op,
  output wire[1:0] io_out_wb,
  output wire io_out_rs2_src,
  output wire[11:0] io_out_itype_immed,
  output wire[2:0] io_out_mem_read,
  output wire[2:0] io_out_mem_write,
  output wire[2:0] io_out_branch_type,
  output wire[19:0] io_out_upper_immed,
  output wire[31:0] io_out_curr_PC,
  output wire io_out_jal,
  output wire[31:0] io_out_jal_offset,
  output wire[31:0] io_out_PC_next
);
  reg[4:0] reg1327, reg1336, reg1349;
  reg[31:0] reg1343, reg1355, reg1375, reg1434, reg1440, reg1446, reg1458;
  reg[3:0] reg1362;
  reg[1:0] reg1369;
  reg reg1382, reg1428, reg1452;
  reg[11:0] reg1389, reg1422;
  reg[2:0] reg1396, reg1402, reg1409;
  reg[19:0] reg1416;
  wire eq1462, eq1466, orl1468, sel1496, sel1518, sel1527;
  wire[4:0] sel1471, sel1474, sel1480;
  wire[31:0] sel1477, sel1483, sel1493, sel1521, sel1524, sel1530, sel1533;
  wire[3:0] sel1487;
  wire[1:0] sel1490;
  wire[11:0] sel1500, sel1515;
  wire[2:0] sel1503, sel1506, sel1509;
  wire[19:0] sel1512;

  always @ (posedge clk) begin
    if (reset)
      reg1327 <= 5'h0;
    else
      reg1327 <= sel1471;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1336 <= 5'h0;
    else
      reg1336 <= sel1474;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1343 <= 32'h0;
    else
      reg1343 <= sel1477;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1349 <= 5'h0;
    else
      reg1349 <= sel1480;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1355 <= 32'h0;
    else
      reg1355 <= sel1483;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1362 <= 4'h0;
    else
      reg1362 <= sel1487;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1369 <= 2'h0;
    else
      reg1369 <= sel1490;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1375 <= 32'h0;
    else
      reg1375 <= sel1493;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1382 <= 1'h0;
    else
      reg1382 <= sel1496;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1389 <= 12'h0;
    else
      reg1389 <= sel1500;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1396 <= 3'h7;
    else
      reg1396 <= sel1503;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1402 <= 3'h7;
    else
      reg1402 <= sel1506;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1409 <= 3'h0;
    else
      reg1409 <= sel1509;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1416 <= 20'h0;
    else
      reg1416 <= sel1512;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1422 <= 12'h0;
    else
      reg1422 <= sel1515;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1428 <= 1'h0;
    else
      reg1428 <= sel1518;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1434 <= 32'h0;
    else
      reg1434 <= sel1521;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1440 <= 32'h0;
    else
      reg1440 <= sel1524;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1446 <= 32'h0;
    else
      reg1446 <= sel1533;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1452 <= 1'h0;
    else
      reg1452 <= sel1527;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1458 <= 32'h0;
    else
      reg1458 <= sel1530;
  end
  assign eq1462 = io_in_branch_stall == 1'h1;
  assign eq1466 = io_in_fwd_stall == 1'h1;
  assign orl1468 = eq1466 | eq1462;
  assign sel1471 = orl1468 ? 5'h0 : io_in_rd;
  assign sel1474 = orl1468 ? 5'h0 : io_in_rs1;
  assign sel1477 = orl1468 ? 32'h0 : io_in_rd1;
  assign sel1480 = orl1468 ? 5'h0 : io_in_rs2;
  assign sel1483 = orl1468 ? 32'h0 : io_in_rd2;
  assign sel1487 = orl1468 ? 4'hf : io_in_alu_op;
  assign sel1490 = orl1468 ? 2'h0 : io_in_wb;
  assign sel1493 = orl1468 ? 32'h0 : io_in_PC_next;
  assign sel1496 = orl1468 ? 1'h0 : io_in_rs2_src;
  assign sel1500 = orl1468 ? 12'h7b : io_in_itype_immed;
  assign sel1503 = orl1468 ? 3'h7 : io_in_mem_read;
  assign sel1506 = orl1468 ? 3'h7 : io_in_mem_write;
  assign sel1509 = orl1468 ? 3'h0 : io_in_branch_type;
  assign sel1512 = orl1468 ? 20'h0 : io_in_upper_immed;
  assign sel1515 = orl1468 ? 12'h0 : io_in_csr_address;
  assign sel1518 = orl1468 ? 1'h0 : io_in_is_csr;
  assign sel1521 = orl1468 ? 32'h0 : io_in_csr_data;
  assign sel1524 = orl1468 ? 32'h0 : io_in_csr_mask;
  assign sel1527 = orl1468 ? 1'h0 : io_in_jal;
  assign sel1530 = orl1468 ? 32'h0 : io_in_jal_offset;
  assign sel1533 = orl1468 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1422;
  assign io_out_is_csr = reg1428;
  assign io_out_csr_data = reg1434;
  assign io_out_csr_mask = reg1440;
  assign io_out_rd = reg1327;
  assign io_out_rs1 = reg1336;
  assign io_out_rd1 = reg1343;
  assign io_out_rs2 = reg1349;
  assign io_out_rd2 = reg1355;
  assign io_out_alu_op = reg1362;
  assign io_out_wb = reg1369;
  assign io_out_rs2_src = reg1382;
  assign io_out_itype_immed = reg1389;
  assign io_out_mem_read = reg1396;
  assign io_out_mem_write = reg1402;
  assign io_out_branch_type = reg1409;
  assign io_out_upper_immed = reg1416;
  assign io_out_curr_PC = reg1446;
  assign io_out_jal = reg1452;
  assign io_out_jal_offset = reg1458;
  assign io_out_PC_next = reg1375;

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
  input wire[11:0] io_in_itype_immed,
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
  wire[31:0] proxy1745, proxy1751, sel1759, sel1766, proxy1771, add1774, add1777, sub1782, shl1786, sel1796, sel1805, xorl1810, shr1814, shr1819, orl1824, andl1829, add1842, orl1848, sub1852, andl1855, sel1860;
  wire eq1757, eq1764, lt1794, lt1803, ge1833, ne1868, sel1870;
  reg[31:0] sel1859, sel1861;

  assign proxy1745 = {20'h0, io_in_itype_immed};
  assign proxy1751 = {20'hfffff, io_in_itype_immed};
  assign eq1757 = io_in_itype_immed[11] == 1'h1;
  assign sel1759 = eq1757 ? proxy1751 : proxy1745;
  assign eq1764 = io_in_rs2_src == 1'h1;
  assign sel1766 = eq1764 ? sel1759 : io_in_rd2;
  assign proxy1771 = {io_in_upper_immed, 12'h0};
  assign add1774 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1777 = $signed(io_in_rd1) + $signed(sel1766);
  assign sub1782 = $signed(io_in_rd1) - $signed(sel1766);
  assign shl1786 = io_in_rd1 << sel1766;
  assign lt1794 = $signed(io_in_rd1) < $signed(sel1766);
  assign sel1796 = lt1794 ? 32'h1 : 32'h0;
  assign lt1803 = io_in_rd1 < sel1766;
  assign sel1805 = lt1803 ? 32'h1 : 32'h0;
  assign xorl1810 = io_in_rd1 ^ sel1766;
  assign shr1814 = io_in_rd1 >> sel1766;
  assign shr1819 = $signed(io_in_rd1) >> sel1766;
  assign orl1824 = io_in_rd1 | sel1766;
  assign andl1829 = sel1766 & io_in_rd1;
  assign ge1833 = io_in_rd1 >= sel1766;
  assign add1842 = $signed(io_in_curr_PC) + $signed(proxy1771);
  assign orl1848 = io_in_csr_data | io_in_csr_mask;
  assign sub1852 = 32'hffffffff - io_in_csr_mask;
  assign andl1855 = io_in_csr_data & sub1852;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1859 = 32'h7b;
      4'h1: sel1859 = 32'h7b;
      4'h2: sel1859 = 32'h7b;
      4'h3: sel1859 = 32'h7b;
      4'h4: sel1859 = 32'h7b;
      4'h5: sel1859 = 32'h7b;
      4'h6: sel1859 = 32'h7b;
      4'h7: sel1859 = 32'h7b;
      4'h8: sel1859 = 32'h7b;
      4'h9: sel1859 = 32'h7b;
      4'ha: sel1859 = 32'h7b;
      4'hb: sel1859 = 32'h7b;
      4'hc: sel1859 = 32'h7b;
      4'hd: sel1859 = io_in_csr_mask;
      4'he: sel1859 = orl1848;
      4'hf: sel1859 = andl1855;
      default: sel1859 = 32'h7b;
    endcase
  end
  assign sel1860 = ge1833 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1861 = add1777;
      4'h1: sel1861 = sub1782;
      4'h2: sel1861 = shl1786;
      4'h3: sel1861 = sel1796;
      4'h4: sel1861 = sel1805;
      4'h5: sel1861 = xorl1810;
      4'h6: sel1861 = shr1814;
      4'h7: sel1861 = shr1819;
      4'h8: sel1861 = orl1824;
      4'h9: sel1861 = andl1829;
      4'ha: sel1861 = sel1860;
      4'hb: sel1861 = proxy1771;
      4'hc: sel1861 = add1842;
      4'hd: sel1861 = io_in_csr_data;
      4'he: sel1861 = io_in_csr_data;
      4'hf: sel1861 = io_in_csr_data;
      default: sel1861 = 32'h0;
    endcase
  end
  assign ne1868 = io_in_branch_type != 3'h0;
  assign sel1870 = ne1868 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1859;
  assign io_out_alu_result = sel1861;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1774;
  assign io_out_branch_offset = sel1759;
  assign io_out_branch_stall = sel1870;
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
  reg[31:0] reg2057, reg2079, reg2091, reg2104, reg2137, reg2143, reg2149;
  reg[4:0] reg2067, reg2073, reg2085;
  reg[1:0] reg2098;
  reg[2:0] reg2111, reg2117, reg2155;
  reg[11:0] reg2124;
  reg reg2131;

  always @ (posedge clk) begin
    if (reset)
      reg2057 <= 32'h0;
    else
      reg2057 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2067 <= 5'h0;
    else
      reg2067 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2073 <= 5'h0;
    else
      reg2073 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2079 <= 32'h0;
    else
      reg2079 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2085 <= 5'h0;
    else
      reg2085 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2091 <= 32'h0;
    else
      reg2091 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2098 <= 2'h0;
    else
      reg2098 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2104 <= 32'h0;
    else
      reg2104 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2111 <= 3'h0;
    else
      reg2111 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2117 <= 3'h0;
    else
      reg2117 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2124 <= 12'h0;
    else
      reg2124 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2131 <= 1'h0;
    else
      reg2131 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2137 <= 32'h0;
    else
      reg2137 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2143 <= 32'h0;
    else
      reg2143 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2149 <= 32'h0;
    else
      reg2149 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2155 <= 3'h0;
    else
      reg2155 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg2124;
  assign io_out_is_csr = reg2131;
  assign io_out_csr_result = reg2137;
  assign io_out_alu_result = reg2057;
  assign io_out_rd = reg2067;
  assign io_out_wb = reg2098;
  assign io_out_rs1 = reg2073;
  assign io_out_rd1 = reg2079;
  assign io_out_rd2 = reg2091;
  assign io_out_rs2 = reg2085;
  assign io_out_mem_read = reg2111;
  assign io_out_mem_write = reg2117;
  assign io_out_curr_PC = reg2143;
  assign io_out_branch_offset = reg2149;
  assign io_out_branch_type = reg2155;
  assign io_out_PC_next = reg2104;

endmodule

module Cache(
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
  output wire[31:0] io_out_data
);
  wire lt2357, lt2360, orl2362, eq2370, eq2384, eq2388, andl2390, eq2411, eq2415, andl2417, orl2420, proxy2439, eq2440, proxy2459, eq2460;
  wire[1:0] sel2396, sel2400, sel2404;
  wire[7:0] proxy2429;
  wire[31:0] proxy2431, proxy2435, sel2442, proxy2451, proxy2455, sel2462;
  wire[15:0] proxy2449;
  reg[31:0] sel2482;

  assign lt2357 = io_in_mem_write < 3'h7;
  assign lt2360 = io_in_mem_read < 3'h7;
  assign orl2362 = lt2360 | lt2357;
  assign eq2370 = io_in_mem_write == 3'h2;
  assign eq2384 = io_in_mem_write == 3'h7;
  assign eq2388 = io_in_mem_read == 3'h7;
  assign andl2390 = eq2388 & eq2384;
  assign sel2396 = andl2390 ? 2'h0 : 2'h3;
  assign sel2400 = eq2370 ? 2'h2 : sel2396;
  assign sel2404 = lt2360 ? 2'h1 : sel2400;
  assign eq2411 = eq2370 == 1'h0;
  assign eq2415 = andl2390 == 1'h0;
  assign andl2417 = eq2415 & eq2411;
  assign orl2420 = lt2360 | andl2417;
  assign proxy2429 = io_DBUS_in_data_data[7:0];
  assign proxy2431 = {24'h0, proxy2429};
  assign proxy2435 = {24'hffffff, proxy2429};
  assign proxy2439 = proxy2429[7];
  assign eq2440 = proxy2439 == 1'h1;
  assign sel2442 = eq2440 ? proxy2435 : proxy2431;
  assign proxy2449 = io_DBUS_in_data_data[15:0];
  assign proxy2451 = {16'h0, proxy2449};
  assign proxy2455 = {16'hffff, proxy2449};
  assign proxy2459 = proxy2449[15];
  assign eq2460 = proxy2459 == 1'h1;
  assign sel2462 = eq2460 ? proxy2455 : proxy2451;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2482 = sel2442;
      3'h1: sel2482 = sel2462;
      3'h2: sel2482 = io_DBUS_in_data_data;
      3'h4: sel2482 = proxy2431;
      3'h5: sel2482 = proxy2451;
      default: sel2482 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2420;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2357;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2362;
  assign io_DBUS_out_control_data = sel2404;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2482;

endmodule

module Memory(
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
  output wire[31:0] io_out_PC_next
);
  wire[31:0] bindin2489, bindout2498, bindout2507, bindin2525, bindin2534, bindout2537, shl2540, add2542;
  wire bindin2492, bindout2495, bindout2501, bindin2504, bindout2510, bindin2513, bindout2519, bindin2522, eq2552, sel2554, sel2563, eq2570, sel2572, sel2581;
  wire[1:0] bindout2516;
  wire[2:0] bindin2528, bindin2531;
  reg sel2604;

  Cache __module10__(.io_DBUS_in_data_data(bindin2489), .io_DBUS_in_data_valid(bindin2492), .io_DBUS_out_data_ready(bindin2504), .io_DBUS_out_address_ready(bindin2513), .io_DBUS_out_control_ready(bindin2522), .io_in_address(bindin2525), .io_in_mem_read(bindin2528), .io_in_mem_write(bindin2531), .io_in_data(bindin2534), .io_DBUS_in_data_ready(bindout2495), .io_DBUS_out_data_data(bindout2498), .io_DBUS_out_data_valid(bindout2501), .io_DBUS_out_address_data(bindout2507), .io_DBUS_out_address_valid(bindout2510), .io_DBUS_out_control_data(bindout2516), .io_DBUS_out_control_valid(bindout2519), .io_out_data(bindout2537));
  assign bindin2489 = io_DBUS_in_data_data;
  assign bindin2492 = io_DBUS_in_data_valid;
  assign bindin2504 = io_DBUS_out_data_ready;
  assign bindin2513 = io_DBUS_out_address_ready;
  assign bindin2522 = io_DBUS_out_control_ready;
  assign bindin2525 = io_in_alu_result;
  assign bindin2528 = io_in_mem_read;
  assign bindin2531 = io_in_mem_write;
  assign bindin2534 = io_in_rd2;
  assign shl2540 = $signed(io_in_branch_offset) << 32'h1;
  assign add2542 = $signed(io_in_curr_PC) + $signed(shl2540);
  assign eq2552 = io_in_alu_result == 32'h0;
  assign sel2554 = eq2552 ? 1'h1 : 1'h0;
  assign sel2563 = eq2552 ? 1'h0 : 1'h1;
  assign eq2570 = io_in_alu_result[31] == 1'h0;
  assign sel2572 = eq2570 ? 1'h0 : 1'h1;
  assign sel2581 = eq2570 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2604 = sel2554;
      3'h2: sel2604 = sel2563;
      3'h3: sel2604 = sel2572;
      3'h4: sel2604 = sel2581;
      3'h5: sel2604 = sel2572;
      3'h6: sel2604 = sel2581;
      3'h0: sel2604 = 1'h0;
      default: sel2604 = 1'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = bindout2495;
  assign io_DBUS_out_data_data = bindout2498;
  assign io_DBUS_out_data_valid = bindout2501;
  assign io_DBUS_out_address_data = bindout2507;
  assign io_DBUS_out_address_valid = bindout2510;
  assign io_DBUS_out_control_data = bindout2516;
  assign io_DBUS_out_control_valid = bindout2519;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2537;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2604;
  assign io_out_branch_dest = add2542;
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
  reg[31:0] reg2742, reg2751, reg2783;
  reg[4:0] reg2758, reg2764, reg2770;
  reg[1:0] reg2777;

  always @ (posedge clk) begin
    if (reset)
      reg2742 <= 32'h0;
    else
      reg2742 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2751 <= 32'h0;
    else
      reg2751 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2758 <= 5'h0;
    else
      reg2758 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2764 <= 5'h0;
    else
      reg2764 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2770 <= 5'h0;
    else
      reg2770 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2777 <= 2'h0;
    else
      reg2777 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2783 <= 32'h0;
    else
      reg2783 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2742;
  assign io_out_mem_result = reg2751;
  assign io_out_rd = reg2758;
  assign io_out_wb = reg2777;
  assign io_out_rs1 = reg2764;
  assign io_out_rs2 = reg2770;
  assign io_out_PC_next = reg2783;

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
  wire eq2849, eq2854;
  wire[31:0] sel2856, sel2858;

  assign eq2849 = io_in_wb == 2'h3;
  assign eq2854 = io_in_wb == 2'h1;
  assign sel2856 = eq2854 ? io_in_alu_result : io_in_mem_result;
  assign sel2858 = eq2849 ? io_in_PC_next : sel2856;

  assign io_out_write_data = sel2858;
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
  output wire[31:0] io_out_src1_fwd_data,
  output wire io_out_src2_fwd,
  output wire[31:0] io_out_src2_fwd_data,
  output wire io_out_csr_fwd,
  output wire[31:0] io_out_csr_fwd_data,
  output wire io_out_fwd_stall
);
  wire eq2938, eq2942, eq2946, eq2951, eq2955, eq2959, eq2964, eq2968, ne2973, ne2978, eq2981, andl2983, andl2985, eq2990, ne2994, eq3001, andl3003, andl3005, andl3007, eq3011, ne3019, eq3026, andl3028, andl3030, andl3032, andl3034, orl3037, orl3039, ne3065, eq3068, andl3070, andl3072, eq3076, eq3087, andl3089, andl3091, andl3093, eq3097, eq3112, andl3114, andl3116, andl3118, andl3120, orl3123, orl3125, eq3145, andl3147, eq3151, eq3154, andl3156, andl3158, orl3161, orl3171, andl3173, sel3175;
  wire[31:0] sel3043, sel3045, sel3047, sel3049, sel3051, sel3053, sel3055, sel3057, sel3132, sel3138, sel3142, sel3164, sel3166;

  assign eq2938 = io_in_execute_wb == 2'h2;
  assign eq2942 = io_in_memory_wb == 2'h2;
  assign eq2946 = io_in_writeback_wb == 2'h2;
  assign eq2951 = io_in_execute_wb == 2'h3;
  assign eq2955 = io_in_memory_wb == 2'h3;
  assign eq2959 = io_in_writeback_wb == 2'h3;
  assign eq2964 = io_in_execute_is_csr == 1'h1;
  assign eq2968 = io_in_memory_is_csr == 1'h1;
  assign ne2973 = io_in_execute_wb != 2'h0;
  assign ne2978 = io_in_decode_src1 != 5'h0;
  assign eq2981 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2983 = eq2981 & ne2978;
  assign andl2985 = andl2983 & ne2973;
  assign eq2990 = andl2985 == 1'h0;
  assign ne2994 = io_in_memory_wb != 2'h0;
  assign eq3001 = io_in_decode_src1 == io_in_memory_dest;
  assign andl3003 = eq3001 & ne2978;
  assign andl3005 = andl3003 & ne2994;
  assign andl3007 = andl3005 & eq2990;
  assign eq3011 = andl3007 == 1'h0;
  assign ne3019 = io_in_writeback_wb != 2'h0;
  assign eq3026 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl3028 = eq3026 & ne2978;
  assign andl3030 = andl3028 & ne3019;
  assign andl3032 = andl3030 & eq2990;
  assign andl3034 = andl3032 & eq3011;
  assign orl3037 = andl2985 | andl3007;
  assign orl3039 = orl3037 | andl3034;
  assign sel3043 = eq2946 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel3045 = eq2959 ? io_in_writeback_PC_next : sel3043;
  assign sel3047 = andl3034 ? sel3045 : 32'h7b;
  assign sel3049 = eq2942 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel3051 = eq2955 ? io_in_memory_PC_next : sel3049;
  assign sel3053 = andl3007 ? sel3051 : sel3047;
  assign sel3055 = eq2951 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel3057 = andl2985 ? sel3055 : sel3053;
  assign ne3065 = io_in_decode_src2 != 5'h0;
  assign eq3068 = io_in_decode_src2 == io_in_execute_dest;
  assign andl3070 = eq3068 & ne3065;
  assign andl3072 = andl3070 & ne2973;
  assign eq3076 = andl3072 == 1'h0;
  assign eq3087 = io_in_decode_src2 == io_in_memory_dest;
  assign andl3089 = eq3087 & ne3065;
  assign andl3091 = andl3089 & ne2994;
  assign andl3093 = andl3091 & eq3076;
  assign eq3097 = andl3093 == 1'h0;
  assign eq3112 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl3114 = eq3112 & ne3065;
  assign andl3116 = andl3114 & ne3019;
  assign andl3118 = andl3116 & eq3076;
  assign andl3120 = andl3118 & eq3097;
  assign orl3123 = andl3072 | andl3093;
  assign orl3125 = orl3123 | andl3120;
  assign sel3132 = andl3120 ? sel3045 : 32'h7b;
  assign sel3138 = andl3093 ? sel3051 : sel3132;
  assign sel3142 = andl3072 ? sel3055 : sel3138;
  assign eq3145 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3147 = eq3145 & eq2964;
  assign eq3151 = andl3147 == 1'h0;
  assign eq3154 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3156 = eq3154 & eq2968;
  assign andl3158 = andl3156 & eq3151;
  assign orl3161 = andl3147 | andl3158;
  assign sel3164 = andl3158 ? io_in_memory_csr_result : 32'h7b;
  assign sel3166 = andl3147 ? io_in_execute_alu_result : sel3164;
  assign orl3171 = andl2985 | andl3072;
  assign andl3173 = orl3171 & eq2938;
  assign sel3175 = andl3173 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl3039;
  assign io_out_src1_fwd_data = sel3057;
  assign io_out_src2_fwd = orl3125;
  assign io_out_src2_fwd_data = sel3142;
  assign io_out_csr_fwd = orl3161;
  assign io_out_csr_fwd_data = sel3166;
  assign io_out_fwd_stall = sel3175;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3282 [0:1];
  wire[31:0] mrport3284;

  initial begin
    mem3282[0] = 32'hdeadbeef;
    mem3282[1] = 32'hdeadbeef;
  end
  assign mrport3284 = mem3282[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport3284;

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
  reg[3:0] reg3353, sel3443;
  wire eq3361, andl3446, eq3450, andl3454, eq3458, andl3462;
  wire[3:0] sel3367, sel3372, sel3378, sel3384, sel3394, sel3399, sel3403, sel3412, sel3418, sel3428, sel3433, sel3437, sel3444, sel3460, sel3461, sel3463;

  always @ (posedge clk) begin
    if (reset)
      reg3353 <= 4'h0;
    else
      reg3353 <= sel3463;
  end
  assign eq3361 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3367 = eq3361 ? 4'h0 : 4'h1;
  assign sel3372 = eq3361 ? 4'h2 : 4'h1;
  assign sel3378 = eq3361 ? 4'h9 : 4'h3;
  assign sel3384 = eq3361 ? 4'h5 : 4'h4;
  assign sel3394 = eq3361 ? 4'h8 : 4'h6;
  assign sel3399 = eq3361 ? 4'h7 : 4'h6;
  assign sel3403 = eq3361 ? 4'h4 : 4'h8;
  assign sel3412 = eq3361 ? 4'h0 : 4'ha;
  assign sel3418 = eq3361 ? 4'hc : 4'hb;
  assign sel3428 = eq3361 ? 4'hf : 4'hd;
  assign sel3433 = eq3361 ? 4'he : 4'hd;
  assign sel3437 = eq3361 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3353)
      4'h0: sel3443 = sel3367;
      4'h1: sel3443 = sel3372;
      4'h2: sel3443 = sel3378;
      4'h3: sel3443 = sel3384;
      4'h4: sel3443 = sel3384;
      4'h5: sel3443 = sel3394;
      4'h6: sel3443 = sel3399;
      4'h7: sel3443 = sel3403;
      4'h8: sel3443 = sel3372;
      4'h9: sel3443 = sel3412;
      4'ha: sel3443 = sel3418;
      4'hb: sel3443 = sel3418;
      4'hc: sel3443 = sel3428;
      4'hd: sel3443 = sel3433;
      4'he: sel3443 = sel3437;
      4'hf: sel3443 = sel3372;
      default: sel3443 = reg3353;
    endcase
  end
  assign sel3444 = io_JTAG_TAP_in_mode_select_valid ? sel3443 : 4'h0;
  assign andl3446 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3450 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3454 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3458 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3460 = eq3450 ? 4'h0 : reg3353;
  assign sel3461 = andl3462 ? sel3444 : reg3353;
  assign andl3462 = andl3454 & eq3458;
  assign sel3463 = andl3446 ? sel3460 : sel3461;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3353;

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
  wire bindin3469, bindin3471, bindin3472, bindin3475, bindout3478, bindin3481, bindin3484, bindout3487, bindin3490, bindin3493, bindout3496, eq3533, eq3542, eq3547, eq3624, andl3625, sel3627, sel3633;
  wire[3:0] bindout3499;
  reg[31:0] reg3507, reg3514, reg3521, reg3528, sel3626;
  wire[31:0] sel3550, sel3552, shr3559, proxy3564, sel3619, sel3620, sel3621, sel3622, sel3623;
  wire[30:0] proxy3562;
  reg sel3632, sel3638;

  assign bindin3469 = clk;
  assign bindin3471 = reset;
  TAP __module16__(.clk(bindin3469), .reset(bindin3471), .io_JTAG_TAP_in_mode_select_data(bindin3472), .io_JTAG_TAP_in_mode_select_valid(bindin3475), .io_JTAG_TAP_in_clock_data(bindin3481), .io_JTAG_TAP_in_clock_valid(bindin3484), .io_JTAG_TAP_in_reset_data(bindin3490), .io_JTAG_TAP_in_reset_valid(bindin3493), .io_JTAG_TAP_in_mode_select_ready(bindout3478), .io_JTAG_TAP_in_clock_ready(bindout3487), .io_JTAG_TAP_in_reset_ready(bindout3496), .io_out_curr_state(bindout3499));
  assign bindin3472 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3475 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3481 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3484 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3490 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3493 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3507 <= 32'h0;
    else
      reg3507 <= sel3619;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3514 <= 32'h1234;
    else
      reg3514 <= sel3622;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3521 <= 32'h5678;
    else
      reg3521 <= sel3623;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3528 <= 32'h0;
    else
      reg3528 <= sel3626;
  end
  assign eq3533 = reg3507 == 32'h0;
  assign eq3542 = reg3507 == 32'h1;
  assign eq3547 = reg3507 == 32'h2;
  assign sel3550 = eq3547 ? reg3514 : 32'hdeadbeef;
  assign sel3552 = eq3542 ? reg3521 : sel3550;
  assign shr3559 = reg3528 >> 32'h1;
  assign proxy3562 = shr3559[30:0];
  assign proxy3564 = {io_JTAG_in_data_data, proxy3562};
  assign sel3619 = (bindout3499 == 4'hf) ? reg3528 : reg3507;
  assign sel3620 = eq3547 ? reg3528 : reg3514;
  assign sel3621 = eq3542 ? reg3514 : sel3620;
  assign sel3622 = (bindout3499 == 4'h8) ? sel3621 : reg3514;
  assign sel3623 = andl3625 ? reg3528 : reg3521;
  assign eq3624 = bindout3499 == 4'h8;
  assign andl3625 = eq3624 & eq3542;
  always @(*) begin
    case (bindout3499)
      4'h3: sel3626 = sel3552;
      4'h4: sel3626 = proxy3564;
      4'ha: sel3626 = reg3507;
      4'hb: sel3626 = proxy3564;
      default: sel3626 = reg3528;
    endcase
  end
  assign sel3627 = eq3533 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3499)
      4'h3: sel3632 = sel3627;
      4'h4: sel3632 = 1'h1;
      4'h8: sel3632 = sel3627;
      4'ha: sel3632 = sel3627;
      4'hb: sel3632 = 1'h1;
      4'hf: sel3632 = sel3627;
      default: sel3632 = sel3627;
    endcase
  end
  assign sel3633 = eq3533 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3499)
      4'h3: sel3638 = sel3633;
      4'h4: sel3638 = reg3528[0];
      4'h8: sel3638 = sel3633;
      4'ha: sel3638 = sel3633;
      4'hb: sel3638 = reg3528[0];
      4'hf: sel3638 = sel3633;
      default: sel3638 = sel3633;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3478;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3487;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3496;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3638;
  assign io_JTAG_out_data_valid = sel3632;

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
  reg[31:0] mem3694 [0:4095];
  reg[1:0] reg3703, sel3737;
  wire eq3715, eq3719, eq3735;
  reg sel3738;
  reg[31:0] sel3739;
  reg[11:0] sel3740;
  wire[31:0] mrport3742;

  always @ (posedge clk) begin
    if (sel3738) begin
      mem3694[sel3740] <= sel3739;
    end
  end
  assign mrport3742 = mem3694[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (reset)
      reg3703 <= 2'h0;
    else
      reg3703 <= sel3737;
  end
  assign eq3715 = reg3703 == 2'h1;
  assign eq3719 = reg3703 == 2'h0;
  assign eq3735 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3719)
      sel3737 = 2'h1;
    else if (eq3715)
      sel3737 = 2'h3;
    else
      sel3737 = reg3703;
  end
  always @(*) begin
    if (eq3719)
      sel3738 = 1'h1;
    else if (eq3715)
      sel3738 = 1'h1;
    else
      sel3738 = eq3735;
  end
  always @(*) begin
    if (eq3719)
      sel3739 = 32'h0;
    else if (eq3715)
      sel3739 = 32'h0;
    else
      sel3739 = io_in_mem_csr_result;
  end
  always @(*) begin
    if (eq3719)
      sel3740 = 12'hf14;
    else if (eq3715)
      sel3740 = 12'h301;
    else
      sel3740 = io_in_mem_csr_address;
  end

  assign io_out_decode_csr_data = mrport3742;

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
  output wire io_out_fwd_stall,
  output wire io_out_branch_stall,
  output wire[31:0] io_actual_change
);
  wire bindin162, bindin164, bindin168, bindout171, bindout177, bindin180, bindin183, bindin189, bindin192, bindin195, bindin198, bindin204, bindin282, bindin283, bindin293, bindin296, bindin299, bindin1127, bindin1128, bindin1138, bindin1150, bindin1156, bindin1162, bindout1174, bindout1207, bindout1222, bindout1225, bindin1538, bindin1539, bindin1561, bindin1579, bindin1582, bindin1591, bindin1603, bindout1612, bindout1642, bindout1663, bindin1896, bindin1920, bindin1929, bindout1941, bindout1974, bindout1983, bindin2160, bindin2161, bindin2195, bindout2213, bindin2611, bindout2614, bindout2620, bindin2623, bindout2629, bindin2632, bindout2638, bindin2641, bindout2701, bindin2788, bindin2789, bindin3204, bindin3228, bindout3252, bindout3258, bindout3264, bindout3270, bindin3289, bindin3292, bindout3295, bindout3298, bindin3642, bindin3643, bindin3644, bindin3647, bindout3650, bindin3653, bindin3656, bindout3659, bindin3662, bindin3665, bindout3668, bindin3671, bindin3674, bindout3677, bindout3680, bindout3683, bindin3686, bindin3747, bindin3748, bindin3755, orl3763, eq3768, eq3772, orl3774;
  wire[31:0] bindin165, bindout174, bindin186, bindin201, bindin207, bindout210, bindout213, bindout216, bindin284, bindin287, bindin290, bindout302, bindout305, bindout308, bindin1129, bindin1132, bindin1135, bindin1141, bindin1153, bindin1159, bindin1165, bindin1168, bindout1177, bindout1180, bindout1183, bindout1192, bindout1198, bindout1228, bindout1234, bindin1546, bindin1552, bindin1573, bindin1594, bindin1597, bindin1600, bindin1606, bindout1615, bindout1618, bindout1627, bindout1633, bindout1660, bindout1666, bindout1669, bindin1881, bindin1887, bindin1908, bindin1923, bindin1926, bindin1932, bindin1935, bindout1944, bindout1947, bindout1959, bindout1965, bindout1977, bindout1980, bindout1986, bindin2162, bindin2174, bindin2180, bindin2189, bindin2198, bindin2201, bindin2204, bindout2216, bindout2219, bindout2231, bindout2234, bindout2246, bindout2249, bindout2255, bindin2608, bindout2617, bindout2626, bindin2644, bindin2662, bindin2668, bindin2671, bindin2674, bindin2677, bindout2683, bindout2686, bindout2704, bindout2707, bindin2790, bindin2793, bindin2808, bindout2811, bindout2814, bindout2829, bindin2863, bindin2866, bindin2881, bindout2884, bindin3198, bindin3201, bindin3210, bindin3219, bindin3222, bindin3225, bindin3234, bindin3243, bindin3246, bindin3249, bindout3255, bindout3261, bindout3267, bindout3301, bindin3758, bindout3761;
  wire[4:0] bindin1144, bindout1186, bindout1189, bindout1195, bindin1540, bindin1543, bindin1549, bindout1621, bindout1624, bindout1630, bindin1875, bindin1878, bindin1884, bindout1950, bindout1956, bindout1962, bindin2165, bindin2171, bindin2177, bindout2222, bindout2228, bindout2237, bindin2653, bindin2659, bindin2665, bindout2689, bindout2695, bindout2698, bindin2796, bindin2802, bindin2805, bindout2817, bindout2823, bindout2826, bindin2869, bindin2875, bindin2878, bindout2887, bindin3183, bindin3186, bindin3192, bindin3213, bindin3237;
  wire[1:0] bindin1147, bindout1201, bindin1558, bindout1639, bindin1893, bindout1953, bindin2168, bindout2225, bindout2635, bindin2656, bindout2692, bindin2799, bindout2820, bindin2872, bindout2890, bindin3195, bindin3216, bindin3240;
  wire[11:0] bindout1171, bindout1210, bindin1564, bindin1588, bindout1609, bindout1645, bindin1899, bindin1917, bindout1938, bindin2192, bindout2210, bindin3189, bindin3207, bindin3231, bindin3749, bindin3752;
  wire[3:0] bindout1204, bindin1555, bindout1636, bindin1890;
  wire[2:0] bindout1213, bindout1216, bindout1219, bindin1567, bindin1570, bindin1576, bindout1648, bindout1651, bindout1654, bindin1902, bindin1905, bindin1911, bindout1968, bindout1971, bindin2183, bindin2186, bindin2207, bindout2240, bindout2243, bindout2252, bindin2647, bindin2650, bindin2680;
  wire[19:0] bindout1231, bindin1585, bindout1657, bindin1914;

  assign bindin162 = clk;
  assign bindin164 = reset;
  Fetch __module2__(.clk(bindin162), .reset(bindin164), .io_IBUS_in_data_data(bindin165), .io_IBUS_in_data_valid(bindin168), .io_IBUS_out_address_ready(bindin180), .io_in_branch_dir(bindin183), .io_in_branch_dest(bindin186), .io_in_branch_stall(bindin189), .io_in_fwd_stall(bindin192), .io_in_branch_stall_exe(bindin195), .io_in_jal(bindin198), .io_in_jal_dest(bindin201), .io_in_interrupt(bindin204), .io_in_interrupt_pc(bindin207), .io_IBUS_in_data_ready(bindout171), .io_IBUS_out_address_data(bindout174), .io_IBUS_out_address_valid(bindout177), .io_out_instruction(bindout210), .io_out_curr_PC(bindout213), .io_out_PC_next(bindout216));
  assign bindin165 = io_IBUS_in_data_data;
  assign bindin168 = io_IBUS_in_data_valid;
  assign bindin180 = io_IBUS_out_address_ready;
  assign bindin183 = bindout2701;
  assign bindin186 = bindout2704;
  assign bindin189 = bindout1222;
  assign bindin192 = bindout3270;
  assign bindin195 = bindout1983;
  assign bindin198 = bindout1974;
  assign bindin201 = bindout1977;
  assign bindin204 = bindout3298;
  assign bindin207 = bindout3301;
  assign bindin282 = clk;
  assign bindin283 = reset;
  F_D_Register __module3__(.clk(bindin282), .reset(bindin283), .io_in_instruction(bindin284), .io_in_PC_next(bindin287), .io_in_curr_PC(bindin290), .io_in_branch_stall(bindin293), .io_in_branch_stall_exe(bindin296), .io_in_fwd_stall(bindin299), .io_out_instruction(bindout302), .io_out_curr_PC(bindout305), .io_out_PC_next(bindout308));
  assign bindin284 = bindout210;
  assign bindin287 = bindout216;
  assign bindin290 = bindout213;
  assign bindin293 = bindout1222;
  assign bindin296 = bindout1983;
  assign bindin299 = bindout3270;
  assign bindin1127 = clk;
  assign bindin1128 = reset;
  Decode __module4__(.clk(bindin1127), .reset(bindin1128), .io_in_instruction(bindin1129), .io_in_PC_next(bindin1132), .io_in_curr_PC(bindin1135), .io_in_stall(bindin1138), .io_in_write_data(bindin1141), .io_in_rd(bindin1144), .io_in_wb(bindin1147), .io_in_src1_fwd(bindin1150), .io_in_src1_fwd_data(bindin1153), .io_in_src2_fwd(bindin1156), .io_in_src2_fwd_data(bindin1159), .io_in_csr_fwd(bindin1162), .io_in_csr_fwd_data(bindin1165), .io_in_csr_data(bindin1168), .io_out_csr_address(bindout1171), .io_out_is_csr(bindout1174), .io_out_csr_data(bindout1177), .io_out_csr_mask(bindout1180), .io_actual_change(bindout1183), .io_out_rd(bindout1186), .io_out_rs1(bindout1189), .io_out_rd1(bindout1192), .io_out_rs2(bindout1195), .io_out_rd2(bindout1198), .io_out_wb(bindout1201), .io_out_alu_op(bindout1204), .io_out_rs2_src(bindout1207), .io_out_itype_immed(bindout1210), .io_out_mem_read(bindout1213), .io_out_mem_write(bindout1216), .io_out_branch_type(bindout1219), .io_out_branch_stall(bindout1222), .io_out_jal(bindout1225), .io_out_jal_offset(bindout1228), .io_out_upper_immed(bindout1231), .io_out_PC_next(bindout1234));
  assign bindin1129 = bindout302;
  assign bindin1132 = bindout308;
  assign bindin1135 = bindout305;
  assign bindin1138 = orl3774;
  assign bindin1141 = bindout2884;
  assign bindin1144 = bindout2887;
  assign bindin1147 = bindout2890;
  assign bindin1150 = bindout3252;
  assign bindin1153 = bindout3255;
  assign bindin1156 = bindout3258;
  assign bindin1159 = bindout3261;
  assign bindin1162 = bindout3264;
  assign bindin1165 = bindout3267;
  assign bindin1168 = bindout3761;
  assign bindin1538 = clk;
  assign bindin1539 = reset;
  D_E_Register __module6__(.clk(bindin1538), .reset(bindin1539), .io_in_rd(bindin1540), .io_in_rs1(bindin1543), .io_in_rd1(bindin1546), .io_in_rs2(bindin1549), .io_in_rd2(bindin1552), .io_in_alu_op(bindin1555), .io_in_wb(bindin1558), .io_in_rs2_src(bindin1561), .io_in_itype_immed(bindin1564), .io_in_mem_read(bindin1567), .io_in_mem_write(bindin1570), .io_in_PC_next(bindin1573), .io_in_branch_type(bindin1576), .io_in_fwd_stall(bindin1579), .io_in_branch_stall(bindin1582), .io_in_upper_immed(bindin1585), .io_in_csr_address(bindin1588), .io_in_is_csr(bindin1591), .io_in_csr_data(bindin1594), .io_in_csr_mask(bindin1597), .io_in_curr_PC(bindin1600), .io_in_jal(bindin1603), .io_in_jal_offset(bindin1606), .io_out_csr_address(bindout1609), .io_out_is_csr(bindout1612), .io_out_csr_data(bindout1615), .io_out_csr_mask(bindout1618), .io_out_rd(bindout1621), .io_out_rs1(bindout1624), .io_out_rd1(bindout1627), .io_out_rs2(bindout1630), .io_out_rd2(bindout1633), .io_out_alu_op(bindout1636), .io_out_wb(bindout1639), .io_out_rs2_src(bindout1642), .io_out_itype_immed(bindout1645), .io_out_mem_read(bindout1648), .io_out_mem_write(bindout1651), .io_out_branch_type(bindout1654), .io_out_upper_immed(bindout1657), .io_out_curr_PC(bindout1660), .io_out_jal(bindout1663), .io_out_jal_offset(bindout1666), .io_out_PC_next(bindout1669));
  assign bindin1540 = bindout1186;
  assign bindin1543 = bindout1189;
  assign bindin1546 = bindout1192;
  assign bindin1549 = bindout1195;
  assign bindin1552 = bindout1198;
  assign bindin1555 = bindout1204;
  assign bindin1558 = bindout1201;
  assign bindin1561 = bindout1207;
  assign bindin1564 = bindout1210;
  assign bindin1567 = bindout1213;
  assign bindin1570 = bindout1216;
  assign bindin1573 = bindout1234;
  assign bindin1576 = bindout1219;
  assign bindin1579 = bindout3270;
  assign bindin1582 = bindout1983;
  assign bindin1585 = bindout1231;
  assign bindin1588 = bindout1171;
  assign bindin1591 = bindout1174;
  assign bindin1594 = bindout1177;
  assign bindin1597 = bindout1180;
  assign bindin1600 = bindout305;
  assign bindin1603 = bindout1225;
  assign bindin1606 = bindout1228;
  Execute __module7__(.io_in_rd(bindin1875), .io_in_rs1(bindin1878), .io_in_rd1(bindin1881), .io_in_rs2(bindin1884), .io_in_rd2(bindin1887), .io_in_alu_op(bindin1890), .io_in_wb(bindin1893), .io_in_rs2_src(bindin1896), .io_in_itype_immed(bindin1899), .io_in_mem_read(bindin1902), .io_in_mem_write(bindin1905), .io_in_PC_next(bindin1908), .io_in_branch_type(bindin1911), .io_in_upper_immed(bindin1914), .io_in_csr_address(bindin1917), .io_in_is_csr(bindin1920), .io_in_csr_data(bindin1923), .io_in_csr_mask(bindin1926), .io_in_jal(bindin1929), .io_in_jal_offset(bindin1932), .io_in_curr_PC(bindin1935), .io_out_csr_address(bindout1938), .io_out_is_csr(bindout1941), .io_out_csr_result(bindout1944), .io_out_alu_result(bindout1947), .io_out_rd(bindout1950), .io_out_wb(bindout1953), .io_out_rs1(bindout1956), .io_out_rd1(bindout1959), .io_out_rs2(bindout1962), .io_out_rd2(bindout1965), .io_out_mem_read(bindout1968), .io_out_mem_write(bindout1971), .io_out_jal(bindout1974), .io_out_jal_dest(bindout1977), .io_out_branch_offset(bindout1980), .io_out_branch_stall(bindout1983), .io_out_PC_next(bindout1986));
  assign bindin1875 = bindout1621;
  assign bindin1878 = bindout1624;
  assign bindin1881 = bindout1627;
  assign bindin1884 = bindout1630;
  assign bindin1887 = bindout1633;
  assign bindin1890 = bindout1636;
  assign bindin1893 = bindout1639;
  assign bindin1896 = bindout1642;
  assign bindin1899 = bindout1645;
  assign bindin1902 = bindout1648;
  assign bindin1905 = bindout1651;
  assign bindin1908 = bindout1669;
  assign bindin1911 = bindout1654;
  assign bindin1914 = bindout1657;
  assign bindin1917 = bindout1609;
  assign bindin1920 = bindout1612;
  assign bindin1923 = bindout1615;
  assign bindin1926 = bindout1618;
  assign bindin1929 = bindout1663;
  assign bindin1932 = bindout1666;
  assign bindin1935 = bindout1660;
  assign bindin2160 = clk;
  assign bindin2161 = reset;
  E_M_Register __module8__(.clk(bindin2160), .reset(bindin2161), .io_in_alu_result(bindin2162), .io_in_rd(bindin2165), .io_in_wb(bindin2168), .io_in_rs1(bindin2171), .io_in_rd1(bindin2174), .io_in_rs2(bindin2177), .io_in_rd2(bindin2180), .io_in_mem_read(bindin2183), .io_in_mem_write(bindin2186), .io_in_PC_next(bindin2189), .io_in_csr_address(bindin2192), .io_in_is_csr(bindin2195), .io_in_csr_result(bindin2198), .io_in_curr_PC(bindin2201), .io_in_branch_offset(bindin2204), .io_in_branch_type(bindin2207), .io_out_csr_address(bindout2210), .io_out_is_csr(bindout2213), .io_out_csr_result(bindout2216), .io_out_alu_result(bindout2219), .io_out_rd(bindout2222), .io_out_wb(bindout2225), .io_out_rs1(bindout2228), .io_out_rd1(bindout2231), .io_out_rd2(bindout2234), .io_out_rs2(bindout2237), .io_out_mem_read(bindout2240), .io_out_mem_write(bindout2243), .io_out_curr_PC(bindout2246), .io_out_branch_offset(bindout2249), .io_out_branch_type(bindout2252), .io_out_PC_next(bindout2255));
  assign bindin2162 = bindout1947;
  assign bindin2165 = bindout1950;
  assign bindin2168 = bindout1953;
  assign bindin2171 = bindout1956;
  assign bindin2174 = bindout1959;
  assign bindin2177 = bindout1962;
  assign bindin2180 = bindout1965;
  assign bindin2183 = bindout1968;
  assign bindin2186 = bindout1971;
  assign bindin2189 = bindout1986;
  assign bindin2192 = bindout1938;
  assign bindin2195 = bindout1941;
  assign bindin2198 = bindout1944;
  assign bindin2201 = bindout1660;
  assign bindin2204 = bindout1980;
  assign bindin2207 = bindout1654;
  Memory __module9__(.io_DBUS_in_data_data(bindin2608), .io_DBUS_in_data_valid(bindin2611), .io_DBUS_out_data_ready(bindin2623), .io_DBUS_out_address_ready(bindin2632), .io_DBUS_out_control_ready(bindin2641), .io_in_alu_result(bindin2644), .io_in_mem_read(bindin2647), .io_in_mem_write(bindin2650), .io_in_rd(bindin2653), .io_in_wb(bindin2656), .io_in_rs1(bindin2659), .io_in_rd1(bindin2662), .io_in_rs2(bindin2665), .io_in_rd2(bindin2668), .io_in_PC_next(bindin2671), .io_in_curr_PC(bindin2674), .io_in_branch_offset(bindin2677), .io_in_branch_type(bindin2680), .io_DBUS_in_data_ready(bindout2614), .io_DBUS_out_data_data(bindout2617), .io_DBUS_out_data_valid(bindout2620), .io_DBUS_out_address_data(bindout2626), .io_DBUS_out_address_valid(bindout2629), .io_DBUS_out_control_data(bindout2635), .io_DBUS_out_control_valid(bindout2638), .io_out_alu_result(bindout2683), .io_out_mem_result(bindout2686), .io_out_rd(bindout2689), .io_out_wb(bindout2692), .io_out_rs1(bindout2695), .io_out_rs2(bindout2698), .io_out_branch_dir(bindout2701), .io_out_branch_dest(bindout2704), .io_out_PC_next(bindout2707));
  assign bindin2608 = io_DBUS_in_data_data;
  assign bindin2611 = io_DBUS_in_data_valid;
  assign bindin2623 = io_DBUS_out_data_ready;
  assign bindin2632 = io_DBUS_out_address_ready;
  assign bindin2641 = io_DBUS_out_control_ready;
  assign bindin2644 = bindout2219;
  assign bindin2647 = bindout2240;
  assign bindin2650 = bindout2243;
  assign bindin2653 = bindout2222;
  assign bindin2656 = bindout2225;
  assign bindin2659 = bindout2228;
  assign bindin2662 = bindout2231;
  assign bindin2665 = bindout2237;
  assign bindin2668 = bindout2234;
  assign bindin2671 = bindout2255;
  assign bindin2674 = bindout2246;
  assign bindin2677 = bindout2249;
  assign bindin2680 = bindout2252;
  assign bindin2788 = clk;
  assign bindin2789 = reset;
  M_W_Register __module11__(.clk(bindin2788), .reset(bindin2789), .io_in_alu_result(bindin2790), .io_in_mem_result(bindin2793), .io_in_rd(bindin2796), .io_in_wb(bindin2799), .io_in_rs1(bindin2802), .io_in_rs2(bindin2805), .io_in_PC_next(bindin2808), .io_out_alu_result(bindout2811), .io_out_mem_result(bindout2814), .io_out_rd(bindout2817), .io_out_wb(bindout2820), .io_out_rs1(bindout2823), .io_out_rs2(bindout2826), .io_out_PC_next(bindout2829));
  assign bindin2790 = bindout2683;
  assign bindin2793 = bindout2686;
  assign bindin2796 = bindout2689;
  assign bindin2799 = bindout2692;
  assign bindin2802 = bindout2695;
  assign bindin2805 = bindout2698;
  assign bindin2808 = bindout2707;
  Write_Back __module12__(.io_in_alu_result(bindin2863), .io_in_mem_result(bindin2866), .io_in_rd(bindin2869), .io_in_wb(bindin2872), .io_in_rs1(bindin2875), .io_in_rs2(bindin2878), .io_in_PC_next(bindin2881), .io_out_write_data(bindout2884), .io_out_rd(bindout2887), .io_out_wb(bindout2890));
  assign bindin2863 = bindout2811;
  assign bindin2866 = bindout2814;
  assign bindin2869 = bindout2817;
  assign bindin2872 = bindout2820;
  assign bindin2875 = bindout2823;
  assign bindin2878 = bindout2826;
  assign bindin2881 = bindout2829;
  Forwarding __module13__(.io_in_decode_src1(bindin3183), .io_in_decode_src2(bindin3186), .io_in_decode_csr_address(bindin3189), .io_in_execute_dest(bindin3192), .io_in_execute_wb(bindin3195), .io_in_execute_alu_result(bindin3198), .io_in_execute_PC_next(bindin3201), .io_in_execute_is_csr(bindin3204), .io_in_execute_csr_address(bindin3207), .io_in_execute_csr_result(bindin3210), .io_in_memory_dest(bindin3213), .io_in_memory_wb(bindin3216), .io_in_memory_alu_result(bindin3219), .io_in_memory_mem_data(bindin3222), .io_in_memory_PC_next(bindin3225), .io_in_memory_is_csr(bindin3228), .io_in_memory_csr_address(bindin3231), .io_in_memory_csr_result(bindin3234), .io_in_writeback_dest(bindin3237), .io_in_writeback_wb(bindin3240), .io_in_writeback_alu_result(bindin3243), .io_in_writeback_mem_data(bindin3246), .io_in_writeback_PC_next(bindin3249), .io_out_src1_fwd(bindout3252), .io_out_src1_fwd_data(bindout3255), .io_out_src2_fwd(bindout3258), .io_out_src2_fwd_data(bindout3261), .io_out_csr_fwd(bindout3264), .io_out_csr_fwd_data(bindout3267), .io_out_fwd_stall(bindout3270));
  assign bindin3183 = bindout1189;
  assign bindin3186 = bindout1195;
  assign bindin3189 = bindout1171;
  assign bindin3192 = bindout1950;
  assign bindin3195 = bindout1953;
  assign bindin3198 = bindout1947;
  assign bindin3201 = bindout1986;
  assign bindin3204 = bindout1941;
  assign bindin3207 = bindout1938;
  assign bindin3210 = bindout1944;
  assign bindin3213 = bindout2689;
  assign bindin3216 = bindout2692;
  assign bindin3219 = bindout2683;
  assign bindin3222 = bindout2686;
  assign bindin3225 = bindout2707;
  assign bindin3228 = bindout2213;
  assign bindin3231 = bindout2210;
  assign bindin3234 = bindout2216;
  assign bindin3237 = bindout2817;
  assign bindin3240 = bindout2820;
  assign bindin3243 = bindout2811;
  assign bindin3246 = bindout2814;
  assign bindin3249 = bindout2829;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3289), .io_INTERRUPT_in_interrupt_id_valid(bindin3292), .io_INTERRUPT_in_interrupt_id_ready(bindout3295), .io_out_interrupt(bindout3298), .io_out_interrupt_pc(bindout3301));
  assign bindin3289 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3292 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3642 = clk;
  assign bindin3643 = reset;
  JTAG __module15__(.clk(bindin3642), .reset(bindin3643), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3644), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3647), .io_JTAG_JTAG_TAP_in_clock_data(bindin3653), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3656), .io_JTAG_JTAG_TAP_in_reset_data(bindin3662), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3665), .io_JTAG_in_data_data(bindin3671), .io_JTAG_in_data_valid(bindin3674), .io_JTAG_out_data_ready(bindin3686), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3650), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3659), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3668), .io_JTAG_in_data_ready(bindout3677), .io_JTAG_out_data_data(bindout3680), .io_JTAG_out_data_valid(bindout3683));
  assign bindin3644 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3647 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3653 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3656 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3662 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3665 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3671 = io_jtag_in_data_data;
  assign bindin3674 = io_jtag_in_data_valid;
  assign bindin3686 = io_jtag_out_data_ready;
  assign bindin3747 = clk;
  assign bindin3748 = reset;
  CSR_Handler __module17__(.clk(bindin3747), .reset(bindin3748), .io_in_decode_csr_address(bindin3749), .io_in_mem_csr_address(bindin3752), .io_in_mem_is_csr(bindin3755), .io_in_mem_csr_result(bindin3758), .io_out_decode_csr_data(bindout3761));
  assign bindin3749 = bindout1171;
  assign bindin3752 = bindout2210;
  assign bindin3755 = bindout2213;
  assign bindin3758 = bindout2216;
  assign orl3763 = bindout1222 | bindout1983;
  assign eq3768 = bindout1983 == 1'h1;
  assign eq3772 = bindout3270 == 1'h1;
  assign orl3774 = eq3772 | eq3768;

  assign io_IBUS_in_data_ready = bindout171;
  assign io_IBUS_out_address_data = bindout174;
  assign io_IBUS_out_address_valid = bindout177;
  assign io_DBUS_in_data_ready = bindout2614;
  assign io_DBUS_out_data_data = bindout2617;
  assign io_DBUS_out_data_valid = bindout2620;
  assign io_DBUS_out_address_data = bindout2626;
  assign io_DBUS_out_address_valid = bindout2629;
  assign io_DBUS_out_control_data = bindout2635;
  assign io_DBUS_out_control_valid = bindout2638;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3295;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3650;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3659;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3668;
  assign io_jtag_in_data_ready = bindout3677;
  assign io_jtag_out_data_data = bindout3680;
  assign io_jtag_out_data_valid = bindout3683;
  assign io_out_fwd_stall = bindout3270;
  assign io_out_branch_stall = orl3763;
  assign io_actual_change = bindout1183;

endmodule
