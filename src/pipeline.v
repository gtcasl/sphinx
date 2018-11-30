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
  input wire io_in_debug,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC
);
  reg reg112;
  reg[31:0] reg122, reg135, reg141, reg147, sel163;
  reg[3:0] reg129;
  wire[31:0] sel164, sel166, sel183, sel189, sel195, add219, add222, add225;
  wire eq170, eq174, orl176, orl178, orl180, eq187, eq193;
  wire[3:0] sel204, sel211, sel214;

  always @ (posedge clk) begin
    if (reset)
      reg112 <= 1'h0;
    else
      reg112 <= orl180;
  end
  always @ (posedge clk) begin
    if (reset)
      reg122 <= 32'h0;
    else
      reg122 <= sel195;
  end
  always @ (posedge clk) begin
    if (reset)
      reg129 <= 4'h0;
    else
      reg129 <= sel214;
  end
  always @ (posedge clk) begin
    if (reset)
      reg135 <= 32'h0;
    else
      reg135 <= add219;
  end
  always @ (posedge clk) begin
    if (reset)
      reg141 <= 32'h0;
    else
      reg141 <= add222;
  end
  always @ (posedge clk) begin
    if (reset)
      reg147 <= 32'h0;
    else
      reg147 <= add225;
  end
  always @(*) begin
    case (reg129)
      4'h0: sel163 = reg135;
      4'h1: sel163 = reg141;
      4'h2: sel163 = reg147;
      4'h3: sel163 = reg122;
      default: sel163 = 32'h0;
    endcase
  end
  assign sel164 = io_in_debug ? reg135 : sel163;
  assign sel166 = reg112 ? reg122 : sel164;
  assign eq170 = io_in_fwd_stall == 1'h1;
  assign eq174 = io_in_branch_stall == 1'h1;
  assign orl176 = eq174 | eq170;
  assign orl178 = orl176 | io_in_branch_stall_exe;
  assign orl180 = orl178 | io_in_interrupt;
  assign sel183 = orl180 ? 32'h0 : io_IBUS_in_data_data;
  assign eq187 = io_in_branch_dir == 1'h1;
  assign sel189 = eq187 ? io_in_branch_dest : sel166;
  assign eq193 = io_in_jal == 1'h1;
  assign sel195 = eq193 ? io_in_jal_dest : sel189;
  assign sel204 = eq187 ? 4'h2 : 4'h0;
  assign sel211 = eq193 ? 4'h1 : sel204;
  assign sel214 = io_in_interrupt ? 4'h3 : sel211;
  assign add219 = sel166 + 32'h4;
  assign add222 = io_in_jal_dest + 32'h4;
  assign add225 = io_in_branch_dest + 32'h4;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_valid;
  assign io_IBUS_out_address_data = sel195;
  assign io_IBUS_out_address_valid = 1'h1;
  assign io_out_instruction = sel183;
  assign io_out_curr_PC = sel195;

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
  reg[31:0] reg307, reg316;
  wire eq337;
  wire[31:0] sel339, sel340;

  always @ (posedge clk) begin
    if (reset)
      reg307 <= 32'h0;
    else
      reg307 <= sel340;
  end
  always @ (posedge clk) begin
    if (reset)
      reg316 <= 32'h0;
    else
      reg316 <= sel339;
  end
  assign eq337 = io_in_fwd_stall == 1'h0;
  assign sel339 = eq337 ? io_in_curr_PC : reg316;
  assign sel340 = eq337 ? io_in_instruction : reg307;

  assign io_out_instruction = reg307;
  assign io_out_curr_PC = reg316;

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
  reg[31:0] mem442 [0:31];
  wire ne454, andl457, eq467, eq476;
  wire[31:0] mrport461, sel469, mrport471, sel478;

  always @ (posedge clk) begin
    if (andl457) begin
      mem442[io_in_rd] <= io_in_data;
    end
  end
  assign mrport461 = mem442[io_in_src1];
  assign mrport471 = mem442[io_in_src2];
  assign ne454 = io_in_rd != 5'h0;
  assign andl457 = io_in_write_register & ne454;
  assign eq467 = io_in_src1 == 5'h0;
  assign sel469 = eq467 ? 32'h0 : mrport461;
  assign eq476 = io_in_src2 == 5'h0;
  assign sel478 = eq476 ? 32'h0 : mrport471;

  assign io_out_src1_data = sel469;
  assign io_out_src2_data = sel478;

endmodule

