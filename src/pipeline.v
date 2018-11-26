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
  wire[31:0] sel162, sel177, sel183, sel189, sel191, add217, add220, add223, add226;
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
      reg133 <= add217;
  end
  always @ (posedge clk) begin
    if (reset)
      reg139 <= 32'h0;
    else
      reg139 <= add220;
  end
  always @ (posedge clk) begin
    if (reset)
      reg145 <= 32'h0;
    else
      reg145 <= add223;
  end
  always @ (posedge clk) begin
    if (reset)
      reg151 <= 32'h0;
    else
      reg151 <= add226;
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
  assign add217 = sel162 + 32'h4;
  assign add220 = io_in_jal_dest + 32'h4;
  assign add223 = io_in_branch_dest + 32'h4;
  assign add226 = io_in_interrupt_pc + 32'h4;

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
  reg[31:0] reg302, reg311;
  wire eq332;
  wire[31:0] sel334, sel335;

  always @ (posedge clk) begin
    if (reset)
      reg302 <= 32'h0;
    else
      reg302 <= sel335;
  end
  always @ (posedge clk) begin
    if (reset)
      reg311 <= 32'h0;
    else
      reg311 <= sel334;
  end
  assign eq332 = io_in_fwd_stall == 1'h0;
  assign sel334 = eq332 ? io_in_curr_PC : reg311;
  assign sel335 = eq332 ? io_in_instruction : reg302;

  assign io_out_instruction = reg302;
  assign io_out_curr_PC = reg311;

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
  reg[31:0] mem437 [0:31];
  wire[31:0] mrport448, sel457, mrport459, sel466;
  wire eq455, eq464;

  always @ (posedge clk) begin
    if (io_in_write_register) begin
      mem437[io_in_rd] <= io_in_data;
    end
  end
  assign mrport448 = mem437[io_in_src1];
  assign mrport459 = mem437[io_in_src2];
  assign eq455 = io_in_src1 == 5'h0;
  assign sel457 = eq455 ? 32'h0 : mrport448;
  assign eq464 = io_in_src2 == 5'h0;
  assign sel466 = eq464 ? 32'h0 : mrport459;

  assign io_out_src1_data = sel457;
  assign io_out_src2_data = sel466;

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
  wire bindin473, bindin474, ne534, sel536, eq588, eq593, eq598, orl600, eq605, eq610, eq615, eq620, eq625, eq630, ne635, eq640, andl642, proxy645, eq646, andl649, eq653, andl659, orl671, orl673, orl675, orl677, orl688, orl690, orl697, sel699, proxy725, proxy733, eq751, proxy768, eq769, eq775, lt779, andl782, sel794, ne797, ge800, eq803, andl814, andl816, eq823, eq828, orl830, proxy852, eq904, eq941, eq949, eq957, orl963, lt981;
  wire[4:0] bindin477, bindin483, bindin486, proxy546, proxy553, proxy560;
  wire[31:0] bindin480, bindout489, bindout492, shr543, shr550, shr557, shr564, shr571, add583, sel661, pad663, sel665, shr729, pad742, proxy747, sel753, pad759, proxy764, sel771, sel792, shr856;
  wire[2:0] proxy567, sel703, sel706;
  wire[6:0] proxy574;
  wire[1:0] sel679, sel683, sel692, proxy936;
  wire[19:0] proxy709;
  reg[19:0] sel718;
  wire[7:0] proxy724;
  wire[9:0] proxy732;
  wire[20:0] proxy736;
  wire[11:0] proxy757, sel818, pad832, sel840, proxy843, proxy867;
  reg[31:0] sel793;
  reg sel795, sel894;
  wire[3:0] proxy859, sel906, sel909, sel926, sel943, sel951, sel959, sel965, sel967, sel971, sel975, sel983, sel985;
  wire[5:0] proxy865;
  reg[11:0] sel873;
  reg[2:0] sel892, sel893;
  reg[3:0] sel934;

  assign bindin473 = clk;
  RegisterFile __module5__(.clk(bindin473), .io_in_write_register(bindin474), .io_in_rd(bindin477), .io_in_data(bindin480), .io_in_src1(bindin483), .io_in_src2(bindin486), .io_out_src1_data(bindout489), .io_out_src2_data(bindout492));
  assign bindin474 = sel536;
  assign bindin477 = io_in_rd;
  assign bindin480 = io_in_write_data;
  assign bindin483 = proxy553;
  assign bindin486 = proxy560;
  assign ne534 = io_in_wb != 2'h0;
  assign sel536 = ne534 ? 1'h1 : 1'h0;
  assign shr543 = io_in_instruction >> 32'h7;
  assign proxy546 = shr543[4:0];
  assign shr550 = io_in_instruction >> 32'hf;
  assign proxy553 = shr550[4:0];
  assign shr557 = io_in_instruction >> 32'h14;
  assign proxy560 = shr557[4:0];
  assign shr564 = io_in_instruction >> 32'hc;
  assign proxy567 = shr564[2:0];
  assign shr571 = io_in_instruction >> 32'h19;
  assign proxy574 = shr571[6:0];
  assign add583 = io_in_curr_PC + 32'h4;
  assign eq588 = io_in_instruction[6:0] == 7'h33;
  assign eq593 = io_in_instruction[6:0] == 7'h3;
  assign eq598 = io_in_instruction[6:0] == 7'h13;
  assign orl600 = eq598 | eq593;
  assign eq605 = io_in_instruction[6:0] == 7'h23;
  assign eq610 = io_in_instruction[6:0] == 7'h63;
  assign eq615 = io_in_instruction[6:0] == 7'h6f;
  assign eq620 = io_in_instruction[6:0] == 7'h67;
  assign eq625 = io_in_instruction[6:0] == 7'h37;
  assign eq630 = io_in_instruction[6:0] == 7'h17;
  assign ne635 = proxy567 != 3'h0;
  assign eq640 = io_in_instruction[6:0] == 7'h73;
  assign andl642 = eq640 & ne635;
  assign proxy645 = proxy567[2];
  assign eq646 = proxy645 == 1'h1;
  assign andl649 = andl642 & eq646;
  assign eq653 = proxy567 == 3'h0;
  assign andl659 = eq640 & eq653;
  assign sel661 = eq615 ? io_in_curr_PC : bindout489;
  assign pad663 = {{27{1'b0}}, proxy553};
  assign sel665 = andl649 ? pad663 : sel661;
  assign orl671 = orl600 | eq588;
  assign orl673 = orl671 | eq625;
  assign orl675 = orl673 | eq630;
  assign orl677 = orl675 | andl642;
  assign sel679 = orl677 ? 2'h1 : 2'h0;
  assign sel683 = eq593 ? 2'h2 : sel679;
  assign orl688 = eq615 | eq620;
  assign orl690 = orl688 | andl659;
  assign sel692 = orl690 ? 2'h3 : sel683;
  assign orl697 = orl600 | eq605;
  assign sel699 = orl697 ? 1'h1 : 1'h0;
  assign sel703 = eq593 ? proxy567 : 3'h7;
  assign sel706 = eq605 ? proxy567 : 3'h7;
  assign proxy709 = {proxy574, proxy560, proxy553, proxy567};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h37: sel718 = proxy709;
      7'h17: sel718 = proxy709;
      default: sel718 = 20'h7b;
    endcase
  end
  assign proxy724 = shr564[7:0];
  assign proxy725 = io_in_instruction[20];
  assign shr729 = io_in_instruction >> 32'h15;
  assign proxy732 = shr729[9:0];
  assign proxy733 = io_in_instruction[31];
  assign proxy736 = {proxy733, proxy724, proxy725, proxy732, 1'h0};
  assign pad742 = {{11{1'b0}}, proxy736};
  assign proxy747 = {11'h7ff, proxy736};
  assign eq751 = proxy733 == 1'h1;
  assign sel753 = eq751 ? proxy747 : pad742;
  assign proxy757 = {proxy574, proxy560};
  assign pad759 = {{20{1'b0}}, proxy757};
  assign proxy764 = {20'hfffff, proxy757};
  assign proxy768 = proxy757[11];
  assign eq769 = proxy768 == 1'h1;
  assign sel771 = eq769 ? proxy764 : pad759;
  assign eq775 = proxy567 == 3'h0;
  assign lt779 = shr557[11:0] < 12'h2;
  assign andl782 = eq775 & lt779;
  assign sel792 = andl782 ? 32'hb0000000 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel793 = sel753;
      7'h67: sel793 = sel771;
      7'h73: sel793 = sel792;
      default: sel793 = 32'h7b;
    endcase
  end
  assign sel794 = andl782 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h6f: sel795 = 1'h1;
      7'h67: sel795 = 1'h1;
      7'h73: sel795 = sel794;
      default: sel795 = 1'h0;
    endcase
  end
  assign ne797 = proxy567 != 3'h0;
  assign ge800 = shr557[11:0] >= 12'h2;
  assign eq803 = io_in_instruction[6:0] == io_in_instruction[6:0];
  assign andl814 = ne797 & ge800;
  assign andl816 = andl814 & eq803;
  assign sel818 = andl816 ? shr557[11:0] : 12'h7b;
  assign eq823 = proxy567 == 3'h5;
  assign eq828 = proxy567 == 3'h1;
  assign orl830 = eq828 | eq823;
  assign pad832 = {{7{1'b0}}, proxy560};
  assign sel840 = orl830 ? pad832 : shr557[11:0];
  assign proxy843 = {proxy574, proxy546};
  assign proxy852 = io_in_instruction[7];
  assign shr856 = io_in_instruction >> 32'h8;
  assign proxy859 = shr856[3:0];
  assign proxy865 = shr571[5:0];
  assign proxy867 = {proxy733, proxy852, proxy865, proxy859};
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel873 = sel840;
      7'h23: sel873 = proxy843;
      7'h03: sel873 = shr557[11:0];
      7'h63: sel873 = proxy867;
      default: sel873 = 12'h7b;
    endcase
  end
  always @(*) begin
    case (proxy567)
      3'h0: sel892 = 3'h1;
      3'h1: sel892 = 3'h2;
      3'h4: sel892 = 3'h3;
      3'h5: sel892 = 3'h4;
      3'h6: sel892 = 3'h5;
      3'h7: sel892 = 3'h6;
      default: sel892 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel893 = sel892;
      7'h6f: sel893 = 3'h0;
      7'h67: sel893 = 3'h0;
      default: sel893 = 3'h0;
    endcase
  end
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h63: sel894 = 1'h1;
      7'h6f: sel894 = 1'h1;
      7'h67: sel894 = 1'h1;
      default: sel894 = 1'h0;
    endcase
  end
  assign eq904 = proxy574 == 7'h0;
  assign sel906 = eq904 ? 4'h0 : 4'h1;
  assign sel909 = eq598 ? 4'h0 : sel906;
  assign sel926 = eq904 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy567)
      3'h0: sel934 = sel909;
      3'h1: sel934 = 4'h2;
      3'h2: sel934 = 4'h3;
      3'h3: sel934 = 4'h4;
      3'h4: sel934 = 4'h5;
      3'h5: sel934 = sel926;
      3'h6: sel934 = 4'h8;
      3'h7: sel934 = 4'h9;
      default: sel934 = 4'hf;
    endcase
  end
  assign proxy936 = proxy567[1:0];
  assign eq941 = proxy936 == 2'h3;
  assign sel943 = eq941 ? 4'hf : 4'hf;
  assign eq949 = proxy936 == 2'h2;
  assign sel951 = eq949 ? 4'he : sel943;
  assign eq957 = proxy936 == 2'h1;
  assign sel959 = eq957 ? 4'hd : sel951;
  assign orl963 = eq605 | eq593;
  assign sel965 = orl963 ? 4'h0 : sel934;
  assign sel967 = andl642 ? sel959 : sel965;
  assign sel971 = eq630 ? 4'hc : sel967;
  assign sel975 = eq625 ? 4'hb : sel971;
  assign lt981 = sel893 < 3'h5;
  assign sel983 = lt981 ? 4'h1 : 4'ha;
  assign sel985 = eq610 ? sel983 : sel975;

  assign io_out_csr_address = sel818;
  assign io_out_is_csr = andl642;
  assign io_out_csr_mask = sel665;
  assign io_out_rd = proxy546;
  assign io_out_rs1 = proxy553;
  assign io_out_rd1 = sel661;
  assign io_out_rs2 = proxy560;
  assign io_out_rd2 = bindout492;
  assign io_out_wb = sel692;
  assign io_out_alu_op = sel985;
  assign io_out_rs2_src = sel699;
  assign io_out_itype_immed = sel873;
  assign io_out_mem_read = sel703;
  assign io_out_mem_write = sel706;
  assign io_out_branch_type = sel893;
  assign io_out_branch_stall = sel894;
  assign io_out_jal = sel795;
  assign io_out_jal_offset = sel793;
  assign io_out_upper_immed = sel718;
  assign io_out_PC_next = add583;

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
  reg[4:0] reg1155, reg1164, reg1177;
  reg[31:0] reg1171, reg1183, reg1203, reg1262, reg1268, reg1280;
  reg[3:0] reg1190;
  reg[1:0] reg1197;
  reg reg1210, reg1256, reg1274;
  reg[11:0] reg1217, reg1250;
  reg[2:0] reg1224, reg1230, reg1237;
  reg[19:0] reg1244;
  wire eq1284, eq1288, orl1290, sel1318, sel1340, sel1346;
  wire[4:0] sel1293, sel1296, sel1302;
  wire[31:0] sel1299, sel1305, sel1315, sel1343, sel1349, sel1352;
  wire[3:0] sel1309;
  wire[1:0] sel1312;
  wire[11:0] sel1322, sel1337;
  wire[2:0] sel1325, sel1328, sel1331;
  wire[19:0] sel1334;

  always @ (posedge clk) begin
    if (reset)
      reg1155 <= 5'h0;
    else
      reg1155 <= sel1293;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1164 <= 5'h0;
    else
      reg1164 <= sel1296;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1171 <= 32'h0;
    else
      reg1171 <= sel1299;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1177 <= 5'h0;
    else
      reg1177 <= sel1302;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1183 <= 32'h0;
    else
      reg1183 <= sel1305;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1190 <= 4'h0;
    else
      reg1190 <= sel1309;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1197 <= 2'h0;
    else
      reg1197 <= sel1312;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1203 <= 32'h0;
    else
      reg1203 <= sel1315;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1210 <= 1'h0;
    else
      reg1210 <= sel1318;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1217 <= 12'h0;
    else
      reg1217 <= sel1322;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1224 <= 3'h7;
    else
      reg1224 <= sel1325;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1230 <= 3'h7;
    else
      reg1230 <= sel1328;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1237 <= 3'h0;
    else
      reg1237 <= sel1331;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1244 <= 20'h0;
    else
      reg1244 <= sel1334;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1250 <= 12'h0;
    else
      reg1250 <= sel1337;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1256 <= 1'h0;
    else
      reg1256 <= sel1340;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1262 <= 32'h0;
    else
      reg1262 <= sel1343;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1268 <= 32'h0;
    else
      reg1268 <= sel1352;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1274 <= 1'h0;
    else
      reg1274 <= sel1346;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1280 <= 32'h0;
    else
      reg1280 <= sel1349;
  end
  assign eq1284 = io_in_branch_stall == 1'h1;
  assign eq1288 = io_in_fwd_stall == 1'h1;
  assign orl1290 = eq1288 | eq1284;
  assign sel1293 = orl1290 ? 5'h0 : io_in_rd;
  assign sel1296 = orl1290 ? 5'h0 : io_in_rs1;
  assign sel1299 = orl1290 ? 32'h0 : io_in_rd1;
  assign sel1302 = orl1290 ? 5'h0 : io_in_rs2;
  assign sel1305 = orl1290 ? 32'h0 : io_in_rd2;
  assign sel1309 = orl1290 ? 4'hf : io_in_alu_op;
  assign sel1312 = orl1290 ? 2'h0 : io_in_wb;
  assign sel1315 = orl1290 ? 32'h0 : io_in_PC_next;
  assign sel1318 = orl1290 ? 1'h0 : io_in_rs2_src;
  assign sel1322 = orl1290 ? 12'h7b : io_in_itype_immed;
  assign sel1325 = orl1290 ? 3'h7 : io_in_mem_read;
  assign sel1328 = orl1290 ? 3'h7 : io_in_mem_write;
  assign sel1331 = orl1290 ? 3'h0 : io_in_branch_type;
  assign sel1334 = orl1290 ? 20'h0 : io_in_upper_immed;
  assign sel1337 = orl1290 ? 12'h0 : io_in_csr_address;
  assign sel1340 = orl1290 ? 1'h0 : io_in_is_csr;
  assign sel1343 = orl1290 ? 32'h0 : io_in_csr_mask;
  assign sel1346 = orl1290 ? 1'h0 : io_in_jal;
  assign sel1349 = orl1290 ? 32'h0 : io_in_jal_offset;
  assign sel1352 = orl1290 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1250;
  assign io_out_is_csr = reg1256;
  assign io_out_csr_mask = reg1262;
  assign io_out_rd = reg1155;
  assign io_out_rs1 = reg1164;
  assign io_out_rd1 = reg1171;
  assign io_out_rs2 = reg1177;
  assign io_out_rd2 = reg1183;
  assign io_out_alu_op = reg1190;
  assign io_out_wb = reg1197;
  assign io_out_rs2_src = reg1210;
  assign io_out_itype_immed = reg1217;
  assign io_out_mem_read = reg1224;
  assign io_out_mem_write = reg1230;
  assign io_out_branch_type = reg1237;
  assign io_out_upper_immed = reg1244;
  assign io_out_curr_PC = reg1268;
  assign io_out_jal = reg1274;
  assign io_out_jal_offset = reg1280;
  assign io_out_PC_next = reg1203;

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
  wire[31:0] pad1555, proxy1560, sel1568, sel1575, proxy1580, add1583, add1586, sub1591, shl1595, sel1605, sel1614, xorl1619, shr1623, shr1628, orl1633, andl1638, add1651, orl1657, sub1661, andl1664, sel1669;
  wire eq1566, eq1573, lt1603, lt1612, ge1642, ne1677, sel1679;
  reg[31:0] sel1668, sel1670;

  assign pad1555 = {{20{1'b0}}, io_in_itype_immed};
  assign proxy1560 = {20'hfffff, io_in_itype_immed};
  assign eq1566 = io_in_itype_immed[11] == 1'h1;
  assign sel1568 = eq1566 ? proxy1560 : pad1555;
  assign eq1573 = io_in_rs2_src == 1'h1;
  assign sel1575 = eq1573 ? sel1568 : io_in_rd2;
  assign proxy1580 = {io_in_upper_immed, 12'h0};
  assign add1583 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1586 = $signed(io_in_rd1) + $signed(sel1575);
  assign sub1591 = $signed(io_in_rd1) - $signed(sel1575);
  assign shl1595 = io_in_rd1 << sel1575;
  assign lt1603 = $signed(io_in_rd1) < $signed(sel1575);
  assign sel1605 = lt1603 ? 32'h1 : 32'h0;
  assign lt1612 = io_in_rd1 < sel1575;
  assign sel1614 = lt1612 ? 32'h1 : 32'h0;
  assign xorl1619 = io_in_rd1 ^ sel1575;
  assign shr1623 = io_in_rd1 >> sel1575;
  assign shr1628 = $signed(io_in_rd1) >> sel1575;
  assign orl1633 = io_in_rd1 | sel1575;
  assign andl1638 = sel1575 & io_in_rd1;
  assign ge1642 = io_in_rd1 >= sel1575;
  assign add1651 = $signed(io_in_curr_PC) + $signed(proxy1580);
  assign orl1657 = io_in_csr_data | io_in_csr_mask;
  assign sub1661 = 32'hffffffff - io_in_csr_mask;
  assign andl1664 = io_in_csr_data & sub1661;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1668 = 32'h7b;
      4'h1: sel1668 = 32'h7b;
      4'h2: sel1668 = 32'h7b;
      4'h3: sel1668 = 32'h7b;
      4'h4: sel1668 = 32'h7b;
      4'h5: sel1668 = 32'h7b;
      4'h6: sel1668 = 32'h7b;
      4'h7: sel1668 = 32'h7b;
      4'h8: sel1668 = 32'h7b;
      4'h9: sel1668 = 32'h7b;
      4'ha: sel1668 = 32'h7b;
      4'hb: sel1668 = 32'h7b;
      4'hc: sel1668 = 32'h7b;
      4'hd: sel1668 = io_in_csr_mask;
      4'he: sel1668 = orl1657;
      4'hf: sel1668 = andl1664;
      default: sel1668 = 32'h7b;
    endcase
  end
  assign sel1669 = ge1642 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1670 = add1586;
      4'h1: sel1670 = sub1591;
      4'h2: sel1670 = shl1595;
      4'h3: sel1670 = sel1605;
      4'h4: sel1670 = sel1614;
      4'h5: sel1670 = xorl1619;
      4'h6: sel1670 = shr1623;
      4'h7: sel1670 = shr1628;
      4'h8: sel1670 = orl1633;
      4'h9: sel1670 = andl1638;
      4'ha: sel1670 = sel1669;
      4'hb: sel1670 = proxy1580;
      4'hc: sel1670 = add1651;
      4'hd: sel1670 = io_in_csr_data;
      4'he: sel1670 = io_in_csr_data;
      4'hf: sel1670 = io_in_csr_data;
      default: sel1670 = 32'h0;
    endcase
  end
  assign ne1677 = io_in_branch_type != 3'h0;
  assign sel1679 = ne1677 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1668;
  assign io_out_alu_result = sel1670;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1583;
  assign io_out_branch_offset = sel1568;
  assign io_out_branch_stall = sel1679;
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
  reg[31:0] reg1866, reg1888, reg1900, reg1913, reg1946, reg1952, reg1958;
  reg[4:0] reg1876, reg1882, reg1894;
  reg[1:0] reg1907;
  reg[2:0] reg1920, reg1926, reg1964;
  reg[11:0] reg1933;
  reg reg1940;

  always @ (posedge clk) begin
    if (reset)
      reg1866 <= 32'h0;
    else
      reg1866 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1876 <= 5'h0;
    else
      reg1876 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1882 <= 5'h0;
    else
      reg1882 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1888 <= 32'h0;
    else
      reg1888 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1894 <= 5'h0;
    else
      reg1894 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1900 <= 32'h0;
    else
      reg1900 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1907 <= 2'h0;
    else
      reg1907 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1913 <= 32'h0;
    else
      reg1913 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1920 <= 3'h0;
    else
      reg1920 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1926 <= 3'h0;
    else
      reg1926 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1933 <= 12'h0;
    else
      reg1933 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1940 <= 1'h0;
    else
      reg1940 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1946 <= 32'h0;
    else
      reg1946 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1952 <= 32'h0;
    else
      reg1952 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1958 <= 32'h0;
    else
      reg1958 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1964 <= 3'h0;
    else
      reg1964 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg1933;
  assign io_out_is_csr = reg1940;
  assign io_out_csr_result = reg1946;
  assign io_out_alu_result = reg1866;
  assign io_out_rd = reg1876;
  assign io_out_wb = reg1907;
  assign io_out_rs1 = reg1882;
  assign io_out_rd1 = reg1888;
  assign io_out_rd2 = reg1900;
  assign io_out_rs2 = reg1894;
  assign io_out_mem_read = reg1920;
  assign io_out_mem_write = reg1926;
  assign io_out_curr_PC = reg1952;
  assign io_out_branch_offset = reg1958;
  assign io_out_branch_type = reg1964;
  assign io_out_PC_next = reg1913;

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
  wire lt2166, lt2169, orl2171, eq2179, eq2193, eq2197, andl2199, eq2220, eq2224, andl2226, orl2229, proxy2246, eq2247, proxy2264, eq2265;
  wire[1:0] sel2205, sel2209, sel2213;
  wire[7:0] proxy2238;
  wire[31:0] pad2239, proxy2242, sel2249, pad2257, proxy2260, sel2267;
  wire[15:0] proxy2256;
  reg[31:0] sel2283;

  assign lt2166 = io_in_mem_write < 3'h7;
  assign lt2169 = io_in_mem_read < 3'h7;
  assign orl2171 = lt2169 | lt2166;
  assign eq2179 = io_in_mem_write == 3'h2;
  assign eq2193 = io_in_mem_write == 3'h7;
  assign eq2197 = io_in_mem_read == 3'h7;
  assign andl2199 = eq2197 & eq2193;
  assign sel2205 = andl2199 ? 2'h0 : 2'h3;
  assign sel2209 = eq2179 ? 2'h2 : sel2205;
  assign sel2213 = lt2169 ? 2'h1 : sel2209;
  assign eq2220 = eq2179 == 1'h0;
  assign eq2224 = andl2199 == 1'h0;
  assign andl2226 = eq2224 & eq2220;
  assign orl2229 = lt2169 | andl2226;
  assign proxy2238 = io_DBUS_in_data_data[7:0];
  assign pad2239 = {{24{1'b0}}, proxy2238};
  assign proxy2242 = {24'hffffff, proxy2238};
  assign proxy2246 = proxy2238[7];
  assign eq2247 = proxy2246 == 1'h1;
  assign sel2249 = eq2247 ? proxy2242 : pad2239;
  assign proxy2256 = io_DBUS_in_data_data[15:0];
  assign pad2257 = {{16{1'b0}}, proxy2256};
  assign proxy2260 = {16'hffff, proxy2256};
  assign proxy2264 = proxy2256[15];
  assign eq2265 = proxy2264 == 1'h1;
  assign sel2267 = eq2265 ? proxy2260 : pad2257;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2283 = sel2249;
      3'h1: sel2283 = sel2267;
      3'h2: sel2283 = io_DBUS_in_data_data;
      3'h4: sel2283 = pad2239;
      3'h5: sel2283 = pad2257;
      default: sel2283 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2229;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2166;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2171;
  assign io_DBUS_out_control_data = sel2213;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2283;

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
  wire[31:0] bindin2290, bindout2299, bindout2308, bindin2326, bindin2335, bindout2338, shl2341, add2343;
  wire bindin2293, bindout2296, bindout2302, bindin2305, bindout2311, bindin2314, bindout2320, bindin2323, eq2353, sel2355, sel2364, eq2371, sel2373, sel2382;
  wire[1:0] bindout2317;
  wire[2:0] bindin2329, bindin2332;
  reg sel2405;

  Cache __module10__(.io_DBUS_in_data_data(bindin2290), .io_DBUS_in_data_valid(bindin2293), .io_DBUS_out_data_ready(bindin2305), .io_DBUS_out_address_ready(bindin2314), .io_DBUS_out_control_ready(bindin2323), .io_in_address(bindin2326), .io_in_mem_read(bindin2329), .io_in_mem_write(bindin2332), .io_in_data(bindin2335), .io_DBUS_in_data_ready(bindout2296), .io_DBUS_out_data_data(bindout2299), .io_DBUS_out_data_valid(bindout2302), .io_DBUS_out_address_data(bindout2308), .io_DBUS_out_address_valid(bindout2311), .io_DBUS_out_control_data(bindout2317), .io_DBUS_out_control_valid(bindout2320), .io_out_data(bindout2338));
  assign bindin2290 = io_DBUS_in_data_data;
  assign bindin2293 = io_DBUS_in_data_valid;
  assign bindin2305 = io_DBUS_out_data_ready;
  assign bindin2314 = io_DBUS_out_address_ready;
  assign bindin2323 = io_DBUS_out_control_ready;
  assign bindin2326 = io_in_alu_result;
  assign bindin2329 = io_in_mem_read;
  assign bindin2332 = io_in_mem_write;
  assign bindin2335 = io_in_rd2;
  assign shl2341 = $signed(io_in_branch_offset) << 32'h1;
  assign add2343 = $signed(io_in_curr_PC) + $signed(shl2341);
  assign eq2353 = io_in_alu_result == 32'h0;
  assign sel2355 = eq2353 ? 1'h1 : 1'h0;
  assign sel2364 = eq2353 ? 1'h0 : 1'h1;
  assign eq2371 = io_in_alu_result[31] == 1'h0;
  assign sel2373 = eq2371 ? 1'h0 : 1'h1;
  assign sel2382 = eq2371 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2405 = sel2355;
      3'h2: sel2405 = sel2364;
      3'h3: sel2405 = sel2373;
      3'h4: sel2405 = sel2382;
      3'h5: sel2405 = sel2373;
      3'h6: sel2405 = sel2382;
      3'h0: sel2405 = 1'h0;
      default: sel2405 = 1'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = bindout2296;
  assign io_DBUS_out_data_data = bindout2299;
  assign io_DBUS_out_data_valid = bindout2302;
  assign io_DBUS_out_address_data = bindout2308;
  assign io_DBUS_out_address_valid = bindout2311;
  assign io_DBUS_out_control_data = bindout2317;
  assign io_DBUS_out_control_valid = bindout2320;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2338;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2405;
  assign io_out_branch_dest = add2343;
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
  reg[31:0] reg2543, reg2552, reg2584;
  reg[4:0] reg2559, reg2565, reg2571;
  reg[1:0] reg2578;

  always @ (posedge clk) begin
    if (reset)
      reg2543 <= 32'h0;
    else
      reg2543 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2552 <= 32'h0;
    else
      reg2552 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2559 <= 5'h0;
    else
      reg2559 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2565 <= 5'h0;
    else
      reg2565 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2571 <= 5'h0;
    else
      reg2571 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2578 <= 2'h0;
    else
      reg2578 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2584 <= 32'h0;
    else
      reg2584 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2543;
  assign io_out_mem_result = reg2552;
  assign io_out_rd = reg2559;
  assign io_out_wb = reg2578;
  assign io_out_rs1 = reg2565;
  assign io_out_rs2 = reg2571;
  assign io_out_PC_next = reg2584;

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
  wire eq2650, eq2655;
  wire[31:0] sel2657, sel2659;

  assign eq2650 = io_in_wb == 2'h3;
  assign eq2655 = io_in_wb == 2'h1;
  assign sel2657 = eq2655 ? io_in_alu_result : io_in_mem_result;
  assign sel2659 = eq2650 ? io_in_PC_next : sel2657;

  assign io_out_write_data = sel2659;
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
  wire eq2756, eq2760, ne2765, ne2770, eq2773, andl2775, andl2777, eq2782, ne2786, eq2793, andl2795, andl2797, andl2799, eq2803, ne2811, eq2818, andl2820, andl2822, andl2824, andl2826, orl2829, orl2831, ne2839, eq2842, andl2844, andl2846, eq2850, eq2861, andl2863, andl2865, andl2867, eq2871, eq2886, andl2888, andl2890, andl2892, andl2894, orl2897, orl2899, eq2902, andl2904, eq2908, eq2911, andl2913, andl2915, orl2918, orl2925, orl2927, orl2929;

  assign eq2756 = io_in_execute_is_csr == 1'h1;
  assign eq2760 = io_in_memory_is_csr == 1'h1;
  assign ne2765 = io_in_execute_wb != 2'h0;
  assign ne2770 = io_in_decode_src1 != 5'h0;
  assign eq2773 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2775 = eq2773 & ne2770;
  assign andl2777 = andl2775 & ne2765;
  assign eq2782 = andl2777 == 1'h0;
  assign ne2786 = io_in_memory_wb != 2'h0;
  assign eq2793 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2795 = eq2793 & ne2770;
  assign andl2797 = andl2795 & ne2786;
  assign andl2799 = andl2797 & eq2782;
  assign eq2803 = andl2799 == 1'h0;
  assign ne2811 = io_in_writeback_wb != 2'h0;
  assign eq2818 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2820 = eq2818 & ne2770;
  assign andl2822 = andl2820 & ne2811;
  assign andl2824 = andl2822 & eq2782;
  assign andl2826 = andl2824 & eq2803;
  assign orl2829 = andl2777 | andl2799;
  assign orl2831 = orl2829 | andl2826;
  assign ne2839 = io_in_decode_src2 != 5'h0;
  assign eq2842 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2844 = eq2842 & ne2839;
  assign andl2846 = andl2844 & ne2765;
  assign eq2850 = andl2846 == 1'h0;
  assign eq2861 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2863 = eq2861 & ne2839;
  assign andl2865 = andl2863 & ne2786;
  assign andl2867 = andl2865 & eq2850;
  assign eq2871 = andl2867 == 1'h0;
  assign eq2886 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2888 = eq2886 & ne2839;
  assign andl2890 = andl2888 & ne2811;
  assign andl2892 = andl2890 & eq2850;
  assign andl2894 = andl2892 & eq2871;
  assign orl2897 = andl2846 | andl2867;
  assign orl2899 = orl2897 | andl2894;
  assign eq2902 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2904 = eq2902 & eq2756;
  assign eq2908 = andl2904 == 1'h0;
  assign eq2911 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2913 = eq2911 & eq2760;
  assign andl2915 = andl2913 & eq2908;
  assign orl2918 = andl2904 | andl2915;
  assign orl2925 = orl2831 | andl2846;
  assign orl2927 = orl2925 | andl2867;
  assign orl2929 = orl2927 | andl2894;

  assign io_out_src1_fwd = orl2831;
  assign io_out_src2_fwd = orl2899;
  assign io_out_csr_fwd = orl2918;
  assign io_out_fwd_stall = orl2929;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3024 [0:1];
  wire[31:0] mrport3026, sel3030;

  initial begin
    mem3024[0] = 32'hdeadbeef;
    mem3024[1] = 32'hdeadbeef;
  end
  assign mrport3026 = mem3024[io_INTERRUPT_in_interrupt_id_data];
  assign sel3030 = io_INTERRUPT_in_interrupt_id_valid ? mrport3026 : 32'hdeadbeef;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = sel3030;

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
  reg[3:0] reg3098, sel3188;
  wire eq3106, andl3191, eq3195, andl3199, eq3203, andl3207;
  wire[3:0] sel3112, sel3117, sel3123, sel3129, sel3139, sel3144, sel3148, sel3157, sel3163, sel3173, sel3178, sel3182, sel3189, sel3205, sel3206, sel3208;

  always @ (posedge clk) begin
    if (reset)
      reg3098 <= 4'h0;
    else
      reg3098 <= sel3208;
  end
  assign eq3106 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3112 = eq3106 ? 4'h0 : 4'h1;
  assign sel3117 = eq3106 ? 4'h2 : 4'h1;
  assign sel3123 = eq3106 ? 4'h9 : 4'h3;
  assign sel3129 = eq3106 ? 4'h5 : 4'h4;
  assign sel3139 = eq3106 ? 4'h8 : 4'h6;
  assign sel3144 = eq3106 ? 4'h7 : 4'h6;
  assign sel3148 = eq3106 ? 4'h4 : 4'h8;
  assign sel3157 = eq3106 ? 4'h0 : 4'ha;
  assign sel3163 = eq3106 ? 4'hc : 4'hb;
  assign sel3173 = eq3106 ? 4'hf : 4'hd;
  assign sel3178 = eq3106 ? 4'he : 4'hd;
  assign sel3182 = eq3106 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3098)
      4'h0: sel3188 = sel3112;
      4'h1: sel3188 = sel3117;
      4'h2: sel3188 = sel3123;
      4'h3: sel3188 = sel3129;
      4'h4: sel3188 = sel3129;
      4'h5: sel3188 = sel3139;
      4'h6: sel3188 = sel3144;
      4'h7: sel3188 = sel3148;
      4'h8: sel3188 = sel3117;
      4'h9: sel3188 = sel3157;
      4'ha: sel3188 = sel3163;
      4'hb: sel3188 = sel3163;
      4'hc: sel3188 = sel3173;
      4'hd: sel3188 = sel3178;
      4'he: sel3188 = sel3182;
      4'hf: sel3188 = sel3117;
      default: sel3188 = reg3098;
    endcase
  end
  assign sel3189 = io_JTAG_TAP_in_mode_select_valid ? sel3188 : 4'h0;
  assign andl3191 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3195 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3199 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3203 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3205 = eq3195 ? 4'h0 : reg3098;
  assign sel3206 = andl3207 ? sel3189 : reg3098;
  assign andl3207 = andl3199 & eq3203;
  assign sel3208 = andl3191 ? sel3205 : sel3206;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3098;

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
  wire bindin3214, bindin3216, bindin3217, bindin3220, bindout3223, bindin3226, bindin3229, bindout3232, bindin3235, bindin3238, bindout3241, eq3278, eq3287, eq3292, eq3369, andl3370, sel3371, sel3378;
  wire[3:0] bindout3244;
  reg[31:0] reg3252, reg3259, reg3266, reg3273, sel3377;
  wire[31:0] sel3295, sel3297, shr3304, proxy3309, sel3364, sel3365, sel3366, sel3367, sel3368;
  wire[30:0] proxy3307;
  reg sel3376, sel3383;

  assign bindin3214 = clk;
  assign bindin3216 = reset;
  TAP __module16__(.clk(bindin3214), .reset(bindin3216), .io_JTAG_TAP_in_mode_select_data(bindin3217), .io_JTAG_TAP_in_mode_select_valid(bindin3220), .io_JTAG_TAP_in_clock_data(bindin3226), .io_JTAG_TAP_in_clock_valid(bindin3229), .io_JTAG_TAP_in_reset_data(bindin3235), .io_JTAG_TAP_in_reset_valid(bindin3238), .io_JTAG_TAP_in_mode_select_ready(bindout3223), .io_JTAG_TAP_in_clock_ready(bindout3232), .io_JTAG_TAP_in_reset_ready(bindout3241), .io_out_curr_state(bindout3244));
  assign bindin3217 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3220 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3226 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3229 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3235 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3238 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3252 <= 32'h0;
    else
      reg3252 <= sel3364;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3259 <= 32'h1234;
    else
      reg3259 <= sel3367;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3266 <= 32'h5678;
    else
      reg3266 <= sel3368;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3273 <= 32'h0;
    else
      reg3273 <= sel3377;
  end
  assign eq3278 = reg3252 == 32'h0;
  assign eq3287 = reg3252 == 32'h1;
  assign eq3292 = reg3252 == 32'h2;
  assign sel3295 = eq3292 ? reg3259 : 32'hdeadbeef;
  assign sel3297 = eq3287 ? reg3266 : sel3295;
  assign shr3304 = reg3273 >> 32'h1;
  assign proxy3307 = shr3304[30:0];
  assign proxy3309 = {io_JTAG_in_data_data, proxy3307};
  assign sel3364 = (bindout3244 == 4'hf) ? reg3273 : reg3252;
  assign sel3365 = eq3292 ? reg3273 : reg3259;
  assign sel3366 = eq3287 ? reg3259 : sel3365;
  assign sel3367 = (bindout3244 == 4'h8) ? sel3366 : reg3259;
  assign sel3368 = andl3370 ? reg3273 : reg3266;
  assign eq3369 = bindout3244 == 4'h8;
  assign andl3370 = eq3369 & eq3287;
  assign sel3371 = eq3278 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3244)
      4'h3: sel3376 = sel3371;
      4'h4: sel3376 = 1'h1;
      4'h8: sel3376 = sel3371;
      4'ha: sel3376 = sel3371;
      4'hb: sel3376 = 1'h1;
      4'hf: sel3376 = sel3371;
      default: sel3376 = sel3371;
    endcase
  end
  always @(*) begin
    case (bindout3244)
      4'h3: sel3377 = sel3297;
      4'h4: sel3377 = proxy3309;
      4'ha: sel3377 = reg3252;
      4'hb: sel3377 = proxy3309;
      default: sel3377 = reg3273;
    endcase
  end
  assign sel3378 = eq3278 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3244)
      4'h3: sel3383 = sel3378;
      4'h4: sel3383 = reg3273[0];
      4'h8: sel3383 = sel3378;
      4'ha: sel3383 = sel3378;
      4'hb: sel3383 = reg3273[0];
      4'hf: sel3383 = sel3378;
      default: sel3383 = sel3378;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3223;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3232;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3241;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3383;
  assign io_JTAG_out_data_valid = sel3376;

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
  reg[11:0] mem3439 [0:4095];
  reg[11:0] reg3448;
  wire[11:0] proxy3458, mrport3460;
  wire[31:0] pad3462;

  always @ (posedge clk) begin
    if (io_in_mem_is_csr) begin
      mem3439[io_in_mem_csr_address] <= proxy3458;
    end
  end
  assign mrport3460 = mem3439[reg3448];
  always @ (posedge clk) begin
    if (reset)
      reg3448 <= 12'h0;
    else
      reg3448 <= io_in_decode_csr_address;
  end
  assign proxy3458 = io_in_mem_csr_result[11:0];
  assign pad3462 = {{20{1'b0}}, mrport3460};

  assign io_out_decode_csr_data = pad3462;

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
  wire bindin233, bindin235, bindin239, bindout242, bindout248, bindin251, bindin254, bindin260, bindin263, bindin266, bindin269, bindin275, bindin339, bindin340, bindin347, bindin350, bindin353, bindin990, bindin997, bindout1012, bindout1039, bindout1054, bindout1057, bindin1357, bindin1358, bindin1380, bindin1398, bindin1401, bindin1410, bindin1419, bindout1428, bindout1455, bindout1476, bindin1705, bindin1729, bindin1738, bindout1750, bindout1783, bindout1792, bindin1969, bindin1970, bindin2004, bindout2022, bindin2412, bindout2415, bindout2421, bindin2424, bindout2430, bindin2433, bindout2439, bindin2442, bindout2502, bindin2589, bindin2590, bindin2955, bindin2979, bindout3012, bindin3034, bindin3037, bindout3040, bindout3043, bindin3387, bindin3388, bindin3389, bindin3392, bindout3395, bindin3398, bindin3401, bindout3404, bindin3407, bindin3410, bindout3413, bindin3416, bindin3419, bindout3422, bindout3425, bindout3428, bindin3431, bindin3467, bindin3468, bindin3475, orl3483, eq3488;
  wire[31:0] bindin236, bindout245, bindin257, bindin272, bindin278, bindout281, bindout284, bindin341, bindin344, bindout356, bindout359, bindin991, bindin994, bindin1000, bindout1015, bindout1024, bindout1030, bindout1060, bindout1066, bindin1365, bindin1371, bindin1392, bindin1413, bindin1416, bindin1422, bindout1431, bindout1440, bindout1446, bindout1473, bindout1479, bindout1482, bindin1690, bindin1696, bindin1717, bindin1732, bindin1735, bindin1741, bindin1744, bindout1753, bindout1756, bindout1768, bindout1774, bindout1786, bindout1789, bindout1795, bindin1971, bindin1983, bindin1989, bindin1998, bindin2007, bindin2010, bindin2013, bindout2025, bindout2028, bindout2040, bindout2043, bindout2055, bindout2058, bindout2064, bindin2409, bindout2418, bindout2427, bindin2445, bindin2463, bindin2469, bindin2472, bindin2475, bindin2478, bindout2484, bindout2487, bindout2505, bindout2508, bindin2591, bindin2594, bindin2609, bindout2612, bindout2615, bindout2630, bindin2664, bindin2667, bindin2682, bindout2685, bindin2949, bindin2952, bindin2961, bindin2970, bindin2973, bindin2976, bindin2985, bindin2994, bindin2997, bindin3000, bindout3046, bindin3478, bindout3481;
  wire[4:0] bindin1003, bindout1018, bindout1021, bindout1027, bindin1359, bindin1362, bindin1368, bindout1434, bindout1437, bindout1443, bindin1684, bindin1687, bindin1693, bindout1759, bindout1765, bindout1771, bindin1974, bindin1980, bindin1986, bindout2031, bindout2037, bindout2046, bindin2454, bindin2460, bindin2466, bindout2490, bindout2496, bindout2499, bindin2597, bindin2603, bindin2606, bindout2618, bindout2624, bindout2627, bindin2670, bindin2676, bindin2679, bindout2688, bindin2934, bindin2937, bindin2943, bindin2964, bindin2988;
  wire[1:0] bindin1006, bindout1033, bindin1377, bindout1452, bindin1702, bindout1762, bindin1977, bindout2034, bindout2436, bindin2457, bindout2493, bindin2600, bindout2621, bindin2673, bindout2691, bindin2946, bindin2967, bindin2991;
  wire[11:0] bindout1009, bindout1042, bindin1383, bindin1407, bindout1425, bindout1458, bindin1708, bindin1726, bindout1747, bindin2001, bindout2019, bindin2940, bindin2958, bindin2982, bindin3469, bindin3472;
  wire[3:0] bindout1036, bindin1374, bindout1449, bindin1699;
  wire[2:0] bindout1045, bindout1048, bindout1051, bindin1386, bindin1389, bindin1395, bindout1461, bindout1464, bindout1467, bindin1711, bindin1714, bindin1720, bindout1777, bindout1780, bindin1992, bindin1995, bindin2016, bindout2049, bindout2052, bindout2061, bindin2448, bindin2451, bindin2481;
  wire[19:0] bindout1063, bindin1404, bindout1470, bindin1723;

  assign bindin233 = clk;
  assign bindin235 = reset;
  Fetch __module2__(.clk(bindin233), .reset(bindin235), .io_IBUS_in_data_data(bindin236), .io_IBUS_in_data_valid(bindin239), .io_IBUS_out_address_ready(bindin251), .io_in_branch_dir(bindin254), .io_in_branch_dest(bindin257), .io_in_branch_stall(bindin260), .io_in_fwd_stall(bindin263), .io_in_branch_stall_exe(bindin266), .io_in_jal(bindin269), .io_in_jal_dest(bindin272), .io_in_interrupt(bindin275), .io_in_interrupt_pc(bindin278), .io_IBUS_in_data_ready(bindout242), .io_IBUS_out_address_data(bindout245), .io_IBUS_out_address_valid(bindout248), .io_out_instruction(bindout281), .io_out_curr_PC(bindout284));
  assign bindin236 = io_IBUS_in_data_data;
  assign bindin239 = io_IBUS_in_data_valid;
  assign bindin251 = io_IBUS_out_address_ready;
  assign bindin254 = bindout2502;
  assign bindin257 = bindout2505;
  assign bindin260 = bindout1054;
  assign bindin263 = bindout3012;
  assign bindin266 = bindout1792;
  assign bindin269 = bindout1783;
  assign bindin272 = bindout1786;
  assign bindin275 = bindout3043;
  assign bindin278 = bindout3046;
  assign bindin339 = clk;
  assign bindin340 = reset;
  F_D_Register __module3__(.clk(bindin339), .reset(bindin340), .io_in_instruction(bindin341), .io_in_curr_PC(bindin344), .io_in_branch_stall(bindin347), .io_in_branch_stall_exe(bindin350), .io_in_fwd_stall(bindin353), .io_out_instruction(bindout356), .io_out_curr_PC(bindout359));
  assign bindin341 = bindout281;
  assign bindin344 = bindout284;
  assign bindin347 = bindout1054;
  assign bindin350 = bindout1792;
  assign bindin353 = bindout3012;
  assign bindin990 = clk;
  Decode __module4__(.clk(bindin990), .io_in_instruction(bindin991), .io_in_curr_PC(bindin994), .io_in_stall(bindin997), .io_in_write_data(bindin1000), .io_in_rd(bindin1003), .io_in_wb(bindin1006), .io_out_csr_address(bindout1009), .io_out_is_csr(bindout1012), .io_out_csr_mask(bindout1015), .io_out_rd(bindout1018), .io_out_rs1(bindout1021), .io_out_rd1(bindout1024), .io_out_rs2(bindout1027), .io_out_rd2(bindout1030), .io_out_wb(bindout1033), .io_out_alu_op(bindout1036), .io_out_rs2_src(bindout1039), .io_out_itype_immed(bindout1042), .io_out_mem_read(bindout1045), .io_out_mem_write(bindout1048), .io_out_branch_type(bindout1051), .io_out_branch_stall(bindout1054), .io_out_jal(bindout1057), .io_out_jal_offset(bindout1060), .io_out_upper_immed(bindout1063), .io_out_PC_next(bindout1066));
  assign bindin991 = bindout356;
  assign bindin994 = bindout359;
  assign bindin997 = eq3488;
  assign bindin1000 = bindout2685;
  assign bindin1003 = bindout2688;
  assign bindin1006 = bindout2691;
  assign bindin1357 = clk;
  assign bindin1358 = reset;
  D_E_Register __module6__(.clk(bindin1357), .reset(bindin1358), .io_in_rd(bindin1359), .io_in_rs1(bindin1362), .io_in_rd1(bindin1365), .io_in_rs2(bindin1368), .io_in_rd2(bindin1371), .io_in_alu_op(bindin1374), .io_in_wb(bindin1377), .io_in_rs2_src(bindin1380), .io_in_itype_immed(bindin1383), .io_in_mem_read(bindin1386), .io_in_mem_write(bindin1389), .io_in_PC_next(bindin1392), .io_in_branch_type(bindin1395), .io_in_fwd_stall(bindin1398), .io_in_branch_stall(bindin1401), .io_in_upper_immed(bindin1404), .io_in_csr_address(bindin1407), .io_in_is_csr(bindin1410), .io_in_csr_mask(bindin1413), .io_in_curr_PC(bindin1416), .io_in_jal(bindin1419), .io_in_jal_offset(bindin1422), .io_out_csr_address(bindout1425), .io_out_is_csr(bindout1428), .io_out_csr_mask(bindout1431), .io_out_rd(bindout1434), .io_out_rs1(bindout1437), .io_out_rd1(bindout1440), .io_out_rs2(bindout1443), .io_out_rd2(bindout1446), .io_out_alu_op(bindout1449), .io_out_wb(bindout1452), .io_out_rs2_src(bindout1455), .io_out_itype_immed(bindout1458), .io_out_mem_read(bindout1461), .io_out_mem_write(bindout1464), .io_out_branch_type(bindout1467), .io_out_upper_immed(bindout1470), .io_out_curr_PC(bindout1473), .io_out_jal(bindout1476), .io_out_jal_offset(bindout1479), .io_out_PC_next(bindout1482));
  assign bindin1359 = bindout1018;
  assign bindin1362 = bindout1021;
  assign bindin1365 = bindout1024;
  assign bindin1368 = bindout1027;
  assign bindin1371 = bindout1030;
  assign bindin1374 = bindout1036;
  assign bindin1377 = bindout1033;
  assign bindin1380 = bindout1039;
  assign bindin1383 = bindout1042;
  assign bindin1386 = bindout1045;
  assign bindin1389 = bindout1048;
  assign bindin1392 = bindout1066;
  assign bindin1395 = bindout1051;
  assign bindin1398 = bindout3012;
  assign bindin1401 = bindout1792;
  assign bindin1404 = bindout1063;
  assign bindin1407 = bindout1009;
  assign bindin1410 = bindout1012;
  assign bindin1413 = bindout1015;
  assign bindin1416 = bindout359;
  assign bindin1419 = bindout1057;
  assign bindin1422 = bindout1060;
  Execute __module7__(.io_in_rd(bindin1684), .io_in_rs1(bindin1687), .io_in_rd1(bindin1690), .io_in_rs2(bindin1693), .io_in_rd2(bindin1696), .io_in_alu_op(bindin1699), .io_in_wb(bindin1702), .io_in_rs2_src(bindin1705), .io_in_itype_immed(bindin1708), .io_in_mem_read(bindin1711), .io_in_mem_write(bindin1714), .io_in_PC_next(bindin1717), .io_in_branch_type(bindin1720), .io_in_upper_immed(bindin1723), .io_in_csr_address(bindin1726), .io_in_is_csr(bindin1729), .io_in_csr_data(bindin1732), .io_in_csr_mask(bindin1735), .io_in_jal(bindin1738), .io_in_jal_offset(bindin1741), .io_in_curr_PC(bindin1744), .io_out_csr_address(bindout1747), .io_out_is_csr(bindout1750), .io_out_csr_result(bindout1753), .io_out_alu_result(bindout1756), .io_out_rd(bindout1759), .io_out_wb(bindout1762), .io_out_rs1(bindout1765), .io_out_rd1(bindout1768), .io_out_rs2(bindout1771), .io_out_rd2(bindout1774), .io_out_mem_read(bindout1777), .io_out_mem_write(bindout1780), .io_out_jal(bindout1783), .io_out_jal_dest(bindout1786), .io_out_branch_offset(bindout1789), .io_out_branch_stall(bindout1792), .io_out_PC_next(bindout1795));
  assign bindin1684 = bindout1434;
  assign bindin1687 = bindout1437;
  assign bindin1690 = bindout1440;
  assign bindin1693 = bindout1443;
  assign bindin1696 = bindout1446;
  assign bindin1699 = bindout1449;
  assign bindin1702 = bindout1452;
  assign bindin1705 = bindout1455;
  assign bindin1708 = bindout1458;
  assign bindin1711 = bindout1461;
  assign bindin1714 = bindout1464;
  assign bindin1717 = bindout1482;
  assign bindin1720 = bindout1467;
  assign bindin1723 = bindout1470;
  assign bindin1726 = bindout1425;
  assign bindin1729 = bindout1428;
  assign bindin1732 = bindout3481;
  assign bindin1735 = bindout1431;
  assign bindin1738 = bindout1476;
  assign bindin1741 = bindout1479;
  assign bindin1744 = bindout1473;
  assign bindin1969 = clk;
  assign bindin1970 = reset;
  E_M_Register __module8__(.clk(bindin1969), .reset(bindin1970), .io_in_alu_result(bindin1971), .io_in_rd(bindin1974), .io_in_wb(bindin1977), .io_in_rs1(bindin1980), .io_in_rd1(bindin1983), .io_in_rs2(bindin1986), .io_in_rd2(bindin1989), .io_in_mem_read(bindin1992), .io_in_mem_write(bindin1995), .io_in_PC_next(bindin1998), .io_in_csr_address(bindin2001), .io_in_is_csr(bindin2004), .io_in_csr_result(bindin2007), .io_in_curr_PC(bindin2010), .io_in_branch_offset(bindin2013), .io_in_branch_type(bindin2016), .io_out_csr_address(bindout2019), .io_out_is_csr(bindout2022), .io_out_csr_result(bindout2025), .io_out_alu_result(bindout2028), .io_out_rd(bindout2031), .io_out_wb(bindout2034), .io_out_rs1(bindout2037), .io_out_rd1(bindout2040), .io_out_rd2(bindout2043), .io_out_rs2(bindout2046), .io_out_mem_read(bindout2049), .io_out_mem_write(bindout2052), .io_out_curr_PC(bindout2055), .io_out_branch_offset(bindout2058), .io_out_branch_type(bindout2061), .io_out_PC_next(bindout2064));
  assign bindin1971 = bindout1756;
  assign bindin1974 = bindout1759;
  assign bindin1977 = bindout1762;
  assign bindin1980 = bindout1765;
  assign bindin1983 = bindout1768;
  assign bindin1986 = bindout1771;
  assign bindin1989 = bindout1774;
  assign bindin1992 = bindout1777;
  assign bindin1995 = bindout1780;
  assign bindin1998 = bindout1795;
  assign bindin2001 = bindout1747;
  assign bindin2004 = bindout1750;
  assign bindin2007 = bindout1753;
  assign bindin2010 = bindout1473;
  assign bindin2013 = bindout1789;
  assign bindin2016 = bindout1467;
  Memory __module9__(.io_DBUS_in_data_data(bindin2409), .io_DBUS_in_data_valid(bindin2412), .io_DBUS_out_data_ready(bindin2424), .io_DBUS_out_address_ready(bindin2433), .io_DBUS_out_control_ready(bindin2442), .io_in_alu_result(bindin2445), .io_in_mem_read(bindin2448), .io_in_mem_write(bindin2451), .io_in_rd(bindin2454), .io_in_wb(bindin2457), .io_in_rs1(bindin2460), .io_in_rd1(bindin2463), .io_in_rs2(bindin2466), .io_in_rd2(bindin2469), .io_in_PC_next(bindin2472), .io_in_curr_PC(bindin2475), .io_in_branch_offset(bindin2478), .io_in_branch_type(bindin2481), .io_DBUS_in_data_ready(bindout2415), .io_DBUS_out_data_data(bindout2418), .io_DBUS_out_data_valid(bindout2421), .io_DBUS_out_address_data(bindout2427), .io_DBUS_out_address_valid(bindout2430), .io_DBUS_out_control_data(bindout2436), .io_DBUS_out_control_valid(bindout2439), .io_out_alu_result(bindout2484), .io_out_mem_result(bindout2487), .io_out_rd(bindout2490), .io_out_wb(bindout2493), .io_out_rs1(bindout2496), .io_out_rs2(bindout2499), .io_out_branch_dir(bindout2502), .io_out_branch_dest(bindout2505), .io_out_PC_next(bindout2508));
  assign bindin2409 = io_DBUS_in_data_data;
  assign bindin2412 = io_DBUS_in_data_valid;
  assign bindin2424 = io_DBUS_out_data_ready;
  assign bindin2433 = io_DBUS_out_address_ready;
  assign bindin2442 = io_DBUS_out_control_ready;
  assign bindin2445 = bindout2028;
  assign bindin2448 = bindout2049;
  assign bindin2451 = bindout2052;
  assign bindin2454 = bindout2031;
  assign bindin2457 = bindout2034;
  assign bindin2460 = bindout2037;
  assign bindin2463 = bindout2040;
  assign bindin2466 = bindout2046;
  assign bindin2469 = bindout2043;
  assign bindin2472 = bindout2064;
  assign bindin2475 = bindout2055;
  assign bindin2478 = bindout2058;
  assign bindin2481 = bindout2061;
  assign bindin2589 = clk;
  assign bindin2590 = reset;
  M_W_Register __module11__(.clk(bindin2589), .reset(bindin2590), .io_in_alu_result(bindin2591), .io_in_mem_result(bindin2594), .io_in_rd(bindin2597), .io_in_wb(bindin2600), .io_in_rs1(bindin2603), .io_in_rs2(bindin2606), .io_in_PC_next(bindin2609), .io_out_alu_result(bindout2612), .io_out_mem_result(bindout2615), .io_out_rd(bindout2618), .io_out_wb(bindout2621), .io_out_rs1(bindout2624), .io_out_rs2(bindout2627), .io_out_PC_next(bindout2630));
  assign bindin2591 = bindout2484;
  assign bindin2594 = bindout2487;
  assign bindin2597 = bindout2490;
  assign bindin2600 = bindout2493;
  assign bindin2603 = bindout2496;
  assign bindin2606 = bindout2499;
  assign bindin2609 = bindout2508;
  Write_Back __module12__(.io_in_alu_result(bindin2664), .io_in_mem_result(bindin2667), .io_in_rd(bindin2670), .io_in_wb(bindin2673), .io_in_rs1(bindin2676), .io_in_rs2(bindin2679), .io_in_PC_next(bindin2682), .io_out_write_data(bindout2685), .io_out_rd(bindout2688), .io_out_wb(bindout2691));
  assign bindin2664 = bindout2612;
  assign bindin2667 = bindout2615;
  assign bindin2670 = bindout2618;
  assign bindin2673 = bindout2621;
  assign bindin2676 = bindout2624;
  assign bindin2679 = bindout2627;
  assign bindin2682 = bindout2630;
  Forwarding __module13__(.io_in_decode_src1(bindin2934), .io_in_decode_src2(bindin2937), .io_in_decode_csr_address(bindin2940), .io_in_execute_dest(bindin2943), .io_in_execute_wb(bindin2946), .io_in_execute_alu_result(bindin2949), .io_in_execute_PC_next(bindin2952), .io_in_execute_is_csr(bindin2955), .io_in_execute_csr_address(bindin2958), .io_in_execute_csr_result(bindin2961), .io_in_memory_dest(bindin2964), .io_in_memory_wb(bindin2967), .io_in_memory_alu_result(bindin2970), .io_in_memory_mem_data(bindin2973), .io_in_memory_PC_next(bindin2976), .io_in_memory_is_csr(bindin2979), .io_in_memory_csr_address(bindin2982), .io_in_memory_csr_result(bindin2985), .io_in_writeback_dest(bindin2988), .io_in_writeback_wb(bindin2991), .io_in_writeback_alu_result(bindin2994), .io_in_writeback_mem_data(bindin2997), .io_in_writeback_PC_next(bindin3000), .io_out_fwd_stall(bindout3012));
  assign bindin2934 = bindout1021;
  assign bindin2937 = bindout1027;
  assign bindin2940 = bindout1009;
  assign bindin2943 = bindout1759;
  assign bindin2946 = bindout1762;
  assign bindin2949 = bindout1756;
  assign bindin2952 = bindout1795;
  assign bindin2955 = bindout1750;
  assign bindin2958 = bindout1747;
  assign bindin2961 = bindout1753;
  assign bindin2964 = bindout2490;
  assign bindin2967 = bindout2493;
  assign bindin2970 = bindout2484;
  assign bindin2973 = bindout2487;
  assign bindin2976 = bindout2508;
  assign bindin2979 = bindout2022;
  assign bindin2982 = bindout2019;
  assign bindin2985 = bindout2025;
  assign bindin2988 = bindout2618;
  assign bindin2991 = bindout2621;
  assign bindin2994 = bindout2612;
  assign bindin2997 = bindout2615;
  assign bindin3000 = bindout2630;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3034), .io_INTERRUPT_in_interrupt_id_valid(bindin3037), .io_INTERRUPT_in_interrupt_id_ready(bindout3040), .io_out_interrupt(bindout3043), .io_out_interrupt_pc(bindout3046));
  assign bindin3034 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3037 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3387 = clk;
  assign bindin3388 = reset;
  JTAG __module15__(.clk(bindin3387), .reset(bindin3388), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3389), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3392), .io_JTAG_JTAG_TAP_in_clock_data(bindin3398), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3401), .io_JTAG_JTAG_TAP_in_reset_data(bindin3407), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3410), .io_JTAG_in_data_data(bindin3416), .io_JTAG_in_data_valid(bindin3419), .io_JTAG_out_data_ready(bindin3431), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3395), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3404), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3413), .io_JTAG_in_data_ready(bindout3422), .io_JTAG_out_data_data(bindout3425), .io_JTAG_out_data_valid(bindout3428));
  assign bindin3389 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3392 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3398 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3401 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3407 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3410 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3416 = io_jtag_in_data_data;
  assign bindin3419 = io_jtag_in_data_valid;
  assign bindin3431 = io_jtag_out_data_ready;
  assign bindin3467 = clk;
  assign bindin3468 = reset;
  CSR_Handler __module17__(.clk(bindin3467), .reset(bindin3468), .io_in_decode_csr_address(bindin3469), .io_in_mem_csr_address(bindin3472), .io_in_mem_is_csr(bindin3475), .io_in_mem_csr_result(bindin3478), .io_out_decode_csr_data(bindout3481));
  assign bindin3469 = bindout1009;
  assign bindin3472 = bindout2019;
  assign bindin3475 = bindout2022;
  assign bindin3478 = bindout2025;
  assign orl3483 = bindout1054 | bindout1792;
  assign eq3488 = bindout1792 == 1'h1;

  assign io_IBUS_in_data_ready = bindout242;
  assign io_IBUS_out_address_data = bindout245;
  assign io_IBUS_out_address_valid = bindout248;
  assign io_DBUS_in_data_ready = bindout2415;
  assign io_DBUS_out_data_data = bindout2418;
  assign io_DBUS_out_data_valid = bindout2421;
  assign io_DBUS_out_address_data = bindout2427;
  assign io_DBUS_out_address_valid = bindout2430;
  assign io_DBUS_out_control_data = bindout2436;
  assign io_DBUS_out_control_valid = bindout2439;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3040;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3395;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3404;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3413;
  assign io_jtag_in_data_ready = bindout3422;
  assign io_jtag_out_data_data = bindout3425;
  assign io_jtag_out_data_valid = bindout3428;
  assign io_out_fwd_stall = bindout3012;
  assign io_out_branch_stall = orl3483;

endmodule
