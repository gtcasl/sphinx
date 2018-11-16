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
  reg[31:0] reg112; // fetch.h(38:0)
  wire eq120; // fetch.h(41:1)
  wire eq124; // fetch.h(41:3)
  wire orl126; // fetch.h(41:3)
  wire orl128; // fetch.h(41:3)
  wire[31:0] sel131; // fetch.h(42:0)
  wire eq135; // fetch.h(45:3)
  wire[31:0] sel137; // fetch.h(45:1)
  wire eq141; // fetch.h(45:5)
  wire[31:0] sel143; // fetch.h(45:0)
  wire[31:0] sel145; // fetch.h(46:0)
  wire[31:0] add150; // fetch.h(46:0)
  wire[31:0] sel152; // fetch.h(54:0)

  always @ (posedge clk) begin
    if (reset)
      reg112 <= 32'h0;
    else
      reg112 <= sel152;
  end
  assign eq120 = io_in_fwd_stall == 1'h1;
  assign eq124 = io_in_branch_stall == 1'h1;
  assign orl126 = eq124 || eq120;
  assign orl128 = orl126 || io_in_branch_stall_exe;
  assign sel131 = orl128 ? 32'h0 : io_IBUS_in_data_data;
  assign eq135 = io_in_branch_dir == 1'h1;
  assign sel137 = eq135 ? io_in_branch_dest : reg112;
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
  reg[31:0] reg234; // f_d_register.h(28:0)
  reg[31:0] reg243; // f_d_register.h(29:0)
  reg[31:0] reg249; // f_d_register.h(30:0)
  wire eq271; // f_d_register.h(39:2)
  wire[31:0] sel273; // f_d_register.h(39:0)
  wire[31:0] sel274; // f_d_register.h(39:0)
  wire[31:0] sel275; // f_d_register.h(39:0)

  always @ (posedge clk) begin
    if (reset)
      reg234 <= 32'h0;
    else
      reg234 <= sel274;
  end
  always @ (posedge clk) begin
    if (reset)
      reg243 <= 32'h0;
    else
      reg243 <= sel275;
  end
  always @ (posedge clk) begin
    if (reset)
      reg249 <= 32'h0;
    else
      reg249 <= sel273;
  end
  assign eq271 = io_in_fwd_stall == 1'h0;
  assign sel273 = eq271 ? io_in_curr_PC : reg249;
  assign sel274 = eq271 ? io_in_instruction : reg234;
  assign sel275 = eq271 ? io_in_PC_next : reg243;

  assign io_out_instruction = reg234;
  assign io_out_curr_PC = reg249;
  assign io_out_PC_next = reg243;

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
  reg[31:0] mem394 [0:31]; // decode.h(36:0)
  reg reg400; // decode.h(40:0)
  wire eq407; // decode.h(42:2)
  wire sel411; // decode.h(42:0)
  wire ne424; // decode.h(21:0)
  wire andl427; // decode.h(62:1)
  wire sel429; // decode.h(53:0)
  wire[31:0] sel430; // decode.h(53:0)
  wire[4:0] sel431; // decode.h(53:0)
  wire[31:0] marport433; // decode.h(67:1)
  wire eq437; // decode.h(21:0)
  wire[31:0] sel439; // decode.h(67:0)
  wire[31:0] marport441; // decode.h(68:1)
  wire eq445; // decode.h(21:0)
  wire[31:0] sel447; // decode.h(68:0)

  assign marport433 = mem394[io_in_src1];
  assign marport441 = mem394[io_in_src2];
  always @ (posedge clk) begin
    if (sel429) begin
      mem394[sel431] <= sel430;
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg400 <= 1'h1;
    else
      reg400 <= sel411;
  end
  assign eq407 = reg400 == 1'h1;
  assign sel411 = eq407 ? 1'h0 : reg400;
  assign ne424 = io_in_rd != 5'h0;
  assign andl427 = io_in_write_register && ne424;
  assign sel429 = reg400 ? 1'h1 : andl427;
  assign sel430 = reg400 ? 32'h0 : io_in_data;
  assign sel431 = reg400 ? 5'h0 : io_in_rd;
  assign eq437 = io_in_src1 == 5'h0;
  assign sel439 = eq437 ? 32'h0 : marport433;
  assign eq445 = io_in_src2 == 5'h0;
  assign sel447 = eq445 ? 32'h0 : marport441;

  assign io_out_src1_data = sel439;
  assign io_out_src2_data = sel447;

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
  wire RegisterFile451_clk; // decode.h(109:1)
  wire RegisterFile451_reset; // decode.h(109:1)
  wire RegisterFile451_io_in_write_register; // decode.h(109:1)
  wire[4:0] RegisterFile451_io_in_rd; // decode.h(109:1)
  wire[31:0] RegisterFile451_io_in_data; // decode.h(109:1)
  wire[4:0] RegisterFile451_io_in_src1; // decode.h(109:1)
  wire[4:0] RegisterFile451_io_in_src2; // decode.h(109:1)
  wire[31:0] RegisterFile451_io_out_src1_data; // decode.h(109:1)
  wire[31:0] RegisterFile451_io_out_src2_data; // decode.h(109:1)
  wire ne516; // decode.h(109:0)
  wire sel518; // decode.h(182:0)
  wire[31:0] shr525; // decode.h(187:1)
  wire[31:0] shr532; // decode.h(188:1)
  wire[31:0] shr539; // decode.h(189:1)
  wire[4:0] proxy542; // decode.h(189:0)
  wire[31:0] shr546; // decode.h(190:1)
  wire[31:0] shr553; // decode.h(191:1)
  wire eq566; // decode.h(208:1)
  wire eq571; // decode.h(209:1)
  wire eq576; // decode.h(210:1)
  wire orl578; // decode.h(210:1)
  wire eq583; // decode.h(211:1)
  wire eq588; // decode.h(212:1)
  wire eq593; // decode.h(213:1)
  wire eq598; // decode.h(214:1)
  wire eq603; // decode.h(215:1)
  wire eq608; // decode.h(216:1)
  wire ne613; // decode.h(217:1)
  wire eq618; // decode.h(217:3)
  wire andl620; // decode.h(217:3)
  wire eq624; // decode.h(218:1)
  wire andl627; // decode.h(218:2)
  wire eq631; // decode.h(219:1)
  wire andl637; // decode.h(219:3)
  wire eq641; // decode.h(225:3)
  wire[31:0] sel643; // decode.h(225:1)
  wire[31:0] sel645; // decode.h(225:0)
  wire eq649; // decode.h(226:2)
  wire[31:0] sel651; // decode.h(226:0)
  wire[31:0] pad653; // decode.h(231:1)
  wire[31:0] sel654; // decode.h(231:0)
  wire eq657; // decode.h(109:0)
  wire[31:0] sel659; // decode.h(232:0)
  wire orl665; // decode.h(237:1)
  wire orl667; // decode.h(237:1)
  wire orl669; // decode.h(237:1)
  wire orl671; // decode.h(237:1)
  wire[1:0] sel673; // decode.h(238:2)
  wire[1:0] sel677; // decode.h(238:1)
  wire orl682; // decode.h(235:1)
  wire orl684; // decode.h(235:1)
  wire[1:0] sel686; // decode.h(238:0)
  wire orl691; // decode.h(239:3)
  wire sel693; // decode.h(239:0)
  wire[2:0] sel697; // decode.h(241:0)
  wire[2:0] sel700; // decode.h(242:0)
  wire eq715; // decode.h(264:1)
  wire eq720; // decode.h(264:3)
  wire orl722; // decode.h(264:3)
  wire[11:0] pad724; // decode.h(265:0)
  wire[11:0] sel731; // decode.h(267:0)
  wire[11:0] proxy749; // decode.h(292:0)
  wire[31:0] shr777; // decode.h(321:1)
  wire[11:0] proxy788; // decode.h(324:0)
  wire lt806; // decode.h(192:0)
  wire[19:0] proxy849; // decode.h(413:0)
  wire[31:0] shr883; // decode.h(441:1)
  wire[20:0] proxy891; // decode.h(446:0)
  wire[31:0] pad897; // decode.h(448:1)
  wire[31:0] proxy901; // decode.h(448:2)
  wire eq905; // decode.h(442:0)
  wire[31:0] sel907; // decode.h(448:0)
  wire[11:0] proxy917; // decode.h(464:0)
  wire[31:0] pad919; // decode.h(465:1)
  wire[31:0] proxy923; // decode.h(465:2)
  wire eq928; // decode.h(465:5)
  wire[31:0] sel930; // decode.h(465:0)
  wire[11:0] sel940; // decode.h(371:0)
  wire[11:0] sel941; // decode.h(368:0)
  reg[11:0] sel942; // decode.h(253:0)
  wire sel943; // decode.h(371:0)
  wire sel944; // decode.h(368:0)
  reg sel945; // decode.h(253:0)
  wire sel946; // decode.h(371:0)
  wire sel947; // decode.h(368:0)
  reg sel948; // decode.h(253:0)
  reg[2:0] sel949; // decode.h(328:0)
  wire[2:0] sel950; // decode.h(371:0)
  wire[2:0] sel951; // decode.h(368:0)
  reg[2:0] sel952; // decode.h(253:0)
  wire sel953; // decode.h(371:0)
  wire sel954; // decode.h(368:0)
  reg sel955; // decode.h(253:0)
  wire[31:0] sel956; // decode.h(371:0)
  wire[31:0] sel957; // decode.h(368:0)
  reg[31:0] sel958; // decode.h(253:0)
  wire[19:0] sel959; // decode.h(371:0)
  wire[19:0] sel960; // decode.h(368:0)
  reg[19:0] sel961; // decode.h(253:0)
  wire[11:0] sel962; // decode.h(371:0)
  wire[11:0] sel963; // decode.h(368:0)
  reg[11:0] sel964; // decode.h(253:0)
  wire eq974; // decode.h(191:0)
  wire[3:0] sel976; // decode.h(487:1)
  wire[3:0] sel979; // decode.h(487:0)
  wire[3:0] sel996; // decode.h(507:0)
  reg[3:0] sel1004; // decode.h(483:0)
  wire eq1011; // decode.h(525:2)
  wire[3:0] sel1013; // decode.h(526:2)
  wire eq1019; // decode.h(524:2)
  wire[3:0] sel1021; // decode.h(526:1)
  wire eq1027; // decode.h(523:2)
  wire[3:0] sel1029; // decode.h(526:0)
  wire orl1033; // decode.h(532:6)
  wire[3:0] sel1035; // decode.h(532:4)
  wire[3:0] sel1037; // decode.h(532:3)
  wire[3:0] sel1041; // decode.h(532:2)
  wire[3:0] sel1045; // decode.h(532:1)
  wire lt1051; // decode.h(109:0)
  wire[3:0] sel1053; // decode.h(528:0)
  wire[3:0] sel1055; // decode.h(532:0)

  assign RegisterFile451_clk = clk;
  assign RegisterFile451_reset = reset;
  RegisterFile RegisterFile451(.clk(RegisterFile451_clk), .reset(RegisterFile451_reset), .io_in_write_register(RegisterFile451_io_in_write_register), .io_in_rd(RegisterFile451_io_in_rd), .io_in_data(RegisterFile451_io_in_data), .io_in_src1(RegisterFile451_io_in_src1), .io_in_src2(RegisterFile451_io_in_src2), .io_out_src1_data(RegisterFile451_io_out_src1_data), .io_out_src2_data(RegisterFile451_io_out_src2_data));
  assign RegisterFile451_io_in_write_register = sel518;
  assign RegisterFile451_io_in_rd = io_in_rd;
  assign RegisterFile451_io_in_data = io_in_write_data;
  assign RegisterFile451_io_in_src1 = shr532[4:0];
  assign RegisterFile451_io_in_src2 = proxy542;
  assign ne516 = io_in_wb != 2'h0;
  assign sel518 = ne516 ? 1'h1 : 1'h0;
  assign shr525 = io_in_instruction >> 32'h7;
  assign shr532 = io_in_instruction >> 32'hf;
  assign shr539 = io_in_instruction >> 32'h14;
  assign proxy542 = shr539[4:0];
  assign shr546 = io_in_instruction >> 32'hc;
  assign shr553 = io_in_instruction >> 32'h19;
  assign eq566 = io_in_instruction[6:0] == 7'h33;
  assign eq571 = io_in_instruction[6:0] == 7'h3;
  assign eq576 = io_in_instruction[6:0] == 7'h13;
  assign orl578 = eq576 || eq571;
  assign eq583 = io_in_instruction[6:0] == 7'h23;
  assign eq588 = io_in_instruction[6:0] == 7'h63;
  assign eq593 = io_in_instruction[6:0] == 7'h6f;
  assign eq598 = io_in_instruction[6:0] == 7'h67;
  assign eq603 = io_in_instruction[6:0] == 7'h37;
  assign eq608 = io_in_instruction[6:0] == 7'h17;
  assign ne613 = shr546[2:0] != 3'h0;
  assign eq618 = io_in_instruction[6:0] == 7'h73;
  assign andl620 = eq618 && ne613;
  assign eq624 = shr546[2] == 1'h1;
  assign andl627 = andl620 && eq624;
  assign eq631 = shr546[2:0] == 3'h0;
  assign andl637 = eq618 && eq631;
  assign eq641 = io_in_src1_fwd == 1'h1;
  assign sel643 = eq641 ? io_in_src1_fwd_data : RegisterFile451_io_out_src1_data;
  assign sel645 = eq593 ? io_in_curr_PC : sel643;
  assign eq649 = io_in_src2_fwd == 1'h1;
  assign sel651 = eq649 ? io_in_src2_fwd_data : RegisterFile451_io_out_src2_data;
  assign pad653 = {{27{1'b0}}, proxy542};
  assign sel654 = andl627 ? pad653 : sel651;
  assign eq657 = io_in_csr_fwd == 1'h1;
  assign sel659 = eq657 ? io_in_csr_fwd_data : io_in_csr_data;
  assign orl665 = orl578 || eq566;
  assign orl667 = orl665 || eq603;
  assign orl669 = orl667 || eq608;
  assign orl671 = orl669 || andl620;
  assign sel673 = orl671 ? 2'h1 : 2'h0;
  assign sel677 = eq571 ? 2'h2 : sel673;
  assign orl682 = eq593 || eq598;
  assign orl684 = orl682 || andl637;
  assign sel686 = orl684 ? 2'h3 : sel677;
  assign orl691 = orl578 || eq583;
  assign sel693 = orl691 ? 1'h1 : 1'h0;
  assign sel697 = eq571 ? shr546[2:0] : 3'h7;
  assign sel700 = eq583 ? shr546[2:0] : 3'h7;
  assign eq715 = shr546[2:0] == 3'h5;
  assign eq720 = shr546[2:0] == 3'h1;
  assign orl722 = eq720 || eq715;
  assign pad724 = {{7{1'b0}}, proxy542};
  assign sel731 = orl722 ? pad724 : shr539[11:0];
  assign proxy749 = {shr553[6:0], shr525[4:0]};
  assign shr777 = io_in_instruction >> 32'h8;
  assign proxy788 = {io_in_instruction[31], io_in_instruction[7], shr553[5:0], shr777[3:0]};
  assign lt806 = shr539[11:0] < 12'h2;
  assign proxy849 = {shr553[6:0], shr539[4:0], shr532[4:0], shr546[2:0]};
  assign shr883 = io_in_instruction >> 32'h15;
  assign proxy891 = {io_in_instruction[31], shr546[7:0], io_in_instruction[20], shr883[9:0], 1'h0};
  assign pad897 = {{11{1'b0}}, proxy891};
  assign proxy901 = {11'h7ff, io_in_instruction[31], shr546[7:0], io_in_instruction[20], shr883[9:0], 1'h0};
  assign eq905 = io_in_instruction[31] == 1'h1;
  assign sel907 = eq905 ? proxy901 : pad897;
  assign proxy917 = {shr553[6:0], shr539[4:0]};
  assign pad919 = {{20{1'b0}}, proxy917};
  assign proxy923 = {20'hfffff, shr553[6:0], shr539[4:0]};
  assign eq928 = shr553[6] == 1'h1;
  assign sel930 = eq928 ? proxy923 : pad919;
  assign sel940 = lt806 ? 12'h7b : 12'h7b;
  assign sel941 = (shr546[2:0] == 3'h0) ? sel940 : 12'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel942 = sel731;
      7'h33: sel942 = 12'h7b;
      7'h23: sel942 = proxy749;
      7'h03: sel942 = shr539[11:0];
      7'h63: sel942 = proxy788;
      7'h73: sel942 = sel941;
      7'h37: sel942 = 12'h7b;
      7'h17: sel942 = 12'h7b;
      7'h6f: sel942 = 12'h7b;
      7'h67: sel942 = 12'h7b;
      default: sel942 = 12'h7b;
    endcase
  end
  assign sel943 = lt806 ? 1'h0 : 1'h1;
  assign sel944 = (shr546[2:0] == 3'h0) ? sel943 : 1'h1;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel945 = 1'h0;
      7'h33: sel945 = 1'h0;
      7'h23: sel945 = 1'h0;
      7'h03: sel945 = 1'h0;
      7'h63: sel945 = 1'h0;
      7'h73: sel945 = sel944;
      7'h37: sel945 = 1'h0;
      7'h17: sel945 = 1'h0;
      7'h6f: sel945 = 1'h0;
      7'h67: sel945 = 1'h0;
      default: sel945 = 1'h0;
    endcase
  end
  assign sel946 = lt806 ? 1'h0 : 1'h0;
  assign sel947 = (shr546[2:0] == 3'h0) ? sel946 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel948 = 1'h0;
      7'h33: sel948 = 1'h0;
      7'h23: sel948 = 1'h0;
      7'h03: sel948 = 1'h0;
      7'h63: sel948 = 1'h1;
      7'h73: sel948 = sel947;
      7'h37: sel948 = 1'h0;
      7'h17: sel948 = 1'h0;
      7'h6f: sel948 = 1'h1;
      7'h67: sel948 = 1'h1;
      default: sel948 = 1'h0;
    endcase
  end
  always @(*) begin
    case (shr546[2:0])
      3'h0: sel949 = 3'h1;
      3'h1: sel949 = 3'h2;
      3'h4: sel949 = 3'h3;
      3'h5: sel949 = 3'h4;
      3'h6: sel949 = 3'h5;
      3'h7: sel949 = 3'h6;
      default: sel949 = 3'h0;
    endcase
  end
  assign sel950 = lt806 ? 3'h0 : 3'h0;
  assign sel951 = (shr546[2:0] == 3'h0) ? sel950 : 3'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel952 = 3'h0;
      7'h33: sel952 = 3'h0;
      7'h23: sel952 = 3'h0;
      7'h03: sel952 = 3'h0;
      7'h63: sel952 = sel949;
      7'h73: sel952 = sel951;
      7'h37: sel952 = 3'h0;
      7'h17: sel952 = 3'h0;
      7'h6f: sel952 = 3'h0;
      7'h67: sel952 = 3'h0;
      default: sel952 = 3'h0;
    endcase
  end
  assign sel953 = lt806 ? 1'h1 : 1'h0;
  assign sel954 = (shr546[2:0] == 3'h0) ? sel953 : 1'h0;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel955 = 1'h0;
      7'h33: sel955 = 1'h0;
      7'h23: sel955 = 1'h0;
      7'h03: sel955 = 1'h0;
      7'h63: sel955 = 1'h0;
      7'h73: sel955 = sel954;
      7'h37: sel955 = 1'h0;
      7'h17: sel955 = 1'h0;
      7'h6f: sel955 = 1'h1;
      7'h67: sel955 = 1'h1;
      default: sel955 = 1'h0;
    endcase
  end
  assign sel956 = lt806 ? 32'hb0000000 : 32'h7b;
  assign sel957 = (shr546[2:0] == 3'h0) ? sel956 : 32'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel958 = 32'h7b;
      7'h33: sel958 = 32'h7b;
      7'h23: sel958 = 32'h7b;
      7'h03: sel958 = 32'h7b;
      7'h63: sel958 = 32'h7b;
      7'h73: sel958 = sel957;
      7'h37: sel958 = 32'h7b;
      7'h17: sel958 = 32'h7b;
      7'h6f: sel958 = sel907;
      7'h67: sel958 = sel930;
      default: sel958 = 32'h7b;
    endcase
  end
  assign sel959 = lt806 ? 20'h7b : 20'h7b;
  assign sel960 = (shr546[2:0] == 3'h0) ? sel959 : 20'h7b;
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel961 = 20'h7b;
      7'h33: sel961 = 20'h7b;
      7'h23: sel961 = 20'h7b;
      7'h03: sel961 = 20'h7b;
      7'h63: sel961 = 20'h7b;
      7'h73: sel961 = sel960;
      7'h37: sel961 = proxy849;
      7'h17: sel961 = proxy849;
      7'h6f: sel961 = 20'h7b;
      7'h67: sel961 = 20'h7b;
      default: sel961 = 20'h7b;
    endcase
  end
  assign sel962 = lt806 ? 12'h7b : shr539[11:0];
  assign sel963 = (shr546[2:0] == 3'h0) ? sel962 : shr539[11:0];
  always @(*) begin
    case (io_in_instruction[6:0])
      7'h13: sel964 = 12'h7b;
      7'h33: sel964 = 12'h7b;
      7'h23: sel964 = 12'h7b;
      7'h03: sel964 = 12'h7b;
      7'h63: sel964 = 12'h7b;
      7'h73: sel964 = sel963;
      7'h37: sel964 = 12'h7b;
      7'h17: sel964 = 12'h7b;
      7'h6f: sel964 = 12'h7b;
      7'h67: sel964 = 12'h7b;
      default: sel964 = 12'h7b;
    endcase
  end
  assign eq974 = shr553[6:0] == 7'h0;
  assign sel976 = eq974 ? 4'h0 : 4'h1;
  assign sel979 = eq576 ? 4'h0 : sel976;
  assign sel996 = eq974 ? 4'h6 : 4'h7;
  always @(*) begin
    case (shr546[2:0])
      3'h0: sel1004 = sel979;
      3'h1: sel1004 = 4'h2;
      3'h2: sel1004 = 4'h3;
      3'h3: sel1004 = 4'h4;
      3'h4: sel1004 = 4'h5;
      3'h5: sel1004 = sel996;
      3'h6: sel1004 = 4'h8;
      3'h7: sel1004 = 4'h9;
      default: sel1004 = 4'hf;
    endcase
  end
  assign eq1011 = shr546[1:0] == 2'h3;
  assign sel1013 = eq1011 ? 4'hf : 4'hf;
  assign eq1019 = shr546[1:0] == 2'h2;
  assign sel1021 = eq1019 ? 4'he : sel1013;
  assign eq1027 = shr546[1:0] == 2'h1;
  assign sel1029 = eq1027 ? 4'hd : sel1021;
  assign orl1033 = eq583 || eq571;
  assign sel1035 = orl1033 ? 4'h0 : sel1004;
  assign sel1037 = andl620 ? sel1029 : sel1035;
  assign sel1041 = eq608 ? 4'hc : sel1037;
  assign sel1045 = eq603 ? 4'hb : sel1041;
  assign lt1051 = sel952 < 3'h5;
  assign sel1053 = lt1051 ? 4'h1 : 4'ha;
  assign sel1055 = eq588 ? sel1053 : sel1045;

  assign io_out_csr_address = sel964;
  assign io_out_is_csr = sel945;
  assign io_out_csr_data = sel659;
  assign io_out_csr_mask = sel654;
  assign io_out_rd = shr525[4:0];
  assign io_out_rs1 = shr532[4:0];
  assign io_out_rd1 = sel645;
  assign io_out_rs2 = proxy542;
  assign io_out_rd2 = sel651;
  assign io_out_wb = sel686;
  assign io_out_alu_op = sel1055;
  assign io_out_rs2_src = sel693;
  assign io_out_itype_immed = sel942;
  assign io_out_mem_read = sel697;
  assign io_out_mem_write = sel700;
  assign io_out_branch_type = sel952;
  assign io_out_branch_stall = sel948;
  assign io_out_jal = sel955;
  assign io_out_jal_offset = sel958;
  assign io_out_upper_immed = sel961;
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
  reg[4:0] reg1256; // d_e_register.h(76:0)
  reg[4:0] reg1265; // d_e_register.h(77:0)
  reg[31:0] reg1272; // d_e_register.h(78:0)
  reg[4:0] reg1278; // d_e_register.h(79:0)
  reg[31:0] reg1284; // d_e_register.h(80:0)
  reg[3:0] reg1291; // d_e_register.h(81:0)
  reg[1:0] reg1298; // d_e_register.h(82:0)
  reg[31:0] reg1304; // d_e_register.h(83:0)
  reg reg1311; // d_e_register.h(84:0)
  reg[11:0] reg1318; // d_e_register.h(85:0)
  reg[2:0] reg1325; // d_e_register.h(86:0)
  reg[2:0] reg1331; // d_e_register.h(87:0)
  reg[2:0] reg1338; // d_e_register.h(88:0)
  reg[19:0] reg1345; // d_e_register.h(89:0)
  reg[11:0] reg1351; // d_e_register.h(90:0)
  reg reg1357; // d_e_register.h(91:0)
  reg[31:0] reg1363; // d_e_register.h(92:0)
  reg[31:0] reg1369; // d_e_register.h(93:0)
  reg[31:0] reg1375; // d_e_register.h(94:0)
  reg reg1381; // d_e_register.h(95:0)
  reg[31:0] reg1387; // d_e_register.h(96:0)
  wire eq1392; // d_e_register.h(134:1)
  wire eq1396; // d_e_register.h(134:3)
  wire orl1398; // d_e_register.h(134:3)
  wire[4:0] sel1401; // d_e_register.h(137:0)
  wire[4:0] sel1404; // d_e_register.h(138:0)
  wire[31:0] sel1407; // d_e_register.h(139:0)
  wire[4:0] sel1410; // d_e_register.h(140:0)
  wire[31:0] sel1413; // d_e_register.h(141:0)
  wire[3:0] sel1417; // d_e_register.h(142:0)
  wire[1:0] sel1420; // d_e_register.h(143:0)
  wire[31:0] sel1423; // d_e_register.h(144:0)
  wire sel1426; // d_e_register.h(145:0)
  wire[11:0] sel1430; // d_e_register.h(146:0)
  wire[2:0] sel1433; // d_e_register.h(147:0)
  wire[2:0] sel1436; // d_e_register.h(148:0)
  wire[2:0] sel1439; // d_e_register.h(149:0)
  wire[19:0] sel1442; // d_e_register.h(150:0)
  wire[11:0] sel1445; // d_e_register.h(151:0)
  wire sel1448; // d_e_register.h(152:0)
  wire[31:0] sel1451; // d_e_register.h(153:0)
  wire[31:0] sel1454; // d_e_register.h(154:0)
  wire sel1457; // d_e_register.h(155:0)
  wire[31:0] sel1460; // d_e_register.h(156:0)
  wire[31:0] sel1463; // d_e_register.h(157:0)

  always @ (posedge clk) begin
    if (reset)
      reg1256 <= 5'h0;
    else
      reg1256 <= sel1401;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1265 <= 5'h0;
    else
      reg1265 <= sel1404;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1272 <= 32'h0;
    else
      reg1272 <= sel1407;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1278 <= 5'h0;
    else
      reg1278 <= sel1410;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1284 <= 32'h0;
    else
      reg1284 <= sel1413;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1291 <= 4'h0;
    else
      reg1291 <= sel1417;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1298 <= 2'h0;
    else
      reg1298 <= sel1420;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1304 <= 32'h0;
    else
      reg1304 <= sel1423;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1311 <= 1'h0;
    else
      reg1311 <= sel1426;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1318 <= 12'h0;
    else
      reg1318 <= sel1430;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1325 <= 3'h7;
    else
      reg1325 <= sel1433;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1331 <= 3'h7;
    else
      reg1331 <= sel1436;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1338 <= 3'h0;
    else
      reg1338 <= sel1439;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1345 <= 20'h0;
    else
      reg1345 <= sel1442;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1351 <= 12'h0;
    else
      reg1351 <= sel1445;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1357 <= 1'h0;
    else
      reg1357 <= sel1448;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1363 <= 32'h0;
    else
      reg1363 <= sel1451;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1369 <= 32'h0;
    else
      reg1369 <= sel1454;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1375 <= 32'h0;
    else
      reg1375 <= sel1463;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1381 <= 1'h0;
    else
      reg1381 <= sel1457;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1387 <= 32'h0;
    else
      reg1387 <= sel1460;
  end
  assign eq1392 = io_in_branch_stall == 1'h1;
  assign eq1396 = io_in_fwd_stall == 1'h1;
  assign orl1398 = eq1396 || eq1392;
  assign sel1401 = orl1398 ? 5'h0 : io_in_rd;
  assign sel1404 = orl1398 ? 5'h0 : io_in_rs1;
  assign sel1407 = orl1398 ? 32'h0 : io_in_rd1;
  assign sel1410 = orl1398 ? 5'h0 : io_in_rs2;
  assign sel1413 = orl1398 ? 32'h0 : io_in_rd2;
  assign sel1417 = orl1398 ? 4'hf : io_in_alu_op;
  assign sel1420 = orl1398 ? 2'h0 : io_in_wb;
  assign sel1423 = orl1398 ? 32'h0 : io_in_PC_next;
  assign sel1426 = orl1398 ? 1'h0 : io_in_rs2_src;
  assign sel1430 = orl1398 ? 12'h7b : io_in_itype_immed;
  assign sel1433 = orl1398 ? 3'h7 : io_in_mem_read;
  assign sel1436 = orl1398 ? 3'h7 : io_in_mem_write;
  assign sel1439 = orl1398 ? 3'h0 : io_in_branch_type;
  assign sel1442 = orl1398 ? 20'h0 : io_in_upper_immed;
  assign sel1445 = orl1398 ? 12'h0 : io_in_csr_address;
  assign sel1448 = orl1398 ? 1'h0 : io_in_is_csr;
  assign sel1451 = orl1398 ? 32'h0 : io_in_csr_data;
  assign sel1454 = orl1398 ? 32'h0 : io_in_csr_mask;
  assign sel1457 = orl1398 ? 1'h0 : io_in_jal;
  assign sel1460 = orl1398 ? 32'h0 : io_in_jal_offset;
  assign sel1463 = orl1398 ? 32'h0 : io_in_curr_PC;

  assign io_out_csr_address = reg1351;
  assign io_out_is_csr = reg1357;
  assign io_out_csr_data = reg1363;
  assign io_out_csr_mask = reg1369;
  assign io_out_rd = reg1256;
  assign io_out_rs1 = reg1265;
  assign io_out_rd1 = reg1272;
  assign io_out_rs2 = reg1278;
  assign io_out_rd2 = reg1284;
  assign io_out_alu_op = reg1291;
  assign io_out_wb = reg1298;
  assign io_out_rs2_src = reg1311;
  assign io_out_itype_immed = reg1318;
  assign io_out_mem_read = reg1325;
  assign io_out_mem_write = reg1331;
  assign io_out_branch_type = reg1338;
  assign io_out_upper_immed = reg1345;
  assign io_out_curr_PC = reg1375;
  assign io_out_jal = reg1381;
  assign io_out_jal_offset = reg1387;
  assign io_out_PC_next = reg1304;

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
  wire[31:0] pad1672; // execute.h(63:1)
  wire[31:0] proxy1676; // execute.h(63:2)
  wire eq1683; // execute.h(63:5)
  wire[31:0] sel1685; // execute.h(63:0)
  wire eq1690; // execute.h(69:1)
  wire[31:0] sel1692; // execute.h(70:0)
  wire[31:0] proxy1697; // execute.h(73:0)
  wire[31:0] add1700; // execute.h(9:0)
  wire[31:0] add1703; // execute.h(67:0)
  wire[31:0] sub1708; // execute.h(67:0)
  wire[31:0] shl1712; // execute.h(67:0)
  wire lt1720; // execute.h(67:0)
  wire[31:0] sel1722; // execute.h(108:0)
  wire[31:0] xorb1736; // execute.h(123:0)
  wire[31:0] shr1740; // execute.h(67:0)
  wire[31:0] orb1750; // execute.h(143:0)
  wire[31:0] andb1755; // execute.h(149:0)
  wire ge1759; // execute.h(67:0)
  wire[31:0] add1768; // execute.h(9:0)
  wire[31:0] orb1774; // execute.h(200:0)
  wire[31:0] sub1778; // execute.h(205:0)
  wire[31:0] andb1781; // execute.h(205:1)
  reg[31:0] sel1785; // execute.h(81:0)
  wire[31:0] sel1786; // execute.h(168:0)
  reg[31:0] sel1787; // execute.h(81:0)
  wire ne1793; // execute.h(9:0)
  wire sel1795; // execute.h(215:0)

  assign pad1672 = {{20{1'b0}}, io_in_itype_immed};
  assign proxy1676 = {20'hfffff, io_in_itype_immed};
  assign eq1683 = io_in_itype_immed[11] == 1'h1;
  assign sel1685 = eq1683 ? proxy1676 : pad1672;
  assign eq1690 = io_in_rs2_src == 1'h1;
  assign sel1692 = eq1690 ? sel1685 : io_in_rd2;
  assign proxy1697 = {io_in_upper_immed, 12'h0};
  assign add1700 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign add1703 = $signed(io_in_rd1) + $signed(sel1692);
  assign sub1708 = $signed(io_in_rd1) - $signed(sel1692);
  assign shl1712 = io_in_rd1 << sel1692;
  assign lt1720 = $signed(io_in_rd1) < $signed(sel1692);
  assign sel1722 = lt1720 ? 32'h1 : 32'h0;
  assign xorb1736 = io_in_rd1 ^ sel1692;
  assign shr1740 = io_in_rd1 >> sel1692;
  assign orb1750 = io_in_rd1 | sel1692;
  assign andb1755 = sel1692 & io_in_rd1;
  assign ge1759 = io_in_rd1 >= sel1692;
  assign add1768 = $signed(io_in_curr_PC) + $signed(proxy1697);
  assign orb1774 = io_in_csr_data | io_in_csr_mask;
  assign sub1778 = 32'hffffffff - io_in_csr_mask;
  assign andb1781 = io_in_csr_data & sub1778;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1785 = 32'h7b;
      4'h1: sel1785 = 32'h7b;
      4'h2: sel1785 = 32'h7b;
      4'h3: sel1785 = 32'h7b;
      4'h4: sel1785 = 32'h7b;
      4'h5: sel1785 = 32'h7b;
      4'h6: sel1785 = 32'h7b;
      4'h7: sel1785 = 32'h7b;
      4'h8: sel1785 = 32'h7b;
      4'h9: sel1785 = 32'h7b;
      4'ha: sel1785 = 32'h7b;
      4'hb: sel1785 = 32'h7b;
      4'hc: sel1785 = 32'h7b;
      4'hd: sel1785 = io_in_csr_mask;
      4'he: sel1785 = orb1774;
      4'hf: sel1785 = andb1781;
      default: sel1785 = 32'h7b;
    endcase
  end
  assign sel1786 = ge1759 ? 32'h0 : 32'hffffffff;
  always @(*) begin
    case (io_in_alu_op)
      4'h0: sel1787 = add1703;
      4'h1: sel1787 = sub1708;
      4'h2: sel1787 = shl1712;
      4'h3: sel1787 = sel1722;
      4'h4: sel1787 = sel1722;
      4'h5: sel1787 = xorb1736;
      4'h6: sel1787 = shr1740;
      4'h7: sel1787 = shr1740;
      4'h8: sel1787 = orb1750;
      4'h9: sel1787 = andb1755;
      4'ha: sel1787 = sel1786;
      4'hb: sel1787 = proxy1697;
      4'hc: sel1787 = add1768;
      4'hd: sel1787 = io_in_csr_data;
      4'he: sel1787 = io_in_csr_data;
      4'hf: sel1787 = io_in_csr_data;
      default: sel1787 = 32'h0;
    endcase
  end
  assign ne1793 = io_in_branch_type != 3'h0;
  assign sel1795 = ne1793 ? 1'h1 : 1'h0;

  assign io_out_csr_address = io_in_csr_address;
  assign io_out_is_csr = io_in_is_csr;
  assign io_out_csr_result = sel1785;
  assign io_out_alu_result = sel1787;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rd1 = io_in_rd1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_rd2 = io_in_rd2;
  assign io_out_mem_read = io_in_mem_read;
  assign io_out_mem_write = io_in_mem_write;
  assign io_out_jal = io_in_jal;
  assign io_out_jal_dest = add1700;
  assign io_out_branch_offset = sel1685;
  assign io_out_branch_stall = sel1795;
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
  reg[31:0] reg1981; // e_m_register.h(49:0)
  reg[4:0] reg1991; // e_m_register.h(50:0)
  reg[4:0] reg1997; // e_m_register.h(51:0)
  reg[31:0] reg2003; // e_m_register.h(52:0)
  reg[4:0] reg2009; // e_m_register.h(53:0)
  reg[31:0] reg2015; // e_m_register.h(54:0)
  reg[1:0] reg2022; // e_m_register.h(55:0)
  reg[31:0] reg2028; // e_m_register.h(56:0)
  reg[2:0] reg2035; // e_m_register.h(57:0)
  reg[2:0] reg2041; // e_m_register.h(58:0)
  reg[11:0] reg2048; // e_m_register.h(59:0)
  reg reg2055; // e_m_register.h(60:0)
  reg[31:0] reg2061; // e_m_register.h(61:0)
  reg[31:0] reg2067; // e_m_register.h(62:0)
  reg[31:0] reg2073; // e_m_register.h(63:0)
  reg[2:0] reg2079; // e_m_register.h(64:0)

  always @ (posedge clk) begin
    if (reset)
      reg1981 <= 32'h0;
    else
      reg1981 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1991 <= 5'h0;
    else
      reg1991 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg1997 <= 5'h0;
    else
      reg1997 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2003 <= 32'h0;
    else
      reg2003 <= io_in_rd1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2009 <= 5'h0;
    else
      reg2009 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2015 <= 32'h0;
    else
      reg2015 <= io_in_rd2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2022 <= 2'h0;
    else
      reg2022 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2028 <= 32'h0;
    else
      reg2028 <= io_in_PC_next;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2035 <= 3'h0;
    else
      reg2035 <= io_in_mem_read;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2041 <= 3'h0;
    else
      reg2041 <= io_in_mem_write;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2048 <= 12'h0;
    else
      reg2048 <= io_in_csr_address;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2055 <= 1'h0;
    else
      reg2055 <= io_in_is_csr;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2061 <= 32'h0;
    else
      reg2061 <= io_in_csr_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2067 <= 32'h0;
    else
      reg2067 <= io_in_curr_PC;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2073 <= 32'h0;
    else
      reg2073 <= io_in_branch_offset;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2079 <= 3'h0;
    else
      reg2079 <= io_in_branch_type;
  end

  assign io_out_csr_address = reg2048;
  assign io_out_is_csr = reg2055;
  assign io_out_csr_result = reg2061;
  assign io_out_alu_result = reg1981;
  assign io_out_rd = reg1991;
  assign io_out_wb = reg2022;
  assign io_out_rs1 = reg1997;
  assign io_out_rd1 = reg2003;
  assign io_out_rd2 = reg2015;
  assign io_out_rs2 = reg2009;
  assign io_out_mem_read = reg2035;
  assign io_out_mem_write = reg2041;
  assign io_out_curr_PC = reg2067;
  assign io_out_branch_offset = reg2073;
  assign io_out_branch_type = reg2079;
  assign io_out_PC_next = reg2028;

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
  wire lt2281; // memory.h(9:0)
  wire lt2284; // memory.h(9:0)
  wire orl2286; // memory.h(9:0)
  wire eq2293; // memory.h(9:0)
  wire eq2304; // memory.h(9:0)
  wire eq2307; // memory.h(9:0)
  wire andl2309; // memory.h(9:0)
  wire[1:0] sel2315; // memory.h(53:2)
  wire[1:0] sel2319; // memory.h(53:1)
  wire[1:0] sel2323; // memory.h(53:0)
  wire notl2328; // memory.h(56:0)
  wire notl2331; // memory.h(56:1)
  wire andl2333; // memory.h(56:1)
  wire orl2336; // memory.h(56:2)
  wire[7:0] proxy2345; // memory.h(67:0)
  wire[31:0] pad2346; // memory.h(68:1)
  wire[31:0] proxy2348; // memory.h(68:2)
  wire eq2353; // memory.h(68:4)
  wire[31:0] sel2355; // memory.h(68:0)
  wire[15:0] proxy2362; // memory.h(76:0)
  wire[31:0] pad2363; // memory.h(77:1)
  wire[31:0] proxy2365; // memory.h(77:2)
  wire eq2370; // memory.h(77:4)
  wire[31:0] sel2372; // memory.h(77:0)
  reg[31:0] sel2386; // memory.h(60:0)

  assign lt2281 = io_in_mem_write < 3'h7;
  assign lt2284 = io_in_mem_read < 3'h7;
  assign orl2286 = lt2284 || lt2281;
  assign eq2293 = io_in_mem_write == 3'h2;
  assign eq2304 = io_in_mem_write == 3'h7;
  assign eq2307 = io_in_mem_read == 3'h7;
  assign andl2309 = eq2307 && eq2304;
  assign sel2315 = andl2309 ? 2'h0 : 2'h3;
  assign sel2319 = eq2293 ? 2'h2 : sel2315;
  assign sel2323 = lt2284 ? 2'h1 : sel2319;
  assign notl2328 = !eq2293;
  assign notl2331 = !andl2309;
  assign andl2333 = notl2331 && notl2328;
  assign orl2336 = lt2284 || andl2333;
  assign proxy2345 = io_DBUS_in_data_data[7:0];
  assign pad2346 = {{24{1'b0}}, proxy2345};
  assign proxy2348 = {24'hffffff, io_DBUS_in_data_data[7:0]};
  assign eq2353 = io_DBUS_in_data_data[7] == 1'h1;
  assign sel2355 = eq2353 ? proxy2348 : pad2346;
  assign proxy2362 = io_DBUS_in_data_data[15:0];
  assign pad2363 = {{16{1'b0}}, proxy2362};
  assign proxy2365 = {16'hffff, io_DBUS_in_data_data[15:0]};
  assign eq2370 = io_DBUS_in_data_data[15] == 1'h1;
  assign sel2372 = eq2370 ? proxy2365 : pad2363;
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2386 = sel2355;
      3'h1: sel2386 = sel2372;
      3'h2: sel2386 = io_DBUS_in_data_data;
      3'h4: sel2386 = pad2346;
      3'h5: sel2386 = pad2363;
      default: sel2386 = 32'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = orl2336;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = lt2281;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = orl2286;
  assign io_DBUS_out_control_data = sel2323;
  assign io_DBUS_out_control_valid = 1'h1;
  assign io_out_data = sel2386;

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
  wire[31:0] Cache2392_io_DBUS_in_data_data; // memory.h(158:1)
  wire Cache2392_io_DBUS_in_data_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_in_data_ready; // memory.h(158:1)
  wire[31:0] Cache2392_io_DBUS_out_data_data; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_data_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_data_ready; // memory.h(158:1)
  wire[31:0] Cache2392_io_DBUS_out_address_data; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_address_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_address_ready; // memory.h(158:1)
  wire[1:0] Cache2392_io_DBUS_out_control_data; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_control_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_control_ready; // memory.h(158:1)
  wire[31:0] Cache2392_io_in_address; // memory.h(158:1)
  wire[2:0] Cache2392_io_in_mem_read; // memory.h(158:1)
  wire[2:0] Cache2392_io_in_mem_write; // memory.h(158:1)
  wire[31:0] Cache2392_io_in_data; // memory.h(158:1)
  wire[31:0] Cache2392_io_out_data; // memory.h(158:1)
  wire[31:0] shl2444; // memory.h(158:0)
  wire[31:0] add2446; // memory.h(158:0)
  wire eq2455; // memory.h(158:0)
  wire sel2457; // memory.h(229:0)
  wire sel2465; // memory.h(234:0)
  wire eq2473; // memory.h(238:4)
  wire sel2475; // memory.h(238:0)
  wire sel2485; // memory.h(243:0)
  reg sel2510; // memory.h(221:0)

  Cache Cache2392(.io_DBUS_in_data_data(Cache2392_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Cache2392_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Cache2392_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Cache2392_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Cache2392_io_DBUS_out_control_ready), .io_in_address(Cache2392_io_in_address), .io_in_mem_read(Cache2392_io_in_mem_read), .io_in_mem_write(Cache2392_io_in_mem_write), .io_in_data(Cache2392_io_in_data), .io_DBUS_in_data_ready(Cache2392_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Cache2392_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Cache2392_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Cache2392_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Cache2392_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Cache2392_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Cache2392_io_DBUS_out_control_valid), .io_out_data(Cache2392_io_out_data));
  assign Cache2392_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Cache2392_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Cache2392_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Cache2392_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Cache2392_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Cache2392_io_in_address = io_in_alu_result;
  assign Cache2392_io_in_mem_read = io_in_mem_read;
  assign Cache2392_io_in_mem_write = io_in_mem_write;
  assign Cache2392_io_in_data = io_in_rd2;
  assign shl2444 = $signed(io_in_branch_offset) << 32'h1;
  assign add2446 = $signed(io_in_curr_PC) + $signed(shl2444);
  assign eq2455 = io_in_alu_result == 32'h0;
  assign sel2457 = eq2455 ? 1'h1 : 1'h0;
  assign sel2465 = eq2455 ? 1'h0 : 1'h1;
  assign eq2473 = io_in_alu_result[31] == 1'h0;
  assign sel2475 = eq2473 ? 1'h0 : 1'h1;
  assign sel2485 = eq2473 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2510 = sel2457;
      3'h2: sel2510 = sel2465;
      3'h3: sel2510 = sel2475;
      3'h4: sel2510 = sel2485;
      3'h5: sel2510 = sel2475;
      3'h6: sel2510 = sel2485;
      3'h0: sel2510 = 1'h0;
      default: sel2510 = 1'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = Cache2392_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Cache2392_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Cache2392_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Cache2392_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Cache2392_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Cache2392_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Cache2392_io_DBUS_out_control_valid;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = Cache2392_io_out_data;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2510;
  assign io_out_branch_dest = add2446;
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
  reg[31:0] reg2647; // m_w_register.h(31:0)
  reg[31:0] reg2656; // m_w_register.h(32:0)
  reg[4:0] reg2663; // m_w_register.h(33:0)
  reg[4:0] reg2669; // m_w_register.h(34:0)
  reg[4:0] reg2675; // m_w_register.h(35:0)
  reg[1:0] reg2682; // m_w_register.h(36:0)
  reg[31:0] reg2688; // m_w_register.h(37:0)

  always @ (posedge clk) begin
    if (reset)
      reg2647 <= 32'h0;
    else
      reg2647 <= io_in_alu_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2656 <= 32'h0;
    else
      reg2656 <= io_in_mem_result;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2663 <= 5'h0;
    else
      reg2663 <= io_in_rd;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2669 <= 5'h0;
    else
      reg2669 <= io_in_rs1;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2675 <= 5'h0;
    else
      reg2675 <= io_in_rs2;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2682 <= 2'h0;
    else
      reg2682 <= io_in_wb;
  end
  always @ (posedge clk) begin
    if (reset)
      reg2688 <= 32'h0;
    else
      reg2688 <= io_in_PC_next;
  end

  assign io_out_alu_result = reg2647;
  assign io_out_mem_result = reg2656;
  assign io_out_rd = reg2663;
  assign io_out_wb = reg2682;
  assign io_out_rs1 = reg2669;
  assign io_out_rs2 = reg2675;
  assign io_out_PC_next = reg2688;

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
  wire eq2753; // write_back.h(1:0)
  wire eq2757; // write_back.h(1:0)
  wire[31:0] sel2759; // write_back.h(23:1)
  wire[31:0] sel2761; // write_back.h(23:0)

  assign eq2753 = io_in_wb == 2'h3;
  assign eq2757 = io_in_wb == 2'h1;
  assign sel2759 = eq2757 ? io_in_alu_result : io_in_mem_result;
  assign sel2761 = eq2753 ? io_in_PC_next : sel2759;

  assign io_out_write_data = sel2761;
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
  wire eq2840; // forwarding.h(9:0)
  wire eq2843; // forwarding.h(9:0)
  wire eq2846; // forwarding.h(9:0)
  wire eq2850; // forwarding.h(9:0)
  wire eq2853; // forwarding.h(9:0)
  wire eq2856; // forwarding.h(9:0)
  wire eq2861; // forwarding.h(66:1)
  wire eq2865; // forwarding.h(67:1)
  wire ne2869; // forwarding.h(9:0)
  wire ne2873; // forwarding.h(9:0)
  wire eq2875; // forwarding.h(9:0)
  wire andl2877; // forwarding.h(9:0)
  wire andl2879; // forwarding.h(9:0)
  wire notl2882; // forwarding.h(78:0)
  wire ne2885; // forwarding.h(9:0)
  wire eq2890; // forwarding.h(9:0)
  wire andl2892; // forwarding.h(9:0)
  wire andl2894; // forwarding.h(9:0)
  wire andl2896; // forwarding.h(9:0)
  wire notl2899; // forwarding.h(84:0)
  wire ne2905; // forwarding.h(9:0)
  wire eq2910; // forwarding.h(9:0)
  wire andl2912; // forwarding.h(9:0)
  wire andl2914; // forwarding.h(9:0)
  wire andl2916; // forwarding.h(9:0)
  wire andl2918; // forwarding.h(9:0)
  wire orl2921; // forwarding.h(87:0)
  wire orl2923; // forwarding.h(87:0)
  wire[31:0] sel2927; // forwarding.h(91:1)
  wire[31:0] sel2929; // forwarding.h(91:0)
  wire[31:0] sel2931; // forwarding.h(92:2)
  wire[31:0] sel2933; // forwarding.h(90:1)
  wire[31:0] sel2935; // forwarding.h(90:0)
  wire[31:0] sel2937; // forwarding.h(92:1)
  wire[31:0] sel2939; // forwarding.h(89:0)
  wire[31:0] sel2941; // forwarding.h(92:0)
  wire ne2947; // forwarding.h(9:0)
  wire eq2949; // forwarding.h(9:0)
  wire andl2951; // forwarding.h(9:0)
  wire andl2953; // forwarding.h(9:0)
  wire notl2956; // forwarding.h(138:0)
  wire eq2964; // forwarding.h(9:0)
  wire andl2966; // forwarding.h(9:0)
  wire andl2968; // forwarding.h(9:0)
  wire andl2970; // forwarding.h(9:0)
  wire notl2973; // forwarding.h(144:0)
  wire eq2984; // forwarding.h(9:0)
  wire andl2986; // forwarding.h(9:0)
  wire andl2988; // forwarding.h(9:0)
  wire andl2990; // forwarding.h(9:0)
  wire andl2992; // forwarding.h(9:0)
  wire orl2995; // forwarding.h(147:0)
  wire orl2997; // forwarding.h(147:0)
  wire[31:0] sel3004; // forwarding.h(152:2)
  wire[31:0] sel3010; // forwarding.h(152:1)
  wire[31:0] sel3014; // forwarding.h(152:0)
  wire eq3016; // forwarding.h(9:0)
  wire andl3018; // forwarding.h(9:0)
  wire notl3021; // forwarding.h(192:0)
  wire eq3023; // forwarding.h(9:0)
  wire andl3025; // forwarding.h(9:0)
  wire andl3027; // forwarding.h(9:0)
  wire orl3030; // forwarding.h(194:0)
  wire[31:0] sel3033; // forwarding.h(197:1)
  wire[31:0] sel3035; // forwarding.h(197:0)
  wire orl3041; // forwarding.h(200:3)
  wire andl3043; // forwarding.h(200:3)
  wire sel3045; // forwarding.h(200:0)

  assign eq2840 = io_in_execute_wb == 2'h2;
  assign eq2843 = io_in_memory_wb == 2'h2;
  assign eq2846 = io_in_writeback_wb == 2'h2;
  assign eq2850 = io_in_execute_wb == 2'h3;
  assign eq2853 = io_in_memory_wb == 2'h3;
  assign eq2856 = io_in_writeback_wb == 2'h3;
  assign eq2861 = io_in_execute_is_csr == 1'h1;
  assign eq2865 = io_in_memory_is_csr == 1'h1;
  assign ne2869 = io_in_execute_wb != 2'h0;
  assign ne2873 = io_in_decode_src1 != 5'h0;
  assign eq2875 = io_in_decode_src1 == io_in_execute_dest;
  assign andl2877 = eq2875 && ne2873;
  assign andl2879 = andl2877 && ne2869;
  assign notl2882 = !andl2879;
  assign ne2885 = io_in_memory_wb != 2'h0;
  assign eq2890 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2892 = eq2890 && ne2873;
  assign andl2894 = andl2892 && ne2885;
  assign andl2896 = andl2894 && notl2882;
  assign notl2899 = !andl2896;
  assign ne2905 = io_in_writeback_wb != 2'h0;
  assign eq2910 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2912 = eq2910 && ne2873;
  assign andl2914 = andl2912 && ne2905;
  assign andl2916 = andl2914 && notl2882;
  assign andl2918 = andl2916 && notl2899;
  assign orl2921 = andl2879 || andl2896;
  assign orl2923 = orl2921 || andl2918;
  assign sel2927 = eq2846 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2929 = eq2856 ? io_in_writeback_PC_next : sel2927;
  assign sel2931 = andl2918 ? sel2929 : 32'h7b;
  assign sel2933 = eq2843 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2935 = eq2853 ? io_in_memory_PC_next : sel2933;
  assign sel2937 = andl2896 ? sel2935 : sel2931;
  assign sel2939 = eq2850 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2941 = andl2879 ? sel2939 : sel2937;
  assign ne2947 = io_in_decode_src2 != 5'h0;
  assign eq2949 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2951 = eq2949 && ne2947;
  assign andl2953 = andl2951 && ne2869;
  assign notl2956 = !andl2953;
  assign eq2964 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2966 = eq2964 && ne2947;
  assign andl2968 = andl2966 && ne2885;
  assign andl2970 = andl2968 && notl2956;
  assign notl2973 = !andl2970;
  assign eq2984 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2986 = eq2984 && ne2947;
  assign andl2988 = andl2986 && ne2905;
  assign andl2990 = andl2988 && notl2956;
  assign andl2992 = andl2990 && notl2973;
  assign orl2995 = andl2953 || andl2970;
  assign orl2997 = orl2995 || andl2992;
  assign sel3004 = andl2992 ? sel2929 : 32'h7b;
  assign sel3010 = andl2970 ? sel2935 : sel3004;
  assign sel3014 = andl2953 ? sel2939 : sel3010;
  assign eq3016 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3018 = eq3016 && eq2861;
  assign notl3021 = !andl3018;
  assign eq3023 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3025 = eq3023 && eq2865;
  assign andl3027 = andl3025 && notl3021;
  assign orl3030 = andl3018 || andl3027;
  assign sel3033 = andl3027 ? io_in_memory_csr_result : 32'h7b;
  assign sel3035 = andl3018 ? io_in_execute_alu_result : sel3033;
  assign orl3041 = andl2879 || andl2953;
  assign andl3043 = orl3041 && eq2840;
  assign sel3045 = andl3043 ? 1'h1 : 1'h0;

  assign io_out_src1_fwd = orl2923;
  assign io_out_src1_fwd_data = sel2941;
  assign io_out_src2_fwd = orl2997;
  assign io_out_src2_fwd_data = sel3014;
  assign io_out_csr_fwd = orl3030;
  assign io_out_csr_fwd_data = sel3035;
  assign io_out_fwd_stall = sel3045;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  reg[31:0] mem3149 [0:1]; // interrupt_handler.h(27:0)
  wire[31:0] marport3150; // interrupt_handler.h(31:0)

  initial begin
    mem3149[0] = 32'hdeadbeef;
    mem3149[1] = 32'hdeadbeef;
  end
  assign marport3150 = mem3149[io_INTERRUPT_in_interrupt_id_data];

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = marport3150;

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
  reg[3:0] reg3218; // JTAG/jtag.h(31:0)
  wire eq3227; // JTAG/jtag.h(36:1)
  wire[3:0] sel3233; // JTAG/jtag.h(45:0)
  wire[3:0] sel3238; // JTAG/jtag.h(49:0)
  wire[3:0] sel3244; // JTAG/jtag.h(53:0)
  wire[3:0] sel3250; // JTAG/jtag.h(57:0)
  wire[3:0] sel3260; // JTAG/jtag.h(65:0)
  wire[3:0] sel3265; // JTAG/jtag.h(69:0)
  wire[3:0] sel3269; // JTAG/jtag.h(73:0)
  wire[3:0] sel3278; // JTAG/jtag.h(81:0)
  wire[3:0] sel3284; // JTAG/jtag.h(85:0)
  wire[3:0] sel3294; // JTAG/jtag.h(93:0)
  wire[3:0] sel3299; // JTAG/jtag.h(97:0)
  wire[3:0] sel3303; // JTAG/jtag.h(101:0)
  reg[3:0] sel3309; // JTAG/jtag.h(42:0)
  wire[3:0] sel3310; // JTAG/jtag.h(40:0)
  wire andl3312; // JTAG/jtag.h(115:1)
  wire eq3316; // JTAG/jtag.h(117:2)
  wire andl3320; // JTAG/jtag.h(123:1)
  wire eq3324; // JTAG/jtag.h(125:2)
  wire[3:0] sel3326; // JTAG/jtag.h(117:0)
  wire[3:0] sel3327; // JTAG/jtag.h(125:0)
  wire andb3328; // JTAG/jtag.h(115:0)
  wire[3:0] sel3329; // JTAG/jtag.h(115:0)

  always @ (posedge clk) begin
    if (reset)
      reg3218 <= 4'h0;
    else
      reg3218 <= sel3329;
  end
  assign eq3227 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3233 = eq3227 ? 4'h0 : 4'h1;
  assign sel3238 = eq3227 ? 4'h2 : 4'h1;
  assign sel3244 = eq3227 ? 4'h9 : 4'h3;
  assign sel3250 = eq3227 ? 4'h5 : 4'h4;
  assign sel3260 = eq3227 ? 4'h8 : 4'h6;
  assign sel3265 = eq3227 ? 4'h7 : 4'h6;
  assign sel3269 = eq3227 ? 4'h4 : 4'h8;
  assign sel3278 = eq3227 ? 4'h0 : 4'ha;
  assign sel3284 = eq3227 ? 4'hc : 4'hb;
  assign sel3294 = eq3227 ? 4'hf : 4'hd;
  assign sel3299 = eq3227 ? 4'he : 4'hd;
  assign sel3303 = eq3227 ? 4'hf : 4'hb;
  always @(*) begin
    case (reg3218)
      4'h0: sel3309 = sel3233;
      4'h1: sel3309 = sel3238;
      4'h2: sel3309 = sel3244;
      4'h3: sel3309 = sel3250;
      4'h4: sel3309 = sel3250;
      4'h5: sel3309 = sel3260;
      4'h6: sel3309 = sel3265;
      4'h7: sel3309 = sel3269;
      4'h8: sel3309 = sel3238;
      4'h9: sel3309 = sel3278;
      4'ha: sel3309 = sel3284;
      4'hb: sel3309 = sel3284;
      4'hc: sel3309 = sel3294;
      4'hd: sel3309 = sel3299;
      4'he: sel3309 = sel3303;
      4'hf: sel3309 = sel3238;
      default: sel3309 = reg3218;
    endcase
  end
  assign sel3310 = io_JTAG_TAP_in_mode_select_valid ? sel3309 : 4'h0;
  assign andl3312 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_reset_valid;
  assign eq3316 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign andl3320 = io_JTAG_TAP_in_mode_select_valid && io_JTAG_TAP_in_clock_valid;
  assign eq3324 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3326 = eq3316 ? 4'h0 : reg3218;
  assign sel3327 = andb3328 ? sel3310 : reg3218;
  assign andb3328 = andl3320 & eq3324;
  assign sel3329 = andl3312 ? sel3326 : sel3327;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = reg3218;

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
  wire TAP3332_clk; // JTAG/jtag.h(138:1)
  wire TAP3332_reset; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_mode_select_data; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_mode_select_valid; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_mode_select_ready; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_clock_data; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_clock_valid; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_clock_ready; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_reset_data; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_reset_valid; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_reset_ready; // JTAG/jtag.h(138:1)
  wire[3:0] TAP3332_io_out_curr_state; // JTAG/jtag.h(138:1)
  reg[31:0] reg3372; // JTAG/jtag.h(148:0)
  reg[31:0] reg3379; // JTAG/jtag.h(150:0)
  reg[31:0] reg3386; // JTAG/jtag.h(151:0)
  reg[31:0] reg3393; // JTAG/jtag.h(159:0)
  wire eq3397; // JTAG/jtag.h(148:0)
  wire eq3406; // JTAG/jtag.h(148:0)
  wire eq3410; // JTAG/jtag.h(148:0)
  wire[31:0] sel3413; // JTAG/jtag.h(178:1)
  wire[31:0] sel3415; // JTAG/jtag.h(178:0)
  wire[31:0] shr3423; // JTAG/jtag.h(186:2)
  wire[31:0] proxy3428; // JTAG/jtag.h(186:0)
  wire[31:0] sel3478; // JTAG/jtag.h(161:0)
  wire[31:0] sel3479; // JTAG/jtag.h(210:0)
  wire[31:0] sel3480; // JTAG/jtag.h(205:0)
  wire[31:0] sel3481; // JTAG/jtag.h(161:0)
  reg[31:0] sel3482; // JTAG/jtag.h(161:0)
  wire sel3483; // JTAG/jtag.h(165:0)
  reg sel3488; // JTAG/jtag.h(161:0)
  wire[31:0] sel3489; // JTAG/jtag.h(205:0)
  wire eq3490; // JTAG/jtag.h(161:0)
  wire andb3491; // JTAG/jtag.h(161:0)
  wire sel3492; // JTAG/jtag.h(165:0)
  reg sel3497; // JTAG/jtag.h(161:0)

  assign TAP3332_clk = clk;
  assign TAP3332_reset = reset;
  TAP TAP3332(.clk(TAP3332_clk), .reset(TAP3332_reset), .io_JTAG_TAP_in_mode_select_data(TAP3332_io_JTAG_TAP_in_mode_select_data), .io_JTAG_TAP_in_mode_select_valid(TAP3332_io_JTAG_TAP_in_mode_select_valid), .io_JTAG_TAP_in_clock_data(TAP3332_io_JTAG_TAP_in_clock_data), .io_JTAG_TAP_in_clock_valid(TAP3332_io_JTAG_TAP_in_clock_valid), .io_JTAG_TAP_in_reset_data(TAP3332_io_JTAG_TAP_in_reset_data), .io_JTAG_TAP_in_reset_valid(TAP3332_io_JTAG_TAP_in_reset_valid), .io_JTAG_TAP_in_mode_select_ready(TAP3332_io_JTAG_TAP_in_mode_select_ready), .io_JTAG_TAP_in_clock_ready(TAP3332_io_JTAG_TAP_in_clock_ready), .io_JTAG_TAP_in_reset_ready(TAP3332_io_JTAG_TAP_in_reset_ready), .io_out_curr_state(TAP3332_io_out_curr_state));
  assign TAP3332_io_JTAG_TAP_in_mode_select_data = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign TAP3332_io_JTAG_TAP_in_mode_select_valid = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign TAP3332_io_JTAG_TAP_in_clock_data = io_JTAG_JTAG_TAP_in_clock_data;
  assign TAP3332_io_JTAG_TAP_in_clock_valid = io_JTAG_JTAG_TAP_in_clock_valid;
  assign TAP3332_io_JTAG_TAP_in_reset_data = io_JTAG_JTAG_TAP_in_reset_data;
  assign TAP3332_io_JTAG_TAP_in_reset_valid = io_JTAG_JTAG_TAP_in_reset_valid;
  always @ (posedge clk) begin
    if (reset)
      reg3372 <= 32'h0;
    else
      reg3372 <= sel3478;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3379 <= 32'h1234;
    else
      reg3379 <= sel3481;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3386 <= 32'h5678;
    else
      reg3386 <= sel3489;
  end
  always @ (posedge clk) begin
    if (reset)
      reg3393 <= 32'h0;
    else
      reg3393 <= sel3482;
  end
  assign eq3397 = reg3372 == 32'h0;
  assign eq3406 = reg3372 == 32'h1;
  assign eq3410 = reg3372 == 32'h2;
  assign sel3413 = eq3410 ? reg3379 : 32'hdeadbeef;
  assign sel3415 = eq3406 ? reg3386 : sel3413;
  assign shr3423 = reg3393 >> 32'h1;
  assign proxy3428 = {io_JTAG_in_data_data, shr3423[30:0]};
  assign sel3478 = (TAP3332_io_out_curr_state == 4'hf) ? reg3393 : reg3372;
  assign sel3479 = eq3410 ? reg3393 : reg3379;
  assign sel3480 = eq3406 ? reg3379 : sel3479;
  assign sel3481 = (TAP3332_io_out_curr_state == 4'h8) ? sel3480 : reg3379;
  always @(*) begin
    case (TAP3332_io_out_curr_state)
      4'h3: sel3482 = sel3415;
      4'h4: sel3482 = proxy3428;
      4'ha: sel3482 = reg3372;
      4'hb: sel3482 = proxy3428;
      default: sel3482 = reg3393;
    endcase
  end
  assign sel3483 = eq3397 ? 1'h1 : 1'h0;
  always @(*) begin
    case (TAP3332_io_out_curr_state)
      4'h3: sel3488 = sel3483;
      4'h4: sel3488 = 1'h1;
      4'h8: sel3488 = sel3483;
      4'ha: sel3488 = sel3483;
      4'hb: sel3488 = 1'h1;
      4'hf: sel3488 = sel3483;
      default: sel3488 = sel3483;
    endcase
  end
  assign sel3489 = andb3491 ? reg3393 : reg3386;
  assign eq3490 = TAP3332_io_out_curr_state == 4'h8;
  assign andb3491 = eq3490 & eq3406;
  assign sel3492 = eq3397 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (TAP3332_io_out_curr_state)
      4'h3: sel3497 = sel3492;
      4'h4: sel3497 = reg3393[0];
      4'h8: sel3497 = sel3492;
      4'ha: sel3497 = sel3492;
      4'hb: sel3497 = reg3393[0];
      4'hf: sel3497 = sel3492;
      default: sel3497 = sel3492;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = TAP3332_io_JTAG_TAP_in_mode_select_ready;
  assign io_JTAG_JTAG_TAP_in_clock_ready = TAP3332_io_JTAG_TAP_in_clock_ready;
  assign io_JTAG_JTAG_TAP_in_reset_ready = TAP3332_io_JTAG_TAP_in_reset_ready;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3497;
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
  reg[11:0] mem3553 [0:4095]; // csr_handler.h(23:0)
  reg[1:0] reg3559; // csr_handler.h(25:0)
  wire eq3573; // csr_handler.h(38:1)
  wire eq3577; // csr_handler.h(31:2)
  wire eq3595; // csr_handler.h(9:0)
  reg sel3597; // csr_handler.h(31:0)
  reg[11:0] sel3598; // csr_handler.h(31:0)
  reg[1:0] sel3599; // csr_handler.h(31:0)
  reg[11:0] sel3600; // csr_handler.h(31:0)
  wire[11:0] marport3602; // csr_handler.h(53:1)
  wire[31:0] pad3604; // csr_handler.h(53:0)

  assign marport3602 = mem3553[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (sel3597) begin
      mem3553[sel3600] <= sel3598;
    end
  end
  always @ (posedge clk) begin
    if (reset)
      reg3559 <= 2'h0;
    else
      reg3559 <= sel3599;
  end
  assign eq3573 = reg3559 == 2'h1;
  assign eq3577 = reg3559 == 2'h0;
  assign eq3595 = io_in_mem_is_csr == 1'h1;
  always @(*) begin
    if (eq3577)
      sel3597 = 1'h1;
    else if (eq3573)
      sel3597 = 1'h1;
    else
      sel3597 = eq3595;
  end
  always @(*) begin
    if (eq3577)
      sel3598 = 12'h0;
    else if (eq3573)
      sel3598 = 12'h0;
    else
      sel3598 = io_in_mem_csr_result[11:0];
  end
  always @(*) begin
    if (eq3577)
      sel3599 = 2'h1;
    else if (eq3573)
      sel3599 = 2'h3;
    else
      sel3599 = reg3559;
  end
  always @(*) begin
    if (eq3577)
      sel3600 = 12'hf14;
    else if (eq3573)
      sel3600 = 12'h301;
    else
      sel3600 = io_in_mem_csr_address;
  end
  assign pad3604 = {{20{1'b0}}, marport3602};

  assign io_out_decode_csr_data = pad3604;

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
  wire Fetch156_clk; // RocketChip.h(49:1)
  wire Fetch156_reset; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_IBUS_in_data_data; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_in_data_valid; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_in_data_ready; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_IBUS_out_address_data; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_out_address_valid; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_out_address_ready; // RocketChip.h(49:1)
  wire Fetch156_io_in_branch_dir; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_in_branch_dest; // RocketChip.h(49:1)
  wire Fetch156_io_in_branch_stall; // RocketChip.h(49:1)
  wire Fetch156_io_in_fwd_stall; // RocketChip.h(49:1)
  wire Fetch156_io_in_branch_stall_exe; // RocketChip.h(49:1)
  wire Fetch156_io_in_jal; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_in_jal_dest; // RocketChip.h(49:1)
  wire Fetch156_io_in_interrupt; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_in_interrupt_pc; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_out_instruction; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_out_curr_PC; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_out_PC_next; // RocketChip.h(49:1)
  wire F_D_Register278_clk; // RocketChip.h(49:2)
  wire F_D_Register278_reset; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_in_instruction; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_in_PC_next; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_in_curr_PC; // RocketChip.h(49:2)
  wire F_D_Register278_io_in_branch_stall; // RocketChip.h(49:2)
  wire F_D_Register278_io_in_branch_stall_exe; // RocketChip.h(49:2)
  wire F_D_Register278_io_in_fwd_stall; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_out_instruction; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_out_curr_PC; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_out_PC_next; // RocketChip.h(49:2)
  wire Decode1059_clk; // RocketChip.h(49:3)
  wire Decode1059_reset; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_instruction; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_PC_next; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_curr_PC; // RocketChip.h(49:3)
  wire Decode1059_io_in_stall; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_write_data; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_in_rd; // RocketChip.h(49:3)
  wire[1:0] Decode1059_io_in_wb; // RocketChip.h(49:3)
  wire Decode1059_io_in_src1_fwd; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_src1_fwd_data; // RocketChip.h(49:3)
  wire Decode1059_io_in_src2_fwd; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_src2_fwd_data; // RocketChip.h(49:3)
  wire Decode1059_io_in_csr_fwd; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_csr_fwd_data; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_csr_data; // RocketChip.h(49:3)
  wire[11:0] Decode1059_io_out_csr_address; // RocketChip.h(49:3)
  wire Decode1059_io_out_is_csr; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_csr_data; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_csr_mask; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_out_rd; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_out_rs1; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_rd1; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_out_rs2; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_rd2; // RocketChip.h(49:3)
  wire[1:0] Decode1059_io_out_wb; // RocketChip.h(49:3)
  wire[3:0] Decode1059_io_out_alu_op; // RocketChip.h(49:3)
  wire Decode1059_io_out_rs2_src; // RocketChip.h(49:3)
  wire[11:0] Decode1059_io_out_itype_immed; // RocketChip.h(49:3)
  wire[2:0] Decode1059_io_out_mem_read; // RocketChip.h(49:3)
  wire[2:0] Decode1059_io_out_mem_write; // RocketChip.h(49:3)
  wire[2:0] Decode1059_io_out_branch_type; // RocketChip.h(49:3)
  wire Decode1059_io_out_branch_stall; // RocketChip.h(49:3)
  wire Decode1059_io_out_jal; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_jal_offset; // RocketChip.h(49:3)
  wire[19:0] Decode1059_io_out_upper_immed; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_PC_next; // RocketChip.h(49:3)
  wire D_E_Register1467_clk; // RocketChip.h(49:4)
  wire D_E_Register1467_reset; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_in_rd; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_in_rs1; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_rd1; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_in_rs2; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_rd2; // RocketChip.h(49:4)
  wire[3:0] D_E_Register1467_io_in_alu_op; // RocketChip.h(49:4)
  wire[1:0] D_E_Register1467_io_in_wb; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_rs2_src; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_in_itype_immed; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_in_mem_read; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_in_mem_write; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_PC_next; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_in_branch_type; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_fwd_stall; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_branch_stall; // RocketChip.h(49:4)
  wire[19:0] D_E_Register1467_io_in_upper_immed; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_in_csr_address; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_is_csr; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_csr_data; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_csr_mask; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_curr_PC; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_jal; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_jal_offset; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_out_csr_address; // RocketChip.h(49:4)
  wire D_E_Register1467_io_out_is_csr; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_csr_data; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_csr_mask; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_out_rd; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_out_rs1; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_rd1; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_out_rs2; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_rd2; // RocketChip.h(49:4)
  wire[3:0] D_E_Register1467_io_out_alu_op; // RocketChip.h(49:4)
  wire[1:0] D_E_Register1467_io_out_wb; // RocketChip.h(49:4)
  wire D_E_Register1467_io_out_rs2_src; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_out_itype_immed; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_out_mem_read; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_out_mem_write; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_out_branch_type; // RocketChip.h(49:4)
  wire[19:0] D_E_Register1467_io_out_upper_immed; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_curr_PC; // RocketChip.h(49:4)
  wire D_E_Register1467_io_out_jal; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_jal_offset; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_PC_next; // RocketChip.h(49:4)
  wire[4:0] Execute1799_io_in_rd; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_in_rs1; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_rd1; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_in_rs2; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_rd2; // RocketChip.h(49:5)
  wire[3:0] Execute1799_io_in_alu_op; // RocketChip.h(49:5)
  wire[1:0] Execute1799_io_in_wb; // RocketChip.h(49:5)
  wire Execute1799_io_in_rs2_src; // RocketChip.h(49:5)
  wire[11:0] Execute1799_io_in_itype_immed; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_in_mem_read; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_in_mem_write; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_PC_next; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_in_branch_type; // RocketChip.h(49:5)
  wire[19:0] Execute1799_io_in_upper_immed; // RocketChip.h(49:5)
  wire[11:0] Execute1799_io_in_csr_address; // RocketChip.h(49:5)
  wire Execute1799_io_in_is_csr; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_csr_data; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_csr_mask; // RocketChip.h(49:5)
  wire Execute1799_io_in_jal; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_jal_offset; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_curr_PC; // RocketChip.h(49:5)
  wire[11:0] Execute1799_io_out_csr_address; // RocketChip.h(49:5)
  wire Execute1799_io_out_is_csr; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_csr_result; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_alu_result; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_out_rd; // RocketChip.h(49:5)
  wire[1:0] Execute1799_io_out_wb; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_out_rs1; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_rd1; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_out_rs2; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_rd2; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_out_mem_read; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_out_mem_write; // RocketChip.h(49:5)
  wire Execute1799_io_out_jal; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_jal_dest; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_branch_offset; // RocketChip.h(49:5)
  wire Execute1799_io_out_branch_stall; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_PC_next; // RocketChip.h(49:5)
  wire E_M_Register2083_clk; // RocketChip.h(49:6)
  wire E_M_Register2083_reset; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_alu_result; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_in_rd; // RocketChip.h(49:6)
  wire[1:0] E_M_Register2083_io_in_wb; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_in_rs1; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_rd1; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_in_rs2; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_rd2; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_in_mem_read; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_in_mem_write; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_PC_next; // RocketChip.h(49:6)
  wire[11:0] E_M_Register2083_io_in_csr_address; // RocketChip.h(49:6)
  wire E_M_Register2083_io_in_is_csr; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_csr_result; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_curr_PC; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_branch_offset; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_in_branch_type; // RocketChip.h(49:6)
  wire[11:0] E_M_Register2083_io_out_csr_address; // RocketChip.h(49:6)
  wire E_M_Register2083_io_out_is_csr; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_csr_result; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_alu_result; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_out_rd; // RocketChip.h(49:6)
  wire[1:0] E_M_Register2083_io_out_wb; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_out_rs1; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_rd1; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_rd2; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_out_rs2; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_out_mem_read; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_out_mem_write; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_curr_PC; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_branch_offset; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_out_branch_type; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_PC_next; // RocketChip.h(49:6)
  wire[31:0] Memory2513_io_DBUS_in_data_data; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_in_data_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_in_data_ready; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_DBUS_out_data_data; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_data_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_data_ready; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_DBUS_out_address_data; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_address_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_address_ready; // RocketChip.h(49:7)
  wire[1:0] Memory2513_io_DBUS_out_control_data; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_control_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_control_ready; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_alu_result; // RocketChip.h(49:7)
  wire[2:0] Memory2513_io_in_mem_read; // RocketChip.h(49:7)
  wire[2:0] Memory2513_io_in_mem_write; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_in_rd; // RocketChip.h(49:7)
  wire[1:0] Memory2513_io_in_wb; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_in_rs1; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_rd1; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_in_rs2; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_rd2; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_PC_next; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_curr_PC; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_branch_offset; // RocketChip.h(49:7)
  wire[2:0] Memory2513_io_in_branch_type; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_alu_result; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_mem_result; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_out_rd; // RocketChip.h(49:7)
  wire[1:0] Memory2513_io_out_wb; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_out_rs1; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_out_rs2; // RocketChip.h(49:7)
  wire Memory2513_io_out_branch_dir; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_branch_dest; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_PC_next; // RocketChip.h(49:7)
  wire M_W_Register2692_clk; // RocketChip.h(49:8)
  wire M_W_Register2692_reset; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_in_alu_result; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_in_mem_result; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_in_rd; // RocketChip.h(49:8)
  wire[1:0] M_W_Register2692_io_in_wb; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_in_rs1; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_in_rs2; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_in_PC_next; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_out_alu_result; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_out_mem_result; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_out_rd; // RocketChip.h(49:8)
  wire[1:0] M_W_Register2692_io_out_wb; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_out_rs1; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_out_rs2; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_out_PC_next; // RocketChip.h(49:8)
  wire[31:0] Write_Back2765_io_in_alu_result; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_in_mem_result; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_in_rd; // RocketChip.h(49:9)
  wire[1:0] Write_Back2765_io_in_wb; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_in_rs1; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_in_rs2; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_in_PC_next; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_out_write_data; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_out_rd; // RocketChip.h(49:9)
  wire[1:0] Write_Back2765_io_out_wb; // RocketChip.h(49:9)
  wire[4:0] Forwarding3049_io_in_decode_src1; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_decode_src2; // RocketChip.h(49:10)
  wire[11:0] Forwarding3049_io_in_decode_csr_address; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_execute_dest; // RocketChip.h(49:10)
  wire[1:0] Forwarding3049_io_in_execute_wb; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_execute_alu_result; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_execute_PC_next; // RocketChip.h(49:10)
  wire Forwarding3049_io_in_execute_is_csr; // RocketChip.h(49:10)
  wire[11:0] Forwarding3049_io_in_execute_csr_address; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_execute_csr_result; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_memory_dest; // RocketChip.h(49:10)
  wire[1:0] Forwarding3049_io_in_memory_wb; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_alu_result; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_mem_data; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_PC_next; // RocketChip.h(49:10)
  wire Forwarding3049_io_in_memory_is_csr; // RocketChip.h(49:10)
  wire[11:0] Forwarding3049_io_in_memory_csr_address; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_csr_result; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_writeback_dest; // RocketChip.h(49:10)
  wire[1:0] Forwarding3049_io_in_writeback_wb; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_writeback_alu_result; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_writeback_mem_data; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_writeback_PC_next; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_src1_fwd; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_out_src1_fwd_data; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_src2_fwd; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_out_src2_fwd_data; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_csr_fwd; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_out_csr_fwd_data; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_fwd_stall; // RocketChip.h(49:10)
  wire Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_data; // RocketChip.h(49:11)
  wire Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_valid; // RocketChip.h(49:11)
  wire Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_ready; // RocketChip.h(49:11)
  wire Interrupt_Handler3154_io_out_interrupt; // RocketChip.h(49:11)
  wire[31:0] Interrupt_Handler3154_io_out_interrupt_pc; // RocketChip.h(49:11)
  wire JTAG3500_clk; // RocketChip.h(49:12)
  wire JTAG3500_reset; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_valid; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_clock_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_clock_valid; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_clock_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_reset_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_reset_valid; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_reset_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_in_data_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_in_data_valid; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_in_data_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_out_data_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_out_data_valid; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_out_data_ready; // RocketChip.h(49:12)
  wire CSR_Handler3607_clk; // RocketChip.h(49:13)
  wire CSR_Handler3607_reset; // RocketChip.h(49:13)
  wire[11:0] CSR_Handler3607_io_in_decode_csr_address; // RocketChip.h(49:13)
  wire[11:0] CSR_Handler3607_io_in_mem_csr_address; // RocketChip.h(49:13)
  wire CSR_Handler3607_io_in_mem_is_csr; // RocketChip.h(49:13)
  wire[31:0] CSR_Handler3607_io_in_mem_csr_result; // RocketChip.h(49:13)
  wire[31:0] CSR_Handler3607_io_out_decode_csr_data; // RocketChip.h(49:13)
  wire orl3624; // RocketChip.h(67:0)
  wire eq3629; // RocketChip.h(266:1)
  wire eq3633; // RocketChip.h(266:3)
  wire orl3635; // RocketChip.h(266:3)

  assign Fetch156_clk = clk;
  assign Fetch156_reset = reset;
  Fetch Fetch156(.clk(Fetch156_clk), .reset(Fetch156_reset), .io_IBUS_in_data_data(Fetch156_io_IBUS_in_data_data), .io_IBUS_in_data_valid(Fetch156_io_IBUS_in_data_valid), .io_IBUS_out_address_ready(Fetch156_io_IBUS_out_address_ready), .io_in_branch_dir(Fetch156_io_in_branch_dir), .io_in_branch_dest(Fetch156_io_in_branch_dest), .io_in_branch_stall(Fetch156_io_in_branch_stall), .io_in_fwd_stall(Fetch156_io_in_fwd_stall), .io_in_branch_stall_exe(Fetch156_io_in_branch_stall_exe), .io_in_jal(Fetch156_io_in_jal), .io_in_jal_dest(Fetch156_io_in_jal_dest), .io_in_interrupt(Fetch156_io_in_interrupt), .io_in_interrupt_pc(Fetch156_io_in_interrupt_pc), .io_IBUS_in_data_ready(Fetch156_io_IBUS_in_data_ready), .io_IBUS_out_address_data(Fetch156_io_IBUS_out_address_data), .io_IBUS_out_address_valid(Fetch156_io_IBUS_out_address_valid), .io_out_instruction(Fetch156_io_out_instruction), .io_out_curr_PC(Fetch156_io_out_curr_PC), .io_out_PC_next(Fetch156_io_out_PC_next));
  assign Fetch156_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign Fetch156_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign Fetch156_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign Fetch156_io_in_branch_dir = Memory2513_io_out_branch_dir;
  assign Fetch156_io_in_branch_dest = Memory2513_io_out_branch_dest;
  assign Fetch156_io_in_branch_stall = Decode1059_io_out_branch_stall;
  assign Fetch156_io_in_fwd_stall = Forwarding3049_io_out_fwd_stall;
  assign Fetch156_io_in_branch_stall_exe = Execute1799_io_out_branch_stall;
  assign Fetch156_io_in_jal = Execute1799_io_out_jal;
  assign Fetch156_io_in_jal_dest = Execute1799_io_out_jal_dest;
  assign Fetch156_io_in_interrupt = Interrupt_Handler3154_io_out_interrupt;
  assign Fetch156_io_in_interrupt_pc = Interrupt_Handler3154_io_out_interrupt_pc;
  assign F_D_Register278_clk = clk;
  assign F_D_Register278_reset = reset;
  F_D_Register F_D_Register278(.clk(F_D_Register278_clk), .reset(F_D_Register278_reset), .io_in_instruction(F_D_Register278_io_in_instruction), .io_in_PC_next(F_D_Register278_io_in_PC_next), .io_in_curr_PC(F_D_Register278_io_in_curr_PC), .io_in_branch_stall(F_D_Register278_io_in_branch_stall), .io_in_branch_stall_exe(F_D_Register278_io_in_branch_stall_exe), .io_in_fwd_stall(F_D_Register278_io_in_fwd_stall), .io_out_instruction(F_D_Register278_io_out_instruction), .io_out_curr_PC(F_D_Register278_io_out_curr_PC), .io_out_PC_next(F_D_Register278_io_out_PC_next));
  assign F_D_Register278_io_in_instruction = Fetch156_io_out_instruction;
  assign F_D_Register278_io_in_PC_next = Fetch156_io_out_PC_next;
  assign F_D_Register278_io_in_curr_PC = Fetch156_io_out_curr_PC;
  assign F_D_Register278_io_in_branch_stall = Decode1059_io_out_branch_stall;
  assign F_D_Register278_io_in_branch_stall_exe = Execute1799_io_out_branch_stall;
  assign F_D_Register278_io_in_fwd_stall = Forwarding3049_io_out_fwd_stall;
  assign Decode1059_clk = clk;
  assign Decode1059_reset = reset;
  Decode Decode1059(.clk(Decode1059_clk), .reset(Decode1059_reset), .io_in_instruction(Decode1059_io_in_instruction), .io_in_PC_next(Decode1059_io_in_PC_next), .io_in_curr_PC(Decode1059_io_in_curr_PC), .io_in_stall(Decode1059_io_in_stall), .io_in_write_data(Decode1059_io_in_write_data), .io_in_rd(Decode1059_io_in_rd), .io_in_wb(Decode1059_io_in_wb), .io_in_src1_fwd(Decode1059_io_in_src1_fwd), .io_in_src1_fwd_data(Decode1059_io_in_src1_fwd_data), .io_in_src2_fwd(Decode1059_io_in_src2_fwd), .io_in_src2_fwd_data(Decode1059_io_in_src2_fwd_data), .io_in_csr_fwd(Decode1059_io_in_csr_fwd), .io_in_csr_fwd_data(Decode1059_io_in_csr_fwd_data), .io_in_csr_data(Decode1059_io_in_csr_data), .io_out_csr_address(Decode1059_io_out_csr_address), .io_out_is_csr(Decode1059_io_out_is_csr), .io_out_csr_data(Decode1059_io_out_csr_data), .io_out_csr_mask(Decode1059_io_out_csr_mask), .io_out_rd(Decode1059_io_out_rd), .io_out_rs1(Decode1059_io_out_rs1), .io_out_rd1(Decode1059_io_out_rd1), .io_out_rs2(Decode1059_io_out_rs2), .io_out_rd2(Decode1059_io_out_rd2), .io_out_wb(Decode1059_io_out_wb), .io_out_alu_op(Decode1059_io_out_alu_op), .io_out_rs2_src(Decode1059_io_out_rs2_src), .io_out_itype_immed(Decode1059_io_out_itype_immed), .io_out_mem_read(Decode1059_io_out_mem_read), .io_out_mem_write(Decode1059_io_out_mem_write), .io_out_branch_type(Decode1059_io_out_branch_type), .io_out_branch_stall(Decode1059_io_out_branch_stall), .io_out_jal(Decode1059_io_out_jal), .io_out_jal_offset(Decode1059_io_out_jal_offset), .io_out_upper_immed(Decode1059_io_out_upper_immed), .io_out_PC_next(Decode1059_io_out_PC_next));
  assign Decode1059_io_in_instruction = F_D_Register278_io_out_instruction;
  assign Decode1059_io_in_PC_next = F_D_Register278_io_out_PC_next;
  assign Decode1059_io_in_curr_PC = F_D_Register278_io_out_curr_PC;
  assign Decode1059_io_in_stall = orl3635;
  assign Decode1059_io_in_write_data = Write_Back2765_io_out_write_data;
  assign Decode1059_io_in_rd = Write_Back2765_io_out_rd;
  assign Decode1059_io_in_wb = Write_Back2765_io_out_wb;
  assign Decode1059_io_in_src1_fwd = Forwarding3049_io_out_src1_fwd;
  assign Decode1059_io_in_src1_fwd_data = Forwarding3049_io_out_src1_fwd_data;
  assign Decode1059_io_in_src2_fwd = Forwarding3049_io_out_src2_fwd;
  assign Decode1059_io_in_src2_fwd_data = Forwarding3049_io_out_src2_fwd_data;
  assign Decode1059_io_in_csr_fwd = Forwarding3049_io_out_csr_fwd;
  assign Decode1059_io_in_csr_fwd_data = Forwarding3049_io_out_csr_fwd_data;
  assign Decode1059_io_in_csr_data = CSR_Handler3607_io_out_decode_csr_data;
  assign D_E_Register1467_clk = clk;
  assign D_E_Register1467_reset = reset;
  D_E_Register D_E_Register1467(.clk(D_E_Register1467_clk), .reset(D_E_Register1467_reset), .io_in_rd(D_E_Register1467_io_in_rd), .io_in_rs1(D_E_Register1467_io_in_rs1), .io_in_rd1(D_E_Register1467_io_in_rd1), .io_in_rs2(D_E_Register1467_io_in_rs2), .io_in_rd2(D_E_Register1467_io_in_rd2), .io_in_alu_op(D_E_Register1467_io_in_alu_op), .io_in_wb(D_E_Register1467_io_in_wb), .io_in_rs2_src(D_E_Register1467_io_in_rs2_src), .io_in_itype_immed(D_E_Register1467_io_in_itype_immed), .io_in_mem_read(D_E_Register1467_io_in_mem_read), .io_in_mem_write(D_E_Register1467_io_in_mem_write), .io_in_PC_next(D_E_Register1467_io_in_PC_next), .io_in_branch_type(D_E_Register1467_io_in_branch_type), .io_in_fwd_stall(D_E_Register1467_io_in_fwd_stall), .io_in_branch_stall(D_E_Register1467_io_in_branch_stall), .io_in_upper_immed(D_E_Register1467_io_in_upper_immed), .io_in_csr_address(D_E_Register1467_io_in_csr_address), .io_in_is_csr(D_E_Register1467_io_in_is_csr), .io_in_csr_data(D_E_Register1467_io_in_csr_data), .io_in_csr_mask(D_E_Register1467_io_in_csr_mask), .io_in_curr_PC(D_E_Register1467_io_in_curr_PC), .io_in_jal(D_E_Register1467_io_in_jal), .io_in_jal_offset(D_E_Register1467_io_in_jal_offset), .io_out_csr_address(D_E_Register1467_io_out_csr_address), .io_out_is_csr(D_E_Register1467_io_out_is_csr), .io_out_csr_data(D_E_Register1467_io_out_csr_data), .io_out_csr_mask(D_E_Register1467_io_out_csr_mask), .io_out_rd(D_E_Register1467_io_out_rd), .io_out_rs1(D_E_Register1467_io_out_rs1), .io_out_rd1(D_E_Register1467_io_out_rd1), .io_out_rs2(D_E_Register1467_io_out_rs2), .io_out_rd2(D_E_Register1467_io_out_rd2), .io_out_alu_op(D_E_Register1467_io_out_alu_op), .io_out_wb(D_E_Register1467_io_out_wb), .io_out_rs2_src(D_E_Register1467_io_out_rs2_src), .io_out_itype_immed(D_E_Register1467_io_out_itype_immed), .io_out_mem_read(D_E_Register1467_io_out_mem_read), .io_out_mem_write(D_E_Register1467_io_out_mem_write), .io_out_branch_type(D_E_Register1467_io_out_branch_type), .io_out_upper_immed(D_E_Register1467_io_out_upper_immed), .io_out_curr_PC(D_E_Register1467_io_out_curr_PC), .io_out_jal(D_E_Register1467_io_out_jal), .io_out_jal_offset(D_E_Register1467_io_out_jal_offset), .io_out_PC_next(D_E_Register1467_io_out_PC_next));
  assign D_E_Register1467_io_in_rd = Decode1059_io_out_rd;
  assign D_E_Register1467_io_in_rs1 = Decode1059_io_out_rs1;
  assign D_E_Register1467_io_in_rd1 = Decode1059_io_out_rd1;
  assign D_E_Register1467_io_in_rs2 = Decode1059_io_out_rs2;
  assign D_E_Register1467_io_in_rd2 = Decode1059_io_out_rd2;
  assign D_E_Register1467_io_in_alu_op = Decode1059_io_out_alu_op;
  assign D_E_Register1467_io_in_wb = Decode1059_io_out_wb;
  assign D_E_Register1467_io_in_rs2_src = Decode1059_io_out_rs2_src;
  assign D_E_Register1467_io_in_itype_immed = Decode1059_io_out_itype_immed;
  assign D_E_Register1467_io_in_mem_read = Decode1059_io_out_mem_read;
  assign D_E_Register1467_io_in_mem_write = Decode1059_io_out_mem_write;
  assign D_E_Register1467_io_in_PC_next = Decode1059_io_out_PC_next;
  assign D_E_Register1467_io_in_branch_type = Decode1059_io_out_branch_type;
  assign D_E_Register1467_io_in_fwd_stall = Forwarding3049_io_out_fwd_stall;
  assign D_E_Register1467_io_in_branch_stall = Execute1799_io_out_branch_stall;
  assign D_E_Register1467_io_in_upper_immed = Decode1059_io_out_upper_immed;
  assign D_E_Register1467_io_in_csr_address = Decode1059_io_out_csr_address;
  assign D_E_Register1467_io_in_is_csr = Decode1059_io_out_is_csr;
  assign D_E_Register1467_io_in_csr_data = Decode1059_io_out_csr_data;
  assign D_E_Register1467_io_in_csr_mask = Decode1059_io_out_csr_mask;
  assign D_E_Register1467_io_in_curr_PC = F_D_Register278_io_out_curr_PC;
  assign D_E_Register1467_io_in_jal = Decode1059_io_out_jal;
  assign D_E_Register1467_io_in_jal_offset = Decode1059_io_out_jal_offset;
  Execute Execute1799(.io_in_rd(Execute1799_io_in_rd), .io_in_rs1(Execute1799_io_in_rs1), .io_in_rd1(Execute1799_io_in_rd1), .io_in_rs2(Execute1799_io_in_rs2), .io_in_rd2(Execute1799_io_in_rd2), .io_in_alu_op(Execute1799_io_in_alu_op), .io_in_wb(Execute1799_io_in_wb), .io_in_rs2_src(Execute1799_io_in_rs2_src), .io_in_itype_immed(Execute1799_io_in_itype_immed), .io_in_mem_read(Execute1799_io_in_mem_read), .io_in_mem_write(Execute1799_io_in_mem_write), .io_in_PC_next(Execute1799_io_in_PC_next), .io_in_branch_type(Execute1799_io_in_branch_type), .io_in_upper_immed(Execute1799_io_in_upper_immed), .io_in_csr_address(Execute1799_io_in_csr_address), .io_in_is_csr(Execute1799_io_in_is_csr), .io_in_csr_data(Execute1799_io_in_csr_data), .io_in_csr_mask(Execute1799_io_in_csr_mask), .io_in_jal(Execute1799_io_in_jal), .io_in_jal_offset(Execute1799_io_in_jal_offset), .io_in_curr_PC(Execute1799_io_in_curr_PC), .io_out_csr_address(Execute1799_io_out_csr_address), .io_out_is_csr(Execute1799_io_out_is_csr), .io_out_csr_result(Execute1799_io_out_csr_result), .io_out_alu_result(Execute1799_io_out_alu_result), .io_out_rd(Execute1799_io_out_rd), .io_out_wb(Execute1799_io_out_wb), .io_out_rs1(Execute1799_io_out_rs1), .io_out_rd1(Execute1799_io_out_rd1), .io_out_rs2(Execute1799_io_out_rs2), .io_out_rd2(Execute1799_io_out_rd2), .io_out_mem_read(Execute1799_io_out_mem_read), .io_out_mem_write(Execute1799_io_out_mem_write), .io_out_jal(Execute1799_io_out_jal), .io_out_jal_dest(Execute1799_io_out_jal_dest), .io_out_branch_offset(Execute1799_io_out_branch_offset), .io_out_branch_stall(Execute1799_io_out_branch_stall), .io_out_PC_next(Execute1799_io_out_PC_next));
  assign Execute1799_io_in_rd = D_E_Register1467_io_out_rd;
  assign Execute1799_io_in_rs1 = D_E_Register1467_io_out_rs1;
  assign Execute1799_io_in_rd1 = D_E_Register1467_io_out_rd1;
  assign Execute1799_io_in_rs2 = D_E_Register1467_io_out_rs2;
  assign Execute1799_io_in_rd2 = D_E_Register1467_io_out_rd2;
  assign Execute1799_io_in_alu_op = D_E_Register1467_io_out_alu_op;
  assign Execute1799_io_in_wb = D_E_Register1467_io_out_wb;
  assign Execute1799_io_in_rs2_src = D_E_Register1467_io_out_rs2_src;
  assign Execute1799_io_in_itype_immed = D_E_Register1467_io_out_itype_immed;
  assign Execute1799_io_in_mem_read = D_E_Register1467_io_out_mem_read;
  assign Execute1799_io_in_mem_write = D_E_Register1467_io_out_mem_write;
  assign Execute1799_io_in_PC_next = D_E_Register1467_io_out_PC_next;
  assign Execute1799_io_in_branch_type = D_E_Register1467_io_out_branch_type;
  assign Execute1799_io_in_upper_immed = D_E_Register1467_io_out_upper_immed;
  assign Execute1799_io_in_csr_address = D_E_Register1467_io_out_csr_address;
  assign Execute1799_io_in_is_csr = D_E_Register1467_io_out_is_csr;
  assign Execute1799_io_in_csr_data = D_E_Register1467_io_out_csr_data;
  assign Execute1799_io_in_csr_mask = D_E_Register1467_io_out_csr_mask;
  assign Execute1799_io_in_jal = D_E_Register1467_io_out_jal;
  assign Execute1799_io_in_jal_offset = D_E_Register1467_io_out_jal_offset;
  assign Execute1799_io_in_curr_PC = D_E_Register1467_io_out_curr_PC;
  assign E_M_Register2083_clk = clk;
  assign E_M_Register2083_reset = reset;
  E_M_Register E_M_Register2083(.clk(E_M_Register2083_clk), .reset(E_M_Register2083_reset), .io_in_alu_result(E_M_Register2083_io_in_alu_result), .io_in_rd(E_M_Register2083_io_in_rd), .io_in_wb(E_M_Register2083_io_in_wb), .io_in_rs1(E_M_Register2083_io_in_rs1), .io_in_rd1(E_M_Register2083_io_in_rd1), .io_in_rs2(E_M_Register2083_io_in_rs2), .io_in_rd2(E_M_Register2083_io_in_rd2), .io_in_mem_read(E_M_Register2083_io_in_mem_read), .io_in_mem_write(E_M_Register2083_io_in_mem_write), .io_in_PC_next(E_M_Register2083_io_in_PC_next), .io_in_csr_address(E_M_Register2083_io_in_csr_address), .io_in_is_csr(E_M_Register2083_io_in_is_csr), .io_in_csr_result(E_M_Register2083_io_in_csr_result), .io_in_curr_PC(E_M_Register2083_io_in_curr_PC), .io_in_branch_offset(E_M_Register2083_io_in_branch_offset), .io_in_branch_type(E_M_Register2083_io_in_branch_type), .io_out_csr_address(E_M_Register2083_io_out_csr_address), .io_out_is_csr(E_M_Register2083_io_out_is_csr), .io_out_csr_result(E_M_Register2083_io_out_csr_result), .io_out_alu_result(E_M_Register2083_io_out_alu_result), .io_out_rd(E_M_Register2083_io_out_rd), .io_out_wb(E_M_Register2083_io_out_wb), .io_out_rs1(E_M_Register2083_io_out_rs1), .io_out_rd1(E_M_Register2083_io_out_rd1), .io_out_rd2(E_M_Register2083_io_out_rd2), .io_out_rs2(E_M_Register2083_io_out_rs2), .io_out_mem_read(E_M_Register2083_io_out_mem_read), .io_out_mem_write(E_M_Register2083_io_out_mem_write), .io_out_curr_PC(E_M_Register2083_io_out_curr_PC), .io_out_branch_offset(E_M_Register2083_io_out_branch_offset), .io_out_branch_type(E_M_Register2083_io_out_branch_type), .io_out_PC_next(E_M_Register2083_io_out_PC_next));
  assign E_M_Register2083_io_in_alu_result = Execute1799_io_out_alu_result;
  assign E_M_Register2083_io_in_rd = Execute1799_io_out_rd;
  assign E_M_Register2083_io_in_wb = Execute1799_io_out_wb;
  assign E_M_Register2083_io_in_rs1 = Execute1799_io_out_rs1;
  assign E_M_Register2083_io_in_rd1 = Execute1799_io_out_rd1;
  assign E_M_Register2083_io_in_rs2 = Execute1799_io_out_rs2;
  assign E_M_Register2083_io_in_rd2 = Execute1799_io_out_rd2;
  assign E_M_Register2083_io_in_mem_read = Execute1799_io_out_mem_read;
  assign E_M_Register2083_io_in_mem_write = Execute1799_io_out_mem_write;
  assign E_M_Register2083_io_in_PC_next = Execute1799_io_out_PC_next;
  assign E_M_Register2083_io_in_csr_address = Execute1799_io_out_csr_address;
  assign E_M_Register2083_io_in_is_csr = Execute1799_io_out_is_csr;
  assign E_M_Register2083_io_in_csr_result = Execute1799_io_out_csr_result;
  assign E_M_Register2083_io_in_curr_PC = D_E_Register1467_io_out_curr_PC;
  assign E_M_Register2083_io_in_branch_offset = Execute1799_io_out_branch_offset;
  assign E_M_Register2083_io_in_branch_type = D_E_Register1467_io_out_branch_type;
  Memory Memory2513(.io_DBUS_in_data_data(Memory2513_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Memory2513_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Memory2513_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Memory2513_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Memory2513_io_DBUS_out_control_ready), .io_in_alu_result(Memory2513_io_in_alu_result), .io_in_mem_read(Memory2513_io_in_mem_read), .io_in_mem_write(Memory2513_io_in_mem_write), .io_in_rd(Memory2513_io_in_rd), .io_in_wb(Memory2513_io_in_wb), .io_in_rs1(Memory2513_io_in_rs1), .io_in_rd1(Memory2513_io_in_rd1), .io_in_rs2(Memory2513_io_in_rs2), .io_in_rd2(Memory2513_io_in_rd2), .io_in_PC_next(Memory2513_io_in_PC_next), .io_in_curr_PC(Memory2513_io_in_curr_PC), .io_in_branch_offset(Memory2513_io_in_branch_offset), .io_in_branch_type(Memory2513_io_in_branch_type), .io_DBUS_in_data_ready(Memory2513_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Memory2513_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Memory2513_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Memory2513_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Memory2513_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Memory2513_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Memory2513_io_DBUS_out_control_valid), .io_out_alu_result(Memory2513_io_out_alu_result), .io_out_mem_result(Memory2513_io_out_mem_result), .io_out_rd(Memory2513_io_out_rd), .io_out_wb(Memory2513_io_out_wb), .io_out_rs1(Memory2513_io_out_rs1), .io_out_rs2(Memory2513_io_out_rs2), .io_out_branch_dir(Memory2513_io_out_branch_dir), .io_out_branch_dest(Memory2513_io_out_branch_dest), .io_out_PC_next(Memory2513_io_out_PC_next));
  assign Memory2513_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Memory2513_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign Memory2513_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign Memory2513_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign Memory2513_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Memory2513_io_in_alu_result = E_M_Register2083_io_out_alu_result;
  assign Memory2513_io_in_mem_read = E_M_Register2083_io_out_mem_read;
  assign Memory2513_io_in_mem_write = E_M_Register2083_io_out_mem_write;
  assign Memory2513_io_in_rd = E_M_Register2083_io_out_rd;
  assign Memory2513_io_in_wb = E_M_Register2083_io_out_wb;
  assign Memory2513_io_in_rs1 = E_M_Register2083_io_out_rs1;
  assign Memory2513_io_in_rd1 = E_M_Register2083_io_out_rd1;
  assign Memory2513_io_in_rs2 = E_M_Register2083_io_out_rs2;
  assign Memory2513_io_in_rd2 = E_M_Register2083_io_out_rd2;
  assign Memory2513_io_in_PC_next = E_M_Register2083_io_out_PC_next;
  assign Memory2513_io_in_curr_PC = E_M_Register2083_io_out_curr_PC;
  assign Memory2513_io_in_branch_offset = E_M_Register2083_io_out_branch_offset;
  assign Memory2513_io_in_branch_type = E_M_Register2083_io_out_branch_type;
  assign M_W_Register2692_clk = clk;
  assign M_W_Register2692_reset = reset;
  M_W_Register M_W_Register2692(.clk(M_W_Register2692_clk), .reset(M_W_Register2692_reset), .io_in_alu_result(M_W_Register2692_io_in_alu_result), .io_in_mem_result(M_W_Register2692_io_in_mem_result), .io_in_rd(M_W_Register2692_io_in_rd), .io_in_wb(M_W_Register2692_io_in_wb), .io_in_rs1(M_W_Register2692_io_in_rs1), .io_in_rs2(M_W_Register2692_io_in_rs2), .io_in_PC_next(M_W_Register2692_io_in_PC_next), .io_out_alu_result(M_W_Register2692_io_out_alu_result), .io_out_mem_result(M_W_Register2692_io_out_mem_result), .io_out_rd(M_W_Register2692_io_out_rd), .io_out_wb(M_W_Register2692_io_out_wb), .io_out_rs1(M_W_Register2692_io_out_rs1), .io_out_rs2(M_W_Register2692_io_out_rs2), .io_out_PC_next(M_W_Register2692_io_out_PC_next));
  assign M_W_Register2692_io_in_alu_result = Memory2513_io_out_alu_result;
  assign M_W_Register2692_io_in_mem_result = Memory2513_io_out_mem_result;
  assign M_W_Register2692_io_in_rd = Memory2513_io_out_rd;
  assign M_W_Register2692_io_in_wb = Memory2513_io_out_wb;
  assign M_W_Register2692_io_in_rs1 = Memory2513_io_out_rs1;
  assign M_W_Register2692_io_in_rs2 = Memory2513_io_out_rs2;
  assign M_W_Register2692_io_in_PC_next = Memory2513_io_out_PC_next;
  Write_Back Write_Back2765(.io_in_alu_result(Write_Back2765_io_in_alu_result), .io_in_mem_result(Write_Back2765_io_in_mem_result), .io_in_rd(Write_Back2765_io_in_rd), .io_in_wb(Write_Back2765_io_in_wb), .io_in_rs1(Write_Back2765_io_in_rs1), .io_in_rs2(Write_Back2765_io_in_rs2), .io_in_PC_next(Write_Back2765_io_in_PC_next), .io_out_write_data(Write_Back2765_io_out_write_data), .io_out_rd(Write_Back2765_io_out_rd), .io_out_wb(Write_Back2765_io_out_wb));
  assign Write_Back2765_io_in_alu_result = M_W_Register2692_io_out_alu_result;
  assign Write_Back2765_io_in_mem_result = M_W_Register2692_io_out_mem_result;
  assign Write_Back2765_io_in_rd = M_W_Register2692_io_out_rd;
  assign Write_Back2765_io_in_wb = M_W_Register2692_io_out_wb;
  assign Write_Back2765_io_in_rs1 = M_W_Register2692_io_out_rs1;
  assign Write_Back2765_io_in_rs2 = M_W_Register2692_io_out_rs2;
  assign Write_Back2765_io_in_PC_next = M_W_Register2692_io_out_PC_next;
  Forwarding Forwarding3049(.io_in_decode_src1(Forwarding3049_io_in_decode_src1), .io_in_decode_src2(Forwarding3049_io_in_decode_src2), .io_in_decode_csr_address(Forwarding3049_io_in_decode_csr_address), .io_in_execute_dest(Forwarding3049_io_in_execute_dest), .io_in_execute_wb(Forwarding3049_io_in_execute_wb), .io_in_execute_alu_result(Forwarding3049_io_in_execute_alu_result), .io_in_execute_PC_next(Forwarding3049_io_in_execute_PC_next), .io_in_execute_is_csr(Forwarding3049_io_in_execute_is_csr), .io_in_execute_csr_address(Forwarding3049_io_in_execute_csr_address), .io_in_execute_csr_result(Forwarding3049_io_in_execute_csr_result), .io_in_memory_dest(Forwarding3049_io_in_memory_dest), .io_in_memory_wb(Forwarding3049_io_in_memory_wb), .io_in_memory_alu_result(Forwarding3049_io_in_memory_alu_result), .io_in_memory_mem_data(Forwarding3049_io_in_memory_mem_data), .io_in_memory_PC_next(Forwarding3049_io_in_memory_PC_next), .io_in_memory_is_csr(Forwarding3049_io_in_memory_is_csr), .io_in_memory_csr_address(Forwarding3049_io_in_memory_csr_address), .io_in_memory_csr_result(Forwarding3049_io_in_memory_csr_result), .io_in_writeback_dest(Forwarding3049_io_in_writeback_dest), .io_in_writeback_wb(Forwarding3049_io_in_writeback_wb), .io_in_writeback_alu_result(Forwarding3049_io_in_writeback_alu_result), .io_in_writeback_mem_data(Forwarding3049_io_in_writeback_mem_data), .io_in_writeback_PC_next(Forwarding3049_io_in_writeback_PC_next), .io_out_src1_fwd(Forwarding3049_io_out_src1_fwd), .io_out_src1_fwd_data(Forwarding3049_io_out_src1_fwd_data), .io_out_src2_fwd(Forwarding3049_io_out_src2_fwd), .io_out_src2_fwd_data(Forwarding3049_io_out_src2_fwd_data), .io_out_csr_fwd(Forwarding3049_io_out_csr_fwd), .io_out_csr_fwd_data(Forwarding3049_io_out_csr_fwd_data), .io_out_fwd_stall(Forwarding3049_io_out_fwd_stall));
  assign Forwarding3049_io_in_decode_src1 = Decode1059_io_out_rs1;
  assign Forwarding3049_io_in_decode_src2 = Decode1059_io_out_rs2;
  assign Forwarding3049_io_in_decode_csr_address = Decode1059_io_out_csr_address;
  assign Forwarding3049_io_in_execute_dest = Execute1799_io_out_rd;
  assign Forwarding3049_io_in_execute_wb = Execute1799_io_out_wb;
  assign Forwarding3049_io_in_execute_alu_result = Execute1799_io_out_alu_result;
  assign Forwarding3049_io_in_execute_PC_next = Execute1799_io_out_PC_next;
  assign Forwarding3049_io_in_execute_is_csr = Execute1799_io_out_is_csr;
  assign Forwarding3049_io_in_execute_csr_address = Execute1799_io_out_csr_address;
  assign Forwarding3049_io_in_execute_csr_result = Execute1799_io_out_csr_result;
  assign Forwarding3049_io_in_memory_dest = Memory2513_io_out_rd;
  assign Forwarding3049_io_in_memory_wb = Memory2513_io_out_wb;
  assign Forwarding3049_io_in_memory_alu_result = Memory2513_io_out_alu_result;
  assign Forwarding3049_io_in_memory_mem_data = Memory2513_io_out_mem_result;
  assign Forwarding3049_io_in_memory_PC_next = Memory2513_io_out_PC_next;
  assign Forwarding3049_io_in_memory_is_csr = E_M_Register2083_io_out_is_csr;
  assign Forwarding3049_io_in_memory_csr_address = E_M_Register2083_io_out_csr_address;
  assign Forwarding3049_io_in_memory_csr_result = E_M_Register2083_io_out_csr_result;
  assign Forwarding3049_io_in_writeback_dest = M_W_Register2692_io_out_rd;
  assign Forwarding3049_io_in_writeback_wb = M_W_Register2692_io_out_wb;
  assign Forwarding3049_io_in_writeback_alu_result = M_W_Register2692_io_out_alu_result;
  assign Forwarding3049_io_in_writeback_mem_data = M_W_Register2692_io_out_mem_result;
  assign Forwarding3049_io_in_writeback_PC_next = M_W_Register2692_io_out_PC_next;
  Interrupt_Handler Interrupt_Handler3154(.io_INTERRUPT_in_interrupt_id_data(Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_data), .io_INTERRUPT_in_interrupt_id_valid(Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_valid), .io_INTERRUPT_in_interrupt_id_ready(Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_ready), .io_out_interrupt(Interrupt_Handler3154_io_out_interrupt), .io_out_interrupt_pc(Interrupt_Handler3154_io_out_interrupt_pc));
  assign Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_data = io_INTERRUPT_in_interrupt_id_data;
  assign Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_valid = io_INTERRUPT_in_interrupt_id_valid;
  assign JTAG3500_clk = clk;
  assign JTAG3500_reset = reset;
  JTAG JTAG3500(.clk(JTAG3500_clk), .reset(JTAG3500_reset), .io_JTAG_JTAG_TAP_in_mode_select_data(JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_data), .io_JTAG_JTAG_TAP_in_mode_select_valid(JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_valid), .io_JTAG_JTAG_TAP_in_clock_data(JTAG3500_io_JTAG_JTAG_TAP_in_clock_data), .io_JTAG_JTAG_TAP_in_clock_valid(JTAG3500_io_JTAG_JTAG_TAP_in_clock_valid), .io_JTAG_JTAG_TAP_in_reset_data(JTAG3500_io_JTAG_JTAG_TAP_in_reset_data), .io_JTAG_JTAG_TAP_in_reset_valid(JTAG3500_io_JTAG_JTAG_TAP_in_reset_valid), .io_JTAG_in_data_data(JTAG3500_io_JTAG_in_data_data), .io_JTAG_in_data_valid(JTAG3500_io_JTAG_in_data_valid), .io_JTAG_out_data_ready(JTAG3500_io_JTAG_out_data_ready), .io_JTAG_JTAG_TAP_in_mode_select_ready(JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_ready), .io_JTAG_JTAG_TAP_in_clock_ready(JTAG3500_io_JTAG_JTAG_TAP_in_clock_ready), .io_JTAG_JTAG_TAP_in_reset_ready(JTAG3500_io_JTAG_JTAG_TAP_in_reset_ready), .io_JTAG_in_data_ready(JTAG3500_io_JTAG_in_data_ready), .io_JTAG_out_data_data(JTAG3500_io_JTAG_out_data_data), .io_JTAG_out_data_valid(JTAG3500_io_JTAG_out_data_valid));
  assign JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_data = io_jtag_JTAG_TAP_in_mode_select_data;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_valid = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_clock_data = io_jtag_JTAG_TAP_in_clock_data;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_clock_valid = io_jtag_JTAG_TAP_in_clock_valid;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_reset_data = io_jtag_JTAG_TAP_in_reset_data;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_reset_valid = io_jtag_JTAG_TAP_in_reset_valid;
  assign JTAG3500_io_JTAG_in_data_data = io_jtag_in_data_data;
  assign JTAG3500_io_JTAG_in_data_valid = io_jtag_in_data_valid;
  assign JTAG3500_io_JTAG_out_data_ready = io_jtag_out_data_ready;
  assign CSR_Handler3607_clk = clk;
  assign CSR_Handler3607_reset = reset;
  CSR_Handler CSR_Handler3607(.clk(CSR_Handler3607_clk), .reset(CSR_Handler3607_reset), .io_in_decode_csr_address(CSR_Handler3607_io_in_decode_csr_address), .io_in_mem_csr_address(CSR_Handler3607_io_in_mem_csr_address), .io_in_mem_is_csr(CSR_Handler3607_io_in_mem_is_csr), .io_in_mem_csr_result(CSR_Handler3607_io_in_mem_csr_result), .io_out_decode_csr_data(CSR_Handler3607_io_out_decode_csr_data));
  assign CSR_Handler3607_io_in_decode_csr_address = Decode1059_io_out_csr_address;
  assign CSR_Handler3607_io_in_mem_csr_address = E_M_Register2083_io_out_csr_address;
  assign CSR_Handler3607_io_in_mem_is_csr = E_M_Register2083_io_out_is_csr;
  assign CSR_Handler3607_io_in_mem_csr_result = E_M_Register2083_io_out_csr_result;
  assign orl3624 = Decode1059_io_out_branch_stall || Execute1799_io_out_branch_stall;
  assign eq3629 = Execute1799_io_out_branch_stall == 1'h1;
  assign eq3633 = Forwarding3049_io_out_fwd_stall == 1'h1;
  assign orl3635 = eq3633 || eq3629;

  assign io_IBUS_in_data_ready = Fetch156_io_IBUS_in_data_ready;
  assign io_IBUS_out_address_data = Fetch156_io_IBUS_out_address_data;
  assign io_IBUS_out_address_valid = Fetch156_io_IBUS_out_address_valid;
  assign io_DBUS_in_data_ready = Memory2513_io_DBUS_in_data_ready;
  assign io_DBUS_out_data_data = Memory2513_io_DBUS_out_data_data;
  assign io_DBUS_out_data_valid = Memory2513_io_DBUS_out_data_valid;
  assign io_DBUS_out_address_data = Memory2513_io_DBUS_out_address_data;
  assign io_DBUS_out_address_valid = Memory2513_io_DBUS_out_address_valid;
  assign io_DBUS_out_control_data = Memory2513_io_DBUS_out_control_data;
  assign io_DBUS_out_control_valid = Memory2513_io_DBUS_out_control_valid;
  assign io_INTERRUPT_in_interrupt_id_ready = Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_ready;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_ready;
  assign io_jtag_JTAG_TAP_in_clock_ready = JTAG3500_io_JTAG_JTAG_TAP_in_clock_ready;
  assign io_jtag_JTAG_TAP_in_reset_ready = JTAG3500_io_JTAG_JTAG_TAP_in_reset_ready;
  assign io_jtag_in_data_ready = JTAG3500_io_JTAG_in_data_ready;
  assign io_jtag_out_data_data = JTAG3500_io_JTAG_out_data_data;
  assign io_jtag_out_data_valid = JTAG3500_io_JTAG_out_data_valid;
  assign io_out_fwd_stall = Forwarding3049_io_out_fwd_stall;
  assign io_out_branch_stall = orl3624;

endmodule
