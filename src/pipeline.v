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
  input wire io_in_jal,
  input wire[31:0] io_in_jal_dest,
  input wire io_in_interrupt,
  input wire[31:0] io_in_interrupt_pc,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg115;
  wire eq122, eq126, orl128, eq135, eq141;
  wire[31:0] sel131, sel137, sel143, sel145, add150, sel152;

  always @ (posedge clk) begin
    if (reset)
      reg115 <= 32'h0;
    else
      reg115 <= sel152;
  end
  assign eq122 = io_in_fwd_stall == 1'h1;
  assign eq126 = io_in_branch_stall == 1'h1;
  assign orl128 = eq126 | eq122;
  assign sel131 = orl128 ? 32'h0 : io_IBUS_in_data_data;
  assign eq135 = io_in_branch_dir == 1'h1;
  assign sel137 = eq135 ? io_in_branch_dest : reg115;
  assign eq141 = io_in_jal == 1'h1;
  assign sel143 = eq141 ? io_in_jal_dest : sel137;
  assign sel145 = io_in_interrupt ? io_in_interrupt_pc : sel143;
  assign add150 = sel145 + 32'h4;
  assign sel152 = orl128 ? sel145 : add150;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_valid;
  assign io_IBUS_out_address_data = sel145;
  assign io_IBUS_out_address_valid = 1'h1;
  assign io_out_instruction = sel131;
  assign io_out_curr_PC = sel145;
  assign io_out_PC_next = add150;

endmodule

