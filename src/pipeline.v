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
  input wire reset,
  input wire io_in_write_register,
  input wire[4:0] io_in_rd,
  input wire[31:0] io_in_data,
  input wire[4:0] io_in_src1,
  input wire[4:0] io_in_src2,
  output wire[31:0] io_out_src1_data,
  output wire[31:0] io_out_src2_data
);
  reg[31:0] mem394 [0:31];
  reg reg402;
  wire eq407, sel411, ne425, andl428, sel430, eq439, eq448;
  wire[31:0] sel431, mrport434, sel441, mrport443, sel450;
  wire[4:0] sel432;

  always @ (posedge clk) begin
    if (sel430) begin
      mem394[sel432] <= sel431;
    end
  end
  assign mrport434 = mem394[io_in_src1];
  assign mrport443 = mem394[io_in_src2];
  always @ (posedge clk) begin
    if (reset)
      reg402 <= 1'h1;
    else
      reg402 <= sel411;
  end
  assign eq407 = reg402 == 1'h1;
  assign sel411 = eq407 ? 1'h0 : reg402;
  assign ne425 = io_in_rd != 5'h0;
  assign andl428 = io_in_write_register & ne425;
  assign sel430 = reg402 ? 1'h1 : andl428;
  assign sel431 = reg402 ? 32'h0 : io_in_data;
  assign sel432 = reg402 ? 5'h0 : io_in_rd;
  assign eq439 = io_in_src1 == 5'h0;
  assign sel441 = eq439 ? 32'h0 : mrport434;
  assign eq448 = io_in_src2 == 5'h0;
  assign sel450 = eq448 ? 32'h0 : mrport443;

  assign io_out_src1_data = sel441;
  assign io_out_src2_data = sel450;

endmodule

