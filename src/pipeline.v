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
  reg[31:0] reg113;
  wire eq120, eq124, orl126, orl128, eq135, eq141;
  wire[31:0] sel131, sel137, sel143, sel145, add150, sel152;

  always @ (posedge clk) begin
    if (reset)
      reg113 <= 32'h0;
    else
      reg113 <= sel152;
  end
  assign eq120 = io_in_fwd_stall == 1'h1;
  assign eq124 = io_in_branch_stall == 1'h1;
  assign orl126 = eq124 | eq120;
  assign orl128 = orl126 | io_in_branch_stall_exe;
  assign sel131 = orl128 ? 32'h0 : io_IBUS_in_data_data;
  assign eq135 = io_in_branch_dir == 1'h1;
  assign sel137 = eq135 ? io_in_branch_dest : reg113;
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
  input wire io_in_branch_stall_exe,
  input wire io_in_fwd_stall,
  output wire[31:0] io_out_instruction,
  output wire[31:0] io_out_curr_PC,
  output wire[31:0] io_out_PC_next
);
  reg[31:0] reg235, reg244, reg250;
  wire eq271;
  wire[31:0] sel273, sel274, sel275;

  always @ (posedge clk) begin
    if (reset)
      reg235 <= 32'h0;
    else
      reg235 <= sel274;
  end
  always @ (posedge clk) begin
    if (reset)
      reg244 <= 32'h0;
    else
      reg244 <= sel275;
  end
  always @ (posedge clk) begin
    if (reset)
      reg250 <= 32'h0;
    else
      reg250 <= sel273;
  end
  assign eq271 = io_in_fwd_stall == 1'h0;
  assign sel273 = eq271 ? io_in_curr_PC : reg250;
  assign sel274 = eq271 ? io_in_instruction : reg235;
  assign sel275 = eq271 ? io_in_PC_next : reg244;

  assign io_out_instruction = reg235;
  assign io_out_curr_PC = reg250;
  assign io_out_PC_next = reg244;

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
  reg[31:0] mem388 [0:31];
  wire[31:0] mrport399, sel408, mrport410, sel417;
  wire eq406, eq415;

  always @ (posedge clk) begin
    if (io_in_write_register) begin
      mem388[io_in_rd] <= io_in_data;
    end
  end
  assign mrport399 = mem388[io_in_src1];
  assign mrport410 = mem388[io_in_src2];
  assign eq406 = io_in_src1 == 5'h0;
  assign sel408 = eq406 ? 32'h0 : mrport399;
  assign eq415 = io_in_src2 == 5'h0;
  assign sel417 = eq415 ? 32'h0 : mrport410;

  assign io_out_src1_data = sel408;
  assign io_out_src2_data = sel417;

endmodule

