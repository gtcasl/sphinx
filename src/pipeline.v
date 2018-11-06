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
  wire bindin443, bindin445, bindin446, ne506, sel508, eq512, eq566, eq572, eq579, eq584, eq589, orl591, eq596, eq601, eq606, eq611, eq616, eq621, ne626, eq631, andl633, proxy636, eq637, andl640, eq644, andl650, eq658, orl666, orl668, orl670, orl672, andl674, andl681, orl688, orl690, andl692, orl699, sel701, andl712, eq729, eq734, orl736, proxy787, proxy788, lt821, proxy893, eq923, proxy956, eq957, sel974, sel975, sel977, sel978, sel980, sel981, eq1005, eq1042, eq1050, eq1058, orl1064, lt1082;
  wire[4:0] bindin449, bindin455, bindin458, sel528, proxy536, proxy543;
  wire[31:0] bindin452, bindout461, bindout464, shr524, shr533, shr540, shr547, shr554, sel568, sel574, pad652, sel654, sel660, shr792, shr897, proxy913, proxy919, sel925, sub929, add931, proxy946, proxy952, sel959, add961, sel983, sel984;
  wire[6:0] sel517, proxy557;
  wire[2:0] proxy550, sel708, sel714, sel987, sel988;
  wire[1:0] sel676, sel683, sel694, proxy1037;
  wire[11:0] proxy740, sel748, proxy766, proxy803, proxy941, sel971, sel972, sel993, sel994;
  wire[3:0] proxy795, sel1007, sel1010, sel1027, sel1044, sel1052, sel1060, sel1066, sel1068, sel1072, sel1076, sel1084, sel1086;
  wire[5:0] proxy801;
  wire[19:0] proxy864, sel990, sel991;
  wire[7:0] proxy892;
  wire[9:0] proxy900;
  wire[20:0] proxy904;
  reg[11:0] sel973, sel995;
  reg sel976, sel979, sel982;
  reg[31:0] sel985;
  reg[2:0] sel986, sel989;
  reg[19:0] sel992;
  reg[3:0] sel1035;

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
  assign proxy787 = io_in_instruction[31];
  assign proxy788 = io_in_instruction[7];
  assign shr792 = io_in_instruction >> 32'h8;
  assign proxy795 = shr792[3:0];
  assign proxy801 = shr554[5:0];
  assign proxy803 = {proxy787, proxy788, proxy801, proxy795};
  assign lt821 = shr540[11:0] < 12'h2;
  assign proxy864 = {proxy557, proxy543, proxy536, proxy550};
  assign proxy892 = shr547[7:0];
  assign proxy893 = io_in_instruction[20];
  assign shr897 = io_in_instruction >> 32'h15;
  assign proxy900 = shr897[9:0];
  assign proxy904 = {proxy787, proxy892, proxy893, proxy900, 1'h0};
  assign proxy913 = {11'h0, proxy904};
  assign proxy919 = {11'h7ff, proxy904};
  assign eq923 = proxy787 == 1'h1;
  assign sel925 = eq923 ? proxy919 : proxy913;
  assign sub929 = $signed(io_in_PC_next) - $signed(32'h4);
  assign add931 = $signed(sub929) + $signed(sel925);
  assign proxy941 = {proxy557, proxy543};
  assign proxy946 = {20'h0, proxy941};
  assign proxy952 = {20'hfffff, proxy941};
  assign proxy956 = proxy941[11];
  assign eq957 = proxy956 == 1'h1;
  assign sel959 = eq957 ? proxy952 : proxy946;
  assign add961 = $signed(sel568) + $signed(sel959);
  assign sel971 = lt821 ? 12'h7b : 12'h7b;
  assign sel972 = (proxy550 == 3'h0) ? sel971 : 12'h7b;
  always @(*) begin
    case (sel517)
      7'h13: sel973 = sel748;
      7'h33: sel973 = 12'h7b;
      7'h23: sel973 = proxy766;
      7'h03: sel973 = shr540[11:0];
      7'h63: sel973 = proxy803;
      7'h73: sel973 = sel972;
      7'h37: sel973 = 12'h7b;
      7'h17: sel973 = 12'h7b;
      7'h6f: sel973 = 12'h7b;
      7'h67: sel973 = 12'h7b;
      default: sel973 = 12'h7b;
    endcase
  end
  assign sel974 = lt821 ? 1'h0 : 1'h1;
  assign sel975 = (proxy550 == 3'h0) ? sel974 : 1'h1;
  always @(*) begin
    case (sel517)
      7'h13: sel976 = 1'h0;
      7'h33: sel976 = 1'h0;
      7'h23: sel976 = 1'h0;
      7'h03: sel976 = 1'h0;
      7'h63: sel976 = 1'h0;
      7'h73: sel976 = sel975;
      7'h37: sel976 = 1'h0;
      7'h17: sel976 = 1'h0;
      7'h6f: sel976 = 1'h0;
      7'h67: sel976 = 1'h0;
      default: sel976 = 1'h0;
    endcase
  end
  assign sel977 = lt821 ? 1'h0 : 1'h0;
  assign sel978 = (proxy550 == 3'h0) ? sel977 : 1'h0;
  always @(*) begin
    case (sel517)
      7'h13: sel979 = 1'h0;
      7'h33: sel979 = 1'h0;
      7'h23: sel979 = 1'h0;
      7'h03: sel979 = 1'h0;
      7'h63: sel979 = 1'h1;
      7'h73: sel979 = sel978;
      7'h37: sel979 = 1'h0;
      7'h17: sel979 = 1'h0;
      7'h6f: sel979 = 1'h0;
      7'h67: sel979 = 1'h0;
      default: sel979 = 1'h0;
    endcase
  end
  assign sel980 = lt821 ? 1'h1 : 1'h0;
  assign sel981 = (proxy550 == 3'h0) ? sel980 : 1'h0;
  always @(*) begin
    case (sel517)
      7'h13: sel982 = 1'h0;
      7'h33: sel982 = 1'h0;
      7'h23: sel982 = 1'h0;
      7'h03: sel982 = 1'h0;
      7'h63: sel982 = 1'h0;
      7'h73: sel982 = sel981;
      7'h37: sel982 = 1'h0;
      7'h17: sel982 = 1'h0;
      7'h6f: sel982 = 1'h1;
      7'h67: sel982 = 1'h1;
      default: sel982 = 1'h0;
    endcase
  end
  assign sel983 = lt821 ? 32'hb0000000 : 32'h7b;
  assign sel984 = (proxy550 == 3'h0) ? sel983 : 32'h7b;
  always @(*) begin
    case (sel517)
      7'h13: sel985 = 32'h7b;
      7'h33: sel985 = 32'h7b;
      7'h23: sel985 = 32'h7b;
      7'h03: sel985 = 32'h7b;
      7'h63: sel985 = 32'h7b;
      7'h73: sel985 = sel984;
      7'h37: sel985 = 32'h7b;
      7'h17: sel985 = 32'h7b;
      7'h6f: sel985 = add931;
      7'h67: sel985 = add961;
      default: sel985 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy550)
      3'h0: sel986 = 3'h1;
      3'h1: sel986 = 3'h2;
      3'h4: sel986 = 3'h3;
      3'h5: sel986 = 3'h4;
      3'h6: sel986 = 3'h5;
      3'h7: sel986 = 3'h6;
      default: sel986 = 3'h0;
    endcase
  end
  assign sel987 = lt821 ? 3'h0 : 3'h0;
  assign sel988 = (proxy550 == 3'h0) ? sel987 : 3'h0;
  always @(*) begin
    case (sel517)
      7'h13: sel989 = 3'h0;
      7'h33: sel989 = 3'h0;
      7'h23: sel989 = 3'h0;
      7'h03: sel989 = 3'h0;
      7'h63: sel989 = sel986;
      7'h73: sel989 = sel988;
      7'h37: sel989 = 3'h0;
      7'h17: sel989 = 3'h0;
      7'h6f: sel989 = 3'h0;
      7'h67: sel989 = 3'h0;
      default: sel989 = 3'h0;
    endcase
  end
  assign sel990 = lt821 ? 20'h7b : 20'h7b;
  assign sel991 = (proxy550 == 3'h0) ? sel990 : 20'h7b;
  always @(*) begin
    case (sel517)
      7'h13: sel992 = 20'h7b;
      7'h33: sel992 = 20'h7b;
      7'h23: sel992 = 20'h7b;
      7'h03: sel992 = 20'h7b;
      7'h63: sel992 = 20'h7b;
      7'h73: sel992 = sel991;
      7'h37: sel992 = proxy864;
      7'h17: sel992 = proxy864;
      7'h6f: sel992 = 20'h7b;
      7'h67: sel992 = 20'h7b;
      default: sel992 = 20'h7b;
    endcase
  end
  assign sel993 = lt821 ? 12'h7b : shr540[11:0];
  assign sel994 = (proxy550 == 3'h0) ? sel993 : shr540[11:0];
  always @(*) begin
    case (sel517)
      7'h13: sel995 = 12'h7b;
      7'h33: sel995 = 12'h7b;
      7'h23: sel995 = 12'h7b;
      7'h03: sel995 = 12'h7b;
      7'h63: sel995 = 12'h7b;
      7'h73: sel995 = sel994;
      7'h37: sel995 = 12'h7b;
      7'h17: sel995 = 12'h7b;
      7'h6f: sel995 = 12'h7b;
      7'h67: sel995 = 12'h7b;
      default: sel995 = 12'h7b;
    endcase
  end
  assign eq1005 = proxy557 == 7'h0;
  assign sel1007 = eq1005 ? 4'h0 : 4'h1;
  assign sel1010 = eq589 ? 4'h0 : sel1007;
  assign sel1027 = eq1005 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy550)
      3'h0: sel1035 = sel1010;
      3'h1: sel1035 = 4'h2;
      3'h2: sel1035 = 4'h3;
      3'h3: sel1035 = 4'h4;
      3'h4: sel1035 = 4'h5;
      3'h5: sel1035 = sel1027;
      3'h6: sel1035 = 4'h8;
      3'h7: sel1035 = 4'h9;
      default: sel1035 = 4'hf;
    endcase
  end
  assign proxy1037 = proxy550[1:0];
  assign eq1042 = proxy1037 == 2'h3;
  assign sel1044 = eq1042 ? 4'hf : 4'hf;
  assign eq1050 = proxy1037 == 2'h2;
  assign sel1052 = eq1050 ? 4'he : sel1044;
  assign eq1058 = proxy1037 == 2'h1;
  assign sel1060 = eq1058 ? 4'hd : sel1052;
  assign orl1064 = eq596 | eq584;
  assign sel1066 = orl1064 ? 4'h0 : sel1035;
  assign sel1068 = andl633 ? sel1060 : sel1066;
  assign sel1072 = eq621 ? 4'hc : sel1068;
  assign sel1076 = eq616 ? 4'hb : sel1072;
  assign lt1082 = sel989 < 3'h5;
  assign sel1084 = lt1082 ? 4'h1 : 4'ha;
  assign sel1086 = eq601 ? sel1084 : sel1076;

  assign io_out_csr_address = sel995;
  assign io_out_is_csr = sel976;
  assign io_out_csr_data = sel660;
  assign io_out_csr_mask = sel654;
  assign io_actual_change = 32'h1;
  assign io_out_rd = sel528;
  assign io_out_rs1 = proxy536;
  assign io_out_rd1 = sel568;
  assign io_out_rs2 = proxy543;
  assign io_out_rd2 = sel574;
  assign io_out_wb = sel694;
  assign io_out_alu_op = sel1086;
  assign io_out_rs2_src = sel701;
  assign io_out_itype_immed = sel973;
  assign io_out_mem_read = sel708;
  assign io_out_mem_write = sel714;
  assign io_out_branch_type = sel989;
  assign io_out_branch_stall = sel979;
  assign io_out_jal = sel982;
  assign io_out_jal_dest = sel985;
  assign io_out_upper_immed = sel992;
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
  reg[4:0] reg1277, reg1286, reg1299;
  reg[31:0] reg1293, reg1305, reg1325, reg1383, reg1389;
  reg[3:0] reg1312;
  reg[1:0] reg1319;
  reg reg1332, reg1377;
  reg[11:0] reg1339, reg1371;
  reg[2:0] reg1346, reg1352, reg1358;
  reg[19:0] reg1365;
  wire eq1393, sel1421, sel1444;
  wire[4:0] sel1396, sel1399, sel1405;
  wire[31:0] sel1402, sel1408, sel1418, sel1447, sel1450;
  wire[3:0] sel1412;
  wire[1:0] sel1415;
  wire[11:0] sel1425, sel1441;
  wire[2:0] sel1429, sel1432, sel1435;
  wire[19:0] sel1438;

  always @ (posedge clk) begin
    if (reset)
      reg1277 <= 5'h0;
    else
      reg1277 <= sel1396;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1286 <= 5'h0;
    else
      reg1286 <= sel1399;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1293 <= 32'h0;
    else
      reg1293 <= sel1402;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1299 <= 5'h0;
    else
      reg1299 <= sel1405;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1305 <= 32'h0;
    else
      reg1305 <= sel1408;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1312 <= 4'h0;
    else
      reg1312 <= sel1412;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1319 <= 2'h0;
    else
      reg1319 <= sel1415;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1325 <= 32'h0;
    else
      reg1325 <= sel1418;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1332 <= 1'h0;
    else
      reg1332 <= sel1421;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1339 <= 12'h0;
    else
      reg1339 <= sel1425;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1346 <= 3'h0;
    else
      reg1346 <= sel1429;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1352 <= 3'h0;
    else
      reg1352 <= sel1432;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1358 <= 3'h0;
    else
      reg1358 <= sel1435;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1365 <= 20'h0;
    else
      reg1365 <= sel1438;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1371 <= 12'h0;
    else
      reg1371 <= sel1441;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1377 <= 1'h0;
    else
      reg1377 <= sel1444;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1383 <= 32'h0;
    else
      reg1383 <= sel1447;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1389 <= 32'h0;
    else
      reg1389 <= sel1450;
  end
  assign eq1393 = io_in_fwd_stall == 1'h1;
  assign sel1396 = eq1393 ? 5'h0 : io_in_rd;
  assign sel1399 = eq1393 ? 5'h0 : io_in_rs1;
  assign sel1402 = eq1393 ? 32'h0 : io_in_rd1;
  assign sel1405 = eq1393 ? 5'h0 : io_in_rs2;
  assign sel1408 = eq1393 ? 32'h0 : io_in_rd2;
  assign sel1412 = eq1393 ? 4'hf : io_in_alu_op;
  assign sel1415 = eq1393 ? 2'h0 : io_in_wb;
  assign sel1418 = eq1393 ? 32'h0 : io_in_PC_next;
  assign sel1421 = eq1393 ? 1'h0 : io_in_rs2_src;
  assign sel1425 = eq1393 ? 12'h7b : io_in_itype_immed;
  assign sel1429 = eq1393 ? 3'h7 : io_in_mem_read;
  assign sel1432 = eq1393 ? 3'h7 : io_in_mem_write;
  assign sel1435 = eq1393 ? 3'h0 : io_in_branch_type;
  assign sel1438 = eq1393 ? 20'h0 : io_in_upper_immed;
  assign sel1441 = eq1393 ? 12'h0 : io_in_csr_address;
  assign sel1444 = eq1393 ? 1'h0 : io_in_is_csr;
  assign sel1447 = eq1393 ? 32'h0 : io_in_csr_data;
  assign sel1450 = eq1393 ? 32'h0 : io_in_csr_mask;

  assign io_out_csr_address = reg1371;
  assign io_out_is_csr = reg1377;
  assign io_out_csr_data = reg1383;
  assign io_out_csr_mask = reg1389;
  assign io_out_rd = reg1277;
  assign io_out_rs1 = reg1286;
  assign io_out_rd1 = reg1293;
  assign io_out_rs2 = reg1299;
  assign io_out_rd2 = reg1305;
  assign io_out_alu_op = reg1312;
  assign io_out_wb = reg1319;
  assign io_out_rs2_src = reg1332;
  assign io_out_itype_immed = reg1339;
  assign io_out_mem_read = reg1346;
  assign io_out_mem_write = reg1352;
  assign io_out_branch_type = reg1358;
  assign io_out_upper_immed = reg1365;
  assign io_out_PC_next = reg1325;

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
  wire[31:0] proxy1632, proxy1638, sel1646, sel1653, proxy1658, shl1663, sub1667, add1669, add1678, sub1683, shl1687, sel1696, sel1705, xorl1710, shr1714, shr1719, orl1724, andl1729, add1745, orl1751, sub1755, andl1758, sel1763;
  wire eq1644, eq1651, lt1694, lt1703, ge1733, eq1770, sel1772, sel1780, eq1787, sel1789, sel1798;
  reg[31:0] sel1762, sel1764;
  reg sel1821;

  assign proxy1632 = {20'h0, io_in_itype_immed};
  assign proxy1638 = {20'hfffff, io_in_itype_immed};
  assign eq1644 = io_in_itype_immed[11] == 1'h1;
  assign sel1646 = eq1644 ? proxy1638 : proxy1632;
  assign eq1651 = io_in_rs2_src == 1'h1;
  assign sel1653 = eq1651 ? sel1646 : io_in_rd2;
  assign proxy1658 = {io_in_upper_immed, 12'h0};
  assign shl1663 = $signed(sel1646) << 32'h1;
  assign sub1667 = $signed(io_in_PC_next) - $signed(32'h4);
  assign add1669 = $signed(sub1667) + $signed(shl1663);
  assign add1678 = $signed(io_in_rd1) + $signed(sel1653);
  assign sub1683 = $signed(io_in_rd1) - $signed(sel1653);
  assign shl1687 = io_in_rd1 << sel1653;
  assign lt1694 = $signed(io_in_rd1) < $signed(sel1653);
  assign sel1696 = lt1694 ? 32'h1 : 32'h0;
  assign lt1703 = io_in_rd1 < sel1653;
  assign sel1705 = lt1703 ? 32'h1 : 32'h0;
  assign xorl1710 = io_in_rd1 ^ sel1653;
  assign shr1714 = io_in_rd1 >> sel1653;
  assign shr1719 = $signed(io_in_rd1) >> sel1653;
  assign orl1724 = io_in_rd1 | sel1653;
  assign andl1729 = sel1653 & io_in_rd1;
  assign ge1733 = io_in_rd1 >= sel1653;
  assign add1745 = $signed(sub1667) + $signed(proxy1658);
  assign orl1751 = io_in_csr_data | io_in_csr_mask;
  assign sub1755 = 32'hffffffff - io_in_csr_mask;
  assign andl1758 = io_in_csr_data & sub1755;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1762 = 32'h7b;
      4'h1: sel1762 = 32'h7b;
      4'h2: sel1762 = 32'h7b;
      4'h3: sel1762 = 32'h7b;
      4'h4: sel1762 = 32'h7b;
      4'h5: sel1762 = 32'h7b;
      4'h6: sel1762 = 32'h7b;
      4'h7: sel1762 = 32'h7b;
      4'h8: sel1762 = 32'h7b;
      4'h9: sel1762 = 32'h7b;
      4'ha: sel1762 = 32'h7b;
      4'hb: sel1762 = 32'h7b;
      4'hc: sel1762 = 32'h7b;
      4'hd: sel1762 = io_in_csr_mask;
      4'he: sel1762 = orl1751;
      4'hf: sel1762 = andl1758;
      default: sel1762 = 32'h7b;
    endcase
  end
  assign sel1763 = ge1733 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1764 = add1678;
      4'h1: sel1764 = sub1683;
      4'h2: sel1764 = shl1687;
      4'h3: sel1764 = sel1696;
      4'h4: sel1764 = sel1705;
      4'h5: sel1764 = xorl1710;
      4'h6: sel1764 = shr1714;
      4'h7: sel1764 = shr1719;
      4'h8: sel1764 = orl1724;
      4'h9: sel1764 = andl1729;
      4'ha: sel1764 = sel1763;
      4'hb: sel1764 = proxy1658;
      4'hc: sel1764 = add1745;
      4'hd: sel1764 = io_in_csr_data;
      4'he: sel1764 = io_in_csr_data;
      4'hf: sel1764 = io_in_csr_data;
      default: sel1764 = 32'h0;
    endcase
  end
  assign eq1770 = sel1764 == 32'h0;
  assign sel1772 = eq1770 ? 1'h1 : 1'h0;
  assign sel1780 = eq1770 ? 1'h0 : 1'h1;
  assign eq1787 = sel1764[31] == 1'h0;
  assign sel1789 = eq1787 ? 1'h0 : 1'h1;
  assign sel1798 = eq1787 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel1821 = sel1772;
      3'h2: sel1821 = sel1780;
      3'h3: sel1821 = sel1789;
      3'h4: sel1821 = sel1798;
      3'h5: sel1821 = sel1789;
      3'h6: sel1821 = sel1798;
      3'h0: sel1821 = 1'h0;
      default: sel1821 = 1'h0;
    endcase
  end

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1762;
  assign io_out_alu_result = sel1764;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_branch_dir = sel1821;
  assign io_out_branch_dest = add1669;
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
  reg[31:0] reg1980, reg2002, reg2014, reg2027, reg2060;
  reg[4:0] reg1990, reg1996, reg2008;
  reg[1:0] reg2021;
  reg[2:0] reg2034, reg2040;
  reg[11:0] reg2047;
  reg reg2054;

  always @ (posedge clk) begin
    if (reset)
      reg1980 <= 32'h0;
    else
      reg1980 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1990 <= 5'h0;
    else
      reg1990 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1996 <= 5'h0;
    else
      reg1996 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2002 <= 32'h0;
    else
      reg2002 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2008 <= 5'h0;
    else
      reg2008 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2014 <= 32'h0;
    else
      reg2014 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2021 <= 2'h0;
    else
      reg2021 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2027 <= 32'h0;
    else
      reg2027 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2034 <= 3'h0;
    else
      reg2034 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2040 <= 3'h0;
    else
      reg2040 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2047 <= 12'h0;
    else
      reg2047 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2054 <= 1'h0;
    else
      reg2054 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2060 <= 32'h0;
    else
      reg2060 <= io_in_csr_result;
  end

  assign io_out_csr_address = reg2047;
  assign io_out_is_csr = reg2054;
  assign io_out_csr_result = reg2060;
  assign io_out_alu_result = reg1980;
  assign io_out_rd = reg1990;
  assign io_out_wb = reg2021;
  assign io_out_rs1 = reg1996;
  assign io_out_rd1 = reg2002;
  assign io_out_rd2 = reg2014;
  assign io_out_rs2 = reg2008;
  assign io_out_mem_read = reg2034;
  assign io_out_mem_write = reg2040;
  assign io_out_PC_next = reg2027;

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
  wire lt2235, lt2238, orl2240, eq2248, eq2262, eq2266, andl2268, eq2289, eq2293, andl2295, orl2298, proxy2317, eq2318, proxy2337, eq2338;
  wire[1:0] sel2274, sel2278, sel2282;
  wire[7:0] proxy2307;
  wire[31:0] proxy2309, proxy2313, sel2320, proxy2329, proxy2333, sel2340;
  wire[15:0] proxy2327;
  reg[31:0] sel2360;

  assign lt2235 = io_in_mem_write < 3'h7;
  assign lt2238 = io_in_mem_read < 3'h7;
  assign orl2240 = lt2238 | lt2235;
  assign eq2248 = io_in_mem_write == 3'h2;
  assign eq2262 = io_in_mem_write == 3'h7;
  assign eq2266 = io_in_mem_read == 3'h7;
  assign andl2268 = eq2266 & eq2262;
  assign sel2274 = andl2268 ? 2'h0 : 2'h3;
  assign sel2278 = eq2248 ? 2'h2 : sel2274;
  assign sel2282 = lt2238 ? 2'h1 : sel2278;
  assign eq2289 = eq2248 == 1'h0;
  assign eq2293 = andl2268 == 1'h0;
  assign andl2295 = eq2293 & eq2289;
  assign orl2298 = lt2238 | andl2295;
  assign proxy2307 = io_DBUS_in_data_data[7:0];
  assign proxy2309 = {24'h0, proxy2307};
  assign proxy2313 = {24'hffffff, proxy2307};
  assign proxy2317 = proxy2307[7];
  assign eq2318 = proxy2317 == 1'h1;
  assign sel2320 = eq2318 ? proxy2313 : proxy2309;
  assign proxy2327 = io_DBUS_in_data_data[15:0];
  assign proxy2329 = {16'h0, proxy2327};
  assign proxy2333 = {16'hffff, proxy2327};
  assign proxy2337 = proxy2327[15];
  assign eq2338 = proxy2337 == 1'h1;
  assign sel2340 = eq2338 ? proxy2333 : proxy2329;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2360 = sel2320;
      3'h1: sel2360 = sel2340;
      3'h2: sel2360 = io_DBUS_in_data_data;
      3'h4: sel2360 = proxy2309;
      3'h5: sel2360 = proxy2329;
      default: sel2360 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2298;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2235;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2240;
  assign io_DBUS_out_control_data = sel2282;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2360;

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
  wire[31:0] bindin2367, bindout2376, bindout2385, bindin2403, bindin2412, bindout2415;
  wire bindin2370, bindout2373, bindout2379, bindin2382, bindout2388, bindin2391, bindout2397, bindin2400;
  wire[1:0] bindout2394;
  wire[2:0] bindin2406, bindin2409;

  Cache __module10__(.io_DBUS_in_data_data(bindin2367), .io_DBUS_in_data_valid(bindin2370), .io_DBUS_out_data_ready(bindin2382), .io_DBUS_out_address_ready(bindin2391), .io_DBUS_out_control_ready(bindin2400), .io_in_address(bindin2403), .io_in_mem_read(bindin2406), .io_in_mem_write(bindin2409), .io_in_data(bindin2412), .io_DBUS_in_data_ready(bindout2373), .io_DBUS_out_data_data(bindout2376), .io_DBUS_out_data_valid(bindout2379), .io_DBUS_out_address_data(bindout2385), .io_DBUS_out_address_valid(bindout2388), .io_DBUS_out_control_data(bindout2394), .io_DBUS_out_control_valid(bindout2397), .io_out_data(bindout2415));
  assign bindin2367 = io_DBUS_in_data_data;
  assign bindin2370 = io_DBUS_in_data_valid;
  assign bindin2382 = io_DBUS_out_data_ready;
  assign bindin2391 = io_DBUS_out_address_ready;
  assign bindin2400 = io_DBUS_out_control_ready;
  assign bindin2403 = io_in_alu_result;
  assign bindin2406 = io_in_mem_read;
  assign bindin2409 = io_in_mem_write;
  assign bindin2412 = io_in_rd2;

  assign io_DBUS_in_data_ready = bindout2373;
  assign io_DBUS_out_data_data = bindout2376;
  assign io_DBUS_out_data_valid = bindout2379;
  assign io_DBUS_out_address_data = bindout2385;
  assign io_DBUS_out_address_valid = bindout2388;
  assign io_DBUS_out_control_data = bindout2394;
  assign io_DBUS_out_control_valid = bindout2397;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2415;
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
  reg[31:0] reg2538, reg2547, reg2579;
  reg[4:0] reg2554, reg2560, reg2566;
  reg[1:0] reg2573;

  always @ (posedge clk) begin
    if (reset)
      reg2538 <= 32'h0;
    else
      reg2538 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2547 <= 32'h0;
    else
      reg2547 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2554 <= 5'h0;
    else
      reg2554 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2560 <= 5'h0;
    else
      reg2560 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2566 <= 5'h0;
    else
      reg2566 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2573 <= 2'h0;
    else
      reg2573 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2579 <= 32'h0;
    else
      reg2579 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2538;
  assign io_out_mem_result = reg2547;
  assign io_out_rd = reg2554;
  assign io_out_wb = reg2573;
  assign io_out_rs1 = reg2560;
  assign io_out_rs2 = reg2566;
  assign io_out_PC_next = reg2579;

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
  wire eq2645, eq2650;
  wire[31:0] sel2652, sel2654;

  assign eq2645 = io_in_wb == 2'h3;
  assign eq2650 = io_in_wb == 2'h1;
  assign sel2652 = eq2650 ? io_in_alu_result : io_in_mem_result;
  assign sel2654 = eq2645 ? io_in_PC_next : sel2652;

  assign io_out_write_data = sel2654;
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
  wire eq2734, eq2738, eq2742, eq2747, eq2751, eq2755, eq2760, eq2764, ne2769, ne2774, eq2777, andl2779, andl2781, eq2786, ne2790, eq2797, andl2799, andl2801, andl2803, eq2807, ne2815, eq2822, andl2824, andl2826, andl2828, andl2830, orl2833, orl2835, ne2861, eq2864, andl2866, andl2868, eq2872, eq2883, andl2885, andl2887, andl2889, eq2893, eq2908, andl2910, andl2912, andl2914, andl2916, orl2919, orl2921, eq2941, andl2943, eq2947, eq2950, andl2952, andl2954, orl2957, orl2967, andl2969, sel2971;
  wire[31:0] sel2839, sel2841, sel2843, sel2845, sel2847, sel2849, sel2851, sel2853, sel2928, sel2934, sel2938, sel2960, sel2962;

  assign eq2734 = io_in_execute_wb == 2'h2;
  assign eq2738 = io_in_memory_wb == 2'h2;
  assign eq2742 = io_in_writeback_wb == 2'h2;
  assign eq2747 = io_in_execute_wb == 2'h3;
  assign eq2751 = io_in_memory_wb == 2'h3;
  assign eq2755 = io_in_writeback_wb == 2'h3;
  assign eq2760 = io_in_execute_is_csr == 1'h1;
  assign eq2764 = io_in_memory_is_csr == 1'h1;
  assign ne2769 = io_in_execute_wb != 2'h0;
  assign ne2774 = io_in_decode_src1 != 5'h0;
  assign eq2777 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2779 = eq2777 & ne2774;
  assign andl2781 = andl2779 & ne2769;
  assign eq2786 = andl2781 == 1'h0;
  assign ne2790 = io_in_memory_wb != 2'h0;
  assign eq2797 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2799 = eq2797 & ne2774;
  assign andl2801 = andl2799 & ne2790;
  assign andl2803 = andl2801 & eq2786;
  assign eq2807 = andl2803 == 1'h0;
  assign ne2815 = io_in_writeback_wb != 2'h0;
  assign eq2822 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2824 = eq2822 & ne2774;
  assign andl2826 = andl2824 & ne2815;
  assign andl2828 = andl2826 & eq2786;
  assign andl2830 = andl2828 & eq2807;
  assign orl2833 = andl2781 | andl2803;
  assign orl2835 = orl2833 | andl2830;
  assign sel2839 = eq2742 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2841 = eq2755 ? io_in_writeback_PC_next : sel2839;
  assign sel2843 = andl2830 ? sel2841 : 32'h7b;
  assign sel2845 = eq2738 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2847 = eq2751 ? io_in_memory_PC_next : sel2845;
  assign sel2849 = andl2803 ? sel2847 : sel2843;
  assign sel2851 = eq2747 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2853 = andl2781 ? sel2851 : sel2849;
  assign ne2861 = io_in_decode_src2 != 5'h0;
  assign eq2864 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2866 = eq2864 & ne2861;
  assign andl2868 = andl2866 & ne2769;
  assign eq2872 = andl2868 == 1'h0;
  assign eq2883 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2885 = eq2883 & ne2861;
  assign andl2887 = andl2885 & ne2790;
  assign andl2889 = andl2887 & eq2872;
  assign eq2893 = andl2889 == 1'h0;
  assign eq2908 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2910 = eq2908 & ne2861;
  assign andl2912 = andl2910 & ne2815;
  assign andl2914 = andl2912 & eq2872;
  assign andl2916 = andl2914 & eq2893;
  assign orl2919 = andl2868 | andl2889;
  assign orl2921 = orl2919 | andl2916;
  assign sel2928 = andl2916 ? sel2841 : 32'h7b;
  assign sel2934 = andl2889 ? sel2847 : sel2928;
  assign sel2938 = andl2868 ? sel2851 : sel2934;
  assign eq2941 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl2943 = eq2941 & eq2760;
  assign eq2947 = andl2943 == 1'h0;
  assign eq2950 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl2952 = eq2950 & eq2764;
  assign andl2954 = andl2952 & eq2947;
  assign orl2957 = andl2943 | andl2954;
  assign sel2960 = andl2954 ? io_in_memory_csr_result : 32'h7b;
  assign sel2962 = andl2943 ? io_in_execute_alu_result : sel2960;
  assign orl2967 = andl2781 | andl2868;
  assign andl2969 = orl2967 & eq2734;
  assign sel2971 = andl2969 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2835;
  assign io_out_src1_fwd_data = sel2853;
  assign io_out_src2_fwd = orl2921;
  assign io_out_src2_fwd_data = sel2938;
  assign io_out_csr_fwd = orl2957;
  assign io_out_csr_fwd_data = sel2962;
  assign io_out_fwd_stall = sel2971;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3078 [0:1];
  wire[31:0] mrport3080;

  initial begin
    mem3078[0] = 32'hdeadbeef;
    mem3078[1] = 32'hdeadbeef;
  end
  assign mrport3080 = mem3078[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport3080;

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
  reg[3:0] reg3149, sel3239;
  wire eq3157, andl3242, eq3246, andl3250, eq3254, andl3258;
  wire[3:0] sel3163, sel3168, sel3174, sel3180, sel3190, sel3195, sel3199, sel3208, sel3214, sel3224, sel3229, sel3233, sel3240, sel3256, sel3257, sel3259;

  always @ (posedge clk) begin
    if (reset)
      reg3149 <= 4'h0;
    else
      reg3149 <= sel3259;
  end
  assign eq3157 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3163 = eq3157 ? 4'h0 : 4'h1;
  assign sel3168 = eq3157 ? 4'h2 : 4'h1;
  assign sel3174 = eq3157 ? 4'h9 : 4'h3;
  assign sel3180 = eq3157 ? 4'h5 : 4'h4;
  assign sel3190 = eq3157 ? 4'h8 : 4'h6;
  assign sel3195 = eq3157 ? 4'h7 : 4'h6;
  assign sel3199 = eq3157 ? 4'h4 : 4'h8;
  assign sel3208 = eq3157 ? 4'h0 : 4'ha;
  assign sel3214 = eq3157 ? 4'hc : 4'hb;
  assign sel3224 = eq3157 ? 4'hf : 4'hd;
  assign sel3229 = eq3157 ? 4'he : 4'hd;
  assign sel3233 = eq3157 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3149)
      4'h0: sel3239 = sel3163;
      4'h1: sel3239 = sel3168;
      4'h2: sel3239 = sel3174;
      4'h3: sel3239 = sel3180;
      4'h4: sel3239 = sel3180;
      4'h5: sel3239 = sel3190;
      4'h6: sel3239 = sel3195;
      4'h7: sel3239 = sel3199;
      4'h8: sel3239 = sel3168;
      4'h9: sel3239 = sel3208;
      4'ha: sel3239 = sel3214;
      4'hb: sel3239 = sel3214;
      4'hc: sel3239 = sel3224;
      4'hd: sel3239 = sel3229;
      4'he: sel3239 = sel3233;
      4'hf: sel3239 = sel3168;
      default: sel3239 = reg3149;
    endcase
  end
  assign sel3240 = io_JTAG_TAP_in_mode_select_valid ? sel3239 : 4'h0;
  assign andl3242 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3246 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3250 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3254 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3256 = eq3246 ? 4'h0 : reg3149;
  assign sel3257 = andl3258 ? sel3240 : reg3149;
  assign andl3258 = andl3250 & eq3254;
  assign sel3259 = andl3242 ? sel3256 : sel3257;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3149;

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
  wire bindin3265, bindin3267, bindin3268, bindin3271, bindout3274, bindin3277, bindin3280, bindout3283, bindin3286, bindin3289, bindout3292, eq3329, eq3338, eq3343, eq3419, andl3420, sel3423, sel3429;
  wire[3:0] bindout3295;
  reg[31:0] reg3303, reg3310, reg3317, reg3324, sel3421;
  wire[31:0] sel3346, sel3348, shr3355, proxy3360, sel3415, sel3416, sel3417, sel3418, sel3422;
  wire[30:0] proxy3358;
  reg sel3428, sel3434;

  assign bindin3265 = clk;
  assign bindin3267 = reset;
  TAP __module16__(.clk(bindin3265), .reset(bindin3267), .io_JTAG_TAP_in_mode_select_data(bindin3268), .io_JTAG_TAP_in_mode_select_valid(bindin3271), .io_JTAG_TAP_in_clock_data(bindin3277), .io_JTAG_TAP_in_clock_valid(bindin3280), .io_JTAG_TAP_in_reset_data(bindin3286), .io_JTAG_TAP_in_reset_valid(bindin3289), .io_JTAG_TAP_in_mode_select_ready(bindout3274), .io_JTAG_TAP_in_clock_ready(bindout3283), .io_JTAG_TAP_in_reset_ready(bindout3292), .io_out_curr_state(bindout3295));
  assign bindin3268 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3271 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3277 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3280 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3286 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3289 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3303 <= 32'h0;
    else
      reg3303 <= sel3422;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3310 <= 32'h1234;
    else
      reg3310 <= sel3417;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3317 <= 32'h5678;
    else
      reg3317 <= sel3418;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3324 <= 32'h0;
    else
      reg3324 <= sel3421;
  end
  assign eq3329 = reg3303 == 32'h0;
  assign eq3338 = reg3303 == 32'h1;
  assign eq3343 = reg3303 == 32'h2;
  assign sel3346 = eq3343 ? reg3310 : 32'hdeadbeef;
  assign sel3348 = eq3338 ? reg3317 : sel3346;
  assign shr3355 = reg3324 >> 32'h1;
  assign proxy3358 = shr3355[30:0];
  assign proxy3360 = {io_JTAG_in_data_data, proxy3358};
  assign sel3415 = eq3343 ? reg3324 : reg3310;
  assign sel3416 = eq3338 ? reg3310 : sel3415;
  assign sel3417 = (bindout3295 == 4'h8) ? sel3416 : reg3310;
  assign sel3418 = andl3420 ? reg3324 : reg3317;
  assign eq3419 = bindout3295 == 4'h8;
  assign andl3420 = eq3419 & eq3338;
  always @(*) begin
    case (bindout3295)
      4'h3: sel3421 = sel3348;
      4'h4: sel3421 = proxy3360;
      4'ha: sel3421 = reg3303;
      4'hb: sel3421 = proxy3360;
      default: sel3421 = reg3324;
    endcase
  end
  assign sel3422 = (bindout3295 == 4'hf) ? reg3324 : reg3303;
  assign sel3423 = eq3329 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3295)
      4'h3: sel3428 = sel3423;
      4'h4: sel3428 = 1'h1;
      4'h8: sel3428 = sel3423;
      4'ha: sel3428 = sel3423;
      4'hb: sel3428 = 1'h1;
      4'hf: sel3428 = sel3423;
      default: sel3428 = sel3423;
    endcase
  end
  assign sel3429 = eq3329 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3295)
      4'h3: sel3434 = sel3429;
      4'h4: sel3434 = reg3324[0];
      4'h8: sel3434 = sel3429;
      4'ha: sel3434 = sel3429;
      4'hb: sel3434 = reg3324[0];
      4'hf: sel3434 = sel3429;
      default: sel3434 = sel3429;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3274;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3283;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3292;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3434;
  assign io_JTAG_out_data_valid = sel3428;

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
  reg[31:0] mem3490 [0:4095];
  reg[1:0] reg3499, sel3535;
  wire eq3511, eq3515, eq3531;
  reg sel3533;
  reg[31:0] sel3534;
  reg[11:0] sel3536;
  wire[31:0] mrport3538;

  always @ (posedge clk) begin
    if (sel3533) begin
      mem3490[sel3536] <= sel3534;
    end
  end
  assign mrport3538 = mem3490[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (reset)
      reg3499 <= 2'h0;
    else
      reg3499 <= sel3535;
  end
  assign eq3511 = reg3499 == 2'h1;
  assign eq3515 = reg3499 == 2'h0;
  assign eq3531 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3515)
      sel3533 = 1'h1;
    else if (eq3511)
      sel3533 = 1'h1;
    else
      sel3533 = eq3531;
  end
  always @(*) begin
    if (eq3515)
      sel3534 = 32'h0;
    else if (eq3511)
      sel3534 = 32'h0;
    else
      sel3534 = io_in_mem_csr_result;
  end
  always @(*) begin
    if (eq3515)
      sel3535 = 2'h1;
    else if (eq3511)
      sel3535 = 2'h3;
    else
      sel3535 = reg3499;
  end
  always @(*) begin
    if (eq3515)
      sel3536 = 12'hf14;
    else if (eq3511)
      sel3536 = 12'h301;
    else
      sel3536 = io_in_mem_csr_address;
  end

  assign io_out_decode_csr_data = mrport3538;

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
  wire bindin156, bindin158, bindin162, bindout165, bindout171, bindin174, bindin177, bindin183, bindin186, bindin189, bindin195, bindin252, bindin253, bindin260, bindin263, bindin1093, bindin1094, bindin1101, bindin1113, bindin1119, bindin1125, bindout1137, bindout1170, bindout1185, bindout1188, bindin1455, bindin1456, bindin1478, bindin1496, bindin1505, bindout1517, bindout1547, bindin1846, bindin1870, bindout1882, bindout1915, bindin2065, bindin2066, bindin2100, bindout2109, bindin2422, bindout2425, bindout2431, bindin2434, bindout2440, bindin2443, bindout2449, bindin2452, bindin2584, bindin2585, bindin3000, bindin3024, bindout3048, bindout3054, bindout3060, bindout3066, bindin3085, bindin3088, bindout3091, bindout3094, bindin3438, bindin3439, bindin3440, bindin3443, bindout3446, bindin3449, bindin3452, bindout3455, bindin3458, bindin3461, bindout3464, bindin3467, bindin3470, bindout3473, bindout3476, bindout3479, bindin3482, bindin3543, bindin3544, bindin3551, eq3561;
  wire[31:0] bindin159, bindout168, bindin180, bindin192, bindin198, bindout201, bindout204, bindin254, bindin257, bindout266, bindout269, bindin1095, bindin1098, bindin1104, bindin1116, bindin1122, bindin1128, bindin1131, bindout1140, bindout1143, bindout1146, bindout1155, bindout1161, bindout1191, bindout1197, bindin1463, bindin1469, bindin1490, bindin1508, bindin1511, bindout1520, bindout1523, bindout1532, bindout1538, bindout1565, bindin1831, bindin1837, bindin1858, bindin1873, bindin1876, bindout1885, bindout1888, bindout1900, bindout1906, bindout1918, bindout1921, bindin2067, bindin2079, bindin2085, bindin2094, bindin2103, bindout2112, bindout2115, bindout2127, bindout2130, bindout2142, bindin2419, bindout2428, bindout2437, bindin2455, bindin2473, bindin2479, bindin2482, bindout2485, bindout2488, bindout2503, bindin2586, bindin2589, bindin2604, bindout2607, bindout2610, bindout2625, bindin2659, bindin2662, bindin2677, bindout2680, bindin2994, bindin2997, bindin3006, bindin3015, bindin3018, bindin3021, bindin3030, bindin3039, bindin3042, bindin3045, bindout3051, bindout3057, bindout3063, bindout3097, bindin3554, bindout3557;
  wire[4:0] bindin1107, bindout1149, bindout1152, bindout1158, bindin1457, bindin1460, bindin1466, bindout1526, bindout1529, bindout1535, bindin1825, bindin1828, bindin1834, bindout1891, bindout1897, bindout1903, bindin2070, bindin2076, bindin2082, bindout2118, bindout2124, bindout2133, bindin2464, bindin2470, bindin2476, bindout2491, bindout2497, bindout2500, bindin2592, bindin2598, bindin2601, bindout2613, bindout2619, bindout2622, bindin2665, bindin2671, bindin2674, bindout2683, bindin2979, bindin2982, bindin2988, bindin3009, bindin3033;
  wire[1:0] bindin1110, bindout1164, bindin1475, bindout1544, bindin1843, bindout1894, bindin2073, bindout2121, bindout2446, bindin2467, bindout2494, bindin2595, bindout2616, bindin2668, bindout2686, bindin2991, bindin3012, bindin3036;
  wire[11:0] bindout1134, bindout1173, bindin1481, bindin1502, bindout1514, bindout1550, bindin1849, bindin1867, bindout1879, bindin2097, bindout2106, bindin2985, bindin3003, bindin3027, bindin3545, bindin3548;
  wire[3:0] bindout1167, bindin1472, bindout1541, bindin1840;
  wire[2:0] bindout1176, bindout1179, bindout1182, bindin1484, bindin1487, bindin1493, bindout1553, bindout1556, bindout1559, bindin1852, bindin1855, bindin1861, bindout1909, bindout1912, bindin2088, bindin2091, bindout2136, bindout2139, bindin2458, bindin2461;
  wire[19:0] bindout1194, bindin1499, bindout1562, bindin1864;

  assign bindin156 = clk;
  assign bindin158 = reset;
  Fetch __module2__(.clk(bindin156), .reset(bindin158), .io_IBUS_in_data_data(bindin159), .io_IBUS_in_data_valid(bindin162), .io_IBUS_out_address_ready(bindin174), .io_in_branch_dir(bindin177), .io_in_branch_dest(bindin180), .io_in_branch_stall(bindin183), .io_in_fwd_stall(bindin186), .io_in_jal(bindin189), .io_in_jal_dest(bindin192), .io_in_interrupt(bindin195), .io_in_interrupt_pc(bindin198), .io_IBUS_in_data_ready(bindout165), .io_IBUS_out_address_data(bindout168), .io_IBUS_out_address_valid(bindout171), .io_out_instruction(bindout201), .io_out_PC_next(bindout204));
  assign bindin159 = io_IBUS_in_data_data;
  assign bindin162 = io_IBUS_in_data_valid;
  assign bindin174 = io_IBUS_out_address_ready;
  assign bindin177 = bindout1915;
  assign bindin180 = bindout1918;
  assign bindin183 = bindout1185;
  assign bindin186 = bindout3066;
  assign bindin189 = bindout1188;
  assign bindin192 = bindout1191;
  assign bindin195 = bindout3094;
  assign bindin198 = bindout3097;
  assign bindin252 = clk;
  assign bindin253 = reset;
  F_D_Register __module3__(.clk(bindin252), .reset(bindin253), .io_in_instruction(bindin254), .io_in_PC_next(bindin257), .io_in_branch_stall(bindin260), .io_in_fwd_stall(bindin263), .io_out_instruction(bindout266), .io_out_PC_next(bindout269));
  assign bindin254 = bindout201;
  assign bindin257 = bindout204;
  assign bindin260 = bindout1185;
  assign bindin263 = bindout3066;
  assign bindin1093 = clk;
  assign bindin1094 = reset;
  Decode __module4__(.clk(bindin1093), .reset(bindin1094), .io_in_instruction(bindin1095), .io_in_PC_next(bindin1098), .io_in_stall(bindin1101), .io_in_write_data(bindin1104), .io_in_rd(bindin1107), .io_in_wb(bindin1110), .io_in_src1_fwd(bindin1113), .io_in_src1_fwd_data(bindin1116), .io_in_src2_fwd(bindin1119), .io_in_src2_fwd_data(bindin1122), .io_in_csr_fwd(bindin1125), .io_in_csr_fwd_data(bindin1128), .io_in_csr_data(bindin1131), .io_out_csr_address(bindout1134), .io_out_is_csr(bindout1137), .io_out_csr_data(bindout1140), .io_out_csr_mask(bindout1143), .io_actual_change(bindout1146), .io_out_rd(bindout1149), .io_out_rs1(bindout1152), .io_out_rd1(bindout1155), .io_out_rs2(bindout1158), .io_out_rd2(bindout1161), .io_out_wb(bindout1164), .io_out_alu_op(bindout1167), .io_out_rs2_src(bindout1170), .io_out_itype_immed(bindout1173), .io_out_mem_read(bindout1176), .io_out_mem_write(bindout1179), .io_out_branch_type(bindout1182), .io_out_branch_stall(bindout1185), .io_out_jal(bindout1188), .io_out_jal_dest(bindout1191), .io_out_upper_immed(bindout1194), .io_out_PC_next(bindout1197));
  assign bindin1095 = bindout266;
  assign bindin1098 = bindout269;
  assign bindin1101 = eq3561;
  assign bindin1104 = bindout2680;
  assign bindin1107 = bindout2683;
  assign bindin1110 = bindout2686;
  assign bindin1113 = bindout3048;
  assign bindin1116 = bindout3051;
  assign bindin1119 = bindout3054;
  assign bindin1122 = bindout3057;
  assign bindin1125 = bindout3060;
  assign bindin1128 = bindout3063;
  assign bindin1131 = bindout3557;
  assign bindin1455 = clk;
  assign bindin1456 = reset;
  D_E_Register __module6__(.clk(bindin1455), .reset(bindin1456), .io_in_rd(bindin1457), .io_in_rs1(bindin1460), .io_in_rd1(bindin1463), .io_in_rs2(bindin1466), .io_in_rd2(bindin1469), .io_in_alu_op(bindin1472), .io_in_wb(bindin1475), .io_in_rs2_src(bindin1478), .io_in_itype_immed(bindin1481), .io_in_mem_read(bindin1484), .io_in_mem_write(bindin1487), .io_in_PC_next(bindin1490), .io_in_branch_type(bindin1493), .io_in_fwd_stall(bindin1496), .io_in_upper_immed(bindin1499), .io_in_csr_address(bindin1502), .io_in_is_csr(bindin1505), .io_in_csr_data(bindin1508), .io_in_csr_mask(bindin1511), .io_out_csr_address(bindout1514), .io_out_is_csr(bindout1517), .io_out_csr_data(bindout1520), .io_out_csr_mask(bindout1523), .io_out_rd(bindout1526), .io_out_rs1(bindout1529), .io_out_rd1(bindout1532), .io_out_rs2(bindout1535), .io_out_rd2(bindout1538), .io_out_alu_op(bindout1541), .io_out_wb(bindout1544), .io_out_rs2_src(bindout1547), .io_out_itype_immed(bindout1550), .io_out_mem_read(bindout1553), .io_out_mem_write(bindout1556), .io_out_branch_type(bindout1559), .io_out_upper_immed(bindout1562), .io_out_PC_next(bindout1565));
  assign bindin1457 = bindout1149;
  assign bindin1460 = bindout1152;
  assign bindin1463 = bindout1155;
  assign bindin1466 = bindout1158;
  assign bindin1469 = bindout1161;
  assign bindin1472 = bindout1167;
  assign bindin1475 = bindout1164;
  assign bindin1478 = bindout1170;
  assign bindin1481 = bindout1173;
  assign bindin1484 = bindout1176;
  assign bindin1487 = bindout1179;
  assign bindin1490 = bindout1197;
  assign bindin1493 = bindout1182;
  assign bindin1496 = bindout3066;
  assign bindin1499 = bindout1194;
  assign bindin1502 = bindout1134;
  assign bindin1505 = bindout1137;
  assign bindin1508 = bindout1140;
  assign bindin1511 = bindout1143;
  Execute __module7__(.io_in_rd(bindin1825), .io_in_rs1(bindin1828), .io_in_rd1(bindin1831), .io_in_rs2(bindin1834), .io_in_rd2(bindin1837), .io_in_alu_op(bindin1840), .io_in_wb(bindin1843), .io_in_rs2_src(bindin1846), .io_in_itype_immed(bindin1849), .io_in_mem_read(bindin1852), .io_in_mem_write(bindin1855), .io_in_PC_next(bindin1858), .io_in_branch_type(bindin1861), .io_in_upper_immed(bindin1864), .io_in_csr_address(bindin1867), .io_in_is_csr(bindin1870), .io_in_csr_data(bindin1873), .io_in_csr_mask(bindin1876), .io_out_csr_address(bindout1879), .io_out_is_csr(bindout1882), .io_out_csr_result(bindout1885), .io_out_alu_result(bindout1888), .io_out_rd(bindout1891), .io_out_wb(bindout1894), .io_out_rs1(bindout1897), .io_out_rd1(bindout1900), .io_out_rs2(bindout1903), .io_out_rd2(bindout1906), .io_out_mem_read(bindout1909), .io_out_mem_write(bindout1912), .io_out_branch_dir(bindout1915), .io_out_branch_dest(bindout1918), .io_out_PC_next(bindout1921));
  assign bindin1825 = bindout1526;
  assign bindin1828 = bindout1529;
  assign bindin1831 = bindout1532;
  assign bindin1834 = bindout1535;
  assign bindin1837 = bindout1538;
  assign bindin1840 = bindout1541;
  assign bindin1843 = bindout1544;
  assign bindin1846 = bindout1547;
  assign bindin1849 = bindout1550;
  assign bindin1852 = bindout1553;
  assign bindin1855 = bindout1556;
  assign bindin1858 = bindout1565;
  assign bindin1861 = bindout1559;
  assign bindin1864 = bindout1562;
  assign bindin1867 = bindout1514;
  assign bindin1870 = bindout1517;
  assign bindin1873 = bindout1520;
  assign bindin1876 = bindout1523;
  assign bindin2065 = clk;
  assign bindin2066 = reset;
  E_M_Register __module8__(.clk(bindin2065), .reset(bindin2066), .io_in_alu_result(bindin2067), .io_in_rd(bindin2070), .io_in_wb(bindin2073), .io_in_rs1(bindin2076), .io_in_rd1(bindin2079), .io_in_rs2(bindin2082), .io_in_rd2(bindin2085), .io_in_mem_read(bindin2088), .io_in_mem_write(bindin2091), .io_in_PC_next(bindin2094), .io_in_csr_address(bindin2097), .io_in_is_csr(bindin2100), .io_in_csr_result(bindin2103), .io_out_csr_address(bindout2106), .io_out_is_csr(bindout2109), .io_out_csr_result(bindout2112), .io_out_alu_result(bindout2115), .io_out_rd(bindout2118), .io_out_wb(bindout2121), .io_out_rs1(bindout2124), .io_out_rd1(bindout2127), .io_out_rd2(bindout2130), .io_out_rs2(bindout2133), .io_out_mem_read(bindout2136), .io_out_mem_write(bindout2139), .io_out_PC_next(bindout2142));
  assign bindin2067 = bindout1888;
  assign bindin2070 = bindout1891;
  assign bindin2073 = bindout1894;
  assign bindin2076 = bindout1897;
  assign bindin2079 = bindout1900;
  assign bindin2082 = bindout1903;
  assign bindin2085 = bindout1906;
  assign bindin2088 = bindout1909;
  assign bindin2091 = bindout1912;
  assign bindin2094 = bindout1921;
  assign bindin2097 = bindout1879;
  assign bindin2100 = bindout1882;
  assign bindin2103 = bindout1885;
  Memory __module9__(.io_DBUS_in_data_data(bindin2419), .io_DBUS_in_data_valid(bindin2422), .io_DBUS_out_data_ready(bindin2434), .io_DBUS_out_address_ready(bindin2443), .io_DBUS_out_control_ready(bindin2452), .io_in_alu_result(bindin2455), .io_in_mem_read(bindin2458), .io_in_mem_write(bindin2461), .io_in_rd(bindin2464), .io_in_wb(bindin2467), .io_in_rs1(bindin2470), .io_in_rd1(bindin2473), .io_in_rs2(bindin2476), .io_in_rd2(bindin2479), .io_in_PC_next(bindin2482), .io_DBUS_in_data_ready(bindout2425), .io_DBUS_out_data_data(bindout2428), .io_DBUS_out_data_valid(bindout2431), .io_DBUS_out_address_data(bindout2437), .io_DBUS_out_address_valid(bindout2440), .io_DBUS_out_control_data(bindout2446), .io_DBUS_out_control_valid(bindout2449), .io_out_alu_result(bindout2485), .io_out_mem_result(bindout2488), .io_out_rd(bindout2491), .io_out_wb(bindout2494), .io_out_rs1(bindout2497), .io_out_rs2(bindout2500), .io_out_PC_next(bindout2503));
  assign bindin2419 = io_DBUS_in_data_data;
  assign bindin2422 = io_DBUS_in_data_valid;
  assign bindin2434 = io_DBUS_out_data_ready;
  assign bindin2443 = io_DBUS_out_address_ready;
  assign bindin2452 = io_DBUS_out_control_ready;
  assign bindin2455 = bindout2115;
  assign bindin2458 = bindout2136;
  assign bindin2461 = bindout2139;
  assign bindin2464 = bindout2118;
  assign bindin2467 = bindout2121;
  assign bindin2470 = bindout2124;
  assign bindin2473 = bindout2127;
  assign bindin2476 = bindout2133;
  assign bindin2479 = bindout2130;
  assign bindin2482 = bindout2142;
  assign bindin2584 = clk;
  assign bindin2585 = reset;
  M_W_Register __module11__(.clk(bindin2584), .reset(bindin2585), .io_in_alu_result(bindin2586), .io_in_mem_result(bindin2589), .io_in_rd(bindin2592), .io_in_wb(bindin2595), .io_in_rs1(bindin2598), .io_in_rs2(bindin2601), .io_in_PC_next(bindin2604), .io_out_alu_result(bindout2607), .io_out_mem_result(bindout2610), .io_out_rd(bindout2613), .io_out_wb(bindout2616), .io_out_rs1(bindout2619), .io_out_rs2(bindout2622), .io_out_PC_next(bindout2625));
  assign bindin2586 = bindout2485;
  assign bindin2589 = bindout2488;
  assign bindin2592 = bindout2491;
  assign bindin2595 = bindout2494;
  assign bindin2598 = bindout2497;
  assign bindin2601 = bindout2500;
  assign bindin2604 = bindout2503;
  Write_Back __module12__(.io_in_alu_result(bindin2659), .io_in_mem_result(bindin2662), .io_in_rd(bindin2665), .io_in_wb(bindin2668), .io_in_rs1(bindin2671), .io_in_rs2(bindin2674), .io_in_PC_next(bindin2677), .io_out_write_data(bindout2680), .io_out_rd(bindout2683), .io_out_wb(bindout2686));
  assign bindin2659 = bindout2607;
  assign bindin2662 = bindout2610;
  assign bindin2665 = bindout2613;
  assign bindin2668 = bindout2616;
  assign bindin2671 = bindout2619;
  assign bindin2674 = bindout2622;
  assign bindin2677 = bindout2625;
  Forwarding __module13__(.io_in_decode_src1(bindin2979), .io_in_decode_src2(bindin2982), .io_in_decode_csr_address(bindin2985), .io_in_execute_dest(bindin2988), .io_in_execute_wb(bindin2991), .io_in_execute_alu_result(bindin2994), .io_in_execute_PC_next(bindin2997), .io_in_execute_is_csr(bindin3000), .io_in_execute_csr_address(bindin3003), .io_in_execute_csr_result(bindin3006), .io_in_memory_dest(bindin3009), .io_in_memory_wb(bindin3012), .io_in_memory_alu_result(bindin3015), .io_in_memory_mem_data(bindin3018), .io_in_memory_PC_next(bindin3021), .io_in_memory_is_csr(bindin3024), .io_in_memory_csr_address(bindin3027), .io_in_memory_csr_result(bindin3030), .io_in_writeback_dest(bindin3033), .io_in_writeback_wb(bindin3036), .io_in_writeback_alu_result(bindin3039), .io_in_writeback_mem_data(bindin3042), .io_in_writeback_PC_next(bindin3045), .io_out_src1_fwd(bindout3048), .io_out_src1_fwd_data(bindout3051), .io_out_src2_fwd(bindout3054), .io_out_src2_fwd_data(bindout3057), .io_out_csr_fwd(bindout3060), .io_out_csr_fwd_data(bindout3063), .io_out_fwd_stall(bindout3066));
  assign bindin2979 = bindout1152;
  assign bindin2982 = bindout1158;
  assign bindin2985 = bindout1134;
  assign bindin2988 = bindout1891;
  assign bindin2991 = bindout1894;
  assign bindin2994 = bindout1888;
  assign bindin2997 = bindout1921;
  assign bindin3000 = bindout1882;
  assign bindin3003 = bindout1879;
  assign bindin3006 = bindout1885;
  assign bindin3009 = bindout2491;
  assign bindin3012 = bindout2494;
  assign bindin3015 = bindout2485;
  assign bindin3018 = bindout2488;
  assign bindin3021 = bindout2503;
  assign bindin3024 = bindout2109;
  assign bindin3027 = bindout2106;
  assign bindin3030 = bindout2112;
  assign bindin3033 = bindout2613;
  assign bindin3036 = bindout2616;
  assign bindin3039 = bindout2607;
  assign bindin3042 = bindout2610;
  assign bindin3045 = bindout2625;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3085), .io_INTERRUPT_in_interrupt_id_valid(bindin3088), .io_INTERRUPT_in_interrupt_id_ready(bindout3091), .io_out_interrupt(bindout3094), .io_out_interrupt_pc(bindout3097));
  assign bindin3085 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3088 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3438 = clk;
  assign bindin3439 = reset;
  JTAG __module15__(.clk(bindin3438), .reset(bindin3439), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3440), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3443), .io_JTAG_JTAG_TAP_in_clock_data(bindin3449), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3452), .io_JTAG_JTAG_TAP_in_reset_data(bindin3458), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3461), .io_JTAG_in_data_data(bindin3467), .io_JTAG_in_data_valid(bindin3470), .io_JTAG_out_data_ready(bindin3482), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3446), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3455), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3464), .io_JTAG_in_data_ready(bindout3473), .io_JTAG_out_data_data(bindout3476), .io_JTAG_out_data_valid(bindout3479));
  assign bindin3440 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3443 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3449 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3452 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3458 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3461 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3467 = io_jtag_in_data_data;
  assign bindin3470 = io_jtag_in_data_valid;
  assign bindin3482 = io_jtag_out_data_ready;
  assign bindin3543 = clk;
  assign bindin3544 = reset;
  CSR_Handler __module17__(.clk(bindin3543), .reset(bindin3544), .io_in_decode_csr_address(bindin3545), .io_in_mem_csr_address(bindin3548), .io_in_mem_is_csr(bindin3551), .io_in_mem_csr_result(bindin3554), .io_out_decode_csr_data(bindout3557));
  assign bindin3545 = bindout1134;
  assign bindin3548 = bindout2106;
  assign bindin3551 = bindout2109;
  assign bindin3554 = bindout2112;
  assign eq3561 = bindout3066 == 1'h1;

  assign io_IBUS_in_data_ready = bindout165;
  assign io_IBUS_out_address_data = bindout168;
  assign io_IBUS_out_address_valid = bindout171;
  assign io_DBUS_in_data_ready = bindout2425;
  assign io_DBUS_out_data_data = bindout2428;
  assign io_DBUS_out_data_valid = bindout2431;
  assign io_DBUS_out_address_data = bindout2437;
  assign io_DBUS_out_address_valid = bindout2440;
  assign io_DBUS_out_control_data = bindout2446;
  assign io_DBUS_out_control_valid = bindout2449;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3091;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3446;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3455;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3464;
  assign io_jtag_in_data_ready = bindout3473;
  assign io_jtag_out_data_data = bindout3476;
  assign io_jtag_out_data_valid = bindout3479;
  assign io_out_fwd_stall = bindout3066;
  assign io_out_branch_stall = bindout1185;
  assign io_actual_change = bindout1146;

endmodule
