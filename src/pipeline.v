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
  wire eq1596, lt1626, lt1635, ge1665, ne1700, orl1702, sel1704;
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
  assign orl1702 = ne1700 | io_in_jal;
  assign sel1704 = orl1702 ? 1'h1 : 1'h0;

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
  assign io_out_branch_stall = sel1704;
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
  reg[31:0] reg1899, reg1921, reg1933, reg1946, reg1979, reg1985, reg1991, reg2009;
  reg[4:0] reg1909, reg1915, reg1927;
  reg[1:0] reg1940;
  reg[2:0] reg1953, reg1959, reg1997;
  reg[11:0] reg1966;
  reg reg1973, reg2003;

  always @ (posedge clk) begin
    if (reset)
      reg1899 <= 32'h0;
    else
      reg1899 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1909 <= 5'h0;
    else
      reg1909 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1915 <= 5'h0;
    else
      reg1915 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1921 <= 32'h0;
    else
      reg1921 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1927 <= 5'h0;
    else
      reg1927 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1933 <= 32'h0;
    else
      reg1933 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1940 <= 2'h0;
    else
      reg1940 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1946 <= 32'h0;
    else
      reg1946 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1953 <= 3'h0;
    else
      reg1953 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1959 <= 3'h0;
    else
      reg1959 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1966 <= 12'h0;
    else
      reg1966 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1973 <= 1'h0;
    else
      reg1973 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1979 <= 32'h0;
    else
      reg1979 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1985 <= 32'h0;
    else
      reg1985 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1991 <= 32'h0;
    else
      reg1991 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1997 <= 3'h0;
    else
      reg1997 <= io_in_branch_type;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2003 <= 1'h0;
    else
      reg2003 <= io_in_jal;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2009 <= 32'h0;
    else
      reg2009 <= io_in_jal_dest;
  end

  assign io_out_csr_address = reg1966;
  assign io_out_is_csr = reg1973;
  assign io_out_csr_result = reg1979;
  assign io_out_alu_result = reg1899;
  assign io_out_rd = reg1909;
  assign io_out_wb = reg1940;
  assign io_out_rs1 = reg1915;
  assign io_out_rd1 = reg1921;
  assign io_out_rd2 = reg1933;
  assign io_out_rs2 = reg1927;
  assign io_out_mem_read = reg1953;
  assign io_out_mem_write = reg1959;
  assign io_out_curr_PC = reg1985;
  assign io_out_branch_offset = reg1991;
  assign io_out_branch_type = reg1997;
  assign io_out_jal = reg2003;
  assign io_out_jal_dest = reg2009;
  assign io_out_PC_next = reg1946;

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
  wire lt2226, lt2229, orl2231, eq2239, eq2253, eq2257, andl2259, eq2280, eq2284, andl2286, orl2289, proxy2306, eq2307, proxy2324, eq2325;
  wire[1:0] sel2265, sel2269, sel2273;
  wire[7:0] proxy2298;
  wire[31:0] pad2299, proxy2302, sel2309, pad2317, proxy2320, sel2327;
  wire[15:0] proxy2316;
  reg[31:0] sel2343;

  assign lt2226 = io_in_mem_write < 3'h7;
  assign lt2229 = io_in_mem_read < 3'h7;
  assign orl2231 = lt2229 | lt2226;
  assign eq2239 = io_in_mem_write == 3'h2;
  assign eq2253 = io_in_mem_write == 3'h7;
  assign eq2257 = io_in_mem_read == 3'h7;
  assign andl2259 = eq2257 & eq2253;
  assign sel2265 = andl2259 ? 2'h0 : 2'h3;
  assign sel2269 = eq2239 ? 2'h2 : sel2265;
  assign sel2273 = lt2229 ? 2'h1 : sel2269;
  assign eq2280 = eq2239 == 1'h0;
  assign eq2284 = andl2259 == 1'h0;
  assign andl2286 = eq2284 & eq2280;
  assign orl2289 = lt2229 | andl2286;
  assign proxy2298 = io_DBUS_in_data_data[7:0];
  assign pad2299 = {{24{1'b0}}, proxy2298};
  assign proxy2302 = {24'hffffff, proxy2298};
  assign proxy2306 = proxy2298[7];
  assign eq2307 = proxy2306 == 1'h1;
  assign sel2309 = eq2307 ? proxy2302 : pad2299;
  assign proxy2316 = io_DBUS_in_data_data[15:0];
  assign pad2317 = {{16{1'b0}}, proxy2316};
  assign proxy2320 = {16'hffff, proxy2316};
  assign proxy2324 = proxy2316[15];
  assign eq2325 = proxy2324 == 1'h1;
  assign sel2327 = eq2325 ? proxy2320 : pad2317;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2343 = sel2309;
      3'h1: sel2343 = sel2327;
      3'h2: sel2343 = io_DBUS_in_data_data;
      3'h4: sel2343 = pad2299;
      3'h5: sel2343 = pad2317;
      default: sel2343 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2289;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2226;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2231;
  assign io_DBUS_out_control_data = sel2273;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2343;

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
  wire[31:0] bindin2350, bindout2359, bindout2368, bindin2386, bindin2395, bindout2398, shl2401, add2403;
  wire bindin2353, bindout2356, bindout2362, bindin2365, bindout2371, bindin2374, bindout2380, bindin2383, eq2413, sel2415, sel2424, eq2431, sel2433, sel2442, eq2470, sel2472;
  wire[1:0] bindout2377;
  wire[2:0] bindin2389, bindin2392;
  reg sel2465;

  Cache __module10__(.io_DBUS_in_data_data(bindin2350), .io_DBUS_in_data_valid(bindin2353), .io_DBUS_out_data_ready(bindin2365), .io_DBUS_out_address_ready(bindin2374), .io_DBUS_out_control_ready(bindin2383), .io_in_address(bindin2386), .io_in_mem_read(bindin2389), .io_in_mem_write(bindin2392), .io_in_data(bindin2395), .io_DBUS_in_data_ready(bindout2356), .io_DBUS_out_data_data(bindout2359), .io_DBUS_out_data_valid(bindout2362), .io_DBUS_out_address_data(bindout2368), .io_DBUS_out_address_valid(bindout2371), .io_DBUS_out_control_data(bindout2377), .io_DBUS_out_control_valid(bindout2380), .io_out_data(bindout2398));
  assign bindin2350 = io_DBUS_in_data_data;
  assign bindin2353 = io_DBUS_in_data_valid;
  assign bindin2365 = io_DBUS_out_data_ready;
  assign bindin2374 = io_DBUS_out_address_ready;
  assign bindin2383 = io_DBUS_out_control_ready;
  assign bindin2386 = io_in_alu_result;
  assign bindin2389 = io_in_mem_read;
  assign bindin2392 = io_in_mem_write;
  assign bindin2395 = io_in_rd2;
  assign shl2401 = $signed(io_in_branch_offset) << 32'h1;
  assign add2403 = $signed(io_in_curr_PC) + $signed(shl2401);
  assign eq2413 = io_in_alu_result == 32'h0;
  assign sel2415 = eq2413 ? 1'h1 : 1'h0;
  assign sel2424 = eq2413 ? 1'h0 : 1'h1;
  assign eq2431 = io_in_alu_result[31] == 1'h0;
  assign sel2433 = eq2431 ? 1'h0 : 1'h1;
  assign sel2442 = eq2431 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2465 = sel2415;
      3'h2: sel2465 = sel2424;
      3'h3: sel2465 = sel2433;
      3'h4: sel2465 = sel2442;
      3'h5: sel2465 = sel2433;
      3'h6: sel2465 = sel2442;
      3'h0: sel2465 = 1'h0;
      default: sel2465 = 1'h0;
    endcase
  end
  assign eq2470 = io_in_branch_type == 3'h0;
  assign sel2472 = eq2470 ? 1'h0 : 1'h1;

  assign io_DBUS_in_data_ready = bindout2356;
  assign io_DBUS_out_data_data = bindout2359;
  assign io_DBUS_out_data_valid = bindout2362;
  assign io_DBUS_out_address_data = bindout2368;
  assign io_DBUS_out_address_valid = bindout2371;
  assign io_DBUS_out_control_data = bindout2377;
  assign io_DBUS_out_control_valid = bindout2380;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2398;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2465;
  assign io_out_branch_dest = add2403;
  assign io_out_branch_stall = sel2472;
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
  reg[31:0] reg2622, reg2631, reg2663, reg2676;
  reg[4:0] reg2638, reg2644, reg2650;
  reg[1:0] reg2657;
  reg reg2670;

  always @ (posedge clk) begin
    if (reset)
      reg2622 <= 32'h0;
    else
      reg2622 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2631 <= 32'h0;
    else
      reg2631 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2638 <= 5'h0;
    else
      reg2638 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2644 <= 5'h0;
    else
      reg2644 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2650 <= 5'h0;
    else
      reg2650 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2657 <= 2'h0;
    else
      reg2657 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2663 <= 32'h0;
    else
      reg2663 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2670 <= 1'h0;
    else
      reg2670 <= io_in_branch_dir;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2676 <= 32'h0;
    else
      reg2676 <= io_in_branch_dest;
  end

  assign io_out_alu_result = reg2622;
  assign io_out_mem_result = reg2631;
  assign io_out_rd = reg2638;
  assign io_out_wb = reg2657;
  assign io_out_rs1 = reg2644;
  assign io_out_rs2 = reg2650;
  assign io_out_branch_dir = reg2670;
  assign io_out_branch_dest = reg2676;
  assign io_out_PC_next = reg2663;

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
  wire eq2754, eq2759;
  wire[31:0] sel2761, sel2763;

  assign eq2754 = io_in_wb == 2'h3;
  assign eq2759 = io_in_wb == 2'h1;
  assign sel2761 = eq2759 ? io_in_alu_result : io_in_mem_result;
  assign sel2763 = eq2754 ? io_in_PC_next : sel2761;

  assign io_out_write_data = sel2763;
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
  wire eq2860, eq2864, ne2869, ne2874, eq2877, andl2879, andl2881, eq2886, ne2890, eq2897, andl2899, andl2901, andl2903, eq2907, ne2915, eq2922, andl2924, andl2926, andl2928, andl2930, orl2933, orl2935, ne2943, eq2946, andl2948, andl2950, eq2954, eq2965, andl2967, andl2969, andl2971, eq2975, eq2990, andl2992, andl2994, andl2996, andl2998, orl3001, orl3003, eq3006, andl3008, eq3012, eq3015, andl3017, andl3019, orl3022, orl3029, orl3031, orl3033;

  assign eq2860 = io_in_execute_is_csr == 1'h1;
  assign eq2864 = io_in_memory_is_csr == 1'h1;
  assign ne2869 = io_in_execute_wb != 2'h0;
  assign ne2874 = io_in_decode_src1 != 5'h0;
  assign eq2877 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2879 = eq2877 & ne2874;
  assign andl2881 = andl2879 & ne2869;
  assign eq2886 = andl2881 == 1'h0;
  assign ne2890 = io_in_memory_wb != 2'h0;
  assign eq2897 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2899 = eq2897 & ne2874;
  assign andl2901 = andl2899 & ne2890;
  assign andl2903 = andl2901 & eq2886;
  assign eq2907 = andl2903 == 1'h0;
  assign ne2915 = io_in_writeback_wb != 2'h0;
  assign eq2922 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2924 = eq2922 & ne2874;
  assign andl2926 = andl2924 & ne2915;
  assign andl2928 = andl2926 & eq2886;
  assign andl2930 = andl2928 & eq2907;
  assign orl2933 = andl2881 | andl2903;
  assign orl2935 = orl2933 | andl2930;
  assign ne2943 = io_in_decode_src2 != 5'h0;
  assign eq2946 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2948 = eq2946 & ne2943;
  assign andl2950 = andl2948 & ne2869;
  assign eq2954 = andl2950 == 1'h0;
  assign eq2965 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2967 = eq2965 & ne2943;
  assign andl2969 = andl2967 & ne2890;
  assign andl2971 = andl2969 & eq2954;
  assign eq2975 = andl2971 == 1'h0;
  assign eq2990 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2992 = eq2990 & ne2943;
  assign andl2994 = andl2992 & ne2915;
  assign andl2996 = andl2994 & eq2954;
  assign andl2998 = andl2996 & eq2975;
  assign orl3001 = andl2950 | andl2971;
  assign orl3003 = orl3001 | andl2998;
  assign eq3006 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3008 = eq3006 & eq2860;
  assign eq3012 = andl3008 == 1'h0;
  assign eq3015 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3017 = eq3015 & eq2864;
  assign andl3019 = andl3017 & eq3012;
  assign orl3022 = andl3008 | andl3019;
  assign orl3029 = orl2935 | andl2950;
  assign orl3031 = orl3029 | andl2971;
  assign orl3033 = orl3031 | andl2998;

  assign io_out_src1_fwd = orl2935;
  assign io_out_src2_fwd = orl3003;
  assign io_out_csr_fwd = orl3022;
  assign io_out_fwd_stall = orl3033;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3128 [0:1];
  wire[31:0] mrport3130, sel3134;

  initial begin
    mem3128[0] = 32'hdeadbeef;
    mem3128[1] = 32'hdeadbeef;
  end
  assign mrport3130 = mem3128[io_INTERRUPT_in_interrupt_id_data];
  assign sel3134 = io_INTERRUPT_in_interrupt_id_valid ? mrport3130 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3134;

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
  reg[3:0] reg3202, sel3292;
  wire eq3210, andl3295, eq3299, andl3303, eq3307, andl3311;
  wire[3:0] sel3216, sel3221, sel3227, sel3233, sel3243, sel3248, sel3252, sel3261, sel3267, sel3277, sel3282, sel3286, sel3293, sel3309, sel3310, sel3312;

  always @ (posedge clk) begin
    if (reset)
      reg3202 <= 4'h0;
    else
      reg3202 <= sel3312;
  end
  assign eq3210 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3216 = eq3210 ? 4'h0 : 4'h1;
  assign sel3221 = eq3210 ? 4'h2 : 4'h1;
  assign sel3227 = eq3210 ? 4'h9 : 4'h3;
  assign sel3233 = eq3210 ? 4'h5 : 4'h4;
  assign sel3243 = eq3210 ? 4'h8 : 4'h6;
  assign sel3248 = eq3210 ? 4'h7 : 4'h6;
  assign sel3252 = eq3210 ? 4'h4 : 4'h8;
  assign sel3261 = eq3210 ? 4'h0 : 4'ha;
  assign sel3267 = eq3210 ? 4'hc : 4'hb;
  assign sel3277 = eq3210 ? 4'hf : 4'hd;
  assign sel3282 = eq3210 ? 4'he : 4'hd;
  assign sel3286 = eq3210 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3202)
      4'h0: sel3292 = sel3216;
      4'h1: sel3292 = sel3221;
      4'h2: sel3292 = sel3227;
      4'h3: sel3292 = sel3233;
      4'h4: sel3292 = sel3233;
      4'h5: sel3292 = sel3243;
      4'h6: sel3292 = sel3248;
      4'h7: sel3292 = sel3252;
      4'h8: sel3292 = sel3221;
      4'h9: sel3292 = sel3261;
      4'ha: sel3292 = sel3267;
      4'hb: sel3292 = sel3267;
      4'hc: sel3292 = sel3277;
      4'hd: sel3292 = sel3282;
      4'he: sel3292 = sel3286;
      4'hf: sel3292 = sel3221;
      default: sel3292 = reg3202;
    endcase
  end
  assign sel3293 = io_JTAG_TAP_in_mode_select_valid ? sel3292 : 4'h0;
  assign andl3295 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3299 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3303 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3307 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3309 = eq3299 ? 4'h0 : reg3202;
  assign sel3310 = andl3311 ? sel3293 : reg3202;
  assign andl3311 = andl3303 & eq3307;
  assign sel3312 = andl3295 ? sel3309 : sel3310;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3202;

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
  wire bindin3318, bindin3320, bindin3321, bindin3324, bindout3327, bindin3330, bindin3333, bindout3336, bindin3339, bindin3342, bindout3345, eq3382, eq3391, eq3396, eq3473, andl3474, sel3476, sel3482;
  wire[3:0] bindout3348;
  reg[31:0] reg3356, reg3363, reg3370, reg3377, sel3475;
  wire[31:0] sel3399, sel3401, shr3408, proxy3413, sel3468, sel3469, sel3470, sel3471, sel3472;
  wire[30:0] proxy3411;
  reg sel3481, sel3487;

  assign bindin3318 = clk;
  assign bindin3320 = reset;
  TAP __module16__(.clk(bindin3318), .reset(bindin3320), .io_JTAG_TAP_in_mode_select_data(bindin3321), .io_JTAG_TAP_in_mode_select_valid(bindin3324), .io_JTAG_TAP_in_clock_data(bindin3330), .io_JTAG_TAP_in_clock_valid(bindin3333), .io_JTAG_TAP_in_reset_data(bindin3339), .io_JTAG_TAP_in_reset_valid(bindin3342), .io_JTAG_TAP_in_mode_select_ready(bindout3327), .io_JTAG_TAP_in_clock_ready(bindout3336), .io_JTAG_TAP_in_reset_ready(bindout3345), .io_out_curr_state(bindout3348));
  assign bindin3321 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3324 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3330 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3333 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3339 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3342 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3356 <= 32'h0;
    else
      reg3356 <= sel3468;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3363 <= 32'h1234;
    else
      reg3363 <= sel3471;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3370 <= 32'h5678;
    else
      reg3370 <= sel3472;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3377 <= 32'h0;
    else
      reg3377 <= sel3475;
  end
  assign eq3382 = reg3356 == 32'h0;
  assign eq3391 = reg3356 == 32'h1;
  assign eq3396 = reg3356 == 32'h2;
  assign sel3399 = eq3396 ? reg3363 : 32'hdeadbeef;
  assign sel3401 = eq3391 ? reg3370 : sel3399;
  assign shr3408 = reg3377 >> 32'h1;
  assign proxy3411 = shr3408[30:0];
  assign proxy3413 = {io_JTAG_in_data_data, proxy3411};
  assign sel3468 = (bindout3348 == 4'hf) ? reg3377 : reg3356;
  assign sel3469 = eq3396 ? reg3377 : reg3363;
  assign sel3470 = eq3391 ? reg3363 : sel3469;
  assign sel3471 = (bindout3348 == 4'h8) ? sel3470 : reg3363;
  assign sel3472 = andl3474 ? reg3377 : reg3370;
  assign eq3473 = bindout3348 == 4'h8;
  assign andl3474 = eq3473 & eq3391;
  always @(*) begin
    case (bindout3348)
      4'h3: sel3475 = sel3401;
      4'h4: sel3475 = proxy3413;
      4'ha: sel3475 = reg3356;
      4'hb: sel3475 = proxy3413;
      default: sel3475 = reg3377;
    endcase
  end
  assign sel3476 = eq3382 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3348)
      4'h3: sel3481 = sel3476;
      4'h4: sel3481 = 1'h1;
      4'h8: sel3481 = sel3476;
      4'ha: sel3481 = sel3476;
      4'hb: sel3481 = 1'h1;
      4'hf: sel3481 = sel3476;
      default: sel3481 = sel3476;
    endcase
  end
  assign sel3482 = eq3382 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3348)
      4'h3: sel3487 = sel3482;
      4'h4: sel3487 = reg3377[0];
      4'h8: sel3487 = sel3482;
      4'ha: sel3487 = sel3482;
      4'hb: sel3487 = reg3377[0];
      4'hf: sel3487 = sel3482;
      default: sel3487 = sel3482;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3327;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3336;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3345;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3487;
  assign io_JTAG_out_data_valid = sel3481;

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
  reg[11:0] mem3543 [0:4095];
  reg[11:0] reg3552;
  wire[11:0] proxy3562, mrport3564;
  wire[31:0] pad3566;

  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem3543[io_in_mem_csr_address] <= proxy3562;
    end
  end
  assign mrport3564 = mem3543[reg3552];
  always @ (posedge clk) begin
    if (reset)
      reg3552 <= 12'h0;
    else
      reg3552 <= io_in_decode_csr_address;
  end
  assign proxy3562 = io_in_mem_csr_result[11:0];
  assign pad3566 = {{20{1'b0}}, mrport3564};

  assign io_out_decode_csr_data = pad3566;

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
  wire bindin230, bindin232, bindin236, bindout239, bindout245, bindin248, bindin251, bindin257, bindin260, bindin263, bindin266, bindin272, bindin336, bindin337, bindin344, bindin347, bindin350, bindin1027, bindin1034, bindout1049, bindout1076, bindout1091, bindout1094, bindin1394, bindin1395, bindin1417, bindin1435, bindin1438, bindin1447, bindin1456, bindout1465, bindout1492, bindout1513, bindin1730, bindin1754, bindin1763, bindout1775, bindout1808, bindout1817, bindin2014, bindin2015, bindin2049, bindin2064, bindout2073, bindout2115, bindin2480, bindout2483, bindout2489, bindin2492, bindout2498, bindin2501, bindout2507, bindin2510, bindout2570, bindout2576, bindin2681, bindin2682, bindin2704, bindout2728, bindin3059, bindin3083, bindout3116, bindin3138, bindin3141, bindout3144, bindout3147, bindin3491, bindin3492, bindin3493, bindin3496, bindout3499, bindin3502, bindin3505, bindout3508, bindin3511, bindin3514, bindout3517, bindin3520, bindin3523, bindout3526, bindout3529, bindout3532, bindin3535, bindin3571, bindin3572, bindin3579, orl3587, orl3589, eq3594, orl3596, orl3599;
  wire[31:0] bindin233, bindout242, bindin254, bindin269, bindin275, bindout278, bindout281, bindin338, bindin341, bindout353, bindout356, bindin1028, bindin1031, bindin1037, bindout1052, bindout1061, bindout1067, bindout1079, bindout1097, bindout1103, bindin1402, bindin1408, bindin1420, bindin1429, bindin1450, bindin1453, bindin1459, bindout1468, bindout1477, bindout1483, bindout1495, bindout1510, bindout1516, bindout1519, bindin1715, bindin1721, bindin1733, bindin1742, bindin1757, bindin1760, bindin1766, bindin1769, bindout1778, bindout1781, bindout1793, bindout1799, bindout1811, bindout1814, bindout1820, bindin2016, bindin2028, bindin2034, bindin2043, bindin2052, bindin2055, bindin2058, bindin2067, bindout2076, bindout2079, bindout2091, bindout2094, bindout2106, bindout2109, bindout2118, bindout2121, bindin2477, bindout2486, bindout2495, bindin2513, bindin2531, bindin2537, bindin2540, bindin2543, bindin2546, bindout2552, bindout2555, bindout2573, bindout2579, bindin2683, bindin2686, bindin2701, bindin2707, bindout2710, bindout2713, bindout2731, bindout2734, bindin2768, bindin2771, bindin2786, bindout2789, bindin3053, bindin3056, bindin3065, bindin3074, bindin3077, bindin3080, bindin3089, bindin3098, bindin3101, bindin3104, bindout3150, bindin3582, bindout3585;
  wire[4:0] bindin1040, bindout1055, bindout1058, bindout1064, bindin1396, bindin1399, bindin1405, bindout1471, bindout1474, bindout1480, bindin1709, bindin1712, bindin1718, bindout1784, bindout1790, bindout1796, bindin2019, bindin2025, bindin2031, bindout2082, bindout2088, bindout2097, bindin2522, bindin2528, bindin2534, bindout2558, bindout2564, bindout2567, bindin2689, bindin2695, bindin2698, bindout2716, bindout2722, bindout2725, bindin2774, bindin2780, bindin2783, bindout2792, bindin3038, bindin3041, bindin3047, bindin3068, bindin3092;
  wire[1:0] bindin1043, bindout1070, bindin1414, bindout1489, bindin1727, bindout1787, bindin2022, bindout2085, bindout2504, bindin2525, bindout2561, bindin2692, bindout2719, bindin2777, bindout2795, bindin3050, bindin3071, bindin3095;
  wire[11:0] bindout1046, bindin1444, bindout1462, bindin1751, bindout1772, bindin2046, bindout2070, bindin3044, bindin3062, bindin3086, bindin3573, bindin3576;
  wire[3:0] bindout1073, bindin1411, bindout1486, bindin1724;
  wire[2:0] bindout1082, bindout1085, bindout1088, bindin1423, bindin1426, bindin1432, bindout1498, bindout1501, bindout1504, bindin1736, bindin1739, bindin1745, bindout1802, bindout1805, bindin2037, bindin2040, bindin2061, bindout2100, bindout2103, bindout2112, bindin2516, bindin2519, bindin2549;
  wire[19:0] bindout1100, bindin1441, bindout1507, bindin1748;

  assign bindin230 = clk;
  assign bindin232 = reset;
  Fetch __module2__(.clk(bindin230), .reset(bindin232), .io_IBUS_in_data_data(bindin233), .io_IBUS_in_data_valid(bindin236), .io_IBUS_out_address_ready(bindin248), .io_in_branch_dir(bindin251), .io_in_branch_dest(bindin254), .io_in_branch_stall(bindin257), .io_in_fwd_stall(bindin260), .io_in_branch_stall_exe(bindin263), .io_in_jal(bindin266), .io_in_jal_dest(bindin269), .io_in_interrupt(bindin272), .io_in_interrupt_pc(bindin275), .io_IBUS_in_data_ready(bindout239), .io_IBUS_out_address_data(bindout242), .io_IBUS_out_address_valid(bindout245), .io_out_instruction(bindout278), .io_out_curr_PC(bindout281));
  assign bindin233 = io_IBUS_in_data_data;
  assign bindin236 = io_IBUS_in_data_valid;
  assign bindin248 = io_IBUS_out_address_ready;
  assign bindin251 = bindout2728;
  assign bindin254 = bindout2731;
  assign bindin257 = bindout1091;
  assign bindin260 = bindout3116;
  assign bindin263 = orl3599;
  assign bindin266 = bindout2115;
  assign bindin269 = bindout2118;
  assign bindin272 = bindout3147;
  assign bindin275 = bindout3150;
  assign bindin336 = clk;
  assign bindin337 = reset;
  F_D_Register __module3__(.clk(bindin336), .reset(bindin337), .io_in_instruction(bindin338), .io_in_curr_PC(bindin341), .io_in_branch_stall(bindin344), .io_in_branch_stall_exe(bindin347), .io_in_fwd_stall(bindin350), .io_out_instruction(bindout353), .io_out_curr_PC(bindout356));
  assign bindin338 = bindout278;
  assign bindin341 = bindout281;
  assign bindin344 = bindout1091;
  assign bindin347 = orl3599;
  assign bindin350 = bindout3116;
  assign bindin1027 = clk;
  Decode __module4__(.clk(bindin1027), .io_in_instruction(bindin1028), .io_in_curr_PC(bindin1031), .io_in_stall(bindin1034), .io_in_write_data(bindin1037), .io_in_rd(bindin1040), .io_in_wb(bindin1043), .io_out_csr_address(bindout1046), .io_out_is_csr(bindout1049), .io_out_csr_mask(bindout1052), .io_out_rd(bindout1055), .io_out_rs1(bindout1058), .io_out_rd1(bindout1061), .io_out_rs2(bindout1064), .io_out_rd2(bindout1067), .io_out_wb(bindout1070), .io_out_alu_op(bindout1073), .io_out_rs2_src(bindout1076), .io_out_itype_immed(bindout1079), .io_out_mem_read(bindout1082), .io_out_mem_write(bindout1085), .io_out_branch_type(bindout1088), .io_out_branch_stall(bindout1091), .io_out_jal(bindout1094), .io_out_jal_offset(bindout1097), .io_out_upper_immed(bindout1100), .io_out_PC_next(bindout1103));
  assign bindin1028 = bindout353;
  assign bindin1031 = bindout356;
  assign bindin1034 = orl3596;
  assign bindin1037 = bindout2789;
  assign bindin1040 = bindout2792;
  assign bindin1043 = bindout2795;
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
  assign bindin1435 = bindout3116;
  assign bindin1438 = orl3599;
  assign bindin1441 = bindout1100;
  assign bindin1444 = bindout1046;
  assign bindin1447 = bindout1049;
  assign bindin1450 = bindout1052;
  assign bindin1453 = bindout356;
  assign bindin1456 = bindout1094;
  assign bindin1459 = bindout1097;
  Execute __module7__(.io_in_rd(bindin1709), .io_in_rs1(bindin1712), .io_in_rd1(bindin1715), .io_in_rs2(bindin1718), .io_in_rd2(bindin1721), .io_in_alu_op(bindin1724), .io_in_wb(bindin1727), .io_in_rs2_src(bindin1730), .io_in_itype_immed(bindin1733), .io_in_mem_read(bindin1736), .io_in_mem_write(bindin1739), .io_in_PC_next(bindin1742), .io_in_branch_type(bindin1745), .io_in_upper_immed(bindin1748), .io_in_csr_address(bindin1751), .io_in_is_csr(bindin1754), .io_in_csr_data(bindin1757), .io_in_csr_mask(bindin1760), .io_in_jal(bindin1763), .io_in_jal_offset(bindin1766), .io_in_curr_PC(bindin1769), .io_out_csr_address(bindout1772), .io_out_is_csr(bindout1775), .io_out_csr_result(bindout1778), .io_out_alu_result(bindout1781), .io_out_rd(bindout1784), .io_out_wb(bindout1787), .io_out_rs1(bindout1790), .io_out_rd1(bindout1793), .io_out_rs2(bindout1796), .io_out_rd2(bindout1799), .io_out_mem_read(bindout1802), .io_out_mem_write(bindout1805), .io_out_jal(bindout1808), .io_out_jal_dest(bindout1811), .io_out_branch_offset(bindout1814), .io_out_branch_stall(bindout1817), .io_out_PC_next(bindout1820));
  assign bindin1709 = bindout1471;
  assign bindin1712 = bindout1474;
  assign bindin1715 = bindout1477;
  assign bindin1718 = bindout1480;
  assign bindin1721 = bindout1483;
  assign bindin1724 = bindout1486;
  assign bindin1727 = bindout1489;
  assign bindin1730 = bindout1492;
  assign bindin1733 = bindout1495;
  assign bindin1736 = bindout1498;
  assign bindin1739 = bindout1501;
  assign bindin1742 = bindout1519;
  assign bindin1745 = bindout1504;
  assign bindin1748 = bindout1507;
  assign bindin1751 = bindout1462;
  assign bindin1754 = bindout1465;
  assign bindin1757 = bindout3585;
  assign bindin1760 = bindout1468;
  assign bindin1763 = bindout1513;
  assign bindin1766 = bindout1516;
  assign bindin1769 = bindout1510;
  assign bindin2014 = clk;
  assign bindin2015 = reset;
  E_M_Register __module8__(.clk(bindin2014), .reset(bindin2015), .io_in_alu_result(bindin2016), .io_in_rd(bindin2019), .io_in_wb(bindin2022), .io_in_rs1(bindin2025), .io_in_rd1(bindin2028), .io_in_rs2(bindin2031), .io_in_rd2(bindin2034), .io_in_mem_read(bindin2037), .io_in_mem_write(bindin2040), .io_in_PC_next(bindin2043), .io_in_csr_address(bindin2046), .io_in_is_csr(bindin2049), .io_in_csr_result(bindin2052), .io_in_curr_PC(bindin2055), .io_in_branch_offset(bindin2058), .io_in_branch_type(bindin2061), .io_in_jal(bindin2064), .io_in_jal_dest(bindin2067), .io_out_csr_address(bindout2070), .io_out_is_csr(bindout2073), .io_out_csr_result(bindout2076), .io_out_alu_result(bindout2079), .io_out_rd(bindout2082), .io_out_wb(bindout2085), .io_out_rs1(bindout2088), .io_out_rd1(bindout2091), .io_out_rd2(bindout2094), .io_out_rs2(bindout2097), .io_out_mem_read(bindout2100), .io_out_mem_write(bindout2103), .io_out_curr_PC(bindout2106), .io_out_branch_offset(bindout2109), .io_out_branch_type(bindout2112), .io_out_jal(bindout2115), .io_out_jal_dest(bindout2118), .io_out_PC_next(bindout2121));
  assign bindin2016 = bindout1781;
  assign bindin2019 = bindout1784;
  assign bindin2022 = bindout1787;
  assign bindin2025 = bindout1790;
  assign bindin2028 = bindout1793;
  assign bindin2031 = bindout1796;
  assign bindin2034 = bindout1799;
  assign bindin2037 = bindout1802;
  assign bindin2040 = bindout1805;
  assign bindin2043 = bindout1820;
  assign bindin2046 = bindout1772;
  assign bindin2049 = bindout1775;
  assign bindin2052 = bindout1778;
  assign bindin2055 = bindout1510;
  assign bindin2058 = bindout1814;
  assign bindin2061 = bindout1504;
  assign bindin2064 = bindout1808;
  assign bindin2067 = bindout1811;
  Memory __module9__(.io_DBUS_in_data_data(bindin2477), .io_DBUS_in_data_valid(bindin2480), .io_DBUS_out_data_ready(bindin2492), .io_DBUS_out_address_ready(bindin2501), .io_DBUS_out_control_ready(bindin2510), .io_in_alu_result(bindin2513), .io_in_mem_read(bindin2516), .io_in_mem_write(bindin2519), .io_in_rd(bindin2522), .io_in_wb(bindin2525), .io_in_rs1(bindin2528), .io_in_rd1(bindin2531), .io_in_rs2(bindin2534), .io_in_rd2(bindin2537), .io_in_PC_next(bindin2540), .io_in_curr_PC(bindin2543), .io_in_branch_offset(bindin2546), .io_in_branch_type(bindin2549), .io_DBUS_in_data_ready(bindout2483), .io_DBUS_out_data_data(bindout2486), .io_DBUS_out_data_valid(bindout2489), .io_DBUS_out_address_data(bindout2495), .io_DBUS_out_address_valid(bindout2498), .io_DBUS_out_control_data(bindout2504), .io_DBUS_out_control_valid(bindout2507), .io_out_alu_result(bindout2552), .io_out_mem_result(bindout2555), .io_out_rd(bindout2558), .io_out_wb(bindout2561), .io_out_rs1(bindout2564), .io_out_rs2(bindout2567), .io_out_branch_dir(bindout2570), .io_out_branch_dest(bindout2573), .io_out_branch_stall(bindout2576), .io_out_PC_next(bindout2579));
  assign bindin2477 = io_DBUS_in_data_data;
  assign bindin2480 = io_DBUS_in_data_valid;
  assign bindin2492 = io_DBUS_out_data_ready;
  assign bindin2501 = io_DBUS_out_address_ready;
  assign bindin2510 = io_DBUS_out_control_ready;
  assign bindin2513 = bindout2079;
  assign bindin2516 = bindout2100;
  assign bindin2519 = bindout2103;
  assign bindin2522 = bindout2082;
  assign bindin2525 = bindout2085;
  assign bindin2528 = bindout2088;
  assign bindin2531 = bindout2091;
  assign bindin2534 = bindout2097;
  assign bindin2537 = bindout2094;
  assign bindin2540 = bindout2121;
  assign bindin2543 = bindout2106;
  assign bindin2546 = bindout2109;
  assign bindin2549 = bindout2112;
  assign bindin2681 = clk;
  assign bindin2682 = reset;
  M_W_Register __module11__(.clk(bindin2681), .reset(bindin2682), .io_in_alu_result(bindin2683), .io_in_mem_result(bindin2686), .io_in_rd(bindin2689), .io_in_wb(bindin2692), .io_in_rs1(bindin2695), .io_in_rs2(bindin2698), .io_in_PC_next(bindin2701), .io_in_branch_dir(bindin2704), .io_in_branch_dest(bindin2707), .io_out_alu_result(bindout2710), .io_out_mem_result(bindout2713), .io_out_rd(bindout2716), .io_out_wb(bindout2719), .io_out_rs1(bindout2722), .io_out_rs2(bindout2725), .io_out_branch_dir(bindout2728), .io_out_branch_dest(bindout2731), .io_out_PC_next(bindout2734));
  assign bindin2683 = bindout2552;
  assign bindin2686 = bindout2555;
  assign bindin2689 = bindout2558;
  assign bindin2692 = bindout2561;
  assign bindin2695 = bindout2564;
  assign bindin2698 = bindout2567;
  assign bindin2701 = bindout2579;
  assign bindin2704 = bindout2570;
  assign bindin2707 = bindout2573;
  Write_Back __module12__(.io_in_alu_result(bindin2768), .io_in_mem_result(bindin2771), .io_in_rd(bindin2774), .io_in_wb(bindin2777), .io_in_rs1(bindin2780), .io_in_rs2(bindin2783), .io_in_PC_next(bindin2786), .io_out_write_data(bindout2789), .io_out_rd(bindout2792), .io_out_wb(bindout2795));
  assign bindin2768 = bindout2710;
  assign bindin2771 = bindout2713;
  assign bindin2774 = bindout2716;
  assign bindin2777 = bindout2719;
  assign bindin2780 = bindout2722;
  assign bindin2783 = bindout2725;
  assign bindin2786 = bindout2734;
  Forwarding __module13__(.io_in_decode_src1(bindin3038), .io_in_decode_src2(bindin3041), .io_in_decode_csr_address(bindin3044), .io_in_execute_dest(bindin3047), .io_in_execute_wb(bindin3050), .io_in_execute_alu_result(bindin3053), .io_in_execute_PC_next(bindin3056), .io_in_execute_is_csr(bindin3059), .io_in_execute_csr_address(bindin3062), .io_in_execute_csr_result(bindin3065), .io_in_memory_dest(bindin3068), .io_in_memory_wb(bindin3071), .io_in_memory_alu_result(bindin3074), .io_in_memory_mem_data(bindin3077), .io_in_memory_PC_next(bindin3080), .io_in_memory_is_csr(bindin3083), .io_in_memory_csr_address(bindin3086), .io_in_memory_csr_result(bindin3089), .io_in_writeback_dest(bindin3092), .io_in_writeback_wb(bindin3095), .io_in_writeback_alu_result(bindin3098), .io_in_writeback_mem_data(bindin3101), .io_in_writeback_PC_next(bindin3104), .io_out_fwd_stall(bindout3116));
  assign bindin3038 = bindout1058;
  assign bindin3041 = bindout1064;
  assign bindin3044 = bindout1046;
  assign bindin3047 = bindout1784;
  assign bindin3050 = bindout1787;
  assign bindin3053 = bindout1781;
  assign bindin3056 = bindout1820;
  assign bindin3059 = bindout1775;
  assign bindin3062 = bindout1772;
  assign bindin3065 = bindout1778;
  assign bindin3068 = bindout2558;
  assign bindin3071 = bindout2561;
  assign bindin3074 = bindout2552;
  assign bindin3077 = bindout2555;
  assign bindin3080 = bindout2579;
  assign bindin3083 = bindout2073;
  assign bindin3086 = bindout2070;
  assign bindin3089 = bindout2076;
  assign bindin3092 = bindout2716;
  assign bindin3095 = bindout2719;
  assign bindin3098 = bindout2710;
  assign bindin3101 = bindout2713;
  assign bindin3104 = bindout2734;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3138), .io_INTERRUPT_in_interrupt_id_valid(bindin3141), .io_INTERRUPT_in_interrupt_id_ready(bindout3144), .io_out_interrupt(bindout3147), .io_out_interrupt_pc(bindout3150));
  assign bindin3138 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3141 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3491 = clk;
  assign bindin3492 = reset;
  JTAG __module15__(.clk(bindin3491), .reset(bindin3492), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3493), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3496), .io_JTAG_JTAG_TAP_in_clock_data(bindin3502), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3505), .io_JTAG_JTAG_TAP_in_reset_data(bindin3511), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3514), .io_JTAG_in_data_data(bindin3520), .io_JTAG_in_data_valid(bindin3523), .io_JTAG_out_data_ready(bindin3535), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3499), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3508), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3517), .io_JTAG_in_data_ready(bindout3526), .io_JTAG_out_data_data(bindout3529), .io_JTAG_out_data_valid(bindout3532));
  assign bindin3493 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3496 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3502 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3505 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3511 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3514 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3520 = io_jtag_in_data_data;
  assign bindin3523 = io_jtag_in_data_valid;
  assign bindin3535 = io_jtag_out_data_ready;
  assign bindin3571 = clk;
  assign bindin3572 = reset;
  CSR_Handler __module17__(.clk(bindin3571), .reset(bindin3572), .io_in_decode_csr_address(bindin3573), .io_in_mem_csr_address(bindin3576), .io_in_mem_is_csr(bindin3579), .io_in_mem_csr_result(bindin3582), .io_out_decode_csr_data(bindout3585));
  assign bindin3573 = bindout1046;
  assign bindin3576 = bindout2070;
  assign bindin3579 = bindout2073;
  assign bindin3582 = bindout2076;
  assign orl3587 = bindout1091 | bindout1817;
  assign orl3589 = orl3587 | bindout2576;
  assign eq3594 = bindout1817 == 1'h1;
  assign orl3596 = eq3594 | bindout2576;
  assign orl3599 = bindout1817 | bindout2576;

  assign io_IBUS_in_data_ready = bindout239;
  assign io_IBUS_out_address_data = bindout242;
  assign io_IBUS_out_address_valid = bindout245;
  assign io_DBUS_in_data_ready = bindout2483;
  assign io_DBUS_out_data_data = bindout2486;
  assign io_DBUS_out_data_valid = bindout2489;
  assign io_DBUS_out_address_data = bindout2495;
  assign io_DBUS_out_address_valid = bindout2498;
  assign io_DBUS_out_control_data = bindout2504;
  assign io_DBUS_out_control_valid = bindout2507;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3144;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3499;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3508;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3517;
  assign io_jtag_in_data_ready = bindout3526;
  assign io_jtag_out_data_data = bindout3529;
  assign io_jtag_out_data_valid = bindout3532;
  assign io_out_fwd_stall = bindout3116;
  assign io_out_branch_stall = orl3589;

endmodule