module Decode(
  input wire clk,
  input wire reset,
  input wire[31:0] io_in_instruction,
  input wire[31:0] io_in_PC_next,
  input wire[31:0] io_in_curr_PC,
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
  wire bindin457, bindin459, bindin460, ne520, sel522, eq570, eq575, eq580, orl582, eq587, eq592, eq597, eq602, eq607, eq612, ne617, eq622, andl624, proxy627, eq628, andl631, eq635, andl641, eq645, eq653, eq663, orl671, orl673, orl675, orl677, orl688, orl690, orl697, sel699, eq721, eq726, orl728, proxy777, proxy778, lt811, proxy883, eq909, proxy932, eq933, sel948, sel949, sel951, sel952, sel961, sel962, eq979, eq1016, eq1024, eq1032, orl1038, lt1056;
  wire[4:0] bindin463, bindin469, bindin472, proxy532, proxy539, proxy546;
  wire[31:0] bindin466, bindout475, bindout478, shr529, shr536, shr543, shr550, shr557, sel647, sel649, sel655, pad657, sel659, sel665, shr782, shr887, pad900, proxy905, sel911, pad923, proxy928, sel935, sel954, sel955;
  wire[2:0] proxy553, sel703, sel706, sel958, sel959;
  wire[6:0] proxy560;
  wire[1:0] sel679, sel683, sel692, proxy1011;
  wire[11:0] pad730, sel738, proxy756, proxy793, proxy921, sel945, sel946, sel967, sel968;
  wire[3:0] proxy785, sel981, sel984, sel1001, sel1018, sel1026, sel1034, sel1040, sel1042, sel1046, sel1050, sel1058, sel1060;
  wire[5:0] proxy791;
  wire[19:0] proxy854, sel964, sel965;
  wire[7:0] proxy882;
  wire[9:0] proxy890;
  wire[20:0] proxy894;
  reg[11:0] sel947, sel969;
  reg sel950, sel953, sel963;
  reg[31:0] sel956;
  reg[2:0] sel957, sel960;
  reg[19:0] sel966;
  reg[3:0] sel1009;

  assign bindin457 = clk;
  assign bindin459 = reset;
  RegisterFile __module5__(.clk(bindin457), .reset(bindin459), .io_in_write_register(bindin460), .io_in_rd(bindin463), .io_in_data(bindin466), .io_in_src1(bindin469), .io_in_src2(bindin472), .io_out_src1_data(bindout475), .io_out_src2_data(bindout478));
  assign bindin460 = sel522;
  assign bindin463 = io_in_rd;
  assign bindin466 = io_in_write_data;
  assign bindin469 = proxy539;
  assign bindin472 = proxy546;
  assign ne520 = io_in_wb != 2'h0;
  assign sel522 = ne520 ? 1'h1 : 1'h0;
  assign shr529 = io_in_instruction >> 32'h7;
  assign proxy532 = shr529[4:0];
  assign shr536 = io_in_instruction >> 32'hf;
  assign proxy539 = shr536[4:0];
  assign shr543 = io_in_instruction >> 32'h14;
  assign proxy546 = shr543[4:0];
  assign shr550 = io_in_instruction >> 32'hc;
  assign proxy553 = shr550[2:0];
  assign shr557 = io_in_instruction >> 32'h19;
  assign proxy560 = shr557[6:0];
  assign eq570 = io_in_instruction[6:0] == 7'h33;
  assign eq575 = io_in_instruction[6:0] == 7'h3;
  assign eq580 = io_in_instruction[6:0] == 7'h13;
  assign orl582 = eq580 | eq575;
  assign eq587 = io_in_instruction[6:0] == 7'h23;
  assign eq592 = io_in_instruction[6:0] == 7'h63;
  assign eq597 = io_in_instruction[6:0] == 7'h6f;
  assign eq602 = io_in_instruction[6:0] == 7'h67;
  assign eq607 = io_in_instruction[6:0] == 7'h37;
  assign eq612 = io_in_instruction[6:0] == 7'h17;
  assign ne617 = proxy553 != 3'h0;
  assign eq622 = io_in_instruction[6:0] == 7'h73;
  assign andl624 = eq622 & ne617;
  assign proxy627 = proxy553[2];
  assign eq628 = proxy627 == 1'h1;
  assign andl631 = andl624 & eq628;
  assign eq635 = proxy553 == 3'h0;
  assign andl641 = eq622 & eq635;
  assign eq645 = io_in_src1_fwd == 1'h1;
  assign sel647 = eq645 ? io_in_src1_fwd_data : bindout475;
  assign sel649 = eq597 ? io_in_curr_PC : sel647;
  assign eq653 = io_in_src2_fwd == 1'h1;
  assign sel655 = eq653 ? io_in_src2_fwd_data : bindout478;
  assign pad657 = {{27{1'b0}}, proxy546};
  assign sel659 = andl631 ? pad657 : sel655;
  assign eq663 = io_in_csr_fwd == 1'h1;
  assign sel665 = eq663 ? io_in_csr_fwd_data : io_in_csr_data;
  assign orl671 = orl582 | eq570;
  assign orl673 = orl671 | eq607;
  assign orl675 = orl673 | eq612;
  assign orl677 = orl675 | andl624;
  assign sel679 = orl677 ? 2'h1 : 2'h0;
  assign sel683 = eq575 ? 2'h2 : sel679;
  assign orl688 = eq597 | eq602;
  assign orl690 = orl688 | andl641;
  assign sel692 = orl690 ? 2'h3 : sel683;
  assign orl697 = orl582 | eq587;
  assign sel699 = orl697 ? 1'h1 : 1'h0;
  assign sel703 = eq575 ? proxy553 : 3'h7;
  assign sel706 = eq587 ? proxy553 : 3'h7;
  assign eq721 = proxy553 == 3'h5;
  assign eq726 = proxy553 == 3'h1;
  assign orl728 = eq726 | eq721;
  assign pad730 = {{7{1'b0}}, proxy546};
  assign sel738 = orl728 ? pad730 : shr543[11:0];
  assign proxy756 = {proxy560, proxy532};
  assign proxy777 = io_in_instruction[31];
  assign proxy778 = io_in_instruction[7];
  assign shr782 = io_in_instruction >> 32'h8;
  assign proxy785 = shr782[3:0];
  assign proxy791 = shr557[5:0];
  assign proxy793 = {proxy777, proxy778, proxy791, proxy785};
  assign lt811 = shr543[11:0] < 12'h2;
  assign proxy854 = {proxy560, proxy546, proxy539, proxy553};
  assign proxy882 = shr550[7:0];
  assign proxy883 = io_in_instruction[20];
  assign shr887 = io_in_instruction >> 32'h15;
  assign proxy890 = shr887[9:0];
  assign proxy894 = {proxy777, proxy882, proxy883, proxy890, 1'h0};
  assign pad900 = {{11{1'b0}}, proxy894};
  assign proxy905 = {11'h7ff, proxy894};
  assign eq909 = proxy777 == 1'h1;
  assign sel911 = eq909 ? proxy905 : pad900;
  assign proxy921 = {proxy560, proxy546};
  assign pad923 = {{20{1'b0}}, proxy921};
  assign proxy928 = {20'hfffff, proxy921};
  assign proxy932 = proxy921[11];
  assign eq933 = proxy932 == 1'h1;
  assign sel935 = eq933 ? proxy928 : pad923;
  assign sel945 = lt811 ? 12'h7b : 12'h7b;
  assign sel946 = (proxy553 == 3'h0) ? sel945 : 12'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel947 = sel738;
      7'h33: sel947 = 12'h7b;
      7'h23: sel947 = proxy756;
      7'h03: sel947 = shr543[11:0];
      7'h63: sel947 = proxy793;
      7'h73: sel947 = sel946;
      7'h37: sel947 = 12'h7b;
      7'h17: sel947 = 12'h7b;
      7'h6f: sel947 = 12'h7b;
      7'h67: sel947 = 12'h7b;
      default: sel947 = 12'h7b;
    endcase
  end
  assign sel948 = lt811 ? 1'h0 : 1'h1;
  assign sel949 = (proxy553 == 3'h0) ? sel948 : 1'h1;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel950 = 1'h0;
      7'h33: sel950 = 1'h0;
      7'h23: sel950 = 1'h0;
      7'h03: sel950 = 1'h0;
      7'h63: sel950 = 1'h0;
      7'h73: sel950 = sel949;
      7'h37: sel950 = 1'h0;
      7'h17: sel950 = 1'h0;
      7'h6f: sel950 = 1'h0;
      7'h67: sel950 = 1'h0;
      default: sel950 = 1'h0;
    endcase
  end
  assign sel951 = lt811 ? 1'h0 : 1'h0;
  assign sel952 = (proxy553 == 3'h0) ? sel951 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel953 = 1'h0;
      7'h33: sel953 = 1'h0;
      7'h23: sel953 = 1'h0;
      7'h03: sel953 = 1'h0;
      7'h63: sel953 = 1'h1;
      7'h73: sel953 = sel952;
      7'h37: sel953 = 1'h0;
      7'h17: sel953 = 1'h0;
      7'h6f: sel953 = 1'h1;
      7'h67: sel953 = 1'h1;
      default: sel953 = 1'h0;
    endcase
  end
  assign sel954 = lt811 ? 32'hb0000000 : 32'h7b;
  assign sel955 = (proxy553 == 3'h0) ? sel954 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel956 = 32'h7b;
      7'h33: sel956 = 32'h7b;
      7'h23: sel956 = 32'h7b;
      7'h03: sel956 = 32'h7b;
      7'h63: sel956 = 32'h7b;
      7'h73: sel956 = sel955;
      7'h37: sel956 = 32'h7b;
      7'h17: sel956 = 32'h7b;
      7'h6f: sel956 = sel911;
      7'h67: sel956 = sel935;
      default: sel956 = 32'h7b;
    endcase
  end
  always @(*) begin
    case (proxy553)
      3'h0: sel957 = 3'h1;
      3'h1: sel957 = 3'h2;
      3'h4: sel957 = 3'h3;
      3'h5: sel957 = 3'h4;
      3'h6: sel957 = 3'h5;
      3'h7: sel957 = 3'h6;
      default: sel957 = 3'h0;
    endcase
  end
  assign sel958 = lt811 ? 3'h0 : 3'h0;
  assign sel959 = (proxy553 == 3'h0) ? sel958 : 3'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel960 = 3'h0;
      7'h33: sel960 = 3'h0;
      7'h23: sel960 = 3'h0;
      7'h03: sel960 = 3'h0;
      7'h63: sel960 = sel957;
      7'h73: sel960 = sel959;
      7'h37: sel960 = 3'h0;
      7'h17: sel960 = 3'h0;
      7'h6f: sel960 = 3'h0;
      7'h67: sel960 = 3'h0;
      default: sel960 = 3'h0;
    endcase
  end
  assign sel961 = lt811 ? 1'h1 : 1'h0;
  assign sel962 = (proxy553 == 3'h0) ? sel961 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel963 = 1'h0;
      7'h33: sel963 = 1'h0;
      7'h23: sel963 = 1'h0;
      7'h03: sel963 = 1'h0;
      7'h63: sel963 = 1'h0;
      7'h73: sel963 = sel962;
      7'h37: sel963 = 1'h0;
      7'h17: sel963 = 1'h0;
      7'h6f: sel963 = 1'h1;
      7'h67: sel963 = 1'h1;
      default: sel963 = 1'h0;
    endcase
  end
  assign sel964 = lt811 ? 20'h7b : 20'h7b;
  assign sel965 = (proxy553 == 3'h0) ? sel964 : 20'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel966 = 20'h7b;
      7'h33: sel966 = 20'h7b;
      7'h23: sel966 = 20'h7b;
      7'h03: sel966 = 20'h7b;
      7'h63: sel966 = 20'h7b;
      7'h73: sel966 = sel965;
      7'h37: sel966 = proxy854;
      7'h17: sel966 = proxy854;
      7'h6f: sel966 = 20'h7b;
      7'h67: sel966 = 20'h7b;
      default: sel966 = 20'h7b;
    endcase
  end
  assign sel967 = lt811 ? 12'h7b : shr543[11:0];
  assign sel968 = (proxy553 == 3'h0) ? sel967 : shr543[11:0];
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel969 = 12'h7b;
      7'h33: sel969 = 12'h7b;
      7'h23: sel969 = 12'h7b;
      7'h03: sel969 = 12'h7b;
      7'h63: sel969 = 12'h7b;
      7'h73: sel969 = sel968;
      7'h37: sel969 = 12'h7b;
      7'h17: sel969 = 12'h7b;
      7'h6f: sel969 = 12'h7b;
      7'h67: sel969 = 12'h7b;
      default: sel969 = 12'h7b;
    endcase
  end
  assign eq979 = proxy560 == 7'h0;
  assign sel981 = eq979 ? 4'h0 : 4'h1;
  assign sel984 = eq580 ? 4'h0 : sel981;
  assign sel1001 = eq979 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy553)
      3'h0: sel1009 = sel984;
      3'h1: sel1009 = 4'h2;
      3'h2: sel1009 = 4'h3;
      3'h3: sel1009 = 4'h4;
      3'h4: sel1009 = 4'h5;
      3'h5: sel1009 = sel1001;
      3'h6: sel1009 = 4'h8;
      3'h7: sel1009 = 4'h9;
      default: sel1009 = 4'hf;
    endcase
  end
  assign proxy1011 = proxy553[1:0];
  assign eq1016 = proxy1011 == 2'h3;
  assign sel1018 = eq1016 ? 4'hf : 4'hf;
  assign eq1024 = proxy1011 == 2'h2;
  assign sel1026 = eq1024 ? 4'he : sel1018;
  assign eq1032 = proxy1011 == 2'h1;
  assign sel1034 = eq1032 ? 4'hd : sel1026;
  assign orl1038 = eq587 | eq575;
  assign sel1040 = orl1038 ? 4'h0 : sel1009;
  assign sel1042 = andl624 ? sel1034 : sel1040;
  assign sel1046 = eq612 ? 4'hc : sel1042;
  assign sel1050 = eq607 ? 4'hb : sel1046;
  assign lt1056 = sel960 < 3'h5;
  assign sel1058 = lt1056 ? 4'h1 : 4'ha;
  assign sel1060 = eq592 ? sel1058 : sel1050;

  assign io_out_csr_address = sel969;
  assign io_out_is_csr = sel950;
  assign io_out_csr_data = sel665;
  assign io_out_csr_mask = sel659;
  assign io_out_rd = proxy532;
  assign io_out_rs1 = proxy539;
  assign io_out_rd1 = sel649;
  assign io_out_rs2 = proxy546;
  assign io_out_rd2 = sel655;
  assign io_out_wb = sel692;
  assign io_out_alu_op = sel1060;
  assign io_out_rs2_src = sel699;
  assign io_out_itype_immed = sel947;
  assign io_out_mem_read = sel703;
  assign io_out_mem_write = sel706;
  assign io_out_branch_type = sel960;
  assign io_out_branch_stall = sel953;
  assign io_out_jal = sel963;
  assign io_out_jal_offset = sel956;
  assign io_out_upper_immed = sel966;
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
  reg[4:0] reg1262, reg1271, reg1284;
  reg[31:0] reg1278, reg1290, reg1310, reg1369, reg1375, reg1381, reg1393;
  reg[3:0] reg1297;
  reg[1:0] reg1304;
  reg reg1317, reg1363, reg1387;
  reg[11:0] reg1324, reg1357;
  reg[2:0] reg1331, reg1337, reg1344;
  reg[19:0] reg1351;
  wire eq1397, eq1401, orl1403, sel1431, sel1453, sel1462;
  wire[4:0] sel1406, sel1409, sel1415;
  wire[31:0] sel1412, sel1418, sel1428, sel1456, sel1459, sel1465, sel1468;
  wire[3:0] sel1422;
  wire[1:0] sel1425;
  wire[11:0] sel1435, sel1450;
  wire[2:0] sel1438, sel1441, sel1444;
  wire[19:0] sel1447;

  always @ (posedge clk) begin
    if (reset)
      reg1262 <= 5'h0;
    else
      reg1262 <= sel1406;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1271 <= 5'h0;
    else
      reg1271 <= sel1409;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1278 <= 32'h0;
    else
      reg1278 <= sel1412;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1284 <= 5'h0;
    else
      reg1284 <= sel1415;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1290 <= 32'h0;
    else
      reg1290 <= sel1418;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1297 <= 4'h0;
    else
      reg1297 <= sel1422;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1304 <= 2'h0;
    else
      reg1304 <= sel1425;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1310 <= 32'h0;
    else
      reg1310 <= sel1428;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1317 <= 1'h0;
    else
      reg1317 <= sel1431;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1324 <= 12'h0;
    else
      reg1324 <= sel1435;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1331 <= 3'h7;
    else
      reg1331 <= sel1438;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1337 <= 3'h7;
    else
      reg1337 <= sel1441;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1344 <= 3'h0;
    else
      reg1344 <= sel1444;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1351 <= 20'h0;
    else
      reg1351 <= sel1447;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1357 <= 12'h0;
    else
      reg1357 <= sel1450;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1363 <= 1'h0;
    else
      reg1363 <= sel1453;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1369 <= 32'h0;
    else
      reg1369 <= sel1456;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1375 <= 32'h0;
    else
      reg1375 <= sel1459;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1381 <= 32'h0;
    else
      reg1381 <= sel1468;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1387 <= 1'h0;
    else
      reg1387 <= sel1462;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1393 <= 32'h0;
    else
      reg1393 <= sel1465;
  end
  assign eq1397 = io_in_branch_stall == 1'h1;
  assign eq1401 = io_in_fwd_stall == 1'h1;
  assign orl1403 = eq1401 | eq1397;
  assign sel1406 = orl1403 ? 5'h0 : io_in_rd;
  assign sel1409 = orl1403 ? 5'h0 : io_in_rs1;
  assign sel1412 = orl1403 ? 32'h0 : io_in_rd1;
  assign sel1415 = orl1403 ? 5'h0 : io_in_rs2;
  assign sel1418 = orl1403 ? 32'h0 : io_in_rd2;
  assign sel1422 = orl1403 ? 4'hf : io_in_alu_op;
  assign sel1425 = orl1403 ? 2'h0 : io_in_wb;
  assign sel1428 = orl1403 ? 32'h0 : io_in_PC_next;
  assign sel1431 = orl1403 ? 1'h0 : io_in_rs2_src;
  assign sel1435 = orl1403 ? 12'h7b : io_in_itype_immed;
  assign sel1438 = orl1403 ? 3'h7 : io_in_mem_read;
  assign sel1441 = orl1403 ? 3'h7 : io_in_mem_write;
  assign sel1444 = orl1403 ? 3'h0 : io_in_branch_type;
  assign sel1447 = orl1403 ? 20'h0 : io_in_upper_immed;
  assign sel1450 = orl1403 ? 12'h0 : io_in_csr_address;
  assign sel1453 = orl1403 ? 1'h0 : io_in_is_csr;
  assign sel1456 = orl1403 ? 32'h0 : io_in_csr_data;
  assign sel1459 = orl1403 ? 32'h0 : io_in_csr_mask;
  assign sel1462 = orl1403 ? 1'h0 : io_in_jal;
  assign sel1465 = orl1403 ? 32'h0 : io_in_jal_offset;
  assign sel1468 = orl1403 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1357;
  assign io_out_is_csr = reg1363;
  assign io_out_csr_data = reg1369;
  assign io_out_csr_mask = reg1375;
  assign io_out_rd = reg1262;
  assign io_out_rs1 = reg1271;
  assign io_out_rd1 = reg1278;
  assign io_out_rs2 = reg1284;
  assign io_out_rd2 = reg1290;
  assign io_out_alu_op = reg1297;
  assign io_out_wb = reg1304;
  assign io_out_rs2_src = reg1317;
  assign io_out_itype_immed = reg1324;
  assign io_out_mem_read = reg1331;
  assign io_out_mem_write = reg1337;
  assign io_out_branch_type = reg1344;
  assign io_out_upper_immed = reg1351;
  assign io_out_curr_PC = reg1381;
  assign io_out_jal = reg1387;
  assign io_out_jal_offset = reg1393;
  assign io_out_PC_next = reg1310;

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
  wire[31:0] pad1677, proxy1682, sel1690, sel1697, proxy1702, add1705, add1708, sub1713, shl1717, sel1727, sel1736, xorl1741, shr1745, shr1750, orl1755, andl1760, add1773, orl1779, sub1783, andl1786, sel1791;
  wire eq1688, eq1695, lt1725, lt1734, ge1764, ne1799, sel1801;
  reg[31:0] sel1790, sel1792;

  assign pad1677 = {{20{1'b0}}, io_in_itype_immed};
  assign proxy1682 = {20'hfffff, io_in_itype_immed};
  assign eq1688 = io_in_itype_immed[11] == 1'h1;
  assign sel1690 = eq1688 ? proxy1682 : pad1677;
  assign eq1695 = io_in_rs2_src == 1'h1;
  assign sel1697 = eq1695 ? sel1690 : io_in_rd2;
  assign proxy1702 = {io_in_upper_immed, 12'h0};
  assign add1705 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1708 = $signed(io_in_rd1) + $signed(sel1697);
  assign sub1713 = $signed(io_in_rd1) - $signed(sel1697);
  assign shl1717 = io_in_rd1 << sel1697;
  assign lt1725 = $signed(io_in_rd1) < $signed(sel1697);
  assign sel1727 = lt1725 ? 32'h1 : 32'h0;
  assign lt1734 = io_in_rd1 < sel1697;
  assign sel1736 = lt1734 ? 32'h1 : 32'h0;
  assign xorl1741 = io_in_rd1 ^ sel1697;
  assign shr1745 = io_in_rd1 >> sel1697;
  assign shr1750 = $signed(io_in_rd1) >> sel1697;
  assign orl1755 = io_in_rd1 | sel1697;
  assign andl1760 = sel1697 & io_in_rd1;
  assign ge1764 = io_in_rd1 >= sel1697;
  assign add1773 = $signed(io_in_curr_PC) + $signed(proxy1702);
  assign orl1779 = io_in_csr_data | io_in_csr_mask;
  assign sub1783 = 32'hffffffff - io_in_csr_mask;
  assign andl1786 = io_in_csr_data & sub1783;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1790 = 32'h7b;
      4'h1: sel1790 = 32'h7b;
      4'h2: sel1790 = 32'h7b;
      4'h3: sel1790 = 32'h7b;
      4'h4: sel1790 = 32'h7b;
      4'h5: sel1790 = 32'h7b;
      4'h6: sel1790 = 32'h7b;
      4'h7: sel1790 = 32'h7b;
      4'h8: sel1790 = 32'h7b;
      4'h9: sel1790 = 32'h7b;
      4'ha: sel1790 = 32'h7b;
      4'hb: sel1790 = 32'h7b;
      4'hc: sel1790 = 32'h7b;
      4'hd: sel1790 = io_in_csr_mask;
      4'he: sel1790 = orl1779;
      4'hf: sel1790 = andl1786;
      default: sel1790 = 32'h7b;
    endcase
  end
  assign sel1791 = ge1764 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1792 = add1708;
      4'h1: sel1792 = sub1713;
      4'h2: sel1792 = shl1717;
      4'h3: sel1792 = sel1727;
      4'h4: sel1792 = sel1736;
      4'h5: sel1792 = xorl1741;
      4'h6: sel1792 = shr1745;
      4'h7: sel1792 = shr1750;
      4'h8: sel1792 = orl1755;
      4'h9: sel1792 = andl1760;
      4'ha: sel1792 = sel1791;
      4'hb: sel1792 = proxy1702;
      4'hc: sel1792 = add1773;
      4'hd: sel1792 = io_in_csr_data;
      4'he: sel1792 = io_in_csr_data;
      4'hf: sel1792 = io_in_csr_data;
      default: sel1792 = 32'h0;
    endcase
  end
  assign ne1799 = io_in_branch_type != 3'h0;
  assign sel1801 = ne1799 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1790;
  assign io_out_alu_result = sel1792;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1705;
  assign io_out_branch_offset = sel1690;
  assign io_out_branch_stall = sel1801;
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
  reg[31:0] reg1988, reg2010, reg2022, reg2035, reg2068, reg2074, reg2080;
  reg[4:0] reg1998, reg2004, reg2016;
  reg[1:0] reg2029;
  reg[2:0] reg2042, reg2048, reg2086;
  reg[11:0] reg2055;
  reg reg2062;

  always @ (posedge clk) begin
    if (reset)
      reg1988 <= 32'h0;
    else
      reg1988 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1998 <= 5'h0;
    else
      reg1998 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2004 <= 5'h0;
    else
      reg2004 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2010 <= 32'h0;
    else
      reg2010 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2016 <= 5'h0;
    else
      reg2016 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2022 <= 32'h0;
    else
      reg2022 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2029 <= 2'h0;
    else
      reg2029 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2035 <= 32'h0;
    else
      reg2035 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2042 <= 3'h0;
    else
      reg2042 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2048 <= 3'h0;
    else
      reg2048 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2055 <= 12'h0;
    else
      reg2055 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2062 <= 1'h0;
    else
      reg2062 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2068 <= 32'h0;
    else
      reg2068 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2074 <= 32'h0;
    else
      reg2074 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2080 <= 32'h0;
    else
      reg2080 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2086 <= 3'h0;
    else
      reg2086 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg2055;
  assign io_out_is_csr = reg2062;
  assign io_out_csr_result = reg2068;
  assign io_out_alu_result = reg1988;
  assign io_out_rd = reg1998;
  assign io_out_wb = reg2029;
  assign io_out_rs1 = reg2004;
  assign io_out_rd1 = reg2010;
  assign io_out_rd2 = reg2022;
  assign io_out_rs2 = reg2016;
  assign io_out_mem_read = reg2042;
  assign io_out_mem_write = reg2048;
  assign io_out_curr_PC = reg2074;
  assign io_out_branch_offset = reg2080;
  assign io_out_branch_type = reg2086;
  assign io_out_PC_next = reg2035;

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
  wire lt2288, lt2291, orl2293, eq2301, eq2315, eq2319, andl2321, eq2342, eq2346, andl2348, orl2351, proxy2368, eq2369, proxy2386, eq2387;
  wire[1:0] sel2327, sel2331, sel2335;
  wire[7:0] proxy2360;
  wire[31:0] pad2361, proxy2364, sel2371, pad2379, proxy2382, sel2389;
  wire[15:0] proxy2378;
  reg[31:0] sel2405;

  assign lt2288 = io_in_mem_write < 3'h7;
  assign lt2291 = io_in_mem_read < 3'h7;
  assign orl2293 = lt2291 | lt2288;
  assign eq2301 = io_in_mem_write == 3'h2;
  assign eq2315 = io_in_mem_write == 3'h7;
  assign eq2319 = io_in_mem_read == 3'h7;
  assign andl2321 = eq2319 & eq2315;
  assign sel2327 = andl2321 ? 2'h0 : 2'h3;
  assign sel2331 = eq2301 ? 2'h2 : sel2327;
  assign sel2335 = lt2291 ? 2'h1 : sel2331;
  assign eq2342 = eq2301 == 1'h0;
  assign eq2346 = andl2321 == 1'h0;
  assign andl2348 = eq2346 & eq2342;
  assign orl2351 = lt2291 | andl2348;
  assign proxy2360 = io_DBUS_in_data_data[7:0];
  assign pad2361 = {{24{1'b0}}, proxy2360};
  assign proxy2364 = {24'hffffff, proxy2360};
  assign proxy2368 = proxy2360[7];
  assign eq2369 = proxy2368 == 1'h1;
  assign sel2371 = eq2369 ? proxy2364 : pad2361;
  assign proxy2378 = io_DBUS_in_data_data[15:0];
  assign pad2379 = {{16{1'b0}}, proxy2378};
  assign proxy2382 = {16'hffff, proxy2378};
  assign proxy2386 = proxy2378[15];
  assign eq2387 = proxy2386 == 1'h1;
  assign sel2389 = eq2387 ? proxy2382 : pad2379;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2405 = sel2371;
      3'h1: sel2405 = sel2389;
      3'h2: sel2405 = io_DBUS_in_data_data;
      3'h4: sel2405 = pad2361;
      3'h5: sel2405 = pad2379;
      default: sel2405 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2351;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2288;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2293;
  assign io_DBUS_out_control_data = sel2335;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2405;

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
  wire[31:0] bindin2412, bindout2421, bindout2430, bindin2448, bindin2457, bindout2460, shl2463, add2465;
  wire bindin2415, bindout2418, bindout2424, bindin2427, bindout2433, bindin2436, bindout2442, bindin2445, eq2475, sel2477, sel2486, eq2493, sel2495, sel2504;
  wire[1:0] bindout2439;
  wire[2:0] bindin2451, bindin2454;
  reg sel2527;

  Cache __module10__(.io_DBUS_in_data_data(bindin2412), .io_DBUS_in_data_valid(bindin2415), .io_DBUS_out_data_ready(bindin2427), .io_DBUS_out_address_ready(bindin2436), .io_DBUS_out_control_ready(bindin2445), .io_in_address(bindin2448), .io_in_mem_read(bindin2451), .io_in_mem_write(bindin2454), .io_in_data(bindin2457), .io_DBUS_in_data_ready(bindout2418), .io_DBUS_out_data_data(bindout2421), .io_DBUS_out_data_valid(bindout2424), .io_DBUS_out_address_data(bindout2430), .io_DBUS_out_address_valid(bindout2433), .io_DBUS_out_control_data(bindout2439), .io_DBUS_out_control_valid(bindout2442), .io_out_data(bindout2460));
  assign bindin2412 = io_DBUS_in_data_data;
  assign bindin2415 = io_DBUS_in_data_valid;
  assign bindin2427 = io_DBUS_out_data_ready;
  assign bindin2436 = io_DBUS_out_address_ready;
  assign bindin2445 = io_DBUS_out_control_ready;
  assign bindin2448 = io_in_alu_result;
  assign bindin2451 = io_in_mem_read;
  assign bindin2454 = io_in_mem_write;
  assign bindin2457 = io_in_rd2;
  assign shl2463 = $signed(io_in_branch_offset) << 32'h1;
  assign add2465 = $signed(io_in_curr_PC) + $signed(shl2463);
  assign eq2475 = io_in_alu_result == 32'h0;
  assign sel2477 = eq2475 ? 1'h1 : 1'h0;
  assign sel2486 = eq2475 ? 1'h0 : 1'h1;
  assign eq2493 = io_in_alu_result[31] == 1'h0;
  assign sel2495 = eq2493 ? 1'h0 : 1'h1;
  assign sel2504 = eq2493 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2527 = sel2477;
      3'h2: sel2527 = sel2486;
      3'h3: sel2527 = sel2495;
      3'h4: sel2527 = sel2504;
      3'h5: sel2527 = sel2495;
      3'h6: sel2527 = sel2504;
      3'h0: sel2527 = 1'h0;
      default: sel2527 = 1'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = bindout2418;
  assign io_DBUS_out_data_data = bindout2421;
  assign io_DBUS_out_data_valid = bindout2424;
  assign io_DBUS_out_address_data = bindout2430;
  assign io_DBUS_out_address_valid = bindout2433;
  assign io_DBUS_out_control_data = bindout2439;
  assign io_DBUS_out_control_valid = bindout2442;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = bindout2460;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2527;
  assign io_out_branch_dest = add2465;
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
  reg[31:0] reg2665, reg2674, reg2706;
  reg[4:0] reg2681, reg2687, reg2693;
  reg[1:0] reg2700;

  always @ (posedge clk) begin
    if (reset)
      reg2665 <= 32'h0;
    else
      reg2665 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2674 <= 32'h0;
    else
      reg2674 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2681 <= 5'h0;
    else
      reg2681 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2687 <= 5'h0;
    else
      reg2687 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2693 <= 5'h0;
    else
      reg2693 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2700 <= 2'h0;
    else
      reg2700 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2706 <= 32'h0;
    else
      reg2706 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2665;
  assign io_out_mem_result = reg2674;
  assign io_out_rd = reg2681;
  assign io_out_wb = reg2700;
  assign io_out_rs1 = reg2687;
  assign io_out_rs2 = reg2693;
  assign io_out_PC_next = reg2706;

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
  wire eq2772, eq2777;
  wire[31:0] sel2779, sel2781;

  assign eq2772 = io_in_wb == 2'h3;
  assign eq2777 = io_in_wb == 2'h1;
  assign sel2779 = eq2777 ? io_in_alu_result : io_in_mem_result;
  assign sel2781 = eq2772 ? io_in_PC_next : sel2779;

  assign io_out_write_data = sel2781;
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
  wire eq2861, eq2865, eq2869, eq2874, eq2878, eq2882, eq2887, eq2891, ne2896, ne2901, eq2904, andl2906, andl2908, eq2913, ne2917, eq2924, andl2926, andl2928, andl2930, eq2934, ne2942, eq2949, andl2951, andl2953, andl2955, andl2957, orl2960, orl2962, ne2988, eq2991, andl2993, andl2995, eq2999, eq3010, andl3012, andl3014, andl3016, eq3020, eq3035, andl3037, andl3039, andl3041, andl3043, orl3046, orl3048, eq3068, andl3070, eq3074, eq3077, andl3079, andl3081, orl3084, orl3094, andl3096, sel3098;
  wire[31:0] sel2966, sel2968, sel2970, sel2972, sel2974, sel2976, sel2978, sel2980, sel3055, sel3061, sel3065, sel3087, sel3089;

  assign eq2861 = io_in_execute_wb == 2'h2;
  assign eq2865 = io_in_memory_wb == 2'h2;
  assign eq2869 = io_in_writeback_wb == 2'h2;
  assign eq2874 = io_in_execute_wb == 2'h3;
  assign eq2878 = io_in_memory_wb == 2'h3;
  assign eq2882 = io_in_writeback_wb == 2'h3;
  assign eq2887 = io_in_execute_is_csr == 1'h1;
  assign eq2891 = io_in_memory_is_csr == 1'h1;
  assign ne2896 = io_in_execute_wb != 2'h0;
  assign ne2901 = io_in_decode_src1 != 5'h0;
  assign eq2904 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2906 = eq2904 & ne2901;
  assign andl2908 = andl2906 & ne2896;
  assign eq2913 = andl2908 == 1'h0;
  assign ne2917 = io_in_memory_wb != 2'h0;
  assign eq2924 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2926 = eq2924 & ne2901;
  assign andl2928 = andl2926 & ne2917;
  assign andl2930 = andl2928 & eq2913;
  assign eq2934 = andl2930 == 1'h0;
  assign ne2942 = io_in_writeback_wb != 2'h0;
  assign eq2949 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2951 = eq2949 & ne2901;
  assign andl2953 = andl2951 & ne2942;
  assign andl2955 = andl2953 & eq2913;
  assign andl2957 = andl2955 & eq2934;
  assign orl2960 = andl2908 | andl2930;
  assign orl2962 = orl2960 | andl2957;
  assign sel2966 = eq2869 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2968 = eq2882 ? io_in_writeback_PC_next : sel2966;
  assign sel2970 = andl2957 ? sel2968 : 32'h7b;
  assign sel2972 = eq2865 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2974 = eq2878 ? io_in_memory_PC_next : sel2972;
  assign sel2976 = andl2930 ? sel2974 : sel2970;
  assign sel2978 = eq2874 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2980 = andl2908 ? sel2978 : sel2976;
  assign ne2988 = io_in_decode_src2 != 5'h0;
  assign eq2991 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2993 = eq2991 & ne2988;
  assign andl2995 = andl2993 & ne2896;
  assign eq2999 = andl2995 == 1'h0;
  assign eq3010 = io_in_decode_src2 == io_in_memory_dest;
  assign andl3012 = eq3010 & ne2988;
  assign andl3014 = andl3012 & ne2917;
  assign andl3016 = andl3014 & eq2999;
  assign eq3020 = andl3016 == 1'h0;
  assign eq3035 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl3037 = eq3035 & ne2988;
  assign andl3039 = andl3037 & ne2942;
  assign andl3041 = andl3039 & eq2999;
  assign andl3043 = andl3041 & eq3020;
  assign orl3046 = andl2995 | andl3016;
  assign orl3048 = orl3046 | andl3043;
  assign sel3055 = andl3043 ? sel2968 : 32'h7b;
  assign sel3061 = andl3016 ? sel2974 : sel3055;
  assign sel3065 = andl2995 ? sel2978 : sel3061;
  assign eq3068 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3070 = eq3068 & eq2887;
  assign eq3074 = andl3070 == 1'h0;
  assign eq3077 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3079 = eq3077 & eq2891;
  assign andl3081 = andl3079 & eq3074;
  assign orl3084 = andl3070 | andl3081;
  assign sel3087 = andl3081 ? io_in_memory_csr_result : 32'h7b;
  assign sel3089 = andl3070 ? io_in_execute_alu_result : sel3087;
  assign orl3094 = andl2908 | andl2995;
  assign andl3096 = orl3094 & eq2861;
  assign sel3098 = andl3096 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2962;
  assign io_out_src1_fwd_data = sel2980;
  assign io_out_src2_fwd = orl3048;
  assign io_out_src2_fwd_data = sel3065;
  assign io_out_csr_fwd = orl3084;
  assign io_out_csr_fwd_data = sel3089;
  assign io_out_fwd_stall = sel3098;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3202 [0:1];
  wire[31:0] mrport3204;

  initial begin
    mem3202[0] = 32'hdeadbeef;
    mem3202[1] = 32'hdeadbeef;
  end
  assign mrport3204 = mem3202[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = mrport3204;

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
  reg[3:0] reg3273, sel3363;
  wire eq3281, andl3366, eq3370, andl3374, eq3378, andl3382;
  wire[3:0] sel3287, sel3292, sel3298, sel3304, sel3314, sel3319, sel3323, sel3332, sel3338, sel3348, sel3353, sel3357, sel3364, sel3380, sel3381, sel3383;

  always @ (posedge clk) begin
    if (reset)
      reg3273 <= 4'h0;
    else
      reg3273 <= sel3383;
  end
  assign eq3281 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3287 = eq3281 ? 4'h0 : 4'h1;
  assign sel3292 = eq3281 ? 4'h2 : 4'h1;
  assign sel3298 = eq3281 ? 4'h9 : 4'h3;
  assign sel3304 = eq3281 ? 4'h5 : 4'h4;
  assign sel3314 = eq3281 ? 4'h8 : 4'h6;
  assign sel3319 = eq3281 ? 4'h7 : 4'h6;
  assign sel3323 = eq3281 ? 4'h4 : 4'h8;
  assign sel3332 = eq3281 ? 4'h0 : 4'ha;
  assign sel3338 = eq3281 ? 4'hc : 4'hb;
  assign sel3348 = eq3281 ? 4'hf : 4'hd;
  assign sel3353 = eq3281 ? 4'he : 4'hd;
  assign sel3357 = eq3281 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3273)
      4'h0: sel3363 = sel3287;
      4'h1: sel3363 = sel3292;
      4'h2: sel3363 = sel3298;
      4'h3: sel3363 = sel3304;
      4'h4: sel3363 = sel3304;
      4'h5: sel3363 = sel3314;
      4'h6: sel3363 = sel3319;
      4'h7: sel3363 = sel3323;
      4'h8: sel3363 = sel3292;
      4'h9: sel3363 = sel3332;
      4'ha: sel3363 = sel3338;
      4'hb: sel3363 = sel3338;
      4'hc: sel3363 = sel3348;
      4'hd: sel3363 = sel3353;
      4'he: sel3363 = sel3357;
      4'hf: sel3363 = sel3292;
      default: sel3363 = reg3273;
    endcase
  end
  assign sel3364 = io_JTAG_TAP_in_mode_select_valid ? sel3363 : 4'h0;
  assign andl3366 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_reset_valid;
  assign eq3370 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3374 = io_JTAG_TAP_in_mode_select_valid & io_JTAG_TAP_in_clock_valid;
  assign eq3378 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3380 = eq3370 ? 4'h0 : reg3273;
  assign sel3381 = andl3382 ? sel3364 : reg3273;
  assign andl3382 = andl3374 & eq3378;
  assign sel3383 = andl3366 ? sel3380 : sel3381;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3273;

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
  wire bindin3389, bindin3391, bindin3392, bindin3395, bindout3398, bindin3401, bindin3404, bindout3407, bindin3410, bindin3413, bindout3416, eq3453, eq3462, eq3467, eq3544, andl3545, sel3547, sel3553;
  wire[3:0] bindout3419;
  reg[31:0] reg3427, reg3434, reg3441, reg3448, sel3546;
  wire[31:0] sel3470, sel3472, shr3479, proxy3484, sel3539, sel3540, sel3541, sel3542, sel3543;
  wire[30:0] proxy3482;
  reg sel3552, sel3558;

  assign bindin3389 = clk;
  assign bindin3391 = reset;
  TAP __module16__(.clk(bindin3389), .reset(bindin3391), .io_JTAG_TAP_in_mode_select_data(bindin3392), .io_JTAG_TAP_in_mode_select_valid(bindin3395), .io_JTAG_TAP_in_clock_data(bindin3401), .io_JTAG_TAP_in_clock_valid(bindin3404), .io_JTAG_TAP_in_reset_data(bindin3410), .io_JTAG_TAP_in_reset_valid(bindin3413), .io_JTAG_TAP_in_mode_select_ready(bindout3398), .io_JTAG_TAP_in_clock_ready(bindout3407), .io_JTAG_TAP_in_reset_ready(bindout3416), .io_out_curr_state(bindout3419));
  assign bindin3392 = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign bindin3395 = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign bindin3401 = io_JTAG_JTAG_TAP_in_clock_data;
  assign bindin3404 = io_JTAG_JTAG_TAP_in_clock_valid;
  assign bindin3410 = io_JTAG_JTAG_TAP_in_reset_data;
  assign bindin3413 = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3427 <= 32'h0;
    else
      reg3427 <= sel3539;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3434 <= 32'h1234;
    else
      reg3434 <= sel3542;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3441 <= 32'h5678;
    else
      reg3441 <= sel3543;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3448 <= 32'h0;
    else
      reg3448 <= sel3546;
  end
  assign eq3453 = reg3427 == 32'h0;
  assign eq3462 = reg3427 == 32'h1;
  assign eq3467 = reg3427 == 32'h2;
  assign sel3470 = eq3467 ? reg3434 : 32'hdeadbeef;
  assign sel3472 = eq3462 ? reg3441 : sel3470;
  assign shr3479 = reg3448 >> 32'h1;
  assign proxy3482 = shr3479[30:0];
  assign proxy3484 = {io_JTAG_in_data_data, proxy3482};
  assign sel3539 = (bindout3419 == 4'hf) ? reg3448 : reg3427;
  assign sel3540 = eq3467 ? reg3448 : reg3434;
  assign sel3541 = eq3462 ? reg3434 : sel3540;
  assign sel3542 = (bindout3419 == 4'h8) ? sel3541 : reg3434;
  assign sel3543 = andl3545 ? reg3448 : reg3441;
  assign eq3544 = bindout3419 == 4'h8;
  assign andl3545 = eq3544 & eq3462;
  always @(*) begin
    case (bindout3419)
      4'h3: sel3546 = sel3472;
      4'h4: sel3546 = proxy3484;
      4'ha: sel3546 = reg3427;
      4'hb: sel3546 = proxy3484;
      default: sel3546 = reg3448;
    endcase
  end
  assign sel3547 = eq3453 ? 1'h1 : 1'h0;
  always @(*) begin
    case (bindout3419)
      4'h3: sel3552 = sel3547;
      4'h4: sel3552 = 1'h1;
      4'h8: sel3552 = sel3547;
      4'ha: sel3552 = sel3547;
      4'hb: sel3552 = 1'h1;
      4'hf: sel3552 = sel3547;
      default: sel3552 = sel3547;
    endcase
  end
  assign sel3553 = eq3453 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (bindout3419)
      4'h3: sel3558 = sel3553;
      4'h4: sel3558 = reg3448[0];
      4'h8: sel3558 = sel3553;
      4'ha: sel3558 = sel3553;
      4'hb: sel3558 = reg3448[0];
      4'hf: sel3558 = sel3553;
      default: sel3558 = sel3553;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = bindout3398;
  assign io_JTAG_JTAG_TAP_in_clock_ready = bindout3407;
  assign io_JTAG_JTAG_TAP_in_reset_ready = bindout3416;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3558;
  assign io_JTAG_out_data_valid = sel3552;

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
  reg[11:0] mem3614 [0:4095];
  reg[1:0] reg3623, sel3659;
  wire eq3635, eq3639, eq3657;
  reg sel3660;
  reg[11:0] sel3661, sel3662;
  wire[11:0] mrport3664;
  wire[31:0] pad3666;

  always @ (posedge clk) begin
    if (sel3660) begin
      mem3614[sel3662] <= sel3661;
    end
  end
  assign mrport3664 = mem3614[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (reset)
      reg3623 <= 2'h0;
    else
      reg3623 <= sel3659;
  end
  assign eq3635 = reg3623 == 2'h1;
  assign eq3639 = reg3623 == 2'h0;
  assign eq3657 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3639)
      sel3659 = 2'h1;
    else if (eq3635)
      sel3659 = 2'h3;
    else
      sel3659 = reg3623;
  end
  always @(*) begin
    if (eq3639)
      sel3660 = 1'h1;
    else if (eq3635)
      sel3660 = 1'h1;
    else
      sel3660 = eq3657;
  end
  always @(*) begin
    if (eq3639)
      sel3661 = 12'h0;
    else if (eq3635)
      sel3661 = 12'h0;
    else
      sel3661 = io_in_mem_csr_result[11:0];
  end
  always @(*) begin
    if (eq3639)
      sel3662 = 12'hf14;
    else if (eq3635)
      sel3662 = 12'h301;
    else
      sel3662 = io_in_mem_csr_address;
  end
  assign pad3666 = {{20{1'b0}}, mrport3664};

  assign io_out_decode_csr_data = pad3666;

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
  wire bindin159, bindin161, bindin165, bindout168, bindout174, bindin177, bindin180, bindin186, bindin189, bindin192, bindin195, bindin201, bindin279, bindin280, bindin290, bindin293, bindin296, bindin1065, bindin1066, bindin1076, bindin1088, bindin1094, bindin1100, bindout1112, bindout1142, bindout1157, bindout1160, bindin1473, bindin1474, bindin1496, bindin1514, bindin1517, bindin1526, bindin1538, bindout1547, bindout1577, bindout1598, bindin1827, bindin1851, bindin1860, bindout1872, bindout1905, bindout1914, bindin2091, bindin2092, bindin2126, bindout2144, bindin2534, bindout2537, bindout2543, bindin2546, bindout2552, bindin2555, bindout2561, bindin2564, bindout2624, bindin2711, bindin2712, bindin3124, bindin3148, bindout3172, bindout3178, bindout3184, bindout3190, bindin3209, bindin3212, bindout3215, bindout3218, bindin3562, bindin3563, bindin3564, bindin3567, bindout3570, bindin3573, bindin3576, bindout3579, bindin3582, bindin3585, bindout3588, bindin3591, bindin3594, bindout3597, bindout3600, bindout3603, bindin3606, bindin3671, bindin3672, bindin3679, orl3687, eq3692, eq3696, orl3698;
  wire[31:0] bindin162, bindout171, bindin183, bindin198, bindin204, bindout207, bindout210, bindout213, bindin281, bindin284, bindin287, bindout299, bindout302, bindout305, bindin1067, bindin1070, bindin1073, bindin1079, bindin1091, bindin1097, bindin1103, bindin1106, bindout1115, bindout1118, bindout1127, bindout1133, bindout1163, bindout1169, bindin1481, bindin1487, bindin1508, bindin1529, bindin1532, bindin1535, bindin1541, bindout1550, bindout1553, bindout1562, bindout1568, bindout1595, bindout1601, bindout1604, bindin1812, bindin1818, bindin1839, bindin1854, bindin1857, bindin1863, bindin1866, bindout1875, bindout1878, bindout1890, bindout1896, bindout1908, bindout1911, bindout1917, bindin2093, bindin2105, bindin2111, bindin2120, bindin2129, bindin2132, bindin2135, bindout2147, bindout2150, bindout2162, bindout2165, bindout2177, bindout2180, bindout2186, bindin2531, bindout2540, bindout2549, bindin2567, bindin2585, bindin2591, bindin2594, bindin2597, bindin2600, bindout2606, bindout2609, bindout2627, bindout2630, bindin2713, bindin2716, bindin2731, bindout2734, bindout2737, bindout2752, bindin2786, bindin2789, bindin2804, bindout2807, bindin3118, bindin3121, bindin3130, bindin3139, bindin3142, bindin3145, bindin3154, bindin3163, bindin3166, bindin3169, bindout3175, bindout3181, bindout3187, bindout3221, bindin3682, bindout3685;
  wire[4:0] bindin1082, bindout1121, bindout1124, bindout1130, bindin1475, bindin1478, bindin1484, bindout1556, bindout1559, bindout1565, bindin1806, bindin1809, bindin1815, bindout1881, bindout1887, bindout1893, bindin2096, bindin2102, bindin2108, bindout2153, bindout2159, bindout2168, bindin2576, bindin2582, bindin2588, bindout2612, bindout2618, bindout2621, bindin2719, bindin2725, bindin2728, bindout2740, bindout2746, bindout2749, bindin2792, bindin2798, bindin2801, bindout2810, bindin3103, bindin3106, bindin3112, bindin3133, bindin3157;
  wire[1:0] bindin1085, bindout1136, bindin1493, bindout1574, bindin1824, bindout1884, bindin2099, bindout2156, bindout2558, bindin2579, bindout2615, bindin2722, bindout2743, bindin2795, bindout2813, bindin3115, bindin3136, bindin3160;
  wire[11:0] bindout1109, bindout1145, bindin1499, bindin1523, bindout1544, bindout1580, bindin1830, bindin1848, bindout1869, bindin2123, bindout2141, bindin3109, bindin3127, bindin3151, bindin3673, bindin3676;
  wire[3:0] bindout1139, bindin1490, bindout1571, bindin1821;
  wire[2:0] bindout1148, bindout1151, bindout1154, bindin1502, bindin1505, bindin1511, bindout1583, bindout1586, bindout1589, bindin1833, bindin1836, bindin1842, bindout1899, bindout1902, bindin2114, bindin2117, bindin2138, bindout2171, bindout2174, bindout2183, bindin2570, bindin2573, bindin2603;
  wire[19:0] bindout1166, bindin1520, bindout1592, bindin1845;

  assign bindin159 = clk;
  assign bindin161 = reset;
  Fetch __module2__(.clk(bindin159), .reset(bindin161), .io_IBUS_in_data_data(bindin162), .io_IBUS_in_data_valid(bindin165), .io_IBUS_out_address_ready(bindin177), .io_in_branch_dir(bindin180), .io_in_branch_dest(bindin183), .io_in_branch_stall(bindin186), .io_in_fwd_stall(bindin189), .io_in_branch_stall_exe(bindin192), .io_in_jal(bindin195), .io_in_jal_dest(bindin198), .io_in_interrupt(bindin201), .io_in_interrupt_pc(bindin204), .io_IBUS_in_data_ready(bindout168), .io_IBUS_out_address_data(bindout171), .io_IBUS_out_address_valid(bindout174), .io_out_instruction(bindout207), .io_out_curr_PC(bindout210), .io_out_PC_next(bindout213));
  assign bindin162 = io_IBUS_in_data_data;
  assign bindin165 = io_IBUS_in_data_valid;
  assign bindin177 = io_IBUS_out_address_ready;
  assign bindin180 = bindout2624;
  assign bindin183 = bindout2627;
  assign bindin186 = bindout1157;
  assign bindin189 = bindout3190;
  assign bindin192 = bindout1914;
  assign bindin195 = bindout1905;
  assign bindin198 = bindout1908;
  assign bindin201 = bindout3218;
  assign bindin204 = bindout3221;
  assign bindin279 = clk;
  assign bindin280 = reset;
  F_D_Register __module3__(.clk(bindin279), .reset(bindin280), .io_in_instruction(bindin281), .io_in_PC_next(bindin284), .io_in_curr_PC(bindin287), .io_in_branch_stall(bindin290), .io_in_branch_stall_exe(bindin293), .io_in_fwd_stall(bindin296), .io_out_instruction(bindout299), .io_out_curr_PC(bindout302), .io_out_PC_next(bindout305));
  assign bindin281 = bindout207;
  assign bindin284 = bindout213;
  assign bindin287 = bindout210;
  assign bindin290 = bindout1157;
  assign bindin293 = bindout1914;
  assign bindin296 = bindout3190;
  assign bindin1065 = clk;
  assign bindin1066 = reset;
  Decode __module4__(.clk(bindin1065), .reset(bindin1066), .io_in_instruction(bindin1067), .io_in_PC_next(bindin1070), .io_in_curr_PC(bindin1073), .io_in_stall(bindin1076), .io_in_write_data(bindin1079), .io_in_rd(bindin1082), .io_in_wb(bindin1085), .io_in_src1_fwd(bindin1088), .io_in_src1_fwd_data(bindin1091), .io_in_src2_fwd(bindin1094), .io_in_src2_fwd_data(bindin1097), .io_in_csr_fwd(bindin1100), .io_in_csr_fwd_data(bindin1103), .io_in_csr_data(bindin1106), .io_out_csr_address(bindout1109), .io_out_is_csr(bindout1112), .io_out_csr_data(bindout1115), .io_out_csr_mask(bindout1118), .io_out_rd(bindout1121), .io_out_rs1(bindout1124), .io_out_rd1(bindout1127), .io_out_rs2(bindout1130), .io_out_rd2(bindout1133), .io_out_wb(bindout1136), .io_out_alu_op(bindout1139), .io_out_rs2_src(bindout1142), .io_out_itype_immed(bindout1145), .io_out_mem_read(bindout1148), .io_out_mem_write(bindout1151), .io_out_branch_type(bindout1154), .io_out_branch_stall(bindout1157), .io_out_jal(bindout1160), .io_out_jal_offset(bindout1163), .io_out_upper_immed(bindout1166), .io_out_PC_next(bindout1169));
  assign bindin1067 = bindout299;
  assign bindin1070 = bindout305;
  assign bindin1073 = bindout302;
  assign bindin1076 = orl3698;
  assign bindin1079 = bindout2807;
  assign bindin1082 = bindout2810;
  assign bindin1085 = bindout2813;
  assign bindin1088 = bindout3172;
  assign bindin1091 = bindout3175;
  assign bindin1094 = bindout3178;
  assign bindin1097 = bindout3181;
  assign bindin1100 = bindout3184;
  assign bindin1103 = bindout3187;
  assign bindin1106 = bindout3685;
  assign bindin1473 = clk;
  assign bindin1474 = reset;
  D_E_Register __module6__(.clk(bindin1473), .reset(bindin1474), .io_in_rd(bindin1475), .io_in_rs1(bindin1478), .io_in_rd1(bindin1481), .io_in_rs2(bindin1484), .io_in_rd2(bindin1487), .io_in_alu_op(bindin1490), .io_in_wb(bindin1493), .io_in_rs2_src(bindin1496), .io_in_itype_immed(bindin1499), .io_in_mem_read(bindin1502), .io_in_mem_write(bindin1505), .io_in_PC_next(bindin1508), .io_in_branch_type(bindin1511), .io_in_fwd_stall(bindin1514), .io_in_branch_stall(bindin1517), .io_in_upper_immed(bindin1520), .io_in_csr_address(bindin1523), .io_in_is_csr(bindin1526), .io_in_csr_data(bindin1529), .io_in_csr_mask(bindin1532), .io_in_curr_PC(bindin1535), .io_in_jal(bindin1538), .io_in_jal_offset(bindin1541), .io_out_csr_address(bindout1544), .io_out_is_csr(bindout1547), .io_out_csr_data(bindout1550), .io_out_csr_mask(bindout1553), .io_out_rd(bindout1556), .io_out_rs1(bindout1559), .io_out_rd1(bindout1562), .io_out_rs2(bindout1565), .io_out_rd2(bindout1568), .io_out_alu_op(bindout1571), .io_out_wb(bindout1574), .io_out_rs2_src(bindout1577), .io_out_itype_immed(bindout1580), .io_out_mem_read(bindout1583), .io_out_mem_write(bindout1586), .io_out_branch_type(bindout1589), .io_out_upper_immed(bindout1592), .io_out_curr_PC(bindout1595), .io_out_jal(bindout1598), .io_out_jal_offset(bindout1601), .io_out_PC_next(bindout1604));
  assign bindin1475 = bindout1121;
  assign bindin1478 = bindout1124;
  assign bindin1481 = bindout1127;
  assign bindin1484 = bindout1130;
  assign bindin1487 = bindout1133;
  assign bindin1490 = bindout1139;
  assign bindin1493 = bindout1136;
  assign bindin1496 = bindout1142;
  assign bindin1499 = bindout1145;
  assign bindin1502 = bindout1148;
  assign bindin1505 = bindout1151;
  assign bindin1508 = bindout1169;
  assign bindin1511 = bindout1154;
  assign bindin1514 = bindout3190;
  assign bindin1517 = bindout1914;
  assign bindin1520 = bindout1166;
  assign bindin1523 = bindout1109;
  assign bindin1526 = bindout1112;
  assign bindin1529 = bindout1115;
  assign bindin1532 = bindout1118;
  assign bindin1535 = bindout302;
  assign bindin1538 = bindout1160;
  assign bindin1541 = bindout1163;
  Execute __module7__(.io_in_rd(bindin1806), .io_in_rs1(bindin1809), .io_in_rd1(bindin1812), .io_in_rs2(bindin1815), .io_in_rd2(bindin1818), .io_in_alu_op(bindin1821), .io_in_wb(bindin1824), .io_in_rs2_src(bindin1827), .io_in_itype_immed(bindin1830), .io_in_mem_read(bindin1833), .io_in_mem_write(bindin1836), .io_in_PC_next(bindin1839), .io_in_branch_type(bindin1842), .io_in_upper_immed(bindin1845), .io_in_csr_address(bindin1848), .io_in_is_csr(bindin1851), .io_in_csr_data(bindin1854), .io_in_csr_mask(bindin1857), .io_in_jal(bindin1860), .io_in_jal_offset(bindin1863), .io_in_curr_PC(bindin1866), .io_out_csr_address(bindout1869), .io_out_is_csr(bindout1872), .io_out_csr_result(bindout1875), .io_out_alu_result(bindout1878), .io_out_rd(bindout1881), .io_out_wb(bindout1884), .io_out_rs1(bindout1887), .io_out_rd1(bindout1890), .io_out_rs2(bindout1893), .io_out_rd2(bindout1896), .io_out_mem_read(bindout1899), .io_out_mem_write(bindout1902), .io_out_jal(bindout1905), .io_out_jal_dest(bindout1908), .io_out_branch_offset(bindout1911), .io_out_branch_stall(bindout1914), .io_out_PC_next(bindout1917));
  assign bindin1806 = bindout1556;
  assign bindin1809 = bindout1559;
  assign bindin1812 = bindout1562;
  assign bindin1815 = bindout1565;
  assign bindin1818 = bindout1568;
  assign bindin1821 = bindout1571;
  assign bindin1824 = bindout1574;
  assign bindin1827 = bindout1577;
  assign bindin1830 = bindout1580;
  assign bindin1833 = bindout1583;
  assign bindin1836 = bindout1586;
  assign bindin1839 = bindout1604;
  assign bindin1842 = bindout1589;
  assign bindin1845 = bindout1592;
  assign bindin1848 = bindout1544;
  assign bindin1851 = bindout1547;
  assign bindin1854 = bindout1550;
  assign bindin1857 = bindout1553;
  assign bindin1860 = bindout1598;
  assign bindin1863 = bindout1601;
  assign bindin1866 = bindout1595;
  assign bindin2091 = clk;
  assign bindin2092 = reset;
  E_M_Register __module8__(.clk(bindin2091), .reset(bindin2092), .io_in_alu_result(bindin2093), .io_in_rd(bindin2096), .io_in_wb(bindin2099), .io_in_rs1(bindin2102), .io_in_rd1(bindin2105), .io_in_rs2(bindin2108), .io_in_rd2(bindin2111), .io_in_mem_read(bindin2114), .io_in_mem_write(bindin2117), .io_in_PC_next(bindin2120), .io_in_csr_address(bindin2123), .io_in_is_csr(bindin2126), .io_in_csr_result(bindin2129), .io_in_curr_PC(bindin2132), .io_in_branch_offset(bindin2135), .io_in_branch_type(bindin2138), .io_out_csr_address(bindout2141), .io_out_is_csr(bindout2144), .io_out_csr_result(bindout2147), .io_out_alu_result(bindout2150), .io_out_rd(bindout2153), .io_out_wb(bindout2156), .io_out_rs1(bindout2159), .io_out_rd1(bindout2162), .io_out_rd2(bindout2165), .io_out_rs2(bindout2168), .io_out_mem_read(bindout2171), .io_out_mem_write(bindout2174), .io_out_curr_PC(bindout2177), .io_out_branch_offset(bindout2180), .io_out_branch_type(bindout2183), .io_out_PC_next(bindout2186));
  assign bindin2093 = bindout1878;
  assign bindin2096 = bindout1881;
  assign bindin2099 = bindout1884;
  assign bindin2102 = bindout1887;
  assign bindin2105 = bindout1890;
  assign bindin2108 = bindout1893;
  assign bindin2111 = bindout1896;
  assign bindin2114 = bindout1899;
  assign bindin2117 = bindout1902;
  assign bindin2120 = bindout1917;
  assign bindin2123 = bindout1869;
  assign bindin2126 = bindout1872;
  assign bindin2129 = bindout1875;
  assign bindin2132 = bindout1595;
  assign bindin2135 = bindout1911;
  assign bindin2138 = bindout1589;
  Memory __module9__(.io_DBUS_in_data_data(bindin2531), .io_DBUS_in_data_valid(bindin2534), .io_DBUS_out_data_ready(bindin2546), .io_DBUS_out_address_ready(bindin2555), .io_DBUS_out_control_ready(bindin2564), .io_in_alu_result(bindin2567), .io_in_mem_read(bindin2570), .io_in_mem_write(bindin2573), .io_in_rd(bindin2576), .io_in_wb(bindin2579), .io_in_rs1(bindin2582), .io_in_rd1(bindin2585), .io_in_rs2(bindin2588), .io_in_rd2(bindin2591), .io_in_PC_next(bindin2594), .io_in_curr_PC(bindin2597), .io_in_branch_offset(bindin2600), .io_in_branch_type(bindin2603), .io_DBUS_in_data_ready(bindout2537), .io_DBUS_out_data_data(bindout2540), .io_DBUS_out_data_valid(bindout2543), .io_DBUS_out_address_data(bindout2549), .io_DBUS_out_address_valid(bindout2552), .io_DBUS_out_control_data(bindout2558), .io_DBUS_out_control_valid(bindout2561), .io_out_alu_result(bindout2606), .io_out_mem_result(bindout2609), .io_out_rd(bindout2612), .io_out_wb(bindout2615), .io_out_rs1(bindout2618), .io_out_rs2(bindout2621), .io_out_branch_dir(bindout2624), .io_out_branch_dest(bindout2627), .io_out_PC_next(bindout2630));
  assign bindin2531 = io_DBUS_in_data_data;
  assign bindin2534 = io_DBUS_in_data_valid;
  assign bindin2546 = io_DBUS_out_data_ready;
  assign bindin2555 = io_DBUS_out_address_ready;
  assign bindin2564 = io_DBUS_out_control_ready;
  assign bindin2567 = bindout2150;
  assign bindin2570 = bindout2171;
  assign bindin2573 = bindout2174;
  assign bindin2576 = bindout2153;
  assign bindin2579 = bindout2156;
  assign bindin2582 = bindout2159;
  assign bindin2585 = bindout2162;
  assign bindin2588 = bindout2168;
  assign bindin2591 = bindout2165;
  assign bindin2594 = bindout2186;
  assign bindin2597 = bindout2177;
  assign bindin2600 = bindout2180;
  assign bindin2603 = bindout2183;
  assign bindin2711 = clk;
  assign bindin2712 = reset;
  M_W_Register __module11__(.clk(bindin2711), .reset(bindin2712), .io_in_alu_result(bindin2713), .io_in_mem_result(bindin2716), .io_in_rd(bindin2719), .io_in_wb(bindin2722), .io_in_rs1(bindin2725), .io_in_rs2(bindin2728), .io_in_PC_next(bindin2731), .io_out_alu_result(bindout2734), .io_out_mem_result(bindout2737), .io_out_rd(bindout2740), .io_out_wb(bindout2743), .io_out_rs1(bindout2746), .io_out_rs2(bindout2749), .io_out_PC_next(bindout2752));
  assign bindin2713 = bindout2606;
  assign bindin2716 = bindout2609;
  assign bindin2719 = bindout2612;
  assign bindin2722 = bindout2615;
  assign bindin2725 = bindout2618;
  assign bindin2728 = bindout2621;
  assign bindin2731 = bindout2630;
  Write_Back __module12__(.io_in_alu_result(bindin2786), .io_in_mem_result(bindin2789), .io_in_rd(bindin2792), .io_in_wb(bindin2795), .io_in_rs1(bindin2798), .io_in_rs2(bindin2801), .io_in_PC_next(bindin2804), .io_out_write_data(bindout2807), .io_out_rd(bindout2810), .io_out_wb(bindout2813));
  assign bindin2786 = bindout2734;
  assign bindin2789 = bindout2737;
  assign bindin2792 = bindout2740;
  assign bindin2795 = bindout2743;
  assign bindin2798 = bindout2746;
  assign bindin2801 = bindout2749;
  assign bindin2804 = bindout2752;
  Forwarding __module13__(.io_in_decode_src1(bindin3103), .io_in_decode_src2(bindin3106), .io_in_decode_csr_address(bindin3109), .io_in_execute_dest(bindin3112), .io_in_execute_wb(bindin3115), .io_in_execute_alu_result(bindin3118), .io_in_execute_PC_next(bindin3121), .io_in_execute_is_csr(bindin3124), .io_in_execute_csr_address(bindin3127), .io_in_execute_csr_result(bindin3130), .io_in_memory_dest(bindin3133), .io_in_memory_wb(bindin3136), .io_in_memory_alu_result(bindin3139), .io_in_memory_mem_data(bindin3142), .io_in_memory_PC_next(bindin3145), .io_in_memory_is_csr(bindin3148), .io_in_memory_csr_address(bindin3151), .io_in_memory_csr_result(bindin3154), .io_in_writeback_dest(bindin3157), .io_in_writeback_wb(bindin3160), .io_in_writeback_alu_result(bindin3163), .io_in_writeback_mem_data(bindin3166), .io_in_writeback_PC_next(bindin3169), .io_out_src1_fwd(bindout3172), .io_out_src1_fwd_data(bindout3175), .io_out_src2_fwd(bindout3178), .io_out_src2_fwd_data(bindout3181), .io_out_csr_fwd(bindout3184), .io_out_csr_fwd_data(bindout3187), .io_out_fwd_stall(bindout3190));
  assign bindin3103 = bindout1124;
  assign bindin3106 = bindout1130;
  assign bindin3109 = bindout1109;
  assign bindin3112 = bindout1881;
  assign bindin3115 = bindout1884;
  assign bindin3118 = bindout1878;
  assign bindin3121 = bindout1917;
  assign bindin3124 = bindout1872;
  assign bindin3127 = bindout1869;
  assign bindin3130 = bindout1875;
  assign bindin3133 = bindout2612;
  assign bindin3136 = bindout2615;
  assign bindin3139 = bindout2606;
  assign bindin3142 = bindout2609;
  assign bindin3145 = bindout2630;
  assign bindin3148 = bindout2144;
  assign bindin3151 = bindout2141;
  assign bindin3154 = bindout2147;
  assign bindin3157 = bindout2740;
  assign bindin3160 = bindout2743;
  assign bindin3163 = bindout2734;
  assign bindin3166 = bindout2737;
  assign bindin3169 = bindout2752;
  Interrupt_Handler __module14__(.io_INTERRUPT_in_interrupt_id_data(bindin3209), .io_INTERRUPT_in_interrupt_id_valid(bindin3212), .io_INTERRUPT_in_interrupt_id_ready(bindout3215), .io_out_interrupt(bindout3218), .io_out_interrupt_pc(bindout3221));
  assign bindin3209 = io_INTERRUPT_in_interrupt_id_data;
  assign bindin3212 = io_INTERRUPT_in_interrupt_id_valid;
  assign bindin3562 = clk;
  assign bindin3563 = reset;
  JTAG __module15__(.clk(bindin3562), .reset(bindin3563), .io_JTAG_JTAG_TAP_in_mode_select_data(bindin3564), .io_JTAG_JTAG_TAP_in_mode_select_valid(bindin3567), .io_JTAG_JTAG_TAP_in_clock_data(bindin3573), .io_JTAG_JTAG_TAP_in_clock_valid(bindin3576), .io_JTAG_JTAG_TAP_in_reset_data(bindin3582), .io_JTAG_JTAG_TAP_in_reset_valid(bindin3585), .io_JTAG_in_data_data(bindin3591), .io_JTAG_in_data_valid(bindin3594), .io_JTAG_out_data_ready(bindin3606), .io_JTAG_JTAG_TAP_in_mode_select_ready(bindout3570), .io_JTAG_JTAG_TAP_in_clock_ready(bindout3579), .io_JTAG_JTAG_TAP_in_reset_ready(bindout3588), .io_JTAG_in_data_ready(bindout3597), .io_JTAG_out_data_data(bindout3600), .io_JTAG_out_data_valid(bindout3603));
  assign bindin3564 = io_jtag_JTAG_TAP_in_mode_select_data;
  assign bindin3567 = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign bindin3573 = io_jtag_JTAG_TAP_in_clock_data;
  assign bindin3576 = io_jtag_JTAG_TAP_in_clock_valid;
  assign bindin3582 = io_jtag_JTAG_TAP_in_reset_data;
  assign bindin3585 = io_jtag_JTAG_TAP_in_reset_valid;
  assign bindin3591 = io_jtag_in_data_data;
  assign bindin3594 = io_jtag_in_data_valid;
  assign bindin3606 = io_jtag_out_data_ready;
  assign bindin3671 = clk;
  assign bindin3672 = reset;
  CSR_Handler __module17__(.clk(bindin3671), .reset(bindin3672), .io_in_decode_csr_address(bindin3673), .io_in_mem_csr_address(bindin3676), .io_in_mem_is_csr(bindin3679), .io_in_mem_csr_result(bindin3682), .io_out_decode_csr_data(bindout3685));
  assign bindin3673 = bindout1109;
  assign bindin3676 = bindout2141;
  assign bindin3679 = bindout2144;
  assign bindin3682 = bindout2147;
  assign orl3687 = bindout1157 | bindout1914;
  assign eq3692 = bindout1914 == 1'h1;
  assign eq3696 = bindout3190 == 1'h1;
  assign orl3698 = eq3696 | eq3692;

  assign io_IBUS_in_data_ready = bindout168;
  assign io_IBUS_out_address_data = bindout171;
  assign io_IBUS_out_address_valid = bindout174;
  assign io_DBUS_in_data_ready = bindout2537;
  assign io_DBUS_out_data_data = bindout2540;
  assign io_DBUS_out_data_valid = bindout2543;
  assign io_DBUS_out_address_data = bindout2549;
  assign io_DBUS_out_address_valid = bindout2552;
  assign io_DBUS_out_control_data = bindout2558;
  assign io_DBUS_out_control_valid = bindout2561;
  assign io_INTERRUPT_in_interrupt_id_ready = bindout3215;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = bindout3570;
  assign io_jtag_JTAG_TAP_in_clock_ready = bindout3579;
  assign io_jtag_JTAG_TAP_in_reset_ready = bindout3588;
  assign io_jtag_in_data_ready = bindout3597;
  assign io_jtag_out_data_data = bindout3600;
  assign io_jtag_out_data_valid = bindout3603;
  assign io_out_fwd_stall = bindout3190;
  assign io_out_branch_stall = orl3687;

endmodule