module Decode(
  input wire clk,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
  input wire[31:0] io_in_curr_PC,
  input wire io_in_stall,
  input wire[31:0] io_in_write_data,
  input wire[4:0] io_in_rd,
  input wire[1:0] io_in_wb,
  input wire[31:0] io_in_csr_data,
  output wire[11:0] io_out_csr_address,
  output wire io_out_is_csr,
  output wire[31:0] io_out_csr_data,
  output wire[31:0] io_out_csr_mask,
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
  wire bindin424, bindin425, ne485, sel487, eq535, eq540, eq545, orl547, eq552, eq557, eq562, eq567, eq572, eq577, ne582, eq587, andl589, proxy592, eq593, andl596, eq600, andl606, orl618, orl620, orl622, orl624, orl635, orl637, orl644, sel646, proxy672, proxy680, eq698, proxy715, eq716, eq722, lt726, andl729, sel741, ne744, ge747, eq750, andl761, andl763, eq770, eq775, orl777, proxy799, eq851, eq888, eq896, eq904, orl910, lt928;
  wire[4:0] bindin428, bindin434, bindin437, proxy497, proxy504, proxy511;
  wire[31:0] bindin431, bindout440, bindout443, shr494, shr501, shr508, shr515, shr522, sel608, pad610, sel612, shr676, pad689, proxy694, sel700, pad706, proxy711, sel718, sel739, shr803;
  wire[2:0] proxy518, sel650, sel653;
  wire[6:0] proxy525;
  wire[1:0] sel626, sel630, sel639, proxy883;
  wire[19:0] proxy656;
  reg[19:0] sel665;
  wire[7:0] proxy671;
  wire[9:0] proxy679;
  wire[20:0] proxy683;
  wire[11:0] proxy704, sel765, pad779, sel787, proxy790, proxy814;
  reg[31:0] sel740;
  reg sel742, sel841;
  wire[3:0] proxy806, sel853, sel856, sel873, sel890, sel898, sel906, sel912, sel914, sel918, sel922, sel930, sel932;
  wire[5:0] proxy812;
  reg[11:0] sel820;
  reg[2:0] sel839, sel840;
  reg[3:0] sel881;

  assign bindin424 = clk;
  RegisterFile __module5__(.clk(bindin424), .io_in_write_register(bindin425), .io_in_rd(bindin428), .io_in_data(bindin431), .io_in_src1(bindin434), .io_in_src2(bindin437), .io_out_src1_data(bindout440), .io_out_src2_data(bindout443));
  assign bindin425 = sel487;
  assign bindin428 = io_in_rd;
  assign bindin431 = io_in_write_data;
  assign bindin434 = proxy504;
  assign bindin437 = proxy511;
  assign ne485 = io_in_wb != 2'h0;
  assign sel487 = ne485 ? 1'h1 : 1'h0;
  assign shr494 = io_in_instruction >> 32'h7;
  assign proxy497 = shr494[4:0];
  assign shr501 = io_in_instruction >> 32'hf;
  assign proxy504 = shr501[4:0];
  assign shr508 = io_in_instruction >> 32'h14;
  assign proxy511 = shr508[4:0];
  assign shr515 = io_in_instruction >> 32'hc;
  assign proxy518 = shr515[2:0];
  assign shr522 = io_in_instruction >> 32'h19;
  assign proxy525 = shr522[6:0];
  assign eq535 = io_in_instruction[6:0] == 7'h33;
  assign eq540 = io_in_instruction[6:0] == 7'h3;
  assign eq545 = io_in_instruction[6:0] == 7'h13;
  assign orl547 = eq545 | eq540;
  assign eq552 = io_in_instruction[6:0] == 7'h23;
  assign eq557 = io_in_instruction[6:0] == 7'h63;
  assign eq562 = io_in_instruction[6:0] == 7'h6f;
  assign eq567 = io_in_instruction[6:0] == 7'h67;
  assign eq572 = io_in_instruction[6:0] == 7'h37;
  assign eq577 = io_in_instruction[6:0] == 7'h17;
  assign ne582 = proxy518 != 3'h0;
  assign eq587 = io_in_instruction[6:0] == 7'h73;
  assign andl589 = eq587 & ne582;
  assign proxy592 = proxy518[2];
  assign eq593 = proxy592 == 1'h1;
  assign andl596 = andl589 & eq593;
  assign eq600 = proxy518 == 3'h0;
  assign andl606 = eq587 & eq600;
  assign sel608 = eq562 ? io_in_curr_PC : bindout440;
  assign pad610 = {{27{1'b0}}, proxy504};
  assign sel612 = andl596 ? pad610 : sel608;
  assign orl618 = orl547 | eq535;
  assign orl620 = orl618 | eq572;
  assign orl622 = orl620 | eq577;
  assign orl624 = orl622 | andl589;
  assign sel626 = orl624 ? 2'h1 : 2'h0;
  assign sel630 = eq540 ? 2'h2 : sel626;
  assign orl635 = eq562 | eq567;
  assign orl637 = orl635 | andl606;
  assign sel639 = orl637 ? 2'h3 : sel630;
  assign orl644 = orl547 | eq552;
  assign sel646 = orl644 ? 1'h1 : 1'h0;
  assign sel650 = eq540 ? proxy518 : 3'h7;
  assign sel653 = eq552 ? proxy518 : 3'h7;
  assign proxy656 = {proxy525, proxy511, proxy504, proxy518};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h37: sel665 = proxy656;
      7'h17: sel665 = proxy656;
      default: sel665 = 20'h7b;
    endcase
  end
  assign proxy671 = shr515[7:0];
  assign proxy672 = io_in_instruction[20];
  assign shr676 = io_in_instruction >> 32'h15;
  assign proxy679 = shr676[9:0];
  assign proxy680 = io_in_instruction[31];
  assign proxy683 = {proxy680, proxy671, proxy672, proxy679, 1'h0};
  assign pad689 = {{11{1'b0}}, proxy683};
  assign proxy694 = {11'h7ff, proxy683};
  assign eq698 = proxy680 == 1'h1;
  assign sel700 = eq698 ? proxy694 : pad689;
  assign proxy704 = {proxy525, proxy511};
  assign pad706 = {{20{1'b0}}, proxy704};
  assign proxy711 = {20'hfffff, proxy704};
  assign proxy715 = proxy704[11];
  assign eq716 = proxy715 == 1'h1;
  assign sel718 = eq716 ? proxy711 : pad706;
  assign eq722 = proxy518 == 3'h0;
  assign lt726 = shr508[11:0] < 12'h2;
  assign andl729 = eq722 & lt726;
  assign sel739 = andl729 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel740 = sel700;
      7'h67: sel740 = sel718;
      7'h73: sel740 = sel739;
      default: sel740 = 32'h7b;
    endcase
  end
  assign sel741 = andl729 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel742 = 1'h1;
      7'h67: sel742 = 1'h1;
      7'h73: sel742 = sel741;
      default: sel742 = 1'h0;
    endcase
  end
  assign ne744 = proxy518 != 3'h0;
  assign ge747 = shr508[11:0] >= 12'h2;
  assign eq750 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign andl761 = ne744 & ge747;
  assign andl763 = andl761 & eq750;
  assign sel765 = andl763 ? shr508[11:0] : 12'h7b;
  assign eq770 = proxy518 == 3'h5;
  assign eq775 = proxy518 == 3'h1;
  assign orl777 = eq775 | eq770;
  assign pad779 = {{7{1'b0}}, proxy511};
  assign sel787 = orl777 ? pad779 : shr508[11:0];
  assign proxy790 = {proxy525, proxy497};
  assign proxy799 = io_in_instruction[7];
  assign shr803 = io_in_instruction >> 32'h8;
  assign proxy806 = shr803[3:0];
  assign proxy812 = shr522[5:0];
  assign proxy814 = {proxy680, proxy799, proxy812, proxy806};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel820 = sel787;
      7'h23: sel820 = proxy790;
      7'h03: sel820 = shr508[11:0];
      7'h63: sel820 = proxy814;
      default: sel820 = 12'h7b;
    endcase
  end
  always @(*) begin
    case (proxy518)
      3'h0: sel839 = 3'h1;
      3'h1: sel839 = 3'h2;
      3'h4: sel839 = 3'h3;
      3'h5: sel839 = 3'h4;
      3'h6: sel839 = 3'h5;
      3'h7: sel839 = 3'h6;
      default: sel839 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel840 = sel839;
      7'h6f: sel840 = 3'h0;
      7'h67: sel840 = 3'h0;
      default: sel840 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel841 = 1'h1;
      7'h6f: sel841 = 1'h1;
      7'h67: sel841 = 1'h1;
      default: sel841 = 1'h0;
    endcase
  end
  assign eq851 = proxy525 == 7'h0;
  assign sel853 = eq851 ? 4'h0 : 4'h1;
  assign sel856 = eq545 ? 4'h0 : sel853;
  assign sel873 = eq851 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy518)
      3'h0: sel881 = sel856;
      3'h1: sel881 = 4'h2;
      3'h2: sel881 = 4'h3;
      3'h3: sel881 = 4'h4;
      3'h4: sel881 = 4'h5;
      3'h5: sel881 = sel873;
      3'h6: sel881 = 4'h8;
      3'h7: sel881 = 4'h9;
      default: sel881 = 4'hf;
    endcase
  end
  assign proxy883 = proxy518[1:0];
  assign eq888 = proxy883 == 2'h3;
  assign sel890 = eq888 ? 4'hf : 4'hf;
  assign eq896 = proxy883 == 2'h2;
  assign sel898 = eq896 ? 4'he : sel890;
  assign eq904 = proxy883 == 2'h1;
  assign sel906 = eq904 ? 4'hd : sel898;
  assign orl910 = eq552 | eq540;
  assign sel912 = orl910 ? 4'h0 : sel881;
  assign sel914 = andl589 ? sel906 : sel912;
  assign sel918 = eq577 ? 4'hc : sel914;
  assign sel922 = eq572 ? 4'hb : sel918;
  assign lt928 = sel840 < 3'h5;
  assign sel930 = lt928 ? 4'h1 : 4'ha;
  assign sel932 = eq557 ? sel930 : sel922;

  assign io_out_csr_address = sel765;
  assign io_out_is_csr = andl589;
  assign io_out_csr_data = io_in_csr_data;
  assign io_out_csr_mask = sel612;
  assign io_out_rd = proxy497;
  assign io_out_rs1 = proxy504;
  assign io_out_rd1 = sel608;
  assign io_out_rs2 = proxy511;
  assign io_out_rd2 = bindout443;
  assign io_out_wb = sel639;
  assign io_out_alu_op = sel932;
  assign io_out_rs2_src = sel646;
  assign io_out_itype_immed = sel820;
  assign io_out_mem_read = sel650;
  assign io_out_mem_write = sel653;
  assign io_out_branch_type = sel840;
  assign io_out_branch_stall = sel841;
  assign io_out_jal = sel742;
  assign io_out_jal_offset = sel740;
  assign io_out_upper_immed = sel665;
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
  reg[4:0] reg1115, reg1124, reg1137;
  reg[31:0] reg1131, reg1143, reg1163, reg1222, reg1228, reg1234, reg1246;
  reg[3:0] reg1150;
  reg[1:0] reg1157;
  reg reg1170, reg1216, reg1240;
  reg[11:0] reg1177, reg1210;
  reg[2:0] reg1184, reg1190, reg1197;
  reg[19:0] reg1204;
  wire eq1250, eq1254, orl1256, sel1284, sel1306, sel1315;
  wire[4:0] sel1259, sel1262, sel1268;
  wire[31:0] sel1265, sel1271, sel1281, sel1309, sel1312, sel1318, sel1321;
  wire[3:0] sel1275;
  wire[1:0] sel1278;
  wire[11:0] sel1288, sel1303;
  wire[2:0] sel1291, sel1294, sel1297;
  wire[19:0] sel1300;

  always @ (posedge clk) begin
    if (reset)
      reg1115 <= 5'h0;
    else
      reg1115 <= sel1259;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1124 <= 5'h0;
    else
      reg1124 <= sel1262;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1131 <= 32'h0;
    else
      reg1131 <= sel1265;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1137 <= 5'h0;
    else
      reg1137 <= sel1268;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1143 <= 32'h0;
    else
      reg1143 <= sel1271;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1150 <= 4'h0;
    else
      reg1150 <= sel1275;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1157 <= 2'h0;
    else
      reg1157 <= sel1278;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1163 <= 32'h0;
    else
      reg1163 <= sel1281;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1170 <= 1'h0;
    else
      reg1170 <= sel1284;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1177 <= 12'h0;
    else
      reg1177 <= sel1288;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1184 <= 3'h7;
    else
      reg1184 <= sel1291;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1190 <= 3'h7;
    else
      reg1190 <= sel1294;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1197 <= 3'h0;
    else
      reg1197 <= sel1297;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1204 <= 20'h0;
    else
      reg1204 <= sel1300;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1210 <= 12'h0;
    else
      reg1210 <= sel1303;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1216 <= 1'h0;
    else
      reg1216 <= sel1306;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1222 <= 32'h0;
    else
      reg1222 <= sel1309;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1228 <= 32'h0;
    else
      reg1228 <= sel1312;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1234 <= 32'h0;
    else
      reg1234 <= sel1321;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1240 <= 1'h0;
    else
      reg1240 <= sel1315;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1246 <= 32'h0;
    else
      reg1246 <= sel1318;
  end
  assign eq1250 = io_in_branch_stall == 1'h1;
  assign eq1254 = io_in_fwd_stall == 1'h1;
  assign orl1256 = eq1254 | eq1250;
  assign sel1259 = orl1256 ? 5'h0 : io_in_rd;
  assign sel1262 = orl1256 ? 5'h0 : io_in_rs1;
  assign sel1265 = orl1256 ? 32'h0 : io_in_rd1;
  assign sel1268 = orl1256 ? 5'h0 : io_in_rs2;
  assign sel1271 = orl1256 ? 32'h0 : io_in_rd2;
  assign sel1275 = orl1256 ? 4'hf : io_in_alu_op;
  assign sel1278 = orl1256 ? 2'h0 : io_in_wb;
  assign sel1281 = orl1256 ? 32'h0 : io_in_PC_next;
  assign sel1284 = orl1256 ? 1'h0 : io_in_rs2_src;
  assign sel1288 = orl1256 ? 12'h7b : io_in_itype_immed;
  assign sel1291 = orl1256 ? 3'h7 : io_in_mem_read;
  assign sel1294 = orl1256 ? 3'h7 : io_in_mem_write;
  assign sel1297 = orl1256 ? 3'h0 : io_in_branch_type;
  assign sel1300 = orl1256 ? 20'h0 : io_in_upper_immed;
  assign sel1303 = orl1256 ? 12'h0 : io_in_csr_address;
  assign sel1306 = orl1256 ? 1'h0 : io_in_is_csr;
  assign sel1309 = orl1256 ? 32'h0 : io_in_csr_data;
  assign sel1312 = orl1256 ? 32'h0 : io_in_csr_mask;
  assign sel1315 = orl1256 ? 1'h0 : io_in_jal;
  assign sel1318 = orl1256 ? 32'h0 : io_in_jal_offset;
  assign sel1321 = orl1256 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1210;
  assign io_out_is_csr = reg1216;
  assign io_out_csr_data = reg1222;
  assign io_out_csr_mask = reg1228;
  assign io_out_rd = reg1115;
  assign io_out_rs1 = reg1124;
  assign io_out_rd1 = reg1131;
  assign io_out_rs2 = reg1137;
  assign io_out_rd2 = reg1143;
  assign io_out_alu_op = reg1150;
  assign io_out_wb = reg1157;
  assign io_out_rs2_src = reg1170;
  assign io_out_itype_immed = reg1177;
  assign io_out_mem_read = reg1184;
  assign io_out_mem_write = reg1190;
  assign io_out_branch_type = reg1197;
  assign io_out_upper_immed = reg1204;
  assign io_out_curr_PC = reg1234;
  assign io_out_jal = reg1240;
  assign io_out_jal_offset = reg1246;
  assign io_out_PC_next = reg1163;

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
  wire[31:0] pad1530, proxy1535, sel1543, sel1550, proxy1555, add1558, add1561, sub1566, shl1570, sel1580, sel1589, xorl1594, shr1598, shr1603, orl1608, andl1613, add1626, orl1632, sub1636, andl1639, sel1644;
  wire eq1541, eq1548, lt1578, lt1587, ge1617, ne1652, sel1654;
  reg[31:0] sel1643, sel1645;

  assign pad1530 = {{20{1'b0}}, io_in_itype_immed};
  assign proxy1535 = {20'hfffff, io_in_itype_immed};
  assign eq1541 = io_in_itype_immed[11] == 1'h1;
  assign sel1543 = eq1541 ? proxy1535 : pad1530;
  assign eq1548 = io_in_rs2_src == 1'h1;
  assign sel1550 = eq1548 ? sel1543 : io_in_rd2;
  assign proxy1555 = {io_in_upper_immed, 12'h0};
  assign add1558 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1561 = $signed(io_in_rd1) + $signed(sel1550);
  assign sub1566 = $signed(io_in_rd1) - $signed(sel1550);
  assign shl1570 = io_in_rd1 << sel1550;
  assign lt1578 = $signed(io_in_rd1) < $signed(sel1550);
  assign sel1580 = lt1578 ? 32'h1 : 32'h0;
  assign lt1587 = io_in_rd1 < sel1550;
  assign sel1589 = lt1587 ? 32'h1 : 32'h0;
  assign xorl1594 = io_in_rd1 ^ sel1550;
  assign shr1598 = io_in_rd1 >> sel1550;
  assign shr1603 = $signed(io_in_rd1) >> sel1550;
  assign orl1608 = io_in_rd1 | sel1550;
  assign andl1613 = sel1550 & io_in_rd1;
  assign ge1617 = io_in_rd1 >= sel1550;
  assign add1626 = $signed(io_in_curr_PC) + $signed(proxy1555);
  assign orl1632 = io_in_csr_data | io_in_csr_mask;
  assign sub1636 = 32'hffffffff - io_in_csr_mask;
  assign andl1639 = io_in_csr_data & sub1636;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1643 = 32'h7b;
      4'h1: sel1643 = 32'h7b;
      4'h2: sel1643 = 32'h7b;
      4'h3: sel1643 = 32'h7b;
      4'h4: sel1643 = 32'h7b;
      4'h5: sel1643 = 32'h7b;
      4'h6: sel1643 = 32'h7b;
      4'h7: sel1643 = 32'h7b;
      4'h8: sel1643 = 32'h7b;
      4'h9: sel1643 = 32'h7b;
      4'ha: sel1643 = 32'h7b;
      4'hb: sel1643 = 32'h7b;
      4'hc: sel1643 = 32'h7b;
      4'hd: sel1643 = io_in_csr_mask;
      4'he: sel1643 = orl1632;
      4'hf: sel1643 = andl1639;
      default: sel1643 = 32'h7b;
    endcase
  end
  assign sel1644 = ge1617 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1645 = add1561;
      4'h1: sel1645 = sub1566;
      4'h2: sel1645 = shl1570;
      4'h3: sel1645 = sel1580;
      4'h4: sel1645 = sel1589;
      4'h5: sel1645 = xorl1594;
      4'h6: sel1645 = shr1598;
      4'h7: sel1645 = shr1603;
      4'h8: sel1645 = orl1608;
      4'h9: sel1645 = andl1613;
      4'ha: sel1645 = sel1644;
      4'hb: sel1645 = proxy1555;
      4'hc: sel1645 = add1626;
      4'hd: sel1645 = io_in_csr_data;
      4'he: sel1645 = io_in_csr_data;
      4'hf: sel1645 = io_in_csr_data;
      default: sel1645 = 32'h0;
    endcase
  end
  assign ne1652 = io_in_branch_type != 3'h0;
  assign sel1654 = ne1652 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1643;
  assign io_out_alu_result = sel1645;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1558;
  assign io_out_branch_offset = sel1543;
  assign io_out_branch_stall = sel1654;
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
  reg[31:0] reg1841, reg1863, reg1875, reg1888, reg1921, reg1927, reg1933;
  reg[4:0] reg1851, reg1857, reg1869;
  reg[1:0] reg1882;
  reg[2:0] reg1895, reg1901, reg1939;
  reg[11:0] reg1908;
  reg reg1915;

  always @ (posedge clk) begin
    if (reset)
      reg1841 <= 32'h0;
    else
      reg1841 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1851 <= 5'h0;
    else
      reg1851 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1857 <= 5'h0;
    else
      reg1857 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1863 <= 32'h0;
    else
      reg1863 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1869 <= 5'h0;
    else
      reg1869 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1875 <= 32'h0;
    else
      reg1875 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1882 <= 2'h0;
    else
      reg1882 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1888 <= 32'h0;
    else
      reg1888 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1895 <= 3'h0;
    else
      reg1895 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1901 <= 3'h0;
    else
      reg1901 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1908 <= 12'h0;
    else
      reg1908 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1915 <= 1'h0;
    else
      reg1915 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1921 <= 32'h0;
    else
      reg1921 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1927 <= 32'h0;
    else
      reg1927 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1933 <= 32'h0;
    else
      reg1933 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1939 <= 3'h0;
    else
      reg1939 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg1908;
  assign io_out_is_csr = reg1915;
  assign io_out_csr_result = reg1921;
  assign io_out_alu_result = reg1841;
  assign io_out_rd = reg1851;
  assign io_out_wb = reg1882;
  assign io_out_rs1 = reg1857;
  assign io_out_rd1 = reg1863;
  assign io_out_rd2 = reg1875;
  assign io_out_rs2 = reg1869;
  assign io_out_mem_read = reg1895;
  assign io_out_mem_write = reg1901;
  assign io_out_curr_PC = reg1927;
  assign io_out_branch_offset = reg1933;
  assign io_out_branch_type = reg1939;
  assign io_out_PC_next = reg1888;

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
  wire lt2141, lt2144, orl2146, eq2154, eq2168, eq2172, andl2174, eq2195, eq2199, andl2201, orl2204, proxy2221, eq2222, proxy2239, eq2240;
  wire[1:0] sel2180, sel2184, sel2188;
  wire[7:0] proxy2213;
  wire[31:0] pad2214, proxy2217, sel2224, pad2232, proxy2235, sel2242;
  wire[15:0] proxy2231;
  reg[31:0] sel2258;

  assign lt2141 = io_in_mem_write < 3'h7;
  assign lt2144 = io_in_mem_read < 3'h7;
  assign orl2146 = lt2144 | lt2141;
  assign eq2154 = io_in_mem_write == 3'h2;
  assign eq2168 = io_in_mem_write == 3'h7;
  assign eq2172 = io_in_mem_read == 3'h7;
  assign andl2174 = eq2172 & eq2168;
  assign sel2180 = andl2174 ? 2'h0 : 2'h3;
  assign sel2184 = eq2154 ? 2'h2 : sel2180;
  assign sel2188 = lt2144 ? 2'h1 : sel2184;
  assign eq2195 = eq2154 == 1'h0;
  assign eq2199 = andl2174 == 1'h0;
  assign andl2201 = eq2199 & eq2195;
  assign orl2204 = lt2144 | andl2201;
  assign proxy2213 = io_DBUS_in_data_data[7:0];
  assign pad2214 = {{24{1'b0}}, proxy2213};
  assign proxy2217 = {24'hffffff, proxy2213};
  assign proxy2221 = proxy2213[7];
  assign eq2222 = proxy2221 == 1'h1;
  assign sel2224 = eq2222 ? proxy2217 : pad2214;
  assign proxy2231 = io_DBUS_in_data_data[15:0];
  assign pad2232 = {{16{1'b0}}, proxy2231};
  assign proxy2235 = {16'hffff, proxy2231};
  assign proxy2239 = proxy2231[15];
  assign eq2240 = proxy2239 == 1'h1;
  assign sel2242 = eq2240 ? proxy2235 : pad2232;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2258 = sel2224;
      3'h1: sel2258 = sel2242;
      3'h2: sel2258 = io_DBUS_in_data_data;
      3'h4: sel2258 = pad2214;
      3'h5: sel2258 = pad2232;
      default: sel2258 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2204;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2141;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2146;
  assign io_DBUS_out_control_data = sel2188;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2258;

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
  wire[31:0] bindin2265, bindout2274, bindout2283, bindin2301, bindin2310, bindout2313, shl2316, add2318;
  wire bindin2268, bindout2271, bindout2277, bindin2280, bindout2286, bindin2289, bindout2295, bindin2298, eq2328, sel2330, sel2339, eq2346, sel2348, sel2357;
  wire[1:0] bindout2292;
  wire[2:0] bindin2304, bindin2307;
  reg sel2380;

  Cache __module10__(.io_DBUS_in_data_data(bindin2265), .io_DBUS_in_data_valid(bindin2268), .io_DBUS_out_data_ready(bindin2280), .io_DBUS_out_address_ready(bindin2289), .io_DBUS_out_control_ready(bindin2298), .io_in_address(bindin2301), .io_in_mem_read(bindin2304), .io_in_mem_write(bindin2307), .io_in_data(bindin2310), .io_DBUS_in_data_ready(bindout2271), .io_DBUS_out_data_data(bindout2274), .io_DBUS_out_data_valid(bindout2277), .io_DBUS_out_address_data(bindout2283), .io_DBUS_out_address_valid(bindout2286), .io_DBUS_out_control_data(bindout2292), .io_DBUS_out_control_valid(bindout2295), .io_out_data(bindout2313));
  assign bindin2265 = io_DBUS_in_data_data;
  assign bindin2268 = io_DBUS_in_data_valid;
  assign bindin2280 = io_DBUS_out_data_ready;
  assign bindin2289 = io_DBUS_out_address_ready;
  assign bindin2298 = io_DBUS_out_control_ready;
  assign bindin2301 = io_in_alu_result;
  assign bindin2304 = io_in_mem_read;
  assign bindin2307 = io_in_mem_write;
  assign bindin2310 = io_in_rd2;
  assign shl2316 = $signed(io_in_branch_offset) << 32'h1;
  assign add2318 = $signed(io_in_curr_PC) + $signed(shl2316);
  assign eq2328 = io_in_alu_result == 32'h0;
  assign sel2330 = eq2328 ? 1'h1 : 1'h0;
  assign sel2339 = eq2328 ? 1'h0 : 1'h1;
  assign eq2346 = io_in_alu_result[31] == 1'h0;
  assign sel2348 = eq2346 ? 1'h0 : 1'h1;
  assign sel2357 = eq2346 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2380 = sel2330;
      3'h2: sel2380 = sel2339;
      3'h3: sel2380 = sel2348;
      3'h4: sel2380 = sel2357;
      3'h5: sel2380 = sel2348;
      3'h6: sel2380 = sel2357;
      3'h0: sel2380 = 1'h0;
      default: sel2380 = 1'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = bindout2271;
  assign io_DBUS_out_data_data = bindout2274;
  assign io_DBUS_out_data_valid = bindout2277;
  assign io_DBUS_out_address_data = bindout2283;
  assign io_DBUS_out_address_valid = bindout2286;
  assign io_DBUS_out_control_data = bindout2292;
  assign io_DBUS_out_control_valid = bindout2295;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2313;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2380;
  assign io_out_branch_dest = add2318;
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
  reg[31:0] reg2518, reg2527, reg2559;
  reg[4:0] reg2534, reg2540, reg2546;
  reg[1:0] reg2553;

  always @ (posedge clk) begin
    if (reset)
      reg2518 <= 32'h0;
    else
      reg2518 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2527 <= 32'h0;
    else
      reg2527 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2534 <= 5'h0;
    else
      reg2534 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2540 <= 5'h0;
    else
      reg2540 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2546 <= 5'h0;
    else
      reg2546 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2553 <= 2'h0;
    else
      reg2553 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2559 <= 32'h0;
    else
      reg2559 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2518;
  assign io_out_mem_result = reg2527;
  assign io_out_rd = reg2534;
  assign io_out_wb = reg2553;
  assign io_out_rs1 = reg2540;
  assign io_out_rs2 = reg2546;
  assign io_out_PC_next = reg2559;

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
  wire eq2625, eq2630;
  wire[31:0] sel2632, sel2634;

  assign eq2625 = io_in_wb == 2'h3;
  assign eq2630 = io_in_wb == 2'h1;
  assign sel2632 = eq2630 ? io_in_alu_result : io_in_mem_result;
  assign sel2634 = eq2625 ? io_in_PC_next : sel2632;

  assign io_out_write_data = sel2634;
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
  wire eq2731, eq2735, ne2740, ne2745, eq2748, andl2750, andl2752, eq2757, ne2761, eq2768, andl2770, andl2772, andl2774, eq2778, ne2786, eq2793, andl2795, andl2797, andl2799, andl2801, orl2804, orl2806, ne2814, eq2817, andl2819, andl2821, eq2825, eq2836, andl2838, andl2840, andl2842, eq2846, eq2861, andl2863, andl2865, andl2867, andl2869, orl2872, orl2874, eq2877, andl2879, eq2883, eq2886, andl2888, andl2890, orl2893, orl2900, orl2902, orl2904;

  assign eq2731 = io_in_execute_is_csr == 1'h1;
  assign eq2735 = io_in_memory_is_csr == 1'h1;
  assign ne2740 = io_in_execute_wb != 2'h0;
  assign ne2745 = io_in_decode_src1 != 5'h0;
  assign eq2748 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2750 = eq2748 & ne2745;
  assign andl2752 = andl2750 & ne2740;
  assign eq2757 = andl2752 == 1'h0;
  assign ne2761 = io_in_memory_wb != 2'h0;
  assign eq2768 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2770 = eq2768 & ne2745;
  assign andl2772 = andl2770 & ne2761;
  assign andl2774 = andl2772 & eq2757;
  assign eq2778 = andl2774 == 1'h0;
  assign ne2786 = io_in_writeback_wb != 2'h0;
  assign eq2793 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2795 = eq2793 & ne2745;
  assign andl2797 = andl2795 & ne2786;
  assign andl2799 = andl2797 & eq2757;
  assign andl2801 = andl2799 & eq2778;
  assign orl2804 = andl2752 | andl2774;
  assign orl2806 = orl2804 | andl2801;
  assign ne2814 = io_in_decode_src2 != 5'h0;
  assign eq2817 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2819 = eq2817 & ne2814;
  assign andl2821 = andl2819 & ne2740;
  assign eq2825 = andl2821 == 1'h0;
  assign eq2836 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2838 = eq2836 & ne2814;
  assign andl2840 = andl2838 & ne2761;
  assign andl2842 = andl2840 & eq2825;
  assign eq2846 = andl2842 == 1'h0;
  assign eq2861 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2863 = eq2861 & ne2814;
  assign andl2865 = andl2863 & ne2786;
  assign andl2867 = andl2865 & eq2825;
  assign andl2869 = andl2867 & eq2846;
  assign orl2872 = andl2821 | andl2842;
  assign orl2874 = orl2872 | andl2869;
  assign eq2877 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2879 = eq2877 & eq2731;
  assign eq2883 = andl2879 == 1'h0;
  assign eq2886 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2888 = eq2886 & eq2735;
  assign andl2890 = andl2888 & eq2883;
  assign orl2893 = andl2879 | andl2890;
  assign orl2900 = orl2806 | andl2821;
  assign orl2902 = orl2900 | andl2842;
  assign orl2904 = orl2902 | andl2869;

  assign io_out_src1_fwd = orl2806;
  assign io_out_src2_fwd = orl2874;
  assign io_out_csr_fwd = orl2893;
  assign io_out_fwd_stall = orl2904;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem2999 [0:1];
  wire[31:0] mrport3001, sel3005;

  initial begin
    mem2999[0] = 32'hdeadbeef;
    mem2999[1] = 32'hdeadbeef;
  end
  assign mrport3001 = mem2999[io_INTERRUPT_in_interrupt_id_data];
  assign sel3005 = io_INTERRUPT_in_interrupt_id_valid ? mrport3001 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3005;

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
  reg[3:0] reg3073, sel3163;
  wire eq3081, andl3166, eq3170, andl3174, eq3178, andl3182;
  wire[3:0] sel3087, sel3092, sel3098, sel3104, sel3114, sel3119, sel3123, sel3132, sel3138, sel3148, sel3153, sel3157, sel3164, sel3180, sel3181, sel3183;

  always @ (posedge clk) begin
    if (reset)
      reg3073 <= 4'h0;
    else
      reg3073 <= sel3183;
  end
  assign eq3081 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3087 = eq3081 ? 4'h0 : 4'h1;
  assign sel3092 = eq3081 ? 4'h2 : 4'h1;
  assign sel3098 = eq3081 ? 4'h9 : 4'h3;
  assign sel3104 = eq3081 ? 4'h5 : 4'h4;
  assign sel3114 = eq3081 ? 4'h8 : 4'h6;
  assign sel3119 = eq3081 ? 4'h7 : 4'h6;
  assign sel3123 = eq3081 ? 4'h4 : 4'h8;
  assign sel3132 = eq3081 ? 4'h0 : 4'ha;
  assign sel3138 = eq3081 ? 4'hc : 4'hb;
  assign sel3148 = eq3081 ? 4'hf : 4'hd;
  assign sel3153 = eq3081 ? 4'he : 4'hd;
  assign sel3157 = eq3081 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3073)
      4'h0: sel3163 = sel3087;
      4'h1: sel3163 = sel3092;
      4'h2: sel3163 = sel3098;
      4'h3: sel3163 = sel3104;
      4'h4: sel3163 = sel3104;
      4'h5: sel3163 = sel3114;
      4'h6: sel3163 = sel3119;
      4'h7: sel3163 = sel3123;
      4'h8: sel3163 = sel3092;
      4'h9: sel3163 = sel3132;
      4'ha: sel3163 = sel3138;
      4'hb: sel3163 = sel3138;
      4'hc: sel3163 = sel3148;
      4'hd: sel3163 = sel3153;
      4'he: sel3163 = sel3157;
      4'hf: sel3163 = sel3092;
      default: sel3163 = reg3073;
    endcase
  end
  assign sel3164 = io_JTAG_TAP_in_mode_select_valid ? sel3163 : 4'h0;
  assign andl3166 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3170 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3174 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3178 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3180 = eq3170 ? 4'h0 : reg3073;
  assign sel3181 = andl3182 ? sel3164 : reg3073;
  assign andl3182 = andl3174 & eq3178;
  assign sel3183 = andl3166 ? sel3180 : sel3181;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3073;

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
  wire bindin3189, bindin3191, bindin3192, bindin3195, bindout3198, bindin3201, bindin3204, bindout3207, bindin3210, bindin3213, bindout3216, eq3253, eq3262, eq3267, eq3345, andl3346, sel3347, sel3353;
  wire[3:0] bindout3219;
  reg[31:0] reg3227, reg3234, reg3241, reg3248, sel3343;
  wire[31:0] sel3270, sel3272, shr3279, proxy3284, sel3339, sel3340, sel3341, sel3342, sel3344;
  wire[30:0] proxy3282;
  reg sel3352, sel3358;

  assign bindin3189 = clk;
  assign bindin3191 = reset;
  TAP __module16__(.clk(bindin3189), .reset(bindin3191), .io_JTAG_TAP_in_mode_select_data(bindin3192), .io_JTAG_TAP_in_mode_select_valid(bindin3195), .io_JTAG_TAP_in_clock_data(bindin3201), .io_JTAG_TAP_in_clock_valid(bindin3204), .io_JTAG_TAP_in_reset_data(bindin3210), .io_JTAG_TAP_in_reset_valid(bindin3213), .io_JTAG_TAP_in_mode_select_ready(bindout3198), .io_JTAG_TAP_in_clock_ready(bindout3207), .io_JTAG_TAP_in_reset_ready(bindout3216), .io_out_curr_state(bindout3219));
  assign bindin3192 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3195 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3201 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3204 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3210 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3213 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3227 <= 32'h0;
    else
      reg3227 <= sel3339;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3234 <= 32'h1234;
    else
      reg3234 <= sel3342;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3241 <= 32'h5678;
    else
      reg3241 <= sel3344;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3248 <= 32'h0;
    else
      reg3248 <= sel3343;
  end
  assign eq3253 = reg3227 == 32'h0;
  assign eq3262 = reg3227 == 32'h1;
  assign eq3267 = reg3227 == 32'h2;
  assign sel3270 = eq3267 ? reg3234 : 32'hdeadbeef;
  assign sel3272 = eq3262 ? reg3241 : sel3270;
  assign shr3279 = reg3248 >> 32'h1;
  assign proxy3282 = shr3279[30:0];
  assign proxy3284 = {io_JTAG_in_data_data, proxy3282};
  assign sel3339 = (bindout3219 == 4'hf) ? reg3248 : reg3227;
  assign sel3340 = eq3267 ? reg3248 : reg3234;
  assign sel3341 = eq3262 ? reg3234 : sel3340;
  assign sel3342 = (bindout3219 == 4'h8) ? sel3341 : reg3234;
  always @(*) begin
    case (bindout3219)
      4'h3: sel3343 = sel3272;
      4'h4: sel3343 = proxy3284;
      4'ha: sel3343 = reg3227;
      4'hb: sel3343 = proxy3284;
      default: sel3343 = reg3248;
    endcase
  end
  assign sel3344 = andl3346 ? reg3248 : reg3241;
  assign eq3345 = bindout3219 == 4'h8;
  assign andl3346 = eq3345 & eq3262;
  assign sel3347 = eq3253 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3219)
      4'h3: sel3352 = sel3347;
      4'h4: sel3352 = 1'h1;
      4'h8: sel3352 = sel3347;
      4'ha: sel3352 = sel3347;
      4'hb: sel3352 = 1'h1;
      4'hf: sel3352 = sel3347;
      default: sel3352 = sel3347;
    endcase
  end
  assign sel3353 = eq3253 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3219)
      4'h3: sel3358 = sel3353;
      4'h4: sel3358 = reg3248[0];
      4'h8: sel3358 = sel3353;
      4'ha: sel3358 = sel3353;
      4'hb: sel3358 = reg3248[0];
      4'hf: sel3358 = sel3353;
      default: sel3358 = sel3353;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3198;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3207;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3216;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3358;
  assign io_JTAG_out_data_valid = sel3352;

endmodule

module CSR_Handler(
  input wire clk,
  input wire[11:0] io_in_decode_csr_address,
  input wire[11:0] io_in_mem_csr_address,
  input wire io_in_mem_is_csr,
  input wire[31:0] io_in_mem_csr_result,
  output wire[31:0] io_out_decode_csr_data
);
  reg[11:0] mem3414 [0:4095];
  wire[11:0] proxy3424, mrport3427;
  wire[31:0] pad3429;

  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem3414[io_in_mem_csr_address] <= proxy3424;
    end
  end
  assign mrport3427 = mem3414[io_in_decode_csr_address];
  assign proxy3424 = io_in_mem_csr_result[11:0];
  assign pad3429 = {{20{1'b0}}, mrport3427};

  assign io_out_decode_csr_data = pad3429;

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
  wire bindin159, bindin161, bindin165, bindout168, bindout174, bindin177, bindin180, bindin186, bindin189, bindin192, bindin195, bindin201, bindin279, bindin280, bindin290, bindin293, bindin296, bindin937, bindin947, bindout965, bindout995, bindout1010, bindout1013, bindin1326, bindin1327, bindin1349, bindin1367, bindin1370, bindin1379, bindin1391, bindout1400, bindout1430, bindout1451, bindin1680, bindin1704, bindin1713, bindout1725, bindout1758, bindout1767, bindin1944, bindin1945, bindin1979, bindout1997, bindin2387, bindout2390, bindout2396, bindin2399, bindout2405, bindin2408, bindout2414, bindin2417, bindout2477, bindin2564, bindin2565, bindin2930, bindin2954, bindout2987, bindin3009, bindin3012, bindout3015, bindout3018, bindin3362, bindin3363, bindin3364, bindin3367, bindout3370, bindin3373, bindin3376, bindout3379, bindin3382, bindin3385, bindout3388, bindin3391, bindin3394, bindout3397, bindout3400, bindout3403, bindin3406, bindin3434, bindin3441, orl3449, eq3454;
  wire[31:0] bindin162, bindout171, bindin183, bindin198, bindin204, bindout207, bindout210, bindout213, bindin281, bindin284, bindin287, bindout299, bindout302, bindout305, bindin938, bindin941, bindin944, bindin950, bindin959, bindout968, bindout971, bindout980, bindout986, bindout1016, bindout1022, bindin1334, bindin1340, bindin1361, bindin1382, bindin1385, bindin1388, bindin1394, bindout1403, bindout1406, bindout1415, bindout1421, bindout1448, bindout1454, bindout1457, bindin1665, bindin1671, bindin1692, bindin1707, bindin1710, bindin1716, bindin1719, bindout1728, bindout1731, bindout1743, bindout1749, bindout1761, bindout1764, bindout1770, bindin1946, bindin1958, bindin1964, bindin1973, bindin1982, bindin1985, bindin1988, bindout2000, bindout2003, bindout2015, bindout2018, bindout2030, bindout2033, bindout2039, bindin2384, bindout2393, bindout2402, bindin2420, bindin2438, bindin2444, bindin2447, bindin2450, bindin2453, bindout2459, bindout2462, bindout2480, bindout2483, bindin2566, bindin2569, bindin2584, bindout2587, bindout2590, bindout2605, bindin2639, bindin2642, bindin2657, bindout2660, bindin2924, bindin2927, bindin2936, bindin2945, bindin2948, bindin2951, bindin2960, bindin2969, bindin2972, bindin2975, bindout3021, bindin3444, bindout3447;
  wire[4:0] bindin953, bindout974, bindout977, bindout983, bindin1328, bindin1331, bindin1337, bindout1409, bindout1412, bindout1418, bindin1659, bindin1662, bindin1668, bindout1734, bindout1740, bindout1746, bindin1949, bindin1955, bindin1961, bindout2006, bindout2012, bindout2021, bindin2429, bindin2435, bindin2441, bindout2465, bindout2471, bindout2474, bindin2572, bindin2578, bindin2581, bindout2593, bindout2599, bindout2602, bindin2645, bindin2651, bindin2654, bindout2663, bindin2909, bindin2912, bindin2918, bindin2939, bindin2963;
  wire[1:0] bindin956, bindout989, bindin1346, bindout1427, bindin1677, bindout1737, bindin1952, bindout2009, bindout2411, bindin2432, bindout2468, bindin2575, bindout2596, bindin2648, bindout2666, bindin2921, bindin2942, bindin2966;
  wire[11:0] bindout962, bindout998, bindin1352, bindin1376, bindout1397, bindout1433, bindin1683, bindin1701, bindout1722, bindin1976, bindout1994, bindin2915, bindin2933, bindin2957, bindin3435, bindin3438;
  wire[3:0] bindout992, bindin1343, bindout1424, bindin1674;
  wire[2:0] bindout1001, bindout1004, bindout1007, bindin1355, bindin1358, bindin1364, bindout1436, bindout1439, bindout1442, bindin1686, bindin1689, bindin1695, bindout1752, bindout1755, bindin1967, bindin1970, bindin1991, bindout2024, bindout2027, bindout2036, bindin2423, bindin2426, bindin2456;
  wire[19:0] bindout1019, bindin1373, bindout1445, bindin1698;

  assign bindin159 = clk;
  assign bindin161 = reset;
  Fetch __module2__(.clk(bindin159), .reset(bindin161), .io_IBUS_in_data_data(bindin162), .io_IBUS_in_data_valid(bindin165), .io_IBUS_out_address_ready(bindin177), .io_in_branch_dir(bindin180), .io_in_branch_dest(bindin183), .io_in_branch_stall(bindin186), .io_in_fwd_stall(bindin189), .io_in_branch_stall_exe(bindin192), .io_in_jal(bindin195), .io_in_jal_dest(bindin198), .io_in_interrupt(bindin201), .io_in_interrupt_pc(bindin204), .io_IBUS_in_data_ready(bindout168), .io_IBUS_out_address_data(bindout171), .io_IBUS_out_address_valid(bindout174), .io_out_instruction(bindout207), .io_out_curr_PC(bindout210), .io_out_PC_next(bindout213));
  assign bindin162 = io_IBUS_in_data_data;
  assign bindin165 = io_IBUS_in_data_valid;
  assign bindin177 = io_IBUS_out_address_ready;
  assign bindin180 = bindout2477;
  assign bindin183 = bindout2480;
  assign bindin186 = bindout1010;
  assign bindin189 = bindout2987;
  assign bindin192 = bindout1767;
  assign bindin195 = bindout1758;
  assign bindin198 = bindout1761;
  assign bindin201 = bindout3018;
  assign bindin204 = bindout3021;
  assign bindin279 = clk;
  assign bindin280 = reset;
  F_D_Register __module3__(.clk(bindin279), .reset(bindin280), .io_in_instruction(bindin281), .io_in_PC_next(bindin284), .io_in_curr_PC(bindin287), .io_in_branch_stall(bindin290), .io_in_branch_stall_exe(bindin293), .io_in_fwd_stall(bindin296), .io_out_instruction(bindout299), .io_out_curr_PC(bindout302), .io_out_PC_next(bindout305));
  assign bindin281 = bindout207;
  assign bindin284 = bindout213;
  assign bindin287 = bindout210;
  assign bindin290 = bindout1010;
  assign bindin293 = bindout1767;
  assign bindin296 = bindout2987;
  assign bindin937 = clk;
  Decode __module4__(.clk(bindin937), .io_in_instruction(bindin938), .io_in_PC_next(bindin941), .io_in_curr_PC(bindin944), .io_in_stall(bindin947), .io_in_write_data(bindin950), .io_in_rd(bindin953), .io_in_wb(bindin956), .io_in_csr_data(bindin959), .io_out_csr_address(bindout962), .io_out_is_csr(bindout965), .io_out_csr_data(bindout968), .io_out_csr_mask(bindout971), .io_out_rd(bindout974), .io_out_rs1(bindout977), .io_out_rd1(bindout980), .io_out_rs2(bindout983), .io_out_rd2(bindout986), .io_out_wb(bindout989), .io_out_alu_op(bindout992), .io_out_rs2_src(bindout995), .io_out_itype_immed(bindout998), .io_out_mem_read(bindout1001), .io_out_mem_write(bindout1004), .io_out_branch_type(bindout1007), .io_out_branch_stall(bindout1010), .io_out_jal(bindout1013), .io_out_jal_offset(bindout1016), .io_out_upper_immed(bindout1019), .io_out_PC_next(bindout1022));
  assign bindin938 = bindout299;
  assign bindin941 = bindout305;
  assign bindin944 = bindout302;
  assign bindin947 = eq3454;
  assign bindin950 = bindout2660;
  assign bindin953 = bindout2663;
  assign bindin956 = bindout2666;
  assign bindin959 = bindout3447;
  assign bindin1326 = clk;
  assign bindin1327 = reset;
  D_E_Register __module6__(.clk(bindin1326), .reset(bindin1327), .io_in_rd(bindin1328), .io_in_rs1(bindin1331), .io_in_rd1(bindin1334), .io_in_rs2(bindin1337), .io_in_rd2(bindin1340), .io_in_alu_op(bindin1343), .io_in_wb(bindin1346), .io_in_rs2_src(bindin1349), .io_in_itype_immed(bindin1352), .io_in_mem_read(bindin1355), .io_in_mem_write(bindin1358), .io_in_PC_next(bindin1361), .io_in_branch_type(bindin1364), .io_in_fwd_stall(bindin1367), .io_in_branch_stall(bindin1370), .io_in_upper_immed(bindin1373), .io_in_csr_address(bindin1376), .io_in_is_csr(bindin1379), .io_in_csr_data(bindin1382), .io_in_csr_mask(bindin1385), .io_in_curr_PC(bindin1388), .io_in_jal(bindin1391), .io_in_jal_offset(bindin1394), .io_out_csr_address(bindout1397), .io_out_is_csr(bindout1400), .io_out_csr_data(bindout1403), .io_out_csr_mask(bindout1406), .io_out_rd(bindout1409), .io_out_rs1(bindout1412), .io_out_rd1(bindout1415), .io_out_rs2(bindout1418), .io_out_rd2(bindout1421), .io_out_alu_op(bindout1424), .io_out_wb(bindout1427), .io_out_rs2_src(bindout1430), .io_out_itype_immed(bindout1433), .io_out_mem_read(bindout1436), .io_out_mem_write(bindout1439), .io_out_branch_type(bindout1442), .io_out_upper_immed(bindout1445), .io_out_curr_PC(bindout1448), .io_out_jal(bindout1451), .io_out_jal_offset(bindout1454), .io_out_PC_next(bindout1457));
  assign bindin1328 = bindout974;
  assign bindin1331 = bindout977;
  assign bindin1334 = bindout980;
  assign bindin1337 = bindout983;
  assign bindin1340 = bindout986;
  assign bindin1343 = bindout992;
  assign bindin1346 = bindout989;
  assign bindin1349 = bindout995;
  assign bindin1352 = bindout998;
  assign bindin1355 = bindout1001;
  assign bindin1358 = bindout1004;
  assign bindin1361 = bindout1022;
  assign bindin1364 = bindout1007;
  assign bindin1367 = bindout2987;
  assign bindin1370 = bindout1767;
  assign bindin1373 = bindout1019;
  assign bindin1376 = bindout962;
  assign bindin1379 = bindout965;
  assign bindin1382 = bindout968;
  assign bindin1385 = bindout971;
  assign bindin1388 = bindout302;
  assign bindin1391 = bindout1013;
  assign bindin1394 = bindout1016;
  Execute __module7__(.io_in_rd(bindin1659), .io_in_rs1(bindin1662), .io_in_rd1(bindin1665), .io_in_rs2(bindin1668), .io_in_rd2(bindin1671), .io_in_alu_op(bindin1674), .io_in_wb(bindin1677), .io_in_rs2_src(bindin1680), .io_in_itype_immed(bindin1683), .io_in_mem_read(bindin1686), .io_in_mem_write(bindin1689), .io_in_PC_next(bindin1692), .io_in_branch_type(bindin1695), .io_in_upper_immed(bindin1698), .io_in_csr_address(bindin1701), .io_in_is_csr(bindin1704), .io_in_csr_data(bindin1707), .io_in_csr_mask(bindin1710), .io_in_jal(bindin1713), .io_in_jal_offset(bindin1716), .io_in_curr_PC(bindin1719), .io_out_csr_address(bindout1722), .io_out_is_csr(bindout1725), .io_out_csr_result(bindout1728), .io_out_alu_result(bindout1731), .io_out_rd(bindout1734), .io_out_wb(bindout1737), .io_out_rs1(bindout1740), .io_out_rd1(bindout1743), .io_out_rs2(bindout1746), .io_out_rd2(bindout1749), .io_out_mem_read(bindout1752), .io_out_mem_write(bindout1755), .io_out_jal(bindout1758), .io_out_jal_dest(bindout1761), .io_out_branch_offset(bindout1764), .io_out_branch_stall(bindout1767), .io_out_PC_next(bindout1770));
  assign bindin1659 = bindout1409;
  assign bindin1662 = bindout1412;
  assign bindin1665 = bindout1415;
  assign bindin1668 = bindout1418;
  assign bindin1671 = bindout1421;
  assign bindin1674 = bindout1424;
  assign bindin1677 = bindout1427;
  assign bindin1680 = bindout1430;
  assign bindin1683 = bindout1433;
  assign bindin1686 = bindout1436;
  assign bindin1689 = bindout1439;
  assign bindin1692 = bindout1457;
  assign bindin1695 = bindout1442;
  assign bindin1698 = bindout1445;
  assign bindin1701 = bindout1397;
  assign bindin1704 = bindout1400;
  assign bindin1707 = bindout1403;
  assign bindin1710 = bindout1406;
  assign bindin1713 = bindout1451;
  assign bindin1716 = bindout1454;
  assign bindin1719 = bindout1448;
  assign bindin1944 = clk;
  assign bindin1945 = reset;
  E_M_Register __module8__(.clk(bindin1944), .reset(bindin1945), .io_in_alu_result(bindin1946), .io_in_rd(bindin1949), .io_in_wb(bindin1952), .io_in_rs1(bindin1955), .io_in_rd1(bindin1958), .io_in_rs2(bindin1961), .io_in_rd2(bindin1964), .io_in_mem_read(bindin1967), .io_in_mem_write(bindin1970), .io_in_PC_next(bindin1973), .io_in_csr_address(bindin1976), .io_in_is_csr(bindin1979), .io_in_csr_result(bindin1982), .io_in_curr_PC(bindin1985), .io_in_branch_offset(bindin1988), .io_in_branch_type(bindin1991), .io_out_csr_address(bindout1994), .io_out_is_csr(bindout1997), .io_out_csr_result(bindout2000), .io_out_alu_result(bindout2003), .io_out_rd(bindout2006), .io_out_wb(bindout2009), .io_out_rs1(bindout2012), .io_out_rd1(bindout2015), .io_out_rd2(bindout2018), .io_out_rs2(bindout2021), .io_out_mem_read(bindout2024), .io_out_mem_write(bindout2027), .io_out_curr_PC(bindout2030), .io_out_branch_offset(bindout2033), .io_out_branch_type(bindout2036), .io_out_PC_next(bindout2039));
  assign bindin1946 = bindout1731;
  assign bindin1949 = bindout1734;
  assign bindin1952 = bindout1737;
  assign bindin1955 = bindout1740;
  assign bindin1958 = bindout1743;
  assign bindin1961 = bindout1746;
  assign bindin1964 = bindout1749;
  assign bindin1967 = bindout1752;
  assign bindin1970 = bindout1755;
  assign bindin1973 = bindout1770;
  assign bindin1976 = bindout1722;
  assign bindin1979 = bindout1725;
  assign bindin1982 = bindout1728;
  assign bindin1985 = bindout1448;
  assign bindin1988 = bindout1764;
  assign bindin1991 = bindout1442;
  Memory __module9__(.io_DBUS_in_data_data(bindin2384), .io_DBUS_in_data_valid(bindin2387), .io_DBUS_out_data_ready(bindin2399), .io_DBUS_out_address_ready(bindin2408), .io_DBUS_out_control_ready(bindin2417), .io_in_alu_result(bindin2420), .io_in_mem_read(bindin2423), .io_in_mem_write(bindin2426), .io_in_rd(bindin2429), .io_in_wb(bindin2432), .io_in_rs1(bindin2435), .io_in_rd1(bindin2438), .io_in_rs2(bindin2441), .io_in_rd2(bindin2444), .io_in_PC_next(bindin2447), .io_in_curr_PC(bindin2450), .io_in_branch_offset(bindin2453), .io_in_branch_type(bindin2456), .io_DBUS_in_data_ready(bindout2390), .io_DBUS_out_data_data(bindout2393), .io_DBUS_out_data_valid(bindout2396), .io_DBUS_out_address_data(bindout2402), .io_DBUS_out_address_valid(bindout2405), .io_DBUS_out_control_data(bindout2411), .io_DBUS_out_control_valid(bindout2414), .io_out_alu_result(bindout2459), .io_out_mem_result(bindout2462), .io_out_rd(bindout2465), .io_out_wb(bindout2468), .io_out_rs1(bindout2471), .io_out_rs2(bindout2474), .io_out_branch_dir(bindout2477), .io_out_branch_dest(bindout2480), .io_out_PC_next(bindout2483));
  assign bindin2384 = io_DBUS_in_data_data;
  assign bindin2387 = io_DBUS_in_data_valid;
  assign bindin2399 = io_DBUS_out_data_ready;
  assign bindin2408 = io_DBUS_out_address_ready;
  assign bindin2417 = io_DBUS_out_control_ready;
  assign bindin2420 = bindout2003;
  assign bindin2423 = bindout2024;
  assign bindin2426 = bindout2027;
  assign bindin2429 = bindout2006;
  assign bindin2432 = bindout2009;
  assign bindin2435 = bindout2012;
  assign bindin2438 = bindout2015;
  assign bindin2441 = bindout2021;
  assign bindin2444 = bindout2018;
  assign bindin2447 = bindout2039;
  assign bindin2450 = bindout2030;
  assign bindin2453 = bindout2033;
  assign bindin2456 = bindout2036;
  assign bindin2564 = clk;
  assign bindin2565 = reset;
  M_W_Register __module11__(.clk(bindin2564), .reset(bindin2565), .io_in_alu_result(bindin2566), .io_in_mem_result(bindin2569), .io_in_rd(bindin2572), .io_in_wb(bindin2575), .io_in_rs1(bindin2578), .io_in_rs2(bindin2581), .io_in_PC_next(bindin2584), .io_out_alu_result(bindout2587), .io_out_mem_result(bindout2590), .io_out_rd(bindout2593), .io_out_wb(bindout2596), .io_out_rs1(bindout2599), .io_out_rs2(bindout2602), .io_out_PC_next(bindout2605));
  assign bindin2566 = bindout2459;
  assign bindin2569 = bindout2462;
  assign bindin2572 = bindout2465;
  assign bindin2575 = bindout2468;
  assign bindin2578 = bindout2471;
  assign bindin2581 = bindout2474;
  assign bindin2584 = bindout2483;
  Write_Back __module12__(.io_in_alu_result(bindin2639), .io_in_mem_result(bindin2642), .io_in_rd(bindin2645), .io_in_wb(bindin2648), .io_in_rs1(bindin2651), .io_in_rs2(bindin2654), .io_in_PC_next(bindin2657), .io_out_write_data(bindout2660), .io_out_rd(bindout2663), .io_out_wb(bindout2666));
  assign bindin2639 = bindout2587;
  assign bindin2642 = bindout2590;
  assign bindin2645 = bindout2593;
  assign bindin2648 = bindout2596;
  assign bindin2651 = bindout2599;
  assign bindin2654 = bindout2602;
  assign bindin2657 = bindout2605;
  Forwarding __module13__(.io_in_decode_src1(bindin2909), .io_in_decode_src2(bindin2912), .io_in_decode_csr_address(bindin2915), .io_in_execute_dest(bindin2918), .io_in_execute_wb(bindin2921), .io_in_execute_alu_result(bindin2924), .io_in_execute_PC_next(bindin2927), .io_in_execute_is_csr(bindin2930), .io_in_execute_csr_address(bindin2933), .io_in_execute_csr_result(bindin2936), .io_in_memory_dest(bindin2939), .io_in_memory_wb(bindin2942), .io_in_memory_alu_result(bindin2945), .io_in_memory_mem_data(bindin2948), .io_in_memory_PC_next(bindin2951), .io_in_memory_is_csr(bindin2954), .io_in_memory_csr_address(bindin2957), .io_in_memory_csr_result(bindin2960), .io_in_writeback_dest(bindin2963), .io_in_writeback_wb(bindin2966), .io_in_writeback_alu_result(bindin2969), .io_in_writeback_mem_data(bindin2972), .io_in_writeback_PC_next(bindin2975), .io_out_fwd_stall(bindout2987));
  assign bindin2909 = bindout977;
  assign bindin2912 = bindout983;
  assign bindin2915 = bindout962;
  assign bindin2918 = bindout1734;
  assign bindin2921 = bindout1737;
  assign bindin2924 = bindout1731;
  assign bindin2927 = bindout1770;
  assign bindin2930 = bindout1725;
  assign bindin2933 = bindout1722;
  assign bindin2936 = bindout1728;
  assign bindin2939 = bindout2465;
  assign bindin2942 = bindout2468;
  assign bindin2945 = bindout2459;
  assign bindin2948 = bindout2462;
  assign bindin2951 = bindout2483;
  assign bindin2954 = bindout1997;
  assign bindin2957 = bindout1994;
  assign bindin2960 = bindout2000;
  assign bindin2963 = bindout2593;
  assign bindin2966 = bindout2596;
  assign bindin2969 = bindout2587;
  assign bindin2972 = bindout2590;
  assign bindin2975 = bindout2605;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3009), .io_INTERRUPT_in_interrupt_id_valid(bindin3012), .io_INTERRUPT_in_interrupt_id_ready(bindout3015), .io_out_interrupt(bindout3018), .io_out_interrupt_pc(bindout3021));
  assign bindin3009 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3012 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3362 = clk;
  assign bindin3363 = reset;
  JTAG __module15__(.clk(bindin3362), .reset(bindin3363), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3364), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3367), .io_JTAG_JTAG_TAP_in_clock_data(bindin3373), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3376), .io_JTAG_JTAG_TAP_in_reset_data(bindin3382), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3385), .io_JTAG_in_data_data(bindin3391), .io_JTAG_in_data_valid(bindin3394), .io_JTAG_out_data_ready(bindin3406), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3370), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3379), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3388), .io_JTAG_in_data_ready(bindout3397), .io_JTAG_out_data_data(bindout3400), .io_JTAG_out_data_valid(bindout3403));
  assign bindin3364 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3367 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3373 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3376 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3382 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3385 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3391 = io_jtag_in_data_data;
  assign bindin3394 = io_jtag_in_data_valid;
  assign bindin3406 = io_jtag_out_data_ready;
  assign bindin3434 = clk;
  CSR_Handler __module17__(.clk(bindin3434), .io_in_decode_csr_address(bindin3435), .io_in_mem_csr_address(bindin3438), .io_in_mem_is_csr(bindin3441), .io_in_mem_csr_result(bindin3444), .io_out_decode_csr_data(bindout3447));
  assign bindin3435 = bindout962;
  assign bindin3438 = bindout1994;
  assign bindin3441 = bindout1997;
  assign bindin3444 = bindout2000;
  assign orl3449 = bindout1010 | bindout1767;
  assign eq3454 = bindout1767 == 1'h1;

  assign io_IBUS_in_data_ready = bindout168;
  assign io_IBUS_out_address_data = bindout171;
  assign io_IBUS_out_address_valid = bindout174;
  assign io_DBUS_in_data_ready = bindout2390;
  assign io_DBUS_out_data_data = bindout2393;
  assign io_DBUS_out_data_valid = bindout2396;
  assign io_DBUS_out_address_data = bindout2402;
  assign io_DBUS_out_address_valid = bindout2405;
  assign io_DBUS_out_control_data = bindout2411;
  assign io_DBUS_out_control_valid = bindout2414;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3015;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3370;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3379;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3388;
  assign io_jtag_in_data_ready = bindout3397;
  assign io_jtag_out_data_data = bindout3400;
  assign io_jtag_out_data_valid = bindout3403;
  assign io_out_fwd_stall = bindout2987;
  assign io_out_branch_stall = orl3449;

endmodule
