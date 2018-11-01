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
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg112;
  wire eq119, eq123, orl125, eq132, eq138;
  wire[31:0] sel128, sel134, sel140, sel142, add147, sel149;

  always @ (posedge clk) begin
    if (reset)
      reg112 <= 32'h0;
    else
      reg112 <= sel149;
  end
  assign eq119 = io_in_fwd_stall == 1'h1;
  assign eq123 = io_in_branch_stall == 1'h1;
  assign orl125 = eq123 | eq119;
  assign sel128 = orl125 ? 32'h0 : io_IBUS_in_data_data;
  assign eq132 = io_in_branch_dir == 1'h1;
  assign sel134 = eq132 ? io_in_branch_dest : reg112;
  assign eq138 = io_in_jal == 1'h1;
  assign sel140 = eq138 ? io_in_jal_dest : sel134;
  assign sel142 = io_in_interrupt ? io_in_interrupt_pc : sel140;
  assign add147 = sel142 + 32'h4;
  assign sel149 = orl125 ? sel142 : add147;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_valid;
  assign io_IBUS_out_address_data = sel142;
  assign io_IBUS_out_address_valid = 1'h1;
  assign io_out_instruction = sel128;
  assign io_out_PC_next = add147;

endmodule

module F_D_Register(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
  input wire io_in_branch_stall,
  input wire io_in_fwd_stall,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg221, reg230;
  wire eq245;
  wire[31:0] sel247, sel248;

  always @ (posedge clk) begin
    if (reset)
      reg221 <= 32'h0;
    else
      reg221 <= sel248;
  end
  always @ (posedge clk) begin
    if (reset)
      reg230 <= 32'h0;
    else
      reg230 <= sel247;
  end
  assign eq245 = io_in_fwd_stall == 1'h0;
  assign sel247 = eq245 ? io_in_PC_next : reg230;
  assign sel248 = eq245 ? io_in_instruction : reg221;

  assign io_out_instruction = reg221;
  assign io_out_PC_next = reg230;

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
  reg[31:0] mem360 [0:31];
  wire ne386, andl389, eq397, eq406;
  wire[31:0] mrport392, sel399, mrport401, sel408;

  always @ (posedge clk) begin
    if (1'h1) begin
      mem360[5'h0] <= 32'h0;
    end
  end
  always @ (posedge clk) begin
    if (andl389) begin
      mem360[io_in_rd] <= io_in_data;
    end
  end
  assign mrport392 = mem360[io_in_src1];
  assign mrport401 = mem360[io_in_src2];
  assign ne386 = io_in_rd != 5'h0;
  assign andl389 = io_in_write_register & ne386;
  assign eq397 = io_in_src1 == 5'h0;
  assign sel399 = eq397 ? 32'h0 : mrport392;
  assign eq406 = io_in_src2 == 5'h0;
  assign sel408 = eq406 ? 32'h0 : mrport401;

  assign io_out_src1_data = sel399;
  assign io_out_src2_data = sel408;

endmodule

module Decode(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
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
  output wire[31:0] io_out_jal_dest,
  output wire[19:0] io_out_upper_immed,
  output wire[31:0] io_out_PC_next
);
  wire bindin431, bindin433, bindin434, ne494, sel496, eq500, eq554, eq560, eq567, eq572, eq577, orl579, eq584, eq589, eq594, eq599, eq604, eq609, ne614, eq619, andl621, proxy624, eq625, andl628, eq632, andl638, eq646, orl654, orl656, orl658, orl660, andl662, andl669, orl676, orl678, andl680, orl687, sel689, andl700, eq717, eq722, orl724, proxy777, proxy778, lt811, proxy883, eq913, proxy946, eq947, sel964, sel965, sel967, sel968, sel970, sel971, eq995, eq1032, eq1040, eq1048, orl1054, lt1072;
  wire[4:0] bindin437, bindin443, bindin446, sel516, proxy524, proxy531;
  wire[31:0] bindin440, bindout449, bindout452, shr512, shr521, shr528, shr535, shr542, sel556, sel562, pad640, sel642, sel648, shr782, shr887, proxy903, proxy909, sel915, sub919, add921, proxy936, proxy942, sel949, add951, sel973, sel974;
  wire[6:0] sel505, proxy545;
  wire[2:0] proxy538, sel696, sel702, sel977, sel978;
  wire[1:0] sel664, sel671, sel682, proxy1027;
  wire[11:0] proxy728, sel736, proxy754, proxy793, proxy931, sel961, sel962, sel983, sel984;
  wire[3:0] proxy785, sel997, sel1000, sel1017, sel1034, sel1042, sel1050, sel1056, sel1058, sel1062, sel1066, sel1074, sel1076;
  wire[5:0] proxy791;
  wire[19:0] proxy854, sel980, sel981;
  wire[7:0] proxy882;
  wire[9:0] proxy890;
  wire[20:0] proxy894;
  reg[11:0] sel963, sel985;
  reg sel966, sel969, sel972;
  reg[31:0] sel975;
  reg[2:0] sel976, sel979;
  reg[19:0] sel982;
  reg[3:0] sel1025;

  assign bindin431 = clk;
  assign bindin433 = reset;
  RegisterFile __module5__(.clk(bindin431), .reset(bindin433), .io_in_write_register(bindin434), .io_in_rd(bindin437), .io_in_data(bindin440), .io_in_src1(bindin443), .io_in_src2(bindin446), .io_out_src1_data(bindout449), .io_out_src2_data(bindout452));
  assign bindin434 = sel496;
  assign bindin437 = io_in_rd;
  assign bindin440 = io_in_write_data;
  assign bindin443 = proxy524;
  assign bindin446 = proxy531;
  assign ne494 = io_in_wb != 2'h0;
  assign sel496 = ne494 ? 1'h1 : 1'h0;
  assign eq500 = io_in_stall == 1'h0;
  assign sel505 = eq500 ? io_in_instruction[6:0] : 7'h0;
  assign shr512 = io_in_instruction >> 32'h7;
  assign sel516 = eq500 ? shr512[4:0] : 5'h0;
  assign shr521 = io_in_instruction >> 32'hf;
  assign proxy524 = shr521[4:0];
  assign shr528 = io_in_instruction >> 32'h14;
  assign proxy531 = shr528[4:0];
  assign shr535 = io_in_instruction >> 32'hc;
  assign proxy538 = shr535[2:0];
  assign shr542 = io_in_instruction >> 32'h19;
  assign proxy545 = shr542[6:0];
  assign eq554 = io_in_src1_fwd == 1'h1;
  assign sel556 = eq554 ? io_in_src1_fwd_data : bindout449;
  assign eq560 = io_in_src2_fwd == 1'h1;
  assign sel562 = eq560 ? io_in_src2_fwd_data : bindout452;
  assign eq567 = sel505 == 7'h33;
  assign eq572 = sel505 == 7'h3;
  assign eq577 = sel505 == 7'h13;
  assign orl579 = eq577 | eq572;
  assign eq584 = sel505 == 7'h23;
  assign eq589 = sel505 == 7'h63;
  assign eq594 = sel505 == 7'h6f;
  assign eq599 = sel505 == 7'h67;
  assign eq604 = sel505 == 7'h37;
  assign eq609 = sel505 == 7'h17;
  assign ne614 = proxy538 != 3'h0;
  assign eq619 = sel505 == 7'h73;
  assign andl621 = eq619 & ne614;
  assign proxy624 = proxy538[2];
  assign eq625 = proxy624 == 1'h1;
  assign andl628 = andl621 & eq625;
  assign eq632 = proxy538 == 3'h0;
  assign andl638 = eq619 & eq632;
  assign pad640 = {{27{1'b0}}, proxy531};
  assign sel642 = andl628 ? pad640 : sel562;
  assign eq646 = io_in_csr_fwd == 1'h1;
  assign sel648 = eq646 ? io_in_csr_fwd_data : io_in_csr_data;
  assign orl654 = orl579 | eq567;
  assign orl656 = orl654 | eq604;
  assign orl658 = orl656 | eq609;
  assign orl660 = orl658 | andl621;
  assign andl662 = orl660 & eq500;
  assign sel664 = andl662 ? 2'h1 : 2'h0;
  assign andl669 = eq572 & eq500;
  assign sel671 = andl669 ? 2'h2 : sel664;
  assign orl676 = eq594 | eq599;
  assign orl678 = orl676 | andl638;
  assign andl680 = orl678 & eq500;
  assign sel682 = andl680 ? 2'h3 : sel671;
  assign orl687 = orl579 | eq584;
  assign sel689 = orl687 ? 1'h1 : 1'h0;
  assign sel696 = andl669 ? proxy538 : 3'h7;
  assign andl700 = eq584 & eq500;
  assign sel702 = andl700 ? proxy538 : 3'h7;
  assign eq717 = proxy538 == 3'h5;
  assign eq722 = proxy538 == 3'h1;
  assign orl724 = eq722 | eq717;
  assign proxy728 = {7'h0, proxy531};
  assign sel736 = orl724 ? proxy728 : shr528[11:0];
  assign proxy754 = {proxy545, sel516};
  assign proxy777 = io_in_instruction[31];
  assign proxy778 = io_in_instruction[7];
  assign shr782 = io_in_instruction >> 32'h8;
  assign proxy785 = shr782[3:0];
  assign proxy791 = shr542[5:0];
  assign proxy793 = {proxy777, proxy778, proxy791, proxy785};
  assign lt811 = shr528[11:0] < 12'h2;
  assign proxy854 = {proxy545, proxy531, proxy524, proxy538};
  assign proxy882 = shr535[7:0];
  assign proxy883 = io_in_instruction[20];
  assign shr887 = io_in_instruction >> 32'h15;
  assign proxy890 = shr887[9:0];
  assign proxy894 = {proxy777, proxy882, proxy883, proxy890, 1'h0};
  assign proxy903 = {11'h0, proxy894};
  assign proxy909 = {11'h7ff, proxy894};
  assign eq913 = proxy777 == 1'h1;
  assign sel915 = eq913 ? proxy909 : proxy903;
  assign sub919 = $signed(io_in_PC_next) - $signed(32'h4);
  assign add921 = $signed(sub919) + $signed(sel915);
  assign proxy931 = {proxy545, proxy531};
  assign proxy936 = {20'h0, proxy931};
  assign proxy942 = {20'hfffff, proxy931};
  assign proxy946 = proxy931[11];
  assign eq947 = proxy946 == 1'h1;
  assign sel949 = eq947 ? proxy942 : proxy936;
  assign add951 = $signed(sel556) + $signed(sel949);
  assign sel961 = lt811 ? 12'h7b : 12'h7b;
  assign sel962 = (proxy538 == 3'h0) ? sel961 : 12'h7b;
  always @(*) begin
    case (sel505)
      7'h13: sel963 = sel736;
      7'h33: sel963 = 12'h7b;
      7'h23: sel963 = proxy754;
      7'h03: sel963 = shr528[11:0];
      7'h63: sel963 = proxy793;
      7'h73: sel963 = sel962;
      7'h37: sel963 = 12'h7b;
      7'h17: sel963 = 12'h7b;
      7'h6f: sel963 = 12'h7b;
      7'h67: sel963 = 12'h7b;
      default: sel963 = 12'h7b;
    endcase
  end
  assign sel964 = lt811 ? 1'h0 : 1'h1;
  assign sel965 = (proxy538 == 3'h0) ? sel964 : 1'h1;
  always @(*) begin
    case (sel505)
      7'h13: sel966 = 1'h0;
      7'h33: sel966 = 1'h0;
      7'h23: sel966 = 1'h0;
      7'h03: sel966 = 1'h0;
      7'h63: sel966 = 1'h0;
      7'h73: sel966 = sel965;
      7'h37: sel966 = 1'h0;
      7'h17: sel966 = 1'h0;
      7'h6f: sel966 = 1'h0;
      7'h67: sel966 = 1'h0;
      default: sel966 = 1'h0;
    endcase
  end
  assign sel967 = lt811 ? 1'h0 : 1'h0;
  assign sel968 = (proxy538 == 3'h0) ? sel967 : 1'h0;
  always @(*) begin
    case (sel505)
      7'h13: sel969 = 1'h0;
      7'h33: sel969 = 1'h0;
      7'h23: sel969 = 1'h0;
      7'h03: sel969 = 1'h0;
      7'h63: sel969 = 1'h1;
      7'h73: sel969 = sel968;
      7'h37: sel969 = 1'h0;
      7'h17: sel969 = 1'h0;
      7'h6f: sel969 = 1'h0;
      7'h67: sel969 = 1'h0;
      default: sel969 = 1'h0;
    endcase
  end
  assign sel970 = lt811 ? 1'h1 : 1'h0;
  assign sel971 = (proxy538 == 3'h0) ? sel970 : 1'h0;
  always @(*) begin
    case (sel505)
      7'h13: sel972 = 1'h0;
      7'h33: sel972 = 1'h0;
      7'h23: sel972 = 1'h0;
      7'h03: sel972 = 1'h0;
      7'h63: sel972 = 1'h0;
      7'h73: sel972 = sel971;
      7'h37: sel972 = 1'h0;
      7'h17: sel972 = 1'h0;
      7'h6f: sel972 = 1'h1;
      7'h67: sel972 = 1'h1;
      default: sel972 = 1'h0;
    endcase
  end
  assign sel973 = lt811 ? 32'h12345678 : 32'h7b;
  assign sel974 = (proxy538 == 3'h0) ? sel973 : 32'h7b;
  always @(*) begin
    case (sel505)
      7'h13: sel975 = 32'h7b;
      7'h33: sel975 = 32'h7b;
      7'h23: sel975 = 32'h7b;
      7'h03: sel975 = 32'h7b;
      7'h63: sel975 = 32'h7b;
      7'h73: sel975 = sel974;
      7'h37: sel975 = 32'h7b;
      7'h17: sel975 = 32'h7b;
      7'h6f: sel975 = add921;
      7'h67: sel975 = add951;
      default: sel975 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy538)
      3'h0: sel976 = 3'h1;
      3'h1: sel976 = 3'h2;
      3'h4: sel976 = 3'h3;
      3'h5: sel976 = 3'h4;
      3'h6: sel976 = 3'h5;
      3'h7: sel976 = 3'h6;
      default: sel976 = 3'h0;
    endcase
  end
  assign sel977 = lt811 ? 3'h0 : 3'h0;
  assign sel978 = (proxy538 == 3'h0) ? sel977 : 3'h0;
  always @(*) begin
    case (sel505)
      7'h13: sel979 = 3'h0;
      7'h33: sel979 = 3'h0;
      7'h23: sel979 = 3'h0;
      7'h03: sel979 = 3'h0;
      7'h63: sel979 = sel976;
      7'h73: sel979 = sel978;
      7'h37: sel979 = 3'h0;
      7'h17: sel979 = 3'h0;
      7'h6f: sel979 = 3'h0;
      7'h67: sel979 = 3'h0;
      default: sel979 = 3'h0;
    endcase
  end
  assign sel980 = lt811 ? 20'h7b : 20'h7b;
  assign sel981 = (proxy538 == 3'h0) ? sel980 : 20'h7b;
  always @(*) begin
    case (sel505)
      7'h13: sel982 = 20'h7b;
      7'h33: sel982 = 20'h7b;
      7'h23: sel982 = 20'h7b;
      7'h03: sel982 = 20'h7b;
      7'h63: sel982 = 20'h7b;
      7'h73: sel982 = sel981;
      7'h37: sel982 = proxy854;
      7'h17: sel982 = proxy854;
      7'h6f: sel982 = 20'h7b;
      7'h67: sel982 = 20'h7b;
      default: sel982 = 20'h7b;
    endcase
  end
  assign sel983 = lt811 ? 12'h7b : shr528[11:0];
  assign sel984 = (proxy538 == 3'h0) ? sel983 : shr528[11:0];
  always @(*) begin
    case (sel505)
      7'h13: sel985 = 12'h7b;
      7'h33: sel985 = 12'h7b;
      7'h23: sel985 = 12'h7b;
      7'h03: sel985 = 12'h7b;
      7'h63: sel985 = 12'h7b;
      7'h73: sel985 = sel984;
      7'h37: sel985 = 12'h7b;
      7'h17: sel985 = 12'h7b;
      7'h6f: sel985 = 12'h7b;
      7'h67: sel985 = 12'h7b;
      default: sel985 = 12'h7b;
    endcase
  end
  assign eq995 = proxy545 == 7'h0;
  assign sel997 = eq995 ? 4'h0 : 4'h1;
  assign sel1000 = eq577 ? 4'h0 : sel997;
  assign sel1017 = eq995 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy538)
      3'h0: sel1025 = sel1000;
      3'h1: sel1025 = 4'h2;
      3'h2: sel1025 = 4'h3;
      3'h3: sel1025 = 4'h4;
      3'h4: sel1025 = 4'h5;
      3'h5: sel1025 = sel1017;
      3'h6: sel1025 = 4'h8;
      3'h7: sel1025 = 4'h9;
      default: sel1025 = 4'hf;
    endcase
  end
  assign proxy1027 = proxy538[1:0];
  assign eq1032 = proxy1027 == 2'h3;
  assign sel1034 = eq1032 ? 4'hf : 4'hf;
  assign eq1040 = proxy1027 == 2'h2;
  assign sel1042 = eq1040 ? 4'he : sel1034;
  assign eq1048 = proxy1027 == 2'h1;
  assign sel1050 = eq1048 ? 4'hd : sel1042;
  assign orl1054 = eq584 | eq572;
  assign sel1056 = orl1054 ? 4'h0 : sel1025;
  assign sel1058 = andl621 ? sel1050 : sel1056;
  assign sel1062 = eq609 ? 4'hc : sel1058;
  assign sel1066 = eq604 ? 4'hb : sel1062;
  assign lt1072 = sel979 < 3'h5;
  assign sel1074 = lt1072 ? 4'h1 : 4'ha;
  assign sel1076 = eq589 ? sel1074 : sel1066;

  assign io_out_csr_address = sel985;
  assign io_out_is_csr = sel966;
  assign io_out_csr_data = sel648;
  assign io_out_csr_mask = sel642;
  assign io_actual_change = 32'h1;
  assign io_out_rd = sel516;
  assign io_out_rs1 = proxy524;
  assign io_out_rd1 = sel556;
  assign io_out_rs2 = proxy531;
  assign io_out_rd2 = sel562;
  assign io_out_wb = sel682;
  assign io_out_alu_op = sel1076;
  assign io_out_rs2_src = sel689;
  assign io_out_itype_immed = sel963;
  assign io_out_mem_read = sel696;
  assign io_out_mem_write = sel702;
  assign io_out_branch_type = sel979;
  assign io_out_branch_stall = sel969;
  assign io_out_jal = sel972;
  assign io_out_jal_dest = sel975;
  assign io_out_upper_immed = sel982;
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
  output wire[31:0] io_out_PC_next
);
  reg[4:0] reg1267, reg1276, reg1289;
  reg[31:0] reg1283, reg1295, reg1315, reg1373, reg1379;
  reg[3:0] reg1302;
  reg[1:0] reg1309;
  reg reg1322, reg1367;
  reg[11:0] reg1329, reg1361;
  reg[2:0] reg1336, reg1342, reg1348;
  reg[19:0] reg1355;
  wire eq1383, sel1411, sel1434;
  wire[4:0] sel1386, sel1389, sel1395;
  wire[31:0] sel1392, sel1398, sel1408, sel1437, sel1440;
  wire[3:0] sel1402;
  wire[1:0] sel1405;
  wire[11:0] sel1415, sel1431;
  wire[2:0] sel1419, sel1422, sel1425;
  wire[19:0] sel1428;

  always @ (posedge clk) begin
    if (reset)
      reg1267 <= 5'h0;
    else
      reg1267 <= sel1386;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1276 <= 5'h0;
    else
      reg1276 <= sel1389;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1283 <= 32'h0;
    else
      reg1283 <= sel1392;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1289 <= 5'h0;
    else
      reg1289 <= sel1395;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1295 <= 32'h0;
    else
      reg1295 <= sel1398;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1302 <= 4'h0;
    else
      reg1302 <= sel1402;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1309 <= 2'h0;
    else
      reg1309 <= sel1405;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1315 <= 32'h0;
    else
      reg1315 <= sel1408;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1322 <= 1'h0;
    else
      reg1322 <= sel1411;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1329 <= 12'h0;
    else
      reg1329 <= sel1415;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1336 <= 3'h0;
    else
      reg1336 <= sel1419;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1342 <= 3'h0;
    else
      reg1342 <= sel1422;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1348 <= 3'h0;
    else
      reg1348 <= sel1425;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1355 <= 20'h0;
    else
      reg1355 <= sel1428;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1361 <= 12'h0;
    else
      reg1361 <= sel1431;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1367 <= 1'h0;
    else
      reg1367 <= sel1434;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1373 <= 32'h0;
    else
      reg1373 <= sel1437;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1379 <= 32'h0;
    else
      reg1379 <= sel1440;
  end
  assign eq1383 = io_in_fwd_stall == 1'h1;
  assign sel1386 = eq1383 ? 5'h0 : io_in_rd;
  assign sel1389 = eq1383 ? 5'h0 : io_in_rs1;
  assign sel1392 = eq1383 ? 32'h0 : io_in_rd1;
  assign sel1395 = eq1383 ? 5'h0 : io_in_rs2;
  assign sel1398 = eq1383 ? 32'h0 : io_in_rd2;
  assign sel1402 = eq1383 ? 4'hf : io_in_alu_op;
  assign sel1405 = eq1383 ? 2'h0 : io_in_wb;
  assign sel1408 = eq1383 ? 32'h0 : io_in_PC_next;
  assign sel1411 = eq1383 ? 1'h0 : io_in_rs2_src;
  assign sel1415 = eq1383 ? 12'h7b : io_in_itype_immed;
  assign sel1419 = eq1383 ? 3'h7 : io_in_mem_read;
  assign sel1422 = eq1383 ? 3'h7 : io_in_mem_write;
  assign sel1425 = eq1383 ? 3'h0 : io_in_branch_type;
  assign sel1428 = eq1383 ? 20'h0 : io_in_upper_immed;
  assign sel1431 = eq1383 ? 12'h0 : io_in_csr_address;
  assign sel1434 = eq1383 ? 1'h0 : io_in_is_csr;
  assign sel1437 = eq1383 ? 32'h0 : io_in_csr_data;
  assign sel1440 = eq1383 ? 32'h0 : io_in_csr_mask;

  assign io_out_csr_address = reg1361;
  assign io_out_is_csr = reg1367;
  assign io_out_csr_data = reg1373;
  assign io_out_csr_mask = reg1379;
  assign io_out_rd = reg1267;
  assign io_out_rs1 = reg1276;
  assign io_out_rd1 = reg1283;
  assign io_out_rs2 = reg1289;
  assign io_out_rd2 = reg1295;
  assign io_out_alu_op = reg1302;
  assign io_out_wb = reg1309;
  assign io_out_rs2_src = reg1322;
  assign io_out_itype_immed = reg1329;
  assign io_out_mem_read = reg1336;
  assign io_out_mem_write = reg1342;
  assign io_out_branch_type = reg1348;
  assign io_out_upper_immed = reg1355;
  assign io_out_PC_next = reg1315;

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
  output wire[31:0] io_out_PC_next
);
  wire[31:0] proxy1622, proxy1628, sel1636, sel1643, proxy1648, shl1653, sub1657, add1659, add1668, sub1673, shl1677, sel1686, xorl1699, shr1703, orl1712, andl1717, add1733, orl1739, sub1743, andl1746, sel1751;
  wire eq1634, eq1641, lt1684, gt1721, eq1758, sel1760, sel1768, eq1775, sel1777, sel1786;
  reg[31:0] sel1750, sel1752;
  reg sel1809;

  assign proxy1622 = {20'h0, io_in_itype_immed};
  assign proxy1628 = {20'hfffff, io_in_itype_immed};
  assign eq1634 = io_in_itype_immed[11] == 1'h1;
  assign sel1636 = eq1634 ? proxy1628 : proxy1622;
  assign eq1641 = io_in_rs2_src == 1'h1;
  assign sel1643 = eq1641 ? sel1636 : io_in_rd2;
  assign proxy1648 = {io_in_upper_immed, 12'h0};
  assign shl1653 = $signed(sel1636) << 32'h1;
  assign sub1657 = $signed(io_in_PC_next) - $signed(32'h4);
  assign add1659 = $signed(sub1657) + $signed(shl1653);
  assign add1668 = $signed(io_in_rd1) + $signed(sel1643);
  assign sub1673 = $signed(io_in_rd1) - $signed(sel1643);
  assign shl1677 = io_in_rd1 << sel1643;
  assign lt1684 = $signed(io_in_rd1) < $signed(sel1643);
  assign sel1686 = lt1684 ? 32'h0 : 32'h1;
  assign xorl1699 = io_in_rd1 ^ sel1643;
  assign shr1703 = io_in_rd1 >> sel1643;
  assign orl1712 = io_in_rd1 | sel1643;
  assign andl1717 = sel1643 & io_in_rd1;
  assign gt1721 = io_in_rd1 > sel1643;
  assign add1733 = $signed(sub1657) + $signed(proxy1648);
  assign orl1739 = io_in_csr_data | io_in_csr_mask;
  assign sub1743 = 32'hffffffff - io_in_csr_mask;
  assign andl1746 = io_in_csr_data & sub1743;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1750 = 32'h7b;
      4'h1: sel1750 = 32'h7b;
      4'h2: sel1750 = 32'h7b;
      4'h3: sel1750 = 32'h7b;
      4'h4: sel1750 = 32'h7b;
      4'h5: sel1750 = 32'h7b;
      4'h6: sel1750 = 32'h7b;
      4'h7: sel1750 = 32'h7b;
      4'h8: sel1750 = 32'h7b;
      4'h9: sel1750 = 32'h7b;
      4'ha: sel1750 = 32'h7b;
      4'hb: sel1750 = 32'h7b;
      4'hc: sel1750 = 32'h7b;
      4'hd: sel1750 = io_in_csr_mask;
      4'he: sel1750 = orl1739;
      4'hf: sel1750 = andl1746;
      default: sel1750 = 32'h7b;
    endcase
  end
  assign sel1751 = gt1721 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1752 = add1668;
      4'h1: sel1752 = sub1673;
      4'h2: sel1752 = shl1677;
      4'h3: sel1752 = sel1686;
      4'h4: sel1752 = sel1686;
      4'h5: sel1752 = xorl1699;
      4'h6: sel1752 = shr1703;
      4'h7: sel1752 = shr1703;
      4'h8: sel1752 = orl1712;
      4'h9: sel1752 = andl1717;
      4'ha: sel1752 = sel1751;
      4'hb: sel1752 = proxy1648;
      4'hc: sel1752 = add1733;
      4'hd: sel1752 = io_in_csr_data;
      4'he: sel1752 = io_in_csr_data;
      4'hf: sel1752 = io_in_csr_data;
      default: sel1752 = 32'h0;
    endcase
  end
  assign eq1758 = sel1752 == 32'h0;
  assign sel1760 = eq1758 ? 1'h1 : 1'h0;
  assign sel1768 = eq1758 ? 1'h0 : 1'h1;
  assign eq1775 = sel1752[31] == 1'h0;
  assign sel1777 = eq1775 ? 1'h0 : 1'h1;
  assign sel1786 = eq1775 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel1809 = sel1760;
      3'h2: sel1809 = sel1768;
      3'h3: sel1809 = sel1777;
      3'h4: sel1809 = sel1786;
      3'h5: sel1809 = sel1777;
      3'h6: sel1809 = sel1786;
      3'h0: sel1809 = 1'h0;
      default: sel1809 = 1'h0;
    endcase
  end

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1750;
  assign io_out_alu_result = sel1752;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_branch_dir = sel1809;
  assign io_out_branch_dest = add1659;
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
  reg[31:0] reg1968, reg1990, reg2002, reg2015, reg2048;
  reg[4:0] reg1978, reg1984, reg1996;
  reg[1:0] reg2009;
  reg[2:0] reg2022, reg2028;
  reg[11:0] reg2035;
  reg reg2042;

  always @ (posedge clk) begin
    if (reset)
      reg1968 <= 32'h0;
    else
      reg1968 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1978 <= 5'h0;
    else
      reg1978 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1984 <= 5'h0;
    else
      reg1984 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1990 <= 32'h0;
    else
      reg1990 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1996 <= 5'h0;
    else
      reg1996 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2002 <= 32'h0;
    else
      reg2002 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2009 <= 2'h0;
    else
      reg2009 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2015 <= 32'h0;
    else
      reg2015 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2022 <= 3'h0;
    else
      reg2022 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2028 <= 3'h0;
    else
      reg2028 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2035 <= 12'h0;
    else
      reg2035 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2042 <= 1'h0;
    else
      reg2042 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2048 <= 32'h0;
    else
      reg2048 <= io_in_csr_result;
  end

  assign io_out_csr_address = reg2035;
  assign io_out_is_csr = reg2042;
  assign io_out_csr_result = reg2048;
  assign io_out_alu_result = reg1968;
  assign io_out_rd = reg1978;
  assign io_out_wb = reg2009;
  assign io_out_rs1 = reg1984;
  assign io_out_rd1 = reg1990;
  assign io_out_rd2 = reg2002;
  assign io_out_rs2 = reg1996;
  assign io_out_mem_read = reg2022;
  assign io_out_mem_write = reg2028;
  assign io_out_PC_next = reg2015;

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
  wire eq2224, eq2228, orl2238;
  wire[1:0] sel2248, sel2256;

  assign eq2224 = io_in_mem_read == 3'h2;
  assign eq2228 = io_in_mem_write == 3'h2;
  assign orl2238 = eq2224 | eq2228;
  assign sel2248 = eq2228 ? 2'h2 : 2'h0;
  assign sel2256 = eq2224 ? 2'h1 : sel2248;

  assign io_DBUS_in_data_ready = eq2224;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = eq2228;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2238;
  assign io_DBUS_out_control_data = sel2256;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = io_DBUS_in_data_data;

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
  wire[31:0] bindin2263, bindout2272, bindout2281, bindin2299, bindin2308, bindout2311;
  wire bindin2266, bindout2269, bindout2275, bindin2278, bindout2284, bindin2287, bindout2293, bindin2296;
  wire[1:0] bindout2290;
  wire[2:0] bindin2302, bindin2305;

  Cache __module10__(.io_DBUS_in_data_data(bindin2263), .io_DBUS_in_data_valid(bindin2266), .io_DBUS_out_data_ready(bindin2278), .io_DBUS_out_address_ready(bindin2287), .io_DBUS_out_control_ready(bindin2296), .io_in_address(bindin2299), .io_in_mem_read(bindin2302), .io_in_mem_write(bindin2305), .io_in_data(bindin2308), .io_DBUS_in_data_ready(bindout2269), .io_DBUS_out_data_data(bindout2272), .io_DBUS_out_data_valid(bindout2275), .io_DBUS_out_address_data(bindout2281), .io_DBUS_out_address_valid(bindout2284), .io_DBUS_out_control_data(bindout2290), .io_DBUS_out_control_valid(bindout2293), .io_out_data(bindout2311));
  assign bindin2263 = io_DBUS_in_data_data;
  assign bindin2266 = io_DBUS_in_data_valid;
  assign bindin2278 = io_DBUS_out_data_ready;
  assign bindin2287 = io_DBUS_out_address_ready;
  assign bindin2296 = io_DBUS_out_control_ready;
  assign bindin2299 = io_in_alu_result;
  assign bindin2302 = io_in_mem_read;
  assign bindin2305 = io_in_mem_write;
  assign bindin2308 = io_in_rd2;

  assign io_DBUS_in_data_ready = bindout2269;
  assign io_DBUS_out_data_data = bindout2272;
  assign io_DBUS_out_data_valid = bindout2275;
  assign io_DBUS_out_address_data = bindout2281;
  assign io_DBUS_out_address_valid = bindout2284;
  assign io_DBUS_out_control_data = bindout2290;
  assign io_DBUS_out_control_valid = bindout2293;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2311;
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
  reg[31:0] reg2434, reg2443, reg2475;
  reg[4:0] reg2450, reg2456, reg2462;
  reg[1:0] reg2469;

  always @ (posedge clk) begin
    if (reset)
      reg2434 <= 32'h0;
    else
      reg2434 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2443 <= 32'h0;
    else
      reg2443 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2450 <= 5'h0;
    else
      reg2450 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2456 <= 5'h0;
    else
      reg2456 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2462 <= 5'h0;
    else
      reg2462 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2469 <= 2'h0;
    else
      reg2469 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2475 <= 32'h0;
    else
      reg2475 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2434;
  assign io_out_mem_result = reg2443;
  assign io_out_rd = reg2450;
  assign io_out_wb = reg2469;
  assign io_out_rs1 = reg2456;
  assign io_out_rs2 = reg2462;
  assign io_out_PC_next = reg2475;

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
  wire eq2541, eq2546;
  wire[31:0] sel2548, sel2550;

  assign eq2541 = io_in_wb == 2'h3;
  assign eq2546 = io_in_wb == 2'h1;
  assign sel2548 = eq2546 ? io_in_alu_result : io_in_mem_result;
  assign sel2550 = eq2541 ? io_in_PC_next : sel2548;

  assign io_out_write_data = sel2550;
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
  wire eq2630, eq2634, eq2638, eq2643, eq2647, eq2651, eq2656, eq2660, ne2665, ne2670, eq2673, andl2675, andl2677, eq2682, ne2686, eq2693, andl2695, andl2697, andl2699, eq2703, ne2711, eq2718, andl2720, andl2722, andl2724, andl2726, orl2729, orl2731, ne2757, eq2760, andl2762, andl2764, eq2768, eq2779, andl2781, andl2783, andl2785, eq2789, eq2804, andl2806, andl2808, andl2810, andl2812, orl2815, orl2817, eq2837, andl2839, eq2843, eq2846, andl2848, andl2850, orl2853, orl2863, andl2865, sel2867;
  wire[31:0] sel2735, sel2737, sel2739, sel2741, sel2743, sel2745, sel2747, sel2749, sel2824, sel2830, sel2834, sel2856, sel2858;

  assign eq2630 = io_in_execute_wb == 2'h2;
  assign eq2634 = io_in_memory_wb == 2'h2;
  assign eq2638 = io_in_writeback_wb == 2'h2;
  assign eq2643 = io_in_execute_wb == 2'h3;
  assign eq2647 = io_in_memory_wb == 2'h3;
  assign eq2651 = io_in_writeback_wb == 2'h3;
  assign eq2656 = io_in_execute_is_csr == 1'h1;
  assign eq2660 = io_in_memory_is_csr == 1'h1;
  assign ne2665 = io_in_execute_wb != 2'h0;
  assign ne2670 = io_in_decode_src1 != 5'h0;
  assign eq2673 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2675 = eq2673 & ne2670;
  assign andl2677 = andl2675 & ne2665;
  assign eq2682 = andl2677 == 1'h0;
  assign ne2686 = io_in_memory_wb != 2'h0;
  assign eq2693 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2695 = eq2693 & ne2670;
  assign andl2697 = andl2695 & ne2686;
  assign andl2699 = andl2697 & eq2682;
  assign eq2703 = andl2699 == 1'h0;
  assign ne2711 = io_in_writeback_wb != 2'h0;
  assign eq2718 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2720 = eq2718 & ne2670;
  assign andl2722 = andl2720 & ne2711;
  assign andl2724 = andl2722 & eq2682;
  assign andl2726 = andl2724 & eq2703;
  assign orl2729 = andl2677 | andl2699;
  assign orl2731 = orl2729 | andl2726;
  assign sel2735 = eq2638 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2737 = eq2651 ? io_in_writeback_PC_next : sel2735;
  assign sel2739 = andl2726 ? sel2737 : 32'h7b;
  assign sel2741 = eq2634 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2743 = eq2647 ? io_in_memory_PC_next : sel2741;
  assign sel2745 = andl2699 ? sel2743 : sel2739;
  assign sel2747 = eq2643 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2749 = andl2677 ? sel2747 : sel2745;
  assign ne2757 = io_in_decode_src2 != 5'h0;
  assign eq2760 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2762 = eq2760 & ne2757;
  assign andl2764 = andl2762 & ne2665;
  assign eq2768 = andl2764 == 1'h0;
  assign eq2779 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2781 = eq2779 & ne2757;
  assign andl2783 = andl2781 & ne2686;
  assign andl2785 = andl2783 & eq2768;
  assign eq2789 = andl2785 == 1'h0;
  assign eq2804 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2806 = eq2804 & ne2757;
  assign andl2808 = andl2806 & ne2711;
  assign andl2810 = andl2808 & eq2768;
  assign andl2812 = andl2810 & eq2789;
  assign orl2815 = andl2764 | andl2785;
  assign orl2817 = orl2815 | andl2812;
  assign sel2824 = andl2812 ? sel2737 : 32'h7b;
  assign sel2830 = andl2785 ? sel2743 : sel2824;
  assign sel2834 = andl2764 ? sel2747 : sel2830;
  assign eq2837 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2839 = eq2837 & eq2656;
  assign eq2843 = andl2839 == 1'h0;
  assign eq2846 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2848 = eq2846 & eq2660;
  assign andl2850 = andl2848 & eq2843;
  assign orl2853 = andl2839 | andl2850;
  assign sel2856 = andl2850 ? io_in_memory_csr_result : 32'h7b;
  assign sel2858 = andl2839 ? io_in_execute_alu_result : sel2856;
  assign orl2863 = andl2677 | andl2764;
  assign andl2865 = orl2863 & eq2630;
  assign sel2867 = andl2865 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2731;
  assign io_out_src1_fwd_data = sel2749;
  assign io_out_src2_fwd = orl2817;
  assign io_out_src2_fwd_data = sel2834;
  assign io_out_csr_fwd = orl2853;
  assign io_out_csr_fwd_data = sel2858;
  assign io_out_fwd_stall = sel2867;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem2974 [0:1];
  wire[31:0] mrport2976;

  initial begin
    mem2974[0] = 32'hdeadbeef;
    mem2974[1] = 32'hdeadbeef;
  end
  assign mrport2976 = mem2974[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport2976;

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
  reg[3:0] reg3045, sel3135;
  wire eq3053, andl3138, eq3142, andl3146, eq3150, andl3154;
  wire[3:0] sel3059, sel3064, sel3070, sel3076, sel3086, sel3091, sel3095, sel3104, sel3110, sel3120, sel3125, sel3129, sel3136, sel3152, sel3153, sel3155;

  always @ (posedge clk) begin
    if (reset)
      reg3045 <= 4'h0;
    else
      reg3045 <= sel3155;
  end
  assign eq3053 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3059 = eq3053 ? 4'h0 : 4'h1;
  assign sel3064 = eq3053 ? 4'h2 : 4'h1;
  assign sel3070 = eq3053 ? 4'h9 : 4'h3;
  assign sel3076 = eq3053 ? 4'h5 : 4'h4;
  assign sel3086 = eq3053 ? 4'h8 : 4'h6;
  assign sel3091 = eq3053 ? 4'h7 : 4'h6;
  assign sel3095 = eq3053 ? 4'h4 : 4'h8;
  assign sel3104 = eq3053 ? 4'h0 : 4'ha;
  assign sel3110 = eq3053 ? 4'hc : 4'hb;
  assign sel3120 = eq3053 ? 4'hf : 4'hd;
  assign sel3125 = eq3053 ? 4'he : 4'hd;
  assign sel3129 = eq3053 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3045)
      4'h0: sel3135 = sel3059;
      4'h1: sel3135 = sel3064;
      4'h2: sel3135 = sel3070;
      4'h3: sel3135 = sel3076;
      4'h4: sel3135 = sel3076;
      4'h5: sel3135 = sel3086;
      4'h6: sel3135 = sel3091;
      4'h7: sel3135 = sel3095;
      4'h8: sel3135 = sel3064;
      4'h9: sel3135 = sel3104;
      4'ha: sel3135 = sel3110;
      4'hb: sel3135 = sel3110;
      4'hc: sel3135 = sel3120;
      4'hd: sel3135 = sel3125;
      4'he: sel3135 = sel3129;
      4'hf: sel3135 = sel3064;
      default: sel3135 = reg3045;
    endcase
  end
  assign sel3136 = io_JTAG_TAP_in_mode_select_valid ? sel3135 : 4'h0;
  assign andl3138 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3142 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3146 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3150 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3152 = eq3142 ? 4'h0 : reg3045;
  assign sel3153 = andl3154 ? sel3136 : reg3045;
  assign andl3154 = andl3146 & eq3150;
  assign sel3155 = andl3138 ? sel3152 : sel3153;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3045;

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
  wire bindin3161, bindin3163, bindin3164, bindin3167, bindout3170, bindin3173, bindin3176, bindout3179, bindin3182, bindin3185, bindout3188, eq3225, eq3234, eq3239, eq3312, andl3313, sel3316, sel3325;
  wire[3:0] bindout3191;
  reg[31:0] reg3199, reg3206, reg3213, reg3220, sel3314;
  wire[31:0] sel3242, sel3244, shr3251, proxy3256, sel3311, sel3315, sel3322, sel3323, sel3324;
  wire[30:0] proxy3254;
  reg sel3321, sel3330;

  assign bindin3161 = clk;
  assign bindin3163 = reset;
  TAP __module16__(.clk(bindin3161), .reset(bindin3163), .io_JTAG_TAP_in_mode_select_data(bindin3164), .io_JTAG_TAP_in_mode_select_valid(bindin3167), .io_JTAG_TAP_in_clock_data(bindin3173), .io_JTAG_TAP_in_clock_valid(bindin3176), .io_JTAG_TAP_in_reset_data(bindin3182), .io_JTAG_TAP_in_reset_valid(bindin3185), .io_JTAG_TAP_in_mode_select_ready(bindout3170), .io_JTAG_TAP_in_clock_ready(bindout3179), .io_JTAG_TAP_in_reset_ready(bindout3188), .io_out_curr_state(bindout3191));
  assign bindin3164 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3167 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3173 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3176 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3182 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3185 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3199 <= 32'h0;
    else
      reg3199 <= sel3315;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3206 <= 32'h1234;
    else
      reg3206 <= sel3324;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3213 <= 32'h5678;
    else
      reg3213 <= sel3311;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3220 <= 32'h0;
    else
      reg3220 <= sel3314;
  end
  assign eq3225 = reg3199 == 32'h0;
  assign eq3234 = reg3199 == 32'h1;
  assign eq3239 = reg3199 == 32'h2;
  assign sel3242 = eq3239 ? reg3206 : 32'hdeadbeef;
  assign sel3244 = eq3234 ? reg3213 : sel3242;
  assign shr3251 = reg3220 >> 32'h1;
  assign proxy3254 = shr3251[30:0];
  assign proxy3256 = {io_JTAG_in_data_data, proxy3254};
  assign sel3311 = andl3313 ? reg3220 : reg3213;
  assign eq3312 = bindout3191 == 4'h8;
  assign andl3313 = eq3312 & eq3234;
  always @(*) begin
    case (bindout3191)
      4'h3: sel3314 = sel3244;
      4'h4: sel3314 = proxy3256;
      4'ha: sel3314 = reg3199;
      4'hb: sel3314 = proxy3256;
      default: sel3314 = reg3220;
    endcase
  end
  assign sel3315 = (bindout3191 == 4'hf) ? reg3220 : reg3199;
  assign sel3316 = eq3225 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3191)
      4'h3: sel3321 = sel3316;
      4'h4: sel3321 = 1'h1;
      4'h8: sel3321 = sel3316;
      4'ha: sel3321 = sel3316;
      4'hb: sel3321 = 1'h1;
      4'hf: sel3321 = sel3316;
      default: sel3321 = sel3316;
    endcase
  end
  assign sel3322 = eq3239 ? reg3220 : reg3206;
  assign sel3323 = eq3234 ? reg3206 : sel3322;
  assign sel3324 = (bindout3191 == 4'h8) ? sel3323 : reg3206;
  assign sel3325 = eq3225 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3191)
      4'h3: sel3330 = sel3325;
      4'h4: sel3330 = reg3220[0];
      4'h8: sel3330 = sel3325;
      4'ha: sel3330 = sel3325;
      4'hb: sel3330 = reg3220[0];
      4'hf: sel3330 = sel3325;
      default: sel3330 = sel3325;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3170;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3179;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3188;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3330;
  assign io_JTAG_out_data_valid = sel3321;

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
  reg[31:0] mem3386 [0:4095];
  reg reg3394;
  wire sel3399, eq3411;
  wire[31:0] mrport3407;

  always @ (posedge clk) begin
    if (reg3394) begin
      mem3386[12'hf14] <= 32'h0;
    end
  end
  always @ (posedge clk) begin
    if (reg3394) begin
      mem3386[12'h301] <= 32'h0;
    end
  end
  assign mrport3407 = mem3386[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (eq3411) begin
      mem3386[io_in_mem_csr_address] <= io_in_mem_csr_result;
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg3394 <= 1'h1;
    else
      reg3394 <= sel3399;
  end
  assign sel3399 = reg3394 ? 1'h0 : reg3394;
  assign eq3411 = io_in_mem_is_csr == 1'h1;

  assign io_out_decode_csr_data = mrport3407;

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
  wire bindin156, bindin158, bindin162, bindout165, bindout171, bindin174, bindin177, bindin183, bindin186, bindin189, bindin195, bindin252, bindin253, bindin260, bindin263, bindin1083, bindin1084, bindin1091, bindin1103, bindin1109, bindin1115, bindout1127, bindout1160, bindout1175, bindout1178, bindin1445, bindin1446, bindin1468, bindin1486, bindin1495, bindout1507, bindout1537, bindin1834, bindin1858, bindout1870, bindout1903, bindin2053, bindin2054, bindin2088, bindout2097, bindin2318, bindout2321, bindout2327, bindin2330, bindout2336, bindin2339, bindout2345, bindin2348, bindin2480, bindin2481, bindin2896, bindin2920, bindout2944, bindout2950, bindout2956, bindout2962, bindin2981, bindin2984, bindout2987, bindout2990, bindin3334, bindin3335, bindin3336, bindin3339, bindout3342, bindin3345, bindin3348, bindout3351, bindin3354, bindin3357, bindout3360, bindin3363, bindin3366, bindout3369, bindout3372, bindout3375, bindin3378, bindin3417, bindin3418, bindin3425, eq3435;
  wire[31:0] bindin159, bindout168, bindin180, bindin192, bindin198, bindout201, bindout204, bindin254, bindin257, bindout266, bindout269, bindin1085, bindin1088, bindin1094, bindin1106, bindin1112, bindin1118, bindin1121, bindout1130, bindout1133, bindout1136, bindout1145, bindout1151, bindout1181, bindout1187, bindin1453, bindin1459, bindin1480, bindin1498, bindin1501, bindout1510, bindout1513, bindout1522, bindout1528, bindout1555, bindin1819, bindin1825, bindin1846, bindin1861, bindin1864, bindout1873, bindout1876, bindout1888, bindout1894, bindout1906, bindout1909, bindin2055, bindin2067, bindin2073, bindin2082, bindin2091, bindout2100, bindout2103, bindout2115, bindout2118, bindout2130, bindin2315, bindout2324, bindout2333, bindin2351, bindin2369, bindin2375, bindin2378, bindout2381, bindout2384, bindout2399, bindin2482, bindin2485, bindin2500, bindout2503, bindout2506, bindout2521, bindin2555, bindin2558, bindin2573, bindout2576, bindin2890, bindin2893, bindin2902, bindin2911, bindin2914, bindin2917, bindin2926, bindin2935, bindin2938, bindin2941, bindout2947, bindout2953, bindout2959, bindout2993, bindin3428, bindout3431;
  wire[4:0] bindin1097, bindout1139, bindout1142, bindout1148, bindin1447, bindin1450, bindin1456, bindout1516, bindout1519, bindout1525, bindin1813, bindin1816, bindin1822, bindout1879, bindout1885, bindout1891, bindin2058, bindin2064, bindin2070, bindout2106, bindout2112, bindout2121, bindin2360, bindin2366, bindin2372, bindout2387, bindout2393, bindout2396, bindin2488, bindin2494, bindin2497, bindout2509, bindout2515, bindout2518, bindin2561, bindin2567, bindin2570, bindout2579, bindin2875, bindin2878, bindin2884, bindin2905, bindin2929;
  wire[1:0] bindin1100, bindout1154, bindin1465, bindout1534, bindin1831, bindout1882, bindin2061, bindout2109, bindout2342, bindin2363, bindout2390, bindin2491, bindout2512, bindin2564, bindout2582, bindin2887, bindin2908, bindin2932;
  wire[11:0] bindout1124, bindout1163, bindin1471, bindin1492, bindout1504, bindout1540, bindin1837, bindin1855, bindout1867, bindin2085, bindout2094, bindin2881, bindin2899, bindin2923, bindin3419, bindin3422;
  wire[3:0] bindout1157, bindin1462, bindout1531, bindin1828;
  wire[2:0] bindout1166, bindout1169, bindout1172, bindin1474, bindin1477, bindin1483, bindout1543, bindout1546, bindout1549, bindin1840, bindin1843, bindin1849, bindout1897, bindout1900, bindin2076, bindin2079, bindout2124, bindout2127, bindin2354, bindin2357;
  wire[19:0] bindout1184, bindin1489, bindout1552, bindin1852;

  assign bindin156 = clk;
  assign bindin158 = reset;
  Fetch __module2__(.clk(bindin156), .reset(bindin158), .io_IBUS_in_data_data(bindin159), .io_IBUS_in_data_valid(bindin162), .io_IBUS_out_address_ready(bindin174), .io_in_branch_dir(bindin177), .io_in_branch_dest(bindin180), .io_in_branch_stall(bindin183), .io_in_fwd_stall(bindin186), .io_in_jal(bindin189), .io_in_jal_dest(bindin192), .io_in_interrupt(bindin195), .io_in_interrupt_pc(bindin198), .io_IBUS_in_data_ready(bindout165), .io_IBUS_out_address_data(bindout168), .io_IBUS_out_address_valid(bindout171), .io_out_instruction(bindout201), .io_out_PC_next(bindout204));
  assign bindin159 = io_IBUS_in_data_data;
  assign bindin162 = io_IBUS_in_data_valid;
  assign bindin174 = io_IBUS_out_address_ready;
  assign bindin177 = bindout1903;
  assign bindin180 = bindout1906;
  assign bindin183 = bindout1175;
  assign bindin186 = bindout2962;
  assign bindin189 = bindout1178;
  assign bindin192 = bindout1181;
  assign bindin195 = bindout2990;
  assign bindin198 = bindout2993;
  assign bindin252 = clk;
  assign bindin253 = reset;
  F_D_Register __module3__(.clk(bindin252), .reset(bindin253), .io_in_instruction(bindin254), .io_in_PC_next(bindin257), .io_in_branch_stall(bindin260), .io_in_fwd_stall(bindin263), .io_out_instruction(bindout266), .io_out_PC_next(bindout269));
  assign bindin254 = bindout201;
  assign bindin257 = bindout204;
  assign bindin260 = bindout1175;
  assign bindin263 = bindout2962;
  assign bindin1083 = clk;
  assign bindin1084 = reset;
  Decode __module4__(.clk(bindin1083), .reset(bindin1084), .io_in_instruction(bindin1085), .io_in_PC_next(bindin1088), .io_in_stall(bindin1091), .io_in_write_data(bindin1094), .io_in_rd(bindin1097), .io_in_wb(bindin1100), .io_in_src1_fwd(bindin1103), .io_in_src1_fwd_data(bindin1106), .io_in_src2_fwd(bindin1109), .io_in_src2_fwd_data(bindin1112), .io_in_csr_fwd(bindin1115), .io_in_csr_fwd_data(bindin1118), .io_in_csr_data(bindin1121), .io_out_csr_address(bindout1124), .io_out_is_csr(bindout1127), .io_out_csr_data(bindout1130), .io_out_csr_mask(bindout1133), .io_actual_change(bindout1136), .io_out_rd(bindout1139), .io_out_rs1(bindout1142), .io_out_rd1(bindout1145), .io_out_rs2(bindout1148), .io_out_rd2(bindout1151), .io_out_wb(bindout1154), .io_out_alu_op(bindout1157), .io_out_rs2_src(bindout1160), .io_out_itype_immed(bindout1163), .io_out_mem_read(bindout1166), .io_out_mem_write(bindout1169), .io_out_branch_type(bindout1172), .io_out_branch_stall(bindout1175), .io_out_jal(bindout1178), .io_out_jal_dest(bindout1181), .io_out_upper_immed(bindout1184), .io_out_PC_next(bindout1187));
  assign bindin1085 = bindout266;
  assign bindin1088 = bindout269;
  assign bindin1091 = eq3435;
  assign bindin1094 = bindout2576;
  assign bindin1097 = bindout2579;
  assign bindin1100 = bindout2582;
  assign bindin1103 = bindout2944;
  assign bindin1106 = bindout2947;
  assign bindin1109 = bindout2950;
  assign bindin1112 = bindout2953;
  assign bindin1115 = bindout2956;
  assign bindin1118 = bindout2959;
  assign bindin1121 = bindout3431;
  assign bindin1445 = clk;
  assign bindin1446 = reset;
  D_E_Register __module6__(.clk(bindin1445), .reset(bindin1446), .io_in_rd(bindin1447), .io_in_rs1(bindin1450), .io_in_rd1(bindin1453), .io_in_rs2(bindin1456), .io_in_rd2(bindin1459), .io_in_alu_op(bindin1462), .io_in_wb(bindin1465), .io_in_rs2_src(bindin1468), .io_in_itype_immed(bindin1471), .io_in_mem_read(bindin1474), .io_in_mem_write(bindin1477), .io_in_PC_next(bindin1480), .io_in_branch_type(bindin1483), .io_in_fwd_stall(bindin1486), .io_in_upper_immed(bindin1489), .io_in_csr_address(bindin1492), .io_in_is_csr(bindin1495), .io_in_csr_data(bindin1498), .io_in_csr_mask(bindin1501), .io_out_csr_address(bindout1504), .io_out_is_csr(bindout1507), .io_out_csr_data(bindout1510), .io_out_csr_mask(bindout1513), .io_out_rd(bindout1516), .io_out_rs1(bindout1519), .io_out_rd1(bindout1522), .io_out_rs2(bindout1525), .io_out_rd2(bindout1528), .io_out_alu_op(bindout1531), .io_out_wb(bindout1534), .io_out_rs2_src(bindout1537), .io_out_itype_immed(bindout1540), .io_out_mem_read(bindout1543), .io_out_mem_write(bindout1546), .io_out_branch_type(bindout1549), .io_out_upper_immed(bindout1552), .io_out_PC_next(bindout1555));
  assign bindin1447 = bindout1139;
  assign bindin1450 = bindout1142;
  assign bindin1453 = bindout1145;
  assign bindin1456 = bindout1148;
  assign bindin1459 = bindout1151;
  assign bindin1462 = bindout1157;
  assign bindin1465 = bindout1154;
  assign bindin1468 = bindout1160;
  assign bindin1471 = bindout1163;
  assign bindin1474 = bindout1166;
  assign bindin1477 = bindout1169;
  assign bindin1480 = bindout1187;
  assign bindin1483 = bindout1172;
  assign bindin1486 = bindout2962;
  assign bindin1489 = bindout1184;
  assign bindin1492 = bindout1124;
  assign bindin1495 = bindout1127;
  assign bindin1498 = bindout1130;
  assign bindin1501 = bindout1133;
  Execute __module7__(.io_in_rd(bindin1813), .io_in_rs1(bindin1816), .io_in_rd1(bindin1819), .io_in_rs2(bindin1822), .io_in_rd2(bindin1825), .io_in_alu_op(bindin1828), .io_in_wb(bindin1831), .io_in_rs2_src(bindin1834), .io_in_itype_immed(bindin1837), .io_in_mem_read(bindin1840), .io_in_mem_write(bindin1843), .io_in_PC_next(bindin1846), .io_in_branch_type(bindin1849), .io_in_upper_immed(bindin1852), .io_in_csr_address(bindin1855), .io_in_is_csr(bindin1858), .io_in_csr_data(bindin1861), .io_in_csr_mask(bindin1864), .io_out_csr_address(bindout1867), .io_out_is_csr(bindout1870), .io_out_csr_result(bindout1873), .io_out_alu_result(bindout1876), .io_out_rd(bindout1879), .io_out_wb(bindout1882), .io_out_rs1(bindout1885), .io_out_rd1(bindout1888), .io_out_rs2(bindout1891), .io_out_rd2(bindout1894), .io_out_mem_read(bindout1897), .io_out_mem_write(bindout1900), .io_out_branch_dir(bindout1903), .io_out_branch_dest(bindout1906), .io_out_PC_next(bindout1909));
  assign bindin1813 = bindout1516;
  assign bindin1816 = bindout1519;
  assign bindin1819 = bindout1522;
  assign bindin1822 = bindout1525;
  assign bindin1825 = bindout1528;
  assign bindin1828 = bindout1531;
  assign bindin1831 = bindout1534;
  assign bindin1834 = bindout1537;
  assign bindin1837 = bindout1540;
  assign bindin1840 = bindout1543;
  assign bindin1843 = bindout1546;
  assign bindin1846 = bindout1555;
  assign bindin1849 = bindout1549;
  assign bindin1852 = bindout1552;
  assign bindin1855 = bindout1504;
  assign bindin1858 = bindout1507;
  assign bindin1861 = bindout1510;
  assign bindin1864 = bindout1513;
  assign bindin2053 = clk;
  assign bindin2054 = reset;
  E_M_Register __module8__(.clk(bindin2053), .reset(bindin2054), .io_in_alu_result(bindin2055), .io_in_rd(bindin2058), .io_in_wb(bindin2061), .io_in_rs1(bindin2064), .io_in_rd1(bindin2067), .io_in_rs2(bindin2070), .io_in_rd2(bindin2073), .io_in_mem_read(bindin2076), .io_in_mem_write(bindin2079), .io_in_PC_next(bindin2082), .io_in_csr_address(bindin2085), .io_in_is_csr(bindin2088), .io_in_csr_result(bindin2091), .io_out_csr_address(bindout2094), .io_out_is_csr(bindout2097), .io_out_csr_result(bindout2100), .io_out_alu_result(bindout2103), .io_out_rd(bindout2106), .io_out_wb(bindout2109), .io_out_rs1(bindout2112), .io_out_rd1(bindout2115), .io_out_rd2(bindout2118), .io_out_rs2(bindout2121), .io_out_mem_read(bindout2124), .io_out_mem_write(bindout2127), .io_out_PC_next(bindout2130));
  assign bindin2055 = bindout1876;
  assign bindin2058 = bindout1879;
  assign bindin2061 = bindout1882;
  assign bindin2064 = bindout1885;
  assign bindin2067 = bindout1888;
  assign bindin2070 = bindout1891;
  assign bindin2073 = bindout1894;
  assign bindin2076 = bindout1897;
  assign bindin2079 = bindout1900;
  assign bindin2082 = bindout1909;
  assign bindin2085 = bindout1867;
  assign bindin2088 = bindout1870;
  assign bindin2091 = bindout1873;
  Memory __module9__(.io_DBUS_in_data_data(bindin2315), .io_DBUS_in_data_valid(bindin2318), .io_DBUS_out_data_ready(bindin2330), .io_DBUS_out_address_ready(bindin2339), .io_DBUS_out_control_ready(bindin2348), .io_in_alu_result(bindin2351), .io_in_mem_read(bindin2354), .io_in_mem_write(bindin2357), .io_in_rd(bindin2360), .io_in_wb(bindin2363), .io_in_rs1(bindin2366), .io_in_rd1(bindin2369), .io_in_rs2(bindin2372), .io_in_rd2(bindin2375), .io_in_PC_next(bindin2378), .io_DBUS_in_data_ready(bindout2321), .io_DBUS_out_data_data(bindout2324), .io_DBUS_out_data_valid(bindout2327), .io_DBUS_out_address_data(bindout2333), .io_DBUS_out_address_valid(bindout2336), .io_DBUS_out_control_data(bindout2342), .io_DBUS_out_control_valid(bindout2345), .io_out_alu_result(bindout2381), .io_out_mem_result(bindout2384), .io_out_rd(bindout2387), .io_out_wb(bindout2390), .io_out_rs1(bindout2393), .io_out_rs2(bindout2396), .io_out_PC_next(bindout2399));
  assign bindin2315 = io_DBUS_in_data_data;
  assign bindin2318 = io_DBUS_in_data_valid;
  assign bindin2330 = io_DBUS_out_data_ready;
  assign bindin2339 = io_DBUS_out_address_ready;
  assign bindin2348 = io_DBUS_out_control_ready;
  assign bindin2351 = bindout2103;
  assign bindin2354 = bindout2124;
  assign bindin2357 = bindout2127;
  assign bindin2360 = bindout2106;
  assign bindin2363 = bindout2109;
  assign bindin2366 = bindout2112;
  assign bindin2369 = bindout2115;
  assign bindin2372 = bindout2121;
  assign bindin2375 = bindout2118;
  assign bindin2378 = bindout2130;
  assign bindin2480 = clk;
  assign bindin2481 = reset;
  M_W_Register __module11__(.clk(bindin2480), .reset(bindin2481), .io_in_alu_result(bindin2482), .io_in_mem_result(bindin2485), .io_in_rd(bindin2488), .io_in_wb(bindin2491), .io_in_rs1(bindin2494), .io_in_rs2(bindin2497), .io_in_PC_next(bindin2500), .io_out_alu_result(bindout2503), .io_out_mem_result(bindout2506), .io_out_rd(bindout2509), .io_out_wb(bindout2512), .io_out_rs1(bindout2515), .io_out_rs2(bindout2518), .io_out_PC_next(bindout2521));
  assign bindin2482 = bindout2381;
  assign bindin2485 = bindout2384;
  assign bindin2488 = bindout2387;
  assign bindin2491 = bindout2390;
  assign bindin2494 = bindout2393;
  assign bindin2497 = bindout2396;
  assign bindin2500 = bindout2399;
  Write_Back __module12__(.io_in_alu_result(bindin2555), .io_in_mem_result(bindin2558), .io_in_rd(bindin2561), .io_in_wb(bindin2564), .io_in_rs1(bindin2567), .io_in_rs2(bindin2570), .io_in_PC_next(bindin2573), .io_out_write_data(bindout2576), .io_out_rd(bindout2579), .io_out_wb(bindout2582));
  assign bindin2555 = bindout2503;
  assign bindin2558 = bindout2506;
  assign bindin2561 = bindout2509;
  assign bindin2564 = bindout2512;
  assign bindin2567 = bindout2515;
  assign bindin2570 = bindout2518;
  assign bindin2573 = bindout2521;
  Forwarding __module13__(.io_in_decode_src1(bindin2875), .io_in_decode_src2(bindin2878), .io_in_decode_csr_address(bindin2881), .io_in_execute_dest(bindin2884), .io_in_execute_wb(bindin2887), .io_in_execute_alu_result(bindin2890), .io_in_execute_PC_next(bindin2893), .io_in_execute_is_csr(bindin2896), .io_in_execute_csr_address(bindin2899), .io_in_execute_csr_result(bindin2902), .io_in_memory_dest(bindin2905), .io_in_memory_wb(bindin2908), .io_in_memory_alu_result(bindin2911), .io_in_memory_mem_data(bindin2914), .io_in_memory_PC_next(bindin2917), .io_in_memory_is_csr(bindin2920), .io_in_memory_csr_address(bindin2923), .io_in_memory_csr_result(bindin2926), .io_in_writeback_dest(bindin2929), .io_in_writeback_wb(bindin2932), .io_in_writeback_alu_result(bindin2935), .io_in_writeback_mem_data(bindin2938), .io_in_writeback_PC_next(bindin2941), .io_out_src1_fwd(bindout2944), .io_out_src1_fwd_data(bindout2947), .io_out_src2_fwd(bindout2950), .io_out_src2_fwd_data(bindout2953), .io_out_csr_fwd(bindout2956), .io_out_csr_fwd_data(bindout2959), .io_out_fwd_stall(bindout2962));
  assign bindin2875 = bindout1142;
  assign bindin2878 = bindout1148;
  assign bindin2881 = bindout1124;
  assign bindin2884 = bindout1879;
  assign bindin2887 = bindout1882;
  assign bindin2890 = bindout1876;
  assign bindin2893 = bindout1909;
  assign bindin2896 = bindout1870;
  assign bindin2899 = bindout1867;
  assign bindin2902 = bindout1873;
  assign bindin2905 = bindout2387;
  assign bindin2908 = bindout2390;
  assign bindin2911 = bindout2381;
  assign bindin2914 = bindout2384;
  assign bindin2917 = bindout2399;
  assign bindin2920 = bindout2097;
  assign bindin2923 = bindout2094;
  assign bindin2926 = bindout2100;
  assign bindin2929 = bindout2509;
  assign bindin2932 = bindout2512;
  assign bindin2935 = bindout2503;
  assign bindin2938 = bindout2506;
  assign bindin2941 = bindout2521;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin2981), .io_INTERRUPT_in_interrupt_id_valid(bindin2984), .io_INTERRUPT_in_interrupt_id_ready(bindout2987), .io_out_interrupt(bindout2990), .io_out_interrupt_pc(bindout2993));
  assign bindin2981 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin2984 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3334 = clk;
  assign bindin3335 = reset;
  JTAG __module15__(.clk(bindin3334), .reset(bindin3335), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3336), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3339), .io_JTAG_JTAG_TAP_in_clock_data(bindin3345), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3348), .io_JTAG_JTAG_TAP_in_reset_data(bindin3354), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3357), .io_JTAG_in_data_data(bindin3363), .io_JTAG_in_data_valid(bindin3366), .io_JTAG_out_data_ready(bindin3378), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3342), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3351), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3360), .io_JTAG_in_data_ready(bindout3369), .io_JTAG_out_data_data(bindout3372), .io_JTAG_out_data_valid(bindout3375));
  assign bindin3336 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3339 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3345 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3348 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3354 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3357 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3363 = io_jtag_in_data_data;
  assign bindin3366 = io_jtag_in_data_valid;
  assign bindin3378 = io_jtag_out_data_ready;
  assign bindin3417 = clk;
  assign bindin3418 = reset;
  CSR_Handler __module17__(.clk(bindin3417), .reset(bindin3418), .io_in_decode_csr_address(bindin3419), .io_in_mem_csr_address(bindin3422), .io_in_mem_is_csr(bindin3425), .io_in_mem_csr_result(bindin3428), .io_out_decode_csr_data(bindout3431));
  assign bindin3419 = bindout1124;
  assign bindin3422 = bindout2094;
  assign bindin3425 = bindout2097;
  assign bindin3428 = bindout2100;
  assign eq3435 = bindout2962 == 1'h1;

  assign io_IBUS_in_data_ready = bindout165;
  assign io_IBUS_out_address_data = bindout168;
  assign io_IBUS_out_address_valid = bindout171;
  assign io_DBUS_in_data_ready = bindout2321;
  assign io_DBUS_out_data_data = bindout2324;
  assign io_DBUS_out_data_valid = bindout2327;
  assign io_DBUS_out_address_data = bindout2333;
  assign io_DBUS_out_address_valid = bindout2336;
  assign io_DBUS_out_control_data = bindout2342;
  assign io_DBUS_out_control_valid = bindout2345;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout2987;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3342;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3351;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3360;
  assign io_jtag_in_data_ready = bindout3369;
  assign io_jtag_out_data_data = bindout3372;
  assign io_jtag_out_data_valid = bindout3375;
  assign io_out_fwd_stall = bindout2962;
  assign io_out_branch_stall = bindout1175;
  assign io_actual_change = bindout1136;

endmodule
