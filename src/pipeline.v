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
  output wire[31:0] io_out_curr_PC
);
  reg reg110;
  reg[31:0] reg120, reg133, reg139, reg145, reg151, sel161;
  reg[3:0] reg127;
  wire[31:0] sel162, sel177, sel183, sel189, sel191, add214, add217, add220, add223;
  wire eq166, eq170, orl172, orl174, eq181, eq187;
  wire[3:0] sel199, sel206, sel209;

  always @ (posedge clk) begin
    if (reset)
      reg110 <= 1'h0;
    else
      reg110 <= orl174;
  end
  always @ (posedge clk) begin
    if (reset)
      reg120 <= 32'h0;
    else
      reg120 <= sel191;
  end
  always @ (posedge clk) begin
    if (reset)
      reg127 <= 4'h0;
    else
      reg127 <= sel209;
  end
  always @ (posedge clk) begin
    if (reset)
      reg133 <= 32'h0;
    else
      reg133 <= add214;
  end
  always @ (posedge clk) begin
    if (reset)
      reg139 <= 32'h0;
    else
      reg139 <= add217;
  end
  always @ (posedge clk) begin
    if (reset)
      reg145 <= 32'h0;
    else
      reg145 <= add220;
  end
  always @ (posedge clk) begin
    if (reset)
      reg151 <= 32'h0;
    else
      reg151 <= add223;
  end
  always @(*) begin
    case (reg127)
      4'h0: sel161 = reg133;
      4'h1: sel161 = reg139;
      4'h2: sel161 = reg145;
      4'h3: sel161 = reg151;
      default: sel161 = 32'h0;
    endcase
  end
  assign sel162 = reg110 ? reg120 : sel161;
  assign eq166 = io_in_fwd_stall == 1'h1;
  assign eq170 = io_in_branch_stall == 1'h1;
  assign orl172 = eq170 | eq166;
  assign orl174 = orl172 | io_in_branch_stall_exe;
  assign sel177 = orl174 ? 32'h0 : io_IBUS_in_data_data;
  assign eq181 = io_in_branch_dir == 1'h1;
  assign sel183 = eq181 ? io_in_branch_dest : sel162;
  assign eq187 = io_in_jal == 1'h1;
  assign sel189 = eq187 ? io_in_jal_dest : sel183;
  assign sel191 = io_in_interrupt ? io_in_interrupt_pc : sel189;
  assign sel199 = eq181 ? 4'h2 : 4'h0;
  assign sel206 = eq187 ? 4'h1 : sel199;
  assign sel209 = io_in_interrupt ? 4'h3 : sel206;
  assign add214 = sel162 + 32'h4;
  assign add217 = io_in_jal_dest + 32'h4;
  assign add220 = io_in_branch_dest + 32'h4;
  assign add223 = io_in_interrupt_pc + 32'h4;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_valid;
  assign io_IBUS_out_address_data = sel191;
  assign io_IBUS_out_address_valid = 1'h1;
  assign io_out_instruction = sel177;
  assign io_out_curr_PC = sel191;

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
  reg[31:0] reg299, reg308;
  wire eq329;
  wire[31:0] sel331, sel332;

  always @ (posedge clk) begin
    if (reset)
      reg299 <= 32'h0;
    else
      reg299 <= sel332;
  end
  always @ (posedge clk) begin
    if (reset)
      reg308 <= 32'h0;
    else
      reg308 <= sel331;
  end
  assign eq329 = io_in_fwd_stall == 1'h0;
  assign sel331 = eq329 ? io_in_curr_PC : reg308;
  assign sel332 = eq329 ? io_in_instruction : reg299;

  assign io_out_instruction = reg299;
  assign io_out_curr_PC = reg308;

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
  reg[31:0] mem434 [0:31];
  wire[31:0] mrport445, sel454, mrport456, sel463;
  wire eq452, eq461;

  always @ (posedge clk) begin
    if (io_in_write_register) begin
      mem434[io_in_rd] <= io_in_data;
    end
  end
  assign mrport445 = mem434[io_in_src1];
  assign mrport456 = mem434[io_in_src2];
  assign eq452 = io_in_src1 == 5'h0;
  assign sel454 = eq452 ? 32'h0 : mrport445;
  assign eq461 = io_in_src2 == 5'h0;
  assign sel463 = eq461 ? 32'h0 : mrport456;

  assign io_out_src1_data = sel454;
  assign io_out_src2_data = sel463;

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
  wire bindin470, bindin471, ne531, sel533, eq585, eq590, eq595, orl597, eq602, eq607, eq612, eq617, eq622, eq627, ne632, eq637, andl639, proxy642, eq643, andl646, eq650, andl656, orl668, orl670, orl672, orl674, orl685, orl687, orl694, sel696, proxy722, proxy730, eq748, proxy765, eq766, eq772, lt776, andl779, sel791, ne794, ge797, eq800, andl805, andl807, eq816, eq821, orl823, eq838, proxy868, eq869, proxy874, eq903, eq941, eq978, eq986, eq994, orl1000, lt1018;
  wire[4:0] bindin474, bindin480, bindin483, proxy543, proxy550, proxy557;
  wire[31:0] bindin477, bindout486, bindout489, shr540, shr547, shr554, shr561, shr568, add580, sel658, pad660, sel662, shr726, pad739, proxy744, sel750, pad756, proxy761, sel768, sel789, pad829, proxy833, sel840, pad860, proxy864, sel871, shr878, sel905;
  wire[2:0] proxy564, sel700, sel703;
  wire[6:0] proxy571;
  wire[11:0] proxy577, proxy754, sel809, pad825, sel827, proxy843, proxy889;
  wire[1:0] sel676, sel680, sel689, proxy973;
  wire[19:0] proxy706;
  reg[19:0] sel715;
  wire[7:0] proxy721;
  wire[9:0] proxy729;
  wire[20:0] proxy733;
  reg[31:0] sel790, sel909;
  reg sel792, sel931;
  wire[3:0] proxy881, sel943, sel946, sel963, sel980, sel988, sel996, sel1002, sel1004, sel1008, sel1012, sel1020, sel1022;
  wire[5:0] proxy887;
  reg[11:0] sel910;
  reg[2:0] sel929, sel930;
  reg[3:0] sel971;

  assign bindin470 = clk;
  RegisterFile __module5__(.clk(bindin470), .io_in_write_register(bindin471), .io_in_rd(bindin474), .io_in_data(bindin477), .io_in_src1(bindin480), .io_in_src2(bindin483), .io_out_src1_data(bindout486), .io_out_src2_data(bindout489));
  assign bindin471 = sel533;
  assign bindin474 = io_in_rd;
  assign bindin477 = io_in_write_data;
  assign bindin480 = proxy550;
  assign bindin483 = proxy557;
  assign ne531 = io_in_wb != 2'h0;
  assign sel533 = ne531 ? 1'h1 : 1'h0;
  assign shr540 = io_in_instruction >> 32'h7;
  assign proxy543 = shr540[4:0];
  assign shr547 = io_in_instruction >> 32'hf;
  assign proxy550 = shr547[4:0];
  assign shr554 = io_in_instruction >> 32'h14;
  assign proxy557 = shr554[4:0];
  assign shr561 = io_in_instruction >> 32'hc;
  assign proxy564 = shr561[2:0];
  assign shr568 = io_in_instruction >> 32'h19;
  assign proxy571 = shr568[6:0];
  assign proxy577 = shr554[11:0];
  assign add580 = io_in_curr_PC + 32'h4;
  assign eq585 = io_in_instruction[6:0] == 7'h33;
  assign eq590 = io_in_instruction[6:0] == 7'h3;
  assign eq595 = io_in_instruction[6:0] == 7'h13;
  assign orl597 = eq595 | eq590;
  assign eq602 = io_in_instruction[6:0] == 7'h23;
  assign eq607 = io_in_instruction[6:0] == 7'h63;
  assign eq612 = io_in_instruction[6:0] == 7'h6f;
  assign eq617 = io_in_instruction[6:0] == 7'h67;
  assign eq622 = io_in_instruction[6:0] == 7'h37;
  assign eq627 = io_in_instruction[6:0] == 7'h17;
  assign ne632 = proxy564 != 3'h0;
  assign eq637 = io_in_instruction[6:0] == 7'h73;
  assign andl639 = eq637 & ne632;
  assign proxy642 = proxy564[2];
  assign eq643 = proxy642 == 1'h1;
  assign andl646 = andl639 & eq643;
  assign eq650 = proxy564 == 3'h0;
  assign andl656 = eq637 & eq650;
  assign sel658 = eq612 ? io_in_curr_PC : bindout486;
  assign pad660 = {{27{1'b0}}, proxy550};
  assign sel662 = andl646 ? pad660 : sel658;
  assign orl668 = orl597 | eq585;
  assign orl670 = orl668 | eq622;
  assign orl672 = orl670 | eq627;
  assign orl674 = orl672 | andl639;
  assign sel676 = orl674 ? 2'h1 : 2'h0;
  assign sel680 = eq590 ? 2'h2 : sel676;
  assign orl685 = eq612 | eq617;
  assign orl687 = orl685 | andl656;
  assign sel689 = orl687 ? 2'h3 : sel680;
  assign orl694 = orl597 | eq602;
  assign sel696 = orl694 ? 1'h1 : 1'h0;
  assign sel700 = eq590 ? proxy564 : 3'h7;
  assign sel703 = eq602 ? proxy564 : 3'h7;
  assign proxy706 = {proxy571, proxy557, proxy550, proxy564};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h37: sel715 = proxy706;
      7'h17: sel715 = proxy706;
      default: sel715 = 20'h7b;
    endcase
  end
  assign proxy721 = shr561[7:0];
  assign proxy722 = io_in_instruction[20];
  assign shr726 = io_in_instruction >> 32'h15;
  assign proxy729 = shr726[9:0];
  assign proxy730 = io_in_instruction[31];
  assign proxy733 = {proxy730, proxy721, proxy722, proxy729, 1'h0};
  assign pad739 = {{11{1'b0}}, proxy733};
  assign proxy744 = {11'h7ff, proxy733};
  assign eq748 = proxy730 == 1'h1;
  assign sel750 = eq748 ? proxy744 : pad739;
  assign proxy754 = {proxy571, proxy557};
  assign pad756 = {{20{1'b0}}, proxy754};
  assign proxy761 = {20'hfffff, proxy754};
  assign proxy765 = proxy754[11];
  assign eq766 = proxy765 == 1'h1;
  assign sel768 = eq766 ? proxy761 : pad756;
  assign eq772 = proxy564 == 3'h0;
  assign lt776 = proxy577 < 12'h2;
  assign andl779 = eq772 & lt776;
  assign sel789 = andl779 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel790 = sel750;
      7'h67: sel790 = sel768;
      7'h73: sel790 = sel789;
      default: sel790 = 32'h7b;
    endcase
  end
  assign sel791 = andl779 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel792 = 1'h1;
      7'h67: sel792 = 1'h1;
      7'h73: sel792 = sel791;
      default: sel792 = 1'h0;
    endcase
  end
  assign ne794 = proxy564 != 3'h0;
  assign ge797 = proxy577 >= 12'h2;
  assign eq800 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign andl805 = ne794 & ge797;
  assign andl807 = andl805 & eq800;
  assign sel809 = andl807 ? proxy577 : 12'h7b;
  assign eq816 = proxy564 == 3'h5;
  assign eq821 = proxy564 == 3'h1;
  assign orl823 = eq821 | eq816;
  assign pad825 = {{7{1'b0}}, proxy557};
  assign sel827 = orl823 ? pad825 : proxy577;
  assign pad829 = {{20{1'b0}}, sel910};
  assign proxy833 = {20'hfffff, sel910};
  assign eq838 = sel910[11] == 1'h1;
  assign sel840 = eq838 ? proxy833 : pad829;
  assign proxy843 = {proxy571, proxy543};
  assign pad860 = {{20{1'b0}}, proxy577};
  assign proxy864 = {20'hfffff, proxy577};
  assign proxy868 = proxy577[11];
  assign eq869 = proxy868 == 1'h1;
  assign sel871 = eq869 ? proxy864 : pad860;
  assign proxy874 = io_in_instruction[7];
  assign shr878 = io_in_instruction >> 32'h8;
  assign proxy881 = shr878[3:0];
  assign proxy887 = shr568[5:0];
  assign proxy889 = {proxy730, proxy874, proxy887, proxy881};
  assign eq903 = proxy730 == 1'h1;
  assign sel905 = eq903 ? proxy833 : pad829;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel909 = sel840;
      7'h23: sel909 = sel840;
      7'h03: sel909 = sel871;
      7'h63: sel909 = sel905;
      default: sel909 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel910 = sel827;
      7'h23: sel910 = proxy843;
      7'h03: sel910 = 12'h0;
      7'h63: sel910 = proxy889;
      default: sel910 = 12'h0;
    endcase
  end
  always @(*) begin
    case (proxy564)
      3'h0: sel929 = 3'h1;
      3'h1: sel929 = 3'h2;
      3'h4: sel929 = 3'h3;
      3'h5: sel929 = 3'h4;
      3'h6: sel929 = 3'h5;
      3'h7: sel929 = 3'h6;
      default: sel929 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel930 = sel929;
      7'h6f: sel930 = 3'h0;
      7'h67: sel930 = 3'h0;
      default: sel930 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel931 = 1'h1;
      7'h6f: sel931 = 1'h1;
      7'h67: sel931 = 1'h1;
      default: sel931 = 1'h0;
    endcase
  end
  assign eq941 = proxy571 == 7'h0;
  assign sel943 = eq941 ? 4'h0 : 4'h1;
  assign sel946 = eq595 ? 4'h0 : sel943;
  assign sel963 = eq941 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy564)
      3'h0: sel971 = sel946;
      3'h1: sel971 = 4'h2;
      3'h2: sel971 = 4'h3;
      3'h3: sel971 = 4'h4;
      3'h4: sel971 = 4'h5;
      3'h5: sel971 = sel963;
      3'h6: sel971 = 4'h8;
      3'h7: sel971 = 4'h9;
      default: sel971 = 4'hf;
    endcase
  end
  assign proxy973 = proxy564[1:0];
  assign eq978 = proxy973 == 2'h3;
  assign sel980 = eq978 ? 4'hf : 4'hf;
  assign eq986 = proxy973 == 2'h2;
  assign sel988 = eq986 ? 4'he : sel980;
  assign eq994 = proxy973 == 2'h1;
  assign sel996 = eq994 ? 4'hd : sel988;
  assign orl1000 = eq602 | eq590;
  assign sel1002 = orl1000 ? 4'h0 : sel971;
  assign sel1004 = andl639 ? sel996 : sel1002;
  assign sel1008 = eq627 ? 4'hc : sel1004;
  assign sel1012 = eq622 ? 4'hb : sel1008;
  assign lt1018 = sel930 < 3'h5;
  assign sel1020 = lt1018 ? 4'h1 : 4'ha;
  assign sel1022 = eq607 ? sel1020 : sel1012;

  assign io_out_csr_address = sel809;
  assign io_out_is_csr = andl639;
  assign io_out_csr_mask = sel662;
  assign io_out_rd = proxy543;
  assign io_out_rs1 = proxy550;
  assign io_out_rd1 = sel658;
  assign io_out_rs2 = proxy557;
  assign io_out_rd2 = bindout489;
  assign io_out_wb = sel689;
  assign io_out_alu_op = sel1022;
  assign io_out_rs2_src = sel696;
  assign io_out_itype_immed = sel909;
  assign io_out_mem_read = sel700;
  assign io_out_mem_write = sel703;
  assign io_out_branch_type = sel930;
  assign io_out_branch_stall = sel931;
  assign io_out_jal = sel792;
  assign io_out_jal_offset = sel790;
  assign io_out_upper_immed = sel715;
  assign io_out_PC_next = add580;

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
  reg[4:0] reg1192, reg1201, reg1214;
  reg[31:0] reg1208, reg1220, reg1240, reg1253, reg1299, reg1305, reg1317;
  reg[3:0] reg1227;
  reg[1:0] reg1234;
  reg reg1247, reg1293, reg1311;
  reg[2:0] reg1260, reg1266, reg1273;
  reg[19:0] reg1280;
  reg[11:0] reg1287;
  wire eq1321, eq1325, orl1327, sel1355, sel1377, sel1383;
  wire[4:0] sel1330, sel1333, sel1339;
  wire[31:0] sel1336, sel1342, sel1352, sel1359, sel1380, sel1386, sel1389;
  wire[3:0] sel1346;
  wire[1:0] sel1349;
  wire[2:0] sel1362, sel1365, sel1368;
  wire[19:0] sel1371;
  wire[11:0] sel1374;

  always @ (posedge clk) begin
    if (reset)
      reg1192 <= 5'h0;
    else
      reg1192 <= sel1330;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1201 <= 5'h0;
    else
      reg1201 <= sel1333;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1208 <= 32'h0;
    else
      reg1208 <= sel1336;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1214 <= 5'h0;
    else
      reg1214 <= sel1339;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1220 <= 32'h0;
    else
      reg1220 <= sel1342;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1227 <= 4'h0;
    else
      reg1227 <= sel1346;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1234 <= 2'h0;
    else
      reg1234 <= sel1349;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1240 <= 32'h0;
    else
      reg1240 <= sel1352;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1247 <= 1'h0;
    else
      reg1247 <= sel1355;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1253 <= 32'h0;
    else
      reg1253 <= sel1359;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1260 <= 3'h7;
    else
      reg1260 <= sel1362;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1266 <= 3'h7;
    else
      reg1266 <= sel1365;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1273 <= 3'h0;
    else
      reg1273 <= sel1368;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1280 <= 20'h0;
    else
      reg1280 <= sel1371;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1287 <= 12'h0;
    else
      reg1287 <= sel1374;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1293 <= 1'h0;
    else
      reg1293 <= sel1377;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1299 <= 32'h0;
    else
      reg1299 <= sel1380;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1305 <= 32'h0;
    else
      reg1305 <= sel1389;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1311 <= 1'h0;
    else
      reg1311 <= sel1383;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1317 <= 32'h0;
    else
      reg1317 <= sel1386;
  end
  assign eq1321 = io_in_branch_stall == 1'h1;
  assign eq1325 = io_in_fwd_stall == 1'h1;
  assign orl1327 = eq1325 | eq1321;
  assign sel1330 = orl1327 ? 5'h0 : io_in_rd;
  assign sel1333 = orl1327 ? 5'h0 : io_in_rs1;
  assign sel1336 = orl1327 ? 32'h0 : io_in_rd1;
  assign sel1339 = orl1327 ? 5'h0 : io_in_rs2;
  assign sel1342 = orl1327 ? 32'h0 : io_in_rd2;
  assign sel1346 = orl1327 ? 4'hf : io_in_alu_op;
  assign sel1349 = orl1327 ? 2'h0 : io_in_wb;
  assign sel1352 = orl1327 ? 32'h0 : io_in_PC_next;
  assign sel1355 = orl1327 ? 1'h0 : io_in_rs2_src;
  assign sel1359 = orl1327 ? 32'h7b : io_in_itype_immed;
  assign sel1362 = orl1327 ? 3'h7 : io_in_mem_read;
  assign sel1365 = orl1327 ? 3'h7 : io_in_mem_write;
  assign sel1368 = orl1327 ? 3'h0 : io_in_branch_type;
  assign sel1371 = orl1327 ? 20'h0 : io_in_upper_immed;
  assign sel1374 = orl1327 ? 12'h0 : io_in_csr_address;
  assign sel1377 = orl1327 ? 1'h0 : io_in_is_csr;
  assign sel1380 = orl1327 ? 32'h0 : io_in_csr_mask;
  assign sel1383 = orl1327 ? 1'h0 : io_in_jal;
  assign sel1386 = orl1327 ? 32'h0 : io_in_jal_offset;
  assign sel1389 = orl1327 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1287;
  assign io_out_is_csr = reg1293;
  assign io_out_csr_mask = reg1299;
  assign io_out_rd = reg1192;
  assign io_out_rs1 = reg1201;
  assign io_out_rd1 = reg1208;
  assign io_out_rs2 = reg1214;
  assign io_out_rd2 = reg1220;
  assign io_out_alu_op = reg1227;
  assign io_out_wb = reg1234;
  assign io_out_rs2_src = reg1247;
  assign io_out_itype_immed = reg1253;
  assign io_out_mem_read = reg1260;
  assign io_out_mem_write = reg1266;
  assign io_out_branch_type = reg1273;
  assign io_out_upper_immed = reg1280;
  assign io_out_curr_PC = reg1305;
  assign io_out_jal = reg1311;
  assign io_out_jal_offset = reg1317;
  assign io_out_PC_next = reg1240;

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
  wire eq1596, lt1626, lt1635, ge1665, ne1700, sel1702;
  wire[31:0] sel1598, proxy1603, add1606, add1609, sub1614, shl1618, sel1628, sel1637, xorl1642, shr1646, shr1651, orl1656, andl1661, add1674, orl1680, sub1684, andl1687, sel1692;
  reg[31:0] sel1691, sel1693;

  assign eq1596 = io_in_rs2_src == 1'h1;
  assign sel1598 = eq1596 ? io_in_itype_immed : io_in_rd2;
  assign proxy1603 = {io_in_upper_immed, 12'h0};
  assign add1606 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1609 = $signed(io_in_rd1) + $signed(sel1598);
  assign sub1614 = $signed(io_in_rd1) - $signed(sel1598);
  assign shl1618 = io_in_rd1 << sel1598;
  assign lt1626 = $signed(io_in_rd1) < $signed(sel1598);
  assign sel1628 = lt1626 ? 32'h1 : 32'h0;
  assign lt1635 = io_in_rd1 < sel1598;
  assign sel1637 = lt1635 ? 32'h1 : 32'h0;
  assign xorl1642 = io_in_rd1 ^ sel1598;
  assign shr1646 = io_in_rd1 >> sel1598;
  assign shr1651 = $signed(io_in_rd1) >> sel1598;
  assign orl1656 = io_in_rd1 | sel1598;
  assign andl1661 = sel1598 & io_in_rd1;
  assign ge1665 = io_in_rd1 >= sel1598;
  assign add1674 = $signed(io_in_curr_PC) + $signed(proxy1603);
  assign orl1680 = io_in_csr_data | io_in_csr_mask;
  assign sub1684 = 32'hffffffff - io_in_csr_mask;
  assign andl1687 = io_in_csr_data & sub1684;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1691 = 32'h7b;
      4'h1: sel1691 = 32'h7b;
      4'h2: sel1691 = 32'h7b;
      4'h3: sel1691 = 32'h7b;
      4'h4: sel1691 = 32'h7b;
      4'h5: sel1691 = 32'h7b;
      4'h6: sel1691 = 32'h7b;
      4'h7: sel1691 = 32'h7b;
      4'h8: sel1691 = 32'h7b;
      4'h9: sel1691 = 32'h7b;
      4'ha: sel1691 = 32'h7b;
      4'hb: sel1691 = 32'h7b;
      4'hc: sel1691 = 32'h7b;
      4'hd: sel1691 = io_in_csr_mask;
      4'he: sel1691 = orl1680;
      4'hf: sel1691 = andl1687;
      default: sel1691 = 32'h7b;
    endcase
  end
  assign sel1692 = ge1665 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1693 = add1609;
      4'h1: sel1693 = sub1614;
      4'h2: sel1693 = shl1618;
      4'h3: sel1693 = sel1628;
      4'h4: sel1693 = sel1637;
      4'h5: sel1693 = xorl1642;
      4'h6: sel1693 = shr1646;
      4'h7: sel1693 = shr1651;
      4'h8: sel1693 = orl1656;
      4'h9: sel1693 = andl1661;
      4'ha: sel1693 = sel1692;
      4'hb: sel1693 = proxy1603;
      4'hc: sel1693 = add1674;
      4'hd: sel1693 = io_in_csr_data;
      4'he: sel1693 = io_in_csr_data;
      4'hf: sel1693 = io_in_csr_data;
      default: sel1693 = 32'h0;
    endcase
  end
  assign ne1700 = io_in_branch_type != 3'h0;
  assign sel1702 = ne1700 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1691;
  assign io_out_alu_result = sel1693;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1606;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = sel1702;
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
  reg[31:0] reg1889, reg1911, reg1923, reg1936, reg1969, reg1975, reg1981;
  reg[4:0] reg1899, reg1905, reg1917;
  reg[1:0] reg1930;
  reg[2:0] reg1943, reg1949, reg1987;
  reg[11:0] reg1956;
  reg reg1963;

  always @ (posedge clk) begin
    if (reset)
      reg1889 <= 32'h0;
    else
      reg1889 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1899 <= 5'h0;
    else
      reg1899 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1905 <= 5'h0;
    else
      reg1905 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1911 <= 32'h0;
    else
      reg1911 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1917 <= 5'h0;
    else
      reg1917 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1923 <= 32'h0;
    else
      reg1923 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1930 <= 2'h0;
    else
      reg1930 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1936 <= 32'h0;
    else
      reg1936 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1943 <= 3'h0;
    else
      reg1943 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1949 <= 3'h0;
    else
      reg1949 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1956 <= 12'h0;
    else
      reg1956 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1963 <= 1'h0;
    else
      reg1963 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1969 <= 32'h0;
    else
      reg1969 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1975 <= 32'h0;
    else
      reg1975 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1981 <= 32'h0;
    else
      reg1981 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1987 <= 3'h0;
    else
      reg1987 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg1956;
  assign io_out_is_csr = reg1963;
  assign io_out_csr_result = reg1969;
  assign io_out_alu_result = reg1889;
  assign io_out_rd = reg1899;
  assign io_out_wb = reg1930;
  assign io_out_rs1 = reg1905;
  assign io_out_rd1 = reg1911;
  assign io_out_rd2 = reg1923;
  assign io_out_rs2 = reg1917;
  assign io_out_mem_read = reg1943;
  assign io_out_mem_write = reg1949;
  assign io_out_curr_PC = reg1975;
  assign io_out_branch_offset = reg1981;
  assign io_out_branch_type = reg1987;
  assign io_out_PC_next = reg1936;

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
  wire lt2192, lt2195, orl2197, eq2205, eq2219, eq2223, andl2225, eq2246, eq2250, andl2252, orl2255, proxy2272, eq2273, proxy2290, eq2291;
  wire[1:0] sel2231, sel2235, sel2239;
  wire[7:0] proxy2264;
  wire[31:0] pad2265, proxy2268, sel2275, pad2283, proxy2286, sel2293;
  wire[15:0] proxy2282;
  reg[31:0] sel2309;

  assign lt2192 = io_in_mem_write < 3'h7;
  assign lt2195 = io_in_mem_read < 3'h7;
  assign orl2197 = lt2195 | lt2192;
  assign eq2205 = io_in_mem_write == 3'h2;
  assign eq2219 = io_in_mem_write == 3'h7;
  assign eq2223 = io_in_mem_read == 3'h7;
  assign andl2225 = eq2223 & eq2219;
  assign sel2231 = andl2225 ? 2'h0 : 2'h3;
  assign sel2235 = eq2205 ? 2'h2 : sel2231;
  assign sel2239 = lt2195 ? 2'h1 : sel2235;
  assign eq2246 = eq2205 == 1'h0;
  assign eq2250 = andl2225 == 1'h0;
  assign andl2252 = eq2250 & eq2246;
  assign orl2255 = lt2195 | andl2252;
  assign proxy2264 = io_DBUS_in_data_data[7:0];
  assign pad2265 = {{24{1'b0}}, proxy2264};
  assign proxy2268 = {24'hffffff, proxy2264};
  assign proxy2272 = proxy2264[7];
  assign eq2273 = proxy2272 == 1'h1;
  assign sel2275 = eq2273 ? proxy2268 : pad2265;
  assign proxy2282 = io_DBUS_in_data_data[15:0];
  assign pad2283 = {{16{1'b0}}, proxy2282};
  assign proxy2286 = {16'hffff, proxy2282};
  assign proxy2290 = proxy2282[15];
  assign eq2291 = proxy2290 == 1'h1;
  assign sel2293 = eq2291 ? proxy2286 : pad2283;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2309 = sel2275;
      3'h1: sel2309 = sel2293;
      3'h2: sel2309 = io_DBUS_in_data_data;
      3'h4: sel2309 = pad2265;
      3'h5: sel2309 = pad2283;
      default: sel2309 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2255;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2192;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2197;
  assign io_DBUS_out_control_data = sel2239;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2309;

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
  wire[31:0] bindin2316, bindout2325, bindout2334, bindin2352, bindin2361, bindout2364, shl2367, add2369;
  wire bindin2319, bindout2322, bindout2328, bindin2331, bindout2337, bindin2340, bindout2346, bindin2349, eq2379, sel2381, sel2390, eq2397, sel2399, sel2408, eq2436, sel2438;
  wire[1:0] bindout2343;
  wire[2:0] bindin2355, bindin2358;
  reg sel2431;

  Cache __module10__(.io_DBUS_in_data_data(bindin2316), .io_DBUS_in_data_valid(bindin2319), .io_DBUS_out_data_ready(bindin2331), .io_DBUS_out_address_ready(bindin2340), .io_DBUS_out_control_ready(bindin2349), .io_in_address(bindin2352), .io_in_mem_read(bindin2355), .io_in_mem_write(bindin2358), .io_in_data(bindin2361), .io_DBUS_in_data_ready(bindout2322), .io_DBUS_out_data_data(bindout2325), .io_DBUS_out_data_valid(bindout2328), .io_DBUS_out_address_data(bindout2334), .io_DBUS_out_address_valid(bindout2337), .io_DBUS_out_control_data(bindout2343), .io_DBUS_out_control_valid(bindout2346), .io_out_data(bindout2364));
  assign bindin2316 = io_DBUS_in_data_data;
  assign bindin2319 = io_DBUS_in_data_valid;
  assign bindin2331 = io_DBUS_out_data_ready;
  assign bindin2340 = io_DBUS_out_address_ready;
  assign bindin2349 = io_DBUS_out_control_ready;
  assign bindin2352 = io_in_alu_result;
  assign bindin2355 = io_in_mem_read;
  assign bindin2358 = io_in_mem_write;
  assign bindin2361 = io_in_rd2;
  assign shl2367 = $signed(io_in_branch_offset) << 32'h1;
  assign add2369 = $signed(io_in_curr_PC) + $signed(shl2367);
  assign eq2379 = io_in_alu_result == 32'h0;
  assign sel2381 = eq2379 ? 1'h1 : 1'h0;
  assign sel2390 = eq2379 ? 1'h0 : 1'h1;
  assign eq2397 = io_in_alu_result[31] == 1'h0;
  assign sel2399 = eq2397 ? 1'h0 : 1'h1;
  assign sel2408 = eq2397 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2431 = sel2381;
      3'h2: sel2431 = sel2390;
      3'h3: sel2431 = sel2399;
      3'h4: sel2431 = sel2408;
      3'h5: sel2431 = sel2399;
      3'h6: sel2431 = sel2408;
      3'h0: sel2431 = 1'h0;
      default: sel2431 = 1'h0;
    endcase
  end
  assign eq2436 = io_in_branch_type == 3'h0;
  assign sel2438 = eq2436 ? 1'h0 : 1'h1;

  assign io_DBUS_in_data_ready = bindout2322;
  assign io_DBUS_out_data_data = bindout2325;
  assign io_DBUS_out_data_valid = bindout2328;
  assign io_DBUS_out_address_data = bindout2334;
  assign io_DBUS_out_address_valid = bindout2337;
  assign io_DBUS_out_control_data = bindout2343;
  assign io_DBUS_out_control_valid = bindout2346;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2364;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2431;
  assign io_out_branch_dest = add2369;
  assign io_out_branch_stall = sel2438;
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
  reg[31:0] reg2588, reg2597, reg2629, reg2642;
  reg[4:0] reg2604, reg2610, reg2616;
  reg[1:0] reg2623;
  reg reg2636;

  always @ (posedge clk) begin
    if (reset)
      reg2588 <= 32'h0;
    else
      reg2588 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2597 <= 32'h0;
    else
      reg2597 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2604 <= 5'h0;
    else
      reg2604 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2610 <= 5'h0;
    else
      reg2610 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2616 <= 5'h0;
    else
      reg2616 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2623 <= 2'h0;
    else
      reg2623 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2629 <= 32'h0;
    else
      reg2629 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2636 <= 1'h0;
    else
      reg2636 <= io_in_branch_dir;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2642 <= 32'h0;
    else
      reg2642 <= io_in_branch_dest;
  end

  assign io_out_alu_result = reg2588;
  assign io_out_mem_result = reg2597;
  assign io_out_rd = reg2604;
  assign io_out_wb = reg2623;
  assign io_out_rs1 = reg2610;
  assign io_out_rs2 = reg2616;
  assign io_out_branch_dir = reg2636;
  assign io_out_branch_dest = reg2642;
  assign io_out_PC_next = reg2629;

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
  wire eq2720, eq2725;
  wire[31:0] sel2727, sel2729;

  assign eq2720 = io_in_wb == 2'h3;
  assign eq2725 = io_in_wb == 2'h1;
  assign sel2727 = eq2725 ? io_in_alu_result : io_in_mem_result;
  assign sel2729 = eq2720 ? io_in_PC_next : sel2727;

  assign io_out_write_data = sel2729;
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
  wire eq2826, eq2830, ne2835, ne2840, eq2843, andl2845, andl2847, eq2852, ne2856, eq2863, andl2865, andl2867, andl2869, eq2873, ne2881, eq2888, andl2890, andl2892, andl2894, andl2896, orl2899, orl2901, ne2909, eq2912, andl2914, andl2916, eq2920, eq2931, andl2933, andl2935, andl2937, eq2941, eq2956, andl2958, andl2960, andl2962, andl2964, orl2967, orl2969, eq2972, andl2974, eq2978, eq2981, andl2983, andl2985, orl2988, orl2995, orl2997, orl2999;

  assign eq2826 = io_in_execute_is_csr == 1'h1;
  assign eq2830 = io_in_memory_is_csr == 1'h1;
  assign ne2835 = io_in_execute_wb != 2'h0;
  assign ne2840 = io_in_decode_src1 != 5'h0;
  assign eq2843 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2845 = eq2843 & ne2840;
  assign andl2847 = andl2845 & ne2835;
  assign eq2852 = andl2847 == 1'h0;
  assign ne2856 = io_in_memory_wb != 2'h0;
  assign eq2863 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2865 = eq2863 & ne2840;
  assign andl2867 = andl2865 & ne2856;
  assign andl2869 = andl2867 & eq2852;
  assign eq2873 = andl2869 == 1'h0;
  assign ne2881 = io_in_writeback_wb != 2'h0;
  assign eq2888 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2890 = eq2888 & ne2840;
  assign andl2892 = andl2890 & ne2881;
  assign andl2894 = andl2892 & eq2852;
  assign andl2896 = andl2894 & eq2873;
  assign orl2899 = andl2847 | andl2869;
  assign orl2901 = orl2899 | andl2896;
  assign ne2909 = io_in_decode_src2 != 5'h0;
  assign eq2912 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2914 = eq2912 & ne2909;
  assign andl2916 = andl2914 & ne2835;
  assign eq2920 = andl2916 == 1'h0;
  assign eq2931 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2933 = eq2931 & ne2909;
  assign andl2935 = andl2933 & ne2856;
  assign andl2937 = andl2935 & eq2920;
  assign eq2941 = andl2937 == 1'h0;
  assign eq2956 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2958 = eq2956 & ne2909;
  assign andl2960 = andl2958 & ne2881;
  assign andl2962 = andl2960 & eq2920;
  assign andl2964 = andl2962 & eq2941;
  assign orl2967 = andl2916 | andl2937;
  assign orl2969 = orl2967 | andl2964;
  assign eq2972 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2974 = eq2972 & eq2826;
  assign eq2978 = andl2974 == 1'h0;
  assign eq2981 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2983 = eq2981 & eq2830;
  assign andl2985 = andl2983 & eq2978;
  assign orl2988 = andl2974 | andl2985;
  assign orl2995 = orl2901 | andl2916;
  assign orl2997 = orl2995 | andl2937;
  assign orl2999 = orl2997 | andl2964;

  assign io_out_src1_fwd = orl2901;
  assign io_out_src2_fwd = orl2969;
  assign io_out_csr_fwd = orl2988;
  assign io_out_fwd_stall = orl2999;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3094 [0:1];
  wire[31:0] mrport3096, sel3100;

  initial begin
    mem3094[0] = 32'hdeadbeef;
    mem3094[1] = 32'hdeadbeef;
  end
  assign mrport3096 = mem3094[io_INTERRUPT_in_interrupt_id_data];
  assign sel3100 = io_INTERRUPT_in_interrupt_id_valid ? mrport3096 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3100;

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
  reg[3:0] reg3168, sel3258;
  wire eq3176, andl3261, eq3265, andl3269, eq3273, andl3277;
  wire[3:0] sel3182, sel3187, sel3193, sel3199, sel3209, sel3214, sel3218, sel3227, sel3233, sel3243, sel3248, sel3252, sel3259, sel3275, sel3276, sel3278;

  always @ (posedge clk) begin
    if (reset)
      reg3168 <= 4'h0;
    else
      reg3168 <= sel3278;
  end
  assign eq3176 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3182 = eq3176 ? 4'h0 : 4'h1;
  assign sel3187 = eq3176 ? 4'h2 : 4'h1;
  assign sel3193 = eq3176 ? 4'h9 : 4'h3;
  assign sel3199 = eq3176 ? 4'h5 : 4'h4;
  assign sel3209 = eq3176 ? 4'h8 : 4'h6;
  assign sel3214 = eq3176 ? 4'h7 : 4'h6;
  assign sel3218 = eq3176 ? 4'h4 : 4'h8;
  assign sel3227 = eq3176 ? 4'h0 : 4'ha;
  assign sel3233 = eq3176 ? 4'hc : 4'hb;
  assign sel3243 = eq3176 ? 4'hf : 4'hd;
  assign sel3248 = eq3176 ? 4'he : 4'hd;
  assign sel3252 = eq3176 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3168)
      4'h0: sel3258 = sel3182;
      4'h1: sel3258 = sel3187;
      4'h2: sel3258 = sel3193;
      4'h3: sel3258 = sel3199;
      4'h4: sel3258 = sel3199;
      4'h5: sel3258 = sel3209;
      4'h6: sel3258 = sel3214;
      4'h7: sel3258 = sel3218;
      4'h8: sel3258 = sel3187;
      4'h9: sel3258 = sel3227;
      4'ha: sel3258 = sel3233;
      4'hb: sel3258 = sel3233;
      4'hc: sel3258 = sel3243;
      4'hd: sel3258 = sel3248;
      4'he: sel3258 = sel3252;
      4'hf: sel3258 = sel3187;
      default: sel3258 = reg3168;
    endcase
  end
  assign sel3259 = io_JTAG_TAP_in_mode_select_valid ? sel3258 : 4'h0;
  assign andl3261 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3265 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3269 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3273 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3275 = eq3265 ? 4'h0 : reg3168;
  assign sel3276 = andl3277 ? sel3259 : reg3168;
  assign andl3277 = andl3269 & eq3273;
  assign sel3278 = andl3261 ? sel3275 : sel3276;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3168;

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
  wire bindin3284, bindin3286, bindin3287, bindin3290, bindout3293, bindin3296, bindin3299, bindout3302, bindin3305, bindin3308, bindout3311, eq3348, eq3357, eq3362, eq3438, andl3439, sel3441, sel3448;
  wire[3:0] bindout3314;
  reg[31:0] reg3322, reg3329, reg3336, reg3343, sel3440;
  wire[31:0] sel3365, sel3367, shr3374, proxy3379, sel3434, sel3435, sel3436, sel3437, sel3447;
  wire[30:0] proxy3377;
  reg sel3446, sel3453;

  assign bindin3284 = clk;
  assign bindin3286 = reset;
  TAP __module16__(.clk(bindin3284), .reset(bindin3286), .io_JTAG_TAP_in_mode_select_data(bindin3287), .io_JTAG_TAP_in_mode_select_valid(bindin3290), .io_JTAG_TAP_in_clock_data(bindin3296), .io_JTAG_TAP_in_clock_valid(bindin3299), .io_JTAG_TAP_in_reset_data(bindin3305), .io_JTAG_TAP_in_reset_valid(bindin3308), .io_JTAG_TAP_in_mode_select_ready(bindout3293), .io_JTAG_TAP_in_clock_ready(bindout3302), .io_JTAG_TAP_in_reset_ready(bindout3311), .io_out_curr_state(bindout3314));
  assign bindin3287 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3290 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3296 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3299 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3305 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3308 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3322 <= 32'h0;
    else
      reg3322 <= sel3447;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3329 <= 32'h1234;
    else
      reg3329 <= sel3436;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3336 <= 32'h5678;
    else
      reg3336 <= sel3437;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3343 <= 32'h0;
    else
      reg3343 <= sel3440;
  end
  assign eq3348 = reg3322 == 32'h0;
  assign eq3357 = reg3322 == 32'h1;
  assign eq3362 = reg3322 == 32'h2;
  assign sel3365 = eq3362 ? reg3329 : 32'hdeadbeef;
  assign sel3367 = eq3357 ? reg3336 : sel3365;
  assign shr3374 = reg3343 >> 32'h1;
  assign proxy3377 = shr3374[30:0];
  assign proxy3379 = {io_JTAG_in_data_data, proxy3377};
  assign sel3434 = eq3362 ? reg3343 : reg3329;
  assign sel3435 = eq3357 ? reg3329 : sel3434;
  assign sel3436 = (bindout3314 == 4'h8) ? sel3435 : reg3329;
  assign sel3437 = andl3439 ? reg3343 : reg3336;
  assign eq3438 = bindout3314 == 4'h8;
  assign andl3439 = eq3438 & eq3357;
  always @(*) begin
    case (bindout3314)
      4'h3: sel3440 = sel3367;
      4'h4: sel3440 = proxy3379;
      4'ha: sel3440 = reg3322;
      4'hb: sel3440 = proxy3379;
      default: sel3440 = reg3343;
    endcase
  end
  assign sel3441 = eq3348 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3314)
      4'h3: sel3446 = sel3441;
      4'h4: sel3446 = 1'h1;
      4'h8: sel3446 = sel3441;
      4'ha: sel3446 = sel3441;
      4'hb: sel3446 = 1'h1;
      4'hf: sel3446 = sel3441;
      default: sel3446 = sel3441;
    endcase
  end
  assign sel3447 = (bindout3314 == 4'hf) ? reg3343 : reg3322;
  assign sel3448 = eq3348 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3314)
      4'h3: sel3453 = sel3448;
      4'h4: sel3453 = reg3343[0];
      4'h8: sel3453 = sel3448;
      4'ha: sel3453 = sel3448;
      4'hb: sel3453 = reg3343[0];
      4'hf: sel3453 = sel3448;
      default: sel3453 = sel3448;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3293;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3302;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3311;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3453;
  assign io_JTAG_out_data_valid = sel3446;

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
  reg[11:0] mem3509 [0:4095];
  reg[11:0] reg3518;
  wire[11:0] proxy3528, mrport3530;
  wire[31:0] pad3532;

  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem3509[io_in_mem_csr_address] <= proxy3528;
    end
  end
  assign mrport3530 = mem3509[reg3518];
  always @ (posedge clk) begin
    if (reset)
      reg3518 <= 12'h0;
    else
      reg3518 <= io_in_decode_csr_address;
  end
  assign proxy3528 = io_in_mem_csr_result[11:0];
  assign pad3532 = {{20{1'b0}}, mrport3530};

  assign io_out_decode_csr_data = pad3532;

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
  output wire io_out_branch_stall
);
  wire bindin230, bindin232, bindin236, bindout239, bindout245, bindin248, bindin251, bindin257, bindin260, bindin263, bindin266, bindin272, bindin336, bindin337, bindin344, bindin347, bindin350, bindin1027, bindin1034, bindout1049, bindout1076, bindout1091, bindout1094, bindin1394, bindin1395, bindin1417, bindin1435, bindin1438, bindin1447, bindin1456, bindout1465, bindout1492, bindout1513, bindin1728, bindin1752, bindin1761, bindout1773, bindout1806, bindout1815, bindin1992, bindin1993, bindin2027, bindout2045, bindin2446, bindout2449, bindout2455, bindin2458, bindout2464, bindin2467, bindout2473, bindin2476, bindout2536, bindout2542, bindin2647, bindin2648, bindin2670, bindout2694, bindin3025, bindin3049, bindout3082, bindin3104, bindin3107, bindout3110, bindout3113, bindin3457, bindin3458, bindin3459, bindin3462, bindout3465, bindin3468, bindin3471, bindout3474, bindin3477, bindin3480, bindout3483, bindin3486, bindin3489, bindout3492, bindout3495, bindout3498, bindin3501, bindin3537, bindin3538, bindin3545, orl3553, orl3555, eq3560, orl3562, orl3565;
  wire[31:0] bindin233, bindout242, bindin254, bindin269, bindin275, bindout278, bindout281, bindin338, bindin341, bindout353, bindout356, bindin1028, bindin1031, bindin1037, bindout1052, bindout1061, bindout1067, bindout1079, bindout1097, bindout1103, bindin1402, bindin1408, bindin1420, bindin1429, bindin1450, bindin1453, bindin1459, bindout1468, bindout1477, bindout1483, bindout1495, bindout1510, bindout1516, bindout1519, bindin1713, bindin1719, bindin1731, bindin1740, bindin1755, bindin1758, bindin1764, bindin1767, bindout1776, bindout1779, bindout1791, bindout1797, bindout1809, bindout1812, bindout1818, bindin1994, bindin2006, bindin2012, bindin2021, bindin2030, bindin2033, bindin2036, bindout2048, bindout2051, bindout2063, bindout2066, bindout2078, bindout2081, bindout2087, bindin2443, bindout2452, bindout2461, bindin2479, bindin2497, bindin2503, bindin2506, bindin2509, bindin2512, bindout2518, bindout2521, bindout2539, bindout2545, bindin2649, bindin2652, bindin2667, bindin2673, bindout2676, bindout2679, bindout2697, bindout2700, bindin2734, bindin2737, bindin2752, bindout2755, bindin3019, bindin3022, bindin3031, bindin3040, bindin3043, bindin3046, bindin3055, bindin3064, bindin3067, bindin3070, bindout3116, bindin3548, bindout3551;
  wire[4:0] bindin1040, bindout1055, bindout1058, bindout1064, bindin1396, bindin1399, bindin1405, bindout1471, bindout1474, bindout1480, bindin1707, bindin1710, bindin1716, bindout1782, bindout1788, bindout1794, bindin1997, bindin2003, bindin2009, bindout2054, bindout2060, bindout2069, bindin2488, bindin2494, bindin2500, bindout2524, bindout2530, bindout2533, bindin2655, bindin2661, bindin2664, bindout2682, bindout2688, bindout2691, bindin2740, bindin2746, bindin2749, bindout2758, bindin3004, bindin3007, bindin3013, bindin3034, bindin3058;
  wire[1:0] bindin1043, bindout1070, bindin1414, bindout1489, bindin1725, bindout1785, bindin2000, bindout2057, bindout2470, bindin2491, bindout2527, bindin2658, bindout2685, bindin2743, bindout2761, bindin3016, bindin3037, bindin3061;
  wire[11:0] bindout1046, bindin1444, bindout1462, bindin1749, bindout1770, bindin2024, bindout2042, bindin3010, bindin3028, bindin3052, bindin3539, bindin3542;
  wire[3:0] bindout1073, bindin1411, bindout1486, bindin1722;
  wire[2:0] bindout1082, bindout1085, bindout1088, bindin1423, bindin1426, bindin1432, bindout1498, bindout1501, bindout1504, bindin1734, bindin1737, bindin1743, bindout1800, bindout1803, bindin2015, bindin2018, bindin2039, bindout2072, bindout2075, bindout2084, bindin2482, bindin2485, bindin2515;
  wire[19:0] bindout1100, bindin1441, bindout1507, bindin1746;

  assign bindin230 = clk;
  assign bindin232 = reset;
  Fetch __module2__(.clk(bindin230), .reset(bindin232), .io_IBUS_in_data_data(bindin233), .io_IBUS_in_data_valid(bindin236), .io_IBUS_out_address_ready(bindin248), .io_in_branch_dir(bindin251), .io_in_branch_dest(bindin254), .io_in_branch_stall(bindin257), .io_in_fwd_stall(bindin260), .io_in_branch_stall_exe(bindin263), .io_in_jal(bindin266), .io_in_jal_dest(bindin269), .io_in_interrupt(bindin272), .io_in_interrupt_pc(bindin275), .io_IBUS_in_data_ready(bindout239), .io_IBUS_out_address_data(bindout242), .io_IBUS_out_address_valid(bindout245), .io_out_instruction(bindout278), .io_out_curr_PC(bindout281));
  assign bindin233 = io_IBUS_in_data_data;
  assign bindin236 = io_IBUS_in_data_valid;
  assign bindin248 = io_IBUS_out_address_ready;
  assign bindin251 = bindout2694;
  assign bindin254 = bindout2697;
  assign bindin257 = bindout1091;
  assign bindin260 = bindout3082;
  assign bindin263 = orl3565;
  assign bindin266 = bindout1806;
  assign bindin269 = bindout1809;
  assign bindin272 = bindout3113;
  assign bindin275 = bindout3116;
  assign bindin336 = clk;
  assign bindin337 = reset;
  F_D_Register __module3__(.clk(bindin336), .reset(bindin337), .io_in_instruction(bindin338), .io_in_curr_PC(bindin341), .io_in_branch_stall(bindin344), .io_in_branch_stall_exe(bindin347), .io_in_fwd_stall(bindin350), .io_out_instruction(bindout353), .io_out_curr_PC(bindout356));
  assign bindin338 = bindout278;
  assign bindin341 = bindout281;
  assign bindin344 = bindout1091;
  assign bindin347 = orl3565;
  assign bindin350 = bindout3082;
  assign bindin1027 = clk;
  Decode __module4__(.clk(bindin1027), .io_in_instruction(bindin1028), .io_in_curr_PC(bindin1031), .io_in_stall(bindin1034), .io_in_write_data(bindin1037), .io_in_rd(bindin1040), .io_in_wb(bindin1043), .io_out_csr_address(bindout1046), .io_out_is_csr(bindout1049), .io_out_csr_mask(bindout1052), .io_out_rd(bindout1055), .io_out_rs1(bindout1058), .io_out_rd1(bindout1061), .io_out_rs2(bindout1064), .io_out_rd2(bindout1067), .io_out_wb(bindout1070), .io_out_alu_op(bindout1073), .io_out_rs2_src(bindout1076), .io_out_itype_immed(bindout1079), .io_out_mem_read(bindout1082), .io_out_mem_write(bindout1085), .io_out_branch_type(bindout1088), .io_out_branch_stall(bindout1091), .io_out_jal(bindout1094), .io_out_jal_offset(bindout1097), .io_out_upper_immed(bindout1100), .io_out_PC_next(bindout1103));
  assign bindin1028 = bindout353;
  assign bindin1031 = bindout356;
  assign bindin1034 = orl3562;
  assign bindin1037 = bindout2755;
  assign bindin1040 = bindout2758;
  assign bindin1043 = bindout2761;
  assign bindin1394 = clk;
  assign bindin1395 = reset;
  D_E_Register __module6__(.clk(bindin1394), .reset(bindin1395), .io_in_rd(bindin1396), .io_in_rs1(bindin1399), .io_in_rd1(bindin1402), .io_in_rs2(bindin1405), .io_in_rd2(bindin1408), .io_in_alu_op(bindin1411), .io_in_wb(bindin1414), .io_in_rs2_src(bindin1417), .io_in_itype_immed(bindin1420), .io_in_mem_read(bindin1423), .io_in_mem_write(bindin1426), .io_in_PC_next(bindin1429), .io_in_branch_type(bindin1432), .io_in_fwd_stall(bindin1435), .io_in_branch_stall(bindin1438), .io_in_upper_immed(bindin1441), .io_in_csr_address(bindin1444), .io_in_is_csr(bindin1447), .io_in_csr_mask(bindin1450), .io_in_curr_PC(bindin1453), .io_in_jal(bindin1456), .io_in_jal_offset(bindin1459), .io_out_csr_address(bindout1462), .io_out_is_csr(bindout1465), .io_out_csr_mask(bindout1468), .io_out_rd(bindout1471), .io_out_rs1(bindout1474), .io_out_rd1(bindout1477), .io_out_rs2(bindout1480), .io_out_rd2(bindout1483), .io_out_alu_op(bindout1486), .io_out_wb(bindout1489), .io_out_rs2_src(bindout1492), .io_out_itype_immed(bindout1495), .io_out_mem_read(bindout1498), .io_out_mem_write(bindout1501), .io_out_branch_type(bindout1504), .io_out_upper_immed(bindout1507), .io_out_curr_PC(bindout1510), .io_out_jal(bindout1513), .io_out_jal_offset(bindout1516), .io_out_PC_next(bindout1519));
  assign bindin1396 = bindout1055;
  assign bindin1399 = bindout1058;
  assign bindin1402 = bindout1061;
  assign bindin1405 = bindout1064;
  assign bindin1408 = bindout1067;
  assign bindin1411 = bindout1073;
  assign bindin1414 = bindout1070;
  assign bindin1417 = bindout1076;
  assign bindin1420 = bindout1079;
  assign bindin1423 = bindout1082;
  assign bindin1426 = bindout1085;
  assign bindin1429 = bindout1103;
  assign bindin1432 = bindout1088;
  assign bindin1435 = bindout3082;
  assign bindin1438 = orl3565;
  assign bindin1441 = bindout1100;
  assign bindin1444 = bindout1046;
  assign bindin1447 = bindout1049;
  assign bindin1450 = bindout1052;
  assign bindin1453 = bindout356;
  assign bindin1456 = bindout1094;
  assign bindin1459 = bindout1097;
  Execute __module7__(.io_in_rd(bindin1707), .io_in_rs1(bindin1710), .io_in_rd1(bindin1713), .io_in_rs2(bindin1716), .io_in_rd2(bindin1719), .io_in_alu_op(bindin1722), .io_in_wb(bindin1725), .io_in_rs2_src(bindin1728), .io_in_itype_immed(bindin1731), .io_in_mem_read(bindin1734), .io_in_mem_write(bindin1737), .io_in_PC_next(bindin1740), .io_in_branch_type(bindin1743), .io_in_upper_immed(bindin1746), .io_in_csr_address(bindin1749), .io_in_is_csr(bindin1752), .io_in_csr_data(bindin1755), .io_in_csr_mask(bindin1758), .io_in_jal(bindin1761), .io_in_jal_offset(bindin1764), .io_in_curr_PC(bindin1767), .io_out_csr_address(bindout1770), .io_out_is_csr(bindout1773), .io_out_csr_result(bindout1776), .io_out_alu_result(bindout1779), .io_out_rd(bindout1782), .io_out_wb(bindout1785), .io_out_rs1(bindout1788), .io_out_rd1(bindout1791), .io_out_rs2(bindout1794), .io_out_rd2(bindout1797), .io_out_mem_read(bindout1800), .io_out_mem_write(bindout1803), .io_out_jal(bindout1806), .io_out_jal_dest(bindout1809), .io_out_branch_offset(bindout1812), .io_out_branch_stall(bindout1815), .io_out_PC_next(bindout1818));
  assign bindin1707 = bindout1471;
  assign bindin1710 = bindout1474;
  assign bindin1713 = bindout1477;
  assign bindin1716 = bindout1480;
  assign bindin1719 = bindout1483;
  assign bindin1722 = bindout1486;
  assign bindin1725 = bindout1489;
  assign bindin1728 = bindout1492;
  assign bindin1731 = bindout1495;
  assign bindin1734 = bindout1498;
  assign bindin1737 = bindout1501;
  assign bindin1740 = bindout1519;
  assign bindin1743 = bindout1504;
  assign bindin1746 = bindout1507;
  assign bindin1749 = bindout1462;
  assign bindin1752 = bindout1465;
  assign bindin1755 = bindout3551;
  assign bindin1758 = bindout1468;
  assign bindin1761 = bindout1513;
  assign bindin1764 = bindout1516;
  assign bindin1767 = bindout1510;
  assign bindin1992 = clk;
  assign bindin1993 = reset;
  E_M_Register __module8__(.clk(bindin1992), .reset(bindin1993), .io_in_alu_result(bindin1994), .io_in_rd(bindin1997), .io_in_wb(bindin2000), .io_in_rs1(bindin2003), .io_in_rd1(bindin2006), .io_in_rs2(bindin2009), .io_in_rd2(bindin2012), .io_in_mem_read(bindin2015), .io_in_mem_write(bindin2018), .io_in_PC_next(bindin2021), .io_in_csr_address(bindin2024), .io_in_is_csr(bindin2027), .io_in_csr_result(bindin2030), .io_in_curr_PC(bindin2033), .io_in_branch_offset(bindin2036), .io_in_branch_type(bindin2039), .io_out_csr_address(bindout2042), .io_out_is_csr(bindout2045), .io_out_csr_result(bindout2048), .io_out_alu_result(bindout2051), .io_out_rd(bindout2054), .io_out_wb(bindout2057), .io_out_rs1(bindout2060), .io_out_rd1(bindout2063), .io_out_rd2(bindout2066), .io_out_rs2(bindout2069), .io_out_mem_read(bindout2072), .io_out_mem_write(bindout2075), .io_out_curr_PC(bindout2078), .io_out_branch_offset(bindout2081), .io_out_branch_type(bindout2084), .io_out_PC_next(bindout2087));
  assign bindin1994 = bindout1779;
  assign bindin1997 = bindout1782;
  assign bindin2000 = bindout1785;
  assign bindin2003 = bindout1788;
  assign bindin2006 = bindout1791;
  assign bindin2009 = bindout1794;
  assign bindin2012 = bindout1797;
  assign bindin2015 = bindout1800;
  assign bindin2018 = bindout1803;
  assign bindin2021 = bindout1818;
  assign bindin2024 = bindout1770;
  assign bindin2027 = bindout1773;
  assign bindin2030 = bindout1776;
  assign bindin2033 = bindout1510;
  assign bindin2036 = bindout1812;
  assign bindin2039 = bindout1504;
  Memory __module9__(.io_DBUS_in_data_data(bindin2443), .io_DBUS_in_data_valid(bindin2446), .io_DBUS_out_data_ready(bindin2458), .io_DBUS_out_address_ready(bindin2467), .io_DBUS_out_control_ready(bindin2476), .io_in_alu_result(bindin2479), .io_in_mem_read(bindin2482), .io_in_mem_write(bindin2485), .io_in_rd(bindin2488), .io_in_wb(bindin2491), .io_in_rs1(bindin2494), .io_in_rd1(bindin2497), .io_in_rs2(bindin2500), .io_in_rd2(bindin2503), .io_in_PC_next(bindin2506), .io_in_curr_PC(bindin2509), .io_in_branch_offset(bindin2512), .io_in_branch_type(bindin2515), .io_DBUS_in_data_ready(bindout2449), .io_DBUS_out_data_data(bindout2452), .io_DBUS_out_data_valid(bindout2455), .io_DBUS_out_address_data(bindout2461), .io_DBUS_out_address_valid(bindout2464), .io_DBUS_out_control_data(bindout2470), .io_DBUS_out_control_valid(bindout2473), .io_out_alu_result(bindout2518), .io_out_mem_result(bindout2521), .io_out_rd(bindout2524), .io_out_wb(bindout2527), .io_out_rs1(bindout2530), .io_out_rs2(bindout2533), .io_out_branch_dir(bindout2536), .io_out_branch_dest(bindout2539), .io_out_branch_stall(bindout2542), .io_out_PC_next(bindout2545));
  assign bindin2443 = io_DBUS_in_data_data;
  assign bindin2446 = io_DBUS_in_data_valid;
  assign bindin2458 = io_DBUS_out_data_ready;
  assign bindin2467 = io_DBUS_out_address_ready;
  assign bindin2476 = io_DBUS_out_control_ready;
  assign bindin2479 = bindout2051;
  assign bindin2482 = bindout2072;
  assign bindin2485 = bindout2075;
  assign bindin2488 = bindout2054;
  assign bindin2491 = bindout2057;
  assign bindin2494 = bindout2060;
  assign bindin2497 = bindout2063;
  assign bindin2500 = bindout2069;
  assign bindin2503 = bindout2066;
  assign bindin2506 = bindout2087;
  assign bindin2509 = bindout2078;
  assign bindin2512 = bindout2081;
  assign bindin2515 = bindout2084;
  assign bindin2647 = clk;
  assign bindin2648 = reset;
  M_W_Register __module11__(.clk(bindin2647), .reset(bindin2648), .io_in_alu_result(bindin2649), .io_in_mem_result(bindin2652), .io_in_rd(bindin2655), .io_in_wb(bindin2658), .io_in_rs1(bindin2661), .io_in_rs2(bindin2664), .io_in_PC_next(bindin2667), .io_in_branch_dir(bindin2670), .io_in_branch_dest(bindin2673), .io_out_alu_result(bindout2676), .io_out_mem_result(bindout2679), .io_out_rd(bindout2682), .io_out_wb(bindout2685), .io_out_rs1(bindout2688), .io_out_rs2(bindout2691), .io_out_branch_dir(bindout2694), .io_out_branch_dest(bindout2697), .io_out_PC_next(bindout2700));
  assign bindin2649 = bindout2518;
  assign bindin2652 = bindout2521;
  assign bindin2655 = bindout2524;
  assign bindin2658 = bindout2527;
  assign bindin2661 = bindout2530;
  assign bindin2664 = bindout2533;
  assign bindin2667 = bindout2545;
  assign bindin2670 = bindout2536;
  assign bindin2673 = bindout2539;
  Write_Back __module12__(.io_in_alu_result(bindin2734), .io_in_mem_result(bindin2737), .io_in_rd(bindin2740), .io_in_wb(bindin2743), .io_in_rs1(bindin2746), .io_in_rs2(bindin2749), .io_in_PC_next(bindin2752), .io_out_write_data(bindout2755), .io_out_rd(bindout2758), .io_out_wb(bindout2761));
  assign bindin2734 = bindout2676;
  assign bindin2737 = bindout2679;
  assign bindin2740 = bindout2682;
  assign bindin2743 = bindout2685;
  assign bindin2746 = bindout2688;
  assign bindin2749 = bindout2691;
  assign bindin2752 = bindout2700;
  Forwarding __module13__(.io_in_decode_src1(bindin3004), .io_in_decode_src2(bindin3007), .io_in_decode_csr_address(bindin3010), .io_in_execute_dest(bindin3013), .io_in_execute_wb(bindin3016), .io_in_execute_alu_result(bindin3019), .io_in_execute_PC_next(bindin3022), .io_in_execute_is_csr(bindin3025), .io_in_execute_csr_address(bindin3028), .io_in_execute_csr_result(bindin3031), .io_in_memory_dest(bindin3034), .io_in_memory_wb(bindin3037), .io_in_memory_alu_result(bindin3040), .io_in_memory_mem_data(bindin3043), .io_in_memory_PC_next(bindin3046), .io_in_memory_is_csr(bindin3049), .io_in_memory_csr_address(bindin3052), .io_in_memory_csr_result(bindin3055), .io_in_writeback_dest(bindin3058), .io_in_writeback_wb(bindin3061), .io_in_writeback_alu_result(bindin3064), .io_in_writeback_mem_data(bindin3067), .io_in_writeback_PC_next(bindin3070), .io_out_fwd_stall(bindout3082));
  assign bindin3004 = bindout1058;
  assign bindin3007 = bindout1064;
  assign bindin3010 = bindout1046;
  assign bindin3013 = bindout1782;
  assign bindin3016 = bindout1785;
  assign bindin3019 = bindout1779;
  assign bindin3022 = bindout1818;
  assign bindin3025 = bindout1773;
  assign bindin3028 = bindout1770;
  assign bindin3031 = bindout1776;
  assign bindin3034 = bindout2524;
  assign bindin3037 = bindout2527;
  assign bindin3040 = bindout2518;
  assign bindin3043 = bindout2521;
  assign bindin3046 = bindout2545;
  assign bindin3049 = bindout2045;
  assign bindin3052 = bindout2042;
  assign bindin3055 = bindout2048;
  assign bindin3058 = bindout2682;
  assign bindin3061 = bindout2685;
  assign bindin3064 = bindout2676;
  assign bindin3067 = bindout2679;
  assign bindin3070 = bindout2700;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3104), .io_INTERRUPT_in_interrupt_id_valid(bindin3107), .io_INTERRUPT_in_interrupt_id_ready(bindout3110), .io_out_interrupt(bindout3113), .io_out_interrupt_pc(bindout3116));
  assign bindin3104 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3107 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3457 = clk;
  assign bindin3458 = reset;
  JTAG __module15__(.clk(bindin3457), .reset(bindin3458), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3459), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3462), .io_JTAG_JTAG_TAP_in_clock_data(bindin3468), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3471), .io_JTAG_JTAG_TAP_in_reset_data(bindin3477), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3480), .io_JTAG_in_data_data(bindin3486), .io_JTAG_in_data_valid(bindin3489), .io_JTAG_out_data_ready(bindin3501), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3465), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3474), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3483), .io_JTAG_in_data_ready(bindout3492), .io_JTAG_out_data_data(bindout3495), .io_JTAG_out_data_valid(bindout3498));
  assign bindin3459 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3462 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3468 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3471 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3477 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3480 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3486 = io_jtag_in_data_data;
  assign bindin3489 = io_jtag_in_data_valid;
  assign bindin3501 = io_jtag_out_data_ready;
  assign bindin3537 = clk;
  assign bindin3538 = reset;
  CSR_Handler __module17__(.clk(bindin3537), .reset(bindin3538), .io_in_decode_csr_address(bindin3539), .io_in_mem_csr_address(bindin3542), .io_in_mem_is_csr(bindin3545), .io_in_mem_csr_result(bindin3548), .io_out_decode_csr_data(bindout3551));
  assign bindin3539 = bindout1046;
  assign bindin3542 = bindout2042;
  assign bindin3545 = bindout2045;
  assign bindin3548 = bindout2048;
  assign orl3553 = bindout1091 | bindout1815;
  assign orl3555 = orl3553 | bindout2542;
  assign eq3560 = bindout1815 == 1'h1;
  assign orl3562 = eq3560 | bindout2542;
  assign orl3565 = bindout1815 | bindout2542;

  assign io_IBUS_in_data_ready = bindout239;
  assign io_IBUS_out_address_data = bindout242;
  assign io_IBUS_out_address_valid = bindout245;
  assign io_DBUS_in_data_ready = bindout2449;
  assign io_DBUS_out_data_data = bindout2452;
  assign io_DBUS_out_data_valid = bindout2455;
  assign io_DBUS_out_address_data = bindout2461;
  assign io_DBUS_out_address_valid = bindout2464;
  assign io_DBUS_out_control_data = bindout2470;
  assign io_DBUS_out_control_valid = bindout2473;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3110;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3465;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3474;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3483;
  assign io_jtag_in_data_ready = bindout3492;
  assign io_jtag_out_data_data = bindout3495;
  assign io_jtag_out_data_valid = bindout3498;
  assign io_out_fwd_stall = bindout3082;
  assign io_out_branch_stall = orl3555;

endmodule
