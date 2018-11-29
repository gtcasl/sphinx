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
  wire ne446, andl449, eq459, eq468;
  wire[31:0] mrport453, sel461, mrport463, sel470;

  always @ (posedge clk) begin
    if (andl449) begin
      mem434[io_in_rd] <= io_in_data;
    end
  end
  assign mrport453 = mem434[io_in_src1];
  assign mrport463 = mem434[io_in_src2];
  assign ne446 = io_in_rd != 5'h0;
  assign andl449 = io_in_write_register & ne446;
  assign eq459 = io_in_src1 == 5'h0;
  assign sel461 = eq459 ? 32'h0 : mrport453;
  assign eq468 = io_in_src2 == 5'h0;
  assign sel470 = eq468 ? 32'h0 : mrport463;

  assign io_out_src1_data = sel461;
  assign io_out_src2_data = sel470;

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
  wire bindin477, bindin478, ne538, sel540, eq592, eq597, eq602, orl604, eq609, eq614, eq619, eq624, eq629, eq634, ne639, eq644, andl646, proxy649, eq650, andl653, eq657, andl663, orl675, orl677, orl679, orl681, orl692, orl694, orl701, sel703, proxy729, proxy737, eq755, proxy772, eq773, eq779, lt783, andl786, sel798, ne801, ge804, eq807, andl812, andl814, eq823, eq828, orl830, eq845, proxy875, eq876, proxy881, eq910, eq948, eq985, eq993, eq1001, orl1007, lt1025;
  wire[4:0] bindin481, bindin487, bindin490, proxy550, proxy557, proxy564;
  wire[31:0] bindin484, bindout493, bindout496, shr547, shr554, shr561, shr568, shr575, add587, sel665, pad667, sel669, shr733, pad746, proxy751, sel757, pad763, proxy768, sel775, sel796, pad836, proxy840, sel847, pad867, proxy871, sel878, shr885, sel912;
  wire[2:0] proxy571, sel707, sel710;
  wire[6:0] proxy578;
  wire[11:0] proxy584, proxy761, sel816, pad832, sel834, proxy850, proxy896;
  wire[1:0] sel683, sel687, sel696, proxy980;
  wire[19:0] proxy713;
  reg[19:0] sel722;
  wire[7:0] proxy728;
  wire[9:0] proxy736;
  wire[20:0] proxy740;
  reg[31:0] sel797, sel916;
  reg sel799, sel938;
  wire[3:0] proxy888, sel950, sel953, sel970, sel987, sel995, sel1003, sel1009, sel1011, sel1015, sel1019, sel1027, sel1029;
  wire[5:0] proxy894;
  reg[11:0] sel917;
  reg[2:0] sel936, sel937;
  reg[3:0] sel978;

  assign bindin477 = clk;
  RegisterFile __module5__(.clk(bindin477), .io_in_write_register(bindin478), .io_in_rd(bindin481), .io_in_data(bindin484), .io_in_src1(bindin487), .io_in_src2(bindin490), .io_out_src1_data(bindout493), .io_out_src2_data(bindout496));
  assign bindin478 = sel540;
  assign bindin481 = io_in_rd;
  assign bindin484 = io_in_write_data;
  assign bindin487 = proxy557;
  assign bindin490 = proxy564;
  assign ne538 = io_in_wb != 2'h0;
  assign sel540 = ne538 ? 1'h1 : 1'h0;
  assign shr547 = io_in_instruction >> 32'h7;
  assign proxy550 = shr547[4:0];
  assign shr554 = io_in_instruction >> 32'hf;
  assign proxy557 = shr554[4:0];
  assign shr561 = io_in_instruction >> 32'h14;
  assign proxy564 = shr561[4:0];
  assign shr568 = io_in_instruction >> 32'hc;
  assign proxy571 = shr568[2:0];
  assign shr575 = io_in_instruction >> 32'h19;
  assign proxy578 = shr575[6:0];
  assign proxy584 = shr561[11:0];
  assign add587 = io_in_curr_PC + 32'h4;
  assign eq592 = io_in_instruction[6:0] == 7'h33;
  assign eq597 = io_in_instruction[6:0] == 7'h3;
  assign eq602 = io_in_instruction[6:0] == 7'h13;
  assign orl604 = eq602 | eq597;
  assign eq609 = io_in_instruction[6:0] == 7'h23;
  assign eq614 = io_in_instruction[6:0] == 7'h63;
  assign eq619 = io_in_instruction[6:0] == 7'h6f;
  assign eq624 = io_in_instruction[6:0] == 7'h67;
  assign eq629 = io_in_instruction[6:0] == 7'h37;
  assign eq634 = io_in_instruction[6:0] == 7'h17;
  assign ne639 = proxy571 != 3'h0;
  assign eq644 = io_in_instruction[6:0] == 7'h73;
  assign andl646 = eq644 & ne639;
  assign proxy649 = proxy571[2];
  assign eq650 = proxy649 == 1'h1;
  assign andl653 = andl646 & eq650;
  assign eq657 = proxy571 == 3'h0;
  assign andl663 = eq644 & eq657;
  assign sel665 = eq619 ? io_in_curr_PC : bindout493;
  assign pad667 = {{27{1'b0}}, proxy557};
  assign sel669 = andl653 ? pad667 : sel665;
  assign orl675 = orl604 | eq592;
  assign orl677 = orl675 | eq629;
  assign orl679 = orl677 | eq634;
  assign orl681 = orl679 | andl646;
  assign sel683 = orl681 ? 2'h1 : 2'h0;
  assign sel687 = eq597 ? 2'h2 : sel683;
  assign orl692 = eq619 | eq624;
  assign orl694 = orl692 | andl663;
  assign sel696 = orl694 ? 2'h3 : sel687;
  assign orl701 = orl604 | eq609;
  assign sel703 = orl701 ? 1'h1 : 1'h0;
  assign sel707 = eq597 ? proxy571 : 3'h7;
  assign sel710 = eq609 ? proxy571 : 3'h7;
  assign proxy713 = {proxy578, proxy564, proxy557, proxy571};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h37: sel722 = proxy713;
      7'h17: sel722 = proxy713;
      default: sel722 = 20'h7b;
    endcase
  end
  assign proxy728 = shr568[7:0];
  assign proxy729 = io_in_instruction[20];
  assign shr733 = io_in_instruction >> 32'h15;
  assign proxy736 = shr733[9:0];
  assign proxy737 = io_in_instruction[31];
  assign proxy740 = {proxy737, proxy728, proxy729, proxy736, 1'h0};
  assign pad746 = {{11{1'b0}}, proxy740};
  assign proxy751 = {11'h7ff, proxy740};
  assign eq755 = proxy737 == 1'h1;
  assign sel757 = eq755 ? proxy751 : pad746;
  assign proxy761 = {proxy578, proxy564};
  assign pad763 = {{20{1'b0}}, proxy761};
  assign proxy768 = {20'hfffff, proxy761};
  assign proxy772 = proxy761[11];
  assign eq773 = proxy772 == 1'h1;
  assign sel775 = eq773 ? proxy768 : pad763;
  assign eq779 = proxy571 == 3'h0;
  assign lt783 = proxy584 < 12'h2;
  assign andl786 = eq779 & lt783;
  assign sel796 = andl786 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel797 = sel757;
      7'h67: sel797 = sel775;
      7'h73: sel797 = sel796;
      default: sel797 = 32'h7b;
    endcase
  end
  assign sel798 = andl786 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel799 = 1'h1;
      7'h67: sel799 = 1'h1;
      7'h73: sel799 = sel798;
      default: sel799 = 1'h0;
    endcase
  end
  assign ne801 = proxy571 != 3'h0;
  assign ge804 = proxy584 >= 12'h2;
  assign eq807 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign andl812 = ne801 & ge804;
  assign andl814 = andl812 & eq807;
  assign sel816 = andl814 ? proxy584 : 12'h7b;
  assign eq823 = proxy571 == 3'h5;
  assign eq828 = proxy571 == 3'h1;
  assign orl830 = eq828 | eq823;
  assign pad832 = {{7{1'b0}}, proxy564};
  assign sel834 = orl830 ? pad832 : proxy584;
  assign pad836 = {{20{1'b0}}, sel917};
  assign proxy840 = {20'hfffff, sel917};
  assign eq845 = sel917[11] == 1'h1;
  assign sel847 = eq845 ? proxy840 : pad836;
  assign proxy850 = {proxy578, proxy550};
  assign pad867 = {{20{1'b0}}, proxy584};
  assign proxy871 = {20'hfffff, proxy584};
  assign proxy875 = proxy584[11];
  assign eq876 = proxy875 == 1'h1;
  assign sel878 = eq876 ? proxy871 : pad867;
  assign proxy881 = io_in_instruction[7];
  assign shr885 = io_in_instruction >> 32'h8;
  assign proxy888 = shr885[3:0];
  assign proxy894 = shr575[5:0];
  assign proxy896 = {proxy737, proxy881, proxy894, proxy888};
  assign eq910 = proxy737 == 1'h1;
  assign sel912 = eq910 ? proxy840 : pad836;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel916 = sel847;
      7'h23: sel916 = sel847;
      7'h03: sel916 = sel878;
      7'h63: sel916 = sel912;
      default: sel916 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel917 = sel834;
      7'h23: sel917 = proxy850;
      7'h03: sel917 = 12'h0;
      7'h63: sel917 = proxy896;
      default: sel917 = 12'h0;
    endcase
  end
  always @(*) begin
    case (proxy571)
      3'h0: sel936 = 3'h1;
      3'h1: sel936 = 3'h2;
      3'h4: sel936 = 3'h3;
      3'h5: sel936 = 3'h4;
      3'h6: sel936 = 3'h5;
      3'h7: sel936 = 3'h6;
      default: sel936 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel937 = sel936;
      7'h6f: sel937 = 3'h0;
      7'h67: sel937 = 3'h0;
      default: sel937 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel938 = 1'h1;
      7'h6f: sel938 = 1'h1;
      7'h67: sel938 = 1'h1;
      default: sel938 = 1'h0;
    endcase
  end
  assign eq948 = proxy578 == 7'h0;
  assign sel950 = eq948 ? 4'h0 : 4'h1;
  assign sel953 = eq602 ? 4'h0 : sel950;
  assign sel970 = eq948 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy571)
      3'h0: sel978 = sel953;
      3'h1: sel978 = 4'h2;
      3'h2: sel978 = 4'h3;
      3'h3: sel978 = 4'h4;
      3'h4: sel978 = 4'h5;
      3'h5: sel978 = sel970;
      3'h6: sel978 = 4'h8;
      3'h7: sel978 = 4'h9;
      default: sel978 = 4'hf;
    endcase
  end
  assign proxy980 = proxy571[1:0];
  assign eq985 = proxy980 == 2'h3;
  assign sel987 = eq985 ? 4'hf : 4'hf;
  assign eq993 = proxy980 == 2'h2;
  assign sel995 = eq993 ? 4'he : sel987;
  assign eq1001 = proxy980 == 2'h1;
  assign sel1003 = eq1001 ? 4'hd : sel995;
  assign orl1007 = eq609 | eq597;
  assign sel1009 = orl1007 ? 4'h0 : sel978;
  assign sel1011 = andl646 ? sel1003 : sel1009;
  assign sel1015 = eq634 ? 4'hc : sel1011;
  assign sel1019 = eq629 ? 4'hb : sel1015;
  assign lt1025 = sel937 < 3'h5;
  assign sel1027 = lt1025 ? 4'h1 : 4'ha;
  assign sel1029 = eq614 ? sel1027 : sel1019;

  assign io_out_csr_address = sel816;
  assign io_out_is_csr = andl646;
  assign io_out_csr_mask = sel669;
  assign io_out_rd = proxy550;
  assign io_out_rs1 = proxy557;
  assign io_out_rd1 = sel665;
  assign io_out_rs2 = proxy564;
  assign io_out_rd2 = bindout496;
  assign io_out_wb = sel696;
  assign io_out_alu_op = sel1029;
  assign io_out_rs2_src = sel703;
  assign io_out_itype_immed = sel916;
  assign io_out_mem_read = sel707;
  assign io_out_mem_write = sel710;
  assign io_out_branch_type = sel937;
  assign io_out_branch_stall = sel938;
  assign io_out_jal = sel799;
  assign io_out_jal_offset = sel797;
  assign io_out_upper_immed = sel722;
  assign io_out_PC_next = add587;

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
  reg[4:0] reg1199, reg1208, reg1221;
  reg[31:0] reg1215, reg1227, reg1247, reg1260, reg1306, reg1312, reg1324;
  reg[3:0] reg1234;
  reg[1:0] reg1241;
  reg reg1254, reg1300, reg1318;
  reg[2:0] reg1267, reg1273, reg1280;
  reg[19:0] reg1287;
  reg[11:0] reg1294;
  wire eq1328, eq1332, orl1334, sel1362, sel1384, sel1390;
  wire[4:0] sel1337, sel1340, sel1346;
  wire[31:0] sel1343, sel1349, sel1359, sel1366, sel1387, sel1393, sel1396;
  wire[3:0] sel1353;
  wire[1:0] sel1356;
  wire[2:0] sel1369, sel1372, sel1375;
  wire[19:0] sel1378;
  wire[11:0] sel1381;

  always @ (posedge clk) begin
    if (reset)
      reg1199 <= 5'h0;
    else
      reg1199 <= sel1337;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1208 <= 5'h0;
    else
      reg1208 <= sel1340;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1215 <= 32'h0;
    else
      reg1215 <= sel1343;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1221 <= 5'h0;
    else
      reg1221 <= sel1346;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1227 <= 32'h0;
    else
      reg1227 <= sel1349;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1234 <= 4'h0;
    else
      reg1234 <= sel1353;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1241 <= 2'h0;
    else
      reg1241 <= sel1356;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1247 <= 32'h0;
    else
      reg1247 <= sel1359;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1254 <= 1'h0;
    else
      reg1254 <= sel1362;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1260 <= 32'h0;
    else
      reg1260 <= sel1366;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1267 <= 3'h7;
    else
      reg1267 <= sel1369;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1273 <= 3'h7;
    else
      reg1273 <= sel1372;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1280 <= 3'h0;
    else
      reg1280 <= sel1375;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1287 <= 20'h0;
    else
      reg1287 <= sel1378;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1294 <= 12'h0;
    else
      reg1294 <= sel1381;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1300 <= 1'h0;
    else
      reg1300 <= sel1384;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1306 <= 32'h0;
    else
      reg1306 <= sel1387;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1312 <= 32'h0;
    else
      reg1312 <= sel1396;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1318 <= 1'h0;
    else
      reg1318 <= sel1390;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1324 <= 32'h0;
    else
      reg1324 <= sel1393;
  end
  assign eq1328 = io_in_branch_stall == 1'h1;
  assign eq1332 = io_in_fwd_stall == 1'h1;
  assign orl1334 = eq1332 | eq1328;
  assign sel1337 = orl1334 ? 5'h0 : io_in_rd;
  assign sel1340 = orl1334 ? 5'h0 : io_in_rs1;
  assign sel1343 = orl1334 ? 32'h0 : io_in_rd1;
  assign sel1346 = orl1334 ? 5'h0 : io_in_rs2;
  assign sel1349 = orl1334 ? 32'h0 : io_in_rd2;
  assign sel1353 = orl1334 ? 4'hf : io_in_alu_op;
  assign sel1356 = orl1334 ? 2'h0 : io_in_wb;
  assign sel1359 = orl1334 ? 32'h0 : io_in_PC_next;
  assign sel1362 = orl1334 ? 1'h0 : io_in_rs2_src;
  assign sel1366 = orl1334 ? 32'h7b : io_in_itype_immed;
  assign sel1369 = orl1334 ? 3'h7 : io_in_mem_read;
  assign sel1372 = orl1334 ? 3'h7 : io_in_mem_write;
  assign sel1375 = orl1334 ? 3'h0 : io_in_branch_type;
  assign sel1378 = orl1334 ? 20'h0 : io_in_upper_immed;
  assign sel1381 = orl1334 ? 12'h0 : io_in_csr_address;
  assign sel1384 = orl1334 ? 1'h0 : io_in_is_csr;
  assign sel1387 = orl1334 ? 32'h0 : io_in_csr_mask;
  assign sel1390 = orl1334 ? 1'h0 : io_in_jal;
  assign sel1393 = orl1334 ? 32'h0 : io_in_jal_offset;
  assign sel1396 = orl1334 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1294;
  assign io_out_is_csr = reg1300;
  assign io_out_csr_mask = reg1306;
  assign io_out_rd = reg1199;
  assign io_out_rs1 = reg1208;
  assign io_out_rd1 = reg1215;
  assign io_out_rs2 = reg1221;
  assign io_out_rd2 = reg1227;
  assign io_out_alu_op = reg1234;
  assign io_out_wb = reg1241;
  assign io_out_rs2_src = reg1254;
  assign io_out_itype_immed = reg1260;
  assign io_out_mem_read = reg1267;
  assign io_out_mem_write = reg1273;
  assign io_out_branch_type = reg1280;
  assign io_out_upper_immed = reg1287;
  assign io_out_curr_PC = reg1312;
  assign io_out_jal = reg1318;
  assign io_out_jal_offset = reg1324;
  assign io_out_PC_next = reg1247;

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
  wire eq1602, lt1633, lt1642, ge1672, ne1707, orl1709, sel1711;
  wire[31:0] sel1605, proxy1610, add1613, add1616, sub1621, shl1625, sel1635, sel1644, xorl1649, shr1653, shr1658, orl1663, andl1668, add1681, orl1687, sub1691, andl1694, sel1699;
  reg[31:0] sel1698, sel1700;

  assign eq1602 = io_in_rs2_src == 1'h1;
  assign sel1605 = eq1602 ? io_in_itype_immed : io_in_rd2;
  assign proxy1610 = {io_in_upper_immed, 12'h0};
  assign add1613 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1616 = $signed(io_in_rd1) + $signed(sel1605);
  assign sub1621 = $signed(io_in_rd1) - $signed(sel1605);
  assign shl1625 = io_in_rd1 << sel1605;
  assign lt1633 = $signed(io_in_rd1) < $signed(sel1605);
  assign sel1635 = lt1633 ? 32'h1 : 32'h0;
  assign lt1642 = io_in_rd1 < sel1605;
  assign sel1644 = lt1642 ? 32'h1 : 32'h0;
  assign xorl1649 = io_in_rd1 ^ sel1605;
  assign shr1653 = io_in_rd1 >> sel1605;
  assign shr1658 = $signed(io_in_rd1) >> sel1605;
  assign orl1663 = io_in_rd1 | sel1605;
  assign andl1668 = sel1605 & io_in_rd1;
  assign ge1672 = io_in_rd1 >= sel1605;
  assign add1681 = $signed(io_in_curr_PC) + $signed(proxy1610);
  assign orl1687 = io_in_csr_data | io_in_csr_mask;
  assign sub1691 = 32'hffffffff - io_in_csr_mask;
  assign andl1694 = io_in_csr_data & sub1691;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1698 = 32'h7b;
      4'h1: sel1698 = 32'h7b;
      4'h2: sel1698 = 32'h7b;
      4'h3: sel1698 = 32'h7b;
      4'h4: sel1698 = 32'h7b;
      4'h5: sel1698 = 32'h7b;
      4'h6: sel1698 = 32'h7b;
      4'h7: sel1698 = 32'h7b;
      4'h8: sel1698 = 32'h7b;
      4'h9: sel1698 = 32'h7b;
      4'ha: sel1698 = 32'h7b;
      4'hb: sel1698 = 32'h7b;
      4'hc: sel1698 = 32'h7b;
      4'hd: sel1698 = io_in_csr_mask;
      4'he: sel1698 = orl1687;
      4'hf: sel1698 = andl1694;
      default: sel1698 = 32'h7b;
    endcase
  end
  assign sel1699 = ge1672 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1700 = add1616;
      4'h1: sel1700 = sub1621;
      4'h2: sel1700 = shl1625;
      4'h3: sel1700 = sel1635;
      4'h4: sel1700 = sel1644;
      4'h5: sel1700 = xorl1649;
      4'h6: sel1700 = shr1653;
      4'h7: sel1700 = shr1658;
      4'h8: sel1700 = orl1663;
      4'h9: sel1700 = andl1668;
      4'ha: sel1700 = sel1699;
      4'hb: sel1700 = proxy1610;
      4'hc: sel1700 = add1681;
      4'hd: sel1700 = io_in_csr_data;
      4'he: sel1700 = io_in_csr_data;
      4'hf: sel1700 = io_in_csr_data;
      default: sel1700 = 32'h0;
    endcase
  end
  assign ne1707 = io_in_branch_type != 3'h0;
  assign orl1709 = ne1707 | io_in_jal;
  assign sel1711 = orl1709 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1698;
  assign io_out_alu_result = sel1700;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1613;
  assign io_out_branch_offset = io_in_itype_immed;
  assign io_out_branch_stall = sel1711;
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
  reg[31:0] reg1906, reg1928, reg1940, reg1953, reg1986, reg1992, reg1998, reg2016;
  reg[4:0] reg1916, reg1922, reg1934;
  reg[1:0] reg1947;
  reg[2:0] reg1960, reg1966, reg2004;
  reg[11:0] reg1973;
  reg reg1980, reg2010;

  always @ (posedge clk) begin
    if (reset)
      reg1906 <= 32'h0;
    else
      reg1906 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1916 <= 5'h0;
    else
      reg1916 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1922 <= 5'h0;
    else
      reg1922 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1928 <= 32'h0;
    else
      reg1928 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1934 <= 5'h0;
    else
      reg1934 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1940 <= 32'h0;
    else
      reg1940 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1947 <= 2'h0;
    else
      reg1947 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1953 <= 32'h0;
    else
      reg1953 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1960 <= 3'h0;
    else
      reg1960 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1966 <= 3'h0;
    else
      reg1966 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1973 <= 12'h0;
    else
      reg1973 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1980 <= 1'h0;
    else
      reg1980 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1986 <= 32'h0;
    else
      reg1986 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1992 <= 32'h0;
    else
      reg1992 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1998 <= 32'h0;
    else
      reg1998 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2004 <= 3'h0;
    else
      reg2004 <= io_in_branch_type;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2010 <= 1'h0;
    else
      reg2010 <= io_in_jal;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2016 <= 32'h0;
    else
      reg2016 <= io_in_jal_dest;
  end

  assign io_out_csr_address = reg1973;
  assign io_out_is_csr = reg1980;
  assign io_out_csr_result = reg1986;
  assign io_out_alu_result = reg1906;
  assign io_out_rd = reg1916;
  assign io_out_wb = reg1947;
  assign io_out_rs1 = reg1922;
  assign io_out_rd1 = reg1928;
  assign io_out_rd2 = reg1940;
  assign io_out_rs2 = reg1934;
  assign io_out_mem_read = reg1960;
  assign io_out_mem_write = reg1966;
  assign io_out_curr_PC = reg1992;
  assign io_out_branch_offset = reg1998;
  assign io_out_branch_type = reg2004;
  assign io_out_jal = reg2010;
  assign io_out_jal_dest = reg2016;
  assign io_out_PC_next = reg1953;

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
  wire lt2233, lt2236, orl2238, eq2246, eq2260, eq2264, andl2266, eq2287, eq2291, andl2293, orl2296, proxy2313, eq2314, proxy2331, eq2332;
  wire[1:0] sel2272, sel2276, sel2280;
  wire[7:0] proxy2305;
  wire[31:0] pad2306, proxy2309, sel2316, pad2324, proxy2327, sel2334;
  wire[15:0] proxy2323;
  reg[31:0] sel2350;

  assign lt2233 = io_in_mem_write < 3'h7;
  assign lt2236 = io_in_mem_read < 3'h7;
  assign orl2238 = lt2236 | lt2233;
  assign eq2246 = io_in_mem_write == 3'h2;
  assign eq2260 = io_in_mem_write == 3'h7;
  assign eq2264 = io_in_mem_read == 3'h7;
  assign andl2266 = eq2264 & eq2260;
  assign sel2272 = andl2266 ? 2'h0 : 2'h3;
  assign sel2276 = eq2246 ? 2'h2 : sel2272;
  assign sel2280 = lt2236 ? 2'h1 : sel2276;
  assign eq2287 = eq2246 == 1'h0;
  assign eq2291 = andl2266 == 1'h0;
  assign andl2293 = eq2291 & eq2287;
  assign orl2296 = lt2236 | andl2293;
  assign proxy2305 = io_DBUS_in_data_data[7:0];
  assign pad2306 = {{24{1'b0}}, proxy2305};
  assign proxy2309 = {24'hffffff, proxy2305};
  assign proxy2313 = proxy2305[7];
  assign eq2314 = proxy2313 == 1'h1;
  assign sel2316 = eq2314 ? proxy2309 : pad2306;
  assign proxy2323 = io_DBUS_in_data_data[15:0];
  assign pad2324 = {{16{1'b0}}, proxy2323};
  assign proxy2327 = {16'hffff, proxy2323};
  assign proxy2331 = proxy2323[15];
  assign eq2332 = proxy2331 == 1'h1;
  assign sel2334 = eq2332 ? proxy2327 : pad2324;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2350 = sel2316;
      3'h1: sel2350 = sel2334;
      3'h2: sel2350 = io_DBUS_in_data_data;
      3'h4: sel2350 = pad2306;
      3'h5: sel2350 = pad2324;
      default: sel2350 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2296;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2233;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2238;
  assign io_DBUS_out_control_data = sel2280;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2350;

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
  wire[31:0] bindin2357, bindout2366, bindout2375, bindin2393, bindin2402, bindout2405, shl2408, add2410;
  wire bindin2360, bindout2363, bindout2369, bindin2372, bindout2378, bindin2381, bindout2387, bindin2390, eq2420, sel2422, sel2431, eq2438, sel2440, sel2449, eq2477, sel2479;
  wire[1:0] bindout2384;
  wire[2:0] bindin2396, bindin2399;
  reg sel2472;

  Cache __module10__(.io_DBUS_in_data_data(bindin2357), .io_DBUS_in_data_valid(bindin2360), .io_DBUS_out_data_ready(bindin2372), .io_DBUS_out_address_ready(bindin2381), .io_DBUS_out_control_ready(bindin2390), .io_in_address(bindin2393), .io_in_mem_read(bindin2396), .io_in_mem_write(bindin2399), .io_in_data(bindin2402), .io_DBUS_in_data_ready(bindout2363), .io_DBUS_out_data_data(bindout2366), .io_DBUS_out_data_valid(bindout2369), .io_DBUS_out_address_data(bindout2375), .io_DBUS_out_address_valid(bindout2378), .io_DBUS_out_control_data(bindout2384), .io_DBUS_out_control_valid(bindout2387), .io_out_data(bindout2405));
  assign bindin2357 = io_DBUS_in_data_data;
  assign bindin2360 = io_DBUS_in_data_valid;
  assign bindin2372 = io_DBUS_out_data_ready;
  assign bindin2381 = io_DBUS_out_address_ready;
  assign bindin2390 = io_DBUS_out_control_ready;
  assign bindin2393 = io_in_alu_result;
  assign bindin2396 = io_in_mem_read;
  assign bindin2399 = io_in_mem_write;
  assign bindin2402 = io_in_rd2;
  assign shl2408 = $signed(io_in_branch_offset) << 32'h1;
  assign add2410 = $signed(io_in_curr_PC) + $signed(shl2408);
  assign eq2420 = io_in_alu_result == 32'h0;
  assign sel2422 = eq2420 ? 1'h1 : 1'h0;
  assign sel2431 = eq2420 ? 1'h0 : 1'h1;
  assign eq2438 = io_in_alu_result[31] == 1'h0;
  assign sel2440 = eq2438 ? 1'h0 : 1'h1;
  assign sel2449 = eq2438 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2472 = sel2422;
      3'h2: sel2472 = sel2431;
      3'h3: sel2472 = sel2440;
      3'h4: sel2472 = sel2449;
      3'h5: sel2472 = sel2440;
      3'h6: sel2472 = sel2449;
      3'h0: sel2472 = 1'h0;
      default: sel2472 = 1'h0;
    endcase
  end
  assign eq2477 = io_in_branch_type == 3'h0;
  assign sel2479 = eq2477 ? 1'h0 : 1'h1;

  assign io_DBUS_in_data_ready = bindout2363;
  assign io_DBUS_out_data_data = bindout2366;
  assign io_DBUS_out_data_valid = bindout2369;
  assign io_DBUS_out_address_data = bindout2375;
  assign io_DBUS_out_address_valid = bindout2378;
  assign io_DBUS_out_control_data = bindout2384;
  assign io_DBUS_out_control_valid = bindout2387;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2405;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2472;
  assign io_out_branch_dest = add2410;
  assign io_out_branch_stall = sel2479;
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
  reg[31:0] reg2629, reg2638, reg2670, reg2683;
  reg[4:0] reg2645, reg2651, reg2657;
  reg[1:0] reg2664;
  reg reg2677;

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
  always @ (posedge clk) begin
    if (reset)
      reg2677 <= 1'h0;
    else
      reg2677 <= io_in_branch_dir;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2683 <= 32'h0;
    else
      reg2683 <= io_in_branch_dest;
  end

  assign io_out_alu_result = reg2629;
  assign io_out_mem_result = reg2638;
  assign io_out_rd = reg2645;
  assign io_out_wb = reg2664;
  assign io_out_rs1 = reg2651;
  assign io_out_rs2 = reg2657;
  assign io_out_branch_dir = reg2677;
  assign io_out_branch_dest = reg2683;
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
  wire eq2761, eq2766;
  wire[31:0] sel2768, sel2770;

  assign eq2761 = io_in_wb == 2'h3;
  assign eq2766 = io_in_wb == 2'h1;
  assign sel2768 = eq2766 ? io_in_alu_result : io_in_mem_result;
  assign sel2770 = eq2761 ? io_in_PC_next : sel2768;

  assign io_out_write_data = sel2770;
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
  wire eq2867, eq2871, ne2876, ne2881, eq2884, andl2886, andl2888, eq2893, ne2897, eq2904, andl2906, andl2908, andl2910, eq2914, ne2922, eq2929, andl2931, andl2933, andl2935, andl2937, orl2940, orl2942, ne2950, eq2953, andl2955, andl2957, eq2961, eq2972, andl2974, andl2976, andl2978, eq2982, eq2997, andl2999, andl3001, andl3003, andl3005, orl3008, orl3010, eq3013, andl3015, eq3019, eq3022, andl3024, andl3026, orl3029, orl3036, orl3038, orl3040;

  assign eq2867 = io_in_execute_is_csr == 1'h1;
  assign eq2871 = io_in_memory_is_csr == 1'h1;
  assign ne2876 = io_in_execute_wb != 2'h0;
  assign ne2881 = io_in_decode_src1 != 5'h0;
  assign eq2884 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2886 = eq2884 & ne2881;
  assign andl2888 = andl2886 & ne2876;
  assign eq2893 = andl2888 == 1'h0;
  assign ne2897 = io_in_memory_wb != 2'h0;
  assign eq2904 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2906 = eq2904 & ne2881;
  assign andl2908 = andl2906 & ne2897;
  assign andl2910 = andl2908 & eq2893;
  assign eq2914 = andl2910 == 1'h0;
  assign ne2922 = io_in_writeback_wb != 2'h0;
  assign eq2929 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2931 = eq2929 & ne2881;
  assign andl2933 = andl2931 & ne2922;
  assign andl2935 = andl2933 & eq2893;
  assign andl2937 = andl2935 & eq2914;
  assign orl2940 = andl2888 | andl2910;
  assign orl2942 = orl2940 | andl2937;
  assign ne2950 = io_in_decode_src2 != 5'h0;
  assign eq2953 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2955 = eq2953 & ne2950;
  assign andl2957 = andl2955 & ne2876;
  assign eq2961 = andl2957 == 1'h0;
  assign eq2972 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2974 = eq2972 & ne2950;
  assign andl2976 = andl2974 & ne2897;
  assign andl2978 = andl2976 & eq2961;
  assign eq2982 = andl2978 == 1'h0;
  assign eq2997 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2999 = eq2997 & ne2950;
  assign andl3001 = andl2999 & ne2922;
  assign andl3003 = andl3001 & eq2961;
  assign andl3005 = andl3003 & eq2982;
  assign orl3008 = andl2957 | andl2978;
  assign orl3010 = orl3008 | andl3005;
  assign eq3013 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3015 = eq3013 & eq2867;
  assign eq3019 = andl3015 == 1'h0;
  assign eq3022 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3024 = eq3022 & eq2871;
  assign andl3026 = andl3024 & eq3019;
  assign orl3029 = andl3015 | andl3026;
  assign orl3036 = orl2942 | andl2957;
  assign orl3038 = orl3036 | andl2978;
  assign orl3040 = orl3038 | andl3005;

  assign io_out_src1_fwd = orl2942;
  assign io_out_src2_fwd = orl3010;
  assign io_out_csr_fwd = orl3029;
  assign io_out_fwd_stall = orl3040;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3135 [0:1];
  wire[31:0] mrport3137, sel3141;

  initial begin
    mem3135[0] = 32'hdeadbeef;
    mem3135[1] = 32'hdeadbeef;
  end
  assign mrport3137 = mem3135[io_INTERRUPT_in_interrupt_id_data];
  assign sel3141 = io_INTERRUPT_in_interrupt_id_valid ? mrport3137 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3141;

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
  reg[3:0] reg3209, sel3299;
  wire eq3217, andl3302, eq3306, andl3310, eq3314, andl3318;
  wire[3:0] sel3223, sel3228, sel3234, sel3240, sel3250, sel3255, sel3259, sel3268, sel3274, sel3284, sel3289, sel3293, sel3300, sel3316, sel3317, sel3319;

  always @ (posedge clk) begin
    if (reset)
      reg3209 <= 4'h0;
    else
      reg3209 <= sel3319;
  end
  assign eq3217 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3223 = eq3217 ? 4'h0 : 4'h1;
  assign sel3228 = eq3217 ? 4'h2 : 4'h1;
  assign sel3234 = eq3217 ? 4'h9 : 4'h3;
  assign sel3240 = eq3217 ? 4'h5 : 4'h4;
  assign sel3250 = eq3217 ? 4'h8 : 4'h6;
  assign sel3255 = eq3217 ? 4'h7 : 4'h6;
  assign sel3259 = eq3217 ? 4'h4 : 4'h8;
  assign sel3268 = eq3217 ? 4'h0 : 4'ha;
  assign sel3274 = eq3217 ? 4'hc : 4'hb;
  assign sel3284 = eq3217 ? 4'hf : 4'hd;
  assign sel3289 = eq3217 ? 4'he : 4'hd;
  assign sel3293 = eq3217 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3209)
      4'h0: sel3299 = sel3223;
      4'h1: sel3299 = sel3228;
      4'h2: sel3299 = sel3234;
      4'h3: sel3299 = sel3240;
      4'h4: sel3299 = sel3240;
      4'h5: sel3299 = sel3250;
      4'h6: sel3299 = sel3255;
      4'h7: sel3299 = sel3259;
      4'h8: sel3299 = sel3228;
      4'h9: sel3299 = sel3268;
      4'ha: sel3299 = sel3274;
      4'hb: sel3299 = sel3274;
      4'hc: sel3299 = sel3284;
      4'hd: sel3299 = sel3289;
      4'he: sel3299 = sel3293;
      4'hf: sel3299 = sel3228;
      default: sel3299 = reg3209;
    endcase
  end
  assign sel3300 = io_JTAG_TAP_in_mode_select_valid ? sel3299 : 4'h0;
  assign andl3302 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3306 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3310 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3314 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3316 = eq3306 ? 4'h0 : reg3209;
  assign sel3317 = andl3318 ? sel3300 : reg3209;
  assign andl3318 = andl3310 & eq3314;
  assign sel3319 = andl3302 ? sel3316 : sel3317;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3209;

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
  wire bindin3325, bindin3327, bindin3328, bindin3331, bindout3334, bindin3337, bindin3340, bindout3343, bindin3346, bindin3349, bindout3352, eq3389, eq3398, eq3403, eq3477, andl3478, sel3483, sel3489;
  wire[3:0] bindout3355;
  reg[31:0] reg3363, reg3370, reg3377, reg3384, sel3482;
  wire[31:0] sel3406, sel3408, shr3415, proxy3420, sel3475, sel3476, sel3479, sel3480, sel3481;
  wire[30:0] proxy3418;
  reg sel3488, sel3494;

  assign bindin3325 = clk;
  assign bindin3327 = reset;
  TAP __module16__(.clk(bindin3325), .reset(bindin3327), .io_JTAG_TAP_in_mode_select_data(bindin3328), .io_JTAG_TAP_in_mode_select_valid(bindin3331), .io_JTAG_TAP_in_clock_data(bindin3337), .io_JTAG_TAP_in_clock_valid(bindin3340), .io_JTAG_TAP_in_reset_data(bindin3346), .io_JTAG_TAP_in_reset_valid(bindin3349), .io_JTAG_TAP_in_mode_select_ready(bindout3334), .io_JTAG_TAP_in_clock_ready(bindout3343), .io_JTAG_TAP_in_reset_ready(bindout3352), .io_out_curr_state(bindout3355));
  assign bindin3328 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3331 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3337 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3340 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3346 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3349 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3363 <= 32'h0;
    else
      reg3363 <= sel3475;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3370 <= 32'h1234;
    else
      reg3370 <= sel3481;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3377 <= 32'h5678;
    else
      reg3377 <= sel3476;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3384 <= 32'h0;
    else
      reg3384 <= sel3482;
  end
  assign eq3389 = reg3363 == 32'h0;
  assign eq3398 = reg3363 == 32'h1;
  assign eq3403 = reg3363 == 32'h2;
  assign sel3406 = eq3403 ? reg3370 : 32'hdeadbeef;
  assign sel3408 = eq3398 ? reg3377 : sel3406;
  assign shr3415 = reg3384 >> 32'h1;
  assign proxy3418 = shr3415[30:0];
  assign proxy3420 = {io_JTAG_in_data_data, proxy3418};
  assign sel3475 = (bindout3355 == 4'hf) ? reg3384 : reg3363;
  assign sel3476 = andl3478 ? reg3384 : reg3377;
  assign eq3477 = bindout3355 == 4'h8;
  assign andl3478 = eq3477 & eq3398;
  assign sel3479 = eq3403 ? reg3384 : reg3370;
  assign sel3480 = eq3398 ? reg3370 : sel3479;
  assign sel3481 = (bindout3355 == 4'h8) ? sel3480 : reg3370;
  always @(*) begin
    case (bindout3355)
      4'h3: sel3482 = sel3408;
      4'h4: sel3482 = proxy3420;
      4'ha: sel3482 = reg3363;
      4'hb: sel3482 = proxy3420;
      default: sel3482 = reg3384;
    endcase
  end
  assign sel3483 = eq3389 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3355)
      4'h3: sel3488 = sel3483;
      4'h4: sel3488 = 1'h1;
      4'h8: sel3488 = sel3483;
      4'ha: sel3488 = sel3483;
      4'hb: sel3488 = 1'h1;
      4'hf: sel3488 = sel3483;
      default: sel3488 = sel3483;
    endcase
  end
  assign sel3489 = eq3389 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3355)
      4'h3: sel3494 = sel3489;
      4'h4: sel3494 = reg3384[0];
      4'h8: sel3494 = sel3489;
      4'ha: sel3494 = sel3489;
      4'hb: sel3494 = reg3384[0];
      4'hf: sel3494 = sel3489;
      default: sel3494 = sel3489;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3334;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3343;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3352;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3494;
  assign io_JTAG_out_data_valid = sel3488;

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
  reg[11:0] mem3550 [0:4095];
  reg[11:0] reg3559;
  wire[11:0] proxy3569, mrport3571;
  wire[31:0] pad3573;

  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem3550[io_in_mem_csr_address] <= proxy3569;
    end
  end
  assign mrport3571 = mem3550[reg3559];
  always @ (posedge clk) begin
    if (reset)
      reg3559 <= 12'h0;
    else
      reg3559 <= io_in_decode_csr_address;
  end
  assign proxy3569 = io_in_mem_csr_result[11:0];
  assign pad3573 = {{20{1'b0}}, mrport3571};

  assign io_out_decode_csr_data = pad3573;

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
  wire bindin230, bindin232, bindin236, bindout239, bindout245, bindin248, bindin251, bindin257, bindin260, bindin263, bindin266, bindin272, bindin336, bindin337, bindin344, bindin347, bindin350, bindin1034, bindin1041, bindout1056, bindout1083, bindout1098, bindout1101, bindin1401, bindin1402, bindin1424, bindin1442, bindin1445, bindin1454, bindin1463, bindout1472, bindout1499, bindout1520, bindin1737, bindin1761, bindin1770, bindout1782, bindout1815, bindout1824, bindin2021, bindin2022, bindin2056, bindin2071, bindout2080, bindout2122, bindin2487, bindout2490, bindout2496, bindin2499, bindout2505, bindin2508, bindout2514, bindin2517, bindout2577, bindout2583, bindin2688, bindin2689, bindin2711, bindout2735, bindin3066, bindin3090, bindout3123, bindin3145, bindin3148, bindout3151, bindout3154, bindin3498, bindin3499, bindin3500, bindin3503, bindout3506, bindin3509, bindin3512, bindout3515, bindin3518, bindin3521, bindout3524, bindin3527, bindin3530, bindout3533, bindout3536, bindout3539, bindin3542, bindin3578, bindin3579, bindin3586, orl3594, orl3596, eq3601, orl3603, orl3606;
  wire[31:0] bindin233, bindout242, bindin254, bindin269, bindin275, bindout278, bindout281, bindin338, bindin341, bindout353, bindout356, bindin1035, bindin1038, bindin1044, bindout1059, bindout1068, bindout1074, bindout1086, bindout1104, bindout1110, bindin1409, bindin1415, bindin1427, bindin1436, bindin1457, bindin1460, bindin1466, bindout1475, bindout1484, bindout1490, bindout1502, bindout1517, bindout1523, bindout1526, bindin1722, bindin1728, bindin1740, bindin1749, bindin1764, bindin1767, bindin1773, bindin1776, bindout1785, bindout1788, bindout1800, bindout1806, bindout1818, bindout1821, bindout1827, bindin2023, bindin2035, bindin2041, bindin2050, bindin2059, bindin2062, bindin2065, bindin2074, bindout2083, bindout2086, bindout2098, bindout2101, bindout2113, bindout2116, bindout2125, bindout2128, bindin2484, bindout2493, bindout2502, bindin2520, bindin2538, bindin2544, bindin2547, bindin2550, bindin2553, bindout2559, bindout2562, bindout2580, bindout2586, bindin2690, bindin2693, bindin2708, bindin2714, bindout2717, bindout2720, bindout2738, bindout2741, bindin2775, bindin2778, bindin2793, bindout2796, bindin3060, bindin3063, bindin3072, bindin3081, bindin3084, bindin3087, bindin3096, bindin3105, bindin3108, bindin3111, bindout3157, bindin3589, bindout3592;
  wire[4:0] bindin1047, bindout1062, bindout1065, bindout1071, bindin1403, bindin1406, bindin1412, bindout1478, bindout1481, bindout1487, bindin1716, bindin1719, bindin1725, bindout1791, bindout1797, bindout1803, bindin2026, bindin2032, bindin2038, bindout2089, bindout2095, bindout2104, bindin2529, bindin2535, bindin2541, bindout2565, bindout2571, bindout2574, bindin2696, bindin2702, bindin2705, bindout2723, bindout2729, bindout2732, bindin2781, bindin2787, bindin2790, bindout2799, bindin3045, bindin3048, bindin3054, bindin3075, bindin3099;
  wire[1:0] bindin1050, bindout1077, bindin1421, bindout1496, bindin1734, bindout1794, bindin2029, bindout2092, bindout2511, bindin2532, bindout2568, bindin2699, bindout2726, bindin2784, bindout2802, bindin3057, bindin3078, bindin3102;
  wire[11:0] bindout1053, bindin1451, bindout1469, bindin1758, bindout1779, bindin2053, bindout2077, bindin3051, bindin3069, bindin3093, bindin3580, bindin3583;
  wire[3:0] bindout1080, bindin1418, bindout1493, bindin1731;
  wire[2:0] bindout1089, bindout1092, bindout1095, bindin1430, bindin1433, bindin1439, bindout1505, bindout1508, bindout1511, bindin1743, bindin1746, bindin1752, bindout1809, bindout1812, bindin2044, bindin2047, bindin2068, bindout2107, bindout2110, bindout2119, bindin2523, bindin2526, bindin2556;
  wire[19:0] bindout1107, bindin1448, bindout1514, bindin1755;

  assign bindin230 = clk;
  assign bindin232 = reset;
  Fetch __module2__(.clk(bindin230), .reset(bindin232), .io_IBUS_in_data_data(bindin233), .io_IBUS_in_data_valid(bindin236), .io_IBUS_out_address_ready(bindin248), .io_in_branch_dir(bindin251), .io_in_branch_dest(bindin254), .io_in_branch_stall(bindin257), .io_in_fwd_stall(bindin260), .io_in_branch_stall_exe(bindin263), .io_in_jal(bindin266), .io_in_jal_dest(bindin269), .io_in_interrupt(bindin272), .io_in_interrupt_pc(bindin275), .io_IBUS_in_data_ready(bindout239), .io_IBUS_out_address_data(bindout242), .io_IBUS_out_address_valid(bindout245), .io_out_instruction(bindout278), .io_out_curr_PC(bindout281));
  assign bindin233 = io_IBUS_in_data_data;
  assign bindin236 = io_IBUS_in_data_valid;
  assign bindin248 = io_IBUS_out_address_ready;
  assign bindin251 = bindout2735;
  assign bindin254 = bindout2738;
  assign bindin257 = bindout1098;
  assign bindin260 = bindout3123;
  assign bindin263 = orl3606;
  assign bindin266 = bindout2122;
  assign bindin269 = bindout2125;
  assign bindin272 = bindout3154;
  assign bindin275 = bindout3157;
  assign bindin336 = clk;
  assign bindin337 = reset;
  F_D_Register __module3__(.clk(bindin336), .reset(bindin337), .io_in_instruction(bindin338), .io_in_curr_PC(bindin341), .io_in_branch_stall(bindin344), .io_in_branch_stall_exe(bindin347), .io_in_fwd_stall(bindin350), .io_out_instruction(bindout353), .io_out_curr_PC(bindout356));
  assign bindin338 = bindout278;
  assign bindin341 = bindout281;
  assign bindin344 = bindout1098;
  assign bindin347 = orl3606;
  assign bindin350 = bindout3123;
  assign bindin1034 = clk;
  Decode __module4__(.clk(bindin1034), .io_in_instruction(bindin1035), .io_in_curr_PC(bindin1038), .io_in_stall(bindin1041), .io_in_write_data(bindin1044), .io_in_rd(bindin1047), .io_in_wb(bindin1050), .io_out_csr_address(bindout1053), .io_out_is_csr(bindout1056), .io_out_csr_mask(bindout1059), .io_out_rd(bindout1062), .io_out_rs1(bindout1065), .io_out_rd1(bindout1068), .io_out_rs2(bindout1071), .io_out_rd2(bindout1074), .io_out_wb(bindout1077), .io_out_alu_op(bindout1080), .io_out_rs2_src(bindout1083), .io_out_itype_immed(bindout1086), .io_out_mem_read(bindout1089), .io_out_mem_write(bindout1092), .io_out_branch_type(bindout1095), .io_out_branch_stall(bindout1098), .io_out_jal(bindout1101), .io_out_jal_offset(bindout1104), .io_out_upper_immed(bindout1107), .io_out_PC_next(bindout1110));
  assign bindin1035 = bindout353;
  assign bindin1038 = bindout356;
  assign bindin1041 = orl3603;
  assign bindin1044 = bindout2796;
  assign bindin1047 = bindout2799;
  assign bindin1050 = bindout2802;
  assign bindin1401 = clk;
  assign bindin1402 = reset;
  D_E_Register __module6__(.clk(bindin1401), .reset(bindin1402), .io_in_rd(bindin1403), .io_in_rs1(bindin1406), .io_in_rd1(bindin1409), .io_in_rs2(bindin1412), .io_in_rd2(bindin1415), .io_in_alu_op(bindin1418), .io_in_wb(bindin1421), .io_in_rs2_src(bindin1424), .io_in_itype_immed(bindin1427), .io_in_mem_read(bindin1430), .io_in_mem_write(bindin1433), .io_in_PC_next(bindin1436), .io_in_branch_type(bindin1439), .io_in_fwd_stall(bindin1442), .io_in_branch_stall(bindin1445), .io_in_upper_immed(bindin1448), .io_in_csr_address(bindin1451), .io_in_is_csr(bindin1454), .io_in_csr_mask(bindin1457), .io_in_curr_PC(bindin1460), .io_in_jal(bindin1463), .io_in_jal_offset(bindin1466), .io_out_csr_address(bindout1469), .io_out_is_csr(bindout1472), .io_out_csr_mask(bindout1475), .io_out_rd(bindout1478), .io_out_rs1(bindout1481), .io_out_rd1(bindout1484), .io_out_rs2(bindout1487), .io_out_rd2(bindout1490), .io_out_alu_op(bindout1493), .io_out_wb(bindout1496), .io_out_rs2_src(bindout1499), .io_out_itype_immed(bindout1502), .io_out_mem_read(bindout1505), .io_out_mem_write(bindout1508), .io_out_branch_type(bindout1511), .io_out_upper_immed(bindout1514), .io_out_curr_PC(bindout1517), .io_out_jal(bindout1520), .io_out_jal_offset(bindout1523), .io_out_PC_next(bindout1526));
  assign bindin1403 = bindout1062;
  assign bindin1406 = bindout1065;
  assign bindin1409 = bindout1068;
  assign bindin1412 = bindout1071;
  assign bindin1415 = bindout1074;
  assign bindin1418 = bindout1080;
  assign bindin1421 = bindout1077;
  assign bindin1424 = bindout1083;
  assign bindin1427 = bindout1086;
  assign bindin1430 = bindout1089;
  assign bindin1433 = bindout1092;
  assign bindin1436 = bindout1110;
  assign bindin1439 = bindout1095;
  assign bindin1442 = bindout3123;
  assign bindin1445 = orl3606;
  assign bindin1448 = bindout1107;
  assign bindin1451 = bindout1053;
  assign bindin1454 = bindout1056;
  assign bindin1457 = bindout1059;
  assign bindin1460 = bindout356;
  assign bindin1463 = bindout1101;
  assign bindin1466 = bindout1104;
  Execute __module7__(.io_in_rd(bindin1716), .io_in_rs1(bindin1719), .io_in_rd1(bindin1722), .io_in_rs2(bindin1725), .io_in_rd2(bindin1728), .io_in_alu_op(bindin1731), .io_in_wb(bindin1734), .io_in_rs2_src(bindin1737), .io_in_itype_immed(bindin1740), .io_in_mem_read(bindin1743), .io_in_mem_write(bindin1746), .io_in_PC_next(bindin1749), .io_in_branch_type(bindin1752), .io_in_upper_immed(bindin1755), .io_in_csr_address(bindin1758), .io_in_is_csr(bindin1761), .io_in_csr_data(bindin1764), .io_in_csr_mask(bindin1767), .io_in_jal(bindin1770), .io_in_jal_offset(bindin1773), .io_in_curr_PC(bindin1776), .io_out_csr_address(bindout1779), .io_out_is_csr(bindout1782), .io_out_csr_result(bindout1785), .io_out_alu_result(bindout1788), .io_out_rd(bindout1791), .io_out_wb(bindout1794), .io_out_rs1(bindout1797), .io_out_rd1(bindout1800), .io_out_rs2(bindout1803), .io_out_rd2(bindout1806), .io_out_mem_read(bindout1809), .io_out_mem_write(bindout1812), .io_out_jal(bindout1815), .io_out_jal_dest(bindout1818), .io_out_branch_offset(bindout1821), .io_out_branch_stall(bindout1824), .io_out_PC_next(bindout1827));
  assign bindin1716 = bindout1478;
  assign bindin1719 = bindout1481;
  assign bindin1722 = bindout1484;
  assign bindin1725 = bindout1487;
  assign bindin1728 = bindout1490;
  assign bindin1731 = bindout1493;
  assign bindin1734 = bindout1496;
  assign bindin1737 = bindout1499;
  assign bindin1740 = bindout1502;
  assign bindin1743 = bindout1505;
  assign bindin1746 = bindout1508;
  assign bindin1749 = bindout1526;
  assign bindin1752 = bindout1511;
  assign bindin1755 = bindout1514;
  assign bindin1758 = bindout1469;
  assign bindin1761 = bindout1472;
  assign bindin1764 = bindout3592;
  assign bindin1767 = bindout1475;
  assign bindin1770 = bindout1520;
  assign bindin1773 = bindout1523;
  assign bindin1776 = bindout1517;
  assign bindin2021 = clk;
  assign bindin2022 = reset;
  E_M_Register __module8__(.clk(bindin2021), .reset(bindin2022), .io_in_alu_result(bindin2023), .io_in_rd(bindin2026), .io_in_wb(bindin2029), .io_in_rs1(bindin2032), .io_in_rd1(bindin2035), .io_in_rs2(bindin2038), .io_in_rd2(bindin2041), .io_in_mem_read(bindin2044), .io_in_mem_write(bindin2047), .io_in_PC_next(bindin2050), .io_in_csr_address(bindin2053), .io_in_is_csr(bindin2056), .io_in_csr_result(bindin2059), .io_in_curr_PC(bindin2062), .io_in_branch_offset(bindin2065), .io_in_branch_type(bindin2068), .io_in_jal(bindin2071), .io_in_jal_dest(bindin2074), .io_out_csr_address(bindout2077), .io_out_is_csr(bindout2080), .io_out_csr_result(bindout2083), .io_out_alu_result(bindout2086), .io_out_rd(bindout2089), .io_out_wb(bindout2092), .io_out_rs1(bindout2095), .io_out_rd1(bindout2098), .io_out_rd2(bindout2101), .io_out_rs2(bindout2104), .io_out_mem_read(bindout2107), .io_out_mem_write(bindout2110), .io_out_curr_PC(bindout2113), .io_out_branch_offset(bindout2116), .io_out_branch_type(bindout2119), .io_out_jal(bindout2122), .io_out_jal_dest(bindout2125), .io_out_PC_next(bindout2128));
  assign bindin2023 = bindout1788;
  assign bindin2026 = bindout1791;
  assign bindin2029 = bindout1794;
  assign bindin2032 = bindout1797;
  assign bindin2035 = bindout1800;
  assign bindin2038 = bindout1803;
  assign bindin2041 = bindout1806;
  assign bindin2044 = bindout1809;
  assign bindin2047 = bindout1812;
  assign bindin2050 = bindout1827;
  assign bindin2053 = bindout1779;
  assign bindin2056 = bindout1782;
  assign bindin2059 = bindout1785;
  assign bindin2062 = bindout1517;
  assign bindin2065 = bindout1821;
  assign bindin2068 = bindout1511;
  assign bindin2071 = bindout1815;
  assign bindin2074 = bindout1818;
  Memory __module9__(.io_DBUS_in_data_data(bindin2484), .io_DBUS_in_data_valid(bindin2487), .io_DBUS_out_data_ready(bindin2499), .io_DBUS_out_address_ready(bindin2508), .io_DBUS_out_control_ready(bindin2517), .io_in_alu_result(bindin2520), .io_in_mem_read(bindin2523), .io_in_mem_write(bindin2526), .io_in_rd(bindin2529), .io_in_wb(bindin2532), .io_in_rs1(bindin2535), .io_in_rd1(bindin2538), .io_in_rs2(bindin2541), .io_in_rd2(bindin2544), .io_in_PC_next(bindin2547), .io_in_curr_PC(bindin2550), .io_in_branch_offset(bindin2553), .io_in_branch_type(bindin2556), .io_DBUS_in_data_ready(bindout2490), .io_DBUS_out_data_data(bindout2493), .io_DBUS_out_data_valid(bindout2496), .io_DBUS_out_address_data(bindout2502), .io_DBUS_out_address_valid(bindout2505), .io_DBUS_out_control_data(bindout2511), .io_DBUS_out_control_valid(bindout2514), .io_out_alu_result(bindout2559), .io_out_mem_result(bindout2562), .io_out_rd(bindout2565), .io_out_wb(bindout2568), .io_out_rs1(bindout2571), .io_out_rs2(bindout2574), .io_out_branch_dir(bindout2577), .io_out_branch_dest(bindout2580), .io_out_branch_stall(bindout2583), .io_out_PC_next(bindout2586));
  assign bindin2484 = io_DBUS_in_data_data;
  assign bindin2487 = io_DBUS_in_data_valid;
  assign bindin2499 = io_DBUS_out_data_ready;
  assign bindin2508 = io_DBUS_out_address_ready;
  assign bindin2517 = io_DBUS_out_control_ready;
  assign bindin2520 = bindout2086;
  assign bindin2523 = bindout2107;
  assign bindin2526 = bindout2110;
  assign bindin2529 = bindout2089;
  assign bindin2532 = bindout2092;
  assign bindin2535 = bindout2095;
  assign bindin2538 = bindout2098;
  assign bindin2541 = bindout2104;
  assign bindin2544 = bindout2101;
  assign bindin2547 = bindout2128;
  assign bindin2550 = bindout2113;
  assign bindin2553 = bindout2116;
  assign bindin2556 = bindout2119;
  assign bindin2688 = clk;
  assign bindin2689 = reset;
  M_W_Register __module11__(.clk(bindin2688), .reset(bindin2689), .io_in_alu_result(bindin2690), .io_in_mem_result(bindin2693), .io_in_rd(bindin2696), .io_in_wb(bindin2699), .io_in_rs1(bindin2702), .io_in_rs2(bindin2705), .io_in_PC_next(bindin2708), .io_in_branch_dir(bindin2711), .io_in_branch_dest(bindin2714), .io_out_alu_result(bindout2717), .io_out_mem_result(bindout2720), .io_out_rd(bindout2723), .io_out_wb(bindout2726), .io_out_rs1(bindout2729), .io_out_rs2(bindout2732), .io_out_branch_dir(bindout2735), .io_out_branch_dest(bindout2738), .io_out_PC_next(bindout2741));
  assign bindin2690 = bindout2559;
  assign bindin2693 = bindout2562;
  assign bindin2696 = bindout2565;
  assign bindin2699 = bindout2568;
  assign bindin2702 = bindout2571;
  assign bindin2705 = bindout2574;
  assign bindin2708 = bindout2586;
  assign bindin2711 = bindout2577;
  assign bindin2714 = bindout2580;
  Write_Back __module12__(.io_in_alu_result(bindin2775), .io_in_mem_result(bindin2778), .io_in_rd(bindin2781), .io_in_wb(bindin2784), .io_in_rs1(bindin2787), .io_in_rs2(bindin2790), .io_in_PC_next(bindin2793), .io_out_write_data(bindout2796), .io_out_rd(bindout2799), .io_out_wb(bindout2802));
  assign bindin2775 = bindout2717;
  assign bindin2778 = bindout2720;
  assign bindin2781 = bindout2723;
  assign bindin2784 = bindout2726;
  assign bindin2787 = bindout2729;
  assign bindin2790 = bindout2732;
  assign bindin2793 = bindout2741;
  Forwarding __module13__(.io_in_decode_src1(bindin3045), .io_in_decode_src2(bindin3048), .io_in_decode_csr_address(bindin3051), .io_in_execute_dest(bindin3054), .io_in_execute_wb(bindin3057), .io_in_execute_alu_result(bindin3060), .io_in_execute_PC_next(bindin3063), .io_in_execute_is_csr(bindin3066), .io_in_execute_csr_address(bindin3069), .io_in_execute_csr_result(bindin3072), .io_in_memory_dest(bindin3075), .io_in_memory_wb(bindin3078), .io_in_memory_alu_result(bindin3081), .io_in_memory_mem_data(bindin3084), .io_in_memory_PC_next(bindin3087), .io_in_memory_is_csr(bindin3090), .io_in_memory_csr_address(bindin3093), .io_in_memory_csr_result(bindin3096), .io_in_writeback_dest(bindin3099), .io_in_writeback_wb(bindin3102), .io_in_writeback_alu_result(bindin3105), .io_in_writeback_mem_data(bindin3108), .io_in_writeback_PC_next(bindin3111), .io_out_fwd_stall(bindout3123));
  assign bindin3045 = bindout1065;
  assign bindin3048 = bindout1071;
  assign bindin3051 = bindout1053;
  assign bindin3054 = bindout1791;
  assign bindin3057 = bindout1794;
  assign bindin3060 = bindout1788;
  assign bindin3063 = bindout1827;
  assign bindin3066 = bindout1782;
  assign bindin3069 = bindout1779;
  assign bindin3072 = bindout1785;
  assign bindin3075 = bindout2565;
  assign bindin3078 = bindout2568;
  assign bindin3081 = bindout2559;
  assign bindin3084 = bindout2562;
  assign bindin3087 = bindout2586;
  assign bindin3090 = bindout2080;
  assign bindin3093 = bindout2077;
  assign bindin3096 = bindout2083;
  assign bindin3099 = bindout2723;
  assign bindin3102 = bindout2726;
  assign bindin3105 = bindout2717;
  assign bindin3108 = bindout2720;
  assign bindin3111 = bindout2741;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3145), .io_INTERRUPT_in_interrupt_id_valid(bindin3148), .io_INTERRUPT_in_interrupt_id_ready(bindout3151), .io_out_interrupt(bindout3154), .io_out_interrupt_pc(bindout3157));
  assign bindin3145 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3148 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3498 = clk;
  assign bindin3499 = reset;
  JTAG __module15__(.clk(bindin3498), .reset(bindin3499), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3500), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3503), .io_JTAG_JTAG_TAP_in_clock_data(bindin3509), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3512), .io_JTAG_JTAG_TAP_in_reset_data(bindin3518), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3521), .io_JTAG_in_data_data(bindin3527), .io_JTAG_in_data_valid(bindin3530), .io_JTAG_out_data_ready(bindin3542), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3506), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3515), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3524), .io_JTAG_in_data_ready(bindout3533), .io_JTAG_out_data_data(bindout3536), .io_JTAG_out_data_valid(bindout3539));
  assign bindin3500 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3503 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3509 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3512 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3518 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3521 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3527 = io_jtag_in_data_data;
  assign bindin3530 = io_jtag_in_data_valid;
  assign bindin3542 = io_jtag_out_data_ready;
  assign bindin3578 = clk;
  assign bindin3579 = reset;
  CSR_Handler __module17__(.clk(bindin3578), .reset(bindin3579), .io_in_decode_csr_address(bindin3580), .io_in_mem_csr_address(bindin3583), .io_in_mem_is_csr(bindin3586), .io_in_mem_csr_result(bindin3589), .io_out_decode_csr_data(bindout3592));
  assign bindin3580 = bindout1053;
  assign bindin3583 = bindout2077;
  assign bindin3586 = bindout2080;
  assign bindin3589 = bindout2083;
  assign orl3594 = bindout1098 | bindout1824;
  assign orl3596 = orl3594 | bindout2583;
  assign eq3601 = bindout1824 == 1'h1;
  assign orl3603 = eq3601 | bindout2583;
  assign orl3606 = bindout1824 | bindout2583;

  assign io_IBUS_in_data_ready = bindout239;
  assign io_IBUS_out_address_data = bindout242;
  assign io_IBUS_out_address_valid = bindout245;
  assign io_DBUS_in_data_ready = bindout2490;
  assign io_DBUS_out_data_data = bindout2493;
  assign io_DBUS_out_data_valid = bindout2496;
  assign io_DBUS_out_address_data = bindout2502;
  assign io_DBUS_out_address_valid = bindout2505;
  assign io_DBUS_out_control_data = bindout2511;
  assign io_DBUS_out_control_valid = bindout2514;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3151;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3506;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3515;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3524;
  assign io_jtag_in_data_ready = bindout3533;
  assign io_jtag_out_data_data = bindout3536;
  assign io_jtag_out_data_valid = bindout3539;
  assign io_out_fwd_stall = bindout3123;
  assign io_out_branch_stall = orl3596;

endmodule