module F_D_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_branch_stall,
  input wire io_in_fwd_stall,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg231, reg240, reg246;
  wire eq261;
  wire[31:0] sel263, sel264, sel265;

  always @ (posedge clk) begin
    if (reset)
      reg231 <= 32'h0;
    else
      reg231 <= sel264;
  end
  always @ (posedge clk) begin
    if (reset)
      reg240 <= 32'h0;
    else
      reg240 <= sel265;
  end
  always @ (posedge clk) begin
    if (reset)
      reg246 <= 32'h0;
    else
      reg246 <= sel263;
  end
  assign eq261 = io_in_fwd_stall == 1'h0;
  assign sel263 = eq261 ? io_in_curr_PC : reg246;
  assign sel264 = eq261 ? io_in_instruction : reg231;
  assign sel265 = eq261 ? io_in_PC_next : reg240;

  assign io_out_instruction = reg231;
  assign io_out_curr_PC = reg246;
  assign io_out_PC_next = reg240;

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
  reg[31:0] mem384 [0:31];
  reg reg392;
  wire eq397, sel401, ne415, andl418, sel420, eq429, eq438;
  wire[31:0] sel421, mrport424, sel431, mrport433, sel440;
  wire[4:0] sel422;

  always @ (posedge clk) begin
    if (sel420) begin
      mem384[sel422] <= sel421;
    end
  end
  assign mrport424 = mem384[io_in_src1];
  assign mrport433 = mem384[io_in_src2];
  always @ (posedge clk) begin
    if (reset)
      reg392 <= 1'h1;
    else
      reg392 <= sel401;
  end
  assign eq397 = reg392 == 1'h1;
  assign sel401 = eq397 ? 1'h0 : reg392;
  assign ne415 = io_in_rd != 5'h0;
  assign andl418 = io_in_write_register & ne415;
  assign sel420 = reg392 ? 1'h1 : andl418;
  assign sel421 = reg392 ? 32'h0 : io_in_data;
  assign sel422 = reg392 ? 5'h0 : io_in_rd;
  assign eq429 = io_in_src1 == 5'h0;
  assign sel431 = eq429 ? 32'h0 : mrport424;
  assign eq438 = io_in_src2 == 5'h0;
  assign sel440 = eq438 ? 32'h0 : mrport433;

  assign io_out_src1_data = sel431;
  assign io_out_src2_data = sel440;

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
  wire bindin467, bindin469, bindin470, ne530, sel532, eq536, eq591, eq596, eq601, orl603, eq608, eq613, eq618, eq623, eq628, eq633, ne638, eq643, andl645, proxy648, eq649, andl652, eq656, andl662, eq666, eq674, eq684, orl692, orl694, orl696, orl698, andl700, andl707, orl714, orl716, andl718, orl725, sel727, andl738, eq755, eq760, orl762, proxy813, proxy814, lt847, proxy919, eq949, proxy976, eq977, sel992, sel993, sel1002, sel1003, sel1008, sel1009, eq1023, eq1060, eq1068, eq1076, orl1082, lt1100;
  wire[4:0] bindin473, bindin479, bindin482, sel552, proxy560, proxy567;
  wire[31:0] bindin476, bindout485, bindout488, shr548, shr557, shr564, shr571, shr578, sel668, sel670, sel676, pad678, sel680, sel686, shr818, shr923, proxy939, proxy945, sel951, proxy966, proxy972, sel979, sel995, sel996;
  wire[6:0] sel541, proxy581;
  wire[2:0] proxy574, sel734, sel740, sel999, sel1000;
  wire[1:0] sel702, sel709, sel720, proxy1055;
  wire[11:0] proxy766, sel774, proxy792, proxy829, proxy961, sel989, sel990, sel1011, sel1012;
  wire[3:0] proxy821, sel1025, sel1028, sel1045, sel1062, sel1070, sel1078, sel1084, sel1086, sel1090, sel1094, sel1102, sel1104;
  wire[5:0] proxy827;
  wire[19:0] proxy890, sel1005, sel1006;
  wire[7:0] proxy918;
  wire[9:0] proxy926;
  wire[20:0] proxy930;
  reg[11:0] sel991, sel1013;
  reg sel994, sel1004, sel1010;
  reg[31:0] sel997;
  reg[2:0] sel998, sel1001;
  reg[19:0] sel1007;
  reg[3:0] sel1053;

  assign bindin467 = clk;
  assign bindin469 = reset;
  RegisterFile __module5__(.clk(bindin467), .reset(bindin469), .io_in_write_register(bindin470), .io_in_rd(bindin473), .io_in_data(bindin476), .io_in_src1(bindin479), .io_in_src2(bindin482), .io_out_src1_data(bindout485), .io_out_src2_data(bindout488));
  assign bindin470 = sel532;
  assign bindin473 = io_in_rd;
  assign bindin476 = io_in_write_data;
  assign bindin479 = proxy560;
  assign bindin482 = proxy567;
  assign ne530 = io_in_wb != 2'h0;
  assign sel532 = ne530 ? 1'h1 : 1'h0;
  assign eq536 = io_in_stall == 1'h0;
  assign sel541 = eq536 ? io_in_instruction[6:0] : 7'h0;
  assign shr548 = io_in_instruction >> 32'h7;
  assign sel552 = eq536 ? shr548[4:0] : 5'h0;
  assign shr557 = io_in_instruction >> 32'hf;
  assign proxy560 = shr557[4:0];
  assign shr564 = io_in_instruction >> 32'h14;
  assign proxy567 = shr564[4:0];
  assign shr571 = io_in_instruction >> 32'hc;
  assign proxy574 = shr571[2:0];
  assign shr578 = io_in_instruction >> 32'h19;
  assign proxy581 = shr578[6:0];
  assign eq591 = sel541 == 7'h33;
  assign eq596 = sel541 == 7'h3;
  assign eq601 = sel541 == 7'h13;
  assign orl603 = eq601 | eq596;
  assign eq608 = sel541 == 7'h23;
  assign eq613 = sel541 == 7'h63;
  assign eq618 = sel541 == 7'h6f;
  assign eq623 = sel541 == 7'h67;
  assign eq628 = sel541 == 7'h37;
  assign eq633 = sel541 == 7'h17;
  assign ne638 = proxy574 != 3'h0;
  assign eq643 = sel541 == 7'h73;
  assign andl645 = eq643 & ne638;
  assign proxy648 = proxy574[2];
  assign eq649 = proxy648 == 1'h1;
  assign andl652 = andl645 & eq649;
  assign eq656 = proxy574 == 3'h0;
  assign andl662 = eq643 & eq656;
  assign eq666 = io_in_src1_fwd == 1'h1;
  assign sel668 = eq666 ? io_in_src1_fwd_data : bindout485;
  assign sel670 = eq618 ? io_in_curr_PC : sel668;
  assign eq674 = io_in_src2_fwd == 1'h1;
  assign sel676 = eq674 ? io_in_src2_fwd_data : bindout488;
  assign pad678 = {{27{1'b0}}, proxy567};
  assign sel680 = andl652 ? pad678 : sel676;
  assign eq684 = io_in_csr_fwd == 1'h1;
  assign sel686 = eq684 ? io_in_csr_fwd_data : io_in_csr_data;
  assign orl692 = orl603 | eq591;
  assign orl694 = orl692 | eq628;
  assign orl696 = orl694 | eq633;
  assign orl698 = orl696 | andl645;
  assign andl700 = orl698 & eq536;
  assign sel702 = andl700 ? 2'h1 : 2'h0;
  assign andl707 = eq596 & eq536;
  assign sel709 = andl707 ? 2'h2 : sel702;
  assign orl714 = eq618 | eq623;
  assign orl716 = orl714 | andl662;
  assign andl718 = orl716 & eq536;
  assign sel720 = andl718 ? 2'h3 : sel709;
  assign orl725 = orl603 | eq608;
  assign sel727 = orl725 ? 1'h1 : 1'h0;
  assign sel734 = andl707 ? proxy574 : 3'h7;
  assign andl738 = eq608 & eq536;
  assign sel740 = andl738 ? proxy574 : 3'h7;
  assign eq755 = proxy574 == 3'h5;
  assign eq760 = proxy574 == 3'h1;
  assign orl762 = eq760 | eq755;
  assign proxy766 = {7'h0, proxy567};
  assign sel774 = orl762 ? proxy766 : shr564[11:0];
  assign proxy792 = {proxy581, sel552};
  assign proxy813 = io_in_instruction[31];
  assign proxy814 = io_in_instruction[7];
  assign shr818 = io_in_instruction >> 32'h8;
  assign proxy821 = shr818[3:0];
  assign proxy827 = shr578[5:0];
  assign proxy829 = {proxy813, proxy814, proxy827, proxy821};
  assign lt847 = shr564[11:0] < 12'h2;
  assign proxy890 = {proxy581, proxy567, proxy560, proxy574};
  assign proxy918 = shr571[7:0];
  assign proxy919 = io_in_instruction[20];
  assign shr923 = io_in_instruction >> 32'h15;
  assign proxy926 = shr923[9:0];
  assign proxy930 = {proxy813, proxy918, proxy919, proxy926, 1'h0};
  assign proxy939 = {11'h0, proxy930};
  assign proxy945 = {11'h7ff, proxy930};
  assign eq949 = proxy813 == 1'h1;
  assign sel951 = eq949 ? proxy945 : proxy939;
  assign proxy961 = {proxy581, proxy567};
  assign proxy966 = {20'h0, proxy961};
  assign proxy972 = {20'hfffff, proxy961};
  assign proxy976 = proxy961[11];
  assign eq977 = proxy976 == 1'h1;
  assign sel979 = eq977 ? proxy972 : proxy966;
  assign sel989 = lt847 ? 12'h7b : 12'h7b;
  assign sel990 = (proxy574 == 3'h0) ? sel989 : 12'h7b;
  always @(*) begin
    case (sel541)
      7'h13: sel991 = sel774;
      7'h33: sel991 = 12'h7b;
      7'h23: sel991 = proxy792;
      7'h03: sel991 = shr564[11:0];
      7'h63: sel991 = proxy829;
      7'h73: sel991 = sel990;
      7'h37: sel991 = 12'h7b;
      7'h17: sel991 = 12'h7b;
      7'h6f: sel991 = 12'h7b;
      7'h67: sel991 = 12'h7b;
      default: sel991 = 12'h7b;
    endcase
  end
  assign sel992 = lt847 ? 1'h0 : 1'h0;
  assign sel993 = (proxy574 == 3'h0) ? sel992 : 1'h0;
  always @(*) begin
    case (sel541)
      7'h13: sel994 = 1'h0;
      7'h33: sel994 = 1'h0;
      7'h23: sel994 = 1'h0;
      7'h03: sel994 = 1'h0;
      7'h63: sel994 = 1'h1;
      7'h73: sel994 = sel993;
      7'h37: sel994 = 1'h0;
      7'h17: sel994 = 1'h0;
      7'h6f: sel994 = 1'h1;
      7'h67: sel994 = 1'h1;
      default: sel994 = 1'h0;
    endcase
  end
  assign sel995 = lt847 ? 32'hb0000000 : 32'h7b;
  assign sel996 = (proxy574 == 3'h0) ? sel995 : 32'h7b;
  always @(*) begin
    case (sel541)
      7'h13: sel997 = 32'h7b;
      7'h33: sel997 = 32'h7b;
      7'h23: sel997 = 32'h7b;
      7'h03: sel997 = 32'h7b;
      7'h63: sel997 = 32'h7b;
      7'h73: sel997 = sel996;
      7'h37: sel997 = 32'h7b;
      7'h17: sel997 = 32'h7b;
      7'h6f: sel997 = sel951;
      7'h67: sel997 = sel979;
      default: sel997 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy574)
      3'h0: sel998 = 3'h1;
      3'h1: sel998 = 3'h2;
      3'h4: sel998 = 3'h3;
      3'h5: sel998 = 3'h4;
      3'h6: sel998 = 3'h5;
      3'h7: sel998 = 3'h6;
      default: sel998 = 3'h0;
    endcase
  end
  assign sel999 = lt847 ? 3'h0 : 3'h0;
  assign sel1000 = (proxy574 == 3'h0) ? sel999 : 3'h0;
  always @(*) begin
    case (sel541)
      7'h13: sel1001 = 3'h0;
      7'h33: sel1001 = 3'h0;
      7'h23: sel1001 = 3'h0;
      7'h03: sel1001 = 3'h0;
      7'h63: sel1001 = sel998;
      7'h73: sel1001 = sel1000;
      7'h37: sel1001 = 3'h0;
      7'h17: sel1001 = 3'h0;
      7'h6f: sel1001 = 3'h0;
      7'h67: sel1001 = 3'h0;
      default: sel1001 = 3'h0;
    endcase
  end
  assign sel1002 = lt847 ? 1'h1 : 1'h0;
  assign sel1003 = (proxy574 == 3'h0) ? sel1002 : 1'h0;
  always @(*) begin
    case (sel541)
      7'h13: sel1004 = 1'h0;
      7'h33: sel1004 = 1'h0;
      7'h23: sel1004 = 1'h0;
      7'h03: sel1004 = 1'h0;
      7'h63: sel1004 = 1'h0;
      7'h73: sel1004 = sel1003;
      7'h37: sel1004 = 1'h0;
      7'h17: sel1004 = 1'h0;
      7'h6f: sel1004 = 1'h1;
      7'h67: sel1004 = 1'h1;
      default: sel1004 = 1'h0;
    endcase
  end
  assign sel1005 = lt847 ? 20'h7b : 20'h7b;
  assign sel1006 = (proxy574 == 3'h0) ? sel1005 : 20'h7b;
  always @(*) begin
    case (sel541)
      7'h13: sel1007 = 20'h7b;
      7'h33: sel1007 = 20'h7b;
      7'h23: sel1007 = 20'h7b;
      7'h03: sel1007 = 20'h7b;
      7'h63: sel1007 = 20'h7b;
      7'h73: sel1007 = sel1006;
      7'h37: sel1007 = proxy890;
      7'h17: sel1007 = proxy890;
      7'h6f: sel1007 = 20'h7b;
      7'h67: sel1007 = 20'h7b;
      default: sel1007 = 20'h7b;
    endcase
  end
  assign sel1008 = lt847 ? 1'h0 : 1'h1;
  assign sel1009 = (proxy574 == 3'h0) ? sel1008 : 1'h1;
  always @(*) begin
    case (sel541)
      7'h13: sel1010 = 1'h0;
      7'h33: sel1010 = 1'h0;
      7'h23: sel1010 = 1'h0;
      7'h03: sel1010 = 1'h0;
      7'h63: sel1010 = 1'h0;
      7'h73: sel1010 = sel1009;
      7'h37: sel1010 = 1'h0;
      7'h17: sel1010 = 1'h0;
      7'h6f: sel1010 = 1'h0;
      7'h67: sel1010 = 1'h0;
      default: sel1010 = 1'h0;
    endcase
  end
  assign sel1011 = lt847 ? 12'h7b : shr564[11:0];
  assign sel1012 = (proxy574 == 3'h0) ? sel1011 : shr564[11:0];
  always @(*) begin
    case (sel541)
      7'h13: sel1013 = 12'h7b;
      7'h33: sel1013 = 12'h7b;
      7'h23: sel1013 = 12'h7b;
      7'h03: sel1013 = 12'h7b;
      7'h63: sel1013 = 12'h7b;
      7'h73: sel1013 = sel1012;
      7'h37: sel1013 = 12'h7b;
      7'h17: sel1013 = 12'h7b;
      7'h6f: sel1013 = 12'h7b;
      7'h67: sel1013 = 12'h7b;
      default: sel1013 = 12'h7b;
    endcase
  end
  assign eq1023 = proxy581 == 7'h0;
  assign sel1025 = eq1023 ? 4'h0 : 4'h1;
  assign sel1028 = eq601 ? 4'h0 : sel1025;
  assign sel1045 = eq1023 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy574)
      3'h0: sel1053 = sel1028;
      3'h1: sel1053 = 4'h2;
      3'h2: sel1053 = 4'h3;
      3'h3: sel1053 = 4'h4;
      3'h4: sel1053 = 4'h5;
      3'h5: sel1053 = sel1045;
      3'h6: sel1053 = 4'h8;
      3'h7: sel1053 = 4'h9;
      default: sel1053 = 4'hf;
    endcase
  end
  assign proxy1055 = proxy574[1:0];
  assign eq1060 = proxy1055 == 2'h3;
  assign sel1062 = eq1060 ? 4'hf : 4'hf;
  assign eq1068 = proxy1055 == 2'h2;
  assign sel1070 = eq1068 ? 4'he : sel1062;
  assign eq1076 = proxy1055 == 2'h1;
  assign sel1078 = eq1076 ? 4'hd : sel1070;
  assign orl1082 = eq608 | eq596;
  assign sel1084 = orl1082 ? 4'h0 : sel1053;
  assign sel1086 = andl645 ? sel1078 : sel1084;
  assign sel1090 = eq633 ? 4'hc : sel1086;
  assign sel1094 = eq628 ? 4'hb : sel1090;
  assign lt1100 = sel1001 < 3'h5;
  assign sel1102 = lt1100 ? 4'h1 : 4'ha;
  assign sel1104 = eq613 ? sel1102 : sel1094;

  assign io_out_csr_address = sel1013;
  assign io_out_is_csr = sel1010;
  assign io_out_csr_data = sel686;
  assign io_out_csr_mask = sel680;
  assign io_actual_change = 32'h1;
  assign io_out_rd = sel552;
  assign io_out_rs1 = proxy560;
  assign io_out_rd1 = sel670;
  assign io_out_rs2 = proxy567;
  assign io_out_rd2 = sel676;
  assign io_out_wb = sel720;
  assign io_out_alu_op = sel1104;
  assign io_out_rs2_src = sel727;
  assign io_out_itype_immed = sel991;
  assign io_out_mem_read = sel734;
  assign io_out_mem_write = sel740;
  assign io_out_branch_type = sel1001;
  assign io_out_branch_stall = sel994;
  assign io_out_jal = sel1004;
  assign io_out_jal_offset = sel997;
  assign io_out_upper_immed = sel1007;
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
  reg[4:0] reg1310, reg1319, reg1332;
  reg[31:0] reg1326, reg1338, reg1358, reg1417, reg1423, reg1429, reg1441;
  reg[3:0] reg1345;
  reg[1:0] reg1352;
  reg reg1365, reg1411, reg1435;
  reg[11:0] reg1372, reg1405;
  reg[2:0] reg1379, reg1385, reg1392;
  reg[19:0] reg1399;
  wire eq1445, sel1473, sel1495, sel1504;
  wire[4:0] sel1448, sel1451, sel1457;
  wire[31:0] sel1454, sel1460, sel1470, sel1498, sel1501, sel1507, sel1510;
  wire[3:0] sel1464;
  wire[1:0] sel1467;
  wire[11:0] sel1477, sel1492;
  wire[2:0] sel1480, sel1483, sel1486;
  wire[19:0] sel1489;

  always @ (posedge clk) begin
    if (reset)
      reg1310 <= 5'h0;
    else
      reg1310 <= sel1448;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1319 <= 5'h0;
    else
      reg1319 <= sel1451;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1326 <= 32'h0;
    else
      reg1326 <= sel1454;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1332 <= 5'h0;
    else
      reg1332 <= sel1457;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1338 <= 32'h0;
    else
      reg1338 <= sel1460;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1345 <= 4'h0;
    else
      reg1345 <= sel1464;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1352 <= 2'h0;
    else
      reg1352 <= sel1467;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1358 <= 32'h0;
    else
      reg1358 <= sel1470;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1365 <= 1'h0;
    else
      reg1365 <= sel1473;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1372 <= 12'h0;
    else
      reg1372 <= sel1477;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1379 <= 3'h7;
    else
      reg1379 <= sel1480;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1385 <= 3'h7;
    else
      reg1385 <= sel1483;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1392 <= 3'h0;
    else
      reg1392 <= sel1486;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1399 <= 20'h0;
    else
      reg1399 <= sel1489;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1405 <= 12'h0;
    else
      reg1405 <= sel1492;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1411 <= 1'h0;
    else
      reg1411 <= sel1495;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1417 <= 32'h0;
    else
      reg1417 <= sel1498;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1423 <= 32'h0;
    else
      reg1423 <= sel1501;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1429 <= 32'h0;
    else
      reg1429 <= sel1510;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1435 <= 1'h0;
    else
      reg1435 <= sel1504;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1441 <= 32'h0;
    else
      reg1441 <= sel1507;
  end
  assign eq1445 = io_in_fwd_stall == 1'h1;
  assign sel1448 = eq1445 ? 5'h0 : io_in_rd;
  assign sel1451 = eq1445 ? 5'h0 : io_in_rs1;
  assign sel1454 = eq1445 ? 32'h0 : io_in_rd1;
  assign sel1457 = eq1445 ? 5'h0 : io_in_rs2;
  assign sel1460 = eq1445 ? 32'h0 : io_in_rd2;
  assign sel1464 = eq1445 ? 4'hf : io_in_alu_op;
  assign sel1467 = eq1445 ? 2'h0 : io_in_wb;
  assign sel1470 = eq1445 ? 32'h0 : io_in_PC_next;
  assign sel1473 = eq1445 ? 1'h0 : io_in_rs2_src;
  assign sel1477 = eq1445 ? 12'h7b : io_in_itype_immed;
  assign sel1480 = eq1445 ? 3'h7 : io_in_mem_read;
  assign sel1483 = eq1445 ? 3'h7 : io_in_mem_write;
  assign sel1486 = eq1445 ? 3'h0 : io_in_branch_type;
  assign sel1489 = eq1445 ? 20'h0 : io_in_upper_immed;
  assign sel1492 = eq1445 ? 12'h0 : io_in_csr_address;
  assign sel1495 = eq1445 ? 1'h0 : io_in_is_csr;
  assign sel1498 = eq1445 ? 32'h0 : io_in_csr_data;
  assign sel1501 = eq1445 ? 32'h0 : io_in_csr_mask;
  assign sel1504 = eq1445 ? 1'h0 : io_in_jal;
  assign sel1507 = eq1445 ? 32'h0 : io_in_jal_offset;
  assign sel1510 = eq1445 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1405;
  assign io_out_is_csr = reg1411;
  assign io_out_csr_data = reg1417;
  assign io_out_csr_mask = reg1423;
  assign io_out_rd = reg1310;
  assign io_out_rs1 = reg1319;
  assign io_out_rd1 = reg1326;
  assign io_out_rs2 = reg1332;
  assign io_out_rd2 = reg1338;
  assign io_out_alu_op = reg1345;
  assign io_out_wb = reg1352;
  assign io_out_rs2_src = reg1365;
  assign io_out_itype_immed = reg1372;
  assign io_out_mem_read = reg1379;
  assign io_out_mem_write = reg1385;
  assign io_out_branch_type = reg1392;
  assign io_out_upper_immed = reg1399;
  assign io_out_curr_PC = reg1429;
  assign io_out_jal = reg1435;
  assign io_out_jal_offset = reg1441;
  assign io_out_PC_next = reg1358;

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
  output wire io_out_branch_dir,
  output wire[31:0] io_out_branch_dest,
  output wire io_out_jal,
  output wire[31:0] io_out_jal_dest,
  output wire[31:0] io_out_PC_next
);
  wire[31:0] proxy1719, proxy1725, sel1733, sel1740, proxy1745, shl1750, add1752, add1754, add1757, sub1762, shl1766, sel1775, sel1784, xorl1789, shr1793, shr1798, orl1803, andl1808, add1821, orl1827, sub1831, andl1834, sel1839;
  wire eq1731, eq1738, lt1773, lt1782, ge1812, eq1846, sel1848, sel1856, eq1863, sel1865, sel1874;
  reg[31:0] sel1838, sel1840;
  reg sel1897;

  assign proxy1719 = {20'h0, io_in_itype_immed};
  assign proxy1725 = {20'hfffff, io_in_itype_immed};
  assign eq1731 = io_in_itype_immed[11] == 1'h1;
  assign sel1733 = eq1731 ? proxy1725 : proxy1719;
  assign eq1738 = io_in_rs2_src == 1'h1;
  assign sel1740 = eq1738 ? sel1733 : io_in_rd2;
  assign proxy1745 = {io_in_upper_immed, 12'h0};
  assign shl1750 = $signed(sel1733) << 32'h1;
  assign add1752 = $signed(io_in_curr_PC) + $signed(shl1750);
  assign add1754 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1757 = $signed(io_in_rd1) + $signed(sel1740);
  assign sub1762 = $signed(io_in_rd1) - $signed(sel1740);
  assign shl1766 = io_in_rd1 << sel1740;
  assign lt1773 = $signed(io_in_rd1) < $signed(sel1740);
  assign sel1775 = lt1773 ? 32'h1 : 32'h0;
  assign lt1782 = io_in_rd1 < sel1740;
  assign sel1784 = lt1782 ? 32'h1 : 32'h0;
  assign xorl1789 = io_in_rd1 ^ sel1740;
  assign shr1793 = io_in_rd1 >> sel1740;
  assign shr1798 = $signed(io_in_rd1) >> sel1740;
  assign orl1803 = io_in_rd1 | sel1740;
  assign andl1808 = sel1740 & io_in_rd1;
  assign ge1812 = io_in_rd1 >= sel1740;
  assign add1821 = $signed(io_in_curr_PC) + $signed(proxy1745);
  assign orl1827 = io_in_csr_data | io_in_csr_mask;
  assign sub1831 = 32'hffffffff - io_in_csr_mask;
  assign andl1834 = io_in_csr_data & sub1831;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1838 = 32'h7b;
      4'h1: sel1838 = 32'h7b;
      4'h2: sel1838 = 32'h7b;
      4'h3: sel1838 = 32'h7b;
      4'h4: sel1838 = 32'h7b;
      4'h5: sel1838 = 32'h7b;
      4'h6: sel1838 = 32'h7b;
      4'h7: sel1838 = 32'h7b;
      4'h8: sel1838 = 32'h7b;
      4'h9: sel1838 = 32'h7b;
      4'ha: sel1838 = 32'h7b;
      4'hb: sel1838 = 32'h7b;
      4'hc: sel1838 = 32'h7b;
      4'hd: sel1838 = io_in_csr_mask;
      4'he: sel1838 = orl1827;
      4'hf: sel1838 = andl1834;
      default: sel1838 = 32'h7b;
    endcase
  end
  assign sel1839 = ge1812 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1840 = add1757;
      4'h1: sel1840 = sub1762;
      4'h2: sel1840 = shl1766;
      4'h3: sel1840 = sel1775;
      4'h4: sel1840 = sel1784;
      4'h5: sel1840 = xorl1789;
      4'h6: sel1840 = shr1793;
      4'h7: sel1840 = shr1798;
      4'h8: sel1840 = orl1803;
      4'h9: sel1840 = andl1808;
      4'ha: sel1840 = sel1839;
      4'hb: sel1840 = proxy1745;
      4'hc: sel1840 = add1821;
      4'hd: sel1840 = io_in_csr_data;
      4'he: sel1840 = io_in_csr_data;
      4'hf: sel1840 = io_in_csr_data;
      default: sel1840 = 32'h0;
    endcase
  end
  assign eq1846 = sel1840 == 32'h0;
  assign sel1848 = eq1846 ? 1'h1 : 1'h0;
  assign sel1856 = eq1846 ? 1'h0 : 1'h1;
  assign eq1863 = sel1840[31] == 1'h0;
  assign sel1865 = eq1863 ? 1'h0 : 1'h1;
  assign sel1874 = eq1863 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel1897 = sel1848;
      3'h2: sel1897 = sel1856;
      3'h3: sel1897 = sel1865;
      3'h4: sel1897 = sel1874;
      3'h5: sel1897 = sel1865;
      3'h6: sel1897 = sel1874;
      3'h0: sel1897 = 1'h0;
      default: sel1897 = 1'h0;
    endcase
  end

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1838;
  assign io_out_alu_result = sel1840;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_branch_dir = sel1897;
  assign io_out_branch_dest = add1752;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1754;
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
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg2071, reg2093, reg2105, reg2118, reg2151;
  reg[4:0] reg2081, reg2087, reg2099;
  reg[1:0] reg2112;
  reg[2:0] reg2125, reg2131;
  reg[11:0] reg2138;
  reg reg2145;

  always @ (posedge clk) begin
    if (reset)
      reg2071 <= 32'h0;
    else
      reg2071 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2081 <= 5'h0;
    else
      reg2081 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2087 <= 5'h0;
    else
      reg2087 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2093 <= 32'h0;
    else
      reg2093 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2099 <= 5'h0;
    else
      reg2099 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2105 <= 32'h0;
    else
      reg2105 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2112 <= 2'h0;
    else
      reg2112 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2118 <= 32'h0;
    else
      reg2118 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2125 <= 3'h0;
    else
      reg2125 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2131 <= 3'h0;
    else
      reg2131 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2138 <= 12'h0;
    else
      reg2138 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2145 <= 1'h0;
    else
      reg2145 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2151 <= 32'h0;
    else
      reg2151 <= io_in_csr_result;
  end

  assign io_out_csr_address = reg2138;
  assign io_out_is_csr = reg2145;
  assign io_out_csr_result = reg2151;
  assign io_out_alu_result = reg2071;
  assign io_out_rd = reg2081;
  assign io_out_wb = reg2112;
  assign io_out_rs1 = reg2087;
  assign io_out_rd1 = reg2093;
  assign io_out_rd2 = reg2105;
  assign io_out_rs2 = reg2099;
  assign io_out_mem_read = reg2125;
  assign io_out_mem_write = reg2131;
  assign io_out_PC_next = reg2118;

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
  wire lt2326, lt2329, orl2331, eq2339, eq2353, eq2357, andl2359, eq2380, eq2384, andl2386, orl2389, proxy2408, eq2409, proxy2428, eq2429;
  wire[1:0] sel2365, sel2369, sel2373;
  wire[7:0] proxy2398;
  wire[31:0] proxy2400, proxy2404, sel2411, proxy2420, proxy2424, sel2431;
  wire[15:0] proxy2418;
  reg[31:0] sel2451;

  assign lt2326 = io_in_mem_write < 3'h7;
  assign lt2329 = io_in_mem_read < 3'h7;
  assign orl2331 = lt2329 | lt2326;
  assign eq2339 = io_in_mem_write == 3'h2;
  assign eq2353 = io_in_mem_write == 3'h7;
  assign eq2357 = io_in_mem_read == 3'h7;
  assign andl2359 = eq2357 & eq2353;
  assign sel2365 = andl2359 ? 2'h0 : 2'h3;
  assign sel2369 = eq2339 ? 2'h2 : sel2365;
  assign sel2373 = lt2329 ? 2'h1 : sel2369;
  assign eq2380 = eq2339 == 1'h0;
  assign eq2384 = andl2359 == 1'h0;
  assign andl2386 = eq2384 & eq2380;
  assign orl2389 = lt2329 | andl2386;
  assign proxy2398 = io_DBUS_in_data_data[7:0];
  assign proxy2400 = {24'h0, proxy2398};
  assign proxy2404 = {24'hffffff, proxy2398};
  assign proxy2408 = proxy2398[7];
  assign eq2409 = proxy2408 == 1'h1;
  assign sel2411 = eq2409 ? proxy2404 : proxy2400;
  assign proxy2418 = io_DBUS_in_data_data[15:0];
  assign proxy2420 = {16'h0, proxy2418};
  assign proxy2424 = {16'hffff, proxy2418};
  assign proxy2428 = proxy2418[15];
  assign eq2429 = proxy2428 == 1'h1;
  assign sel2431 = eq2429 ? proxy2424 : proxy2420;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2451 = sel2411;
      3'h1: sel2451 = sel2431;
      3'h2: sel2451 = io_DBUS_in_data_data;
      3'h4: sel2451 = proxy2400;
      3'h5: sel2451 = proxy2420;
      default: sel2451 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2389;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2326;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2331;
  assign io_DBUS_out_control_data = sel2373;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2451;

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
  output wire[31:0] io_out_alu_result,
  output wire[31:0] io_out_mem_result,
  output wire[4:0] io_out_rd,
  output wire[1:0] io_out_wb,
  output wire[4:0] io_out_rs1,
  output wire[4:0] io_out_rs2,
  output wire[31:0] io_out_PC_next
);
  wire[31:0] bindin2458, bindout2467, bindout2476, bindin2494, bindin2503, bindout2506;
  wire bindin2461, bindout2464, bindout2470, bindin2473, bindout2479, bindin2482, bindout2488, bindin2491;
  wire[1:0] bindout2485;
  wire[2:0] bindin2497, bindin2500;

  Cache __module10__(.io_DBUS_in_data_data(bindin2458), .io_DBUS_in_data_valid(bindin2461), .io_DBUS_out_data_ready(bindin2473), .io_DBUS_out_address_ready(bindin2482), .io_DBUS_out_control_ready(bindin2491), .io_in_address(bindin2494), .io_in_mem_read(bindin2497), .io_in_mem_write(bindin2500), .io_in_data(bindin2503), .io_DBUS_in_data_ready(bindout2464), .io_DBUS_out_data_data(bindout2467), .io_DBUS_out_data_valid(bindout2470), .io_DBUS_out_address_data(bindout2476), .io_DBUS_out_address_valid(bindout2479), .io_DBUS_out_control_data(bindout2485), .io_DBUS_out_control_valid(bindout2488), .io_out_data(bindout2506));
  assign bindin2458 = io_DBUS_in_data_data;
  assign bindin2461 = io_DBUS_in_data_valid;
  assign bindin2473 = io_DBUS_out_data_ready;
  assign bindin2482 = io_DBUS_out_address_ready;
  assign bindin2491 = io_DBUS_out_control_ready;
  assign bindin2494 = io_in_alu_result;
  assign bindin2497 = io_in_mem_read;
  assign bindin2500 = io_in_mem_write;
  assign bindin2503 = io_in_rd2;

  assign io_DBUS_in_data_ready = bindout2464;
  assign io_DBUS_out_data_data = bindout2467;
  assign io_DBUS_out_data_valid = bindout2470;
  assign io_DBUS_out_address_data = bindout2476;
  assign io_DBUS_out_address_valid = bindout2479;
  assign io_DBUS_out_control_data = bindout2485;
  assign io_DBUS_out_control_valid = bindout2488;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2506;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
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
  reg[31:0] reg2629, reg2638, reg2670;
  reg[4:0] reg2645, reg2651, reg2657;
  reg[1:0] reg2664;

  always @ (posedge clk) begin
    if (reset)
      reg2629 <= 32'h0;
    else
      reg2629 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2638 <= 32'h0;
    else
      reg2638 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2645 <= 5'h0;
    else
      reg2645 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2651 <= 5'h0;
    else
      reg2651 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2657 <= 5'h0;
    else
      reg2657 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2664 <= 2'h0;
    else
      reg2664 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2670 <= 32'h0;
    else
      reg2670 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2629;
  assign io_out_mem_result = reg2638;
  assign io_out_rd = reg2645;
  assign io_out_wb = reg2664;
  assign io_out_rs1 = reg2651;
  assign io_out_rs2 = reg2657;
  assign io_out_PC_next = reg2670;

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
  wire eq2736, eq2741;
  wire[31:0] sel2743, sel2745;

  assign eq2736 = io_in_wb == 2'h3;
  assign eq2741 = io_in_wb == 2'h1;
  assign sel2743 = eq2741 ? io_in_alu_result : io_in_mem_result;
  assign sel2745 = eq2736 ? io_in_PC_next : sel2743;

  assign io_out_write_data = sel2745;
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
  wire eq2825, eq2829, eq2833, eq2838, eq2842, eq2846, eq2851, eq2855, ne2860, ne2865, eq2868, andl2870, andl2872, eq2877, ne2881, eq2888, andl2890, andl2892, andl2894, eq2898, ne2906, eq2913, andl2915, andl2917, andl2919, andl2921, orl2924, orl2926, ne2952, eq2955, andl2957, andl2959, eq2963, eq2974, andl2976, andl2978, andl2980, eq2984, eq2999, andl3001, andl3003, andl3005, andl3007, orl3010, orl3012, eq3032, andl3034, eq3038, eq3041, andl3043, andl3045, orl3048, orl3058, andl3060, sel3062;
  wire[31:0] sel2930, sel2932, sel2934, sel2936, sel2938, sel2940, sel2942, sel2944, sel3019, sel3025, sel3029, sel3051, sel3053;

  assign eq2825 = io_in_execute_wb == 2'h2;
  assign eq2829 = io_in_memory_wb == 2'h2;
  assign eq2833 = io_in_writeback_wb == 2'h2;
  assign eq2838 = io_in_execute_wb == 2'h3;
  assign eq2842 = io_in_memory_wb == 2'h3;
  assign eq2846 = io_in_writeback_wb == 2'h3;
  assign eq2851 = io_in_execute_is_csr == 1'h1;
  assign eq2855 = io_in_memory_is_csr == 1'h1;
  assign ne2860 = io_in_execute_wb != 2'h0;
  assign ne2865 = io_in_decode_src1 != 5'h0;
  assign eq2868 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2870 = eq2868 & ne2865;
  assign andl2872 = andl2870 & ne2860;
  assign eq2877 = andl2872 == 1'h0;
  assign ne2881 = io_in_memory_wb != 2'h0;
  assign eq2888 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2890 = eq2888 & ne2865;
  assign andl2892 = andl2890 & ne2881;
  assign andl2894 = andl2892 & eq2877;
  assign eq2898 = andl2894 == 1'h0;
  assign ne2906 = io_in_writeback_wb != 2'h0;
  assign eq2913 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2915 = eq2913 & ne2865;
  assign andl2917 = andl2915 & ne2906;
  assign andl2919 = andl2917 & eq2877;
  assign andl2921 = andl2919 & eq2898;
  assign orl2924 = andl2872 | andl2894;
  assign orl2926 = orl2924 | andl2921;
  assign sel2930 = eq2833 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2932 = eq2846 ? io_in_writeback_PC_next : sel2930;
  assign sel2934 = andl2921 ? sel2932 : 32'h7b;
  assign sel2936 = eq2829 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2938 = eq2842 ? io_in_memory_PC_next : sel2936;
  assign sel2940 = andl2894 ? sel2938 : sel2934;
  assign sel2942 = eq2838 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2944 = andl2872 ? sel2942 : sel2940;
  assign ne2952 = io_in_decode_src2 != 5'h0;
  assign eq2955 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2957 = eq2955 & ne2952;
  assign andl2959 = andl2957 & ne2860;
  assign eq2963 = andl2959 == 1'h0;
  assign eq2974 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2976 = eq2974 & ne2952;
  assign andl2978 = andl2976 & ne2881;
  assign andl2980 = andl2978 & eq2963;
  assign eq2984 = andl2980 == 1'h0;
  assign eq2999 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl3001 = eq2999 & ne2952;
  assign andl3003 = andl3001 & ne2906;
  assign andl3005 = andl3003 & eq2963;
  assign andl3007 = andl3005 & eq2984;
  assign orl3010 = andl2959 | andl2980;
  assign orl3012 = orl3010 | andl3007;
  assign sel3019 = andl3007 ? sel2932 : 32'h7b;
  assign sel3025 = andl2980 ? sel2938 : sel3019;
  assign sel3029 = andl2959 ? sel2942 : sel3025;
  assign eq3032 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3034 = eq3032 & eq2851;
  assign eq3038 = andl3034 == 1'h0;
  assign eq3041 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3043 = eq3041 & eq2855;
  assign andl3045 = andl3043 & eq3038;
  assign orl3048 = andl3034 | andl3045;
  assign sel3051 = andl3045 ? io_in_memory_csr_result : 32'h7b;
  assign sel3053 = andl3034 ? io_in_execute_alu_result : sel3051;
  assign orl3058 = andl2872 | andl2959;
  assign andl3060 = orl3058 & eq2825;
  assign sel3062 = andl3060 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2926;
  assign io_out_src1_fwd_data = sel2944;
  assign io_out_src2_fwd = orl3012;
  assign io_out_src2_fwd_data = sel3029;
  assign io_out_csr_fwd = orl3048;
  assign io_out_csr_fwd_data = sel3053;
  assign io_out_fwd_stall = sel3062;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3169 [0:1];
  wire[31:0] mrport3171;

  initial begin
    mem3169[0] = 32'hdeadbeef;
    mem3169[1] = 32'hdeadbeef;
  end
  assign mrport3171 = mem3169[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport3171;

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
  reg[3:0] reg3240, sel3330;
  wire eq3248, andl3333, eq3337, andl3341, eq3345, andl3349;
  wire[3:0] sel3254, sel3259, sel3265, sel3271, sel3281, sel3286, sel3290, sel3299, sel3305, sel3315, sel3320, sel3324, sel3331, sel3347, sel3348, sel3350;

  always @ (posedge clk) begin
    if (reset)
      reg3240 <= 4'h0;
    else
      reg3240 <= sel3350;
  end
  assign eq3248 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3254 = eq3248 ? 4'h0 : 4'h1;
  assign sel3259 = eq3248 ? 4'h2 : 4'h1;
  assign sel3265 = eq3248 ? 4'h9 : 4'h3;
  assign sel3271 = eq3248 ? 4'h5 : 4'h4;
  assign sel3281 = eq3248 ? 4'h8 : 4'h6;
  assign sel3286 = eq3248 ? 4'h7 : 4'h6;
  assign sel3290 = eq3248 ? 4'h4 : 4'h8;
  assign sel3299 = eq3248 ? 4'h0 : 4'ha;
  assign sel3305 = eq3248 ? 4'hc : 4'hb;
  assign sel3315 = eq3248 ? 4'hf : 4'hd;
  assign sel3320 = eq3248 ? 4'he : 4'hd;
  assign sel3324 = eq3248 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3240)
      4'h0: sel3330 = sel3254;
      4'h1: sel3330 = sel3259;
      4'h2: sel3330 = sel3265;
      4'h3: sel3330 = sel3271;
      4'h4: sel3330 = sel3271;
      4'h5: sel3330 = sel3281;
      4'h6: sel3330 = sel3286;
      4'h7: sel3330 = sel3290;
      4'h8: sel3330 = sel3259;
      4'h9: sel3330 = sel3299;
      4'ha: sel3330 = sel3305;
      4'hb: sel3330 = sel3305;
      4'hc: sel3330 = sel3315;
      4'hd: sel3330 = sel3320;
      4'he: sel3330 = sel3324;
      4'hf: sel3330 = sel3259;
      default: sel3330 = reg3240;
    endcase
  end
  assign sel3331 = io_JTAG_TAP_in_mode_select_valid ? sel3330 : 4'h0;
  assign andl3333 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3337 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3341 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3345 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3347 = eq3337 ? 4'h0 : reg3240;
  assign sel3348 = andl3349 ? sel3331 : reg3240;
  assign andl3349 = andl3341 & eq3345;
  assign sel3350 = andl3333 ? sel3347 : sel3348;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3240;

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
  wire bindin3356, bindin3358, bindin3359, bindin3362, bindout3365, bindin3368, bindin3371, bindout3374, bindin3377, bindin3380, bindout3383, eq3420, eq3429, eq3434, eq3510, andl3511, sel3514, sel3520;
  wire[3:0] bindout3386;
  reg[31:0] reg3394, reg3401, reg3408, reg3415, sel3512;
  wire[31:0] sel3437, sel3439, shr3446, proxy3451, sel3506, sel3507, sel3508, sel3509, sel3513;
  wire[30:0] proxy3449;
  reg sel3519, sel3525;

  assign bindin3356 = clk;
  assign bindin3358 = reset;
  TAP __module16__(.clk(bindin3356), .reset(bindin3358), .io_JTAG_TAP_in_mode_select_data(bindin3359), .io_JTAG_TAP_in_mode_select_valid(bindin3362), .io_JTAG_TAP_in_clock_data(bindin3368), .io_JTAG_TAP_in_clock_valid(bindin3371), .io_JTAG_TAP_in_reset_data(bindin3377), .io_JTAG_TAP_in_reset_valid(bindin3380), .io_JTAG_TAP_in_mode_select_ready(bindout3365), .io_JTAG_TAP_in_clock_ready(bindout3374), .io_JTAG_TAP_in_reset_ready(bindout3383), .io_out_curr_state(bindout3386));
  assign bindin3359 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3362 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3368 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3371 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3377 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3380 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3394 <= 32'h0;
    else
      reg3394 <= sel3513;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3401 <= 32'h1234;
    else
      reg3401 <= sel3508;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3408 <= 32'h5678;
    else
      reg3408 <= sel3509;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3415 <= 32'h0;
    else
      reg3415 <= sel3512;
  end
  assign eq3420 = reg3394 == 32'h0;
  assign eq3429 = reg3394 == 32'h1;
  assign eq3434 = reg3394 == 32'h2;
  assign sel3437 = eq3434 ? reg3401 : 32'hdeadbeef;
  assign sel3439 = eq3429 ? reg3408 : sel3437;
  assign shr3446 = reg3415 >> 32'h1;
  assign proxy3449 = shr3446[30:0];
  assign proxy3451 = {io_JTAG_in_data_data, proxy3449};
  assign sel3506 = eq3434 ? reg3415 : reg3401;
  assign sel3507 = eq3429 ? reg3401 : sel3506;
  assign sel3508 = (bindout3386 == 4'h8) ? sel3507 : reg3401;
  assign sel3509 = andl3511 ? reg3415 : reg3408;
  assign eq3510 = bindout3386 == 4'h8;
  assign andl3511 = eq3510 & eq3429;
  always @(*) begin
    case (bindout3386)
      4'h3: sel3512 = sel3439;
      4'h4: sel3512 = proxy3451;
      4'ha: sel3512 = reg3394;
      4'hb: sel3512 = proxy3451;
      default: sel3512 = reg3415;
    endcase
  end
  assign sel3513 = (bindout3386 == 4'hf) ? reg3415 : reg3394;
  assign sel3514 = eq3420 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3386)
      4'h3: sel3519 = sel3514;
      4'h4: sel3519 = 1'h1;
      4'h8: sel3519 = sel3514;
      4'ha: sel3519 = sel3514;
      4'hb: sel3519 = 1'h1;
      4'hf: sel3519 = sel3514;
      default: sel3519 = sel3514;
    endcase
  end
  assign sel3520 = eq3420 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3386)
      4'h3: sel3525 = sel3520;
      4'h4: sel3525 = reg3415[0];
      4'h8: sel3525 = sel3520;
      4'ha: sel3525 = sel3520;
      4'hb: sel3525 = reg3415[0];
      4'hf: sel3525 = sel3520;
      default: sel3525 = sel3520;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3365;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3374;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3383;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3525;
  assign io_JTAG_out_data_valid = sel3519;

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
  reg[31:0] mem3581 [0:4095];
  reg[1:0] reg3590, sel3624;
  wire eq3602, eq3606, eq3622;
  reg sel3625;
  reg[31:0] sel3626;
  reg[11:0] sel3627;
  wire[31:0] mrport3629;

  always @ (posedge clk) begin
    if (sel3625) begin
      mem3581[sel3627] <= sel3626;
    end
  end
  assign mrport3629 = mem3581[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (reset)
      reg3590 <= 2'h0;
    else
      reg3590 <= sel3624;
  end
  assign eq3602 = reg3590 == 2'h1;
  assign eq3606 = reg3590 == 2'h0;
  assign eq3622 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3606)
      sel3624 = 2'h1;
    else if (eq3602)
      sel3624 = 2'h3;
    else
      sel3624 = reg3590;
  end
  always @(*) begin
    if (eq3606)
      sel3625 = 1'h1;
    else if (eq3602)
      sel3625 = 1'h1;
    else
      sel3625 = eq3622;
  end
  always @(*) begin
    if (eq3606)
      sel3626 = 32'h0;
    else if (eq3602)
      sel3626 = 32'h0;
    else
      sel3626 = io_in_mem_csr_result;
  end
  always @(*) begin
    if (eq3606)
      sel3627 = 12'hf14;
    else if (eq3602)
      sel3627 = 12'h301;
    else
      sel3627 = io_in_mem_csr_address;
  end

  assign io_out_decode_csr_data = mrport3629;

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
  wire bindin159, bindin161, bindin165, bindout168, bindout174, bindin177, bindin180, bindin186, bindin189, bindin192, bindin198, bindin269, bindin270, bindin280, bindin283, bindin1111, bindin1112, bindin1122, bindin1134, bindin1140, bindin1146, bindout1158, bindout1191, bindout1206, bindout1209, bindin1515, bindin1516, bindin1538, bindin1556, bindin1565, bindin1577, bindout1586, bindout1616, bindout1637, bindin1922, bindin1946, bindin1955, bindout1967, bindout2000, bindout2006, bindin2156, bindin2157, bindin2191, bindout2200, bindin2513, bindout2516, bindout2522, bindin2525, bindout2531, bindin2534, bindout2540, bindin2543, bindin2675, bindin2676, bindin3091, bindin3115, bindout3139, bindout3145, bindout3151, bindout3157, bindin3176, bindin3179, bindout3182, bindout3185, bindin3529, bindin3530, bindin3531, bindin3534, bindout3537, bindin3540, bindin3543, bindout3546, bindin3549, bindin3552, bindout3555, bindin3558, bindin3561, bindout3564, bindout3567, bindout3570, bindin3573, bindin3634, bindin3635, bindin3642, eq3652;
  wire[31:0] bindin162, bindout171, bindin183, bindin195, bindin201, bindout204, bindout207, bindout210, bindin271, bindin274, bindin277, bindout286, bindout289, bindout292, bindin1113, bindin1116, bindin1119, bindin1125, bindin1137, bindin1143, bindin1149, bindin1152, bindout1161, bindout1164, bindout1167, bindout1176, bindout1182, bindout1212, bindout1218, bindin1523, bindin1529, bindin1550, bindin1568, bindin1571, bindin1574, bindin1580, bindout1589, bindout1592, bindout1601, bindout1607, bindout1634, bindout1640, bindout1643, bindin1907, bindin1913, bindin1934, bindin1949, bindin1952, bindin1958, bindin1961, bindout1970, bindout1973, bindout1985, bindout1991, bindout2003, bindout2009, bindout2012, bindin2158, bindin2170, bindin2176, bindin2185, bindin2194, bindout2203, bindout2206, bindout2218, bindout2221, bindout2233, bindin2510, bindout2519, bindout2528, bindin2546, bindin2564, bindin2570, bindin2573, bindout2576, bindout2579, bindout2594, bindin2677, bindin2680, bindin2695, bindout2698, bindout2701, bindout2716, bindin2750, bindin2753, bindin2768, bindout2771, bindin3085, bindin3088, bindin3097, bindin3106, bindin3109, bindin3112, bindin3121, bindin3130, bindin3133, bindin3136, bindout3142, bindout3148, bindout3154, bindout3188, bindin3645, bindout3648;
  wire[4:0] bindin1128, bindout1170, bindout1173, bindout1179, bindin1517, bindin1520, bindin1526, bindout1595, bindout1598, bindout1604, bindin1901, bindin1904, bindin1910, bindout1976, bindout1982, bindout1988, bindin2161, bindin2167, bindin2173, bindout2209, bindout2215, bindout2224, bindin2555, bindin2561, bindin2567, bindout2582, bindout2588, bindout2591, bindin2683, bindin2689, bindin2692, bindout2704, bindout2710, bindout2713, bindin2756, bindin2762, bindin2765, bindout2774, bindin3070, bindin3073, bindin3079, bindin3100, bindin3124;
  wire[1:0] bindin1131, bindout1185, bindin1535, bindout1613, bindin1919, bindout1979, bindin2164, bindout2212, bindout2537, bindin2558, bindout2585, bindin2686, bindout2707, bindin2759, bindout2777, bindin3082, bindin3103, bindin3127;
  wire[11:0] bindout1155, bindout1194, bindin1541, bindin1562, bindout1583, bindout1619, bindin1925, bindin1943, bindout1964, bindin2188, bindout2197, bindin3076, bindin3094, bindin3118, bindin3636, bindin3639;
  wire[3:0] bindout1188, bindin1532, bindout1610, bindin1916;
  wire[2:0] bindout1197, bindout1200, bindout1203, bindin1544, bindin1547, bindin1553, bindout1622, bindout1625, bindout1628, bindin1928, bindin1931, bindin1937, bindout1994, bindout1997, bindin2179, bindin2182, bindout2227, bindout2230, bindin2549, bindin2552;
  wire[19:0] bindout1215, bindin1559, bindout1631, bindin1940;

  assign bindin159 = clk;
  assign bindin161 = reset;
  Fetch __module2__(.clk(bindin159), .reset(bindin161), .io_IBUS_in_data_data(bindin162), .io_IBUS_in_data_valid(bindin165), .io_IBUS_out_address_ready(bindin177), .io_in_branch_dir(bindin180), .io_in_branch_dest(bindin183), .io_in_branch_stall(bindin186), .io_in_fwd_stall(bindin189), .io_in_jal(bindin192), .io_in_jal_dest(bindin195), .io_in_interrupt(bindin198), .io_in_interrupt_pc(bindin201), .io_IBUS_in_data_ready(bindout168), .io_IBUS_out_address_data(bindout171), .io_IBUS_out_address_valid(bindout174), .io_out_instruction(bindout204), .io_out_curr_PC(bindout207), .io_out_PC_next(bindout210));
  assign bindin162 = io_IBUS_in_data_data;
  assign bindin165 = io_IBUS_in_data_valid;
  assign bindin177 = io_IBUS_out_address_ready;
  assign bindin180 = bindout2000;
  assign bindin183 = bindout2003;
  assign bindin186 = bindout1206;
  assign bindin189 = bindout3157;
  assign bindin192 = bindout2006;
  assign bindin195 = bindout2009;
  assign bindin198 = bindout3185;
  assign bindin201 = bindout3188;
  assign bindin269 = clk;
  assign bindin270 = reset;
  F_D_Register __module3__(.clk(bindin269), .reset(bindin270), .io_in_instruction(bindin271), .io_in_PC_next(bindin274), .io_in_curr_PC(bindin277), .io_in_branch_stall(bindin280), .io_in_fwd_stall(bindin283), .io_out_instruction(bindout286), .io_out_curr_PC(bindout289), .io_out_PC_next(bindout292));
  assign bindin271 = bindout204;
  assign bindin274 = bindout210;
  assign bindin277 = bindout207;
  assign bindin280 = bindout1206;
  assign bindin283 = bindout3157;
  assign bindin1111 = clk;
  assign bindin1112 = reset;
  Decode __module4__(.clk(bindin1111), .reset(bindin1112), .io_in_instruction(bindin1113), .io_in_PC_next(bindin1116), .io_in_curr_PC(bindin1119), .io_in_stall(bindin1122), .io_in_write_data(bindin1125), .io_in_rd(bindin1128), .io_in_wb(bindin1131), .io_in_src1_fwd(bindin1134), .io_in_src1_fwd_data(bindin1137), .io_in_src2_fwd(bindin1140), .io_in_src2_fwd_data(bindin1143), .io_in_csr_fwd(bindin1146), .io_in_csr_fwd_data(bindin1149), .io_in_csr_data(bindin1152), .io_out_csr_address(bindout1155), .io_out_is_csr(bindout1158), .io_out_csr_data(bindout1161), .io_out_csr_mask(bindout1164), .io_actual_change(bindout1167), .io_out_rd(bindout1170), .io_out_rs1(bindout1173), .io_out_rd1(bindout1176), .io_out_rs2(bindout1179), .io_out_rd2(bindout1182), .io_out_wb(bindout1185), .io_out_alu_op(bindout1188), .io_out_rs2_src(bindout1191), .io_out_itype_immed(bindout1194), .io_out_mem_read(bindout1197), .io_out_mem_write(bindout1200), .io_out_branch_type(bindout1203), .io_out_branch_stall(bindout1206), .io_out_jal(bindout1209), .io_out_jal_offset(bindout1212), .io_out_upper_immed(bindout1215), .io_out_PC_next(bindout1218));
  assign bindin1113 = bindout286;
  assign bindin1116 = bindout292;
  assign bindin1119 = bindout289;
  assign bindin1122 = eq3652;
  assign bindin1125 = bindout2771;
  assign bindin1128 = bindout2774;
  assign bindin1131 = bindout2777;
  assign bindin1134 = bindout3139;
  assign bindin1137 = bindout3142;
  assign bindin1140 = bindout3145;
  assign bindin1143 = bindout3148;
  assign bindin1146 = bindout3151;
  assign bindin1149 = bindout3154;
  assign bindin1152 = bindout3648;
  assign bindin1515 = clk;
  assign bindin1516 = reset;
  D_E_Register __module6__(.clk(bindin1515), .reset(bindin1516), .io_in_rd(bindin1517), .io_in_rs1(bindin1520), .io_in_rd1(bindin1523), .io_in_rs2(bindin1526), .io_in_rd2(bindin1529), .io_in_alu_op(bindin1532), .io_in_wb(bindin1535), .io_in_rs2_src(bindin1538), .io_in_itype_immed(bindin1541), .io_in_mem_read(bindin1544), .io_in_mem_write(bindin1547), .io_in_PC_next(bindin1550), .io_in_branch_type(bindin1553), .io_in_fwd_stall(bindin1556), .io_in_upper_immed(bindin1559), .io_in_csr_address(bindin1562), .io_in_is_csr(bindin1565), .io_in_csr_data(bindin1568), .io_in_csr_mask(bindin1571), .io_in_curr_PC(bindin1574), .io_in_jal(bindin1577), .io_in_jal_offset(bindin1580), .io_out_csr_address(bindout1583), .io_out_is_csr(bindout1586), .io_out_csr_data(bindout1589), .io_out_csr_mask(bindout1592), .io_out_rd(bindout1595), .io_out_rs1(bindout1598), .io_out_rd1(bindout1601), .io_out_rs2(bindout1604), .io_out_rd2(bindout1607), .io_out_alu_op(bindout1610), .io_out_wb(bindout1613), .io_out_rs2_src(bindout1616), .io_out_itype_immed(bindout1619), .io_out_mem_read(bindout1622), .io_out_mem_write(bindout1625), .io_out_branch_type(bindout1628), .io_out_upper_immed(bindout1631), .io_out_curr_PC(bindout1634), .io_out_jal(bindout1637), .io_out_jal_offset(bindout1640), .io_out_PC_next(bindout1643));
  assign bindin1517 = bindout1170;
  assign bindin1520 = bindout1173;
  assign bindin1523 = bindout1176;
  assign bindin1526 = bindout1179;
  assign bindin1529 = bindout1182;
  assign bindin1532 = bindout1188;
  assign bindin1535 = bindout1185;
  assign bindin1538 = bindout1191;
  assign bindin1541 = bindout1194;
  assign bindin1544 = bindout1197;
  assign bindin1547 = bindout1200;
  assign bindin1550 = bindout1218;
  assign bindin1553 = bindout1203;
  assign bindin1556 = bindout3157;
  assign bindin1559 = bindout1215;
  assign bindin1562 = bindout1155;
  assign bindin1565 = bindout1158;
  assign bindin1568 = bindout1161;
  assign bindin1571 = bindout1164;
  assign bindin1574 = bindout289;
  assign bindin1577 = bindout1209;
  assign bindin1580 = bindout1212;
  Execute __module7__(.io_in_rd(bindin1901), .io_in_rs1(bindin1904), .io_in_rd1(bindin1907), .io_in_rs2(bindin1910), .io_in_rd2(bindin1913), .io_in_alu_op(bindin1916), .io_in_wb(bindin1919), .io_in_rs2_src(bindin1922), .io_in_itype_immed(bindin1925), .io_in_mem_read(bindin1928), .io_in_mem_write(bindin1931), .io_in_PC_next(bindin1934), .io_in_branch_type(bindin1937), .io_in_upper_immed(bindin1940), .io_in_csr_address(bindin1943), .io_in_is_csr(bindin1946), .io_in_csr_data(bindin1949), .io_in_csr_mask(bindin1952), .io_in_jal(bindin1955), .io_in_jal_offset(bindin1958), .io_in_curr_PC(bindin1961), .io_out_csr_address(bindout1964), .io_out_is_csr(bindout1967), .io_out_csr_result(bindout1970), .io_out_alu_result(bindout1973), .io_out_rd(bindout1976), .io_out_wb(bindout1979), .io_out_rs1(bindout1982), .io_out_rd1(bindout1985), .io_out_rs2(bindout1988), .io_out_rd2(bindout1991), .io_out_mem_read(bindout1994), .io_out_mem_write(bindout1997), .io_out_branch_dir(bindout2000), .io_out_branch_dest(bindout2003), .io_out_jal(bindout2006), .io_out_jal_dest(bindout2009), .io_out_PC_next(bindout2012));
  assign bindin1901 = bindout1595;
  assign bindin1904 = bindout1598;
  assign bindin1907 = bindout1601;
  assign bindin1910 = bindout1604;
  assign bindin1913 = bindout1607;
  assign bindin1916 = bindout1610;
  assign bindin1919 = bindout1613;
  assign bindin1922 = bindout1616;
  assign bindin1925 = bindout1619;
  assign bindin1928 = bindout1622;
  assign bindin1931 = bindout1625;
  assign bindin1934 = bindout1643;
  assign bindin1937 = bindout1628;
  assign bindin1940 = bindout1631;
  assign bindin1943 = bindout1583;
  assign bindin1946 = bindout1586;
  assign bindin1949 = bindout1589;
  assign bindin1952 = bindout1592;
  assign bindin1955 = bindout1637;
  assign bindin1958 = bindout1640;
  assign bindin1961 = bindout1634;
  assign bindin2156 = clk;
  assign bindin2157 = reset;
  E_M_Register __module8__(.clk(bindin2156), .reset(bindin2157), .io_in_alu_result(bindin2158), .io_in_rd(bindin2161), .io_in_wb(bindin2164), .io_in_rs1(bindin2167), .io_in_rd1(bindin2170), .io_in_rs2(bindin2173), .io_in_rd2(bindin2176), .io_in_mem_read(bindin2179), .io_in_mem_write(bindin2182), .io_in_PC_next(bindin2185), .io_in_csr_address(bindin2188), .io_in_is_csr(bindin2191), .io_in_csr_result(bindin2194), .io_out_csr_address(bindout2197), .io_out_is_csr(bindout2200), .io_out_csr_result(bindout2203), .io_out_alu_result(bindout2206), .io_out_rd(bindout2209), .io_out_wb(bindout2212), .io_out_rs1(bindout2215), .io_out_rd1(bindout2218), .io_out_rd2(bindout2221), .io_out_rs2(bindout2224), .io_out_mem_read(bindout2227), .io_out_mem_write(bindout2230), .io_out_PC_next(bindout2233));
  assign bindin2158 = bindout1973;
  assign bindin2161 = bindout1976;
  assign bindin2164 = bindout1979;
  assign bindin2167 = bindout1982;
  assign bindin2170 = bindout1985;
  assign bindin2173 = bindout1988;
  assign bindin2176 = bindout1991;
  assign bindin2179 = bindout1994;
  assign bindin2182 = bindout1997;
  assign bindin2185 = bindout2012;
  assign bindin2188 = bindout1964;
  assign bindin2191 = bindout1967;
  assign bindin2194 = bindout1970;
  Memory __module9__(.io_DBUS_in_data_data(bindin2510), .io_DBUS_in_data_valid(bindin2513), .io_DBUS_out_data_ready(bindin2525), .io_DBUS_out_address_ready(bindin2534), .io_DBUS_out_control_ready(bindin2543), .io_in_alu_result(bindin2546), .io_in_mem_read(bindin2549), .io_in_mem_write(bindin2552), .io_in_rd(bindin2555), .io_in_wb(bindin2558), .io_in_rs1(bindin2561), .io_in_rd1(bindin2564), .io_in_rs2(bindin2567), .io_in_rd2(bindin2570), .io_in_PC_next(bindin2573), .io_DBUS_in_data_ready(bindout2516), .io_DBUS_out_data_data(bindout2519), .io_DBUS_out_data_valid(bindout2522), .io_DBUS_out_address_data(bindout2528), .io_DBUS_out_address_valid(bindout2531), .io_DBUS_out_control_data(bindout2537), .io_DBUS_out_control_valid(bindout2540), .io_out_alu_result(bindout2576), .io_out_mem_result(bindout2579), .io_out_rd(bindout2582), .io_out_wb(bindout2585), .io_out_rs1(bindout2588), .io_out_rs2(bindout2591), .io_out_PC_next(bindout2594));
  assign bindin2510 = io_DBUS_in_data_data;
  assign bindin2513 = io_DBUS_in_data_valid;
  assign bindin2525 = io_DBUS_out_data_ready;
  assign bindin2534 = io_DBUS_out_address_ready;
  assign bindin2543 = io_DBUS_out_control_ready;
  assign bindin2546 = bindout2206;
  assign bindin2549 = bindout2227;
  assign bindin2552 = bindout2230;
  assign bindin2555 = bindout2209;
  assign bindin2558 = bindout2212;
  assign bindin2561 = bindout2215;
  assign bindin2564 = bindout2218;
  assign bindin2567 = bindout2224;
  assign bindin2570 = bindout2221;
  assign bindin2573 = bindout2233;
  assign bindin2675 = clk;
  assign bindin2676 = reset;
  M_W_Register __module11__(.clk(bindin2675), .reset(bindin2676), .io_in_alu_result(bindin2677), .io_in_mem_result(bindin2680), .io_in_rd(bindin2683), .io_in_wb(bindin2686), .io_in_rs1(bindin2689), .io_in_rs2(bindin2692), .io_in_PC_next(bindin2695), .io_out_alu_result(bindout2698), .io_out_mem_result(bindout2701), .io_out_rd(bindout2704), .io_out_wb(bindout2707), .io_out_rs1(bindout2710), .io_out_rs2(bindout2713), .io_out_PC_next(bindout2716));
  assign bindin2677 = bindout2576;
  assign bindin2680 = bindout2579;
  assign bindin2683 = bindout2582;
  assign bindin2686 = bindout2585;
  assign bindin2689 = bindout2588;
  assign bindin2692 = bindout2591;
  assign bindin2695 = bindout2594;
  Write_Back __module12__(.io_in_alu_result(bindin2750), .io_in_mem_result(bindin2753), .io_in_rd(bindin2756), .io_in_wb(bindin2759), .io_in_rs1(bindin2762), .io_in_rs2(bindin2765), .io_in_PC_next(bindin2768), .io_out_write_data(bindout2771), .io_out_rd(bindout2774), .io_out_wb(bindout2777));
  assign bindin2750 = bindout2698;
  assign bindin2753 = bindout2701;
  assign bindin2756 = bindout2704;
  assign bindin2759 = bindout2707;
  assign bindin2762 = bindout2710;
  assign bindin2765 = bindout2713;
  assign bindin2768 = bindout2716;
  Forwarding __module13__(.io_in_decode_src1(bindin3070), .io_in_decode_src2(bindin3073), .io_in_decode_csr_address(bindin3076), .io_in_execute_dest(bindin3079), .io_in_execute_wb(bindin3082), .io_in_execute_alu_result(bindin3085), .io_in_execute_PC_next(bindin3088), .io_in_execute_is_csr(bindin3091), .io_in_execute_csr_address(bindin3094), .io_in_execute_csr_result(bindin3097), .io_in_memory_dest(bindin3100), .io_in_memory_wb(bindin3103), .io_in_memory_alu_result(bindin3106), .io_in_memory_mem_data(bindin3109), .io_in_memory_PC_next(bindin3112), .io_in_memory_is_csr(bindin3115), .io_in_memory_csr_address(bindin3118), .io_in_memory_csr_result(bindin3121), .io_in_writeback_dest(bindin3124), .io_in_writeback_wb(bindin3127), .io_in_writeback_alu_result(bindin3130), .io_in_writeback_mem_data(bindin3133), .io_in_writeback_PC_next(bindin3136), .io_out_src1_fwd(bindout3139), .io_out_src1_fwd_data(bindout3142), .io_out_src2_fwd(bindout3145), .io_out_src2_fwd_data(bindout3148), .io_out_csr_fwd(bindout3151), .io_out_csr_fwd_data(bindout3154), .io_out_fwd_stall(bindout3157));
  assign bindin3070 = bindout1173;
  assign bindin3073 = bindout1179;
  assign bindin3076 = bindout1155;
  assign bindin3079 = bindout1976;
  assign bindin3082 = bindout1979;
  assign bindin3085 = bindout1973;
  assign bindin3088 = bindout2012;
  assign bindin3091 = bindout1967;
  assign bindin3094 = bindout1964;
  assign bindin3097 = bindout1970;
  assign bindin3100 = bindout2582;
  assign bindin3103 = bindout2585;
  assign bindin3106 = bindout2576;
  assign bindin3109 = bindout2579;
  assign bindin3112 = bindout2594;
  assign bindin3115 = bindout2200;
  assign bindin3118 = bindout2197;
  assign bindin3121 = bindout2203;
  assign bindin3124 = bindout2704;
  assign bindin3127 = bindout2707;
  assign bindin3130 = bindout2698;
  assign bindin3133 = bindout2701;
  assign bindin3136 = bindout2716;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3176), .io_INTERRUPT_in_interrupt_id_valid(bindin3179), .io_INTERRUPT_in_interrupt_id_ready(bindout3182), .io_out_interrupt(bindout3185), .io_out_interrupt_pc(bindout3188));
  assign bindin3176 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3179 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3529 = clk;
  assign bindin3530 = reset;
  JTAG __module15__(.clk(bindin3529), .reset(bindin3530), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3531), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3534), .io_JTAG_JTAG_TAP_in_clock_data(bindin3540), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3543), .io_JTAG_JTAG_TAP_in_reset_data(bindin3549), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3552), .io_JTAG_in_data_data(bindin3558), .io_JTAG_in_data_valid(bindin3561), .io_JTAG_out_data_ready(bindin3573), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3537), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3546), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3555), .io_JTAG_in_data_ready(bindout3564), .io_JTAG_out_data_data(bindout3567), .io_JTAG_out_data_valid(bindout3570));
  assign bindin3531 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3534 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3540 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3543 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3549 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3552 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3558 = io_jtag_in_data_data;
  assign bindin3561 = io_jtag_in_data_valid;
  assign bindin3573 = io_jtag_out_data_ready;
  assign bindin3634 = clk;
  assign bindin3635 = reset;
  CSR_Handler __module17__(.clk(bindin3634), .reset(bindin3635), .io_in_decode_csr_address(bindin3636), .io_in_mem_csr_address(bindin3639), .io_in_mem_is_csr(bindin3642), .io_in_mem_csr_result(bindin3645), .io_out_decode_csr_data(bindout3648));
  assign bindin3636 = bindout1155;
  assign bindin3639 = bindout2197;
  assign bindin3642 = bindout2200;
  assign bindin3645 = bindout2203;
  assign eq3652 = bindout3157 == 1'h1;

  assign io_IBUS_in_data_ready = bindout168;
  assign io_IBUS_out_address_data = bindout171;
  assign io_IBUS_out_address_valid = bindout174;
  assign io_DBUS_in_data_ready = bindout2516;
  assign io_DBUS_out_data_data = bindout2519;
  assign io_DBUS_out_data_valid = bindout2522;
  assign io_DBUS_out_address_data = bindout2528;
  assign io_DBUS_out_address_valid = bindout2531;
  assign io_DBUS_out_control_data = bindout2537;
  assign io_DBUS_out_control_valid = bindout2540;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3182;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3537;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3546;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3555;
  assign io_jtag_in_data_ready = bindout3564;
  assign io_jtag_out_data_data = bindout3567;
  assign io_jtag_out_data_valid = bindout3570;
  assign io_out_fwd_stall = bindout3157;
  assign io_out_branch_stall = bindout1206;
  assign io_actual_change = bindout1167;

endmodule