module Decode(
  input wire clk,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_stall,
  input wire[31:0] io_in_write_data,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
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
  wire bindin485, bindin486, ne546, sel548, eq600, eq605, eq610, orl612, eq617, eq622, eq627, eq632, eq637, eq642, ne647, eq652, andl654, proxy657, eq658, andl661, eq665, andl671, orl683, orl685, orl687, orl689, orl700, orl702, orl709, sel711, proxy737, proxy745, eq763, proxy780, eq781, eq787, lt791, andl794, sel806, ne809, ge812, eq815, andl820, andl822, eq831, eq836, orl838, eq853, proxy883, eq884, proxy889, eq918, eq956, eq993, eq1001, eq1009, orl1015, lt1033;
  wire[4:0] bindin489, bindin495, bindin498, proxy558, proxy565, proxy572;
  wire[31:0] bindin492, bindout501, bindout504, shr555, shr562, shr569, shr576, shr583, add595, sel673, pad675, sel677, shr741, pad754, proxy759, sel765, pad771, proxy776, sel783, sel804, pad844, proxy848, sel855, pad875, proxy879, sel886, shr893, sel920;
  wire[2:0] proxy579, sel715, sel718;
  wire[6:0] proxy586;
  wire[11:0] proxy592, proxy769, sel824, pad840, sel842, proxy858, proxy904;
  wire[1:0] sel691, sel695, sel704, proxy988;
  wire[19:0] proxy721;
  reg[19:0] sel730;
  wire[7:0] proxy736;
  wire[9:0] proxy744;
  wire[20:0] proxy748;
  reg[31:0] sel805, sel924;
  reg sel807, sel946;
  wire[3:0] proxy896, sel958, sel961, sel978, sel995, sel1003, sel1011, sel1017, sel1019, sel1023, sel1027, sel1035, sel1037;
  wire[5:0] proxy902;
  reg[11:0] sel925;
  reg[2:0] sel944, sel945;
  reg[3:0] sel986;

  assign bindin485 = clk;
  RegisterFile __module5__(.clk(bindin485), .io_in_write_register(bindin486), .io_in_rd(bindin489), .io_in_data(bindin492), .io_in_src1(bindin495), .io_in_src2(bindin498), .io_out_src1_data(bindout501), .io_out_src2_data(bindout504));
  assign bindin486 = sel548;
  assign bindin489 = io_in_rd;
  assign bindin492 = io_in_write_data;
  assign bindin495 = proxy565;
  assign bindin498 = proxy572;
  assign ne546 = io_in_wb != 2'h0;
  assign sel548 = ne546 ? 1'h1 : 1'h0;
  assign shr555 = io_in_instruction >> 32'h7;
  assign proxy558 = shr555[4:0];
  assign shr562 = io_in_instruction >> 32'hf;
  assign proxy565 = shr562[4:0];
  assign shr569 = io_in_instruction >> 32'h14;
  assign proxy572 = shr569[4:0];
  assign shr576 = io_in_instruction >> 32'hc;
  assign proxy579 = shr576[2:0];
  assign shr583 = io_in_instruction >> 32'h19;
  assign proxy586 = shr583[6:0];
  assign proxy592 = shr569[11:0];
  assign add595 = io_in_curr_PC + 32'h4;
  assign eq600 = io_in_instruction[6:0] == 7'h33;
  assign eq605 = io_in_instruction[6:0] == 7'h3;
  assign eq610 = io_in_instruction[6:0] == 7'h13;
  assign orl612 = eq610 | eq605;
  assign eq617 = io_in_instruction[6:0] == 7'h23;
  assign eq622 = io_in_instruction[6:0] == 7'h63;
  assign eq627 = io_in_instruction[6:0] == 7'h6f;
  assign eq632 = io_in_instruction[6:0] == 7'h67;
  assign eq637 = io_in_instruction[6:0] == 7'h37;
  assign eq642 = io_in_instruction[6:0] == 7'h17;
  assign ne647 = proxy579 != 3'h0;
  assign eq652 = io_in_instruction[6:0] == 7'h73;
  assign andl654 = eq652 & ne647;
  assign proxy657 = proxy579[2];
  assign eq658 = proxy657 == 1'h1;
  assign andl661 = andl654 & eq658;
  assign eq665 = proxy579 == 3'h0;
  assign andl671 = eq652 & eq665;
  assign sel673 = eq627 ? io_in_curr_PC : bindout501;
  assign pad675 = {{27{1'b0}}, proxy565};
  assign sel677 = andl661 ? pad675 : sel673;
  assign orl683 = orl612 | eq600;
  assign orl685 = orl683 | eq637;
  assign orl687 = orl685 | eq642;
  assign orl689 = orl687 | andl654;
  assign sel691 = orl689 ? 2'h1 : 2'h0;
  assign sel695 = eq605 ? 2'h2 : sel691;
  assign orl700 = eq627 | eq632;
  assign orl702 = orl700 | andl671;
  assign sel704 = orl702 ? 2'h3 : sel695;
  assign orl709 = orl612 | eq617;
  assign sel711 = orl709 ? 1'h1 : 1'h0;
  assign sel715 = eq605 ? proxy579 : 3'h7;
  assign sel718 = eq617 ? proxy579 : 3'h7;
  assign proxy721 = {proxy586, proxy572, proxy565, proxy579};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h37: sel730 = proxy721;
      7'h17: sel730 = proxy721;
      default: sel730 = 20'h7b;
    endcase
  end
  assign proxy736 = shr576[7:0];
  assign proxy737 = io_in_instruction[20];
  assign shr741 = io_in_instruction >> 32'h15;
  assign proxy744 = shr741[9:0];
  assign proxy745 = io_in_instruction[31];
  assign proxy748 = {proxy745, proxy736, proxy737, proxy744, 1'h0};
  assign pad754 = {{11{1'b0}}, proxy748};
  assign proxy759 = {11'h7ff, proxy748};
  assign eq763 = proxy745 == 1'h1;
  assign sel765 = eq763 ? proxy759 : pad754;
  assign proxy769 = {proxy586, proxy572};
  assign pad771 = {{20{1'b0}}, proxy769};
  assign proxy776 = {20'hfffff, proxy769};
  assign proxy780 = proxy769[11];
  assign eq781 = proxy780 == 1'h1;
  assign sel783 = eq781 ? proxy776 : pad771;
  assign eq787 = proxy579 == 3'h0;
  assign lt791 = proxy592 < 12'h2;
  assign andl794 = eq787 & lt791;
  assign sel804 = andl794 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel805 = sel765;
      7'h67: sel805 = sel783;
      7'h73: sel805 = sel804;
      default: sel805 = 32'h7b;
    endcase
  end
  assign sel806 = andl794 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel807 = 1'h1;
      7'h67: sel807 = 1'h1;
      7'h73: sel807 = sel806;
      default: sel807 = 1'h0;
    endcase
  end
  assign ne809 = proxy579 != 3'h0;
  assign ge812 = proxy592 >= 12'h2;
  assign eq815 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign andl820 = ne809 & ge812;
  assign andl822 = andl820 & eq815;
  assign sel824 = andl822 ? proxy592 : 12'h7b;
  assign eq831 = proxy579 == 3'h5;
  assign eq836 = proxy579 == 3'h1;
  assign orl838 = eq836 | eq831;
  assign pad840 = {{7{1'b0}}, proxy572};
  assign sel842 = orl838 ? pad840 : proxy592;
  assign pad844 = {{20{1'b0}}, sel925};
  assign proxy848 = {20'hfffff, sel925};
  assign eq853 = sel925[11] == 1'h1;
  assign sel855 = eq853 ? proxy848 : pad844;
  assign proxy858 = {proxy586, proxy558};
  assign pad875 = {{20{1'b0}}, proxy592};
  assign proxy879 = {20'hfffff, proxy592};
  assign proxy883 = proxy592[11];
  assign eq884 = proxy883 == 1'h1;
  assign sel886 = eq884 ? proxy879 : pad875;
  assign proxy889 = io_in_instruction[7];
  assign shr893 = io_in_instruction >> 32'h8;
  assign proxy896 = shr893[3:0];
  assign proxy902 = shr583[5:0];
  assign proxy904 = {proxy745, proxy889, proxy902, proxy896};
  assign eq918 = proxy745 == 1'h1;
  assign sel920 = eq918 ? proxy848 : pad844;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel924 = sel855;
      7'h23: sel924 = sel855;
      7'h03: sel924 = sel886;
      7'h63: sel924 = sel920;
      default: sel924 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel925 = sel842;
      7'h23: sel925 = proxy858;
      7'h03: sel925 = 12'h0;
      7'h63: sel925 = proxy904;
      default: sel925 = 12'h0;
    endcase
  end
  always @(*) begin
    case (proxy579)
      3'h0: sel944 = 3'h1;
      3'h1: sel944 = 3'h2;
      3'h4: sel944 = 3'h3;
      3'h5: sel944 = 3'h4;
      3'h6: sel944 = 3'h5;
      3'h7: sel944 = 3'h6;
      default: sel944 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel945 = sel944;
      7'h6f: sel945 = 3'h0;
      7'h67: sel945 = 3'h0;
      default: sel945 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel946 = 1'h1;
      7'h6f: sel946 = 1'h1;
      7'h67: sel946 = 1'h1;
      default: sel946 = 1'h0;
    endcase
  end
  assign eq956 = proxy586 == 7'h0;
  assign sel958 = eq956 ? 4'h0 : 4'h1;
  assign sel961 = eq610 ? 4'h0 : sel958;
  assign sel978 = eq956 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy579)
      3'h0: sel986 = sel961;
      3'h1: sel986 = 4'h2;
      3'h2: sel986 = 4'h3;
      3'h3: sel986 = 4'h4;
      3'h4: sel986 = 4'h5;
      3'h5: sel986 = sel978;
      3'h6: sel986 = 4'h8;
      3'h7: sel986 = 4'h9;
      default: sel986 = 4'hf;
    endcase
  end
  assign proxy988 = proxy579[1:0];
  assign eq993 = proxy988 == 2'h3;
  assign sel995 = eq993 ? 4'hf : 4'hf;
  assign eq1001 = proxy988 == 2'h2;
  assign sel1003 = eq1001 ? 4'he : sel995;
  assign eq1009 = proxy988 == 2'h1;
  assign sel1011 = eq1009 ? 4'hd : sel1003;
  assign orl1015 = eq617 | eq605;
  assign sel1017 = orl1015 ? 4'h0 : sel986;
  assign sel1019 = andl654 ? sel1011 : sel1017;
  assign sel1023 = eq642 ? 4'hc : sel1019;
  assign sel1027 = eq637 ? 4'hb : sel1023;
  assign lt1033 = sel945 < 3'h5;
  assign sel1035 = lt1033 ? 4'h1 : 4'ha;
  assign sel1037 = eq622 ? sel1035 : sel1027;

  assign io_out_csr_address = sel824;
  assign io_out_is_csr = andl654;
  assign io_out_csr_mask = sel677;
  assign io_out_rd = proxy558;
  assign io_out_rs1 = proxy565;
  assign io_out_rd1 = sel673;
  assign io_out_rs2 = proxy572;
  assign io_out_rd2 = bindout504;
  assign io_out_wb = sel704;
  assign io_out_alu_op = sel1037;
  assign io_out_rs2_src = sel711;
  assign io_out_itype_immed = sel924;
  assign io_out_mem_read = sel715;
  assign io_out_mem_write = sel718;
  assign io_out_branch_type = sel945;
  assign io_out_branch_stall = sel946;
  assign io_out_jal = sel807;
  assign io_out_jal_offset = sel805;
  assign io_out_upper_immed = sel730;
  assign io_out_PC_next = add595;

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
  reg[4:0] reg1207, reg1216, reg1229;
  reg[31:0] reg1223, reg1235, reg1255, reg1268, reg1314, reg1320, reg1332;
  reg[3:0] reg1242;
  reg[1:0] reg1249;
  reg reg1262, reg1308, reg1326;
  reg[2:0] reg1275, reg1281, reg1288;
  reg[19:0] reg1295;
  reg[11:0] reg1302;
  wire eq1336, eq1340, orl1342, sel1370, sel1392, sel1398;
  wire[4:0] sel1345, sel1348, sel1354;
  wire[31:0] sel1351, sel1357, sel1367, sel1374, sel1395, sel1401, sel1404;
  wire[3:0] sel1361;
  wire[1:0] sel1364;
  wire[2:0] sel1377, sel1380, sel1383;
  wire[19:0] sel1386;
  wire[11:0] sel1389;

  always @ (posedge clk) begin
    if (reset)
      reg1207 <= 5'h0;
    else
      reg1207 <= sel1345;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1216 <= 5'h0;
    else
      reg1216 <= sel1348;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1223 <= 32'h0;
    else
      reg1223 <= sel1351;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1229 <= 5'h0;
    else
      reg1229 <= sel1354;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1235 <= 32'h0;
    else
      reg1235 <= sel1357;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1242 <= 4'h0;
    else
      reg1242 <= sel1361;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1249 <= 2'h0;
    else
      reg1249 <= sel1364;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1255 <= 32'h0;
    else
      reg1255 <= sel1367;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1262 <= 1'h0;
    else
      reg1262 <= sel1370;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1268 <= 32'h0;
    else
      reg1268 <= sel1374;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1275 <= 3'h7;
    else
      reg1275 <= sel1377;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1281 <= 3'h7;
    else
      reg1281 <= sel1380;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1288 <= 3'h0;
    else
      reg1288 <= sel1383;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1295 <= 20'h0;
    else
      reg1295 <= sel1386;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1302 <= 12'h0;
    else
      reg1302 <= sel1389;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1308 <= 1'h0;
    else
      reg1308 <= sel1392;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1314 <= 32'h0;
    else
      reg1314 <= sel1395;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1320 <= 32'h0;
    else
      reg1320 <= sel1404;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1326 <= 1'h0;
    else
      reg1326 <= sel1398;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1332 <= 32'h0;
    else
      reg1332 <= sel1401;
  end
  assign eq1336 = io_in_branch_stall == 1'h1;
  assign eq1340 = io_in_fwd_stall == 1'h1;
  assign orl1342 = eq1340 | eq1336;
  assign sel1345 = orl1342 ? 5'h0 : io_in_rd;
  assign sel1348 = orl1342 ? 5'h0 : io_in_rs1;
  assign sel1351 = orl1342 ? 32'h0 : io_in_rd1;
  assign sel1354 = orl1342 ? 5'h0 : io_in_rs2;
  assign sel1357 = orl1342 ? 32'h0 : io_in_rd2;
  assign sel1361 = orl1342 ? 4'hf : io_in_alu_op;
  assign sel1364 = orl1342 ? 2'h0 : io_in_wb;
  assign sel1367 = orl1342 ? 32'h0 : io_in_PC_next;
  assign sel1370 = orl1342 ? 1'h0 : io_in_rs2_src;
  assign sel1374 = orl1342 ? 32'h7b : io_in_itype_immed;
  assign sel1377 = orl1342 ? 3'h7 : io_in_mem_read;
  assign sel1380 = orl1342 ? 3'h7 : io_in_mem_write;
  assign sel1383 = orl1342 ? 3'h0 : io_in_branch_type;
  assign sel1386 = orl1342 ? 20'h0 : io_in_upper_immed;
  assign sel1389 = orl1342 ? 12'h0 : io_in_csr_address;
  assign sel1392 = orl1342 ? 1'h0 : io_in_is_csr;
  assign sel1395 = orl1342 ? 32'h0 : io_in_csr_mask;
  assign sel1398 = orl1342 ? 1'h0 : io_in_jal;
  assign sel1401 = orl1342 ? 32'h0 : io_in_jal_offset;
  assign sel1404 = orl1342 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1302;
  assign io_out_is_csr = reg1308;
  assign io_out_csr_mask = reg1314;
  assign io_out_rd = reg1207;
  assign io_out_rs1 = reg1216;
  assign io_out_rd1 = reg1223;
  assign io_out_rs2 = reg1229;
  assign io_out_rd2 = reg1235;
  assign io_out_alu_op = reg1242;
  assign io_out_wb = reg1249;
  assign io_out_rs2_src = reg1262;
  assign io_out_itype_immed = reg1268;
  assign io_out_mem_read = reg1275;
  assign io_out_mem_write = reg1281;
  assign io_out_branch_type = reg1288;
  assign io_out_upper_immed = reg1295;
  assign io_out_curr_PC = reg1320;
  assign io_out_jal = reg1326;
  assign io_out_jal_offset = reg1332;
  assign io_out_PC_next = reg1255;

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
  wire eq1610, lt1641, lt1650, ge1680, ne1715, orl1717, sel1719;
  wire[31:0] sel1613, proxy1618, add1621, add1624, sub1629, shl1633, sel1643, sel1652, xorl1657, shr1661, shr1666, orl1671, andl1676, add1689, orl1695, sub1699, andl1702, sel1707;
  reg[31:0] sel1706, sel1708;

  assign eq1610 = io_in_rs2_src == 1'h1;
  assign sel1613 = eq1610 ? io_in_itype_immed : io_in_rd2;
  assign proxy1618 = {io_in_upper_immed, 12'h0};
  assign add1621 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1624 = $signed(io_in_rd1) + $signed(sel1613);
  assign sub1629 = $signed(io_in_rd1) - $signed(sel1613);
  assign shl1633 = io_in_rd1 << sel1613;
  assign lt1641 = $signed(io_in_rd1) < $signed(sel1613);
  assign sel1643 = lt1641 ? 32'h1 : 32'h0;
  assign lt1650 = io_in_rd1 < sel1613;
  assign sel1652 = lt1650 ? 32'h1 : 32'h0;
  assign xorl1657 = io_in_rd1 ^ sel1613;
  assign shr1661 = io_in_rd1 >> sel1613;
  assign shr1666 = $signed(io_in_rd1) >> sel1613;
  assign orl1671 = io_in_rd1 | sel1613;
  assign andl1676 = sel1613 & io_in_rd1;
  assign ge1680 = io_in_rd1 >= sel1613;
  assign add1689 = $signed(io_in_curr_PC) + $signed(proxy1618);
  assign orl1695 = io_in_csr_data | io_in_csr_mask;
  assign sub1699 = 32'hffffffff - io_in_csr_mask;
  assign andl1702 = io_in_csr_data & sub1699;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1706 = 32'h7b;
      4'h1: sel1706 = 32'h7b;
      4'h2: sel1706 = 32'h7b;
      4'h3: sel1706 = 32'h7b;
      4'h4: sel1706 = 32'h7b;
      4'h5: sel1706 = 32'h7b;
      4'h6: sel1706 = 32'h7b;
      4'h7: sel1706 = 32'h7b;
      4'h8: sel1706 = 32'h7b;
      4'h9: sel1706 = 32'h7b;
      4'ha: sel1706 = 32'h7b;
      4'hb: sel1706 = 32'h7b;
      4'hc: sel1706 = 32'h7b;
      4'hd: sel1706 = io_in_csr_mask;
      4'he: sel1706 = orl1695;
      4'hf: sel1706 = andl1702;
      default: sel1706 = 32'h7b;
    endcase
  end
  assign sel1707 = ge1680 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1708 = add1624;
      4'h1: sel1708 = sub1629;
      4'h2: sel1708 = shl1633;
      4'h3: sel1708 = sel1643;
      4'h4: sel1708 = sel1652;
      4'h5: sel1708 = xorl1657;
      4'h6: sel1708 = shr1661;
      4'h7: sel1708 = shr1666;
      4'h8: sel1708 = orl1671;
      4'h9: sel1708 = andl1676;
      4'ha: sel1708 = sel1707;
      4'hb: sel1708 = proxy1618;
      4'hc: sel1708 = add1689;
      4'hd: sel1708 = io_in_csr_data;
      4'he: sel1708 = io_in_csr_data;
      4'hf: sel1708 = io_in_csr_data;
      default: sel1708 = 32'h0;
    endcase
  end
  assign ne1715 = io_in_branch_type != 3'h0;
  assign orl1717 = ne1715 | io_in_jal;
  assign sel1719 = orl1717 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1706;
  assign io_out_alu_result = sel1708;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1621;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = sel1719;
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
  reg[31:0] reg1914, reg1936, reg1948, reg1961, reg1994, reg2000, reg2006, reg2024;
  reg[4:0] reg1924, reg1930, reg1942;
  reg[1:0] reg1955;
  reg[2:0] reg1968, reg1974, reg2012;
  reg[11:0] reg1981;
  reg reg1988, reg2018;

  always @ (posedge clk) begin
    if (reset)
      reg1914 <= 32'h0;
    else
      reg1914 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1924 <= 5'h0;
    else
      reg1924 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1930 <= 5'h0;
    else
      reg1930 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1936 <= 32'h0;
    else
      reg1936 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1942 <= 5'h0;
    else
      reg1942 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1948 <= 32'h0;
    else
      reg1948 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1955 <= 2'h0;
    else
      reg1955 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1961 <= 32'h0;
    else
      reg1961 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1968 <= 3'h0;
    else
      reg1968 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1974 <= 3'h0;
    else
      reg1974 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1981 <= 12'h0;
    else
      reg1981 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1988 <= 1'h0;
    else
      reg1988 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1994 <= 32'h0;
    else
      reg1994 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2000 <= 32'h0;
    else
      reg2000 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2006 <= 32'h0;
    else
      reg2006 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2012 <= 3'h0;
    else
      reg2012 <= io_in_branch_type;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2018 <= 1'h0;
    else
      reg2018 <= io_in_jal;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2024 <= 32'h0;
    else
      reg2024 <= io_in_jal_dest;
  end

  assign io_out_csr_address = reg1981;
  assign io_out_is_csr = reg1988;
  assign io_out_csr_result = reg1994;
  assign io_out_alu_result = reg1914;
  assign io_out_rd = reg1924;
  assign io_out_wb = reg1955;
  assign io_out_rs1 = reg1930;
  assign io_out_rd1 = reg1936;
  assign io_out_rd2 = reg1948;
  assign io_out_rs2 = reg1942;
  assign io_out_mem_read = reg1968;
  assign io_out_mem_write = reg1974;
  assign io_out_curr_PC = reg2000;
  assign io_out_branch_offset = reg2006;
  assign io_out_branch_type = reg2012;
  assign io_out_jal = reg2018;
  assign io_out_jal_dest = reg2024;
  assign io_out_PC_next = reg1961;

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
  wire lt2241, lt2244, orl2246, eq2254, eq2268, eq2272, andl2274, eq2295, eq2299, andl2301, orl2304, proxy2321, eq2322, proxy2339, eq2340;
  wire[1:0] sel2280, sel2284, sel2288;
  wire[7:0] proxy2313;
  wire[31:0] pad2314, proxy2317, sel2324, pad2332, proxy2335, sel2342;
  wire[15:0] proxy2331;
  reg[31:0] sel2358;

  assign lt2241 = io_in_mem_write < 3'h7;
  assign lt2244 = io_in_mem_read < 3'h7;
  assign orl2246 = lt2244 | lt2241;
  assign eq2254 = io_in_mem_write == 3'h2;
  assign eq2268 = io_in_mem_write == 3'h7;
  assign eq2272 = io_in_mem_read == 3'h7;
  assign andl2274 = eq2272 & eq2268;
  assign sel2280 = andl2274 ? 2'h0 : 2'h3;
  assign sel2284 = eq2254 ? 2'h2 : sel2280;
  assign sel2288 = lt2244 ? 2'h1 : sel2284;
  assign eq2295 = eq2254 == 1'h0;
  assign eq2299 = andl2274 == 1'h0;
  assign andl2301 = eq2299 & eq2295;
  assign orl2304 = lt2244 | andl2301;
  assign proxy2313 = io_DBUS_in_data_data[7:0];
  assign pad2314 = {{24{1'b0}}, proxy2313};
  assign proxy2317 = {24'hffffff, proxy2313};
  assign proxy2321 = proxy2313[7];
  assign eq2322 = proxy2321 == 1'h1;
  assign sel2324 = eq2322 ? proxy2317 : pad2314;
  assign proxy2331 = io_DBUS_in_data_data[15:0];
  assign pad2332 = {{16{1'b0}}, proxy2331};
  assign proxy2335 = {16'hffff, proxy2331};
  assign proxy2339 = proxy2331[15];
  assign eq2340 = proxy2339 == 1'h1;
  assign sel2342 = eq2340 ? proxy2335 : pad2332;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2358 = sel2324;
      3'h1: sel2358 = sel2342;
      3'h2: sel2358 = io_DBUS_in_data_data;
      3'h4: sel2358 = pad2314;
      3'h5: sel2358 = pad2332;
      default: sel2358 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2304;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2241;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2246;
  assign io_DBUS_out_control_data = sel2288;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2358;

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
  output wire io_out_branch_stall,
  output wire[31:0] io_out_PC_next
);
  wire[31:0] bindin2365, bindout2374, bindout2383, bindin2401, bindin2410, bindout2413, shl2416, add2418;
  wire bindin2368, bindout2371, bindout2377, bindin2380, bindout2386, bindin2389, bindout2395, bindin2398, eq2428, sel2430, sel2439, eq2446, sel2448, sel2457, eq2485, sel2487;
  wire[1:0] bindout2392;
  wire[2:0] bindin2404, bindin2407;
  reg sel2480;

  Cache __module10__(.io_DBUS_in_data_data(bindin2365), .io_DBUS_in_data_valid(bindin2368), .io_DBUS_out_data_ready(bindin2380), .io_DBUS_out_address_ready(bindin2389), .io_DBUS_out_control_ready(bindin2398), .io_in_address(bindin2401), .io_in_mem_read(bindin2404), .io_in_mem_write(bindin2407), .io_in_data(bindin2410), .io_DBUS_in_data_ready(bindout2371), .io_DBUS_out_data_data(bindout2374), .io_DBUS_out_data_valid(bindout2377), .io_DBUS_out_address_data(bindout2383), .io_DBUS_out_address_valid(bindout2386), .io_DBUS_out_control_data(bindout2392), .io_DBUS_out_control_valid(bindout2395), .io_out_data(bindout2413));
  assign bindin2365 = io_DBUS_in_data_data;
  assign bindin2368 = io_DBUS_in_data_valid;
  assign bindin2380 = io_DBUS_out_data_ready;
  assign bindin2389 = io_DBUS_out_address_ready;
  assign bindin2398 = io_DBUS_out_control_ready;
  assign bindin2401 = io_in_alu_result;
  assign bindin2404 = io_in_mem_read;
  assign bindin2407 = io_in_mem_write;
  assign bindin2410 = io_in_rd2;
  assign shl2416 = $signed(io_in_branch_offset) << 32'h1;
  assign add2418 = $signed(io_in_curr_PC) + $signed(shl2416);
  assign eq2428 = io_in_alu_result == 32'h0;
  assign sel2430 = eq2428 ? 1'h1 : 1'h0;
  assign sel2439 = eq2428 ? 1'h0 : 1'h1;
  assign eq2446 = io_in_alu_result[31] == 1'h0;
  assign sel2448 = eq2446 ? 1'h0 : 1'h1;
  assign sel2457 = eq2446 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2480 = sel2430;
      3'h2: sel2480 = sel2439;
      3'h3: sel2480 = sel2448;
      3'h4: sel2480 = sel2457;
      3'h5: sel2480 = sel2448;
      3'h6: sel2480 = sel2457;
      3'h0: sel2480 = 1'h0;
      default: sel2480 = 1'h0;
    endcase
  end
  assign eq2485 = io_in_branch_type == 3'h0;
  assign sel2487 = eq2485 ? 1'h0 : 1'h1;

  assign io_DBUS_in_data_ready = bindout2371;
  assign io_DBUS_out_data_data = bindout2374;
  assign io_DBUS_out_data_valid = bindout2377;
  assign io_DBUS_out_address_data = bindout2383;
  assign io_DBUS_out_address_valid = bindout2386;
  assign io_DBUS_out_control_data = bindout2392;
  assign io_DBUS_out_control_valid = bindout2395;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2413;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2480;
  assign io_out_branch_dest = add2418;
  assign io_out_branch_stall = sel2487;
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
  reg[31:0] reg2637, reg2646, reg2678, reg2691;
  reg[4:0] reg2653, reg2659, reg2665;
  reg[1:0] reg2672;
  reg reg2685;

  always @ (posedge clk) begin
    if (reset)
      reg2637 <= 32'h0;
    else
      reg2637 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2646 <= 32'h0;
    else
      reg2646 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2653 <= 5'h0;
    else
      reg2653 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2659 <= 5'h0;
    else
      reg2659 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2665 <= 5'h0;
    else
      reg2665 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2672 <= 2'h0;
    else
      reg2672 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2678 <= 32'h0;
    else
      reg2678 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2685 <= 1'h0;
    else
      reg2685 <= io_in_branch_dir;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2691 <= 32'h0;
    else
      reg2691 <= io_in_branch_dest;
  end

  assign io_out_alu_result = reg2637;
  assign io_out_mem_result = reg2646;
  assign io_out_rd = reg2653;
  assign io_out_wb = reg2672;
  assign io_out_rs1 = reg2659;
  assign io_out_rs2 = reg2665;
  assign io_out_branch_dir = reg2685;
  assign io_out_branch_dest = reg2691;
  assign io_out_PC_next = reg2678;

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
  wire eq2769, eq2774;
  wire[31:0] sel2776, sel2778;

  assign eq2769 = io_in_wb == 2'h3;
  assign eq2774 = io_in_wb == 2'h1;
  assign sel2776 = eq2774 ? io_in_alu_result : io_in_mem_result;
  assign sel2778 = eq2769 ? io_in_PC_next : sel2776;

  assign io_out_write_data = sel2778;
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
  output wire io_out_fwd_stall
);
  wire eq2875, eq2879, ne2884, ne2889, eq2892, andl2894, andl2896, eq2901, ne2905, eq2912, andl2914, andl2916, andl2918, eq2922, ne2930, eq2937, andl2939, andl2941, andl2943, andl2945, orl2948, orl2950, ne2958, eq2961, andl2963, andl2965, eq2969, eq2980, andl2982, andl2984, andl2986, eq2990, eq3005, andl3007, andl3009, andl3011, andl3013, orl3016, orl3018, eq3021, andl3023, eq3027, eq3030, andl3032, andl3034, orl3037, orl3044, orl3046, orl3048;

  assign eq2875 = io_in_execute_is_csr == 1'h1;
  assign eq2879 = io_in_memory_is_csr == 1'h1;
  assign ne2884 = io_in_execute_wb != 2'h0;
  assign ne2889 = io_in_decode_src1 != 5'h0;
  assign eq2892 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2894 = eq2892 & ne2889;
  assign andl2896 = andl2894 & ne2884;
  assign eq2901 = andl2896 == 1'h0;
  assign ne2905 = io_in_memory_wb != 2'h0;
  assign eq2912 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2914 = eq2912 & ne2889;
  assign andl2916 = andl2914 & ne2905;
  assign andl2918 = andl2916 & eq2901;
  assign eq2922 = andl2918 == 1'h0;
  assign ne2930 = io_in_writeback_wb != 2'h0;
  assign eq2937 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2939 = eq2937 & ne2889;
  assign andl2941 = andl2939 & ne2930;
  assign andl2943 = andl2941 & eq2901;
  assign andl2945 = andl2943 & eq2922;
  assign orl2948 = andl2896 | andl2918;
  assign orl2950 = orl2948 | andl2945;
  assign ne2958 = io_in_decode_src2 != 5'h0;
  assign eq2961 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2963 = eq2961 & ne2958;
  assign andl2965 = andl2963 & ne2884;
  assign eq2969 = andl2965 == 1'h0;
  assign eq2980 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2982 = eq2980 & ne2958;
  assign andl2984 = andl2982 & ne2905;
  assign andl2986 = andl2984 & eq2969;
  assign eq2990 = andl2986 == 1'h0;
  assign eq3005 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl3007 = eq3005 & ne2958;
  assign andl3009 = andl3007 & ne2930;
  assign andl3011 = andl3009 & eq2969;
  assign andl3013 = andl3011 & eq2990;
  assign orl3016 = andl2965 | andl2986;
  assign orl3018 = orl3016 | andl3013;
  assign eq3021 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3023 = eq3021 & eq2875;
  assign eq3027 = andl3023 == 1'h0;
  assign eq3030 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3032 = eq3030 & eq2879;
  assign andl3034 = andl3032 & eq3027;
  assign orl3037 = andl3023 | andl3034;
  assign orl3044 = orl2950 | andl2965;
  assign orl3046 = orl3044 | andl2986;
  assign orl3048 = orl3046 | andl3013;

  assign io_out_src1_fwd = orl2950;
  assign io_out_src2_fwd = orl3018;
  assign io_out_csr_fwd = orl3037;
  assign io_out_fwd_stall = orl3048;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3143 [0:1];
  wire[31:0] mrport3145, sel3149;

  initial begin
    mem3143[0] = 32'hdeadbeef;
    mem3143[1] = 32'hdeadbeef;
  end
  assign mrport3145 = mem3143[io_INTERRUPT_in_interrupt_id_data];
  assign sel3149 = io_INTERRUPT_in_interrupt_id_valid ? mrport3145 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3149;

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
  reg[3:0] reg3217, sel3307;
  wire eq3225, andl3310, eq3314, andl3318, eq3322, andl3326;
  wire[3:0] sel3231, sel3236, sel3242, sel3248, sel3258, sel3263, sel3267, sel3276, sel3282, sel3292, sel3297, sel3301, sel3308, sel3324, sel3325, sel3327;

  always @ (posedge clk) begin
    if (reset)
      reg3217 <= 4'h0;
    else
      reg3217 <= sel3327;
  end
  assign eq3225 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3231 = eq3225 ? 4'h0 : 4'h1;
  assign sel3236 = eq3225 ? 4'h2 : 4'h1;
  assign sel3242 = eq3225 ? 4'h9 : 4'h3;
  assign sel3248 = eq3225 ? 4'h5 : 4'h4;
  assign sel3258 = eq3225 ? 4'h8 : 4'h6;
  assign sel3263 = eq3225 ? 4'h7 : 4'h6;
  assign sel3267 = eq3225 ? 4'h4 : 4'h8;
  assign sel3276 = eq3225 ? 4'h0 : 4'ha;
  assign sel3282 = eq3225 ? 4'hc : 4'hb;
  assign sel3292 = eq3225 ? 4'hf : 4'hd;
  assign sel3297 = eq3225 ? 4'he : 4'hd;
  assign sel3301 = eq3225 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3217)
      4'h0: sel3307 = sel3231;
      4'h1: sel3307 = sel3236;
      4'h2: sel3307 = sel3242;
      4'h3: sel3307 = sel3248;
      4'h4: sel3307 = sel3248;
      4'h5: sel3307 = sel3258;
      4'h6: sel3307 = sel3263;
      4'h7: sel3307 = sel3267;
      4'h8: sel3307 = sel3236;
      4'h9: sel3307 = sel3276;
      4'ha: sel3307 = sel3282;
      4'hb: sel3307 = sel3282;
      4'hc: sel3307 = sel3292;
      4'hd: sel3307 = sel3297;
      4'he: sel3307 = sel3301;
      4'hf: sel3307 = sel3236;
      default: sel3307 = reg3217;
    endcase
  end
  assign sel3308 = io_JTAG_TAP_in_mode_select_valid ? sel3307 : 4'h0;
  assign andl3310 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3314 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3318 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3322 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3324 = eq3314 ? 4'h0 : reg3217;
  assign sel3325 = andl3326 ? sel3308 : reg3217;
  assign andl3326 = andl3318 & eq3322;
  assign sel3327 = andl3310 ? sel3324 : sel3325;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3217;

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
  wire bindin3333, bindin3335, bindin3336, bindin3339, bindout3342, bindin3345, bindin3348, bindout3351, bindin3354, bindin3357, bindout3360, eq3397, eq3406, eq3411, eq3489, andl3490, sel3491, sel3497;
  wire[3:0] bindout3363;
  reg[31:0] reg3371, reg3378, reg3385, reg3392, sel3487;
  wire[31:0] sel3414, sel3416, shr3423, proxy3428, sel3483, sel3484, sel3485, sel3486, sel3488;
  wire[30:0] proxy3426;
  reg sel3496, sel3502;

  assign bindin3333 = clk;
  assign bindin3335 = reset;
  TAP __module16__(.clk(bindin3333), .reset(bindin3335), .io_JTAG_TAP_in_mode_select_data(bindin3336), .io_JTAG_TAP_in_mode_select_valid(bindin3339), .io_JTAG_TAP_in_clock_data(bindin3345), .io_JTAG_TAP_in_clock_valid(bindin3348), .io_JTAG_TAP_in_reset_data(bindin3354), .io_JTAG_TAP_in_reset_valid(bindin3357), .io_JTAG_TAP_in_mode_select_ready(bindout3342), .io_JTAG_TAP_in_clock_ready(bindout3351), .io_JTAG_TAP_in_reset_ready(bindout3360), .io_out_curr_state(bindout3363));
  assign bindin3336 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3339 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3345 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3348 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3354 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3357 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3371 <= 32'h0;
    else
      reg3371 <= sel3483;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3378 <= 32'h1234;
    else
      reg3378 <= sel3486;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3385 <= 32'h5678;
    else
      reg3385 <= sel3488;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3392 <= 32'h0;
    else
      reg3392 <= sel3487;
  end
  assign eq3397 = reg3371 == 32'h0;
  assign eq3406 = reg3371 == 32'h1;
  assign eq3411 = reg3371 == 32'h2;
  assign sel3414 = eq3411 ? reg3378 : 32'hdeadbeef;
  assign sel3416 = eq3406 ? reg3385 : sel3414;
  assign shr3423 = reg3392 >> 32'h1;
  assign proxy3426 = shr3423[30:0];
  assign proxy3428 = {io_JTAG_in_data_data, proxy3426};
  assign sel3483 = (bindout3363 == 4'hf) ? reg3392 : reg3371;
  assign sel3484 = eq3411 ? reg3392 : reg3378;
  assign sel3485 = eq3406 ? reg3378 : sel3484;
  assign sel3486 = (bindout3363 == 4'h8) ? sel3485 : reg3378;
  always @(*) begin
    case (bindout3363)
      4'h3: sel3487 = sel3416;
      4'h4: sel3487 = proxy3428;
      4'ha: sel3487 = reg3371;
      4'hb: sel3487 = proxy3428;
      default: sel3487 = reg3392;
    endcase
  end
  assign sel3488 = andl3490 ? reg3392 : reg3385;
  assign eq3489 = bindout3363 == 4'h8;
  assign andl3490 = eq3489 & eq3406;
  assign sel3491 = eq3397 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3363)
      4'h3: sel3496 = sel3491;
      4'h4: sel3496 = 1'h1;
      4'h8: sel3496 = sel3491;
      4'ha: sel3496 = sel3491;
      4'hb: sel3496 = 1'h1;
      4'hf: sel3496 = sel3491;
      default: sel3496 = sel3491;
    endcase
  end
  assign sel3497 = eq3397 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3363)
      4'h3: sel3502 = sel3497;
      4'h4: sel3502 = reg3392[0];
      4'h8: sel3502 = sel3497;
      4'ha: sel3502 = sel3497;
      4'hb: sel3502 = reg3392[0];
      4'hf: sel3502 = sel3497;
      default: sel3502 = sel3497;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3342;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3351;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3360;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3502;
  assign io_JTAG_out_data_valid = sel3496;

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
  reg[11:0] mem3558 [0:4095];
  reg[11:0] reg3567;
  wire[11:0] proxy3577, mrport3579;
  wire[31:0] pad3581;

  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem3558[io_in_mem_csr_address] <= proxy3577;
    end
  end
  assign mrport3579 = mem3558[reg3567];
  always @ (posedge clk) begin
    if (reset)
      reg3567 <= 12'h0;
    else
      reg3567 <= io_in_decode_csr_address;
  end
  assign proxy3577 = io_in_mem_csr_result[11:0];
  assign pad3581 = {{20{1'b0}}, mrport3579};

  assign io_out_decode_csr_data = pad3581;

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
  input wire io_in_debug,
  output wire io_out_fwd_stall,
  output wire io_out_branch_stall
);
  wire bindin235, bindin237, bindin241, bindout244, bindout250, bindin253, bindin256, bindin262, bindin265, bindin268, bindin271, bindin277, bindin283, bindin344, bindin345, bindin352, bindin355, bindin358, bindin1042, bindin1049, bindout1064, bindout1091, bindout1106, bindout1109, bindin1409, bindin1410, bindin1432, bindin1450, bindin1453, bindin1462, bindin1471, bindout1480, bindout1507, bindout1528, bindin1745, bindin1769, bindin1778, bindout1790, bindout1823, bindout1832, bindin2029, bindin2030, bindin2064, bindin2079, bindout2088, bindout2130, bindin2495, bindout2498, bindout2504, bindin2507, bindout2513, bindin2516, bindout2522, bindin2525, bindout2585, bindout2591, bindin2696, bindin2697, bindin2719, bindout2743, bindin3074, bindin3098, bindout3131, bindin3153, bindin3156, bindout3159, bindout3162, bindin3506, bindin3507, bindin3508, bindin3511, bindout3514, bindin3517, bindin3520, bindout3523, bindin3526, bindin3529, bindout3532, bindin3535, bindin3538, bindout3541, bindout3544, bindout3547, bindin3550, bindin3586, bindin3587, bindin3594, orl3602, orl3604, eq3609, orl3611, orl3614;
  wire[31:0] bindin238, bindout247, bindin259, bindin274, bindin280, bindout286, bindout289, bindin346, bindin349, bindout361, bindout364, bindin1043, bindin1046, bindin1052, bindout1067, bindout1076, bindout1082, bindout1094, bindout1112, bindout1118, bindin1417, bindin1423, bindin1435, bindin1444, bindin1465, bindin1468, bindin1474, bindout1483, bindout1492, bindout1498, bindout1510, bindout1525, bindout1531, bindout1534, bindin1730, bindin1736, bindin1748, bindin1757, bindin1772, bindin1775, bindin1781, bindin1784, bindout1793, bindout1796, bindout1808, bindout1814, bindout1826, bindout1829, bindout1835, bindin2031, bindin2043, bindin2049, bindin2058, bindin2067, bindin2070, bindin2073, bindin2082, bindout2091, bindout2094, bindout2106, bindout2109, bindout2121, bindout2124, bindout2133, bindout2136, bindin2492, bindout2501, bindout2510, bindin2528, bindin2546, bindin2552, bindin2555, bindin2558, bindin2561, bindout2567, bindout2570, bindout2588, bindout2594, bindin2698, bindin2701, bindin2716, bindin2722, bindout2725, bindout2728, bindout2746, bindout2749, bindin2783, bindin2786, bindin2801, bindout2804, bindin3068, bindin3071, bindin3080, bindin3089, bindin3092, bindin3095, bindin3104, bindin3113, bindin3116, bindin3119, bindout3165, bindin3597, bindout3600;
  wire[4:0] bindin1055, bindout1070, bindout1073, bindout1079, bindin1411, bindin1414, bindin1420, bindout1486, bindout1489, bindout1495, bindin1724, bindin1727, bindin1733, bindout1799, bindout1805, bindout1811, bindin2034, bindin2040, bindin2046, bindout2097, bindout2103, bindout2112, bindin2537, bindin2543, bindin2549, bindout2573, bindout2579, bindout2582, bindin2704, bindin2710, bindin2713, bindout2731, bindout2737, bindout2740, bindin2789, bindin2795, bindin2798, bindout2807, bindin3053, bindin3056, bindin3062, bindin3083, bindin3107;
  wire[1:0] bindin1058, bindout1085, bindin1429, bindout1504, bindin1742, bindout1802, bindin2037, bindout2100, bindout2519, bindin2540, bindout2576, bindin2707, bindout2734, bindin2792, bindout2810, bindin3065, bindin3086, bindin3110;
  wire[11:0] bindout1061, bindin1459, bindout1477, bindin1766, bindout1787, bindin2061, bindout2085, bindin3059, bindin3077, bindin3101, bindin3588, bindin3591;
  wire[3:0] bindout1088, bindin1426, bindout1501, bindin1739;
  wire[2:0] bindout1097, bindout1100, bindout1103, bindin1438, bindin1441, bindin1447, bindout1513, bindout1516, bindout1519, bindin1751, bindin1754, bindin1760, bindout1817, bindout1820, bindin2052, bindin2055, bindin2076, bindout2115, bindout2118, bindout2127, bindin2531, bindin2534, bindin2564;
  wire[19:0] bindout1115, bindin1456, bindout1522, bindin1763;

  assign bindin235 = clk;
  assign bindin237 = reset;
  Fetch __module2__(.clk(bindin235), .reset(bindin237), .io_IBUS_in_data_data(bindin238), .io_IBUS_in_data_valid(bindin241), .io_IBUS_out_address_ready(bindin253), .io_in_branch_dir(bindin256), .io_in_branch_dest(bindin259), .io_in_branch_stall(bindin262), .io_in_fwd_stall(bindin265), .io_in_branch_stall_exe(bindin268), .io_in_jal(bindin271), .io_in_jal_dest(bindin274), .io_in_interrupt(bindin277), .io_in_interrupt_pc(bindin280), .io_in_debug(bindin283), .io_IBUS_in_data_ready(bindout244), .io_IBUS_out_address_data(bindout247), .io_IBUS_out_address_valid(bindout250), .io_out_instruction(bindout286), .io_out_curr_PC(bindout289));
  assign bindin238 = io_IBUS_in_data_data;
  assign bindin241 = io_IBUS_in_data_valid;
  assign bindin253 = io_IBUS_out_address_ready;
  assign bindin256 = bindout2743;
  assign bindin259 = bindout2746;
  assign bindin262 = bindout1106;
  assign bindin265 = bindout3131;
  assign bindin268 = orl3614;
  assign bindin271 = bindout2130;
  assign bindin274 = bindout2133;
  assign bindin277 = bindout3162;
  assign bindin280 = bindout3165;
  assign bindin283 = io_in_debug;
  assign bindin344 = clk;
  assign bindin345 = reset;
  F_D_Register __module3__(.clk(bindin344), .reset(bindin345), .io_in_instruction(bindin346), .io_in_curr_PC(bindin349), .io_in_branch_stall(bindin352), .io_in_branch_stall_exe(bindin355), .io_in_fwd_stall(bindin358), .io_out_instruction(bindout361), .io_out_curr_PC(bindout364));
  assign bindin346 = bindout286;
  assign bindin349 = bindout289;
  assign bindin352 = bindout1106;
  assign bindin355 = orl3614;
  assign bindin358 = bindout3131;
  assign bindin1042 = clk;
  Decode __module4__(.clk(bindin1042), .io_in_instruction(bindin1043), .io_in_curr_PC(bindin1046), .io_in_stall(bindin1049), .io_in_write_data(bindin1052), .io_in_rd(bindin1055), .io_in_wb(bindin1058), .io_out_csr_address(bindout1061), .io_out_is_csr(bindout1064), .io_out_csr_mask(bindout1067), .io_out_rd(bindout1070), .io_out_rs1(bindout1073), .io_out_rd1(bindout1076), .io_out_rs2(bindout1079), .io_out_rd2(bindout1082), .io_out_wb(bindout1085), .io_out_alu_op(bindout1088), .io_out_rs2_src(bindout1091), .io_out_itype_immed(bindout1094), .io_out_mem_read(bindout1097), .io_out_mem_write(bindout1100), .io_out_branch_type(bindout1103), .io_out_branch_stall(bindout1106), .io_out_jal(bindout1109), .io_out_jal_offset(bindout1112), .io_out_upper_immed(bindout1115), .io_out_PC_next(bindout1118));
  assign bindin1043 = bindout361;
  assign bindin1046 = bindout364;
  assign bindin1049 = orl3611;
  assign bindin1052 = bindout2804;
  assign bindin1055 = bindout2807;
  assign bindin1058 = bindout2810;
  assign bindin1409 = clk;
  assign bindin1410 = reset;
  D_E_Register __module6__(.clk(bindin1409), .reset(bindin1410), .io_in_rd(bindin1411), .io_in_rs1(bindin1414), .io_in_rd1(bindin1417), .io_in_rs2(bindin1420), .io_in_rd2(bindin1423), .io_in_alu_op(bindin1426), .io_in_wb(bindin1429), .io_in_rs2_src(bindin1432), .io_in_itype_immed(bindin1435), .io_in_mem_read(bindin1438), .io_in_mem_write(bindin1441), .io_in_PC_next(bindin1444), .io_in_branch_type(bindin1447), .io_in_fwd_stall(bindin1450), .io_in_branch_stall(bindin1453), .io_in_upper_immed(bindin1456), .io_in_csr_address(bindin1459), .io_in_is_csr(bindin1462), .io_in_csr_mask(bindin1465), .io_in_curr_PC(bindin1468), .io_in_jal(bindin1471), .io_in_jal_offset(bindin1474), .io_out_csr_address(bindout1477), .io_out_is_csr(bindout1480), .io_out_csr_mask(bindout1483), .io_out_rd(bindout1486), .io_out_rs1(bindout1489), .io_out_rd1(bindout1492), .io_out_rs2(bindout1495), .io_out_rd2(bindout1498), .io_out_alu_op(bindout1501), .io_out_wb(bindout1504), .io_out_rs2_src(bindout1507), .io_out_itype_immed(bindout1510), .io_out_mem_read(bindout1513), .io_out_mem_write(bindout1516), .io_out_branch_type(bindout1519), .io_out_upper_immed(bindout1522), .io_out_curr_PC(bindout1525), .io_out_jal(bindout1528), .io_out_jal_offset(bindout1531), .io_out_PC_next(bindout1534));
  assign bindin1411 = bindout1070;
  assign bindin1414 = bindout1073;
  assign bindin1417 = bindout1076;
  assign bindin1420 = bindout1079;
  assign bindin1423 = bindout1082;
  assign bindin1426 = bindout1088;
  assign bindin1429 = bindout1085;
  assign bindin1432 = bindout1091;
  assign bindin1435 = bindout1094;
  assign bindin1438 = bindout1097;
  assign bindin1441 = bindout1100;
  assign bindin1444 = bindout1118;
  assign bindin1447 = bindout1103;
  assign bindin1450 = bindout3131;
  assign bindin1453 = orl3614;
  assign bindin1456 = bindout1115;
  assign bindin1459 = bindout1061;
  assign bindin1462 = bindout1064;
  assign bindin1465 = bindout1067;
  assign bindin1468 = bindout364;
  assign bindin1471 = bindout1109;
  assign bindin1474 = bindout1112;
  Execute __module7__(.io_in_rd(bindin1724), .io_in_rs1(bindin1727), .io_in_rd1(bindin1730), .io_in_rs2(bindin1733), .io_in_rd2(bindin1736), .io_in_alu_op(bindin1739), .io_in_wb(bindin1742), .io_in_rs2_src(bindin1745), .io_in_itype_immed(bindin1748), .io_in_mem_read(bindin1751), .io_in_mem_write(bindin1754), .io_in_PC_next(bindin1757), .io_in_branch_type(bindin1760), .io_in_upper_immed(bindin1763), .io_in_csr_address(bindin1766), .io_in_is_csr(bindin1769), .io_in_csr_data(bindin1772), .io_in_csr_mask(bindin1775), .io_in_jal(bindin1778), .io_in_jal_offset(bindin1781), .io_in_curr_PC(bindin1784), .io_out_csr_address(bindout1787), .io_out_is_csr(bindout1790), .io_out_csr_result(bindout1793), .io_out_alu_result(bindout1796), .io_out_rd(bindout1799), .io_out_wb(bindout1802), .io_out_rs1(bindout1805), .io_out_rd1(bindout1808), .io_out_rs2(bindout1811), .io_out_rd2(bindout1814), .io_out_mem_read(bindout1817), .io_out_mem_write(bindout1820), .io_out_jal(bindout1823), .io_out_jal_dest(bindout1826), .io_out_branch_offset(bindout1829), .io_out_branch_stall(bindout1832), .io_out_PC_next(bindout1835));
  assign bindin1724 = bindout1486;
  assign bindin1727 = bindout1489;
  assign bindin1730 = bindout1492;
  assign bindin1733 = bindout1495;
  assign bindin1736 = bindout1498;
  assign bindin1739 = bindout1501;
  assign bindin1742 = bindout1504;
  assign bindin1745 = bindout1507;
  assign bindin1748 = bindout1510;
  assign bindin1751 = bindout1513;
  assign bindin1754 = bindout1516;
  assign bindin1757 = bindout1534;
  assign bindin1760 = bindout1519;
  assign bindin1763 = bindout1522;
  assign bindin1766 = bindout1477;
  assign bindin1769 = bindout1480;
  assign bindin1772 = bindout3600;
  assign bindin1775 = bindout1483;
  assign bindin1778 = bindout1528;
  assign bindin1781 = bindout1531;
  assign bindin1784 = bindout1525;
  assign bindin2029 = clk;
  assign bindin2030 = reset;
  E_M_Register __module8__(.clk(bindin2029), .reset(bindin2030), .io_in_alu_result(bindin2031), .io_in_rd(bindin2034), .io_in_wb(bindin2037), .io_in_rs1(bindin2040), .io_in_rd1(bindin2043), .io_in_rs2(bindin2046), .io_in_rd2(bindin2049), .io_in_mem_read(bindin2052), .io_in_mem_write(bindin2055), .io_in_PC_next(bindin2058), .io_in_csr_address(bindin2061), .io_in_is_csr(bindin2064), .io_in_csr_result(bindin2067), .io_in_curr_PC(bindin2070), .io_in_branch_offset(bindin2073), .io_in_branch_type(bindin2076), .io_in_jal(bindin2079), .io_in_jal_dest(bindin2082), .io_out_csr_address(bindout2085), .io_out_is_csr(bindout2088), .io_out_csr_result(bindout2091), .io_out_alu_result(bindout2094), .io_out_rd(bindout2097), .io_out_wb(bindout2100), .io_out_rs1(bindout2103), .io_out_rd1(bindout2106), .io_out_rd2(bindout2109), .io_out_rs2(bindout2112), .io_out_mem_read(bindout2115), .io_out_mem_write(bindout2118), .io_out_curr_PC(bindout2121), .io_out_branch_offset(bindout2124), .io_out_branch_type(bindout2127), .io_out_jal(bindout2130), .io_out_jal_dest(bindout2133), .io_out_PC_next(bindout2136));
  assign bindin2031 = bindout1796;
  assign bindin2034 = bindout1799;
  assign bindin2037 = bindout1802;
  assign bindin2040 = bindout1805;
  assign bindin2043 = bindout1808;
  assign bindin2046 = bindout1811;
  assign bindin2049 = bindout1814;
  assign bindin2052 = bindout1817;
  assign bindin2055 = bindout1820;
  assign bindin2058 = bindout1835;
  assign bindin2061 = bindout1787;
  assign bindin2064 = bindout1790;
  assign bindin2067 = bindout1793;
  assign bindin2070 = bindout1525;
  assign bindin2073 = bindout1829;
  assign bindin2076 = bindout1519;
  assign bindin2079 = bindout1823;
  assign bindin2082 = bindout1826;
  Memory __module9__(.io_DBUS_in_data_data(bindin2492), .io_DBUS_in_data_valid(bindin2495), .io_DBUS_out_data_ready(bindin2507), .io_DBUS_out_address_ready(bindin2516), .io_DBUS_out_control_ready(bindin2525), .io_in_alu_result(bindin2528), .io_in_mem_read(bindin2531), .io_in_mem_write(bindin2534), .io_in_rd(bindin2537), .io_in_wb(bindin2540), .io_in_rs1(bindin2543), .io_in_rd1(bindin2546), .io_in_rs2(bindin2549), .io_in_rd2(bindin2552), .io_in_PC_next(bindin2555), .io_in_curr_PC(bindin2558), .io_in_branch_offset(bindin2561), .io_in_branch_type(bindin2564), .io_DBUS_in_data_ready(bindout2498), .io_DBUS_out_data_data(bindout2501), .io_DBUS_out_data_valid(bindout2504), .io_DBUS_out_address_data(bindout2510), .io_DBUS_out_address_valid(bindout2513), .io_DBUS_out_control_data(bindout2519), .io_DBUS_out_control_valid(bindout2522), .io_out_alu_result(bindout2567), .io_out_mem_result(bindout2570), .io_out_rd(bindout2573), .io_out_wb(bindout2576), .io_out_rs1(bindout2579), .io_out_rs2(bindout2582), .io_out_branch_dir(bindout2585), .io_out_branch_dest(bindout2588), .io_out_branch_stall(bindout2591), .io_out_PC_next(bindout2594));
  assign bindin2492 = io_DBUS_in_data_data;
  assign bindin2495 = io_DBUS_in_data_valid;
  assign bindin2507 = io_DBUS_out_data_ready;
  assign bindin2516 = io_DBUS_out_address_ready;
  assign bindin2525 = io_DBUS_out_control_ready;
  assign bindin2528 = bindout2094;
  assign bindin2531 = bindout2115;
  assign bindin2534 = bindout2118;
  assign bindin2537 = bindout2097;
  assign bindin2540 = bindout2100;
  assign bindin2543 = bindout2103;
  assign bindin2546 = bindout2106;
  assign bindin2549 = bindout2112;
  assign bindin2552 = bindout2109;
  assign bindin2555 = bindout2136;
  assign bindin2558 = bindout2121;
  assign bindin2561 = bindout2124;
  assign bindin2564 = bindout2127;
  assign bindin2696 = clk;
  assign bindin2697 = reset;
  M_W_Register __module11__(.clk(bindin2696), .reset(bindin2697), .io_in_alu_result(bindin2698), .io_in_mem_result(bindin2701), .io_in_rd(bindin2704), .io_in_wb(bindin2707), .io_in_rs1(bindin2710), .io_in_rs2(bindin2713), .io_in_PC_next(bindin2716), .io_in_branch_dir(bindin2719), .io_in_branch_dest(bindin2722), .io_out_alu_result(bindout2725), .io_out_mem_result(bindout2728), .io_out_rd(bindout2731), .io_out_wb(bindout2734), .io_out_rs1(bindout2737), .io_out_rs2(bindout2740), .io_out_branch_dir(bindout2743), .io_out_branch_dest(bindout2746), .io_out_PC_next(bindout2749));
  assign bindin2698 = bindout2567;
  assign bindin2701 = bindout2570;
  assign bindin2704 = bindout2573;
  assign bindin2707 = bindout2576;
  assign bindin2710 = bindout2579;
  assign bindin2713 = bindout2582;
  assign bindin2716 = bindout2594;
  assign bindin2719 = bindout2585;
  assign bindin2722 = bindout2588;
  Write_Back __module12__(.io_in_alu_result(bindin2783), .io_in_mem_result(bindin2786), .io_in_rd(bindin2789), .io_in_wb(bindin2792), .io_in_rs1(bindin2795), .io_in_rs2(bindin2798), .io_in_PC_next(bindin2801), .io_out_write_data(bindout2804), .io_out_rd(bindout2807), .io_out_wb(bindout2810));
  assign bindin2783 = bindout2725;
  assign bindin2786 = bindout2728;
  assign bindin2789 = bindout2731;
  assign bindin2792 = bindout2734;
  assign bindin2795 = bindout2737;
  assign bindin2798 = bindout2740;
  assign bindin2801 = bindout2749;
  Forwarding __module13__(.io_in_decode_src1(bindin3053), .io_in_decode_src2(bindin3056), .io_in_decode_csr_address(bindin3059), .io_in_execute_dest(bindin3062), .io_in_execute_wb(bindin3065), .io_in_execute_alu_result(bindin3068), .io_in_execute_PC_next(bindin3071), .io_in_execute_is_csr(bindin3074), .io_in_execute_csr_address(bindin3077), .io_in_execute_csr_result(bindin3080), .io_in_memory_dest(bindin3083), .io_in_memory_wb(bindin3086), .io_in_memory_alu_result(bindin3089), .io_in_memory_mem_data(bindin3092), .io_in_memory_PC_next(bindin3095), .io_in_memory_is_csr(bindin3098), .io_in_memory_csr_address(bindin3101), .io_in_memory_csr_result(bindin3104), .io_in_writeback_dest(bindin3107), .io_in_writeback_wb(bindin3110), .io_in_writeback_alu_result(bindin3113), .io_in_writeback_mem_data(bindin3116), .io_in_writeback_PC_next(bindin3119), .io_out_fwd_stall(bindout3131));
  assign bindin3053 = bindout1073;
  assign bindin3056 = bindout1079;
  assign bindin3059 = bindout1061;
  assign bindin3062 = bindout1799;
  assign bindin3065 = bindout1802;
  assign bindin3068 = bindout1796;
  assign bindin3071 = bindout1835;
  assign bindin3074 = bindout1790;
  assign bindin3077 = bindout1787;
  assign bindin3080 = bindout1793;
  assign bindin3083 = bindout2573;
  assign bindin3086 = bindout2576;
  assign bindin3089 = bindout2567;
  assign bindin3092 = bindout2570;
  assign bindin3095 = bindout2594;
  assign bindin3098 = bindout2088;
  assign bindin3101 = bindout2085;
  assign bindin3104 = bindout2091;
  assign bindin3107 = bindout2731;
  assign bindin3110 = bindout2734;
  assign bindin3113 = bindout2725;
  assign bindin3116 = bindout2728;
  assign bindin3119 = bindout2749;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3153), .io_INTERRUPT_in_interrupt_id_valid(bindin3156), .io_INTERRUPT_in_interrupt_id_ready(bindout3159), .io_out_interrupt(bindout3162), .io_out_interrupt_pc(bindout3165));
  assign bindin3153 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3156 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3506 = clk;
  assign bindin3507 = reset;
  JTAG __module15__(.clk(bindin3506), .reset(bindin3507), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3508), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3511), .io_JTAG_JTAG_TAP_in_clock_data(bindin3517), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3520), .io_JTAG_JTAG_TAP_in_reset_data(bindin3526), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3529), .io_JTAG_in_data_data(bindin3535), .io_JTAG_in_data_valid(bindin3538), .io_JTAG_out_data_ready(bindin3550), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3514), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3523), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3532), .io_JTAG_in_data_ready(bindout3541), .io_JTAG_out_data_data(bindout3544), .io_JTAG_out_data_valid(bindout3547));
  assign bindin3508 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3511 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3517 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3520 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3526 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3529 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3535 = io_jtag_in_data_data;
  assign bindin3538 = io_jtag_in_data_valid;
  assign bindin3550 = io_jtag_out_data_ready;
  assign bindin3586 = clk;
  assign bindin3587 = reset;
  CSR_Handler __module17__(.clk(bindin3586), .reset(bindin3587), .io_in_decode_csr_address(bindin3588), .io_in_mem_csr_address(bindin3591), .io_in_mem_is_csr(bindin3594), .io_in_mem_csr_result(bindin3597), .io_out_decode_csr_data(bindout3600));
  assign bindin3588 = bindout1061;
  assign bindin3591 = bindout2085;
  assign bindin3594 = bindout2088;
  assign bindin3597 = bindout2091;
  assign orl3602 = bindout1106 | bindout1832;
  assign orl3604 = orl3602 | bindout2591;
  assign eq3609 = bindout1832 == 1'h1;
  assign orl3611 = eq3609 | bindout2591;
  assign orl3614 = bindout1832 | bindout2591;

  assign io_IBUS_in_data_ready = bindout244;
  assign io_IBUS_out_address_data = bindout247;
  assign io_IBUS_out_address_valid = bindout250;
  assign io_DBUS_in_data_ready = bindout2498;
  assign io_DBUS_out_data_data = bindout2501;
  assign io_DBUS_out_data_valid = bindout2504;
  assign io_DBUS_out_address_data = bindout2510;
  assign io_DBUS_out_address_valid = bindout2513;
  assign io_DBUS_out_control_data = bindout2519;
  assign io_DBUS_out_control_valid = bindout2522;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3159;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3514;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3523;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3532;
  assign io_jtag_in_data_ready = bindout3541;
  assign io_jtag_out_data_data = bindout3544;
  assign io_jtag_out_data_valid = bindout3547;
  assign io_out_fwd_stall = bindout3131;
  assign io_out_branch_stall = orl3604;

endmodule
