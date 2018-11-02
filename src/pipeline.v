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
  assign sel985 = lt823 ? 32'h12345678 : 32'h7b;
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
  wire eq2238, eq2242, orl2252, lt2260;
  wire[1:0] sel2262, sel2270;

  assign eq2238 = io_in_mem_read == 3'h2;
  assign eq2242 = io_in_mem_write == 3'h2;
  assign orl2252 = eq2238 | eq2242;
  assign lt2260 = io_in_mem_write < 3'h7;
  assign sel2262 = lt2260 ? 2'h2 : 2'h0;
  assign sel2270 = eq2238 ? 2'h1 : sel2262;

  assign io_DBUS_in_data_ready = eq2238;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = eq2242;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2252;
  assign io_DBUS_out_control_data = sel2270;
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
  wire[31:0] bindin2277, bindout2286, bindout2295, bindin2313, bindin2322, bindout2325;
  wire bindin2280, bindout2283, bindout2289, bindin2292, bindout2298, bindin2301, bindout2307, bindin2310;
  wire[1:0] bindout2304;
  wire[2:0] bindin2316, bindin2319;

  Cache __module10__(.io_DBUS_in_data_data(bindin2277), .io_DBUS_in_data_valid(bindin2280), .io_DBUS_out_data_ready(bindin2292), .io_DBUS_out_address_ready(bindin2301), .io_DBUS_out_control_ready(bindin2310), .io_in_address(bindin2313), .io_in_mem_read(bindin2316), .io_in_mem_write(bindin2319), .io_in_data(bindin2322), .io_DBUS_in_data_ready(bindout2283), .io_DBUS_out_data_data(bindout2286), .io_DBUS_out_data_valid(bindout2289), .io_DBUS_out_address_data(bindout2295), .io_DBUS_out_address_valid(bindout2298), .io_DBUS_out_control_data(bindout2304), .io_DBUS_out_control_valid(bindout2307), .io_out_data(bindout2325));
  assign bindin2277 = io_DBUS_in_data_data;
  assign bindin2280 = io_DBUS_in_data_valid;
  assign bindin2292 = io_DBUS_out_data_ready;
  assign bindin2301 = io_DBUS_out_address_ready;
  assign bindin2310 = io_DBUS_out_control_ready;
  assign bindin2313 = io_in_alu_result;
  assign bindin2316 = io_in_mem_read;
  assign bindin2319 = io_in_mem_write;
  assign bindin2322 = io_in_rd2;

  assign io_DBUS_in_data_ready = bindout2283;
  assign io_DBUS_out_data_data = bindout2286;
  assign io_DBUS_out_data_valid = bindout2289;
  assign io_DBUS_out_address_data = bindout2295;
  assign io_DBUS_out_address_valid = bindout2298;
  assign io_DBUS_out_control_data = bindout2304;
  assign io_DBUS_out_control_valid = bindout2307;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2325;
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
  reg[31:0] reg2448, reg2457, reg2489;
  reg[4:0] reg2464, reg2470, reg2476;
  reg[1:0] reg2483;

  always @ (posedge clk) begin
    if (reset)
      reg2448 <= 32'h0;
    else
      reg2448 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2457 <= 32'h0;
    else
      reg2457 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2464 <= 5'h0;
    else
      reg2464 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2470 <= 5'h0;
    else
      reg2470 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2476 <= 5'h0;
    else
      reg2476 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2483 <= 2'h0;
    else
      reg2483 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2489 <= 32'h0;
    else
      reg2489 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2448;
  assign io_out_mem_result = reg2457;
  assign io_out_rd = reg2464;
  assign io_out_wb = reg2483;
  assign io_out_rs1 = reg2470;
  assign io_out_rs2 = reg2476;
  assign io_out_PC_next = reg2489;

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
  wire eq2555, eq2560;
  wire[31:0] sel2562, sel2564;

  assign eq2555 = io_in_wb == 2'h3;
  assign eq2560 = io_in_wb == 2'h1;
  assign sel2562 = eq2560 ? io_in_alu_result : io_in_mem_result;
  assign sel2564 = eq2555 ? io_in_PC_next : sel2562;

  assign io_out_write_data = sel2564;
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
  wire eq2644, eq2648, eq2652, eq2657, eq2661, eq2665, eq2670, eq2674, ne2679, ne2684, eq2687, andl2689, andl2691, eq2696, ne2700, eq2707, andl2709, andl2711, andl2713, eq2717, ne2725, eq2732, andl2734, andl2736, andl2738, andl2740, orl2743, orl2745, ne2771, eq2774, andl2776, andl2778, eq2782, eq2793, andl2795, andl2797, andl2799, eq2803, eq2818, andl2820, andl2822, andl2824, andl2826, orl2829, orl2831, eq2851, andl2853, eq2857, eq2860, andl2862, andl2864, orl2867, orl2877, andl2879, sel2881;
  wire[31:0] sel2749, sel2751, sel2753, sel2755, sel2757, sel2759, sel2761, sel2763, sel2838, sel2844, sel2848, sel2870, sel2872;

  assign eq2644 = io_in_execute_wb == 2'h2;
  assign eq2648 = io_in_memory_wb == 2'h2;
  assign eq2652 = io_in_writeback_wb == 2'h2;
  assign eq2657 = io_in_execute_wb == 2'h3;
  assign eq2661 = io_in_memory_wb == 2'h3;
  assign eq2665 = io_in_writeback_wb == 2'h3;
  assign eq2670 = io_in_execute_is_csr == 1'h1;
  assign eq2674 = io_in_memory_is_csr == 1'h1;
  assign ne2679 = io_in_execute_wb != 2'h0;
  assign ne2684 = io_in_decode_src1 != 5'h0;
  assign eq2687 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2689 = eq2687 & ne2684;
  assign andl2691 = andl2689 & ne2679;
  assign eq2696 = andl2691 == 1'h0;
  assign ne2700 = io_in_memory_wb != 2'h0;
  assign eq2707 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2709 = eq2707 & ne2684;
  assign andl2711 = andl2709 & ne2700;
  assign andl2713 = andl2711 & eq2696;
  assign eq2717 = andl2713 == 1'h0;
  assign ne2725 = io_in_writeback_wb != 2'h0;
  assign eq2732 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2734 = eq2732 & ne2684;
  assign andl2736 = andl2734 & ne2725;
  assign andl2738 = andl2736 & eq2696;
  assign andl2740 = andl2738 & eq2717;
  assign orl2743 = andl2691 | andl2713;
  assign orl2745 = orl2743 | andl2740;
  assign sel2749 = eq2652 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2751 = eq2665 ? io_in_writeback_PC_next : sel2749;
  assign sel2753 = andl2740 ? sel2751 : 32'h7b;
  assign sel2755 = eq2648 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2757 = eq2661 ? io_in_memory_PC_next : sel2755;
  assign sel2759 = andl2713 ? sel2757 : sel2753;
  assign sel2761 = eq2657 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2763 = andl2691 ? sel2761 : sel2759;
  assign ne2771 = io_in_decode_src2 != 5'h0;
  assign eq2774 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2776 = eq2774 & ne2771;
  assign andl2778 = andl2776 & ne2679;
  assign eq2782 = andl2778 == 1'h0;
  assign eq2793 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2795 = eq2793 & ne2771;
  assign andl2797 = andl2795 & ne2700;
  assign andl2799 = andl2797 & eq2782;
  assign eq2803 = andl2799 == 1'h0;
  assign eq2818 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2820 = eq2818 & ne2771;
  assign andl2822 = andl2820 & ne2725;
  assign andl2824 = andl2822 & eq2782;
  assign andl2826 = andl2824 & eq2803;
  assign orl2829 = andl2778 | andl2799;
  assign orl2831 = orl2829 | andl2826;
  assign sel2838 = andl2826 ? sel2751 : 32'h7b;
  assign sel2844 = andl2799 ? sel2757 : sel2838;
  assign sel2848 = andl2778 ? sel2761 : sel2844;
  assign eq2851 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2853 = eq2851 & eq2670;
  assign eq2857 = andl2853 == 1'h0;
  assign eq2860 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2862 = eq2860 & eq2674;
  assign andl2864 = andl2862 & eq2857;
  assign orl2867 = andl2853 | andl2864;
  assign sel2870 = andl2864 ? io_in_memory_csr_result : 32'h7b;
  assign sel2872 = andl2853 ? io_in_execute_alu_result : sel2870;
  assign orl2877 = andl2691 | andl2778;
  assign andl2879 = orl2877 & eq2644;
  assign sel2881 = andl2879 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2745;
  assign io_out_src1_fwd_data = sel2763;
  assign io_out_src2_fwd = orl2831;
  assign io_out_src2_fwd_data = sel2848;
  assign io_out_csr_fwd = orl2867;
  assign io_out_csr_fwd_data = sel2872;
  assign io_out_fwd_stall = sel2881;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem2988 [0:1];
  wire[31:0] mrport2990;

  initial begin
    mem2988[0] = 32'hdeadbeef;
    mem2988[1] = 32'hdeadbeef;
  end
  assign mrport2990 = mem2988[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport2990;

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
  reg[3:0] reg3059, sel3149;
  wire eq3067, andl3152, eq3156, andl3160, eq3164, andl3168;
  wire[3:0] sel3073, sel3078, sel3084, sel3090, sel3100, sel3105, sel3109, sel3118, sel3124, sel3134, sel3139, sel3143, sel3150, sel3166, sel3167, sel3169;

  always @ (posedge clk) begin
    if (reset)
      reg3059 <= 4'h0;
    else
      reg3059 <= sel3169;
  end
  assign eq3067 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3073 = eq3067 ? 4'h0 : 4'h1;
  assign sel3078 = eq3067 ? 4'h2 : 4'h1;
  assign sel3084 = eq3067 ? 4'h9 : 4'h3;
  assign sel3090 = eq3067 ? 4'h5 : 4'h4;
  assign sel3100 = eq3067 ? 4'h8 : 4'h6;
  assign sel3105 = eq3067 ? 4'h7 : 4'h6;
  assign sel3109 = eq3067 ? 4'h4 : 4'h8;
  assign sel3118 = eq3067 ? 4'h0 : 4'ha;
  assign sel3124 = eq3067 ? 4'hc : 4'hb;
  assign sel3134 = eq3067 ? 4'hf : 4'hd;
  assign sel3139 = eq3067 ? 4'he : 4'hd;
  assign sel3143 = eq3067 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3059)
      4'h0: sel3149 = sel3073;
      4'h1: sel3149 = sel3078;
      4'h2: sel3149 = sel3084;
      4'h3: sel3149 = sel3090;
      4'h4: sel3149 = sel3090;
      4'h5: sel3149 = sel3100;
      4'h6: sel3149 = sel3105;
      4'h7: sel3149 = sel3109;
      4'h8: sel3149 = sel3078;
      4'h9: sel3149 = sel3118;
      4'ha: sel3149 = sel3124;
      4'hb: sel3149 = sel3124;
      4'hc: sel3149 = sel3134;
      4'hd: sel3149 = sel3139;
      4'he: sel3149 = sel3143;
      4'hf: sel3149 = sel3078;
      default: sel3149 = reg3059;
    endcase
  end
  assign sel3150 = io_JTAG_TAP_in_mode_select_valid ? sel3149 : 4'h0;
  assign andl3152 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3156 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3160 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3164 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3166 = eq3156 ? 4'h0 : reg3059;
  assign sel3167 = andl3168 ? sel3150 : reg3059;
  assign andl3168 = andl3160 & eq3164;
  assign sel3169 = andl3152 ? sel3166 : sel3167;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3059;

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
  wire bindin3175, bindin3177, bindin3178, bindin3181, bindout3184, bindin3187, bindin3190, bindout3193, bindin3196, bindin3199, bindout3202, eq3239, eq3248, eq3253, eq3330, andl3331, sel3333, sel3339;
  wire[3:0] bindout3205;
  reg[31:0] reg3213, reg3220, reg3227, reg3234, sel3332;
  wire[31:0] sel3256, sel3258, shr3265, proxy3270, sel3325, sel3326, sel3327, sel3328, sel3329;
  wire[30:0] proxy3268;
  reg sel3338, sel3344;

  assign bindin3175 = clk;
  assign bindin3177 = reset;
  TAP __module16__(.clk(bindin3175), .reset(bindin3177), .io_JTAG_TAP_in_mode_select_data(bindin3178), .io_JTAG_TAP_in_mode_select_valid(bindin3181), .io_JTAG_TAP_in_clock_data(bindin3187), .io_JTAG_TAP_in_clock_valid(bindin3190), .io_JTAG_TAP_in_reset_data(bindin3196), .io_JTAG_TAP_in_reset_valid(bindin3199), .io_JTAG_TAP_in_mode_select_ready(bindout3184), .io_JTAG_TAP_in_clock_ready(bindout3193), .io_JTAG_TAP_in_reset_ready(bindout3202), .io_out_curr_state(bindout3205));
  assign bindin3178 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3181 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3187 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3190 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3196 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3199 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3213 <= 32'h0;
    else
      reg3213 <= sel3328;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3220 <= 32'h1234;
    else
      reg3220 <= sel3327;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3227 <= 32'h5678;
    else
      reg3227 <= sel3329;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3234 <= 32'h0;
    else
      reg3234 <= sel3332;
  end
  assign eq3239 = reg3213 == 32'h0;
  assign eq3248 = reg3213 == 32'h1;
  assign eq3253 = reg3213 == 32'h2;
  assign sel3256 = eq3253 ? reg3220 : 32'hdeadbeef;
  assign sel3258 = eq3248 ? reg3227 : sel3256;
  assign shr3265 = reg3234 >> 32'h1;
  assign proxy3268 = shr3265[30:0];
  assign proxy3270 = {io_JTAG_in_data_data, proxy3268};
  assign sel3325 = eq3253 ? reg3234 : reg3220;
  assign sel3326 = eq3248 ? reg3220 : sel3325;
  assign sel3327 = (bindout3205 == 4'h8) ? sel3326 : reg3220;
  assign sel3328 = (bindout3205 == 4'hf) ? reg3234 : reg3213;
  assign sel3329 = andl3331 ? reg3234 : reg3227;
  assign eq3330 = bindout3205 == 4'h8;
  assign andl3331 = eq3330 & eq3248;
  always @(*) begin
    case (bindout3205)
      4'h3: sel3332 = sel3258;
      4'h4: sel3332 = proxy3270;
      4'ha: sel3332 = reg3213;
      4'hb: sel3332 = proxy3270;
      default: sel3332 = reg3234;
    endcase
  end
  assign sel3333 = eq3239 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3205)
      4'h3: sel3338 = sel3333;
      4'h4: sel3338 = 1'h1;
      4'h8: sel3338 = sel3333;
      4'ha: sel3338 = sel3333;
      4'hb: sel3338 = 1'h1;
      4'hf: sel3338 = sel3333;
      default: sel3338 = sel3333;
    endcase
  end
  assign sel3339 = eq3239 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3205)
      4'h3: sel3344 = sel3339;
      4'h4: sel3344 = reg3234[0];
      4'h8: sel3344 = sel3339;
      4'ha: sel3344 = sel3339;
      4'hb: sel3344 = reg3234[0];
      4'hf: sel3344 = sel3339;
      default: sel3344 = sel3339;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3184;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3193;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3202;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3344;
  assign io_JTAG_out_data_valid = sel3338;

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
  reg[31:0] mem3400 [0:4095];
  reg[1:0] reg3409, sel3444;
  wire eq3421, eq3425, eq3441;
  reg sel3443;
  reg[31:0] sel3445;
  reg[11:0] sel3446;
  wire[31:0] mrport3448;

  always @ (posedge clk) begin
    if (sel3443) begin
      mem3400[sel3446] <= sel3445;
    end
  end
  assign mrport3448 = mem3400[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (reset)
      reg3409 <= 2'h0;
    else
      reg3409 <= sel3444;
  end
  assign eq3421 = reg3409 == 2'h1;
  assign eq3425 = reg3409 == 2'h0;
  assign eq3441 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3425)
      sel3443 = 1'h1;
    else if (eq3421)
      sel3443 = 1'h1;
    else
      sel3443 = eq3441;
  end
  always @(*) begin
    if (eq3425)
      sel3444 = 2'h1;
    else if (eq3421)
      sel3444 = 2'h3;
    else
      sel3444 = reg3409;
  end
  always @(*) begin
    if (eq3425)
      sel3445 = 32'h0;
    else if (eq3421)
      sel3445 = 32'h0;
    else
      sel3445 = io_in_mem_csr_result;
  end
  always @(*) begin
    if (eq3425)
      sel3446 = 12'hf14;
    else if (eq3421)
      sel3446 = 12'h301;
    else
      sel3446 = io_in_mem_csr_address;
  end

  assign io_out_decode_csr_data = mrport3448;

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
  wire bindin156, bindin158, bindin162, bindout165, bindout171, bindin174, bindin177, bindin183, bindin186, bindin189, bindin195, bindin252, bindin253, bindin260, bindin263, bindin1095, bindin1096, bindin1103, bindin1115, bindin1121, bindin1127, bindout1139, bindout1172, bindout1187, bindout1190, bindin1457, bindin1458, bindin1480, bindin1498, bindin1507, bindout1519, bindout1549, bindin1848, bindin1872, bindout1884, bindout1917, bindin2067, bindin2068, bindin2102, bindout2111, bindin2332, bindout2335, bindout2341, bindin2344, bindout2350, bindin2353, bindout2359, bindin2362, bindin2494, bindin2495, bindin2910, bindin2934, bindout2958, bindout2964, bindout2970, bindout2976, bindin2995, bindin2998, bindout3001, bindout3004, bindin3348, bindin3349, bindin3350, bindin3353, bindout3356, bindin3359, bindin3362, bindout3365, bindin3368, bindin3371, bindout3374, bindin3377, bindin3380, bindout3383, bindout3386, bindout3389, bindin3392, bindin3453, bindin3454, bindin3461, eq3471;
  wire[31:0] bindin159, bindout168, bindin180, bindin192, bindin198, bindout201, bindout204, bindin254, bindin257, bindout266, bindout269, bindin1097, bindin1100, bindin1106, bindin1118, bindin1124, bindin1130, bindin1133, bindout1142, bindout1145, bindout1148, bindout1157, bindout1163, bindout1193, bindout1199, bindin1465, bindin1471, bindin1492, bindin1510, bindin1513, bindout1522, bindout1525, bindout1534, bindout1540, bindout1567, bindin1833, bindin1839, bindin1860, bindin1875, bindin1878, bindout1887, bindout1890, bindout1902, bindout1908, bindout1920, bindout1923, bindin2069, bindin2081, bindin2087, bindin2096, bindin2105, bindout2114, bindout2117, bindout2129, bindout2132, bindout2144, bindin2329, bindout2338, bindout2347, bindin2365, bindin2383, bindin2389, bindin2392, bindout2395, bindout2398, bindout2413, bindin2496, bindin2499, bindin2514, bindout2517, bindout2520, bindout2535, bindin2569, bindin2572, bindin2587, bindout2590, bindin2904, bindin2907, bindin2916, bindin2925, bindin2928, bindin2931, bindin2940, bindin2949, bindin2952, bindin2955, bindout2961, bindout2967, bindout2973, bindout3007, bindin3464, bindout3467;
  wire[4:0] bindin1109, bindout1151, bindout1154, bindout1160, bindin1459, bindin1462, bindin1468, bindout1528, bindout1531, bindout1537, bindin1827, bindin1830, bindin1836, bindout1893, bindout1899, bindout1905, bindin2072, bindin2078, bindin2084, bindout2120, bindout2126, bindout2135, bindin2374, bindin2380, bindin2386, bindout2401, bindout2407, bindout2410, bindin2502, bindin2508, bindin2511, bindout2523, bindout2529, bindout2532, bindin2575, bindin2581, bindin2584, bindout2593, bindin2889, bindin2892, bindin2898, bindin2919, bindin2943;
  wire[1:0] bindin1112, bindout1166, bindin1477, bindout1546, bindin1845, bindout1896, bindin2075, bindout2123, bindout2356, bindin2377, bindout2404, bindin2505, bindout2526, bindin2578, bindout2596, bindin2901, bindin2922, bindin2946;
  wire[11:0] bindout1136, bindout1175, bindin1483, bindin1504, bindout1516, bindout1552, bindin1851, bindin1869, bindout1881, bindin2099, bindout2108, bindin2895, bindin2913, bindin2937, bindin3455, bindin3458;
  wire[3:0] bindout1169, bindin1474, bindout1543, bindin1842;
  wire[2:0] bindout1178, bindout1181, bindout1184, bindin1486, bindin1489, bindin1495, bindout1555, bindout1558, bindout1561, bindin1854, bindin1857, bindin1863, bindout1911, bindout1914, bindin2090, bindin2093, bindout2138, bindout2141, bindin2368, bindin2371;
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
  assign bindin186 = bindout2976;
  assign bindin189 = bindout1190;
  assign bindin192 = bindout1193;
  assign bindin195 = bindout3004;
  assign bindin198 = bindout3007;
  assign bindin252 = clk;
  assign bindin253 = reset;
  F_D_Register __module3__(.clk(bindin252), .reset(bindin253), .io_in_instruction(bindin254), .io_in_PC_next(bindin257), .io_in_branch_stall(bindin260), .io_in_fwd_stall(bindin263), .io_out_instruction(bindout266), .io_out_PC_next(bindout269));
  assign bindin254 = bindout201;
  assign bindin257 = bindout204;
  assign bindin260 = bindout1187;
  assign bindin263 = bindout2976;
  assign bindin1095 = clk;
  assign bindin1096 = reset;
  Decode __module4__(.clk(bindin1095), .reset(bindin1096), .io_in_instruction(bindin1097), .io_in_PC_next(bindin1100), .io_in_stall(bindin1103), .io_in_write_data(bindin1106), .io_in_rd(bindin1109), .io_in_wb(bindin1112), .io_in_src1_fwd(bindin1115), .io_in_src1_fwd_data(bindin1118), .io_in_src2_fwd(bindin1121), .io_in_src2_fwd_data(bindin1124), .io_in_csr_fwd(bindin1127), .io_in_csr_fwd_data(bindin1130), .io_in_csr_data(bindin1133), .io_out_csr_address(bindout1136), .io_out_is_csr(bindout1139), .io_out_csr_data(bindout1142), .io_out_csr_mask(bindout1145), .io_actual_change(bindout1148), .io_out_rd(bindout1151), .io_out_rs1(bindout1154), .io_out_rd1(bindout1157), .io_out_rs2(bindout1160), .io_out_rd2(bindout1163), .io_out_wb(bindout1166), .io_out_alu_op(bindout1169), .io_out_rs2_src(bindout1172), .io_out_itype_immed(bindout1175), .io_out_mem_read(bindout1178), .io_out_mem_write(bindout1181), .io_out_branch_type(bindout1184), .io_out_branch_stall(bindout1187), .io_out_jal(bindout1190), .io_out_jal_dest(bindout1193), .io_out_upper_immed(bindout1196), .io_out_PC_next(bindout1199));
  assign bindin1097 = bindout266;
  assign bindin1100 = bindout269;
  assign bindin1103 = eq3471;
  assign bindin1106 = bindout2590;
  assign bindin1109 = bindout2593;
  assign bindin1112 = bindout2596;
  assign bindin1115 = bindout2958;
  assign bindin1118 = bindout2961;
  assign bindin1121 = bindout2964;
  assign bindin1124 = bindout2967;
  assign bindin1127 = bindout2970;
  assign bindin1130 = bindout2973;
  assign bindin1133 = bindout3467;
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
  assign bindin1498 = bindout2976;
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
  Memory __module9__(.io_DBUS_in_data_data(bindin2329), .io_DBUS_in_data_valid(bindin2332), .io_DBUS_out_data_ready(bindin2344), .io_DBUS_out_address_ready(bindin2353), .io_DBUS_out_control_ready(bindin2362), .io_in_alu_result(bindin2365), .io_in_mem_read(bindin2368), .io_in_mem_write(bindin2371), .io_in_rd(bindin2374), .io_in_wb(bindin2377), .io_in_rs1(bindin2380), .io_in_rd1(bindin2383), .io_in_rs2(bindin2386), .io_in_rd2(bindin2389), .io_in_PC_next(bindin2392), .io_DBUS_in_data_ready(bindout2335), .io_DBUS_out_data_data(bindout2338), .io_DBUS_out_data_valid(bindout2341), .io_DBUS_out_address_data(bindout2347), .io_DBUS_out_address_valid(bindout2350), .io_DBUS_out_control_data(bindout2356), .io_DBUS_out_control_valid(bindout2359), .io_out_alu_result(bindout2395), .io_out_mem_result(bindout2398), .io_out_rd(bindout2401), .io_out_wb(bindout2404), .io_out_rs1(bindout2407), .io_out_rs2(bindout2410), .io_out_PC_next(bindout2413));
  assign bindin2329 = io_DBUS_in_data_data;
  assign bindin2332 = io_DBUS_in_data_valid;
  assign bindin2344 = io_DBUS_out_data_ready;
  assign bindin2353 = io_DBUS_out_address_ready;
  assign bindin2362 = io_DBUS_out_control_ready;
  assign bindin2365 = bindout2117;
  assign bindin2368 = bindout2138;
  assign bindin2371 = bindout2141;
  assign bindin2374 = bindout2120;
  assign bindin2377 = bindout2123;
  assign bindin2380 = bindout2126;
  assign bindin2383 = bindout2129;
  assign bindin2386 = bindout2135;
  assign bindin2389 = bindout2132;
  assign bindin2392 = bindout2144;
  assign bindin2494 = clk;
  assign bindin2495 = reset;
  M_W_Register __module11__(.clk(bindin2494), .reset(bindin2495), .io_in_alu_result(bindin2496), .io_in_mem_result(bindin2499), .io_in_rd(bindin2502), .io_in_wb(bindin2505), .io_in_rs1(bindin2508), .io_in_rs2(bindin2511), .io_in_PC_next(bindin2514), .io_out_alu_result(bindout2517), .io_out_mem_result(bindout2520), .io_out_rd(bindout2523), .io_out_wb(bindout2526), .io_out_rs1(bindout2529), .io_out_rs2(bindout2532), .io_out_PC_next(bindout2535));
  assign bindin2496 = bindout2395;
  assign bindin2499 = bindout2398;
  assign bindin2502 = bindout2401;
  assign bindin2505 = bindout2404;
  assign bindin2508 = bindout2407;
  assign bindin2511 = bindout2410;
  assign bindin2514 = bindout2413;
  Write_Back __module12__(.io_in_alu_result(bindin2569), .io_in_mem_result(bindin2572), .io_in_rd(bindin2575), .io_in_wb(bindin2578), .io_in_rs1(bindin2581), .io_in_rs2(bindin2584), .io_in_PC_next(bindin2587), .io_out_write_data(bindout2590), .io_out_rd(bindout2593), .io_out_wb(bindout2596));
  assign bindin2569 = bindout2517;
  assign bindin2572 = bindout2520;
  assign bindin2575 = bindout2523;
  assign bindin2578 = bindout2526;
  assign bindin2581 = bindout2529;
  assign bindin2584 = bindout2532;
  assign bindin2587 = bindout2535;
  Forwarding __module13__(.io_in_decode_src1(bindin2889), .io_in_decode_src2(bindin2892), .io_in_decode_csr_address(bindin2895), .io_in_execute_dest(bindin2898), .io_in_execute_wb(bindin2901), .io_in_execute_alu_result(bindin2904), .io_in_execute_PC_next(bindin2907), .io_in_execute_is_csr(bindin2910), .io_in_execute_csr_address(bindin2913), .io_in_execute_csr_result(bindin2916), .io_in_memory_dest(bindin2919), .io_in_memory_wb(bindin2922), .io_in_memory_alu_result(bindin2925), .io_in_memory_mem_data(bindin2928), .io_in_memory_PC_next(bindin2931), .io_in_memory_is_csr(bindin2934), .io_in_memory_csr_address(bindin2937), .io_in_memory_csr_result(bindin2940), .io_in_writeback_dest(bindin2943), .io_in_writeback_wb(bindin2946), .io_in_writeback_alu_result(bindin2949), .io_in_writeback_mem_data(bindin2952), .io_in_writeback_PC_next(bindin2955), .io_out_src1_fwd(bindout2958), .io_out_src1_fwd_data(bindout2961), .io_out_src2_fwd(bindout2964), .io_out_src2_fwd_data(bindout2967), .io_out_csr_fwd(bindout2970), .io_out_csr_fwd_data(bindout2973), .io_out_fwd_stall(bindout2976));
  assign bindin2889 = bindout1154;
  assign bindin2892 = bindout1160;
  assign bindin2895 = bindout1136;
  assign bindin2898 = bindout1893;
  assign bindin2901 = bindout1896;
  assign bindin2904 = bindout1890;
  assign bindin2907 = bindout1923;
  assign bindin2910 = bindout1884;
  assign bindin2913 = bindout1881;
  assign bindin2916 = bindout1887;
  assign bindin2919 = bindout2401;
  assign bindin2922 = bindout2404;
  assign bindin2925 = bindout2395;
  assign bindin2928 = bindout2398;
  assign bindin2931 = bindout2413;
  assign bindin2934 = bindout2111;
  assign bindin2937 = bindout2108;
  assign bindin2940 = bindout2114;
  assign bindin2943 = bindout2523;
  assign bindin2946 = bindout2526;
  assign bindin2949 = bindout2517;
  assign bindin2952 = bindout2520;
  assign bindin2955 = bindout2535;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin2995), .io_INTERRUPT_in_interrupt_id_valid(bindin2998), .io_INTERRUPT_in_interrupt_id_ready(bindout3001), .io_out_interrupt(bindout3004), .io_out_interrupt_pc(bindout3007));
  assign bindin2995 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin2998 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3348 = clk;
  assign bindin3349 = reset;
  JTAG __module15__(.clk(bindin3348), .reset(bindin3349), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3350), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3353), .io_JTAG_JTAG_TAP_in_clock_data(bindin3359), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3362), .io_JTAG_JTAG_TAP_in_reset_data(bindin3368), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3371), .io_JTAG_in_data_data(bindin3377), .io_JTAG_in_data_valid(bindin3380), .io_JTAG_out_data_ready(bindin3392), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3356), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3365), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3374), .io_JTAG_in_data_ready(bindout3383), .io_JTAG_out_data_data(bindout3386), .io_JTAG_out_data_valid(bindout3389));
  assign bindin3350 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3353 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3359 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3362 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3368 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3371 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3377 = io_jtag_in_data_data;
  assign bindin3380 = io_jtag_in_data_valid;
  assign bindin3392 = io_jtag_out_data_ready;
  assign bindin3453 = clk;
  assign bindin3454 = reset;
  CSR_Handler __module17__(.clk(bindin3453), .reset(bindin3454), .io_in_decode_csr_address(bindin3455), .io_in_mem_csr_address(bindin3458), .io_in_mem_is_csr(bindin3461), .io_in_mem_csr_result(bindin3464), .io_out_decode_csr_data(bindout3467));
  assign bindin3455 = bindout1136;
  assign bindin3458 = bindout2108;
  assign bindin3461 = bindout2111;
  assign bindin3464 = bindout2114;
  assign eq3471 = bindout2976 == 1'h1;

  assign io_IBUS_in_data_ready = bindout165;
  assign io_IBUS_out_address_data = bindout168;
  assign io_IBUS_out_address_valid = bindout171;
  assign io_DBUS_in_data_ready = bindout2335;
  assign io_DBUS_out_data_data = bindout2338;
  assign io_DBUS_out_data_valid = bindout2341;
  assign io_DBUS_out_address_data = bindout2347;
  assign io_DBUS_out_address_valid = bindout2350;
  assign io_DBUS_out_control_data = bindout2356;
  assign io_DBUS_out_control_valid = bindout2359;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3001;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3356;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3365;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3374;
  assign io_jtag_in_data_ready = bindout3383;
  assign io_jtag_out_data_data = bindout3386;
  assign io_jtag_out_data_valid = bindout3389;
  assign io_out_fwd_stall = bindout2976;
  assign io_out_branch_stall = bindout1187;
  assign io_actual_change = bindout1148;

endmodule
