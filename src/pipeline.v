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
  reg reg368;
  wire eq373, sel377, ne391, andl394, sel396, eq405, eq414;
  wire[31:0] sel397, mrport400, sel407, mrport409, sel416;
  wire[4:0] sel398;

  always @ (posedge clk) begin
    if (sel396) begin
      mem360[sel398] <= sel397;
    end
  end
  assign mrport400 = mem360[io_in_src1];
  assign mrport409 = mem360[io_in_src2];
  always @ (posedge clk) begin
    if (reset)
      reg368 <= 1'h1;
    else
      reg368 <= sel377;
  end
  assign eq373 = reg368 == 1'h1;
  assign sel377 = eq373 ? 1'h0 : reg368;
  assign ne391 = io_in_rd != 5'h0;
  assign andl394 = io_in_write_register & ne391;
  assign sel396 = reg368 ? 1'h1 : andl394;
  assign sel397 = reg368 ? 32'h0 : io_in_data;
  assign sel398 = reg368 ? 5'h0 : io_in_rd;
  assign eq405 = io_in_src1 == 5'h0;
  assign sel407 = eq405 ? 32'h0 : mrport400;
  assign eq414 = io_in_src2 == 5'h0;
  assign sel416 = eq414 ? 32'h0 : mrport409;

  assign io_out_src1_data = sel407;
  assign io_out_src2_data = sel416;

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
  wire bindin443, bindin445, bindin446, ne506, sel508, eq512, eq566, eq572, eq579, eq584, eq589, orl591, eq596, eq601, eq606, eq611, eq616, eq621, ne626, eq631, andl633, proxy636, eq637, andl640, eq644, andl650, eq658, orl666, orl668, orl670, orl672, andl674, andl681, orl688, orl690, andl692, orl699, sel701, andl712, eq729, eq734, orl736, proxy789, proxy790, lt823, proxy895, eq925, proxy958, eq959, sel976, sel977, sel979, sel980, sel982, sel983, eq1007, eq1044, eq1052, eq1060, orl1066, lt1084;
  wire[4:0] bindin449, bindin455, bindin458, sel528, proxy536, proxy543;
  wire[31:0] bindin452, bindout461, bindout464, shr524, shr533, shr540, shr547, shr554, sel568, sel574, pad652, sel654, sel660, shr794, shr899, proxy915, proxy921, sel927, sub931, add933, proxy948, proxy954, sel961, add963, sel985, sel986;
  wire[6:0] sel517, proxy557;
  wire[2:0] proxy550, sel708, sel714, sel989, sel990;
  wire[1:0] sel676, sel683, sel694, proxy1039;
  wire[11:0] proxy740, sel748, proxy766, proxy805, proxy943, sel973, sel974, sel995, sel996;
  wire[3:0] proxy797, sel1009, sel1012, sel1029, sel1046, sel1054, sel1062, sel1068, sel1070, sel1074, sel1078, sel1086, sel1088;
  wire[5:0] proxy803;
  wire[19:0] proxy866, sel992, sel993;
  wire[7:0] proxy894;
  wire[9:0] proxy902;
  wire[20:0] proxy906;
  reg[11:0] sel975, sel997;
  reg sel978, sel981, sel984;
  reg[31:0] sel987;
  reg[2:0] sel988, sel991;
  reg[19:0] sel994;
  reg[3:0] sel1037;

  assign bindin443 = clk;
  assign bindin445 = reset;
  RegisterFile __module5__(.clk(bindin443), .reset(bindin445), .io_in_write_register(bindin446), .io_in_rd(bindin449), .io_in_data(bindin452), .io_in_src1(bindin455), .io_in_src2(bindin458), .io_out_src1_data(bindout461), .io_out_src2_data(bindout464));
  assign bindin446 = sel508;
  assign bindin449 = io_in_rd;
  assign bindin452 = io_in_write_data;
  assign bindin455 = proxy536;
  assign bindin458 = proxy543;
  assign ne506 = io_in_wb != 2'h0;
  assign sel508 = ne506 ? 1'h1 : 1'h0;
  assign eq512 = io_in_stall == 1'h0;
  assign sel517 = eq512 ? io_in_instruction[6:0] : 7'h0;
  assign shr524 = io_in_instruction >> 32'h7;
  assign sel528 = eq512 ? shr524[4:0] : 5'h0;
  assign shr533 = io_in_instruction >> 32'hf;
  assign proxy536 = shr533[4:0];
  assign shr540 = io_in_instruction >> 32'h14;
  assign proxy543 = shr540[4:0];
  assign shr547 = io_in_instruction >> 32'hc;
  assign proxy550 = shr547[2:0];
  assign shr554 = io_in_instruction >> 32'h19;
  assign proxy557 = shr554[6:0];
  assign eq566 = io_in_src1_fwd == 1'h1;
  assign sel568 = eq566 ? io_in_src1_fwd_data : bindout461;
  assign eq572 = io_in_src2_fwd == 1'h1;
  assign sel574 = eq572 ? io_in_src2_fwd_data : bindout464;
  assign eq579 = sel517 == 7'h33;
  assign eq584 = sel517 == 7'h3;
  assign eq589 = sel517 == 7'h13;
  assign orl591 = eq589 | eq584;
  assign eq596 = sel517 == 7'h23;
  assign eq601 = sel517 == 7'h63;
  assign eq606 = sel517 == 7'h6f;
  assign eq611 = sel517 == 7'h67;
  assign eq616 = sel517 == 7'h37;
  assign eq621 = sel517 == 7'h17;
  assign ne626 = proxy550 != 3'h0;
  assign eq631 = sel517 == 7'h73;
  assign andl633 = eq631 & ne626;
  assign proxy636 = proxy550[2];
  assign eq637 = proxy636 == 1'h1;
  assign andl640 = andl633 & eq637;
  assign eq644 = proxy550 == 3'h0;
  assign andl650 = eq631 & eq644;
  assign pad652 = {{27{1'b0}}, proxy543};
  assign sel654 = andl640 ? pad652 : sel574;
  assign eq658 = io_in_csr_fwd == 1'h1;
  assign sel660 = eq658 ? io_in_csr_fwd_data : io_in_csr_data;
  assign orl666 = orl591 | eq579;
  assign orl668 = orl666 | eq616;
  assign orl670 = orl668 | eq621;
  assign orl672 = orl670 | andl633;
  assign andl674 = orl672 & eq512;
  assign sel676 = andl674 ? 2'h1 : 2'h0;
  assign andl681 = eq584 & eq512;
  assign sel683 = andl681 ? 2'h2 : sel676;
  assign orl688 = eq606 | eq611;
  assign orl690 = orl688 | andl650;
  assign andl692 = orl690 & eq512;
  assign sel694 = andl692 ? 2'h3 : sel683;
  assign orl699 = orl591 | eq596;
  assign sel701 = orl699 ? 1'h1 : 1'h0;
  assign sel708 = andl681 ? proxy550 : 3'h7;
  assign andl712 = eq596 & eq512;
  assign sel714 = andl712 ? proxy550 : 3'h7;
  assign eq729 = proxy550 == 3'h5;
  assign eq734 = proxy550 == 3'h1;
  assign orl736 = eq734 | eq729;
  assign proxy740 = {7'h0, proxy543};
  assign sel748 = orl736 ? proxy740 : shr540[11:0];
  assign proxy766 = {proxy557, sel528};
  assign proxy789 = io_in_instruction[31];
  assign proxy790 = io_in_instruction[7];
  assign shr794 = io_in_instruction >> 32'h8;
  assign proxy797 = shr794[3:0];
  assign proxy803 = shr554[5:0];
  assign proxy805 = {proxy789, proxy790, proxy803, proxy797};
  assign lt823 = shr540[11:0] < 12'h2;
  assign proxy866 = {proxy557, proxy543, proxy536, proxy550};
  assign proxy894 = shr547[7:0];
  assign proxy895 = io_in_instruction[20];
  assign shr899 = io_in_instruction >> 32'h15;
  assign proxy902 = shr899[9:0];
  assign proxy906 = {proxy789, proxy894, proxy895, proxy902, 1'h0};
  assign proxy915 = {11'h0, proxy906};
  assign proxy921 = {11'h7ff, proxy906};
  assign eq925 = proxy789 == 1'h1;
  assign sel927 = eq925 ? proxy921 : proxy915;
  assign sub931 = $signed(io_in_PC_next) - $signed(32'h4);
  assign add933 = $signed(sub931) + $signed(sel927);
  assign proxy943 = {proxy557, proxy543};
  assign proxy948 = {20'h0, proxy943};
  assign proxy954 = {20'hfffff, proxy943};
  assign proxy958 = proxy943[11];
  assign eq959 = proxy958 == 1'h1;
  assign sel961 = eq959 ? proxy954 : proxy948;
  assign add963 = $signed(sel568) + $signed(sel961);
  assign sel973 = lt823 ? 12'h7b : 12'h7b;
  assign sel974 = (proxy550 == 3'h0) ? sel973 : 12'h7b;
  always @(*) begin
    case (sel517)
      7'h13: sel975 = sel748;
      7'h33: sel975 = 12'h7b;
      7'h23: sel975 = proxy766;
      7'h03: sel975 = shr540[11:0];
      7'h63: sel975 = proxy805;
      7'h73: sel975 = sel974;
      7'h37: sel975 = 12'h7b;
      7'h17: sel975 = 12'h7b;
      7'h6f: sel975 = 12'h7b;
      7'h67: sel975 = 12'h7b;
      default: sel975 = 12'h7b;
    endcase
  end
  assign sel976 = lt823 ? 1'h0 : 1'h1;
  assign sel977 = (proxy550 == 3'h0) ? sel976 : 1'h1;
  always @(*) begin
    case (sel517)
      7'h13: sel978 = 1'h0;
      7'h33: sel978 = 1'h0;
      7'h23: sel978 = 1'h0;
      7'h03: sel978 = 1'h0;
      7'h63: sel978 = 1'h0;
      7'h73: sel978 = sel977;
      7'h37: sel978 = 1'h0;
      7'h17: sel978 = 1'h0;
      7'h6f: sel978 = 1'h0;
      7'h67: sel978 = 1'h0;
      default: sel978 = 1'h0;
    endcase
  end
  assign sel979 = lt823 ? 1'h0 : 1'h0;
  assign sel980 = (proxy550 == 3'h0) ? sel979 : 1'h0;
  always @(*) begin
    case (sel517)
      7'h13: sel981 = 1'h0;
      7'h33: sel981 = 1'h0;
      7'h23: sel981 = 1'h0;
      7'h03: sel981 = 1'h0;
      7'h63: sel981 = 1'h1;
      7'h73: sel981 = sel980;
      7'h37: sel981 = 1'h0;
      7'h17: sel981 = 1'h0;
      7'h6f: sel981 = 1'h0;
      7'h67: sel981 = 1'h0;
      default: sel981 = 1'h0;
    endcase
  end
  assign sel982 = lt823 ? 1'h1 : 1'h0;
  assign sel983 = (proxy550 == 3'h0) ? sel982 : 1'h0;
  always @(*) begin
    case (sel517)
      7'h13: sel984 = 1'h0;
      7'h33: sel984 = 1'h0;
      7'h23: sel984 = 1'h0;
      7'h03: sel984 = 1'h0;
      7'h63: sel984 = 1'h0;
      7'h73: sel984 = sel983;
      7'h37: sel984 = 1'h0;
      7'h17: sel984 = 1'h0;
      7'h6f: sel984 = 1'h1;
      7'h67: sel984 = 1'h1;
      default: sel984 = 1'h0;
    endcase
  end
  assign sel985 = lt823 ? 32'hb0000000 : 32'h7b;
  assign sel986 = (proxy550 == 3'h0) ? sel985 : 32'h7b;
  always @(*) begin
    case (sel517)
      7'h13: sel987 = 32'h7b;
      7'h33: sel987 = 32'h7b;
      7'h23: sel987 = 32'h7b;
      7'h03: sel987 = 32'h7b;
      7'h63: sel987 = 32'h7b;
      7'h73: sel987 = sel986;
      7'h37: sel987 = 32'h7b;
      7'h17: sel987 = 32'h7b;
      7'h6f: sel987 = add933;
      7'h67: sel987 = add963;
      default: sel987 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy550)
      3'h0: sel988 = 3'h1;
      3'h1: sel988 = 3'h2;
      3'h4: sel988 = 3'h3;
      3'h5: sel988 = 3'h4;
      3'h6: sel988 = 3'h5;
      3'h7: sel988 = 3'h6;
      default: sel988 = 3'h0;
    endcase
  end
  assign sel989 = lt823 ? 3'h0 : 3'h0;
  assign sel990 = (proxy550 == 3'h0) ? sel989 : 3'h0;
  always @(*) begin
    case (sel517)
      7'h13: sel991 = 3'h0;
      7'h33: sel991 = 3'h0;
      7'h23: sel991 = 3'h0;
      7'h03: sel991 = 3'h0;
      7'h63: sel991 = sel988;
      7'h73: sel991 = sel990;
      7'h37: sel991 = 3'h0;
      7'h17: sel991 = 3'h0;
      7'h6f: sel991 = 3'h0;
      7'h67: sel991 = 3'h0;
      default: sel991 = 3'h0;
    endcase
  end
  assign sel992 = lt823 ? 20'h7b : 20'h7b;
  assign sel993 = (proxy550 == 3'h0) ? sel992 : 20'h7b;
  always @(*) begin
    case (sel517)
      7'h13: sel994 = 20'h7b;
      7'h33: sel994 = 20'h7b;
      7'h23: sel994 = 20'h7b;
      7'h03: sel994 = 20'h7b;
      7'h63: sel994 = 20'h7b;
      7'h73: sel994 = sel993;
      7'h37: sel994 = proxy866;
      7'h17: sel994 = proxy866;
      7'h6f: sel994 = 20'h7b;
      7'h67: sel994 = 20'h7b;
      default: sel994 = 20'h7b;
    endcase
  end
  assign sel995 = lt823 ? 12'h7b : shr540[11:0];
  assign sel996 = (proxy550 == 3'h0) ? sel995 : shr540[11:0];
  always @(*) begin
    case (sel517)
      7'h13: sel997 = 12'h7b;
      7'h33: sel997 = 12'h7b;
      7'h23: sel997 = 12'h7b;
      7'h03: sel997 = 12'h7b;
      7'h63: sel997 = 12'h7b;
      7'h73: sel997 = sel996;
      7'h37: sel997 = 12'h7b;
      7'h17: sel997 = 12'h7b;
      7'h6f: sel997 = 12'h7b;
      7'h67: sel997 = 12'h7b;
      default: sel997 = 12'h7b;
    endcase
  end
  assign eq1007 = proxy557 == 7'h0;
  assign sel1009 = eq1007 ? 4'h0 : 4'h1;
  assign sel1012 = eq589 ? 4'h0 : sel1009;
  assign sel1029 = eq1007 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy550)
      3'h0: sel1037 = sel1012;
      3'h1: sel1037 = 4'h2;
      3'h2: sel1037 = 4'h3;
      3'h3: sel1037 = 4'h4;
      3'h4: sel1037 = 4'h5;
      3'h5: sel1037 = sel1029;
      3'h6: sel1037 = 4'h8;
      3'h7: sel1037 = 4'h9;
      default: sel1037 = 4'hf;
    endcase
  end
  assign proxy1039 = proxy550[1:0];
  assign eq1044 = proxy1039 == 2'h3;
  assign sel1046 = eq1044 ? 4'hf : 4'hf;
  assign eq1052 = proxy1039 == 2'h2;
  assign sel1054 = eq1052 ? 4'he : sel1046;
  assign eq1060 = proxy1039 == 2'h1;
  assign sel1062 = eq1060 ? 4'hd : sel1054;
  assign orl1066 = eq596 | eq584;
  assign sel1068 = orl1066 ? 4'h0 : sel1037;
  assign sel1070 = andl633 ? sel1062 : sel1068;
  assign sel1074 = eq621 ? 4'hc : sel1070;
  assign sel1078 = eq616 ? 4'hb : sel1074;
  assign lt1084 = sel991 < 3'h5;
  assign sel1086 = lt1084 ? 4'h1 : 4'ha;
  assign sel1088 = eq601 ? sel1086 : sel1078;

  assign io_out_csr_address = sel997;
  assign io_out_is_csr = sel978;
  assign io_out_csr_data = sel660;
  assign io_out_csr_mask = sel654;
  assign io_actual_change = 32'h1;
  assign io_out_rd = sel528;
  assign io_out_rs1 = proxy536;
  assign io_out_rd1 = sel568;
  assign io_out_rs2 = proxy543;
  assign io_out_rd2 = sel574;
  assign io_out_wb = sel694;
  assign io_out_alu_op = sel1088;
  assign io_out_rs2_src = sel701;
  assign io_out_itype_immed = sel975;
  assign io_out_mem_read = sel708;
  assign io_out_mem_write = sel714;
  assign io_out_branch_type = sel991;
  assign io_out_branch_stall = sel981;
  assign io_out_jal = sel984;
  assign io_out_jal_dest = sel987;
  assign io_out_upper_immed = sel994;
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
  reg[4:0] reg1279, reg1288, reg1301;
  reg[31:0] reg1295, reg1307, reg1327, reg1385, reg1391;
  reg[3:0] reg1314;
  reg[1:0] reg1321;
  reg reg1334, reg1379;
  reg[11:0] reg1341, reg1373;
  reg[2:0] reg1348, reg1354, reg1360;
  reg[19:0] reg1367;
  wire eq1395, sel1423, sel1446;
  wire[4:0] sel1398, sel1401, sel1407;
  wire[31:0] sel1404, sel1410, sel1420, sel1449, sel1452;
  wire[3:0] sel1414;
  wire[1:0] sel1417;
  wire[11:0] sel1427, sel1443;
  wire[2:0] sel1431, sel1434, sel1437;
  wire[19:0] sel1440;

  always @ (posedge clk) begin
    if (reset)
      reg1279 <= 5'h0;
    else
      reg1279 <= sel1398;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1288 <= 5'h0;
    else
      reg1288 <= sel1401;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1295 <= 32'h0;
    else
      reg1295 <= sel1404;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1301 <= 5'h0;
    else
      reg1301 <= sel1407;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1307 <= 32'h0;
    else
      reg1307 <= sel1410;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1314 <= 4'h0;
    else
      reg1314 <= sel1414;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1321 <= 2'h0;
    else
      reg1321 <= sel1417;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1327 <= 32'h0;
    else
      reg1327 <= sel1420;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1334 <= 1'h0;
    else
      reg1334 <= sel1423;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1341 <= 12'h0;
    else
      reg1341 <= sel1427;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1348 <= 3'h0;
    else
      reg1348 <= sel1431;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1354 <= 3'h0;
    else
      reg1354 <= sel1434;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1360 <= 3'h0;
    else
      reg1360 <= sel1437;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1367 <= 20'h0;
    else
      reg1367 <= sel1440;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1373 <= 12'h0;
    else
      reg1373 <= sel1443;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1379 <= 1'h0;
    else
      reg1379 <= sel1446;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1385 <= 32'h0;
    else
      reg1385 <= sel1449;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1391 <= 32'h0;
    else
      reg1391 <= sel1452;
  end
  assign eq1395 = io_in_fwd_stall == 1'h1;
  assign sel1398 = eq1395 ? 5'h0 : io_in_rd;
  assign sel1401 = eq1395 ? 5'h0 : io_in_rs1;
  assign sel1404 = eq1395 ? 32'h0 : io_in_rd1;
  assign sel1407 = eq1395 ? 5'h0 : io_in_rs2;
  assign sel1410 = eq1395 ? 32'h0 : io_in_rd2;
  assign sel1414 = eq1395 ? 4'hf : io_in_alu_op;
  assign sel1417 = eq1395 ? 2'h0 : io_in_wb;
  assign sel1420 = eq1395 ? 32'h0 : io_in_PC_next;
  assign sel1423 = eq1395 ? 1'h0 : io_in_rs2_src;
  assign sel1427 = eq1395 ? 12'h7b : io_in_itype_immed;
  assign sel1431 = eq1395 ? 3'h7 : io_in_mem_read;
  assign sel1434 = eq1395 ? 3'h7 : io_in_mem_write;
  assign sel1437 = eq1395 ? 3'h0 : io_in_branch_type;
  assign sel1440 = eq1395 ? 20'h0 : io_in_upper_immed;
  assign sel1443 = eq1395 ? 12'h0 : io_in_csr_address;
  assign sel1446 = eq1395 ? 1'h0 : io_in_is_csr;
  assign sel1449 = eq1395 ? 32'h0 : io_in_csr_data;
  assign sel1452 = eq1395 ? 32'h0 : io_in_csr_mask;

  assign io_out_csr_address = reg1373;
  assign io_out_is_csr = reg1379;
  assign io_out_csr_data = reg1385;
  assign io_out_csr_mask = reg1391;
  assign io_out_rd = reg1279;
  assign io_out_rs1 = reg1288;
  assign io_out_rd1 = reg1295;
  assign io_out_rs2 = reg1301;
  assign io_out_rd2 = reg1307;
  assign io_out_alu_op = reg1314;
  assign io_out_wb = reg1321;
  assign io_out_rs2_src = reg1334;
  assign io_out_itype_immed = reg1341;
  assign io_out_mem_read = reg1348;
  assign io_out_mem_write = reg1354;
  assign io_out_branch_type = reg1360;
  assign io_out_upper_immed = reg1367;
  assign io_out_PC_next = reg1327;

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
  wire[31:0] proxy1634, proxy1640, sel1648, sel1655, proxy1660, shl1665, sub1669, add1671, add1680, sub1685, shl1689, sel1698, sel1707, xorl1712, shr1716, shr1721, orl1726, andl1731, add1747, orl1753, sub1757, andl1760, sel1765;
  wire eq1646, eq1653, lt1696, lt1705, ge1735, eq1772, sel1774, sel1782, eq1789, sel1791, sel1800;
  reg[31:0] sel1764, sel1766;
  reg sel1823;

  assign proxy1634 = {20'h0, io_in_itype_immed};
  assign proxy1640 = {20'hfffff, io_in_itype_immed};
  assign eq1646 = io_in_itype_immed[11] == 1'h1;
  assign sel1648 = eq1646 ? proxy1640 : proxy1634;
  assign eq1653 = io_in_rs2_src == 1'h1;
  assign sel1655 = eq1653 ? sel1648 : io_in_rd2;
  assign proxy1660 = {io_in_upper_immed, 12'h0};
  assign shl1665 = $signed(sel1648) << 32'h1;
  assign sub1669 = $signed(io_in_PC_next) - $signed(32'h4);
  assign add1671 = $signed(sub1669) + $signed(shl1665);
  assign add1680 = $signed(io_in_rd1) + $signed(sel1655);
  assign sub1685 = $signed(io_in_rd1) - $signed(sel1655);
  assign shl1689 = io_in_rd1 << sel1655;
  assign lt1696 = $signed(io_in_rd1) < $signed(sel1655);
  assign sel1698 = lt1696 ? 32'h1 : 32'h0;
  assign lt1705 = io_in_rd1 < sel1655;
  assign sel1707 = lt1705 ? 32'h1 : 32'h0;
  assign xorl1712 = io_in_rd1 ^ sel1655;
  assign shr1716 = io_in_rd1 >> sel1655;
  assign shr1721 = $signed(io_in_rd1) >> sel1655;
  assign orl1726 = io_in_rd1 | sel1655;
  assign andl1731 = sel1655 & io_in_rd1;
  assign ge1735 = io_in_rd1 >= sel1655;
  assign add1747 = $signed(sub1669) + $signed(proxy1660);
  assign orl1753 = io_in_csr_data | io_in_csr_mask;
  assign sub1757 = 32'hffffffff - io_in_csr_mask;
  assign andl1760 = io_in_csr_data & sub1757;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1764 = 32'h7b;
      4'h1: sel1764 = 32'h7b;
      4'h2: sel1764 = 32'h7b;
      4'h3: sel1764 = 32'h7b;
      4'h4: sel1764 = 32'h7b;
      4'h5: sel1764 = 32'h7b;
      4'h6: sel1764 = 32'h7b;
      4'h7: sel1764 = 32'h7b;
      4'h8: sel1764 = 32'h7b;
      4'h9: sel1764 = 32'h7b;
      4'ha: sel1764 = 32'h7b;
      4'hb: sel1764 = 32'h7b;
      4'hc: sel1764 = 32'h7b;
      4'hd: sel1764 = io_in_csr_mask;
      4'he: sel1764 = orl1753;
      4'hf: sel1764 = andl1760;
      default: sel1764 = 32'h7b;
    endcase
  end
  assign sel1765 = ge1735 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1766 = add1680;
      4'h1: sel1766 = sub1685;
      4'h2: sel1766 = shl1689;
      4'h3: sel1766 = sel1698;
      4'h4: sel1766 = sel1707;
      4'h5: sel1766 = xorl1712;
      4'h6: sel1766 = shr1716;
      4'h7: sel1766 = shr1721;
      4'h8: sel1766 = orl1726;
      4'h9: sel1766 = andl1731;
      4'ha: sel1766 = sel1765;
      4'hb: sel1766 = proxy1660;
      4'hc: sel1766 = add1747;
      4'hd: sel1766 = io_in_csr_data;
      4'he: sel1766 = io_in_csr_data;
      4'hf: sel1766 = io_in_csr_data;
      default: sel1766 = 32'h0;
    endcase
  end
  assign eq1772 = sel1766 == 32'h0;
  assign sel1774 = eq1772 ? 1'h1 : 1'h0;
  assign sel1782 = eq1772 ? 1'h0 : 1'h1;
  assign eq1789 = sel1766[31] == 1'h0;
  assign sel1791 = eq1789 ? 1'h0 : 1'h1;
  assign sel1800 = eq1789 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel1823 = sel1774;
      3'h2: sel1823 = sel1782;
      3'h3: sel1823 = sel1791;
      3'h4: sel1823 = sel1800;
      3'h5: sel1823 = sel1791;
      3'h6: sel1823 = sel1800;
      3'h0: sel1823 = 1'h0;
      default: sel1823 = 1'h0;
    endcase
  end

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1764;
  assign io_out_alu_result = sel1766;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_branch_dir = sel1823;
  assign io_out_branch_dest = add1671;
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
  reg[31:0] reg1982, reg2004, reg2016, reg2029, reg2062;
  reg[4:0] reg1992, reg1998, reg2010;
  reg[1:0] reg2023;
  reg[2:0] reg2036, reg2042;
  reg[11:0] reg2049;
  reg reg2056;

  always @ (posedge clk) begin
    if (reset)
      reg1982 <= 32'h0;
    else
      reg1982 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1992 <= 5'h0;
    else
      reg1992 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1998 <= 5'h0;
    else
      reg1998 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2004 <= 32'h0;
    else
      reg2004 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2010 <= 5'h0;
    else
      reg2010 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2016 <= 32'h0;
    else
      reg2016 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2023 <= 2'h0;
    else
      reg2023 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2029 <= 32'h0;
    else
      reg2029 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2036 <= 3'h0;
    else
      reg2036 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2042 <= 3'h0;
    else
      reg2042 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2049 <= 12'h0;
    else
      reg2049 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2056 <= 1'h0;
    else
      reg2056 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2062 <= 32'h0;
    else
      reg2062 <= io_in_csr_result;
  end

  assign io_out_csr_address = reg2049;
  assign io_out_is_csr = reg2056;
  assign io_out_csr_result = reg2062;
  assign io_out_alu_result = reg1982;
  assign io_out_rd = reg1992;
  assign io_out_wb = reg2023;
  assign io_out_rs1 = reg1998;
  assign io_out_rd1 = reg2004;
  assign io_out_rd2 = reg2016;
  assign io_out_rs2 = reg2010;
  assign io_out_mem_read = reg2036;
  assign io_out_mem_write = reg2042;
  assign io_out_PC_next = reg2029;

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
  wire lt2237, lt2240, orl2242, eq2250, eq2264, eq2268, andl2270, eq2291, eq2295, andl2297, orl2300, proxy2319, eq2320, proxy2339, eq2340;
  wire[1:0] sel2276, sel2280, sel2284;
  wire[7:0] proxy2309;
  wire[31:0] proxy2311, proxy2315, sel2322, proxy2331, proxy2335, sel2342;
  wire[15:0] proxy2329;
  reg[31:0] sel2362;

  assign lt2237 = io_in_mem_write < 3'h7;
  assign lt2240 = io_in_mem_read < 3'h7;
  assign orl2242 = lt2240 | lt2237;
  assign eq2250 = io_in_mem_write == 3'h2;
  assign eq2264 = io_in_mem_write == 3'h7;
  assign eq2268 = io_in_mem_read == 3'h7;
  assign andl2270 = eq2268 & eq2264;
  assign sel2276 = andl2270 ? 2'h0 : 2'h3;
  assign sel2280 = eq2250 ? 2'h2 : sel2276;
  assign sel2284 = lt2240 ? 2'h1 : sel2280;
  assign eq2291 = eq2250 == 1'h0;
  assign eq2295 = andl2270 == 1'h0;
  assign andl2297 = eq2295 & eq2291;
  assign orl2300 = lt2240 | andl2297;
  assign proxy2309 = io_DBUS_in_data_data[7:0];
  assign proxy2311 = {24'h0, proxy2309};
  assign proxy2315 = {24'hffffff, proxy2309};
  assign proxy2319 = proxy2309[7];
  assign eq2320 = proxy2319 == 1'h1;
  assign sel2322 = eq2320 ? proxy2315 : proxy2311;
  assign proxy2329 = io_DBUS_in_data_data[15:0];
  assign proxy2331 = {16'h0, proxy2329};
  assign proxy2335 = {16'hffff, proxy2329};
  assign proxy2339 = proxy2329[15];
  assign eq2340 = proxy2339 == 1'h1;
  assign sel2342 = eq2340 ? proxy2335 : proxy2331;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2362 = sel2322;
      3'h1: sel2362 = sel2342;
      3'h2: sel2362 = io_DBUS_in_data_data;
      3'h4: sel2362 = proxy2311;
      3'h5: sel2362 = proxy2331;
      default: sel2362 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2300;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2237;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2242;
  assign io_DBUS_out_control_data = sel2284;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2362;

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
  wire[31:0] bindin2369, bindout2378, bindout2387, bindin2405, bindin2414, bindout2417;
  wire bindin2372, bindout2375, bindout2381, bindin2384, bindout2390, bindin2393, bindout2399, bindin2402;
  wire[1:0] bindout2396;
  wire[2:0] bindin2408, bindin2411;

  Cache __module10__(.io_DBUS_in_data_data(bindin2369), .io_DBUS_in_data_valid(bindin2372), .io_DBUS_out_data_ready(bindin2384), .io_DBUS_out_address_ready(bindin2393), .io_DBUS_out_control_ready(bindin2402), .io_in_address(bindin2405), .io_in_mem_read(bindin2408), .io_in_mem_write(bindin2411), .io_in_data(bindin2414), .io_DBUS_in_data_ready(bindout2375), .io_DBUS_out_data_data(bindout2378), .io_DBUS_out_data_valid(bindout2381), .io_DBUS_out_address_data(bindout2387), .io_DBUS_out_address_valid(bindout2390), .io_DBUS_out_control_data(bindout2396), .io_DBUS_out_control_valid(bindout2399), .io_out_data(bindout2417));
  assign bindin2369 = io_DBUS_in_data_data;
  assign bindin2372 = io_DBUS_in_data_valid;
  assign bindin2384 = io_DBUS_out_data_ready;
  assign bindin2393 = io_DBUS_out_address_ready;
  assign bindin2402 = io_DBUS_out_control_ready;
  assign bindin2405 = io_in_alu_result;
  assign bindin2408 = io_in_mem_read;
  assign bindin2411 = io_in_mem_write;
  assign bindin2414 = io_in_rd2;

  assign io_DBUS_in_data_ready = bindout2375;
  assign io_DBUS_out_data_data = bindout2378;
  assign io_DBUS_out_data_valid = bindout2381;
  assign io_DBUS_out_address_data = bindout2387;
  assign io_DBUS_out_address_valid = bindout2390;
  assign io_DBUS_out_control_data = bindout2396;
  assign io_DBUS_out_control_valid = bindout2399;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2417;
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
  reg[31:0] reg2540, reg2549, reg2581;
  reg[4:0] reg2556, reg2562, reg2568;
  reg[1:0] reg2575;

  always @ (posedge clk) begin
    if (reset)
      reg2540 <= 32'h0;
    else
      reg2540 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2549 <= 32'h0;
    else
      reg2549 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2556 <= 5'h0;
    else
      reg2556 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2562 <= 5'h0;
    else
      reg2562 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2568 <= 5'h0;
    else
      reg2568 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2575 <= 2'h0;
    else
      reg2575 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2581 <= 32'h0;
    else
      reg2581 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2540;
  assign io_out_mem_result = reg2549;
  assign io_out_rd = reg2556;
  assign io_out_wb = reg2575;
  assign io_out_rs1 = reg2562;
  assign io_out_rs2 = reg2568;
  assign io_out_PC_next = reg2581;

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
  wire eq2647, eq2652;
  wire[31:0] sel2654, sel2656;

  assign eq2647 = io_in_wb == 2'h3;
  assign eq2652 = io_in_wb == 2'h1;
  assign sel2654 = eq2652 ? io_in_alu_result : io_in_mem_result;
  assign sel2656 = eq2647 ? io_in_PC_next : sel2654;

  assign io_out_write_data = sel2656;
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
  wire eq2736, eq2740, eq2744, eq2749, eq2753, eq2757, eq2762, eq2766, ne2771, ne2776, eq2779, andl2781, andl2783, eq2788, ne2792, eq2799, andl2801, andl2803, andl2805, eq2809, ne2817, eq2824, andl2826, andl2828, andl2830, andl2832, orl2835, orl2837, ne2863, eq2866, andl2868, andl2870, eq2874, eq2885, andl2887, andl2889, andl2891, eq2895, eq2910, andl2912, andl2914, andl2916, andl2918, orl2921, orl2923, eq2943, andl2945, eq2949, eq2952, andl2954, andl2956, orl2959, orl2969, andl2971, sel2973;
  wire[31:0] sel2841, sel2843, sel2845, sel2847, sel2849, sel2851, sel2853, sel2855, sel2930, sel2936, sel2940, sel2962, sel2964;

  assign eq2736 = io_in_execute_wb == 2'h2;
  assign eq2740 = io_in_memory_wb == 2'h2;
  assign eq2744 = io_in_writeback_wb == 2'h2;
  assign eq2749 = io_in_execute_wb == 2'h3;
  assign eq2753 = io_in_memory_wb == 2'h3;
  assign eq2757 = io_in_writeback_wb == 2'h3;
  assign eq2762 = io_in_execute_is_csr == 1'h1;
  assign eq2766 = io_in_memory_is_csr == 1'h1;
  assign ne2771 = io_in_execute_wb != 2'h0;
  assign ne2776 = io_in_decode_src1 != 5'h0;
  assign eq2779 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2781 = eq2779 & ne2776;
  assign andl2783 = andl2781 & ne2771;
  assign eq2788 = andl2783 == 1'h0;
  assign ne2792 = io_in_memory_wb != 2'h0;
  assign eq2799 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2801 = eq2799 & ne2776;
  assign andl2803 = andl2801 & ne2792;
  assign andl2805 = andl2803 & eq2788;
  assign eq2809 = andl2805 == 1'h0;
  assign ne2817 = io_in_writeback_wb != 2'h0;
  assign eq2824 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2826 = eq2824 & ne2776;
  assign andl2828 = andl2826 & ne2817;
  assign andl2830 = andl2828 & eq2788;
  assign andl2832 = andl2830 & eq2809;
  assign orl2835 = andl2783 | andl2805;
  assign orl2837 = orl2835 | andl2832;
  assign sel2841 = eq2744 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2843 = eq2757 ? io_in_writeback_PC_next : sel2841;
  assign sel2845 = andl2832 ? sel2843 : 32'h7b;
  assign sel2847 = eq2740 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2849 = eq2753 ? io_in_memory_PC_next : sel2847;
  assign sel2851 = andl2805 ? sel2849 : sel2845;
  assign sel2853 = eq2749 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2855 = andl2783 ? sel2853 : sel2851;
  assign ne2863 = io_in_decode_src2 != 5'h0;
  assign eq2866 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2868 = eq2866 & ne2863;
  assign andl2870 = andl2868 & ne2771;
  assign eq2874 = andl2870 == 1'h0;
  assign eq2885 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2887 = eq2885 & ne2863;
  assign andl2889 = andl2887 & ne2792;
  assign andl2891 = andl2889 & eq2874;
  assign eq2895 = andl2891 == 1'h0;
  assign eq2910 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2912 = eq2910 & ne2863;
  assign andl2914 = andl2912 & ne2817;
  assign andl2916 = andl2914 & eq2874;
  assign andl2918 = andl2916 & eq2895;
  assign orl2921 = andl2870 | andl2891;
  assign orl2923 = orl2921 | andl2918;
  assign sel2930 = andl2918 ? sel2843 : 32'h7b;
  assign sel2936 = andl2891 ? sel2849 : sel2930;
  assign sel2940 = andl2870 ? sel2853 : sel2936;
  assign eq2943 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2945 = eq2943 & eq2762;
  assign eq2949 = andl2945 == 1'h0;
  assign eq2952 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2954 = eq2952 & eq2766;
  assign andl2956 = andl2954 & eq2949;
  assign orl2959 = andl2945 | andl2956;
  assign sel2962 = andl2956 ? io_in_memory_csr_result : 32'h7b;
  assign sel2964 = andl2945 ? io_in_execute_alu_result : sel2962;
  assign orl2969 = andl2783 | andl2870;
  assign andl2971 = orl2969 & eq2736;
  assign sel2973 = andl2971 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2837;
  assign io_out_src1_fwd_data = sel2855;
  assign io_out_src2_fwd = orl2923;
  assign io_out_src2_fwd_data = sel2940;
  assign io_out_csr_fwd = orl2959;
  assign io_out_csr_fwd_data = sel2964;
  assign io_out_fwd_stall = sel2973;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3080 [0:1];
  wire[31:0] mrport3082;

  initial begin
    mem3080[0] = 32'hdeadbeef;
    mem3080[1] = 32'hdeadbeef;
  end
  assign mrport3082 = mem3080[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport3082;

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
  reg[3:0] reg3151, sel3241;
  wire eq3159, andl3244, eq3248, andl3252, eq3256, andl3260;
  wire[3:0] sel3165, sel3170, sel3176, sel3182, sel3192, sel3197, sel3201, sel3210, sel3216, sel3226, sel3231, sel3235, sel3242, sel3258, sel3259, sel3261;

  always @ (posedge clk) begin
    if (reset)
      reg3151 <= 4'h0;
    else
      reg3151 <= sel3261;
  end
  assign eq3159 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3165 = eq3159 ? 4'h0 : 4'h1;
  assign sel3170 = eq3159 ? 4'h2 : 4'h1;
  assign sel3176 = eq3159 ? 4'h9 : 4'h3;
  assign sel3182 = eq3159 ? 4'h5 : 4'h4;
  assign sel3192 = eq3159 ? 4'h8 : 4'h6;
  assign sel3197 = eq3159 ? 4'h7 : 4'h6;
  assign sel3201 = eq3159 ? 4'h4 : 4'h8;
  assign sel3210 = eq3159 ? 4'h0 : 4'ha;
  assign sel3216 = eq3159 ? 4'hc : 4'hb;
  assign sel3226 = eq3159 ? 4'hf : 4'hd;
  assign sel3231 = eq3159 ? 4'he : 4'hd;
  assign sel3235 = eq3159 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3151)
      4'h0: sel3241 = sel3165;
      4'h1: sel3241 = sel3170;
      4'h2: sel3241 = sel3176;
      4'h3: sel3241 = sel3182;
      4'h4: sel3241 = sel3182;
      4'h5: sel3241 = sel3192;
      4'h6: sel3241 = sel3197;
      4'h7: sel3241 = sel3201;
      4'h8: sel3241 = sel3170;
      4'h9: sel3241 = sel3210;
      4'ha: sel3241 = sel3216;
      4'hb: sel3241 = sel3216;
      4'hc: sel3241 = sel3226;
      4'hd: sel3241 = sel3231;
      4'he: sel3241 = sel3235;
      4'hf: sel3241 = sel3170;
      default: sel3241 = reg3151;
    endcase
  end
  assign sel3242 = io_JTAG_TAP_in_mode_select_valid ? sel3241 : 4'h0;
  assign andl3244 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3248 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3252 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3256 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3258 = eq3248 ? 4'h0 : reg3151;
  assign sel3259 = andl3260 ? sel3242 : reg3151;
  assign andl3260 = andl3252 & eq3256;
  assign sel3261 = andl3244 ? sel3258 : sel3259;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3151;

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
  wire bindin3267, bindin3269, bindin3270, bindin3273, bindout3276, bindin3279, bindin3282, bindout3285, bindin3288, bindin3291, bindout3294, eq3331, eq3340, eq3345, eq3422, andl3423, sel3424, sel3431;
  wire[3:0] bindout3297;
  reg[31:0] reg3305, reg3312, reg3319, reg3326, sel3430;
  wire[31:0] sel3348, sel3350, shr3357, proxy3362, sel3417, sel3418, sel3419, sel3420, sel3421;
  wire[30:0] proxy3360;
  reg sel3429, sel3436;

  assign bindin3267 = clk;
  assign bindin3269 = reset;
  TAP __module16__(.clk(bindin3267), .reset(bindin3269), .io_JTAG_TAP_in_mode_select_data(bindin3270), .io_JTAG_TAP_in_mode_select_valid(bindin3273), .io_JTAG_TAP_in_clock_data(bindin3279), .io_JTAG_TAP_in_clock_valid(bindin3282), .io_JTAG_TAP_in_reset_data(bindin3288), .io_JTAG_TAP_in_reset_valid(bindin3291), .io_JTAG_TAP_in_mode_select_ready(bindout3276), .io_JTAG_TAP_in_clock_ready(bindout3285), .io_JTAG_TAP_in_reset_ready(bindout3294), .io_out_curr_state(bindout3297));
  assign bindin3270 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3273 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3279 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3282 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3288 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3291 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3305 <= 32'h0;
    else
      reg3305 <= sel3420;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3312 <= 32'h1234;
    else
      reg3312 <= sel3419;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3319 <= 32'h5678;
    else
      reg3319 <= sel3421;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3326 <= 32'h0;
    else
      reg3326 <= sel3430;
  end
  assign eq3331 = reg3305 == 32'h0;
  assign eq3340 = reg3305 == 32'h1;
  assign eq3345 = reg3305 == 32'h2;
  assign sel3348 = eq3345 ? reg3312 : 32'hdeadbeef;
  assign sel3350 = eq3340 ? reg3319 : sel3348;
  assign shr3357 = reg3326 >> 32'h1;
  assign proxy3360 = shr3357[30:0];
  assign proxy3362 = {io_JTAG_in_data_data, proxy3360};
  assign sel3417 = eq3345 ? reg3326 : reg3312;
  assign sel3418 = eq3340 ? reg3312 : sel3417;
  assign sel3419 = (bindout3297 == 4'h8) ? sel3418 : reg3312;
  assign sel3420 = (bindout3297 == 4'hf) ? reg3326 : reg3305;
  assign sel3421 = andl3423 ? reg3326 : reg3319;
  assign eq3422 = bindout3297 == 4'h8;
  assign andl3423 = eq3422 & eq3340;
  assign sel3424 = eq3331 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3297)
      4'h3: sel3429 = sel3424;
      4'h4: sel3429 = 1'h1;
      4'h8: sel3429 = sel3424;
      4'ha: sel3429 = sel3424;
      4'hb: sel3429 = 1'h1;
      4'hf: sel3429 = sel3424;
      default: sel3429 = sel3424;
    endcase
  end
  always @(*) begin
    case (bindout3297)
      4'h3: sel3430 = sel3350;
      4'h4: sel3430 = proxy3362;
      4'ha: sel3430 = reg3305;
      4'hb: sel3430 = proxy3362;
      default: sel3430 = reg3326;
    endcase
  end
  assign sel3431 = eq3331 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3297)
      4'h3: sel3436 = sel3431;
      4'h4: sel3436 = reg3326[0];
      4'h8: sel3436 = sel3431;
      4'ha: sel3436 = sel3431;
      4'hb: sel3436 = reg3326[0];
      4'hf: sel3436 = sel3431;
      default: sel3436 = sel3431;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3276;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3285;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3294;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3436;
  assign io_JTAG_out_data_valid = sel3429;

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
  reg[31:0] mem3492 [0:4095];
  reg[1:0] reg3501, sel3535;
  wire eq3513, eq3517, eq3533;
  reg sel3536;
  reg[31:0] sel3537;
  reg[11:0] sel3538;
  wire[31:0] mrport3540;

  always @ (posedge clk) begin
    if (sel3536) begin
      mem3492[sel3538] <= sel3537;
    end
  end
  assign mrport3540 = mem3492[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (reset)
      reg3501 <= 2'h0;
    else
      reg3501 <= sel3535;
  end
  assign eq3513 = reg3501 == 2'h1;
  assign eq3517 = reg3501 == 2'h0;
  assign eq3533 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3517)
      sel3535 = 2'h1;
    else if (eq3513)
      sel3535 = 2'h3;
    else
      sel3535 = reg3501;
  end
  always @(*) begin
    if (eq3517)
      sel3536 = 1'h1;
    else if (eq3513)
      sel3536 = 1'h1;
    else
      sel3536 = eq3533;
  end
  always @(*) begin
    if (eq3517)
      sel3537 = 32'h0;
    else if (eq3513)
      sel3537 = 32'h0;
    else
      sel3537 = io_in_mem_csr_result;
  end
  always @(*) begin
    if (eq3517)
      sel3538 = 12'hf14;
    else if (eq3513)
      sel3538 = 12'h301;
    else
      sel3538 = io_in_mem_csr_address;
  end

  assign io_out_decode_csr_data = mrport3540;

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
  wire bindin156, bindin158, bindin162, bindout165, bindout171, bindin174, bindin177, bindin183, bindin186, bindin189, bindin195, bindin252, bindin253, bindin260, bindin263, bindin1095, bindin1096, bindin1103, bindin1115, bindin1121, bindin1127, bindout1139, bindout1172, bindout1187, bindout1190, bindin1457, bindin1458, bindin1480, bindin1498, bindin1507, bindout1519, bindout1549, bindin1848, bindin1872, bindout1884, bindout1917, bindin2067, bindin2068, bindin2102, bindout2111, bindin2424, bindout2427, bindout2433, bindin2436, bindout2442, bindin2445, bindout2451, bindin2454, bindin2586, bindin2587, bindin3002, bindin3026, bindout3050, bindout3056, bindout3062, bindout3068, bindin3087, bindin3090, bindout3093, bindout3096, bindin3440, bindin3441, bindin3442, bindin3445, bindout3448, bindin3451, bindin3454, bindout3457, bindin3460, bindin3463, bindout3466, bindin3469, bindin3472, bindout3475, bindout3478, bindout3481, bindin3484, bindin3545, bindin3546, bindin3553, eq3563;
  wire[31:0] bindin159, bindout168, bindin180, bindin192, bindin198, bindout201, bindout204, bindin254, bindin257, bindout266, bindout269, bindin1097, bindin1100, bindin1106, bindin1118, bindin1124, bindin1130, bindin1133, bindout1142, bindout1145, bindout1148, bindout1157, bindout1163, bindout1193, bindout1199, bindin1465, bindin1471, bindin1492, bindin1510, bindin1513, bindout1522, bindout1525, bindout1534, bindout1540, bindout1567, bindin1833, bindin1839, bindin1860, bindin1875, bindin1878, bindout1887, bindout1890, bindout1902, bindout1908, bindout1920, bindout1923, bindin2069, bindin2081, bindin2087, bindin2096, bindin2105, bindout2114, bindout2117, bindout2129, bindout2132, bindout2144, bindin2421, bindout2430, bindout2439, bindin2457, bindin2475, bindin2481, bindin2484, bindout2487, bindout2490, bindout2505, bindin2588, bindin2591, bindin2606, bindout2609, bindout2612, bindout2627, bindin2661, bindin2664, bindin2679, bindout2682, bindin2996, bindin2999, bindin3008, bindin3017, bindin3020, bindin3023, bindin3032, bindin3041, bindin3044, bindin3047, bindout3053, bindout3059, bindout3065, bindout3099, bindin3556, bindout3559;
  wire[4:0] bindin1109, bindout1151, bindout1154, bindout1160, bindin1459, bindin1462, bindin1468, bindout1528, bindout1531, bindout1537, bindin1827, bindin1830, bindin1836, bindout1893, bindout1899, bindout1905, bindin2072, bindin2078, bindin2084, bindout2120, bindout2126, bindout2135, bindin2466, bindin2472, bindin2478, bindout2493, bindout2499, bindout2502, bindin2594, bindin2600, bindin2603, bindout2615, bindout2621, bindout2624, bindin2667, bindin2673, bindin2676, bindout2685, bindin2981, bindin2984, bindin2990, bindin3011, bindin3035;
  wire[1:0] bindin1112, bindout1166, bindin1477, bindout1546, bindin1845, bindout1896, bindin2075, bindout2123, bindout2448, bindin2469, bindout2496, bindin2597, bindout2618, bindin2670, bindout2688, bindin2993, bindin3014, bindin3038;
  wire[11:0] bindout1136, bindout1175, bindin1483, bindin1504, bindout1516, bindout1552, bindin1851, bindin1869, bindout1881, bindin2099, bindout2108, bindin2987, bindin3005, bindin3029, bindin3547, bindin3550;
  wire[3:0] bindout1169, bindin1474, bindout1543, bindin1842;
  wire[2:0] bindout1178, bindout1181, bindout1184, bindin1486, bindin1489, bindin1495, bindout1555, bindout1558, bindout1561, bindin1854, bindin1857, bindin1863, bindout1911, bindout1914, bindin2090, bindin2093, bindout2138, bindout2141, bindin2460, bindin2463;
  wire[19:0] bindout1196, bindin1501, bindout1564, bindin1866;

  assign bindin156 = clk;
  assign bindin158 = reset;
  Fetch __module2__(.clk(bindin156), .reset(bindin158), .io_IBUS_in_data_data(bindin159), .io_IBUS_in_data_valid(bindin162), .io_IBUS_out_address_ready(bindin174), .io_in_branch_dir(bindin177), .io_in_branch_dest(bindin180), .io_in_branch_stall(bindin183), .io_in_fwd_stall(bindin186), .io_in_jal(bindin189), .io_in_jal_dest(bindin192), .io_in_interrupt(bindin195), .io_in_interrupt_pc(bindin198), .io_IBUS_in_data_ready(bindout165), .io_IBUS_out_address_data(bindout168), .io_IBUS_out_address_valid(bindout171), .io_out_instruction(bindout201), .io_out_PC_next(bindout204));
  assign bindin159 = io_IBUS_in_data_data;
  assign bindin162 = io_IBUS_in_data_valid;
  assign bindin174 = io_IBUS_out_address_ready;
  assign bindin177 = bindout1917;
  assign bindin180 = bindout1920;
  assign bindin183 = bindout1187;
  assign bindin186 = bindout3068;
  assign bindin189 = bindout1190;
  assign bindin192 = bindout1193;
  assign bindin195 = bindout3096;
  assign bindin198 = bindout3099;
  assign bindin252 = clk;
  assign bindin253 = reset;
  F_D_Register __module3__(.clk(bindin252), .reset(bindin253), .io_in_instruction(bindin254), .io_in_PC_next(bindin257), .io_in_branch_stall(bindin260), .io_in_fwd_stall(bindin263), .io_out_instruction(bindout266), .io_out_PC_next(bindout269));
  assign bindin254 = bindout201;
  assign bindin257 = bindout204;
  assign bindin260 = bindout1187;
  assign bindin263 = bindout3068;
  assign bindin1095 = clk;
  assign bindin1096 = reset;
  Decode __module4__(.clk(bindin1095), .reset(bindin1096), .io_in_instruction(bindin1097), .io_in_PC_next(bindin1100), .io_in_stall(bindin1103), .io_in_write_data(bindin1106), .io_in_rd(bindin1109), .io_in_wb(bindin1112), .io_in_src1_fwd(bindin1115), .io_in_src1_fwd_data(bindin1118), .io_in_src2_fwd(bindin1121), .io_in_src2_fwd_data(bindin1124), .io_in_csr_fwd(bindin1127), .io_in_csr_fwd_data(bindin1130), .io_in_csr_data(bindin1133), .io_out_csr_address(bindout1136), .io_out_is_csr(bindout1139), .io_out_csr_data(bindout1142), .io_out_csr_mask(bindout1145), .io_actual_change(bindout1148), .io_out_rd(bindout1151), .io_out_rs1(bindout1154), .io_out_rd1(bindout1157), .io_out_rs2(bindout1160), .io_out_rd2(bindout1163), .io_out_wb(bindout1166), .io_out_alu_op(bindout1169), .io_out_rs2_src(bindout1172), .io_out_itype_immed(bindout1175), .io_out_mem_read(bindout1178), .io_out_mem_write(bindout1181), .io_out_branch_type(bindout1184), .io_out_branch_stall(bindout1187), .io_out_jal(bindout1190), .io_out_jal_dest(bindout1193), .io_out_upper_immed(bindout1196), .io_out_PC_next(bindout1199));
  assign bindin1097 = bindout266;
  assign bindin1100 = bindout269;
  assign bindin1103 = eq3563;
  assign bindin1106 = bindout2682;
  assign bindin1109 = bindout2685;
  assign bindin1112 = bindout2688;
  assign bindin1115 = bindout3050;
  assign bindin1118 = bindout3053;
  assign bindin1121 = bindout3056;
  assign bindin1124 = bindout3059;
  assign bindin1127 = bindout3062;
  assign bindin1130 = bindout3065;
  assign bindin1133 = bindout3559;
  assign bindin1457 = clk;
  assign bindin1458 = reset;
  D_E_Register __module6__(.clk(bindin1457), .reset(bindin1458), .io_in_rd(bindin1459), .io_in_rs1(bindin1462), .io_in_rd1(bindin1465), .io_in_rs2(bindin1468), .io_in_rd2(bindin1471), .io_in_alu_op(bindin1474), .io_in_wb(bindin1477), .io_in_rs2_src(bindin1480), .io_in_itype_immed(bindin1483), .io_in_mem_read(bindin1486), .io_in_mem_write(bindin1489), .io_in_PC_next(bindin1492), .io_in_branch_type(bindin1495), .io_in_fwd_stall(bindin1498), .io_in_upper_immed(bindin1501), .io_in_csr_address(bindin1504), .io_in_is_csr(bindin1507), .io_in_csr_data(bindin1510), .io_in_csr_mask(bindin1513), .io_out_csr_address(bindout1516), .io_out_is_csr(bindout1519), .io_out_csr_data(bindout1522), .io_out_csr_mask(bindout1525), .io_out_rd(bindout1528), .io_out_rs1(bindout1531), .io_out_rd1(bindout1534), .io_out_rs2(bindout1537), .io_out_rd2(bindout1540), .io_out_alu_op(bindout1543), .io_out_wb(bindout1546), .io_out_rs2_src(bindout1549), .io_out_itype_immed(bindout1552), .io_out_mem_read(bindout1555), .io_out_mem_write(bindout1558), .io_out_branch_type(bindout1561), .io_out_upper_immed(bindout1564), .io_out_PC_next(bindout1567));
  assign bindin1459 = bindout1151;
  assign bindin1462 = bindout1154;
  assign bindin1465 = bindout1157;
  assign bindin1468 = bindout1160;
  assign bindin1471 = bindout1163;
  assign bindin1474 = bindout1169;
  assign bindin1477 = bindout1166;
  assign bindin1480 = bindout1172;
  assign bindin1483 = bindout1175;
  assign bindin1486 = bindout1178;
  assign bindin1489 = bindout1181;
  assign bindin1492 = bindout1199;
  assign bindin1495 = bindout1184;
  assign bindin1498 = bindout3068;
  assign bindin1501 = bindout1196;
  assign bindin1504 = bindout1136;
  assign bindin1507 = bindout1139;
  assign bindin1510 = bindout1142;
  assign bindin1513 = bindout1145;
  Execute __module7__(.io_in_rd(bindin1827), .io_in_rs1(bindin1830), .io_in_rd1(bindin1833), .io_in_rs2(bindin1836), .io_in_rd2(bindin1839), .io_in_alu_op(bindin1842), .io_in_wb(bindin1845), .io_in_rs2_src(bindin1848), .io_in_itype_immed(bindin1851), .io_in_mem_read(bindin1854), .io_in_mem_write(bindin1857), .io_in_PC_next(bindin1860), .io_in_branch_type(bindin1863), .io_in_upper_immed(bindin1866), .io_in_csr_address(bindin1869), .io_in_is_csr(bindin1872), .io_in_csr_data(bindin1875), .io_in_csr_mask(bindin1878), .io_out_csr_address(bindout1881), .io_out_is_csr(bindout1884), .io_out_csr_result(bindout1887), .io_out_alu_result(bindout1890), .io_out_rd(bindout1893), .io_out_wb(bindout1896), .io_out_rs1(bindout1899), .io_out_rd1(bindout1902), .io_out_rs2(bindout1905), .io_out_rd2(bindout1908), .io_out_mem_read(bindout1911), .io_out_mem_write(bindout1914), .io_out_branch_dir(bindout1917), .io_out_branch_dest(bindout1920), .io_out_PC_next(bindout1923));
  assign bindin1827 = bindout1528;
  assign bindin1830 = bindout1531;
  assign bindin1833 = bindout1534;
  assign bindin1836 = bindout1537;
  assign bindin1839 = bindout1540;
  assign bindin1842 = bindout1543;
  assign bindin1845 = bindout1546;
  assign bindin1848 = bindout1549;
  assign bindin1851 = bindout1552;
  assign bindin1854 = bindout1555;
  assign bindin1857 = bindout1558;
  assign bindin1860 = bindout1567;
  assign bindin1863 = bindout1561;
  assign bindin1866 = bindout1564;
  assign bindin1869 = bindout1516;
  assign bindin1872 = bindout1519;
  assign bindin1875 = bindout1522;
  assign bindin1878 = bindout1525;
  assign bindin2067 = clk;
  assign bindin2068 = reset;
  E_M_Register __module8__(.clk(bindin2067), .reset(bindin2068), .io_in_alu_result(bindin2069), .io_in_rd(bindin2072), .io_in_wb(bindin2075), .io_in_rs1(bindin2078), .io_in_rd1(bindin2081), .io_in_rs2(bindin2084), .io_in_rd2(bindin2087), .io_in_mem_read(bindin2090), .io_in_mem_write(bindin2093), .io_in_PC_next(bindin2096), .io_in_csr_address(bindin2099), .io_in_is_csr(bindin2102), .io_in_csr_result(bindin2105), .io_out_csr_address(bindout2108), .io_out_is_csr(bindout2111), .io_out_csr_result(bindout2114), .io_out_alu_result(bindout2117), .io_out_rd(bindout2120), .io_out_wb(bindout2123), .io_out_rs1(bindout2126), .io_out_rd1(bindout2129), .io_out_rd2(bindout2132), .io_out_rs2(bindout2135), .io_out_mem_read(bindout2138), .io_out_mem_write(bindout2141), .io_out_PC_next(bindout2144));
  assign bindin2069 = bindout1890;
  assign bindin2072 = bindout1893;
  assign bindin2075 = bindout1896;
  assign bindin2078 = bindout1899;
  assign bindin2081 = bindout1902;
  assign bindin2084 = bindout1905;
  assign bindin2087 = bindout1908;
  assign bindin2090 = bindout1911;
  assign bindin2093 = bindout1914;
  assign bindin2096 = bindout1923;
  assign bindin2099 = bindout1881;
  assign bindin2102 = bindout1884;
  assign bindin2105 = bindout1887;
  Memory __module9__(.io_DBUS_in_data_data(bindin2421), .io_DBUS_in_data_valid(bindin2424), .io_DBUS_out_data_ready(bindin2436), .io_DBUS_out_address_ready(bindin2445), .io_DBUS_out_control_ready(bindin2454), .io_in_alu_result(bindin2457), .io_in_mem_read(bindin2460), .io_in_mem_write(bindin2463), .io_in_rd(bindin2466), .io_in_wb(bindin2469), .io_in_rs1(bindin2472), .io_in_rd1(bindin2475), .io_in_rs2(bindin2478), .io_in_rd2(bindin2481), .io_in_PC_next(bindin2484), .io_DBUS_in_data_ready(bindout2427), .io_DBUS_out_data_data(bindout2430), .io_DBUS_out_data_valid(bindout2433), .io_DBUS_out_address_data(bindout2439), .io_DBUS_out_address_valid(bindout2442), .io_DBUS_out_control_data(bindout2448), .io_DBUS_out_control_valid(bindout2451), .io_out_alu_result(bindout2487), .io_out_mem_result(bindout2490), .io_out_rd(bindout2493), .io_out_wb(bindout2496), .io_out_rs1(bindout2499), .io_out_rs2(bindout2502), .io_out_PC_next(bindout2505));
  assign bindin2421 = io_DBUS_in_data_data;
  assign bindin2424 = io_DBUS_in_data_valid;
  assign bindin2436 = io_DBUS_out_data_ready;
  assign bindin2445 = io_DBUS_out_address_ready;
  assign bindin2454 = io_DBUS_out_control_ready;
  assign bindin2457 = bindout2117;
  assign bindin2460 = bindout2138;
  assign bindin2463 = bindout2141;
  assign bindin2466 = bindout2120;
  assign bindin2469 = bindout2123;
  assign bindin2472 = bindout2126;
  assign bindin2475 = bindout2129;
  assign bindin2478 = bindout2135;
  assign bindin2481 = bindout2132;
  assign bindin2484 = bindout2144;
  assign bindin2586 = clk;
  assign bindin2587 = reset;
  M_W_Register __module11__(.clk(bindin2586), .reset(bindin2587), .io_in_alu_result(bindin2588), .io_in_mem_result(bindin2591), .io_in_rd(bindin2594), .io_in_wb(bindin2597), .io_in_rs1(bindin2600), .io_in_rs2(bindin2603), .io_in_PC_next(bindin2606), .io_out_alu_result(bindout2609), .io_out_mem_result(bindout2612), .io_out_rd(bindout2615), .io_out_wb(bindout2618), .io_out_rs1(bindout2621), .io_out_rs2(bindout2624), .io_out_PC_next(bindout2627));
  assign bindin2588 = bindout2487;
  assign bindin2591 = bindout2490;
  assign bindin2594 = bindout2493;
  assign bindin2597 = bindout2496;
  assign bindin2600 = bindout2499;
  assign bindin2603 = bindout2502;
  assign bindin2606 = bindout2505;
  Write_Back __module12__(.io_in_alu_result(bindin2661), .io_in_mem_result(bindin2664), .io_in_rd(bindin2667), .io_in_wb(bindin2670), .io_in_rs1(bindin2673), .io_in_rs2(bindin2676), .io_in_PC_next(bindin2679), .io_out_write_data(bindout2682), .io_out_rd(bindout2685), .io_out_wb(bindout2688));
  assign bindin2661 = bindout2609;
  assign bindin2664 = bindout2612;
  assign bindin2667 = bindout2615;
  assign bindin2670 = bindout2618;
  assign bindin2673 = bindout2621;
  assign bindin2676 = bindout2624;
  assign bindin2679 = bindout2627;
  Forwarding __module13__(.io_in_decode_src1(bindin2981), .io_in_decode_src2(bindin2984), .io_in_decode_csr_address(bindin2987), .io_in_execute_dest(bindin2990), .io_in_execute_wb(bindin2993), .io_in_execute_alu_result(bindin2996), .io_in_execute_PC_next(bindin2999), .io_in_execute_is_csr(bindin3002), .io_in_execute_csr_address(bindin3005), .io_in_execute_csr_result(bindin3008), .io_in_memory_dest(bindin3011), .io_in_memory_wb(bindin3014), .io_in_memory_alu_result(bindin3017), .io_in_memory_mem_data(bindin3020), .io_in_memory_PC_next(bindin3023), .io_in_memory_is_csr(bindin3026), .io_in_memory_csr_address(bindin3029), .io_in_memory_csr_result(bindin3032), .io_in_writeback_dest(bindin3035), .io_in_writeback_wb(bindin3038), .io_in_writeback_alu_result(bindin3041), .io_in_writeback_mem_data(bindin3044), .io_in_writeback_PC_next(bindin3047), .io_out_src1_fwd(bindout3050), .io_out_src1_fwd_data(bindout3053), .io_out_src2_fwd(bindout3056), .io_out_src2_fwd_data(bindout3059), .io_out_csr_fwd(bindout3062), .io_out_csr_fwd_data(bindout3065), .io_out_fwd_stall(bindout3068));
  assign bindin2981 = bindout1154;
  assign bindin2984 = bindout1160;
  assign bindin2987 = bindout1136;
  assign bindin2990 = bindout1893;
  assign bindin2993 = bindout1896;
  assign bindin2996 = bindout1890;
  assign bindin2999 = bindout1923;
  assign bindin3002 = bindout1884;
  assign bindin3005 = bindout1881;
  assign bindin3008 = bindout1887;
  assign bindin3011 = bindout2493;
  assign bindin3014 = bindout2496;
  assign bindin3017 = bindout2487;
  assign bindin3020 = bindout2490;
  assign bindin3023 = bindout2505;
  assign bindin3026 = bindout2111;
  assign bindin3029 = bindout2108;
  assign bindin3032 = bindout2114;
  assign bindin3035 = bindout2615;
  assign bindin3038 = bindout2618;
  assign bindin3041 = bindout2609;
  assign bindin3044 = bindout2612;
  assign bindin3047 = bindout2627;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3087), .io_INTERRUPT_in_interrupt_id_valid(bindin3090), .io_INTERRUPT_in_interrupt_id_ready(bindout3093), .io_out_interrupt(bindout3096), .io_out_interrupt_pc(bindout3099));
  assign bindin3087 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3090 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3440 = clk;
  assign bindin3441 = reset;
  JTAG __module15__(.clk(bindin3440), .reset(bindin3441), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3442), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3445), .io_JTAG_JTAG_TAP_in_clock_data(bindin3451), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3454), .io_JTAG_JTAG_TAP_in_reset_data(bindin3460), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3463), .io_JTAG_in_data_data(bindin3469), .io_JTAG_in_data_valid(bindin3472), .io_JTAG_out_data_ready(bindin3484), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3448), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3457), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3466), .io_JTAG_in_data_ready(bindout3475), .io_JTAG_out_data_data(bindout3478), .io_JTAG_out_data_valid(bindout3481));
  assign bindin3442 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3445 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3451 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3454 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3460 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3463 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3469 = io_jtag_in_data_data;
  assign bindin3472 = io_jtag_in_data_valid;
  assign bindin3484 = io_jtag_out_data_ready;
  assign bindin3545 = clk;
  assign bindin3546 = reset;
  CSR_Handler __module17__(.clk(bindin3545), .reset(bindin3546), .io_in_decode_csr_address(bindin3547), .io_in_mem_csr_address(bindin3550), .io_in_mem_is_csr(bindin3553), .io_in_mem_csr_result(bindin3556), .io_out_decode_csr_data(bindout3559));
  assign bindin3547 = bindout1136;
  assign bindin3550 = bindout2108;
  assign bindin3553 = bindout2111;
  assign bindin3556 = bindout2114;
  assign eq3563 = bindout3068 == 1'h1;

  assign io_IBUS_in_data_ready = bindout165;
  assign io_IBUS_out_address_data = bindout168;
  assign io_IBUS_out_address_valid = bindout171;
  assign io_DBUS_in_data_ready = bindout2427;
  assign io_DBUS_out_data_data = bindout2430;
  assign io_DBUS_out_data_valid = bindout2433;
  assign io_DBUS_out_address_data = bindout2439;
  assign io_DBUS_out_address_valid = bindout2442;
  assign io_DBUS_out_control_data = bindout2448;
  assign io_DBUS_out_control_valid = bindout2451;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3093;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3448;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3457;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3466;
  assign io_jtag_in_data_ready = bindout3475;
  assign io_jtag_out_data_data = bindout3478;
  assign io_jtag_out_data_valid = bindout3481;
  assign io_out_fwd_stall = bindout3068;
  assign io_out_branch_stall = bindout1187;
  assign io_actual_change = bindout1148;

endmodule
