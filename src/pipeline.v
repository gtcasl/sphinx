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
  wire[31:0] io_IBUS_out_address_data83; // fetch.h(12:0)
  wire io_IBUS_out_address_valid86; // fetch.h(12:0)
  wire[31:0] io_out_instruction99; // fetch.h(12:0)
  wire[31:0] io_out_curr_PC102; // fetch.h(12:0)
  wire[31:0] io_out_PC_next105; // fetch.h(12:0)
  wire[31:0] proxy111; // fetch.h(38:0)
  reg[31:0] reg112; // fetch.h(38:0)
  wire eq120; // fetch.h(41:1)
  wire eq124; // fetch.h(41:3)
  wire orl126; // fetch.h(41:3)
  wire orl128; // fetch.h(41:3)
  wire[31:0] sel131; // fetch.h(42:0)
  wire[31:0] proxy132; // fetch.h(42:0)
  wire eq135; // fetch.h(45:3)
  wire[31:0] sel137; // fetch.h(45:1)
  wire eq141; // fetch.h(45:5)
  wire[31:0] sel143; // fetch.h(45:0)
  wire[31:0] sel145; // fetch.h(46:0)
  wire[31:0] proxy146; // fetch.h(46:0)
  wire proxy147; // fetch.h(49:0)
  wire[31:0] add150; // fetch.h(46:0)
  wire[31:0] proxy151; // fetch.h(46:0)
  wire[31:0] sel152; // fetch.h(54:0)
  wire[31:0] proxy153; // fetch.h(54:0)

  assign io_IBUS_out_address_data83 = proxy146;
  assign io_IBUS_out_address_valid86 = proxy147;
  assign io_out_instruction99 = proxy132;
  assign io_out_curr_PC102 = proxy146;
  assign io_out_PC_next105 = proxy151;
  assign proxy111 = proxy153;
  always @ (posedge clk) begin
    if (reset)
      reg112 <= 32'h0;
    else
      reg112 <= proxy111;
  end
  assign eq120 = io_in_fwd_stall == 1'h1;
  assign eq124 = io_in_branch_stall == 1'h1;
  assign orl126 = eq124 || eq120;
  assign orl128 = orl126 || io_in_branch_stall_exe;
  assign sel131 = orl128 ? 32'h0 : io_IBUS_in_data_data;
  assign proxy132 = sel131;
  assign eq135 = io_in_branch_dir == 1'h1;
  assign sel137 = eq135 ? io_in_branch_dest : reg112;
  assign eq141 = io_in_jal == 1'h1;
  assign sel143 = eq141 ? io_in_jal_dest : sel137;
  assign sel145 = io_in_interrupt ? io_in_interrupt_pc : sel143;
  assign proxy146 = sel145;
  assign proxy147 = 1'h1;
  assign add150 = proxy146 + 32'h4;
  assign proxy151 = add150;
  assign sel152 = orl128 ? proxy146 : io_out_PC_next105;
  assign proxy153 = sel152;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_valid;
  assign io_IBUS_out_address_data = io_IBUS_out_address_data83;
  assign io_IBUS_out_address_valid = io_IBUS_out_address_valid86;
  assign io_out_instruction = io_out_instruction99;
  assign io_out_curr_PC = io_out_curr_PC102;
  assign io_out_PC_next = io_out_PC_next105;

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
  wire[31:0] io_out_instruction221; // f_d_register.h(9:0)
  wire[31:0] io_out_curr_PC224; // f_d_register.h(9:0)
  wire[31:0] io_out_PC_next227; // f_d_register.h(9:0)
  wire[31:0] proxy232; // f_d_register.h(28:0)
  reg[31:0] reg234; // f_d_register.h(28:0)
  wire[31:0] proxy241; // f_d_register.h(29:0)
  reg[31:0] reg243; // f_d_register.h(29:0)
  wire[31:0] proxy247; // f_d_register.h(30:0)
  reg[31:0] reg249; // f_d_register.h(30:0)
  wire eq271; // f_d_register.h(39:2)
  wire[31:0] sel273; // f_d_register.h(39:0)
  wire[31:0] sel274; // f_d_register.h(39:0)
  wire[31:0] sel275; // f_d_register.h(39:0)

  assign io_out_instruction221 = proxy232;
  assign io_out_curr_PC224 = proxy247;
  assign io_out_PC_next227 = proxy241;
  assign proxy232 = reg234;
  always @ (posedge clk) begin
    if (reset)
      reg234 <= 32'h0;
    else
      reg234 <= sel274;
  end
  assign proxy241 = reg243;
  always @ (posedge clk) begin
    if (reset)
      reg243 <= 32'h0;
    else
      reg243 <= sel275;
  end
  assign proxy247 = reg249;
  always @ (posedge clk) begin
    if (reset)
      reg249 <= 32'h0;
    else
      reg249 <= sel273;
  end
  assign eq271 = io_in_fwd_stall == 1'h0;
  assign sel273 = eq271 ? io_in_curr_PC : proxy247;
  assign sel274 = eq271 ? io_in_instruction : proxy232;
  assign sel275 = eq271 ? io_in_PC_next : proxy241;

  assign io_out_instruction = io_out_instruction221;
  assign io_out_curr_PC = io_out_curr_PC224;
  assign io_out_PC_next = io_out_PC_next227;

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
  wire[31:0] io_out_src1_data389; // decode.h(21:0)
  wire[31:0] io_out_src2_data392; // decode.h(21:0)
  reg[31:0] mem394 [0:31]; // decode.h(36:0)
  wire proxy398; // decode.h(40:0)
  reg reg400; // decode.h(40:0)
  wire proxy406; // decode.h(42:2)
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
  wire[31:0] proxy440; // decode.h(67:0)
  wire[31:0] marport441; // decode.h(68:1)
  wire eq445; // decode.h(21:0)
  wire[31:0] sel447; // decode.h(68:0)
  wire[31:0] proxy448; // decode.h(68:0)

  assign io_out_src1_data389 = proxy440;
  assign io_out_src2_data392 = proxy448;
  assign marport433 = mem394[io_in_src1];
  assign marport441 = mem394[io_in_src2];
  always @ (posedge clk) begin
    if (sel429) begin
      mem394[sel431] <= sel430;
    end
  end
  assign proxy398 = reg400;
  always @ (posedge clk) begin
    if (reset)
      reg400 <= 1'h1;
    else
      reg400 <= sel411;
  end
  assign proxy406 = proxy398;
  assign eq407 = proxy406 == 1'h1;
  assign sel411 = eq407 ? 1'h0 : proxy398;
  assign ne424 = io_in_rd != 5'h0;
  assign andl427 = io_in_write_register && ne424;
  assign sel429 = proxy398 ? 1'h1 : andl427;
  assign sel430 = proxy398 ? 32'h0 : io_in_data;
  assign sel431 = proxy398 ? 5'h0 : io_in_rd;
  assign eq437 = io_in_src1 == 5'h0;
  assign sel439 = eq437 ? 32'h0 : marport433;
  assign proxy440 = sel439;
  assign eq445 = io_in_src2 == 5'h0;
  assign sel447 = eq445 ? 32'h0 : marport441;
  assign proxy448 = sel447;

  assign io_out_src1_data = io_out_src1_data389;
  assign io_out_src2_data = io_out_src2_data392;

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
  wire[31:0] io_out_csr_data327; // decode.h(109:0)
  wire[31:0] io_out_csr_mask330; // decode.h(109:0)
  wire[4:0] io_out_rd333; // decode.h(109:0)
  wire[4:0] io_out_rs1336; // decode.h(109:0)
  wire[31:0] io_out_rd1339; // decode.h(109:0)
  wire[4:0] io_out_rs2342; // decode.h(109:0)
  wire[31:0] io_out_rd2345; // decode.h(109:0)
  wire[1:0] io_out_wb348; // decode.h(109:0)
  wire[3:0] io_out_alu_op351; // decode.h(109:0)
  wire io_out_rs2_src354; // decode.h(109:0)
  wire[2:0] io_out_mem_read360; // decode.h(109:0)
  wire[2:0] io_out_mem_write363; // decode.h(109:0)
  wire proxy450; // decode.h(109:1)
  wire RegisterFile451_clk; // decode.h(109:1)
  wire RegisterFile451_reset; // decode.h(109:1)
  wire RegisterFile451_io_in_write_register; // decode.h(109:1)
  wire[4:0] RegisterFile451_io_in_rd; // decode.h(109:1)
  wire[31:0] RegisterFile451_io_in_data; // decode.h(109:1)
  wire[4:0] proxy465; // decode.h(109:1)
  wire[4:0] RegisterFile451_io_in_src1; // decode.h(109:1)
  wire[4:0] proxy468; // decode.h(109:1)
  wire[4:0] RegisterFile451_io_in_src2; // decode.h(109:1)
  wire[31:0] proxy471; // decode.h(109:1)
  wire[31:0] RegisterFile451_io_out_src1_data; // decode.h(109:1)
  wire[31:0] proxy474; // decode.h(109:1)
  wire[31:0] RegisterFile451_io_out_src2_data; // decode.h(109:1)
  wire[6:0] proxy477; // decode.h(163:0)
  wire[31:0] proxy483; // decode.h(166:0)
  wire[31:0] proxy485; // decode.h(167:0)
  wire proxy487; // decode.h(169:0)
  wire proxy489; // decode.h(170:0)
  wire proxy491; // decode.h(171:0)
  wire proxy493; // decode.h(172:0)
  wire proxy495; // decode.h(173:0)
  wire proxy497; // decode.h(174:0)
  wire proxy499; // decode.h(175:0)
  wire proxy501; // decode.h(176:0)
  wire proxy503; // decode.h(177:0)
  wire proxy505; // decode.h(178:0)
  wire proxy507; // decode.h(179:0)
  wire proxy509; // decode.h(180:0)
  wire ne516; // decode.h(109:0)
  wire sel518; // decode.h(182:0)
  wire proxy519; // decode.h(182:0)
  wire[6:0] proxy521; // decode.h(184:0)
  wire[31:0] shr525; // decode.h(187:1)
  wire[31:0] proxy526; // decode.h(187:1)
  wire[4:0] proxy528; // decode.h(187:0)
  wire[31:0] shr532; // decode.h(188:1)
  wire[31:0] proxy533; // decode.h(188:1)
  wire[4:0] proxy535; // decode.h(188:0)
  wire[31:0] shr539; // decode.h(189:1)
  wire[31:0] proxy540; // decode.h(189:1)
  wire[4:0] proxy542; // decode.h(189:0)
  wire[31:0] shr546; // decode.h(190:1)
  wire[31:0] proxy547; // decode.h(190:1)
  wire[2:0] proxy549; // decode.h(190:0)
  wire[31:0] shr553; // decode.h(191:1)
  wire[31:0] proxy554; // decode.h(191:1)
  wire[6:0] proxy556; // decode.h(191:0)
  wire[31:0] shr559; // decode.h(192:1)
  wire[31:0] proxy560; // decode.h(192:1)
  wire[11:0] proxy562; // decode.h(192:0)
  wire[6:0] proxy565; // decode.h(208:1)
  wire eq566; // decode.h(208:1)
  wire proxy567; // decode.h(208:1)
  wire[6:0] proxy570; // decode.h(209:1)
  wire eq571; // decode.h(209:1)
  wire proxy572; // decode.h(209:1)
  wire[6:0] proxy575; // decode.h(210:1)
  wire eq576; // decode.h(210:1)
  wire orl578; // decode.h(210:1)
  wire proxy579; // decode.h(210:1)
  wire[6:0] proxy582; // decode.h(211:1)
  wire eq583; // decode.h(211:1)
  wire proxy584; // decode.h(211:1)
  wire[6:0] proxy587; // decode.h(212:1)
  wire eq588; // decode.h(212:1)
  wire proxy589; // decode.h(212:1)
  wire[6:0] proxy592; // decode.h(213:1)
  wire eq593; // decode.h(213:1)
  wire proxy594; // decode.h(213:1)
  wire[6:0] proxy597; // decode.h(214:1)
  wire eq598; // decode.h(214:1)
  wire proxy599; // decode.h(214:1)
  wire[6:0] proxy602; // decode.h(215:1)
  wire eq603; // decode.h(215:1)
  wire proxy604; // decode.h(215:1)
  wire[6:0] proxy607; // decode.h(216:1)
  wire eq608; // decode.h(216:1)
  wire proxy609; // decode.h(216:1)
  wire[2:0] proxy612; // decode.h(217:1)
  wire ne613; // decode.h(217:1)
  wire[6:0] proxy617; // decode.h(217:3)
  wire eq618; // decode.h(217:3)
  wire andl620; // decode.h(217:3)
  wire proxy621; // decode.h(217:3)
  wire proxy623; // decode.h(218:1)
  wire eq624; // decode.h(218:1)
  wire proxy626; // decode.h(218:2)
  wire andl627; // decode.h(218:2)
  wire proxy628; // decode.h(218:2)
  wire[2:0] proxy630; // decode.h(219:1)
  wire eq631; // decode.h(219:1)
  wire[6:0] proxy634; // decode.h(219:3)
  wire eq635; // decode.h(219:3)
  wire andl637; // decode.h(219:3)
  wire proxy638; // decode.h(219:3)
  wire eq641; // decode.h(225:3)
  wire[31:0] sel643; // decode.h(225:1)
  wire[31:0] sel645; // decode.h(225:0)
  wire[31:0] proxy646; // decode.h(225:0)
  wire eq649; // decode.h(226:2)
  wire[31:0] sel651; // decode.h(226:0)
  wire[31:0] proxy652; // decode.h(226:0)
  wire[31:0] pad653; // decode.h(231:1)
  wire[31:0] sel654; // decode.h(231:0)
  wire[31:0] proxy655; // decode.h(231:0)
  wire eq657; // decode.h(109:0)
  wire[31:0] sel659; // decode.h(232:0)
  wire[31:0] proxy660; // decode.h(232:0)
  wire proxy664; // decode.h(237:1)
  wire orl665; // decode.h(237:1)
  wire orl667; // decode.h(237:1)
  wire orl669; // decode.h(237:1)
  wire orl671; // decode.h(237:1)
  wire[1:0] sel673; // decode.h(238:2)
  wire[1:0] sel677; // decode.h(238:1)
  wire proxy681; // decode.h(235:1)
  wire orl682; // decode.h(235:1)
  wire orl684; // decode.h(235:1)
  wire[1:0] sel686; // decode.h(238:0)
  wire[1:0] proxy687; // decode.h(238:0)
  wire proxy690; // decode.h(239:3)
  wire orl691; // decode.h(239:3)
  wire sel693; // decode.h(239:0)
  wire proxy694; // decode.h(239:0)
  wire[2:0] sel697; // decode.h(241:0)
  wire[2:0] proxy698; // decode.h(241:0)
  wire[2:0] sel700; // decode.h(242:0)
  wire[2:0] proxy701; // decode.h(242:0)
  wire[2:0] proxy714; // decode.h(264:1)
  wire eq715; // decode.h(264:1)
  wire[2:0] proxy719; // decode.h(264:3)
  wire eq720; // decode.h(264:3)
  wire orl722; // decode.h(264:3)
  wire[11:0] pad724; // decode.h(265:0)
  wire[31:0] shr727; // decode.h(267:2)
  wire[31:0] proxy728; // decode.h(267:2)
  wire[11:0] proxy730; // decode.h(267:1)
  wire[11:0] sel731; // decode.h(267:0)
  wire[11:0] proxy749; // decode.h(292:0)
  wire[6:0] proxy750; // /home/blaise/dev/cash/include/logic.h(180:1)
  wire[31:0] shr758; // decode.h(306:1)
  wire[31:0] proxy759; // decode.h(306:1)
  wire[11:0] proxy761; // decode.h(306:0)
  wire proxy771; // decode.h(319:0)
  wire proxy773; // decode.h(320:0)
  wire[31:0] shr777; // decode.h(321:1)
  wire[31:0] proxy778; // decode.h(321:1)
  wire[3:0] proxy780; // decode.h(321:0)
  wire[31:0] shr783; // decode.h(322:1)
  wire[31:0] proxy784; // decode.h(322:1)
  wire[5:0] proxy786; // decode.h(322:0)
  wire[11:0] proxy788; // decode.h(324:0)
  wire[3:0] proxy789; // /home/blaise/dev/cash/include/logic.h(180:2)
  wire[5:0] proxy790; // /home/blaise/dev/cash/include/logic.h(180:3)
  wire proxy791; // /home/blaise/dev/cash/include/logic.h(180:4)
  wire proxy792; // /home/blaise/dev/cash/include/logic.h(180:5)
  wire lt806; // decode.h(192:0)
  wire[31:0] shr825; // decode.h(389:1)
  wire[31:0] proxy826; // decode.h(389:1)
  wire[11:0] proxy828; // decode.h(389:0)
  wire[31:0] shr838; // decode.h(401:1)
  wire[31:0] proxy839; // decode.h(401:1)
  wire[11:0] proxy841; // decode.h(401:0)
  wire[19:0] proxy849; // decode.h(413:0)
  wire[2:0] proxy850; // /home/blaise/dev/cash/include/logic.h(180:6)
  wire[6:0] proxy851; // /home/blaise/dev/cash/include/logic.h(180:9)
  wire[19:0] proxy860; // decode.h(425:0)
  wire[2:0] proxy861; // /home/blaise/dev/cash/include/logic.h(180:10)
  wire[6:0] proxy862; // /home/blaise/dev/cash/include/logic.h(180:13)
  wire[31:0] shr874; // decode.h(439:1)
  wire[31:0] proxy875; // decode.h(439:1)
  wire[7:0] proxy877; // decode.h(439:0)
  wire proxy879; // decode.h(440:0)
  wire[31:0] shr883; // decode.h(441:1)
  wire[31:0] proxy884; // decode.h(441:1)
  wire[9:0] proxy886; // decode.h(441:0)
  wire proxy888; // decode.h(442:0)
  wire proxy889; // decode.h(444:0)
  wire[20:0] proxy891; // decode.h(446:0)
  wire proxy892; // /home/blaise/dev/cash/include/logic.h(180:14)
  wire[9:0] proxy893; // /home/blaise/dev/cash/include/logic.h(180:15)
  wire proxy894; // /home/blaise/dev/cash/include/logic.h(180:16)
  wire[7:0] proxy895; // /home/blaise/dev/cash/include/logic.h(180:17)
  wire proxy896; // /home/blaise/dev/cash/include/logic.h(180:18)
  wire[31:0] pad897; // decode.h(448:1)
  wire[10:0] proxy899; // decode.h(448:3)
  wire[31:0] proxy901; // decode.h(448:2)
  wire[20:0] proxy902; // /home/blaise/dev/cash/include/logic.h(180:19)
  wire[10:0] proxy903; // /home/blaise/dev/cash/include/logic.h(180:20)
  wire eq905; // decode.h(442:0)
  wire[31:0] sel907; // decode.h(448:0)
  wire[11:0] proxy917; // decode.h(464:0)
  wire[6:0] proxy918; // /home/blaise/dev/cash/include/logic.h(180:22)
  wire[31:0] pad919; // decode.h(465:1)
  wire[19:0] proxy921; // decode.h(465:3)
  wire[31:0] proxy923; // decode.h(465:2)
  wire[11:0] proxy924; // /home/blaise/dev/cash/include/logic.h(180:23)
  wire[19:0] proxy925; // /home/blaise/dev/cash/include/logic.h(180:24)
  wire proxy927; // decode.h(465:5)
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
  wire[31:0] sel953; // decode.h(371:0)
  wire[31:0] sel954; // decode.h(368:0)
  reg[31:0] sel955; // decode.h(253:0)
  wire[19:0] sel956; // decode.h(371:0)
  wire[19:0] sel957; // decode.h(368:0)
  reg[19:0] sel958; // decode.h(253:0)
  wire sel959; // decode.h(371:0)
  wire sel960; // decode.h(368:0)
  reg sel961; // decode.h(253:0)
  wire[11:0] sel962; // decode.h(371:0)
  wire[11:0] sel963; // decode.h(368:0)
  reg[11:0] sel964; // decode.h(253:0)
  wire[6:0] proxy966; // decode.h(486:1)
  wire eq967; // decode.h(486:1)
  wire eq974; // decode.h(191:0)
  wire[3:0] sel976; // decode.h(487:1)
  wire[3:0] sel979; // decode.h(487:0)
  wire eq994; // decode.h(191:0)
  wire[3:0] sel996; // decode.h(507:0)
  reg[3:0] sel1004; // decode.h(483:0)
  wire[1:0] proxy1006; // decode.h(522:0)
  wire[1:0] proxy1010; // decode.h(525:2)
  wire eq1011; // decode.h(525:2)
  wire[3:0] sel1013; // decode.h(526:2)
  wire[1:0] proxy1018; // decode.h(524:2)
  wire eq1019; // decode.h(524:2)
  wire[3:0] sel1021; // decode.h(526:1)
  wire[1:0] proxy1026; // decode.h(523:2)
  wire eq1027; // decode.h(523:2)
  wire[3:0] sel1029; // decode.h(526:0)
  wire proxy1032; // decode.h(532:6)
  wire orl1033; // decode.h(532:6)
  wire[3:0] sel1035; // decode.h(532:4)
  wire[3:0] sel1037; // decode.h(532:3)
  wire[3:0] sel1041; // decode.h(532:2)
  wire[3:0] sel1045; // decode.h(532:1)
  wire lt1051; // decode.h(109:0)
  wire[3:0] sel1053; // decode.h(528:0)
  wire[3:0] sel1055; // decode.h(532:0)
  wire[3:0] proxy1056; // decode.h(532:0)

  assign io_out_csr_data327 = proxy660;
  assign io_out_csr_mask330 = proxy655;
  assign io_out_rd333 = proxy528;
  assign io_out_rs1336 = proxy535;
  assign io_out_rd1339 = proxy646;
  assign io_out_rs2342 = proxy542;
  assign io_out_rd2345 = proxy652;
  assign io_out_wb348 = proxy687;
  assign io_out_alu_op351 = proxy1056;
  assign io_out_rs2_src354 = proxy694;
  assign io_out_mem_read360 = proxy698;
  assign io_out_mem_write363 = proxy701;
  assign proxy450 = proxy519;
  assign RegisterFile451_clk = clk;
  assign RegisterFile451_reset = reset;
  RegisterFile RegisterFile451(.clk(RegisterFile451_clk), .reset(RegisterFile451_reset), .io_in_write_register(RegisterFile451_io_in_write_register), .io_in_rd(RegisterFile451_io_in_rd), .io_in_data(RegisterFile451_io_in_data), .io_in_src1(RegisterFile451_io_in_src1), .io_in_src2(RegisterFile451_io_in_src2), .io_out_src1_data(RegisterFile451_io_out_src1_data), .io_out_src2_data(RegisterFile451_io_out_src2_data));
  assign RegisterFile451_io_in_write_register = proxy450;
  assign RegisterFile451_io_in_rd = io_in_rd;
  assign RegisterFile451_io_in_data = io_in_write_data;
  assign proxy465 = io_out_rs1336;
  assign RegisterFile451_io_in_src1 = proxy465;
  assign proxy468 = io_out_rs2342;
  assign RegisterFile451_io_in_src2 = proxy468;
  assign proxy471 = RegisterFile451_io_out_src1_data;
  assign proxy474 = RegisterFile451_io_out_src2_data;
  assign proxy477 = proxy521;
  assign proxy483 = proxy471;
  assign proxy485 = proxy474;
  assign proxy487 = proxy579;
  assign proxy489 = proxy567;
  assign proxy491 = proxy584;
  assign proxy493 = proxy589;
  assign proxy495 = proxy572;
  assign proxy497 = proxy594;
  assign proxy499 = proxy599;
  assign proxy501 = proxy604;
  assign proxy503 = proxy609;
  assign proxy505 = proxy621;
  assign proxy507 = proxy628;
  assign proxy509 = proxy638;
  assign ne516 = io_in_wb != 2'h0;
  assign sel518 = ne516 ? 1'h1 : 1'h0;
  assign proxy519 = sel518;
  assign proxy521 = io_in_instruction[6:0];
  assign shr525 = io_in_instruction >> 32'h7;
  assign proxy526 = shr525;
  assign proxy528 = proxy526[4:0];
  assign shr532 = io_in_instruction >> 32'hf;
  assign proxy533 = shr532;
  assign proxy535 = proxy533[4:0];
  assign shr539 = io_in_instruction >> 32'h14;
  assign proxy540 = shr539;
  assign proxy542 = proxy540[4:0];
  assign shr546 = io_in_instruction >> 32'hc;
  assign proxy547 = shr546;
  assign proxy549 = proxy547[2:0];
  assign shr553 = io_in_instruction >> 32'h19;
  assign proxy554 = shr553;
  assign proxy556 = proxy554[6:0];
  assign shr559 = io_in_instruction >> 32'h14;
  assign proxy560 = shr559;
  assign proxy562 = proxy560[11:0];
  assign proxy565 = proxy477;
  assign eq566 = proxy565 == 7'h33;
  assign proxy567 = eq566;
  assign proxy570 = proxy477;
  assign eq571 = proxy570 == 7'h3;
  assign proxy572 = eq571;
  assign proxy575 = proxy477;
  assign eq576 = proxy575 == 7'h13;
  assign orl578 = eq576 || proxy495;
  assign proxy579 = orl578;
  assign proxy582 = proxy477;
  assign eq583 = proxy582 == 7'h23;
  assign proxy584 = eq583;
  assign proxy587 = proxy477;
  assign eq588 = proxy587 == 7'h63;
  assign proxy589 = eq588;
  assign proxy592 = proxy477;
  assign eq593 = proxy592 == 7'h6f;
  assign proxy594 = eq593;
  assign proxy597 = proxy477;
  assign eq598 = proxy597 == 7'h67;
  assign proxy599 = eq598;
  assign proxy602 = proxy477;
  assign eq603 = proxy602 == 7'h37;
  assign proxy604 = eq603;
  assign proxy607 = proxy477;
  assign eq608 = proxy607 == 7'h17;
  assign proxy609 = eq608;
  assign proxy612 = proxy549;
  assign ne613 = proxy612 != 3'h0;
  assign proxy617 = proxy477;
  assign eq618 = proxy617 == 7'h73;
  assign andl620 = eq618 && ne613;
  assign proxy621 = andl620;
  assign proxy623 = proxy549[2];
  assign eq624 = proxy623 == 1'h1;
  assign proxy626 = proxy505;
  assign andl627 = proxy626 && eq624;
  assign proxy628 = andl627;
  assign proxy630 = proxy549;
  assign eq631 = proxy630 == 3'h0;
  assign proxy634 = proxy477;
  assign eq635 = proxy634 == 7'h73;
  assign andl637 = eq635 && eq631;
  assign proxy638 = andl637;
  assign eq641 = io_in_src1_fwd == 1'h1;
  assign sel643 = eq641 ? io_in_src1_fwd_data : proxy483;
  assign sel645 = proxy497 ? io_in_curr_PC : sel643;
  assign proxy646 = sel645;
  assign eq649 = io_in_src2_fwd == 1'h1;
  assign sel651 = eq649 ? io_in_src2_fwd_data : proxy485;
  assign proxy652 = sel651;
  assign pad653 = {{27{1'b0}}, io_out_rs2342};
  assign sel654 = proxy507 ? pad653 : io_out_rd2345;
  assign proxy655 = sel654;
  assign eq657 = io_in_csr_fwd == 1'h1;
  assign sel659 = eq657 ? io_in_csr_fwd_data : io_in_csr_data;
  assign proxy660 = sel659;
  assign proxy664 = proxy487;
  assign orl665 = proxy664 || proxy489;
  assign orl667 = orl665 || proxy501;
  assign orl669 = orl667 || proxy503;
  assign orl671 = orl669 || proxy505;
  assign sel673 = orl671 ? 2'h1 : 2'h0;
  assign sel677 = proxy495 ? 2'h2 : sel673;
  assign proxy681 = proxy497;
  assign orl682 = proxy681 || proxy499;
  assign orl684 = orl682 || proxy509;
  assign sel686 = orl684 ? 2'h3 : sel677;
  assign proxy687 = sel686;
  assign proxy690 = proxy487;
  assign orl691 = proxy690 || proxy491;
  assign sel693 = orl691 ? 1'h1 : 1'h0;
  assign proxy694 = sel693;
  assign sel697 = proxy495 ? proxy549 : 3'h7;
  assign proxy698 = sel697;
  assign sel700 = proxy491 ? proxy549 : 3'h7;
  assign proxy701 = sel700;
  assign proxy714 = proxy549;
  assign eq715 = proxy714 == 3'h5;
  assign proxy719 = proxy549;
  assign eq720 = proxy719 == 3'h1;
  assign orl722 = eq720 || eq715;
  assign pad724 = {{7{1'b0}}, io_out_rs2342};
  assign shr727 = io_in_instruction >> 32'h14;
  assign proxy728 = shr727;
  assign proxy730 = proxy728[11:0];
  assign sel731 = orl722 ? pad724 : proxy730;
  assign proxy749 = {proxy750, io_out_rd333};
  assign proxy750 = proxy556;
  assign shr758 = io_in_instruction >> 32'h14;
  assign proxy759 = shr758;
  assign proxy761 = proxy759[11:0];
  assign proxy771 = io_in_instruction[31];
  assign proxy773 = io_in_instruction[7];
  assign shr777 = io_in_instruction >> 32'h8;
  assign proxy778 = shr777;
  assign proxy780 = proxy778[3:0];
  assign shr783 = io_in_instruction >> 32'h19;
  assign proxy784 = shr783;
  assign proxy786 = proxy784[5:0];
  assign proxy788 = {proxy792, proxy791, proxy790, proxy789};
  assign proxy789 = proxy780;
  assign proxy790 = proxy786;
  assign proxy791 = proxy773;
  assign proxy792 = proxy771;
  assign lt806 = proxy562 < 12'h2;
  assign shr825 = io_in_instruction >> 32'h14;
  assign proxy826 = shr825;
  assign proxy828 = proxy826[11:0];
  assign shr838 = io_in_instruction >> 32'h14;
  assign proxy839 = shr838;
  assign proxy841 = proxy839[11:0];
  assign proxy849 = {proxy851, io_out_rs2342, io_out_rs1336, proxy850};
  assign proxy850 = proxy549;
  assign proxy851 = proxy556;
  assign proxy860 = {proxy862, io_out_rs2342, io_out_rs1336, proxy861};
  assign proxy861 = proxy549;
  assign proxy862 = proxy556;
  assign shr874 = io_in_instruction >> 32'hc;
  assign proxy875 = shr874;
  assign proxy877 = proxy875[7:0];
  assign proxy879 = io_in_instruction[20];
  assign shr883 = io_in_instruction >> 32'h15;
  assign proxy884 = shr883;
  assign proxy886 = proxy884[9:0];
  assign proxy888 = io_in_instruction[31];
  assign proxy889 = 1'h0;
  assign proxy891 = {proxy896, proxy895, proxy894, proxy893, proxy892};
  assign proxy892 = proxy889;
  assign proxy893 = proxy886;
  assign proxy894 = proxy879;
  assign proxy895 = proxy877;
  assign proxy896 = proxy888;
  assign pad897 = {{11{1'b0}}, proxy891};
  assign proxy899 = 11'h7ff;
  assign proxy901 = {proxy903, proxy902};
  assign proxy902 = proxy891;
  assign proxy903 = proxy899;
  assign eq905 = proxy888 == 1'h1;
  assign sel907 = eq905 ? proxy901 : pad897;
  assign proxy917 = {proxy918, io_out_rs2342};
  assign proxy918 = proxy556;
  assign pad919 = {{20{1'b0}}, proxy917};
  assign proxy921 = 20'hfffff;
  assign proxy923 = {proxy925, proxy924};
  assign proxy924 = proxy917;
  assign proxy925 = proxy921;
  assign proxy927 = proxy917[11];
  assign eq928 = proxy927 == 1'h1;
  assign sel930 = eq928 ? proxy923 : pad919;
  assign sel940 = lt806 ? 12'h7b : 12'h7b;
  assign sel941 = (proxy549 == 3'h0) ? sel940 : 12'h7b;
  always @(*) begin
    case (proxy477)
      7'h13: sel942 = sel731;
      7'h33: sel942 = 12'h7b;
      7'h23: sel942 = proxy749;
      7'h03: sel942 = proxy761;
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
  assign sel944 = (proxy549 == 3'h0) ? sel943 : 1'h1;
  always @(*) begin
    case (proxy477)
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
  assign sel947 = (proxy549 == 3'h0) ? sel946 : 1'h0;
  always @(*) begin
    case (proxy477)
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
    case (proxy549)
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
  assign sel951 = (proxy549 == 3'h0) ? sel950 : 3'h0;
  always @(*) begin
    case (proxy477)
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
  assign sel953 = lt806 ? 32'hb0000000 : 32'h7b;
  assign sel954 = (proxy549 == 3'h0) ? sel953 : 32'h7b;
  always @(*) begin
    case (proxy477)
      7'h13: sel955 = 32'h7b;
      7'h33: sel955 = 32'h7b;
      7'h23: sel955 = 32'h7b;
      7'h03: sel955 = 32'h7b;
      7'h63: sel955 = 32'h7b;
      7'h73: sel955 = sel954;
      7'h37: sel955 = 32'h7b;
      7'h17: sel955 = 32'h7b;
      7'h6f: sel955 = sel907;
      7'h67: sel955 = sel930;
      default: sel955 = 32'h7b;
    endcase
  end
  assign sel956 = lt806 ? 20'h7b : 20'h7b;
  assign sel957 = (proxy549 == 3'h0) ? sel956 : 20'h7b;
  always @(*) begin
    case (proxy477)
      7'h13: sel958 = 20'h7b;
      7'h33: sel958 = 20'h7b;
      7'h23: sel958 = 20'h7b;
      7'h03: sel958 = 20'h7b;
      7'h63: sel958 = 20'h7b;
      7'h73: sel958 = sel957;
      7'h37: sel958 = proxy849;
      7'h17: sel958 = proxy860;
      7'h6f: sel958 = 20'h7b;
      7'h67: sel958 = 20'h7b;
      default: sel958 = 20'h7b;
    endcase
  end
  assign sel959 = lt806 ? 1'h1 : 1'h0;
  assign sel960 = (proxy549 == 3'h0) ? sel959 : 1'h0;
  always @(*) begin
    case (proxy477)
      7'h13: sel961 = 1'h0;
      7'h33: sel961 = 1'h0;
      7'h23: sel961 = 1'h0;
      7'h03: sel961 = 1'h0;
      7'h63: sel961 = 1'h0;
      7'h73: sel961 = sel960;
      7'h37: sel961 = 1'h0;
      7'h17: sel961 = 1'h0;
      7'h6f: sel961 = 1'h1;
      7'h67: sel961 = 1'h1;
      default: sel961 = 1'h0;
    endcase
  end
  assign sel962 = lt806 ? 12'h7b : proxy828;
  assign sel963 = (proxy549 == 3'h0) ? sel962 : proxy841;
  always @(*) begin
    case (proxy477)
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
  assign proxy966 = proxy477;
  assign eq967 = proxy966 == 7'h13;
  assign eq974 = proxy556 == 7'h0;
  assign sel976 = eq974 ? 4'h0 : 4'h1;
  assign sel979 = eq967 ? 4'h0 : sel976;
  assign eq994 = proxy556 == 7'h0;
  assign sel996 = eq994 ? 4'h6 : 4'h7;
  always @(*) begin
    case (proxy549)
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
  assign proxy1006 = proxy549[1:0];
  assign proxy1010 = proxy1006;
  assign eq1011 = proxy1010 == 2'h3;
  assign sel1013 = eq1011 ? 4'hf : 4'hf;
  assign proxy1018 = proxy1006;
  assign eq1019 = proxy1018 == 2'h2;
  assign sel1021 = eq1019 ? 4'he : sel1013;
  assign proxy1026 = proxy1006;
  assign eq1027 = proxy1026 == 2'h1;
  assign sel1029 = eq1027 ? 4'hd : sel1021;
  assign proxy1032 = proxy491;
  assign orl1033 = proxy1032 || proxy495;
  assign sel1035 = orl1033 ? 4'h0 : sel1004;
  assign sel1037 = proxy505 ? sel1029 : sel1035;
  assign sel1041 = proxy503 ? 4'hc : sel1037;
  assign sel1045 = proxy501 ? 4'hb : sel1041;
  assign lt1051 = sel952 < 3'h5;
  assign sel1053 = lt1051 ? 4'h1 : 4'ha;
  assign sel1055 = proxy493 ? sel1053 : sel1045;
  assign proxy1056 = sel1055;

  assign io_out_csr_address = sel964;
  assign io_out_is_csr = sel945;
  assign io_out_csr_data = io_out_csr_data327;
  assign io_out_csr_mask = io_out_csr_mask330;
  assign io_out_rd = io_out_rd333;
  assign io_out_rs1 = io_out_rs1336;
  assign io_out_rd1 = io_out_rd1339;
  assign io_out_rs2 = io_out_rs2342;
  assign io_out_rd2 = io_out_rd2345;
  assign io_out_wb = io_out_wb348;
  assign io_out_alu_op = io_out_alu_op351;
  assign io_out_rs2_src = io_out_rs2_src354;
  assign io_out_itype_immed = sel942;
  assign io_out_mem_read = io_out_mem_read360;
  assign io_out_mem_write = io_out_mem_write363;
  assign io_out_branch_type = sel952;
  assign io_out_branch_stall = sel948;
  assign io_out_jal = sel961;
  assign io_out_jal_offset = sel955;
  assign io_out_upper_immed = sel958;
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
  wire[11:0] io_out_csr_address1189; // d_e_register.h(21:0)
  wire io_out_is_csr1192; // d_e_register.h(21:0)
  wire[31:0] io_out_csr_data1195; // d_e_register.h(21:0)
  wire[31:0] io_out_csr_mask1198; // d_e_register.h(21:0)
  wire[4:0] io_out_rd1201; // d_e_register.h(21:0)
  wire[4:0] io_out_rs11204; // d_e_register.h(21:0)
  wire[31:0] io_out_rd11207; // d_e_register.h(21:0)
  wire[4:0] io_out_rs21210; // d_e_register.h(21:0)
  wire[31:0] io_out_rd21213; // d_e_register.h(21:0)
  wire[3:0] io_out_alu_op1216; // d_e_register.h(21:0)
  wire[1:0] io_out_wb1219; // d_e_register.h(21:0)
  wire io_out_rs2_src1222; // d_e_register.h(21:0)
  wire[11:0] io_out_itype_immed1225; // d_e_register.h(21:0)
  wire[2:0] io_out_mem_read1228; // d_e_register.h(21:0)
  wire[2:0] io_out_mem_write1231; // d_e_register.h(21:0)
  wire[2:0] io_out_branch_type1234; // d_e_register.h(21:0)
  wire[19:0] io_out_upper_immed1237; // d_e_register.h(21:0)
  wire[31:0] io_out_curr_PC1240; // d_e_register.h(21:0)
  wire io_out_jal1243; // d_e_register.h(21:0)
  wire[31:0] io_out_jal_offset1246; // d_e_register.h(21:0)
  wire[31:0] io_out_PC_next1249; // d_e_register.h(21:0)
  wire[4:0] proxy1254; // d_e_register.h(76:0)
  wire[4:0] proxy1255; // d_e_register.h(76:0)
  reg[4:0] reg1256; // d_e_register.h(76:0)
  wire[4:0] proxy1263; // d_e_register.h(77:0)
  wire[4:0] proxy1264; // d_e_register.h(77:0)
  reg[4:0] reg1265; // d_e_register.h(77:0)
  wire[31:0] proxy1270; // d_e_register.h(78:0)
  wire[31:0] proxy1271; // d_e_register.h(78:0)
  reg[31:0] reg1272; // d_e_register.h(78:0)
  wire[4:0] proxy1276; // d_e_register.h(79:0)
  wire[4:0] proxy1277; // d_e_register.h(79:0)
  reg[4:0] reg1278; // d_e_register.h(79:0)
  wire[31:0] proxy1282; // d_e_register.h(80:0)
  wire[31:0] proxy1283; // d_e_register.h(80:0)
  reg[31:0] reg1284; // d_e_register.h(80:0)
  wire[3:0] proxy1289; // d_e_register.h(81:0)
  wire[3:0] proxy1290; // d_e_register.h(81:0)
  reg[3:0] reg1291; // d_e_register.h(81:0)
  wire[1:0] proxy1296; // d_e_register.h(82:0)
  wire[1:0] proxy1297; // d_e_register.h(82:0)
  reg[1:0] reg1298; // d_e_register.h(82:0)
  wire[31:0] proxy1302; // d_e_register.h(83:0)
  wire[31:0] proxy1303; // d_e_register.h(83:0)
  reg[31:0] reg1304; // d_e_register.h(83:0)
  wire proxy1309; // d_e_register.h(84:0)
  wire proxy1310; // d_e_register.h(84:0)
  reg reg1311; // d_e_register.h(84:0)
  wire[11:0] proxy1316; // d_e_register.h(85:0)
  wire[11:0] proxy1317; // d_e_register.h(85:0)
  reg[11:0] reg1318; // d_e_register.h(85:0)
  wire[2:0] proxy1323; // d_e_register.h(86:0)
  wire[2:0] proxy1324; // d_e_register.h(86:0)
  reg[2:0] reg1325; // d_e_register.h(86:0)
  wire[2:0] proxy1329; // d_e_register.h(87:0)
  wire[2:0] proxy1330; // d_e_register.h(87:0)
  reg[2:0] reg1331; // d_e_register.h(87:0)
  wire[2:0] proxy1336; // d_e_register.h(88:0)
  wire[2:0] proxy1337; // d_e_register.h(88:0)
  reg[2:0] reg1338; // d_e_register.h(88:0)
  wire[19:0] proxy1343; // d_e_register.h(89:0)
  wire[19:0] proxy1344; // d_e_register.h(89:0)
  reg[19:0] reg1345; // d_e_register.h(89:0)
  wire[11:0] proxy1349; // d_e_register.h(90:0)
  wire[11:0] proxy1350; // d_e_register.h(90:0)
  reg[11:0] reg1351; // d_e_register.h(90:0)
  wire proxy1355; // d_e_register.h(91:0)
  wire proxy1356; // d_e_register.h(91:0)
  reg reg1357; // d_e_register.h(91:0)
  wire[31:0] proxy1361; // d_e_register.h(92:0)
  wire[31:0] proxy1362; // d_e_register.h(92:0)
  reg[31:0] reg1363; // d_e_register.h(92:0)
  wire[31:0] proxy1367; // d_e_register.h(93:0)
  wire[31:0] proxy1368; // d_e_register.h(93:0)
  reg[31:0] reg1369; // d_e_register.h(93:0)
  wire[31:0] proxy1373; // d_e_register.h(94:0)
  wire[31:0] proxy1374; // d_e_register.h(94:0)
  reg[31:0] reg1375; // d_e_register.h(94:0)
  wire proxy1379; // d_e_register.h(95:0)
  wire proxy1380; // d_e_register.h(95:0)
  reg reg1381; // d_e_register.h(95:0)
  wire[31:0] proxy1385; // d_e_register.h(96:0)
  wire[31:0] proxy1386; // d_e_register.h(96:0)
  reg[31:0] reg1387; // d_e_register.h(96:0)
  wire eq1392; // d_e_register.h(134:1)
  wire eq1396; // d_e_register.h(134:3)
  wire orl1398; // d_e_register.h(134:3)
  wire[4:0] sel1401; // d_e_register.h(137:0)
  wire[4:0] proxy1402; // d_e_register.h(137:0)
  wire[4:0] sel1404; // d_e_register.h(138:0)
  wire[4:0] proxy1405; // d_e_register.h(138:0)
  wire[31:0] sel1407; // d_e_register.h(139:0)
  wire[31:0] proxy1408; // d_e_register.h(139:0)
  wire[4:0] sel1410; // d_e_register.h(140:0)
  wire[4:0] proxy1411; // d_e_register.h(140:0)
  wire[31:0] sel1413; // d_e_register.h(141:0)
  wire[31:0] proxy1414; // d_e_register.h(141:0)
  wire[3:0] sel1417; // d_e_register.h(142:0)
  wire[3:0] proxy1418; // d_e_register.h(142:0)
  wire[1:0] sel1420; // d_e_register.h(143:0)
  wire[1:0] proxy1421; // d_e_register.h(143:0)
  wire[31:0] sel1423; // d_e_register.h(144:0)
  wire[31:0] proxy1424; // d_e_register.h(144:0)
  wire sel1426; // d_e_register.h(145:0)
  wire proxy1427; // d_e_register.h(145:0)
  wire[11:0] sel1430; // d_e_register.h(146:0)
  wire[11:0] proxy1431; // d_e_register.h(146:0)
  wire[2:0] sel1433; // d_e_register.h(147:0)
  wire[2:0] proxy1434; // d_e_register.h(147:0)
  wire[2:0] sel1436; // d_e_register.h(148:0)
  wire[2:0] proxy1437; // d_e_register.h(148:0)
  wire[2:0] sel1439; // d_e_register.h(149:0)
  wire[2:0] proxy1440; // d_e_register.h(149:0)
  wire[19:0] sel1442; // d_e_register.h(150:0)
  wire[19:0] proxy1443; // d_e_register.h(150:0)
  wire[11:0] sel1445; // d_e_register.h(151:0)
  wire[11:0] proxy1446; // d_e_register.h(151:0)
  wire sel1448; // d_e_register.h(152:0)
  wire proxy1449; // d_e_register.h(152:0)
  wire[31:0] sel1451; // d_e_register.h(153:0)
  wire[31:0] proxy1452; // d_e_register.h(153:0)
  wire[31:0] sel1454; // d_e_register.h(154:0)
  wire[31:0] proxy1455; // d_e_register.h(154:0)
  wire sel1457; // d_e_register.h(155:0)
  wire proxy1458; // d_e_register.h(155:0)
  wire[31:0] sel1460; // d_e_register.h(156:0)
  wire[31:0] proxy1461; // d_e_register.h(156:0)
  wire[31:0] sel1463; // d_e_register.h(157:0)
  wire[31:0] proxy1464; // d_e_register.h(157:0)

  assign io_out_csr_address1189 = proxy1349;
  assign io_out_is_csr1192 = proxy1355;
  assign io_out_csr_data1195 = proxy1361;
  assign io_out_csr_mask1198 = proxy1367;
  assign io_out_rd1201 = proxy1254;
  assign io_out_rs11204 = proxy1263;
  assign io_out_rd11207 = proxy1270;
  assign io_out_rs21210 = proxy1276;
  assign io_out_rd21213 = proxy1282;
  assign io_out_alu_op1216 = proxy1289;
  assign io_out_wb1219 = proxy1296;
  assign io_out_rs2_src1222 = proxy1309;
  assign io_out_itype_immed1225 = proxy1316;
  assign io_out_mem_read1228 = proxy1323;
  assign io_out_mem_write1231 = proxy1329;
  assign io_out_branch_type1234 = proxy1336;
  assign io_out_upper_immed1237 = proxy1343;
  assign io_out_curr_PC1240 = proxy1373;
  assign io_out_jal1243 = proxy1379;
  assign io_out_jal_offset1246 = proxy1385;
  assign io_out_PC_next1249 = proxy1302;
  assign proxy1254 = reg1256;
  assign proxy1255 = proxy1402;
  always @ (posedge clk) begin
    if (reset)
      reg1256 <= 5'h0;
    else
      reg1256 <= proxy1255;
  end
  assign proxy1263 = reg1265;
  assign proxy1264 = proxy1405;
  always @ (posedge clk) begin
    if (reset)
      reg1265 <= 5'h0;
    else
      reg1265 <= proxy1264;
  end
  assign proxy1270 = reg1272;
  assign proxy1271 = proxy1408;
  always @ (posedge clk) begin
    if (reset)
      reg1272 <= 32'h0;
    else
      reg1272 <= proxy1271;
  end
  assign proxy1276 = reg1278;
  assign proxy1277 = proxy1411;
  always @ (posedge clk) begin
    if (reset)
      reg1278 <= 5'h0;
    else
      reg1278 <= proxy1277;
  end
  assign proxy1282 = reg1284;
  assign proxy1283 = proxy1414;
  always @ (posedge clk) begin
    if (reset)
      reg1284 <= 32'h0;
    else
      reg1284 <= proxy1283;
  end
  assign proxy1289 = reg1291;
  assign proxy1290 = proxy1418;
  always @ (posedge clk) begin
    if (reset)
      reg1291 <= 4'h0;
    else
      reg1291 <= proxy1290;
  end
  assign proxy1296 = reg1298;
  assign proxy1297 = proxy1421;
  always @ (posedge clk) begin
    if (reset)
      reg1298 <= 2'h0;
    else
      reg1298 <= proxy1297;
  end
  assign proxy1302 = reg1304;
  assign proxy1303 = proxy1424;
  always @ (posedge clk) begin
    if (reset)
      reg1304 <= 32'h0;
    else
      reg1304 <= proxy1303;
  end
  assign proxy1309 = reg1311;
  assign proxy1310 = proxy1427;
  always @ (posedge clk) begin
    if (reset)
      reg1311 <= 1'h0;
    else
      reg1311 <= proxy1310;
  end
  assign proxy1316 = reg1318;
  assign proxy1317 = proxy1431;
  always @ (posedge clk) begin
    if (reset)
      reg1318 <= 12'h0;
    else
      reg1318 <= proxy1317;
  end
  assign proxy1323 = reg1325;
  assign proxy1324 = proxy1434;
  always @ (posedge clk) begin
    if (reset)
      reg1325 <= 3'h7;
    else
      reg1325 <= proxy1324;
  end
  assign proxy1329 = reg1331;
  assign proxy1330 = proxy1437;
  always @ (posedge clk) begin
    if (reset)
      reg1331 <= 3'h7;
    else
      reg1331 <= proxy1330;
  end
  assign proxy1336 = reg1338;
  assign proxy1337 = proxy1440;
  always @ (posedge clk) begin
    if (reset)
      reg1338 <= 3'h0;
    else
      reg1338 <= proxy1337;
  end
  assign proxy1343 = reg1345;
  assign proxy1344 = proxy1443;
  always @ (posedge clk) begin
    if (reset)
      reg1345 <= 20'h0;
    else
      reg1345 <= proxy1344;
  end
  assign proxy1349 = reg1351;
  assign proxy1350 = proxy1446;
  always @ (posedge clk) begin
    if (reset)
      reg1351 <= 12'h0;
    else
      reg1351 <= proxy1350;
  end
  assign proxy1355 = reg1357;
  assign proxy1356 = proxy1449;
  always @ (posedge clk) begin
    if (reset)
      reg1357 <= 1'h0;
    else
      reg1357 <= proxy1356;
  end
  assign proxy1361 = reg1363;
  assign proxy1362 = proxy1452;
  always @ (posedge clk) begin
    if (reset)
      reg1363 <= 32'h0;
    else
      reg1363 <= proxy1362;
  end
  assign proxy1367 = reg1369;
  assign proxy1368 = proxy1455;
  always @ (posedge clk) begin
    if (reset)
      reg1369 <= 32'h0;
    else
      reg1369 <= proxy1368;
  end
  assign proxy1373 = reg1375;
  assign proxy1374 = proxy1464;
  always @ (posedge clk) begin
    if (reset)
      reg1375 <= 32'h0;
    else
      reg1375 <= proxy1374;
  end
  assign proxy1379 = reg1381;
  assign proxy1380 = proxy1458;
  always @ (posedge clk) begin
    if (reset)
      reg1381 <= 1'h0;
    else
      reg1381 <= proxy1380;
  end
  assign proxy1385 = reg1387;
  assign proxy1386 = proxy1461;
  always @ (posedge clk) begin
    if (reset)
      reg1387 <= 32'h0;
    else
      reg1387 <= proxy1386;
  end
  assign eq1392 = io_in_branch_stall == 1'h1;
  assign eq1396 = io_in_fwd_stall == 1'h1;
  assign orl1398 = eq1396 || eq1392;
  assign sel1401 = orl1398 ? 5'h0 : io_in_rd;
  assign proxy1402 = sel1401;
  assign sel1404 = orl1398 ? 5'h0 : io_in_rs1;
  assign proxy1405 = sel1404;
  assign sel1407 = orl1398 ? 32'h0 : io_in_rd1;
  assign proxy1408 = sel1407;
  assign sel1410 = orl1398 ? 5'h0 : io_in_rs2;
  assign proxy1411 = sel1410;
  assign sel1413 = orl1398 ? 32'h0 : io_in_rd2;
  assign proxy1414 = sel1413;
  assign sel1417 = orl1398 ? 4'hf : io_in_alu_op;
  assign proxy1418 = sel1417;
  assign sel1420 = orl1398 ? 2'h0 : io_in_wb;
  assign proxy1421 = sel1420;
  assign sel1423 = orl1398 ? 32'h0 : io_in_PC_next;
  assign proxy1424 = sel1423;
  assign sel1426 = orl1398 ? 1'h0 : io_in_rs2_src;
  assign proxy1427 = sel1426;
  assign sel1430 = orl1398 ? 12'h7b : io_in_itype_immed;
  assign proxy1431 = sel1430;
  assign sel1433 = orl1398 ? 3'h7 : io_in_mem_read;
  assign proxy1434 = sel1433;
  assign sel1436 = orl1398 ? 3'h7 : io_in_mem_write;
  assign proxy1437 = sel1436;
  assign sel1439 = orl1398 ? 3'h0 : io_in_branch_type;
  assign proxy1440 = sel1439;
  assign sel1442 = orl1398 ? 20'h0 : io_in_upper_immed;
  assign proxy1443 = sel1442;
  assign sel1445 = orl1398 ? 12'h0 : io_in_csr_address;
  assign proxy1446 = sel1445;
  assign sel1448 = orl1398 ? 1'h0 : io_in_is_csr;
  assign proxy1449 = sel1448;
  assign sel1451 = orl1398 ? 32'h0 : io_in_csr_data;
  assign proxy1452 = sel1451;
  assign sel1454 = orl1398 ? 32'h0 : io_in_csr_mask;
  assign proxy1455 = sel1454;
  assign sel1457 = orl1398 ? 1'h0 : io_in_jal;
  assign proxy1458 = sel1457;
  assign sel1460 = orl1398 ? 32'h0 : io_in_jal_offset;
  assign proxy1461 = sel1460;
  assign sel1463 = orl1398 ? 32'h0 : io_in_curr_PC;
  assign proxy1464 = sel1463;

  assign io_out_csr_address = io_out_csr_address1189;
  assign io_out_is_csr = io_out_is_csr1192;
  assign io_out_csr_data = io_out_csr_data1195;
  assign io_out_csr_mask = io_out_csr_mask1198;
  assign io_out_rd = io_out_rd1201;
  assign io_out_rs1 = io_out_rs11204;
  assign io_out_rd1 = io_out_rd11207;
  assign io_out_rs2 = io_out_rs21210;
  assign io_out_rd2 = io_out_rd21213;
  assign io_out_alu_op = io_out_alu_op1216;
  assign io_out_wb = io_out_wb1219;
  assign io_out_rs2_src = io_out_rs2_src1222;
  assign io_out_itype_immed = io_out_itype_immed1225;
  assign io_out_mem_read = io_out_mem_read1228;
  assign io_out_mem_write = io_out_mem_write1231;
  assign io_out_branch_type = io_out_branch_type1234;
  assign io_out_upper_immed = io_out_upper_immed1237;
  assign io_out_curr_PC = io_out_curr_PC1240;
  assign io_out_jal = io_out_jal1243;
  assign io_out_jal_offset = io_out_jal_offset1246;
  assign io_out_PC_next = io_out_PC_next1249;

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
  wire[31:0] io_out_jal_dest1661; // execute.h(9:0)
  wire[31:0] io_out_branch_offset1664; // execute.h(9:0)
  wire io_out_branch_stall1667; // execute.h(9:0)
  wire[31:0] pad1672; // execute.h(63:1)
  wire[19:0] proxy1674; // execute.h(63:3)
  wire[31:0] proxy1676; // execute.h(63:2)
  wire[11:0] io_in_itype_immed1677; // /home/blaise/dev/cash/include/ioport.h(75:0)
  wire[19:0] proxy1678; // /home/blaise/dev/cash/include/logic.h(180:25)
  wire eq1683; // execute.h(63:5)
  wire[31:0] sel1685; // execute.h(63:0)
  wire[31:0] proxy1686; // execute.h(63:0)
  wire[31:0] io_in_rd11687; // execute.h(67:0)
  wire eq1690; // execute.h(69:1)
  wire[31:0] sel1692; // execute.h(70:0)
  wire[31:0] proxy1693; // execute.h(70:0)
  wire[11:0] proxy1695; // execute.h(73:1)
  wire[31:0] proxy1697; // execute.h(73:0)
  wire[11:0] proxy1698; // /home/blaise/dev/cash/include/logic.h(180:26)
  wire[19:0] io_in_upper_immed1699; // /home/blaise/dev/cash/include/ioport.h(75:1)
  wire[31:0] add1700; // execute.h(9:0)
  wire[31:0] proxy1701; // execute.h(9:0)
  wire[31:0] add1703; // execute.h(67:0)
  wire[31:0] sub1708; // execute.h(67:0)
  wire[31:0] shl1712; // execute.h(67:0)
  wire lt1720; // execute.h(67:0)
  wire[31:0] sel1722; // execute.h(108:0)
  wire[31:0] io_in_rd11728; // execute.h(116:3)
  wire lt1729; // execute.h(116:3)
  wire[31:0] sel1731; // execute.h(116:0)
  wire[31:0] io_in_rd11735; // execute.h(123:0)
  wire[31:0] xorb1736; // execute.h(123:0)
  wire[31:0] shr1740; // execute.h(67:0)
  wire[31:0] io_in_rd11744; // execute.h(136:0)
  wire[31:0] shr1745; // execute.h(136:0)
  wire[31:0] io_in_rd11749; // execute.h(143:0)
  wire[31:0] orb1750; // execute.h(143:0)
  wire[31:0] proxy1754; // execute.h(149:0)
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
  wire proxy1796; // execute.h(215:0)

  assign io_out_jal_dest1661 = proxy1701;
  assign io_out_branch_offset1664 = proxy1686;
  assign io_out_branch_stall1667 = proxy1796;
  assign pad1672 = {{20{1'b0}}, io_in_itype_immed};
  assign proxy1674 = 20'hfffff;
  assign proxy1676 = {proxy1678, io_in_itype_immed1677};
  assign io_in_itype_immed1677 = io_in_itype_immed;
  assign proxy1678 = proxy1674;
  assign eq1683 = io_in_itype_immed[11] == 1'h1;
  assign sel1685 = eq1683 ? proxy1676 : pad1672;
  assign proxy1686 = sel1685;
  assign io_in_rd11687 = io_in_rd1;
  assign eq1690 = io_in_rs2_src == 1'h1;
  assign sel1692 = eq1690 ? proxy1686 : io_in_rd2;
  assign proxy1693 = sel1692;
  assign proxy1695 = 12'h0;
  assign proxy1697 = {io_in_upper_immed1699, proxy1698};
  assign proxy1698 = proxy1695;
  assign io_in_upper_immed1699 = io_in_upper_immed;
  assign add1700 = $signed(io_in_rd1) + $signed(io_in_jal_offset);
  assign proxy1701 = add1700;
  assign add1703 = $signed(io_in_rd11687) + $signed(proxy1693);
  assign sub1708 = $signed(io_in_rd11687) - $signed(proxy1693);
  assign shl1712 = io_in_rd11687 << proxy1693;
  assign lt1720 = $signed(io_in_rd11687) < $signed(proxy1693);
  assign sel1722 = lt1720 ? 32'h1 : 32'h0;
  assign io_in_rd11728 = io_in_rd11687;
  assign lt1729 = io_in_rd11728 < proxy1693;
  assign sel1731 = lt1729 ? 32'h1 : 32'h0;
  assign io_in_rd11735 = io_in_rd11687;
  assign xorb1736 = io_in_rd11735 ^ proxy1693;
  assign shr1740 = io_in_rd11687 >> proxy1693;
  assign io_in_rd11744 = io_in_rd11687;
  assign shr1745 = $signed(io_in_rd11744) >> proxy1693;
  assign io_in_rd11749 = io_in_rd11687;
  assign orb1750 = io_in_rd11749 | proxy1693;
  assign proxy1754 = proxy1693;
  assign andb1755 = proxy1754 & io_in_rd11687;
  assign ge1759 = io_in_rd11687 >= proxy1693;
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
      4'h4: sel1787 = sel1731;
      4'h5: sel1787 = xorb1736;
      4'h6: sel1787 = shr1740;
      4'h7: sel1787 = shr1745;
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
  assign proxy1796 = sel1795;

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
  assign io_out_jal_dest = io_out_jal_dest1661;
  assign io_out_branch_offset = io_out_branch_offset1664;
  assign io_out_branch_stall = io_out_branch_stall1667;
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
  wire[11:0] io_out_csr_address1929; // e_m_register.h(8:0)
  wire io_out_is_csr1932; // e_m_register.h(8:0)
  wire[31:0] io_out_csr_result1935; // e_m_register.h(8:0)
  wire[31:0] io_out_alu_result1938; // e_m_register.h(8:0)
  wire[4:0] io_out_rd1941; // e_m_register.h(8:0)
  wire[1:0] io_out_wb1944; // e_m_register.h(8:0)
  wire[4:0] io_out_rs11947; // e_m_register.h(8:0)
  wire[31:0] io_out_rd11950; // e_m_register.h(8:0)
  wire[31:0] io_out_rd21953; // e_m_register.h(8:0)
  wire[4:0] io_out_rs21956; // e_m_register.h(8:0)
  wire[2:0] io_out_mem_read1959; // e_m_register.h(8:0)
  wire[2:0] io_out_mem_write1962; // e_m_register.h(8:0)
  wire[31:0] io_out_curr_PC1965; // e_m_register.h(8:0)
  wire[31:0] io_out_branch_offset1968; // e_m_register.h(8:0)
  wire[2:0] io_out_branch_type1971; // e_m_register.h(8:0)
  wire[31:0] io_out_PC_next1974; // e_m_register.h(8:0)
  wire[31:0] proxy1979; // e_m_register.h(49:0)
  reg[31:0] reg1981; // e_m_register.h(49:0)
  wire[4:0] proxy1989; // e_m_register.h(50:0)
  reg[4:0] reg1991; // e_m_register.h(50:0)
  wire[4:0] proxy1995; // e_m_register.h(51:0)
  reg[4:0] reg1997; // e_m_register.h(51:0)
  wire[31:0] proxy2001; // e_m_register.h(52:0)
  reg[31:0] reg2003; // e_m_register.h(52:0)
  wire[4:0] proxy2007; // e_m_register.h(53:0)
  reg[4:0] reg2009; // e_m_register.h(53:0)
  wire[31:0] proxy2013; // e_m_register.h(54:0)
  reg[31:0] reg2015; // e_m_register.h(54:0)
  wire[1:0] proxy2020; // e_m_register.h(55:0)
  reg[1:0] reg2022; // e_m_register.h(55:0)
  wire[31:0] proxy2026; // e_m_register.h(56:0)
  reg[31:0] reg2028; // e_m_register.h(56:0)
  wire[2:0] proxy2033; // e_m_register.h(57:0)
  reg[2:0] reg2035; // e_m_register.h(57:0)
  wire[2:0] proxy2039; // e_m_register.h(58:0)
  reg[2:0] reg2041; // e_m_register.h(58:0)
  wire[11:0] proxy2046; // e_m_register.h(59:0)
  reg[11:0] reg2048; // e_m_register.h(59:0)
  wire proxy2053; // e_m_register.h(60:0)
  reg reg2055; // e_m_register.h(60:0)
  wire[31:0] proxy2059; // e_m_register.h(61:0)
  reg[31:0] reg2061; // e_m_register.h(61:0)
  wire[31:0] proxy2065; // e_m_register.h(62:0)
  reg[31:0] reg2067; // e_m_register.h(62:0)
  wire[31:0] proxy2071; // e_m_register.h(63:0)
  reg[31:0] reg2073; // e_m_register.h(63:0)
  wire[2:0] proxy2077; // e_m_register.h(64:0)
  reg[2:0] reg2079; // e_m_register.h(64:0)

  assign io_out_csr_address1929 = proxy2046;
  assign io_out_is_csr1932 = proxy2053;
  assign io_out_csr_result1935 = proxy2059;
  assign io_out_alu_result1938 = proxy1979;
  assign io_out_rd1941 = proxy1989;
  assign io_out_wb1944 = proxy2020;
  assign io_out_rs11947 = proxy1995;
  assign io_out_rd11950 = proxy2001;
  assign io_out_rd21953 = proxy2013;
  assign io_out_rs21956 = proxy2007;
  assign io_out_mem_read1959 = proxy2033;
  assign io_out_mem_write1962 = proxy2039;
  assign io_out_curr_PC1965 = proxy2065;
  assign io_out_branch_offset1968 = proxy2071;
  assign io_out_branch_type1971 = proxy2077;
  assign io_out_PC_next1974 = proxy2026;
  assign proxy1979 = reg1981;
  always @ (posedge clk) begin
    if (reset)
      reg1981 <= 32'h0;
    else
      reg1981 <= io_in_alu_result;
  end
  assign proxy1989 = reg1991;
  always @ (posedge clk) begin
    if (reset)
      reg1991 <= 5'h0;
    else
      reg1991 <= io_in_rd;
  end
  assign proxy1995 = reg1997;
  always @ (posedge clk) begin
    if (reset)
      reg1997 <= 5'h0;
    else
      reg1997 <= io_in_rs1;
  end
  assign proxy2001 = reg2003;
  always @ (posedge clk) begin
    if (reset)
      reg2003 <= 32'h0;
    else
      reg2003 <= io_in_rd1;
  end
  assign proxy2007 = reg2009;
  always @ (posedge clk) begin
    if (reset)
      reg2009 <= 5'h0;
    else
      reg2009 <= io_in_rs2;
  end
  assign proxy2013 = reg2015;
  always @ (posedge clk) begin
    if (reset)
      reg2015 <= 32'h0;
    else
      reg2015 <= io_in_rd2;
  end
  assign proxy2020 = reg2022;
  always @ (posedge clk) begin
    if (reset)
      reg2022 <= 2'h0;
    else
      reg2022 <= io_in_wb;
  end
  assign proxy2026 = reg2028;
  always @ (posedge clk) begin
    if (reset)
      reg2028 <= 32'h0;
    else
      reg2028 <= io_in_PC_next;
  end
  assign proxy2033 = reg2035;
  always @ (posedge clk) begin
    if (reset)
      reg2035 <= 3'h0;
    else
      reg2035 <= io_in_mem_read;
  end
  assign proxy2039 = reg2041;
  always @ (posedge clk) begin
    if (reset)
      reg2041 <= 3'h0;
    else
      reg2041 <= io_in_mem_write;
  end
  assign proxy2046 = reg2048;
  always @ (posedge clk) begin
    if (reset)
      reg2048 <= 12'h0;
    else
      reg2048 <= io_in_csr_address;
  end
  assign proxy2053 = reg2055;
  always @ (posedge clk) begin
    if (reset)
      reg2055 <= 1'h0;
    else
      reg2055 <= io_in_is_csr;
  end
  assign proxy2059 = reg2061;
  always @ (posedge clk) begin
    if (reset)
      reg2061 <= 32'h0;
    else
      reg2061 <= io_in_csr_result;
  end
  assign proxy2065 = reg2067;
  always @ (posedge clk) begin
    if (reset)
      reg2067 <= 32'h0;
    else
      reg2067 <= io_in_curr_PC;
  end
  assign proxy2071 = reg2073;
  always @ (posedge clk) begin
    if (reset)
      reg2073 <= 32'h0;
    else
      reg2073 <= io_in_branch_offset;
  end
  assign proxy2077 = reg2079;
  always @ (posedge clk) begin
    if (reset)
      reg2079 <= 3'h0;
    else
      reg2079 <= io_in_branch_type;
  end

  assign io_out_csr_address = io_out_csr_address1929;
  assign io_out_is_csr = io_out_is_csr1932;
  assign io_out_csr_result = io_out_csr_result1935;
  assign io_out_alu_result = io_out_alu_result1938;
  assign io_out_rd = io_out_rd1941;
  assign io_out_wb = io_out_wb1944;
  assign io_out_rs1 = io_out_rs11947;
  assign io_out_rd1 = io_out_rd11950;
  assign io_out_rd2 = io_out_rd21953;
  assign io_out_rs2 = io_out_rs21956;
  assign io_out_mem_read = io_out_mem_read1959;
  assign io_out_mem_write = io_out_mem_write1962;
  assign io_out_curr_PC = io_out_curr_PC1965;
  assign io_out_branch_offset = io_out_branch_offset1968;
  assign io_out_branch_type = io_out_branch_type1971;
  assign io_out_PC_next = io_out_PC_next1974;

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
  wire io_DBUS_in_data_ready2249; // memory.h(9:0)
  wire io_DBUS_out_data_valid2255; // memory.h(9:0)
  wire io_DBUS_out_address_valid2262; // memory.h(9:0)
  wire[1:0] io_DBUS_out_control_data2266; // memory.h(9:0)
  wire io_DBUS_out_control_valid2269; // memory.h(9:0)
  wire[31:0] io_out_data2277; // memory.h(9:0)
  wire lt2281; // memory.h(9:0)
  wire lt2284; // memory.h(9:0)
  wire orl2286; // memory.h(9:0)
  wire proxy2287; // memory.h(9:0)
  wire lt2289; // memory.h(9:0)
  wire proxy2290; // memory.h(9:0)
  wire eq2293; // memory.h(9:0)
  wire proxy2294; // memory.h(9:0)
  wire eq2304; // memory.h(9:0)
  wire eq2307; // memory.h(9:0)
  wire andl2309; // memory.h(9:0)
  wire proxy2310; // memory.h(9:0)
  wire[1:0] sel2315; // memory.h(53:2)
  wire[1:0] sel2319; // memory.h(53:1)
  wire[1:0] sel2323; // memory.h(53:0)
  wire[1:0] proxy2324; // memory.h(53:0)
  wire proxy2326; // memory.h(54:0)
  wire proxy2327; // memory.h(56:0)
  wire notl2328; // memory.h(56:0)
  wire proxy2330; // memory.h(56:1)
  wire notl2331; // memory.h(56:1)
  wire andl2333; // memory.h(56:1)
  wire proxy2335; // memory.h(56:2)
  wire orl2336; // memory.h(56:2)
  wire proxy2337; // memory.h(56:2)
  wire[31:0] proxy2339; // memory.h(59:0)
  wire[23:0] proxy2341; // memory.h(63:0)
  wire[7:0] proxy2345; // memory.h(67:0)
  wire[31:0] pad2346; // memory.h(68:1)
  wire[31:0] proxy2348; // memory.h(68:2)
  wire[7:0] proxy2349; // /home/blaise/dev/cash/include/logic.h(180:27)
  wire[23:0] proxy2350; // /home/blaise/dev/cash/include/logic.h(180:28)
  wire proxy2352; // memory.h(68:4)
  wire eq2353; // memory.h(68:4)
  wire[31:0] sel2355; // memory.h(68:0)
  wire[15:0] proxy2358; // memory.h(73:0)
  wire[15:0] proxy2362; // memory.h(76:0)
  wire[31:0] pad2363; // memory.h(77:1)
  wire[31:0] proxy2365; // memory.h(77:2)
  wire[15:0] proxy2366; // /home/blaise/dev/cash/include/logic.h(180:29)
  wire[15:0] proxy2367; // /home/blaise/dev/cash/include/logic.h(180:30)
  wire proxy2369; // memory.h(77:4)
  wire eq2370; // memory.h(77:4)
  wire[31:0] sel2372; // memory.h(77:0)
  wire[7:0] proxy2377; // memory.h(89:0)
  wire[31:0] pad2378; // memory.h(90:0)
  wire[15:0] proxy2382; // memory.h(97:0)
  wire[31:0] pad2383; // memory.h(98:0)
  reg[31:0] sel2386; // memory.h(60:0)
  wire lt2388; // memory.h(9:0)
  wire proxy2389; // memory.h(9:0)

  assign io_DBUS_in_data_ready2249 = proxy2337;
  assign io_DBUS_out_data_valid2255 = proxy2389;
  assign io_DBUS_out_address_valid2262 = proxy2287;
  assign io_DBUS_out_control_data2266 = proxy2324;
  assign io_DBUS_out_control_valid2269 = proxy2326;
  assign io_out_data2277 = proxy2339;
  assign lt2281 = io_in_mem_write < 3'h7;
  assign lt2284 = io_in_mem_read < 3'h7;
  assign orl2286 = lt2284 || lt2281;
  assign proxy2287 = orl2286;
  assign lt2289 = io_in_mem_read < 3'h7;
  assign proxy2290 = lt2289;
  assign eq2293 = io_in_mem_write == 3'h2;
  assign proxy2294 = eq2293;
  assign eq2304 = io_in_mem_write == 3'h7;
  assign eq2307 = io_in_mem_read == 3'h7;
  assign andl2309 = eq2307 && eq2304;
  assign proxy2310 = andl2309;
  assign sel2315 = proxy2310 ? 2'h0 : 2'h3;
  assign sel2319 = proxy2294 ? 2'h2 : sel2315;
  assign sel2323 = proxy2290 ? 2'h1 : sel2319;
  assign proxy2324 = sel2323;
  assign proxy2326 = 1'h1;
  assign proxy2327 = proxy2294;
  assign notl2328 = !proxy2327;
  assign proxy2330 = proxy2310;
  assign notl2331 = !proxy2330;
  assign andl2333 = notl2331 && notl2328;
  assign proxy2335 = proxy2290;
  assign orl2336 = proxy2335 || andl2333;
  assign proxy2337 = orl2336;
  assign proxy2339 = sel2386;
  assign proxy2341 = 24'hffffff;
  assign proxy2345 = io_DBUS_in_data_data[7:0];
  assign pad2346 = {{24{1'b0}}, proxy2345};
  assign proxy2348 = {proxy2350, proxy2349};
  assign proxy2349 = proxy2345;
  assign proxy2350 = proxy2341;
  assign proxy2352 = proxy2345[7];
  assign eq2353 = proxy2352 == 1'h1;
  assign sel2355 = eq2353 ? proxy2348 : pad2346;
  assign proxy2358 = 16'hffff;
  assign proxy2362 = io_DBUS_in_data_data[15:0];
  assign pad2363 = {{16{1'b0}}, proxy2362};
  assign proxy2365 = {proxy2367, proxy2366};
  assign proxy2366 = proxy2362;
  assign proxy2367 = proxy2358;
  assign proxy2369 = proxy2362[15];
  assign eq2370 = proxy2369 == 1'h1;
  assign sel2372 = eq2370 ? proxy2365 : pad2363;
  assign proxy2377 = io_DBUS_in_data_data[7:0];
  assign pad2378 = {{24{1'b0}}, proxy2377};
  assign proxy2382 = io_DBUS_in_data_data[15:0];
  assign pad2383 = {{16{1'b0}}, proxy2382};
  always @(*) begin
    case (io_in_mem_read)
      3'h0: sel2386 = sel2355;
      3'h1: sel2386 = sel2372;
      3'h2: sel2386 = io_DBUS_in_data_data;
      3'h4: sel2386 = pad2378;
      3'h5: sel2386 = pad2383;
      default: sel2386 = 32'h0;
    endcase
  end
  assign lt2388 = io_in_mem_write < 3'h7;
  assign proxy2389 = lt2388;

  assign io_DBUS_in_data_ready = io_DBUS_in_data_ready2249;
  assign io_DBUS_out_data_data = io_in_data;
  assign io_DBUS_out_data_valid = io_DBUS_out_data_valid2255;
  assign io_DBUS_out_address_data = io_in_address;
  assign io_DBUS_out_address_valid = io_DBUS_out_address_valid2262;
  assign io_DBUS_out_control_data = io_DBUS_out_control_data2266;
  assign io_DBUS_out_control_valid = io_DBUS_out_control_valid2269;
  assign io_out_data = io_out_data2277;

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
  wire io_DBUS_in_data_ready2183; // memory.h(158:0)
  wire[31:0] io_DBUS_out_data_data2186; // memory.h(158:0)
  wire io_DBUS_out_data_valid2189; // memory.h(158:0)
  wire[31:0] io_DBUS_out_address_data2193; // memory.h(158:0)
  wire io_DBUS_out_address_valid2196; // memory.h(158:0)
  wire[1:0] io_DBUS_out_control_data2200; // memory.h(158:0)
  wire io_DBUS_out_control_valid2203; // memory.h(158:0)
  wire[31:0] io_out_mem_result2223; // memory.h(158:0)
  wire[31:0] io_out_branch_dest2241; // memory.h(158:0)
  wire[31:0] Cache2392_io_DBUS_in_data_data; // memory.h(158:1)
  wire Cache2392_io_DBUS_in_data_valid; // memory.h(158:1)
  wire proxy2398; // memory.h(158:1)
  wire Cache2392_io_DBUS_in_data_ready; // memory.h(158:1)
  wire[31:0] proxy2401; // memory.h(158:1)
  wire[31:0] Cache2392_io_DBUS_out_data_data; // memory.h(158:1)
  wire proxy2404; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_data_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_data_ready; // memory.h(158:1)
  wire[31:0] proxy2410; // memory.h(158:1)
  wire[31:0] Cache2392_io_DBUS_out_address_data; // memory.h(158:1)
  wire proxy2413; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_address_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_address_ready; // memory.h(158:1)
  wire[1:0] proxy2419; // memory.h(158:1)
  wire[1:0] Cache2392_io_DBUS_out_control_data; // memory.h(158:1)
  wire proxy2422; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_control_valid; // memory.h(158:1)
  wire Cache2392_io_DBUS_out_control_ready; // memory.h(158:1)
  wire[31:0] Cache2392_io_in_address; // memory.h(158:1)
  wire[2:0] Cache2392_io_in_mem_read; // memory.h(158:1)
  wire[2:0] Cache2392_io_in_mem_write; // memory.h(158:1)
  wire[31:0] Cache2392_io_in_data; // memory.h(158:1)
  wire[31:0] proxy2440; // memory.h(158:1)
  wire[31:0] Cache2392_io_out_data; // memory.h(158:1)
  wire[31:0] shl2444; // memory.h(158:0)
  wire[31:0] add2446; // memory.h(158:0)
  wire[31:0] proxy2447; // memory.h(158:0)
  wire eq2455; // memory.h(158:0)
  wire sel2457; // memory.h(229:0)
  wire eq2463; // memory.h(158:0)
  wire sel2465; // memory.h(234:0)
  wire eq2473; // memory.h(238:4)
  wire sel2475; // memory.h(238:0)
  wire eq2483; // memory.h(243:4)
  wire sel2485; // memory.h(243:0)
  wire eq2493; // memory.h(250:4)
  wire sel2495; // memory.h(250:0)
  wire eq2503; // memory.h(255:4)
  wire sel2505; // memory.h(255:0)
  reg sel2510; // memory.h(221:0)

  assign io_DBUS_in_data_ready2183 = proxy2398;
  assign io_DBUS_out_data_data2186 = proxy2401;
  assign io_DBUS_out_data_valid2189 = proxy2404;
  assign io_DBUS_out_address_data2193 = proxy2410;
  assign io_DBUS_out_address_valid2196 = proxy2413;
  assign io_DBUS_out_control_data2200 = proxy2419;
  assign io_DBUS_out_control_valid2203 = proxy2422;
  assign io_out_mem_result2223 = proxy2440;
  assign io_out_branch_dest2241 = proxy2447;
  Cache Cache2392(.io_DBUS_in_data_data(Cache2392_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Cache2392_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Cache2392_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Cache2392_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Cache2392_io_DBUS_out_control_ready), .io_in_address(Cache2392_io_in_address), .io_in_mem_read(Cache2392_io_in_mem_read), .io_in_mem_write(Cache2392_io_in_mem_write), .io_in_data(Cache2392_io_in_data), .io_DBUS_in_data_ready(Cache2392_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Cache2392_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Cache2392_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Cache2392_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Cache2392_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Cache2392_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Cache2392_io_DBUS_out_control_valid), .io_out_data(Cache2392_io_out_data));
  assign Cache2392_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Cache2392_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign proxy2398 = Cache2392_io_DBUS_in_data_ready;
  assign proxy2401 = Cache2392_io_DBUS_out_data_data;
  assign proxy2404 = Cache2392_io_DBUS_out_data_valid;
  assign Cache2392_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign proxy2410 = Cache2392_io_DBUS_out_address_data;
  assign proxy2413 = Cache2392_io_DBUS_out_address_valid;
  assign Cache2392_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign proxy2419 = Cache2392_io_DBUS_out_control_data;
  assign proxy2422 = Cache2392_io_DBUS_out_control_valid;
  assign Cache2392_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign Cache2392_io_in_address = io_in_alu_result;
  assign Cache2392_io_in_mem_read = io_in_mem_read;
  assign Cache2392_io_in_mem_write = io_in_mem_write;
  assign Cache2392_io_in_data = io_in_rd2;
  assign proxy2440 = Cache2392_io_out_data;
  assign shl2444 = $signed(io_in_branch_offset) << 32'h1;
  assign add2446 = $signed(io_in_curr_PC) + $signed(shl2444);
  assign proxy2447 = add2446;
  assign eq2455 = io_in_alu_result == 32'h0;
  assign sel2457 = eq2455 ? 1'h1 : 1'h0;
  assign eq2463 = io_in_alu_result == 32'h0;
  assign sel2465 = eq2463 ? 1'h0 : 1'h1;
  assign eq2473 = io_in_alu_result[31] == 1'h0;
  assign sel2475 = eq2473 ? 1'h0 : 1'h1;
  assign eq2483 = io_in_alu_result[31] == 1'h0;
  assign sel2485 = eq2483 ? 1'h1 : 1'h0;
  assign eq2493 = io_in_alu_result[31] == 1'h0;
  assign sel2495 = eq2493 ? 1'h0 : 1'h1;
  assign eq2503 = io_in_alu_result[31] == 1'h0;
  assign sel2505 = eq2503 ? 1'h1 : 1'h0;
  always @(*) begin
    case (io_in_branch_type)
      3'h1: sel2510 = sel2457;
      3'h2: sel2510 = sel2465;
      3'h3: sel2510 = sel2475;
      3'h4: sel2510 = sel2485;
      3'h5: sel2510 = sel2495;
      3'h6: sel2510 = sel2505;
      3'h0: sel2510 = 1'h0;
      default: sel2510 = 1'h0;
    endcase
  end

  assign io_DBUS_in_data_ready = io_DBUS_in_data_ready2183;
  assign io_DBUS_out_data_data = io_DBUS_out_data_data2186;
  assign io_DBUS_out_data_valid = io_DBUS_out_data_valid2189;
  assign io_DBUS_out_address_data = io_DBUS_out_address_data2193;
  assign io_DBUS_out_address_valid = io_DBUS_out_address_valid2196;
  assign io_DBUS_out_control_data = io_DBUS_out_control_data2200;
  assign io_DBUS_out_control_valid = io_DBUS_out_control_valid2203;
  assign io_out_alu_result = io_in_alu_result;
  assign io_out_mem_result = io_out_mem_result2223;
  assign io_out_rd = io_in_rd;
  assign io_out_wb = io_in_wb;
  assign io_out_rs1 = io_in_rs1;
  assign io_out_rs2 = io_in_rs2;
  assign io_out_branch_dir = sel2510;
  assign io_out_branch_dest = io_out_branch_dest2241;
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
  wire[31:0] io_out_alu_result2622; // m_w_register.h(8:0)
  wire[31:0] io_out_mem_result2625; // m_w_register.h(8:0)
  wire[4:0] io_out_rd2628; // m_w_register.h(8:0)
  wire[1:0] io_out_wb2631; // m_w_register.h(8:0)
  wire[4:0] io_out_rs12634; // m_w_register.h(8:0)
  wire[4:0] io_out_rs22637; // m_w_register.h(8:0)
  wire[31:0] io_out_PC_next2640; // m_w_register.h(8:0)
  wire[31:0] proxy2645; // m_w_register.h(31:0)
  reg[31:0] reg2647; // m_w_register.h(31:0)
  wire[31:0] proxy2654; // m_w_register.h(32:0)
  reg[31:0] reg2656; // m_w_register.h(32:0)
  wire[4:0] proxy2661; // m_w_register.h(33:0)
  reg[4:0] reg2663; // m_w_register.h(33:0)
  wire[4:0] proxy2667; // m_w_register.h(34:0)
  reg[4:0] reg2669; // m_w_register.h(34:0)
  wire[4:0] proxy2673; // m_w_register.h(35:0)
  reg[4:0] reg2675; // m_w_register.h(35:0)
  wire[1:0] proxy2680; // m_w_register.h(36:0)
  reg[1:0] reg2682; // m_w_register.h(36:0)
  wire[31:0] proxy2686; // m_w_register.h(37:0)
  reg[31:0] reg2688; // m_w_register.h(37:0)

  assign io_out_alu_result2622 = proxy2645;
  assign io_out_mem_result2625 = proxy2654;
  assign io_out_rd2628 = proxy2661;
  assign io_out_wb2631 = proxy2680;
  assign io_out_rs12634 = proxy2667;
  assign io_out_rs22637 = proxy2673;
  assign io_out_PC_next2640 = proxy2686;
  assign proxy2645 = reg2647;
  always @ (posedge clk) begin
    if (reset)
      reg2647 <= 32'h0;
    else
      reg2647 <= io_in_alu_result;
  end
  assign proxy2654 = reg2656;
  always @ (posedge clk) begin
    if (reset)
      reg2656 <= 32'h0;
    else
      reg2656 <= io_in_mem_result;
  end
  assign proxy2661 = reg2663;
  always @ (posedge clk) begin
    if (reset)
      reg2663 <= 5'h0;
    else
      reg2663 <= io_in_rd;
  end
  assign proxy2667 = reg2669;
  always @ (posedge clk) begin
    if (reset)
      reg2669 <= 5'h0;
    else
      reg2669 <= io_in_rs1;
  end
  assign proxy2673 = reg2675;
  always @ (posedge clk) begin
    if (reset)
      reg2675 <= 5'h0;
    else
      reg2675 <= io_in_rs2;
  end
  assign proxy2680 = reg2682;
  always @ (posedge clk) begin
    if (reset)
      reg2682 <= 2'h0;
    else
      reg2682 <= io_in_wb;
  end
  assign proxy2686 = reg2688;
  always @ (posedge clk) begin
    if (reset)
      reg2688 <= 32'h0;
    else
      reg2688 <= io_in_PC_next;
  end

  assign io_out_alu_result = io_out_alu_result2622;
  assign io_out_mem_result = io_out_mem_result2625;
  assign io_out_rd = io_out_rd2628;
  assign io_out_wb = io_out_wb2631;
  assign io_out_rs1 = io_out_rs12634;
  assign io_out_rs2 = io_out_rs22637;
  assign io_out_PC_next = io_out_PC_next2640;

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
  wire[31:0] io_out_write_data2743; // write_back.h(1:0)
  wire eq2753; // write_back.h(1:0)
  wire eq2757; // write_back.h(1:0)
  wire[31:0] sel2759; // write_back.h(23:1)
  wire[31:0] sel2761; // write_back.h(23:0)
  wire[31:0] proxy2762; // write_back.h(23:0)

  assign io_out_write_data2743 = proxy2762;
  assign eq2753 = io_in_wb == 2'h3;
  assign eq2757 = io_in_wb == 2'h1;
  assign sel2759 = eq2757 ? io_in_alu_result : io_in_mem_result;
  assign sel2761 = eq2753 ? io_in_PC_next : sel2759;
  assign proxy2762 = sel2761;

  assign io_out_write_data = io_out_write_data2743;
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
  wire io_out_src1_fwd2818; // forwarding.h(9:0)
  wire[31:0] io_out_src1_fwd_data2821; // forwarding.h(9:0)
  wire io_out_src2_fwd2824; // forwarding.h(9:0)
  wire[31:0] io_out_src2_fwd_data2827; // forwarding.h(9:0)
  wire io_out_csr_fwd2830; // forwarding.h(9:0)
  wire[31:0] io_out_csr_fwd_data2833; // forwarding.h(9:0)
  wire io_out_fwd_stall2836; // forwarding.h(9:0)
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
  wire proxy2880; // forwarding.h(9:0)
  wire proxy2881; // forwarding.h(78:0)
  wire notl2882; // forwarding.h(78:0)
  wire ne2885; // forwarding.h(9:0)
  wire ne2888; // forwarding.h(9:0)
  wire eq2890; // forwarding.h(9:0)
  wire andl2892; // forwarding.h(9:0)
  wire andl2894; // forwarding.h(9:0)
  wire andl2896; // forwarding.h(9:0)
  wire proxy2897; // forwarding.h(9:0)
  wire proxy2898; // forwarding.h(84:0)
  wire notl2899; // forwarding.h(84:0)
  wire proxy2901; // forwarding.h(83:0)
  wire notl2902; // forwarding.h(83:0)
  wire ne2905; // forwarding.h(9:0)
  wire ne2908; // forwarding.h(9:0)
  wire eq2910; // forwarding.h(9:0)
  wire andl2912; // forwarding.h(9:0)
  wire andl2914; // forwarding.h(9:0)
  wire andl2916; // forwarding.h(9:0)
  wire andl2918; // forwarding.h(9:0)
  wire proxy2920; // forwarding.h(87:0)
  wire orl2921; // forwarding.h(87:0)
  wire orl2923; // forwarding.h(87:0)
  wire proxy2924; // forwarding.h(87:0)
  wire[31:0] sel2927; // forwarding.h(91:1)
  wire[31:0] sel2929; // forwarding.h(91:0)
  wire[31:0] sel2931; // forwarding.h(92:2)
  wire[31:0] sel2933; // forwarding.h(90:1)
  wire[31:0] sel2935; // forwarding.h(90:0)
  wire[31:0] sel2937; // forwarding.h(92:1)
  wire[31:0] sel2939; // forwarding.h(89:0)
  wire[31:0] sel2941; // forwarding.h(92:0)
  wire[31:0] proxy2942; // forwarding.h(92:0)
  wire ne2944; // forwarding.h(9:0)
  wire ne2947; // forwarding.h(9:0)
  wire eq2949; // forwarding.h(9:0)
  wire andl2951; // forwarding.h(9:0)
  wire andl2953; // forwarding.h(9:0)
  wire proxy2954; // forwarding.h(9:0)
  wire proxy2955; // forwarding.h(138:0)
  wire notl2956; // forwarding.h(138:0)
  wire ne2959; // forwarding.h(9:0)
  wire ne2962; // forwarding.h(9:0)
  wire eq2964; // forwarding.h(9:0)
  wire andl2966; // forwarding.h(9:0)
  wire andl2968; // forwarding.h(9:0)
  wire andl2970; // forwarding.h(9:0)
  wire proxy2971; // forwarding.h(9:0)
  wire proxy2972; // forwarding.h(144:0)
  wire notl2973; // forwarding.h(144:0)
  wire proxy2975; // forwarding.h(143:0)
  wire notl2976; // forwarding.h(143:0)
  wire ne2979; // forwarding.h(9:0)
  wire ne2982; // forwarding.h(9:0)
  wire eq2984; // forwarding.h(9:0)
  wire andl2986; // forwarding.h(9:0)
  wire andl2988; // forwarding.h(9:0)
  wire andl2990; // forwarding.h(9:0)
  wire andl2992; // forwarding.h(9:0)
  wire proxy2994; // forwarding.h(147:0)
  wire orl2995; // forwarding.h(147:0)
  wire orl2997; // forwarding.h(147:0)
  wire proxy2998; // forwarding.h(147:0)
  wire[31:0] sel3000; // forwarding.h(151:1)
  wire[31:0] sel3002; // forwarding.h(151:0)
  wire[31:0] sel3004; // forwarding.h(152:2)
  wire[31:0] sel3006; // forwarding.h(150:1)
  wire[31:0] sel3008; // forwarding.h(150:0)
  wire[31:0] sel3010; // forwarding.h(152:1)
  wire[31:0] sel3012; // forwarding.h(149:0)
  wire[31:0] sel3014; // forwarding.h(152:0)
  wire[31:0] proxy3015; // forwarding.h(152:0)
  wire eq3016; // forwarding.h(9:0)
  wire andl3018; // forwarding.h(9:0)
  wire proxy3019; // forwarding.h(9:0)
  wire proxy3020; // forwarding.h(192:0)
  wire notl3021; // forwarding.h(192:0)
  wire eq3023; // forwarding.h(9:0)
  wire andl3025; // forwarding.h(9:0)
  wire andl3027; // forwarding.h(9:0)
  wire proxy3029; // forwarding.h(194:0)
  wire orl3030; // forwarding.h(194:0)
  wire proxy3031; // forwarding.h(194:0)
  wire[31:0] sel3033; // forwarding.h(197:1)
  wire[31:0] sel3035; // forwarding.h(197:0)
  wire[31:0] proxy3036; // forwarding.h(197:0)
  wire proxy3040; // forwarding.h(200:3)
  wire orl3041; // forwarding.h(200:3)
  wire andl3043; // forwarding.h(200:3)
  wire sel3045; // forwarding.h(200:0)
  wire proxy3046; // forwarding.h(200:0)

  assign io_out_src1_fwd2818 = proxy2924;
  assign io_out_src1_fwd_data2821 = proxy2942;
  assign io_out_src2_fwd2824 = proxy2998;
  assign io_out_src2_fwd_data2827 = proxy3015;
  assign io_out_csr_fwd2830 = proxy3031;
  assign io_out_csr_fwd_data2833 = proxy3036;
  assign io_out_fwd_stall2836 = proxy3046;
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
  assign proxy2880 = andl2879;
  assign proxy2881 = proxy2880;
  assign notl2882 = !proxy2881;
  assign ne2885 = io_in_memory_wb != 2'h0;
  assign ne2888 = io_in_decode_src1 != 5'h0;
  assign eq2890 = io_in_decode_src1 == io_in_memory_dest;
  assign andl2892 = eq2890 && ne2888;
  assign andl2894 = andl2892 && ne2885;
  assign andl2896 = andl2894 && notl2882;
  assign proxy2897 = andl2896;
  assign proxy2898 = proxy2897;
  assign notl2899 = !proxy2898;
  assign proxy2901 = proxy2880;
  assign notl2902 = !proxy2901;
  assign ne2905 = io_in_writeback_wb != 2'h0;
  assign ne2908 = io_in_decode_src1 != 5'h0;
  assign eq2910 = io_in_decode_src1 == io_in_writeback_dest;
  assign andl2912 = eq2910 && ne2908;
  assign andl2914 = andl2912 && ne2905;
  assign andl2916 = andl2914 && notl2902;
  assign andl2918 = andl2916 && notl2899;
  assign proxy2920 = proxy2880;
  assign orl2921 = proxy2920 || proxy2897;
  assign orl2923 = orl2921 || andl2918;
  assign proxy2924 = orl2923;
  assign sel2927 = eq2846 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel2929 = eq2856 ? io_in_writeback_PC_next : sel2927;
  assign sel2931 = andl2918 ? sel2929 : 32'h7b;
  assign sel2933 = eq2843 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel2935 = eq2853 ? io_in_memory_PC_next : sel2933;
  assign sel2937 = proxy2897 ? sel2935 : sel2931;
  assign sel2939 = eq2850 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel2941 = proxy2880 ? sel2939 : sel2937;
  assign proxy2942 = sel2941;
  assign ne2944 = io_in_execute_wb != 2'h0;
  assign ne2947 = io_in_decode_src2 != 5'h0;
  assign eq2949 = io_in_decode_src2 == io_in_execute_dest;
  assign andl2951 = eq2949 && ne2947;
  assign andl2953 = andl2951 && ne2944;
  assign proxy2954 = andl2953;
  assign proxy2955 = proxy2954;
  assign notl2956 = !proxy2955;
  assign ne2959 = io_in_memory_wb != 2'h0;
  assign ne2962 = io_in_decode_src2 != 5'h0;
  assign eq2964 = io_in_decode_src2 == io_in_memory_dest;
  assign andl2966 = eq2964 && ne2962;
  assign andl2968 = andl2966 && ne2959;
  assign andl2970 = andl2968 && notl2956;
  assign proxy2971 = andl2970;
  assign proxy2972 = proxy2971;
  assign notl2973 = !proxy2972;
  assign proxy2975 = proxy2954;
  assign notl2976 = !proxy2975;
  assign ne2979 = io_in_writeback_wb != 2'h0;
  assign ne2982 = io_in_decode_src2 != 5'h0;
  assign eq2984 = io_in_decode_src2 == io_in_writeback_dest;
  assign andl2986 = eq2984 && ne2982;
  assign andl2988 = andl2986 && ne2979;
  assign andl2990 = andl2988 && notl2976;
  assign andl2992 = andl2990 && notl2973;
  assign proxy2994 = proxy2954;
  assign orl2995 = proxy2994 || proxy2971;
  assign orl2997 = orl2995 || andl2992;
  assign proxy2998 = orl2997;
  assign sel3000 = eq2846 ? io_in_writeback_mem_data : io_in_writeback_alu_result;
  assign sel3002 = eq2856 ? io_in_writeback_PC_next : sel3000;
  assign sel3004 = andl2992 ? sel3002 : 32'h7b;
  assign sel3006 = eq2843 ? io_in_memory_mem_data : io_in_memory_alu_result;
  assign sel3008 = eq2853 ? io_in_memory_PC_next : sel3006;
  assign sel3010 = proxy2971 ? sel3008 : sel3004;
  assign sel3012 = eq2850 ? io_in_execute_PC_next : io_in_execute_alu_result;
  assign sel3014 = proxy2954 ? sel3012 : sel3010;
  assign proxy3015 = sel3014;
  assign eq3016 = io_in_decode_csr_address == io_in_execute_csr_address;
  assign andl3018 = eq3016 && eq2861;
  assign proxy3019 = andl3018;
  assign proxy3020 = proxy3019;
  assign notl3021 = !proxy3020;
  assign eq3023 = io_in_decode_csr_address == io_in_memory_csr_address;
  assign andl3025 = eq3023 && eq2865;
  assign andl3027 = andl3025 && notl3021;
  assign proxy3029 = proxy3019;
  assign orl3030 = proxy3029 || andl3027;
  assign proxy3031 = orl3030;
  assign sel3033 = andl3027 ? io_in_memory_csr_result : 32'h7b;
  assign sel3035 = proxy3019 ? io_in_execute_alu_result : sel3033;
  assign proxy3036 = sel3035;
  assign proxy3040 = proxy2880;
  assign orl3041 = proxy3040 || proxy2954;
  assign andl3043 = orl3041 && eq2840;
  assign sel3045 = andl3043 ? 1'h1 : 1'h0;
  assign proxy3046 = sel3045;

  assign io_out_src1_fwd = io_out_src1_fwd2818;
  assign io_out_src1_fwd_data = io_out_src1_fwd_data2821;
  assign io_out_src2_fwd = io_out_src2_fwd2824;
  assign io_out_src2_fwd_data = io_out_src2_fwd_data2827;
  assign io_out_csr_fwd = io_out_csr_fwd2830;
  assign io_out_csr_fwd_data = io_out_csr_fwd_data2833;
  assign io_out_fwd_stall = io_out_fwd_stall2836;

endmodule

module Interrupt_Handler(
  input wire io_INTERRUPT_in_interrupt_id_data,
  input wire io_INTERRUPT_in_interrupt_id_valid,
  output wire io_INTERRUPT_in_interrupt_id_ready,
  output wire io_out_interrupt,
  output wire[31:0] io_out_interrupt_pc
);
  wire[31:0] io_out_interrupt_pc3147; // interrupt_handler.h(11:0)
  reg[31:0] mem3149 [0:1]; // interrupt_handler.h(27:0)
  wire[31:0] marport3150; // interrupt_handler.h(31:0)
  wire[31:0] proxy3151; // interrupt_handler.h(31:0)

  assign io_out_interrupt_pc3147 = proxy3151;
  initial begin
    mem3149[0] = 32'hdeadbeef;
    mem3149[1] = 32'hdeadbeef;
  end
  assign marport3150 = mem3149[io_INTERRUPT_in_interrupt_id_data];
  assign proxy3151 = marport3150;

  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt = io_INTERRUPT_in_interrupt_id_valid;
  assign io_out_interrupt_pc = io_out_interrupt_pc3147;

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
  wire[3:0] io_out_curr_state3211; // JTAG/jtag.h(16:0)
  wire[3:0] proxy3216; // JTAG/jtag.h(31:0)
  reg[3:0] reg3218; // JTAG/jtag.h(31:0)
  wire io_JTAG_TAP_in_mode_select_valid3223; // JTAG/jtag.h(35:0)
  wire eq3227; // JTAG/jtag.h(36:1)
  wire[3:0] sel3233; // JTAG/jtag.h(45:0)
  wire[3:0] sel3238; // JTAG/jtag.h(49:0)
  wire[3:0] sel3244; // JTAG/jtag.h(53:0)
  wire[3:0] sel3250; // JTAG/jtag.h(57:0)
  wire[3:0] sel3254; // JTAG/jtag.h(61:0)
  wire[3:0] sel3260; // JTAG/jtag.h(65:0)
  wire[3:0] sel3265; // JTAG/jtag.h(69:0)
  wire[3:0] sel3269; // JTAG/jtag.h(73:0)
  wire[3:0] sel3273; // JTAG/jtag.h(77:0)
  wire[3:0] sel3278; // JTAG/jtag.h(81:0)
  wire[3:0] sel3284; // JTAG/jtag.h(85:0)
  wire[3:0] sel3288; // JTAG/jtag.h(89:0)
  wire[3:0] sel3294; // JTAG/jtag.h(93:0)
  wire[3:0] sel3299; // JTAG/jtag.h(97:0)
  wire[3:0] sel3303; // JTAG/jtag.h(101:0)
  wire[3:0] sel3307; // JTAG/jtag.h(105:0)
  reg[3:0] sel3309; // JTAG/jtag.h(42:0)
  wire[3:0] sel3310; // JTAG/jtag.h(40:0)
  wire io_JTAG_TAP_in_mode_select_valid3311; // JTAG/jtag.h(115:1)
  wire andl3312; // JTAG/jtag.h(115:1)
  wire eq3316; // JTAG/jtag.h(117:2)
  wire io_JTAG_TAP_in_mode_select_valid3319; // JTAG/jtag.h(123:1)
  wire andl3320; // JTAG/jtag.h(123:1)
  wire eq3324; // JTAG/jtag.h(125:2)
  wire[3:0] sel3326; // JTAG/jtag.h(117:0)
  wire[3:0] sel3327; // JTAG/jtag.h(125:0)
  wire andb3328; // JTAG/jtag.h(115:0)
  wire[3:0] sel3329; // JTAG/jtag.h(115:0)

  assign io_out_curr_state3211 = proxy3216;
  assign proxy3216 = reg3218;
  always @ (posedge clk) begin
    if (reset)
      reg3218 <= 4'h0;
    else
      reg3218 <= sel3329;
  end
  assign io_JTAG_TAP_in_mode_select_valid3223 = io_JTAG_TAP_in_mode_select_valid;
  assign eq3227 = io_JTAG_TAP_in_mode_select_data == 1'h1;
  assign sel3233 = eq3227 ? 4'h0 : 4'h1;
  assign sel3238 = eq3227 ? 4'h2 : 4'h1;
  assign sel3244 = eq3227 ? 4'h9 : 4'h3;
  assign sel3250 = eq3227 ? 4'h5 : 4'h4;
  assign sel3254 = eq3227 ? 4'h5 : 4'h4;
  assign sel3260 = eq3227 ? 4'h8 : 4'h6;
  assign sel3265 = eq3227 ? 4'h7 : 4'h6;
  assign sel3269 = eq3227 ? 4'h4 : 4'h8;
  assign sel3273 = eq3227 ? 4'h2 : 4'h1;
  assign sel3278 = eq3227 ? 4'h0 : 4'ha;
  assign sel3284 = eq3227 ? 4'hc : 4'hb;
  assign sel3288 = eq3227 ? 4'hc : 4'hb;
  assign sel3294 = eq3227 ? 4'hf : 4'hd;
  assign sel3299 = eq3227 ? 4'he : 4'hd;
  assign sel3303 = eq3227 ? 4'hf : 4'hb;
  assign sel3307 = eq3227 ? 4'h2 : 4'h1;
  always @(*) begin
    case (proxy3216)
      4'h0: sel3309 = sel3233;
      4'h1: sel3309 = sel3238;
      4'h2: sel3309 = sel3244;
      4'h3: sel3309 = sel3250;
      4'h4: sel3309 = sel3254;
      4'h5: sel3309 = sel3260;
      4'h6: sel3309 = sel3265;
      4'h7: sel3309 = sel3269;
      4'h8: sel3309 = sel3273;
      4'h9: sel3309 = sel3278;
      4'ha: sel3309 = sel3284;
      4'hb: sel3309 = sel3288;
      4'hc: sel3309 = sel3294;
      4'hd: sel3309 = sel3299;
      4'he: sel3309 = sel3303;
      4'hf: sel3309 = sel3307;
      default: sel3309 = proxy3216;
    endcase
  end
  assign sel3310 = io_JTAG_TAP_in_mode_select_valid3223 ? sel3309 : 4'h0;
  assign io_JTAG_TAP_in_mode_select_valid3311 = io_JTAG_TAP_in_mode_select_valid3223;
  assign andl3312 = io_JTAG_TAP_in_mode_select_valid3311 && io_JTAG_TAP_in_reset_valid;
  assign eq3316 = io_JTAG_TAP_in_reset_data == 1'h1;
  assign io_JTAG_TAP_in_mode_select_valid3319 = io_JTAG_TAP_in_mode_select_valid3223;
  assign andl3320 = io_JTAG_TAP_in_mode_select_valid3319 && io_JTAG_TAP_in_clock_valid;
  assign eq3324 = io_JTAG_TAP_in_clock_data == 1'h1;
  assign sel3326 = eq3316 ? 4'h0 : proxy3216;
  assign sel3327 = andb3328 ? sel3310 : proxy3216;
  assign andb3328 = andl3320 & eq3324;
  assign sel3329 = andl3312 ? sel3326 : sel3327;

  assign io_JTAG_TAP_in_mode_select_ready = io_JTAG_TAP_in_mode_select_valid;
  assign io_JTAG_TAP_in_clock_ready = io_JTAG_TAP_in_clock_valid;
  assign io_JTAG_TAP_in_reset_ready = io_JTAG_TAP_in_reset_valid;
  assign io_out_curr_state = io_out_curr_state3211;

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
  wire io_JTAG_JTAG_TAP_in_mode_select_ready3171; // JTAG/jtag.h(138:0)
  wire io_JTAG_JTAG_TAP_in_clock_ready3176; // JTAG/jtag.h(138:0)
  wire io_JTAG_JTAG_TAP_in_reset_ready3181; // JTAG/jtag.h(138:0)
  wire TAP3332_clk; // JTAG/jtag.h(138:1)
  wire TAP3332_reset; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_mode_select_data; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_mode_select_valid; // JTAG/jtag.h(138:1)
  wire proxy3343; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_mode_select_ready; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_clock_data; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_clock_valid; // JTAG/jtag.h(138:1)
  wire proxy3352; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_clock_ready; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_reset_data; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_reset_valid; // JTAG/jtag.h(138:1)
  wire proxy3361; // JTAG/jtag.h(138:1)
  wire TAP3332_io_JTAG_TAP_in_reset_ready; // JTAG/jtag.h(138:1)
  wire[3:0] proxy3364; // JTAG/jtag.h(138:1)
  wire[3:0] TAP3332_io_out_curr_state; // JTAG/jtag.h(138:1)
  wire[31:0] proxy3367; // JTAG/jtag.h(148:1)
  wire[31:0] proxy3368; // /home/blaise/dev/cash/include/reg.h(45:50)
  reg[31:0] reg3372; // JTAG/jtag.h(148:0)
  reg[31:0] reg3379; // JTAG/jtag.h(150:0)
  reg[31:0] reg3386; // JTAG/jtag.h(151:0)
  wire[3:0] proxy3388; // JTAG/jtag.h(157:0)
  wire[31:0] proxy3391; // JTAG/jtag.h(159:0)
  reg[31:0] reg3393; // JTAG/jtag.h(159:0)
  wire eq3397; // JTAG/jtag.h(148:0)
  wire eq3406; // JTAG/jtag.h(148:0)
  wire eq3410; // JTAG/jtag.h(148:0)
  wire[31:0] sel3413; // JTAG/jtag.h(178:1)
  wire[31:0] sel3415; // JTAG/jtag.h(178:0)
  wire proxy3420; // JTAG/jtag.h(184:0)
  wire[31:0] proxy3421; // JTAG/jtag.h(186:2)
  wire[31:0] shr3423; // JTAG/jtag.h(186:2)
  wire[31:0] proxy3424; // JTAG/jtag.h(186:2)
  wire[30:0] proxy3426; // JTAG/jtag.h(186:1)
  wire[31:0] proxy3428; // JTAG/jtag.h(186:0)
  wire[30:0] proxy3429; // /home/blaise/dev/cash/include/logic.h(180:31)
  wire io_JTAG_in_data_data3430; // /home/blaise/dev/cash/include/ioport.h(75:2)
  wire eq3433; // JTAG/jtag.h(148:0)
  wire eq3439; // JTAG/jtag.h(148:0)
  wire eq3442; // JTAG/jtag.h(148:0)
  wire eq3446; // JTAG/jtag.h(148:0)
  wire proxy3454; // JTAG/jtag.h(234:0)
  wire[31:0] proxy3455; // JTAG/jtag.h(236:2)
  wire[31:0] shr3457; // JTAG/jtag.h(236:2)
  wire[31:0] proxy3458; // JTAG/jtag.h(236:2)
  wire[30:0] proxy3460; // JTAG/jtag.h(236:1)
  wire[31:0] proxy3462; // JTAG/jtag.h(236:0)
  wire[30:0] proxy3463; // /home/blaise/dev/cash/include/logic.h(180:32)
  wire io_JTAG_in_data_data3464; // /home/blaise/dev/cash/include/ioport.h(75:3)
  wire eq3467; // JTAG/jtag.h(148:0)
  wire eq3473; // JTAG/jtag.h(148:0)
  wire[31:0] sel3478; // JTAG/jtag.h(161:0)
  wire[31:0] sel3479; // JTAG/jtag.h(210:0)
  wire[31:0] sel3480; // JTAG/jtag.h(205:0)
  wire[31:0] sel3481; // JTAG/jtag.h(161:0)
  reg[31:0] sel3482; // JTAG/jtag.h(161:0)
  wire[31:0] sel3483; // JTAG/jtag.h(205:0)
  wire eq3484; // JTAG/jtag.h(161:0)
  wire andb3485; // JTAG/jtag.h(161:0)
  wire sel3486; // JTAG/jtag.h(165:0)
  wire sel3487; // JTAG/jtag.h(192:0)
  wire sel3488; // JTAG/jtag.h(219:0)
  wire sel3489; // JTAG/jtag.h(241:0)
  wire sel3490; // JTAG/jtag.h(256:0)
  reg sel3491; // JTAG/jtag.h(161:0)
  wire sel3492; // JTAG/jtag.h(165:0)
  wire sel3493; // JTAG/jtag.h(192:0)
  wire sel3494; // JTAG/jtag.h(219:0)
  wire sel3495; // JTAG/jtag.h(241:0)
  wire sel3496; // JTAG/jtag.h(256:0)
  reg sel3497; // JTAG/jtag.h(161:0)

  assign io_JTAG_JTAG_TAP_in_mode_select_ready3171 = proxy3343;
  assign io_JTAG_JTAG_TAP_in_clock_ready3176 = proxy3352;
  assign io_JTAG_JTAG_TAP_in_reset_ready3181 = proxy3361;
  assign TAP3332_clk = clk;
  assign TAP3332_reset = reset;
  TAP TAP3332(.clk(TAP3332_clk), .reset(TAP3332_reset), .io_JTAG_TAP_in_mode_select_data(TAP3332_io_JTAG_TAP_in_mode_select_data), .io_JTAG_TAP_in_mode_select_valid(TAP3332_io_JTAG_TAP_in_mode_select_valid), .io_JTAG_TAP_in_clock_data(TAP3332_io_JTAG_TAP_in_clock_data), .io_JTAG_TAP_in_clock_valid(TAP3332_io_JTAG_TAP_in_clock_valid), .io_JTAG_TAP_in_reset_data(TAP3332_io_JTAG_TAP_in_reset_data), .io_JTAG_TAP_in_reset_valid(TAP3332_io_JTAG_TAP_in_reset_valid), .io_JTAG_TAP_in_mode_select_ready(TAP3332_io_JTAG_TAP_in_mode_select_ready), .io_JTAG_TAP_in_clock_ready(TAP3332_io_JTAG_TAP_in_clock_ready), .io_JTAG_TAP_in_reset_ready(TAP3332_io_JTAG_TAP_in_reset_ready), .io_out_curr_state(TAP3332_io_out_curr_state));
  assign TAP3332_io_JTAG_TAP_in_mode_select_data = io_JTAG_JTAG_TAP_in_mode_select_data;
  assign TAP3332_io_JTAG_TAP_in_mode_select_valid = io_JTAG_JTAG_TAP_in_mode_select_valid;
  assign proxy3343 = TAP3332_io_JTAG_TAP_in_mode_select_ready;
  assign TAP3332_io_JTAG_TAP_in_clock_data = io_JTAG_JTAG_TAP_in_clock_data;
  assign TAP3332_io_JTAG_TAP_in_clock_valid = io_JTAG_JTAG_TAP_in_clock_valid;
  assign proxy3352 = TAP3332_io_JTAG_TAP_in_clock_ready;
  assign TAP3332_io_JTAG_TAP_in_reset_data = io_JTAG_JTAG_TAP_in_reset_data;
  assign TAP3332_io_JTAG_TAP_in_reset_valid = io_JTAG_JTAG_TAP_in_reset_valid;
  assign proxy3361 = TAP3332_io_JTAG_TAP_in_reset_ready;
  assign proxy3364 = TAP3332_io_out_curr_state;
  assign proxy3367 = 32'h0;
  assign proxy3368 = proxy3367;
  always @ (posedge clk) begin
    if (reset)
      reg3372 <= proxy3368;
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
      reg3386 <= sel3483;
  end
  assign proxy3388 = proxy3364;
  assign proxy3391 = reg3393;
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
  assign proxy3420 = proxy3391[0];
  assign proxy3421 = proxy3391;
  assign shr3423 = proxy3421 >> 32'h1;
  assign proxy3424 = shr3423;
  assign proxy3426 = proxy3424[30:0];
  assign proxy3428 = {io_JTAG_in_data_data3430, proxy3429};
  assign proxy3429 = proxy3426;
  assign io_JTAG_in_data_data3430 = io_JTAG_in_data_data;
  assign eq3433 = reg3372 == 32'h0;
  assign eq3439 = reg3372 == 32'h1;
  assign eq3442 = reg3372 == 32'h2;
  assign eq3446 = reg3372 == 32'h0;
  assign proxy3454 = proxy3391[0];
  assign proxy3455 = proxy3391;
  assign shr3457 = proxy3455 >> 32'h1;
  assign proxy3458 = shr3457;
  assign proxy3460 = proxy3458[30:0];
  assign proxy3462 = {io_JTAG_in_data_data3464, proxy3463};
  assign proxy3463 = proxy3460;
  assign io_JTAG_in_data_data3464 = io_JTAG_in_data_data;
  assign eq3467 = reg3372 == 32'h0;
  assign eq3473 = reg3372 == 32'h0;
  assign sel3478 = (proxy3388 == 4'hf) ? proxy3391 : reg3372;
  assign sel3479 = eq3442 ? proxy3391 : reg3379;
  assign sel3480 = eq3439 ? reg3379 : sel3479;
  assign sel3481 = (proxy3388 == 4'h8) ? sel3480 : reg3379;
  always @(*) begin
    case (proxy3388)
      4'h3: sel3482 = sel3415;
      4'h4: sel3482 = proxy3428;
      4'ha: sel3482 = reg3372;
      4'hb: sel3482 = proxy3462;
      default: sel3482 = proxy3391;
    endcase
  end
  assign sel3483 = andb3485 ? proxy3391 : reg3386;
  assign eq3484 = proxy3388 == 4'h8;
  assign andb3485 = eq3484 & eq3439;
  assign sel3486 = eq3397 ? 1'h1 : 1'h0;
  assign sel3487 = eq3433 ? 1'h1 : 1'h0;
  assign sel3488 = eq3446 ? 1'h1 : 1'h0;
  assign sel3489 = eq3467 ? 1'h1 : 1'h0;
  assign sel3490 = eq3473 ? 1'h1 : 1'h0;
  always @(*) begin
    case (proxy3388)
      4'h3: sel3491 = sel3486;
      4'h4: sel3491 = 1'h1;
      4'h8: sel3491 = sel3487;
      4'ha: sel3491 = sel3488;
      4'hb: sel3491 = 1'h1;
      4'hf: sel3491 = sel3489;
      default: sel3491 = sel3490;
    endcase
  end
  assign sel3492 = eq3397 ? io_JTAG_in_data_data : 1'h0;
  assign sel3493 = eq3433 ? io_JTAG_in_data_data : 1'h0;
  assign sel3494 = eq3446 ? io_JTAG_in_data_data : 1'h0;
  assign sel3495 = eq3467 ? io_JTAG_in_data_data : 1'h0;
  assign sel3496 = eq3473 ? io_JTAG_in_data_data : 1'h0;
  always @(*) begin
    case (proxy3388)
      4'h3: sel3497 = sel3492;
      4'h4: sel3497 = proxy3420;
      4'h8: sel3497 = sel3493;
      4'ha: sel3497 = sel3494;
      4'hb: sel3497 = proxy3454;
      4'hf: sel3497 = sel3495;
      default: sel3497 = sel3496;
    endcase
  end

  assign io_JTAG_JTAG_TAP_in_mode_select_ready = io_JTAG_JTAG_TAP_in_mode_select_ready3171;
  assign io_JTAG_JTAG_TAP_in_clock_ready = io_JTAG_JTAG_TAP_in_clock_ready3176;
  assign io_JTAG_JTAG_TAP_in_reset_ready = io_JTAG_JTAG_TAP_in_reset_ready3181;
  assign io_JTAG_in_data_ready = io_JTAG_in_data_valid;
  assign io_JTAG_out_data_data = sel3497;
  assign io_JTAG_out_data_valid = sel3491;

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
  wire[1:0] proxy3557; // csr_handler.h(25:0)
  reg[1:0] reg3559; // csr_handler.h(25:0)
  wire[1:0] proxy3572; // csr_handler.h(38:1)
  wire eq3573; // csr_handler.h(38:1)
  wire[1:0] proxy3576; // csr_handler.h(31:2)
  wire eq3577; // csr_handler.h(31:2)
  wire eq3595; // csr_handler.h(9:0)
  reg sel3597; // csr_handler.h(31:0)
  reg[1:0] sel3598; // csr_handler.h(31:0)
  reg[11:0] sel3599; // csr_handler.h(31:0)
  reg[11:0] sel3600; // csr_handler.h(31:0)
  wire[11:0] marport3602; // csr_handler.h(53:1)
  wire[11:0] proxy3603; // csr_handler.h(53:1)
  wire[31:0] pad3604; // csr_handler.h(53:0)

  assign marport3602 = mem3553[io_in_decode_csr_address];
  always @ (posedge clk) begin
    if (sel3597) begin
      mem3553[sel3600] <= sel3599;
    end
  end
  assign proxy3557 = reg3559;
  always @ (posedge clk) begin
    if (reset)
      reg3559 <= 2'h0;
    else
      reg3559 <= sel3598;
  end
  assign proxy3572 = proxy3557;
  assign eq3573 = proxy3572 == 2'h1;
  assign proxy3576 = proxy3557;
  assign eq3577 = proxy3576 == 2'h0;
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
      sel3598 = 2'h1;
    else if (eq3573)
      sel3598 = 2'h3;
    else
      sel3598 = proxy3557;
  end
  always @(*) begin
    if (eq3577)
      sel3599 = 12'h0;
    else if (eq3573)
      sel3599 = 12'h0;
    else
      sel3599 = io_in_mem_csr_result[11:0];
  end
  always @(*) begin
    if (eq3577)
      sel3600 = 12'hf14;
    else if (eq3573)
      sel3600 = 12'h301;
    else
      sel3600 = io_in_mem_csr_address;
  end
  assign proxy3603 = marport3602;
  assign pad3604 = {{20{1'b0}}, proxy3603};

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
  wire io_IBUS_in_data_ready4; // RocketChip.h(49:0)
  wire[31:0] io_IBUS_out_address_data7; // RocketChip.h(49:0)
  wire io_IBUS_out_address_valid10; // RocketChip.h(49:0)
  wire io_DBUS_in_data_ready16; // RocketChip.h(49:0)
  wire[31:0] io_DBUS_out_data_data19; // RocketChip.h(49:0)
  wire io_DBUS_out_data_valid22; // RocketChip.h(49:0)
  wire[31:0] io_DBUS_out_address_data26; // RocketChip.h(49:0)
  wire io_DBUS_out_address_valid29; // RocketChip.h(49:0)
  wire[1:0] io_DBUS_out_control_data33; // RocketChip.h(49:0)
  wire io_DBUS_out_control_valid36; // RocketChip.h(49:0)
  wire io_INTERRUPT_in_interrupt_id_ready42; // RocketChip.h(49:0)
  wire io_jtag_JTAG_TAP_in_mode_select_ready47; // RocketChip.h(49:0)
  wire io_jtag_JTAG_TAP_in_clock_ready52; // RocketChip.h(49:0)
  wire io_jtag_JTAG_TAP_in_reset_ready57; // RocketChip.h(49:0)
  wire io_jtag_in_data_ready62; // RocketChip.h(49:0)
  wire io_jtag_out_data_data65; // RocketChip.h(49:0)
  wire io_jtag_out_data_valid68; // RocketChip.h(49:0)
  wire io_out_fwd_stall72; // RocketChip.h(49:0)
  wire io_out_branch_stall75; // RocketChip.h(49:0)
  wire Fetch156_clk; // RocketChip.h(49:1)
  wire Fetch156_reset; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_IBUS_in_data_data; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_in_data_valid; // RocketChip.h(49:1)
  wire proxy167; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_in_data_ready; // RocketChip.h(49:1)
  wire[31:0] proxy170; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_IBUS_out_address_data; // RocketChip.h(49:1)
  wire proxy173; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_out_address_valid; // RocketChip.h(49:1)
  wire Fetch156_io_IBUS_out_address_ready; // RocketChip.h(49:1)
  wire proxy179; // RocketChip.h(49:1)
  wire Fetch156_io_in_branch_dir; // RocketChip.h(49:1)
  wire[31:0] proxy182; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_in_branch_dest; // RocketChip.h(49:1)
  wire proxy185; // RocketChip.h(49:1)
  wire Fetch156_io_in_branch_stall; // RocketChip.h(49:1)
  wire proxy188; // RocketChip.h(49:1)
  wire Fetch156_io_in_fwd_stall; // RocketChip.h(49:1)
  wire proxy191; // RocketChip.h(49:1)
  wire Fetch156_io_in_branch_stall_exe; // RocketChip.h(49:1)
  wire proxy194; // RocketChip.h(49:1)
  wire Fetch156_io_in_jal; // RocketChip.h(49:1)
  wire[31:0] proxy197; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_in_jal_dest; // RocketChip.h(49:1)
  wire proxy200; // RocketChip.h(49:1)
  wire Fetch156_io_in_interrupt; // RocketChip.h(49:1)
  wire[31:0] proxy203; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_in_interrupt_pc; // RocketChip.h(49:1)
  wire[31:0] proxy206; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_out_instruction; // RocketChip.h(49:1)
  wire[31:0] proxy209; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_out_curr_PC; // RocketChip.h(49:1)
  wire[31:0] proxy212; // RocketChip.h(49:1)
  wire[31:0] Fetch156_io_out_PC_next; // RocketChip.h(49:1)
  wire[31:0] proxy277; // RocketChip.h(49:2)
  wire F_D_Register278_clk; // RocketChip.h(49:2)
  wire F_D_Register278_reset; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_in_instruction; // RocketChip.h(49:2)
  wire[31:0] proxy283; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_in_PC_next; // RocketChip.h(49:2)
  wire[31:0] proxy286; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_in_curr_PC; // RocketChip.h(49:2)
  wire proxy289; // RocketChip.h(49:2)
  wire F_D_Register278_io_in_branch_stall; // RocketChip.h(49:2)
  wire proxy292; // RocketChip.h(49:2)
  wire F_D_Register278_io_in_branch_stall_exe; // RocketChip.h(49:2)
  wire proxy295; // RocketChip.h(49:2)
  wire F_D_Register278_io_in_fwd_stall; // RocketChip.h(49:2)
  wire[31:0] proxy298; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_out_instruction; // RocketChip.h(49:2)
  wire[31:0] proxy301; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_out_curr_PC; // RocketChip.h(49:2)
  wire[31:0] proxy304; // RocketChip.h(49:2)
  wire[31:0] F_D_Register278_io_out_PC_next; // RocketChip.h(49:2)
  wire[31:0] proxy1058; // RocketChip.h(49:3)
  wire Decode1059_clk; // RocketChip.h(49:3)
  wire Decode1059_reset; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_instruction; // RocketChip.h(49:3)
  wire[31:0] proxy1064; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_PC_next; // RocketChip.h(49:3)
  wire[31:0] proxy1067; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_curr_PC; // RocketChip.h(49:3)
  wire proxy1070; // RocketChip.h(49:3)
  wire Decode1059_io_in_stall; // RocketChip.h(49:3)
  wire[31:0] proxy1073; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_write_data; // RocketChip.h(49:3)
  wire[4:0] proxy1076; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_in_rd; // RocketChip.h(49:3)
  wire[1:0] proxy1079; // RocketChip.h(49:3)
  wire[1:0] Decode1059_io_in_wb; // RocketChip.h(49:3)
  wire proxy1082; // RocketChip.h(49:3)
  wire Decode1059_io_in_src1_fwd; // RocketChip.h(49:3)
  wire[31:0] proxy1085; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_src1_fwd_data; // RocketChip.h(49:3)
  wire proxy1088; // RocketChip.h(49:3)
  wire Decode1059_io_in_src2_fwd; // RocketChip.h(49:3)
  wire[31:0] proxy1091; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_src2_fwd_data; // RocketChip.h(49:3)
  wire proxy1094; // RocketChip.h(49:3)
  wire Decode1059_io_in_csr_fwd; // RocketChip.h(49:3)
  wire[31:0] proxy1097; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_csr_fwd_data; // RocketChip.h(49:3)
  wire[31:0] proxy1100; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_in_csr_data; // RocketChip.h(49:3)
  wire[11:0] proxy1103; // RocketChip.h(49:3)
  wire[11:0] Decode1059_io_out_csr_address; // RocketChip.h(49:3)
  wire proxy1106; // RocketChip.h(49:3)
  wire Decode1059_io_out_is_csr; // RocketChip.h(49:3)
  wire[31:0] proxy1109; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_csr_data; // RocketChip.h(49:3)
  wire[31:0] proxy1112; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_csr_mask; // RocketChip.h(49:3)
  wire[4:0] proxy1115; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_out_rd; // RocketChip.h(49:3)
  wire[4:0] proxy1118; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_out_rs1; // RocketChip.h(49:3)
  wire[31:0] proxy1121; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_rd1; // RocketChip.h(49:3)
  wire[4:0] proxy1124; // RocketChip.h(49:3)
  wire[4:0] Decode1059_io_out_rs2; // RocketChip.h(49:3)
  wire[31:0] proxy1127; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_rd2; // RocketChip.h(49:3)
  wire[1:0] proxy1130; // RocketChip.h(49:3)
  wire[1:0] Decode1059_io_out_wb; // RocketChip.h(49:3)
  wire[3:0] proxy1133; // RocketChip.h(49:3)
  wire[3:0] Decode1059_io_out_alu_op; // RocketChip.h(49:3)
  wire proxy1136; // RocketChip.h(49:3)
  wire Decode1059_io_out_rs2_src; // RocketChip.h(49:3)
  wire[11:0] proxy1139; // RocketChip.h(49:3)
  wire[11:0] Decode1059_io_out_itype_immed; // RocketChip.h(49:3)
  wire[2:0] proxy1142; // RocketChip.h(49:3)
  wire[2:0] Decode1059_io_out_mem_read; // RocketChip.h(49:3)
  wire[2:0] proxy1145; // RocketChip.h(49:3)
  wire[2:0] Decode1059_io_out_mem_write; // RocketChip.h(49:3)
  wire[2:0] proxy1148; // RocketChip.h(49:3)
  wire[2:0] Decode1059_io_out_branch_type; // RocketChip.h(49:3)
  wire proxy1151; // RocketChip.h(49:3)
  wire Decode1059_io_out_branch_stall; // RocketChip.h(49:3)
  wire proxy1154; // RocketChip.h(49:3)
  wire Decode1059_io_out_jal; // RocketChip.h(49:3)
  wire[31:0] proxy1157; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_jal_offset; // RocketChip.h(49:3)
  wire[19:0] proxy1160; // RocketChip.h(49:3)
  wire[19:0] Decode1059_io_out_upper_immed; // RocketChip.h(49:3)
  wire[31:0] proxy1163; // RocketChip.h(49:3)
  wire[31:0] Decode1059_io_out_PC_next; // RocketChip.h(49:3)
  wire[4:0] proxy1466; // RocketChip.h(49:4)
  wire D_E_Register1467_clk; // RocketChip.h(49:4)
  wire D_E_Register1467_reset; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_in_rd; // RocketChip.h(49:4)
  wire[4:0] proxy1472; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_in_rs1; // RocketChip.h(49:4)
  wire[31:0] proxy1475; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_rd1; // RocketChip.h(49:4)
  wire[4:0] proxy1478; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_in_rs2; // RocketChip.h(49:4)
  wire[31:0] proxy1481; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_rd2; // RocketChip.h(49:4)
  wire[3:0] proxy1484; // RocketChip.h(49:4)
  wire[3:0] D_E_Register1467_io_in_alu_op; // RocketChip.h(49:4)
  wire[1:0] proxy1487; // RocketChip.h(49:4)
  wire[1:0] D_E_Register1467_io_in_wb; // RocketChip.h(49:4)
  wire proxy1490; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_rs2_src; // RocketChip.h(49:4)
  wire[11:0] proxy1493; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_in_itype_immed; // RocketChip.h(49:4)
  wire[2:0] proxy1496; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_in_mem_read; // RocketChip.h(49:4)
  wire[2:0] proxy1499; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_in_mem_write; // RocketChip.h(49:4)
  wire[31:0] proxy1502; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_PC_next; // RocketChip.h(49:4)
  wire[2:0] proxy1505; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_in_branch_type; // RocketChip.h(49:4)
  wire proxy1508; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_fwd_stall; // RocketChip.h(49:4)
  wire proxy1511; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_branch_stall; // RocketChip.h(49:4)
  wire[19:0] proxy1514; // RocketChip.h(49:4)
  wire[19:0] D_E_Register1467_io_in_upper_immed; // RocketChip.h(49:4)
  wire[11:0] proxy1517; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_in_csr_address; // RocketChip.h(49:4)
  wire proxy1520; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_is_csr; // RocketChip.h(49:4)
  wire[31:0] proxy1523; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_csr_data; // RocketChip.h(49:4)
  wire[31:0] proxy1526; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_csr_mask; // RocketChip.h(49:4)
  wire[31:0] proxy1529; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_curr_PC; // RocketChip.h(49:4)
  wire proxy1532; // RocketChip.h(49:4)
  wire D_E_Register1467_io_in_jal; // RocketChip.h(49:4)
  wire[31:0] proxy1535; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_in_jal_offset; // RocketChip.h(49:4)
  wire[11:0] proxy1538; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_out_csr_address; // RocketChip.h(49:4)
  wire proxy1541; // RocketChip.h(49:4)
  wire D_E_Register1467_io_out_is_csr; // RocketChip.h(49:4)
  wire[31:0] proxy1544; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_csr_data; // RocketChip.h(49:4)
  wire[31:0] proxy1547; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_csr_mask; // RocketChip.h(49:4)
  wire[4:0] proxy1550; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_out_rd; // RocketChip.h(49:4)
  wire[4:0] proxy1553; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_out_rs1; // RocketChip.h(49:4)
  wire[31:0] proxy1556; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_rd1; // RocketChip.h(49:4)
  wire[4:0] proxy1559; // RocketChip.h(49:4)
  wire[4:0] D_E_Register1467_io_out_rs2; // RocketChip.h(49:4)
  wire[31:0] proxy1562; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_rd2; // RocketChip.h(49:4)
  wire[3:0] proxy1565; // RocketChip.h(49:4)
  wire[3:0] D_E_Register1467_io_out_alu_op; // RocketChip.h(49:4)
  wire[1:0] proxy1568; // RocketChip.h(49:4)
  wire[1:0] D_E_Register1467_io_out_wb; // RocketChip.h(49:4)
  wire proxy1571; // RocketChip.h(49:4)
  wire D_E_Register1467_io_out_rs2_src; // RocketChip.h(49:4)
  wire[11:0] proxy1574; // RocketChip.h(49:4)
  wire[11:0] D_E_Register1467_io_out_itype_immed; // RocketChip.h(49:4)
  wire[2:0] proxy1577; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_out_mem_read; // RocketChip.h(49:4)
  wire[2:0] proxy1580; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_out_mem_write; // RocketChip.h(49:4)
  wire[2:0] proxy1583; // RocketChip.h(49:4)
  wire[2:0] D_E_Register1467_io_out_branch_type; // RocketChip.h(49:4)
  wire[19:0] proxy1586; // RocketChip.h(49:4)
  wire[19:0] D_E_Register1467_io_out_upper_immed; // RocketChip.h(49:4)
  wire[31:0] proxy1589; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_curr_PC; // RocketChip.h(49:4)
  wire proxy1592; // RocketChip.h(49:4)
  wire D_E_Register1467_io_out_jal; // RocketChip.h(49:4)
  wire[31:0] proxy1595; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_jal_offset; // RocketChip.h(49:4)
  wire[31:0] proxy1598; // RocketChip.h(49:4)
  wire[31:0] D_E_Register1467_io_out_PC_next; // RocketChip.h(49:4)
  wire[4:0] proxy1798; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_in_rd; // RocketChip.h(49:5)
  wire[4:0] proxy1802; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_in_rs1; // RocketChip.h(49:5)
  wire[31:0] proxy1805; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_rd1; // RocketChip.h(49:5)
  wire[4:0] proxy1808; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_in_rs2; // RocketChip.h(49:5)
  wire[31:0] proxy1811; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_rd2; // RocketChip.h(49:5)
  wire[3:0] proxy1814; // RocketChip.h(49:5)
  wire[3:0] Execute1799_io_in_alu_op; // RocketChip.h(49:5)
  wire[1:0] proxy1817; // RocketChip.h(49:5)
  wire[1:0] Execute1799_io_in_wb; // RocketChip.h(49:5)
  wire proxy1820; // RocketChip.h(49:5)
  wire Execute1799_io_in_rs2_src; // RocketChip.h(49:5)
  wire[11:0] proxy1823; // RocketChip.h(49:5)
  wire[11:0] Execute1799_io_in_itype_immed; // RocketChip.h(49:5)
  wire[2:0] proxy1826; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_in_mem_read; // RocketChip.h(49:5)
  wire[2:0] proxy1829; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_in_mem_write; // RocketChip.h(49:5)
  wire[31:0] proxy1832; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_PC_next; // RocketChip.h(49:5)
  wire[2:0] proxy1835; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_in_branch_type; // RocketChip.h(49:5)
  wire[19:0] proxy1838; // RocketChip.h(49:5)
  wire[19:0] Execute1799_io_in_upper_immed; // RocketChip.h(49:5)
  wire[11:0] proxy1841; // RocketChip.h(49:5)
  wire[11:0] Execute1799_io_in_csr_address; // RocketChip.h(49:5)
  wire proxy1844; // RocketChip.h(49:5)
  wire Execute1799_io_in_is_csr; // RocketChip.h(49:5)
  wire[31:0] proxy1847; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_csr_data; // RocketChip.h(49:5)
  wire[31:0] proxy1850; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_csr_mask; // RocketChip.h(49:5)
  wire proxy1853; // RocketChip.h(49:5)
  wire Execute1799_io_in_jal; // RocketChip.h(49:5)
  wire[31:0] proxy1856; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_jal_offset; // RocketChip.h(49:5)
  wire[31:0] proxy1859; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_in_curr_PC; // RocketChip.h(49:5)
  wire[11:0] proxy1862; // RocketChip.h(49:5)
  wire[11:0] Execute1799_io_out_csr_address; // RocketChip.h(49:5)
  wire proxy1865; // RocketChip.h(49:5)
  wire Execute1799_io_out_is_csr; // RocketChip.h(49:5)
  wire[31:0] proxy1868; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_csr_result; // RocketChip.h(49:5)
  wire[31:0] proxy1871; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_alu_result; // RocketChip.h(49:5)
  wire[4:0] proxy1874; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_out_rd; // RocketChip.h(49:5)
  wire[1:0] proxy1877; // RocketChip.h(49:5)
  wire[1:0] Execute1799_io_out_wb; // RocketChip.h(49:5)
  wire[4:0] proxy1880; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_out_rs1; // RocketChip.h(49:5)
  wire[31:0] proxy1883; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_rd1; // RocketChip.h(49:5)
  wire[4:0] proxy1886; // RocketChip.h(49:5)
  wire[4:0] Execute1799_io_out_rs2; // RocketChip.h(49:5)
  wire[31:0] proxy1889; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_rd2; // RocketChip.h(49:5)
  wire[2:0] proxy1892; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_out_mem_read; // RocketChip.h(49:5)
  wire[2:0] proxy1895; // RocketChip.h(49:5)
  wire[2:0] Execute1799_io_out_mem_write; // RocketChip.h(49:5)
  wire proxy1898; // RocketChip.h(49:5)
  wire Execute1799_io_out_jal; // RocketChip.h(49:5)
  wire[31:0] proxy1901; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_jal_dest; // RocketChip.h(49:5)
  wire[31:0] proxy1904; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_branch_offset; // RocketChip.h(49:5)
  wire proxy1907; // RocketChip.h(49:5)
  wire Execute1799_io_out_branch_stall; // RocketChip.h(49:5)
  wire[31:0] proxy1910; // RocketChip.h(49:5)
  wire[31:0] Execute1799_io_out_PC_next; // RocketChip.h(49:5)
  wire[31:0] proxy2082; // RocketChip.h(49:6)
  wire E_M_Register2083_clk; // RocketChip.h(49:6)
  wire E_M_Register2083_reset; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_alu_result; // RocketChip.h(49:6)
  wire[4:0] proxy2088; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_in_rd; // RocketChip.h(49:6)
  wire[1:0] proxy2091; // RocketChip.h(49:6)
  wire[1:0] E_M_Register2083_io_in_wb; // RocketChip.h(49:6)
  wire[4:0] proxy2094; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_in_rs1; // RocketChip.h(49:6)
  wire[31:0] proxy2097; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_rd1; // RocketChip.h(49:6)
  wire[4:0] proxy2100; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_in_rs2; // RocketChip.h(49:6)
  wire[31:0] proxy2103; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_rd2; // RocketChip.h(49:6)
  wire[2:0] proxy2106; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_in_mem_read; // RocketChip.h(49:6)
  wire[2:0] proxy2109; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_in_mem_write; // RocketChip.h(49:6)
  wire[31:0] proxy2112; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_PC_next; // RocketChip.h(49:6)
  wire[11:0] proxy2115; // RocketChip.h(49:6)
  wire[11:0] E_M_Register2083_io_in_csr_address; // RocketChip.h(49:6)
  wire proxy2118; // RocketChip.h(49:6)
  wire E_M_Register2083_io_in_is_csr; // RocketChip.h(49:6)
  wire[31:0] proxy2121; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_csr_result; // RocketChip.h(49:6)
  wire[31:0] proxy2124; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_curr_PC; // RocketChip.h(49:6)
  wire[31:0] proxy2127; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_in_branch_offset; // RocketChip.h(49:6)
  wire[2:0] proxy2130; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_in_branch_type; // RocketChip.h(49:6)
  wire[11:0] proxy2133; // RocketChip.h(49:6)
  wire[11:0] E_M_Register2083_io_out_csr_address; // RocketChip.h(49:6)
  wire proxy2136; // RocketChip.h(49:6)
  wire E_M_Register2083_io_out_is_csr; // RocketChip.h(49:6)
  wire[31:0] proxy2139; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_csr_result; // RocketChip.h(49:6)
  wire[31:0] proxy2142; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_alu_result; // RocketChip.h(49:6)
  wire[4:0] proxy2145; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_out_rd; // RocketChip.h(49:6)
  wire[1:0] proxy2148; // RocketChip.h(49:6)
  wire[1:0] E_M_Register2083_io_out_wb; // RocketChip.h(49:6)
  wire[4:0] proxy2151; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_out_rs1; // RocketChip.h(49:6)
  wire[31:0] proxy2154; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_rd1; // RocketChip.h(49:6)
  wire[31:0] proxy2157; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_rd2; // RocketChip.h(49:6)
  wire[4:0] proxy2160; // RocketChip.h(49:6)
  wire[4:0] E_M_Register2083_io_out_rs2; // RocketChip.h(49:6)
  wire[2:0] proxy2163; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_out_mem_read; // RocketChip.h(49:6)
  wire[2:0] proxy2166; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_out_mem_write; // RocketChip.h(49:6)
  wire[31:0] proxy2169; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_curr_PC; // RocketChip.h(49:6)
  wire[31:0] proxy2172; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_branch_offset; // RocketChip.h(49:6)
  wire[2:0] proxy2175; // RocketChip.h(49:6)
  wire[2:0] E_M_Register2083_io_out_branch_type; // RocketChip.h(49:6)
  wire[31:0] proxy2178; // RocketChip.h(49:6)
  wire[31:0] E_M_Register2083_io_out_PC_next; // RocketChip.h(49:6)
  wire[31:0] Memory2513_io_DBUS_in_data_data; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_in_data_valid; // RocketChip.h(49:7)
  wire proxy2519; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_in_data_ready; // RocketChip.h(49:7)
  wire[31:0] proxy2522; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_DBUS_out_data_data; // RocketChip.h(49:7)
  wire proxy2525; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_data_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_data_ready; // RocketChip.h(49:7)
  wire[31:0] proxy2531; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_DBUS_out_address_data; // RocketChip.h(49:7)
  wire proxy2534; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_address_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_address_ready; // RocketChip.h(49:7)
  wire[1:0] proxy2540; // RocketChip.h(49:7)
  wire[1:0] Memory2513_io_DBUS_out_control_data; // RocketChip.h(49:7)
  wire proxy2543; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_control_valid; // RocketChip.h(49:7)
  wire Memory2513_io_DBUS_out_control_ready; // RocketChip.h(49:7)
  wire[31:0] proxy2549; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_alu_result; // RocketChip.h(49:7)
  wire[2:0] proxy2552; // RocketChip.h(49:7)
  wire[2:0] Memory2513_io_in_mem_read; // RocketChip.h(49:7)
  wire[2:0] proxy2555; // RocketChip.h(49:7)
  wire[2:0] Memory2513_io_in_mem_write; // RocketChip.h(49:7)
  wire[4:0] proxy2558; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_in_rd; // RocketChip.h(49:7)
  wire[1:0] proxy2561; // RocketChip.h(49:7)
  wire[1:0] Memory2513_io_in_wb; // RocketChip.h(49:7)
  wire[4:0] proxy2564; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_in_rs1; // RocketChip.h(49:7)
  wire[31:0] proxy2567; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_rd1; // RocketChip.h(49:7)
  wire[4:0] proxy2570; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_in_rs2; // RocketChip.h(49:7)
  wire[31:0] proxy2573; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_rd2; // RocketChip.h(49:7)
  wire[31:0] proxy2576; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_PC_next; // RocketChip.h(49:7)
  wire[31:0] proxy2579; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_curr_PC; // RocketChip.h(49:7)
  wire[31:0] proxy2582; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_in_branch_offset; // RocketChip.h(49:7)
  wire[2:0] proxy2585; // RocketChip.h(49:7)
  wire[2:0] Memory2513_io_in_branch_type; // RocketChip.h(49:7)
  wire[31:0] proxy2588; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_alu_result; // RocketChip.h(49:7)
  wire[31:0] proxy2591; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_mem_result; // RocketChip.h(49:7)
  wire[4:0] proxy2594; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_out_rd; // RocketChip.h(49:7)
  wire[1:0] proxy2597; // RocketChip.h(49:7)
  wire[1:0] Memory2513_io_out_wb; // RocketChip.h(49:7)
  wire[4:0] proxy2600; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_out_rs1; // RocketChip.h(49:7)
  wire[4:0] proxy2603; // RocketChip.h(49:7)
  wire[4:0] Memory2513_io_out_rs2; // RocketChip.h(49:7)
  wire proxy2606; // RocketChip.h(49:7)
  wire Memory2513_io_out_branch_dir; // RocketChip.h(49:7)
  wire[31:0] proxy2609; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_branch_dest; // RocketChip.h(49:7)
  wire[31:0] proxy2612; // RocketChip.h(49:7)
  wire[31:0] Memory2513_io_out_PC_next; // RocketChip.h(49:7)
  wire[31:0] proxy2691; // RocketChip.h(49:8)
  wire M_W_Register2692_clk; // RocketChip.h(49:8)
  wire M_W_Register2692_reset; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_in_alu_result; // RocketChip.h(49:8)
  wire[31:0] proxy2697; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_in_mem_result; // RocketChip.h(49:8)
  wire[4:0] proxy2700; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_in_rd; // RocketChip.h(49:8)
  wire[1:0] proxy2703; // RocketChip.h(49:8)
  wire[1:0] M_W_Register2692_io_in_wb; // RocketChip.h(49:8)
  wire[4:0] proxy2706; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_in_rs1; // RocketChip.h(49:8)
  wire[4:0] proxy2709; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_in_rs2; // RocketChip.h(49:8)
  wire[31:0] proxy2712; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_in_PC_next; // RocketChip.h(49:8)
  wire[31:0] proxy2715; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_out_alu_result; // RocketChip.h(49:8)
  wire[31:0] proxy2718; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_out_mem_result; // RocketChip.h(49:8)
  wire[4:0] proxy2721; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_out_rd; // RocketChip.h(49:8)
  wire[1:0] proxy2724; // RocketChip.h(49:8)
  wire[1:0] M_W_Register2692_io_out_wb; // RocketChip.h(49:8)
  wire[4:0] proxy2727; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_out_rs1; // RocketChip.h(49:8)
  wire[4:0] proxy2730; // RocketChip.h(49:8)
  wire[4:0] M_W_Register2692_io_out_rs2; // RocketChip.h(49:8)
  wire[31:0] proxy2733; // RocketChip.h(49:8)
  wire[31:0] M_W_Register2692_io_out_PC_next; // RocketChip.h(49:8)
  wire[31:0] proxy2764; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_in_alu_result; // RocketChip.h(49:9)
  wire[31:0] proxy2768; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_in_mem_result; // RocketChip.h(49:9)
  wire[4:0] proxy2771; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_in_rd; // RocketChip.h(49:9)
  wire[1:0] proxy2774; // RocketChip.h(49:9)
  wire[1:0] Write_Back2765_io_in_wb; // RocketChip.h(49:9)
  wire[4:0] proxy2777; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_in_rs1; // RocketChip.h(49:9)
  wire[4:0] proxy2780; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_in_rs2; // RocketChip.h(49:9)
  wire[31:0] proxy2783; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_in_PC_next; // RocketChip.h(49:9)
  wire[31:0] proxy2786; // RocketChip.h(49:9)
  wire[31:0] Write_Back2765_io_out_write_data; // RocketChip.h(49:9)
  wire[4:0] proxy2789; // RocketChip.h(49:9)
  wire[4:0] Write_Back2765_io_out_rd; // RocketChip.h(49:9)
  wire[1:0] proxy2792; // RocketChip.h(49:9)
  wire[1:0] Write_Back2765_io_out_wb; // RocketChip.h(49:9)
  wire[4:0] proxy3048; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_decode_src1; // RocketChip.h(49:10)
  wire[4:0] proxy3052; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_decode_src2; // RocketChip.h(49:10)
  wire[11:0] proxy3055; // RocketChip.h(49:10)
  wire[11:0] Forwarding3049_io_in_decode_csr_address; // RocketChip.h(49:10)
  wire[4:0] proxy3058; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_execute_dest; // RocketChip.h(49:10)
  wire[1:0] proxy3061; // RocketChip.h(49:10)
  wire[1:0] Forwarding3049_io_in_execute_wb; // RocketChip.h(49:10)
  wire[31:0] proxy3064; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_execute_alu_result; // RocketChip.h(49:10)
  wire[31:0] proxy3067; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_execute_PC_next; // RocketChip.h(49:10)
  wire proxy3070; // RocketChip.h(49:10)
  wire Forwarding3049_io_in_execute_is_csr; // RocketChip.h(49:10)
  wire[11:0] proxy3073; // RocketChip.h(49:10)
  wire[11:0] Forwarding3049_io_in_execute_csr_address; // RocketChip.h(49:10)
  wire[31:0] proxy3076; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_execute_csr_result; // RocketChip.h(49:10)
  wire[4:0] proxy3079; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_memory_dest; // RocketChip.h(49:10)
  wire[1:0] proxy3082; // RocketChip.h(49:10)
  wire[1:0] Forwarding3049_io_in_memory_wb; // RocketChip.h(49:10)
  wire[31:0] proxy3085; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_alu_result; // RocketChip.h(49:10)
  wire[31:0] proxy3088; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_mem_data; // RocketChip.h(49:10)
  wire[31:0] proxy3091; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_PC_next; // RocketChip.h(49:10)
  wire proxy3094; // RocketChip.h(49:10)
  wire Forwarding3049_io_in_memory_is_csr; // RocketChip.h(49:10)
  wire[11:0] proxy3097; // RocketChip.h(49:10)
  wire[11:0] Forwarding3049_io_in_memory_csr_address; // RocketChip.h(49:10)
  wire[31:0] proxy3100; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_memory_csr_result; // RocketChip.h(49:10)
  wire[4:0] proxy3103; // RocketChip.h(49:10)
  wire[4:0] Forwarding3049_io_in_writeback_dest; // RocketChip.h(49:10)
  wire[1:0] proxy3106; // RocketChip.h(49:10)
  wire[1:0] Forwarding3049_io_in_writeback_wb; // RocketChip.h(49:10)
  wire[31:0] proxy3109; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_writeback_alu_result; // RocketChip.h(49:10)
  wire[31:0] proxy3112; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_writeback_mem_data; // RocketChip.h(49:10)
  wire[31:0] proxy3115; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_in_writeback_PC_next; // RocketChip.h(49:10)
  wire proxy3118; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_src1_fwd; // RocketChip.h(49:10)
  wire[31:0] proxy3121; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_out_src1_fwd_data; // RocketChip.h(49:10)
  wire proxy3124; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_src2_fwd; // RocketChip.h(49:10)
  wire[31:0] proxy3127; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_out_src2_fwd_data; // RocketChip.h(49:10)
  wire proxy3130; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_csr_fwd; // RocketChip.h(49:10)
  wire[31:0] proxy3133; // RocketChip.h(49:10)
  wire[31:0] Forwarding3049_io_out_csr_fwd_data; // RocketChip.h(49:10)
  wire proxy3136; // RocketChip.h(49:10)
  wire Forwarding3049_io_out_fwd_stall; // RocketChip.h(49:10)
  wire Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_data; // RocketChip.h(49:11)
  wire Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_valid; // RocketChip.h(49:11)
  wire proxy3160; // RocketChip.h(49:11)
  wire Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_ready; // RocketChip.h(49:11)
  wire proxy3163; // RocketChip.h(49:11)
  wire Interrupt_Handler3154_io_out_interrupt; // RocketChip.h(49:11)
  wire[31:0] proxy3166; // RocketChip.h(49:11)
  wire[31:0] Interrupt_Handler3154_io_out_interrupt_pc; // RocketChip.h(49:11)
  wire JTAG3500_clk; // RocketChip.h(49:12)
  wire JTAG3500_reset; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_valid; // RocketChip.h(49:12)
  wire proxy3508; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_clock_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_clock_valid; // RocketChip.h(49:12)
  wire proxy3517; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_clock_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_reset_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_reset_valid; // RocketChip.h(49:12)
  wire proxy3526; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_JTAG_TAP_in_reset_ready; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_in_data_data; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_in_data_valid; // RocketChip.h(49:12)
  wire proxy3535; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_in_data_ready; // RocketChip.h(49:12)
  wire proxy3538; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_out_data_data; // RocketChip.h(49:12)
  wire proxy3541; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_out_data_valid; // RocketChip.h(49:12)
  wire JTAG3500_io_JTAG_out_data_ready; // RocketChip.h(49:12)
  wire[11:0] proxy3606; // RocketChip.h(49:13)
  wire CSR_Handler3607_clk; // RocketChip.h(49:13)
  wire CSR_Handler3607_reset; // RocketChip.h(49:13)
  wire[11:0] CSR_Handler3607_io_in_decode_csr_address; // RocketChip.h(49:13)
  wire[11:0] proxy3612; // RocketChip.h(49:13)
  wire[11:0] CSR_Handler3607_io_in_mem_csr_address; // RocketChip.h(49:13)
  wire proxy3615; // RocketChip.h(49:13)
  wire CSR_Handler3607_io_in_mem_is_csr; // RocketChip.h(49:13)
  wire[31:0] proxy3618; // RocketChip.h(49:13)
  wire[31:0] CSR_Handler3607_io_in_mem_csr_result; // RocketChip.h(49:13)
  wire[31:0] proxy3621; // RocketChip.h(49:13)
  wire[31:0] CSR_Handler3607_io_out_decode_csr_data; // RocketChip.h(49:13)
  wire proxy3623; // RocketChip.h(67:0)
  wire orl3624; // RocketChip.h(67:0)
  wire proxy3625; // RocketChip.h(67:0)
  wire proxy3628; // RocketChip.h(266:1)
  wire eq3629; // RocketChip.h(266:1)
  wire proxy3632; // RocketChip.h(266:3)
  wire eq3633; // RocketChip.h(266:3)
  wire orl3635; // RocketChip.h(266:3)
  wire proxy3636; // RocketChip.h(266:3)

  assign io_IBUS_in_data_ready4 = proxy167;
  assign io_IBUS_out_address_data7 = proxy170;
  assign io_IBUS_out_address_valid10 = proxy173;
  assign io_DBUS_in_data_ready16 = proxy2519;
  assign io_DBUS_out_data_data19 = proxy2522;
  assign io_DBUS_out_data_valid22 = proxy2525;
  assign io_DBUS_out_address_data26 = proxy2531;
  assign io_DBUS_out_address_valid29 = proxy2534;
  assign io_DBUS_out_control_data33 = proxy2540;
  assign io_DBUS_out_control_valid36 = proxy2543;
  assign io_INTERRUPT_in_interrupt_id_ready42 = proxy3160;
  assign io_jtag_JTAG_TAP_in_mode_select_ready47 = proxy3508;
  assign io_jtag_JTAG_TAP_in_clock_ready52 = proxy3517;
  assign io_jtag_JTAG_TAP_in_reset_ready57 = proxy3526;
  assign io_jtag_in_data_ready62 = proxy3535;
  assign io_jtag_out_data_data65 = proxy3538;
  assign io_jtag_out_data_valid68 = proxy3541;
  assign io_out_fwd_stall72 = proxy3136;
  assign io_out_branch_stall75 = proxy3625;
  assign Fetch156_clk = clk;
  assign Fetch156_reset = reset;
  Fetch Fetch156(.clk(Fetch156_clk), .reset(Fetch156_reset), .io_IBUS_in_data_data(Fetch156_io_IBUS_in_data_data), .io_IBUS_in_data_valid(Fetch156_io_IBUS_in_data_valid), .io_IBUS_out_address_ready(Fetch156_io_IBUS_out_address_ready), .io_in_branch_dir(Fetch156_io_in_branch_dir), .io_in_branch_dest(Fetch156_io_in_branch_dest), .io_in_branch_stall(Fetch156_io_in_branch_stall), .io_in_fwd_stall(Fetch156_io_in_fwd_stall), .io_in_branch_stall_exe(Fetch156_io_in_branch_stall_exe), .io_in_jal(Fetch156_io_in_jal), .io_in_jal_dest(Fetch156_io_in_jal_dest), .io_in_interrupt(Fetch156_io_in_interrupt), .io_in_interrupt_pc(Fetch156_io_in_interrupt_pc), .io_IBUS_in_data_ready(Fetch156_io_IBUS_in_data_ready), .io_IBUS_out_address_data(Fetch156_io_IBUS_out_address_data), .io_IBUS_out_address_valid(Fetch156_io_IBUS_out_address_valid), .io_out_instruction(Fetch156_io_out_instruction), .io_out_curr_PC(Fetch156_io_out_curr_PC), .io_out_PC_next(Fetch156_io_out_PC_next));
  assign Fetch156_io_IBUS_in_data_data = io_IBUS_in_data_data;
  assign Fetch156_io_IBUS_in_data_valid = io_IBUS_in_data_valid;
  assign proxy167 = Fetch156_io_IBUS_in_data_ready;
  assign proxy170 = Fetch156_io_IBUS_out_address_data;
  assign proxy173 = Fetch156_io_IBUS_out_address_valid;
  assign Fetch156_io_IBUS_out_address_ready = io_IBUS_out_address_ready;
  assign proxy179 = proxy2606;
  assign Fetch156_io_in_branch_dir = proxy179;
  assign proxy182 = proxy2609;
  assign Fetch156_io_in_branch_dest = proxy182;
  assign proxy185 = proxy1151;
  assign Fetch156_io_in_branch_stall = proxy185;
  assign proxy188 = proxy3136;
  assign Fetch156_io_in_fwd_stall = proxy188;
  assign proxy191 = proxy1907;
  assign Fetch156_io_in_branch_stall_exe = proxy191;
  assign proxy194 = proxy1898;
  assign Fetch156_io_in_jal = proxy194;
  assign proxy197 = proxy1901;
  assign Fetch156_io_in_jal_dest = proxy197;
  assign proxy200 = proxy3163;
  assign Fetch156_io_in_interrupt = proxy200;
  assign proxy203 = proxy3166;
  assign Fetch156_io_in_interrupt_pc = proxy203;
  assign proxy206 = Fetch156_io_out_instruction;
  assign proxy209 = Fetch156_io_out_curr_PC;
  assign proxy212 = Fetch156_io_out_PC_next;
  assign proxy277 = proxy206;
  assign F_D_Register278_clk = clk;
  assign F_D_Register278_reset = reset;
  F_D_Register F_D_Register278(.clk(F_D_Register278_clk), .reset(F_D_Register278_reset), .io_in_instruction(F_D_Register278_io_in_instruction), .io_in_PC_next(F_D_Register278_io_in_PC_next), .io_in_curr_PC(F_D_Register278_io_in_curr_PC), .io_in_branch_stall(F_D_Register278_io_in_branch_stall), .io_in_branch_stall_exe(F_D_Register278_io_in_branch_stall_exe), .io_in_fwd_stall(F_D_Register278_io_in_fwd_stall), .io_out_instruction(F_D_Register278_io_out_instruction), .io_out_curr_PC(F_D_Register278_io_out_curr_PC), .io_out_PC_next(F_D_Register278_io_out_PC_next));
  assign F_D_Register278_io_in_instruction = proxy277;
  assign proxy283 = proxy212;
  assign F_D_Register278_io_in_PC_next = proxy283;
  assign proxy286 = proxy209;
  assign F_D_Register278_io_in_curr_PC = proxy286;
  assign proxy289 = proxy1151;
  assign F_D_Register278_io_in_branch_stall = proxy289;
  assign proxy292 = proxy1907;
  assign F_D_Register278_io_in_branch_stall_exe = proxy292;
  assign proxy295 = proxy3136;
  assign F_D_Register278_io_in_fwd_stall = proxy295;
  assign proxy298 = F_D_Register278_io_out_instruction;
  assign proxy301 = F_D_Register278_io_out_curr_PC;
  assign proxy304 = F_D_Register278_io_out_PC_next;
  assign proxy1058 = proxy298;
  assign Decode1059_clk = clk;
  assign Decode1059_reset = reset;
  Decode Decode1059(.clk(Decode1059_clk), .reset(Decode1059_reset), .io_in_instruction(Decode1059_io_in_instruction), .io_in_PC_next(Decode1059_io_in_PC_next), .io_in_curr_PC(Decode1059_io_in_curr_PC), .io_in_stall(Decode1059_io_in_stall), .io_in_write_data(Decode1059_io_in_write_data), .io_in_rd(Decode1059_io_in_rd), .io_in_wb(Decode1059_io_in_wb), .io_in_src1_fwd(Decode1059_io_in_src1_fwd), .io_in_src1_fwd_data(Decode1059_io_in_src1_fwd_data), .io_in_src2_fwd(Decode1059_io_in_src2_fwd), .io_in_src2_fwd_data(Decode1059_io_in_src2_fwd_data), .io_in_csr_fwd(Decode1059_io_in_csr_fwd), .io_in_csr_fwd_data(Decode1059_io_in_csr_fwd_data), .io_in_csr_data(Decode1059_io_in_csr_data), .io_out_csr_address(Decode1059_io_out_csr_address), .io_out_is_csr(Decode1059_io_out_is_csr), .io_out_csr_data(Decode1059_io_out_csr_data), .io_out_csr_mask(Decode1059_io_out_csr_mask), .io_out_rd(Decode1059_io_out_rd), .io_out_rs1(Decode1059_io_out_rs1), .io_out_rd1(Decode1059_io_out_rd1), .io_out_rs2(Decode1059_io_out_rs2), .io_out_rd2(Decode1059_io_out_rd2), .io_out_wb(Decode1059_io_out_wb), .io_out_alu_op(Decode1059_io_out_alu_op), .io_out_rs2_src(Decode1059_io_out_rs2_src), .io_out_itype_immed(Decode1059_io_out_itype_immed), .io_out_mem_read(Decode1059_io_out_mem_read), .io_out_mem_write(Decode1059_io_out_mem_write), .io_out_branch_type(Decode1059_io_out_branch_type), .io_out_branch_stall(Decode1059_io_out_branch_stall), .io_out_jal(Decode1059_io_out_jal), .io_out_jal_offset(Decode1059_io_out_jal_offset), .io_out_upper_immed(Decode1059_io_out_upper_immed), .io_out_PC_next(Decode1059_io_out_PC_next));
  assign Decode1059_io_in_instruction = proxy1058;
  assign proxy1064 = proxy304;
  assign Decode1059_io_in_PC_next = proxy1064;
  assign proxy1067 = proxy301;
  assign Decode1059_io_in_curr_PC = proxy1067;
  assign proxy1070 = proxy3636;
  assign Decode1059_io_in_stall = proxy1070;
  assign proxy1073 = proxy2786;
  assign Decode1059_io_in_write_data = proxy1073;
  assign proxy1076 = proxy2789;
  assign Decode1059_io_in_rd = proxy1076;
  assign proxy1079 = proxy2792;
  assign Decode1059_io_in_wb = proxy1079;
  assign proxy1082 = proxy3118;
  assign Decode1059_io_in_src1_fwd = proxy1082;
  assign proxy1085 = proxy3121;
  assign Decode1059_io_in_src1_fwd_data = proxy1085;
  assign proxy1088 = proxy3124;
  assign Decode1059_io_in_src2_fwd = proxy1088;
  assign proxy1091 = proxy3127;
  assign Decode1059_io_in_src2_fwd_data = proxy1091;
  assign proxy1094 = proxy3130;
  assign Decode1059_io_in_csr_fwd = proxy1094;
  assign proxy1097 = proxy3133;
  assign Decode1059_io_in_csr_fwd_data = proxy1097;
  assign proxy1100 = proxy3621;
  assign Decode1059_io_in_csr_data = proxy1100;
  assign proxy1103 = Decode1059_io_out_csr_address;
  assign proxy1106 = Decode1059_io_out_is_csr;
  assign proxy1109 = Decode1059_io_out_csr_data;
  assign proxy1112 = Decode1059_io_out_csr_mask;
  assign proxy1115 = Decode1059_io_out_rd;
  assign proxy1118 = Decode1059_io_out_rs1;
  assign proxy1121 = Decode1059_io_out_rd1;
  assign proxy1124 = Decode1059_io_out_rs2;
  assign proxy1127 = Decode1059_io_out_rd2;
  assign proxy1130 = Decode1059_io_out_wb;
  assign proxy1133 = Decode1059_io_out_alu_op;
  assign proxy1136 = Decode1059_io_out_rs2_src;
  assign proxy1139 = Decode1059_io_out_itype_immed;
  assign proxy1142 = Decode1059_io_out_mem_read;
  assign proxy1145 = Decode1059_io_out_mem_write;
  assign proxy1148 = Decode1059_io_out_branch_type;
  assign proxy1151 = Decode1059_io_out_branch_stall;
  assign proxy1154 = Decode1059_io_out_jal;
  assign proxy1157 = Decode1059_io_out_jal_offset;
  assign proxy1160 = Decode1059_io_out_upper_immed;
  assign proxy1163 = Decode1059_io_out_PC_next;
  assign proxy1466 = proxy1115;
  assign D_E_Register1467_clk = clk;
  assign D_E_Register1467_reset = reset;
  D_E_Register D_E_Register1467(.clk(D_E_Register1467_clk), .reset(D_E_Register1467_reset), .io_in_rd(D_E_Register1467_io_in_rd), .io_in_rs1(D_E_Register1467_io_in_rs1), .io_in_rd1(D_E_Register1467_io_in_rd1), .io_in_rs2(D_E_Register1467_io_in_rs2), .io_in_rd2(D_E_Register1467_io_in_rd2), .io_in_alu_op(D_E_Register1467_io_in_alu_op), .io_in_wb(D_E_Register1467_io_in_wb), .io_in_rs2_src(D_E_Register1467_io_in_rs2_src), .io_in_itype_immed(D_E_Register1467_io_in_itype_immed), .io_in_mem_read(D_E_Register1467_io_in_mem_read), .io_in_mem_write(D_E_Register1467_io_in_mem_write), .io_in_PC_next(D_E_Register1467_io_in_PC_next), .io_in_branch_type(D_E_Register1467_io_in_branch_type), .io_in_fwd_stall(D_E_Register1467_io_in_fwd_stall), .io_in_branch_stall(D_E_Register1467_io_in_branch_stall), .io_in_upper_immed(D_E_Register1467_io_in_upper_immed), .io_in_csr_address(D_E_Register1467_io_in_csr_address), .io_in_is_csr(D_E_Register1467_io_in_is_csr), .io_in_csr_data(D_E_Register1467_io_in_csr_data), .io_in_csr_mask(D_E_Register1467_io_in_csr_mask), .io_in_curr_PC(D_E_Register1467_io_in_curr_PC), .io_in_jal(D_E_Register1467_io_in_jal), .io_in_jal_offset(D_E_Register1467_io_in_jal_offset), .io_out_csr_address(D_E_Register1467_io_out_csr_address), .io_out_is_csr(D_E_Register1467_io_out_is_csr), .io_out_csr_data(D_E_Register1467_io_out_csr_data), .io_out_csr_mask(D_E_Register1467_io_out_csr_mask), .io_out_rd(D_E_Register1467_io_out_rd), .io_out_rs1(D_E_Register1467_io_out_rs1), .io_out_rd1(D_E_Register1467_io_out_rd1), .io_out_rs2(D_E_Register1467_io_out_rs2), .io_out_rd2(D_E_Register1467_io_out_rd2), .io_out_alu_op(D_E_Register1467_io_out_alu_op), .io_out_wb(D_E_Register1467_io_out_wb), .io_out_rs2_src(D_E_Register1467_io_out_rs2_src), .io_out_itype_immed(D_E_Register1467_io_out_itype_immed), .io_out_mem_read(D_E_Register1467_io_out_mem_read), .io_out_mem_write(D_E_Register1467_io_out_mem_write), .io_out_branch_type(D_E_Register1467_io_out_branch_type), .io_out_upper_immed(D_E_Register1467_io_out_upper_immed), .io_out_curr_PC(D_E_Register1467_io_out_curr_PC), .io_out_jal(D_E_Register1467_io_out_jal), .io_out_jal_offset(D_E_Register1467_io_out_jal_offset), .io_out_PC_next(D_E_Register1467_io_out_PC_next));
  assign D_E_Register1467_io_in_rd = proxy1466;
  assign proxy1472 = proxy1118;
  assign D_E_Register1467_io_in_rs1 = proxy1472;
  assign proxy1475 = proxy1121;
  assign D_E_Register1467_io_in_rd1 = proxy1475;
  assign proxy1478 = proxy1124;
  assign D_E_Register1467_io_in_rs2 = proxy1478;
  assign proxy1481 = proxy1127;
  assign D_E_Register1467_io_in_rd2 = proxy1481;
  assign proxy1484 = proxy1133;
  assign D_E_Register1467_io_in_alu_op = proxy1484;
  assign proxy1487 = proxy1130;
  assign D_E_Register1467_io_in_wb = proxy1487;
  assign proxy1490 = proxy1136;
  assign D_E_Register1467_io_in_rs2_src = proxy1490;
  assign proxy1493 = proxy1139;
  assign D_E_Register1467_io_in_itype_immed = proxy1493;
  assign proxy1496 = proxy1142;
  assign D_E_Register1467_io_in_mem_read = proxy1496;
  assign proxy1499 = proxy1145;
  assign D_E_Register1467_io_in_mem_write = proxy1499;
  assign proxy1502 = proxy1163;
  assign D_E_Register1467_io_in_PC_next = proxy1502;
  assign proxy1505 = proxy1148;
  assign D_E_Register1467_io_in_branch_type = proxy1505;
  assign proxy1508 = proxy3136;
  assign D_E_Register1467_io_in_fwd_stall = proxy1508;
  assign proxy1511 = proxy1907;
  assign D_E_Register1467_io_in_branch_stall = proxy1511;
  assign proxy1514 = proxy1160;
  assign D_E_Register1467_io_in_upper_immed = proxy1514;
  assign proxy1517 = proxy1103;
  assign D_E_Register1467_io_in_csr_address = proxy1517;
  assign proxy1520 = proxy1106;
  assign D_E_Register1467_io_in_is_csr = proxy1520;
  assign proxy1523 = proxy1109;
  assign D_E_Register1467_io_in_csr_data = proxy1523;
  assign proxy1526 = proxy1112;
  assign D_E_Register1467_io_in_csr_mask = proxy1526;
  assign proxy1529 = proxy301;
  assign D_E_Register1467_io_in_curr_PC = proxy1529;
  assign proxy1532 = proxy1154;
  assign D_E_Register1467_io_in_jal = proxy1532;
  assign proxy1535 = proxy1157;
  assign D_E_Register1467_io_in_jal_offset = proxy1535;
  assign proxy1538 = D_E_Register1467_io_out_csr_address;
  assign proxy1541 = D_E_Register1467_io_out_is_csr;
  assign proxy1544 = D_E_Register1467_io_out_csr_data;
  assign proxy1547 = D_E_Register1467_io_out_csr_mask;
  assign proxy1550 = D_E_Register1467_io_out_rd;
  assign proxy1553 = D_E_Register1467_io_out_rs1;
  assign proxy1556 = D_E_Register1467_io_out_rd1;
  assign proxy1559 = D_E_Register1467_io_out_rs2;
  assign proxy1562 = D_E_Register1467_io_out_rd2;
  assign proxy1565 = D_E_Register1467_io_out_alu_op;
  assign proxy1568 = D_E_Register1467_io_out_wb;
  assign proxy1571 = D_E_Register1467_io_out_rs2_src;
  assign proxy1574 = D_E_Register1467_io_out_itype_immed;
  assign proxy1577 = D_E_Register1467_io_out_mem_read;
  assign proxy1580 = D_E_Register1467_io_out_mem_write;
  assign proxy1583 = D_E_Register1467_io_out_branch_type;
  assign proxy1586 = D_E_Register1467_io_out_upper_immed;
  assign proxy1589 = D_E_Register1467_io_out_curr_PC;
  assign proxy1592 = D_E_Register1467_io_out_jal;
  assign proxy1595 = D_E_Register1467_io_out_jal_offset;
  assign proxy1598 = D_E_Register1467_io_out_PC_next;
  assign proxy1798 = proxy1550;
  Execute Execute1799(.io_in_rd(Execute1799_io_in_rd), .io_in_rs1(Execute1799_io_in_rs1), .io_in_rd1(Execute1799_io_in_rd1), .io_in_rs2(Execute1799_io_in_rs2), .io_in_rd2(Execute1799_io_in_rd2), .io_in_alu_op(Execute1799_io_in_alu_op), .io_in_wb(Execute1799_io_in_wb), .io_in_rs2_src(Execute1799_io_in_rs2_src), .io_in_itype_immed(Execute1799_io_in_itype_immed), .io_in_mem_read(Execute1799_io_in_mem_read), .io_in_mem_write(Execute1799_io_in_mem_write), .io_in_PC_next(Execute1799_io_in_PC_next), .io_in_branch_type(Execute1799_io_in_branch_type), .io_in_upper_immed(Execute1799_io_in_upper_immed), .io_in_csr_address(Execute1799_io_in_csr_address), .io_in_is_csr(Execute1799_io_in_is_csr), .io_in_csr_data(Execute1799_io_in_csr_data), .io_in_csr_mask(Execute1799_io_in_csr_mask), .io_in_jal(Execute1799_io_in_jal), .io_in_jal_offset(Execute1799_io_in_jal_offset), .io_in_curr_PC(Execute1799_io_in_curr_PC), .io_out_csr_address(Execute1799_io_out_csr_address), .io_out_is_csr(Execute1799_io_out_is_csr), .io_out_csr_result(Execute1799_io_out_csr_result), .io_out_alu_result(Execute1799_io_out_alu_result), .io_out_rd(Execute1799_io_out_rd), .io_out_wb(Execute1799_io_out_wb), .io_out_rs1(Execute1799_io_out_rs1), .io_out_rd1(Execute1799_io_out_rd1), .io_out_rs2(Execute1799_io_out_rs2), .io_out_rd2(Execute1799_io_out_rd2), .io_out_mem_read(Execute1799_io_out_mem_read), .io_out_mem_write(Execute1799_io_out_mem_write), .io_out_jal(Execute1799_io_out_jal), .io_out_jal_dest(Execute1799_io_out_jal_dest), .io_out_branch_offset(Execute1799_io_out_branch_offset), .io_out_branch_stall(Execute1799_io_out_branch_stall), .io_out_PC_next(Execute1799_io_out_PC_next));
  assign Execute1799_io_in_rd = proxy1798;
  assign proxy1802 = proxy1553;
  assign Execute1799_io_in_rs1 = proxy1802;
  assign proxy1805 = proxy1556;
  assign Execute1799_io_in_rd1 = proxy1805;
  assign proxy1808 = proxy1559;
  assign Execute1799_io_in_rs2 = proxy1808;
  assign proxy1811 = proxy1562;
  assign Execute1799_io_in_rd2 = proxy1811;
  assign proxy1814 = proxy1565;
  assign Execute1799_io_in_alu_op = proxy1814;
  assign proxy1817 = proxy1568;
  assign Execute1799_io_in_wb = proxy1817;
  assign proxy1820 = proxy1571;
  assign Execute1799_io_in_rs2_src = proxy1820;
  assign proxy1823 = proxy1574;
  assign Execute1799_io_in_itype_immed = proxy1823;
  assign proxy1826 = proxy1577;
  assign Execute1799_io_in_mem_read = proxy1826;
  assign proxy1829 = proxy1580;
  assign Execute1799_io_in_mem_write = proxy1829;
  assign proxy1832 = proxy1598;
  assign Execute1799_io_in_PC_next = proxy1832;
  assign proxy1835 = proxy1583;
  assign Execute1799_io_in_branch_type = proxy1835;
  assign proxy1838 = proxy1586;
  assign Execute1799_io_in_upper_immed = proxy1838;
  assign proxy1841 = proxy1538;
  assign Execute1799_io_in_csr_address = proxy1841;
  assign proxy1844 = proxy1541;
  assign Execute1799_io_in_is_csr = proxy1844;
  assign proxy1847 = proxy1544;
  assign Execute1799_io_in_csr_data = proxy1847;
  assign proxy1850 = proxy1547;
  assign Execute1799_io_in_csr_mask = proxy1850;
  assign proxy1853 = proxy1592;
  assign Execute1799_io_in_jal = proxy1853;
  assign proxy1856 = proxy1595;
  assign Execute1799_io_in_jal_offset = proxy1856;
  assign proxy1859 = proxy1589;
  assign Execute1799_io_in_curr_PC = proxy1859;
  assign proxy1862 = Execute1799_io_out_csr_address;
  assign proxy1865 = Execute1799_io_out_is_csr;
  assign proxy1868 = Execute1799_io_out_csr_result;
  assign proxy1871 = Execute1799_io_out_alu_result;
  assign proxy1874 = Execute1799_io_out_rd;
  assign proxy1877 = Execute1799_io_out_wb;
  assign proxy1880 = Execute1799_io_out_rs1;
  assign proxy1883 = Execute1799_io_out_rd1;
  assign proxy1886 = Execute1799_io_out_rs2;
  assign proxy1889 = Execute1799_io_out_rd2;
  assign proxy1892 = Execute1799_io_out_mem_read;
  assign proxy1895 = Execute1799_io_out_mem_write;
  assign proxy1898 = Execute1799_io_out_jal;
  assign proxy1901 = Execute1799_io_out_jal_dest;
  assign proxy1904 = Execute1799_io_out_branch_offset;
  assign proxy1907 = Execute1799_io_out_branch_stall;
  assign proxy1910 = Execute1799_io_out_PC_next;
  assign proxy2082 = proxy1871;
  assign E_M_Register2083_clk = clk;
  assign E_M_Register2083_reset = reset;
  E_M_Register E_M_Register2083(.clk(E_M_Register2083_clk), .reset(E_M_Register2083_reset), .io_in_alu_result(E_M_Register2083_io_in_alu_result), .io_in_rd(E_M_Register2083_io_in_rd), .io_in_wb(E_M_Register2083_io_in_wb), .io_in_rs1(E_M_Register2083_io_in_rs1), .io_in_rd1(E_M_Register2083_io_in_rd1), .io_in_rs2(E_M_Register2083_io_in_rs2), .io_in_rd2(E_M_Register2083_io_in_rd2), .io_in_mem_read(E_M_Register2083_io_in_mem_read), .io_in_mem_write(E_M_Register2083_io_in_mem_write), .io_in_PC_next(E_M_Register2083_io_in_PC_next), .io_in_csr_address(E_M_Register2083_io_in_csr_address), .io_in_is_csr(E_M_Register2083_io_in_is_csr), .io_in_csr_result(E_M_Register2083_io_in_csr_result), .io_in_curr_PC(E_M_Register2083_io_in_curr_PC), .io_in_branch_offset(E_M_Register2083_io_in_branch_offset), .io_in_branch_type(E_M_Register2083_io_in_branch_type), .io_out_csr_address(E_M_Register2083_io_out_csr_address), .io_out_is_csr(E_M_Register2083_io_out_is_csr), .io_out_csr_result(E_M_Register2083_io_out_csr_result), .io_out_alu_result(E_M_Register2083_io_out_alu_result), .io_out_rd(E_M_Register2083_io_out_rd), .io_out_wb(E_M_Register2083_io_out_wb), .io_out_rs1(E_M_Register2083_io_out_rs1), .io_out_rd1(E_M_Register2083_io_out_rd1), .io_out_rd2(E_M_Register2083_io_out_rd2), .io_out_rs2(E_M_Register2083_io_out_rs2), .io_out_mem_read(E_M_Register2083_io_out_mem_read), .io_out_mem_write(E_M_Register2083_io_out_mem_write), .io_out_curr_PC(E_M_Register2083_io_out_curr_PC), .io_out_branch_offset(E_M_Register2083_io_out_branch_offset), .io_out_branch_type(E_M_Register2083_io_out_branch_type), .io_out_PC_next(E_M_Register2083_io_out_PC_next));
  assign E_M_Register2083_io_in_alu_result = proxy2082;
  assign proxy2088 = proxy1874;
  assign E_M_Register2083_io_in_rd = proxy2088;
  assign proxy2091 = proxy1877;
  assign E_M_Register2083_io_in_wb = proxy2091;
  assign proxy2094 = proxy1880;
  assign E_M_Register2083_io_in_rs1 = proxy2094;
  assign proxy2097 = proxy1883;
  assign E_M_Register2083_io_in_rd1 = proxy2097;
  assign proxy2100 = proxy1886;
  assign E_M_Register2083_io_in_rs2 = proxy2100;
  assign proxy2103 = proxy1889;
  assign E_M_Register2083_io_in_rd2 = proxy2103;
  assign proxy2106 = proxy1892;
  assign E_M_Register2083_io_in_mem_read = proxy2106;
  assign proxy2109 = proxy1895;
  assign E_M_Register2083_io_in_mem_write = proxy2109;
  assign proxy2112 = proxy1910;
  assign E_M_Register2083_io_in_PC_next = proxy2112;
  assign proxy2115 = proxy1862;
  assign E_M_Register2083_io_in_csr_address = proxy2115;
  assign proxy2118 = proxy1865;
  assign E_M_Register2083_io_in_is_csr = proxy2118;
  assign proxy2121 = proxy1868;
  assign E_M_Register2083_io_in_csr_result = proxy2121;
  assign proxy2124 = proxy1589;
  assign E_M_Register2083_io_in_curr_PC = proxy2124;
  assign proxy2127 = proxy1904;
  assign E_M_Register2083_io_in_branch_offset = proxy2127;
  assign proxy2130 = proxy1583;
  assign E_M_Register2083_io_in_branch_type = proxy2130;
  assign proxy2133 = E_M_Register2083_io_out_csr_address;
  assign proxy2136 = E_M_Register2083_io_out_is_csr;
  assign proxy2139 = E_M_Register2083_io_out_csr_result;
  assign proxy2142 = E_M_Register2083_io_out_alu_result;
  assign proxy2145 = E_M_Register2083_io_out_rd;
  assign proxy2148 = E_M_Register2083_io_out_wb;
  assign proxy2151 = E_M_Register2083_io_out_rs1;
  assign proxy2154 = E_M_Register2083_io_out_rd1;
  assign proxy2157 = E_M_Register2083_io_out_rd2;
  assign proxy2160 = E_M_Register2083_io_out_rs2;
  assign proxy2163 = E_M_Register2083_io_out_mem_read;
  assign proxy2166 = E_M_Register2083_io_out_mem_write;
  assign proxy2169 = E_M_Register2083_io_out_curr_PC;
  assign proxy2172 = E_M_Register2083_io_out_branch_offset;
  assign proxy2175 = E_M_Register2083_io_out_branch_type;
  assign proxy2178 = E_M_Register2083_io_out_PC_next;
  Memory Memory2513(.io_DBUS_in_data_data(Memory2513_io_DBUS_in_data_data), .io_DBUS_in_data_valid(Memory2513_io_DBUS_in_data_valid), .io_DBUS_out_data_ready(Memory2513_io_DBUS_out_data_ready), .io_DBUS_out_address_ready(Memory2513_io_DBUS_out_address_ready), .io_DBUS_out_control_ready(Memory2513_io_DBUS_out_control_ready), .io_in_alu_result(Memory2513_io_in_alu_result), .io_in_mem_read(Memory2513_io_in_mem_read), .io_in_mem_write(Memory2513_io_in_mem_write), .io_in_rd(Memory2513_io_in_rd), .io_in_wb(Memory2513_io_in_wb), .io_in_rs1(Memory2513_io_in_rs1), .io_in_rd1(Memory2513_io_in_rd1), .io_in_rs2(Memory2513_io_in_rs2), .io_in_rd2(Memory2513_io_in_rd2), .io_in_PC_next(Memory2513_io_in_PC_next), .io_in_curr_PC(Memory2513_io_in_curr_PC), .io_in_branch_offset(Memory2513_io_in_branch_offset), .io_in_branch_type(Memory2513_io_in_branch_type), .io_DBUS_in_data_ready(Memory2513_io_DBUS_in_data_ready), .io_DBUS_out_data_data(Memory2513_io_DBUS_out_data_data), .io_DBUS_out_data_valid(Memory2513_io_DBUS_out_data_valid), .io_DBUS_out_address_data(Memory2513_io_DBUS_out_address_data), .io_DBUS_out_address_valid(Memory2513_io_DBUS_out_address_valid), .io_DBUS_out_control_data(Memory2513_io_DBUS_out_control_data), .io_DBUS_out_control_valid(Memory2513_io_DBUS_out_control_valid), .io_out_alu_result(Memory2513_io_out_alu_result), .io_out_mem_result(Memory2513_io_out_mem_result), .io_out_rd(Memory2513_io_out_rd), .io_out_wb(Memory2513_io_out_wb), .io_out_rs1(Memory2513_io_out_rs1), .io_out_rs2(Memory2513_io_out_rs2), .io_out_branch_dir(Memory2513_io_out_branch_dir), .io_out_branch_dest(Memory2513_io_out_branch_dest), .io_out_PC_next(Memory2513_io_out_PC_next));
  assign Memory2513_io_DBUS_in_data_data = io_DBUS_in_data_data;
  assign Memory2513_io_DBUS_in_data_valid = io_DBUS_in_data_valid;
  assign proxy2519 = Memory2513_io_DBUS_in_data_ready;
  assign proxy2522 = Memory2513_io_DBUS_out_data_data;
  assign proxy2525 = Memory2513_io_DBUS_out_data_valid;
  assign Memory2513_io_DBUS_out_data_ready = io_DBUS_out_data_ready;
  assign proxy2531 = Memory2513_io_DBUS_out_address_data;
  assign proxy2534 = Memory2513_io_DBUS_out_address_valid;
  assign Memory2513_io_DBUS_out_address_ready = io_DBUS_out_address_ready;
  assign proxy2540 = Memory2513_io_DBUS_out_control_data;
  assign proxy2543 = Memory2513_io_DBUS_out_control_valid;
  assign Memory2513_io_DBUS_out_control_ready = io_DBUS_out_control_ready;
  assign proxy2549 = proxy2142;
  assign Memory2513_io_in_alu_result = proxy2549;
  assign proxy2552 = proxy2163;
  assign Memory2513_io_in_mem_read = proxy2552;
  assign proxy2555 = proxy2166;
  assign Memory2513_io_in_mem_write = proxy2555;
  assign proxy2558 = proxy2145;
  assign Memory2513_io_in_rd = proxy2558;
  assign proxy2561 = proxy2148;
  assign Memory2513_io_in_wb = proxy2561;
  assign proxy2564 = proxy2151;
  assign Memory2513_io_in_rs1 = proxy2564;
  assign proxy2567 = proxy2154;
  assign Memory2513_io_in_rd1 = proxy2567;
  assign proxy2570 = proxy2160;
  assign Memory2513_io_in_rs2 = proxy2570;
  assign proxy2573 = proxy2157;
  assign Memory2513_io_in_rd2 = proxy2573;
  assign proxy2576 = proxy2178;
  assign Memory2513_io_in_PC_next = proxy2576;
  assign proxy2579 = proxy2169;
  assign Memory2513_io_in_curr_PC = proxy2579;
  assign proxy2582 = proxy2172;
  assign Memory2513_io_in_branch_offset = proxy2582;
  assign proxy2585 = proxy2175;
  assign Memory2513_io_in_branch_type = proxy2585;
  assign proxy2588 = Memory2513_io_out_alu_result;
  assign proxy2591 = Memory2513_io_out_mem_result;
  assign proxy2594 = Memory2513_io_out_rd;
  assign proxy2597 = Memory2513_io_out_wb;
  assign proxy2600 = Memory2513_io_out_rs1;
  assign proxy2603 = Memory2513_io_out_rs2;
  assign proxy2606 = Memory2513_io_out_branch_dir;
  assign proxy2609 = Memory2513_io_out_branch_dest;
  assign proxy2612 = Memory2513_io_out_PC_next;
  assign proxy2691 = proxy2588;
  assign M_W_Register2692_clk = clk;
  assign M_W_Register2692_reset = reset;
  M_W_Register M_W_Register2692(.clk(M_W_Register2692_clk), .reset(M_W_Register2692_reset), .io_in_alu_result(M_W_Register2692_io_in_alu_result), .io_in_mem_result(M_W_Register2692_io_in_mem_result), .io_in_rd(M_W_Register2692_io_in_rd), .io_in_wb(M_W_Register2692_io_in_wb), .io_in_rs1(M_W_Register2692_io_in_rs1), .io_in_rs2(M_W_Register2692_io_in_rs2), .io_in_PC_next(M_W_Register2692_io_in_PC_next), .io_out_alu_result(M_W_Register2692_io_out_alu_result), .io_out_mem_result(M_W_Register2692_io_out_mem_result), .io_out_rd(M_W_Register2692_io_out_rd), .io_out_wb(M_W_Register2692_io_out_wb), .io_out_rs1(M_W_Register2692_io_out_rs1), .io_out_rs2(M_W_Register2692_io_out_rs2), .io_out_PC_next(M_W_Register2692_io_out_PC_next));
  assign M_W_Register2692_io_in_alu_result = proxy2691;
  assign proxy2697 = proxy2591;
  assign M_W_Register2692_io_in_mem_result = proxy2697;
  assign proxy2700 = proxy2594;
  assign M_W_Register2692_io_in_rd = proxy2700;
  assign proxy2703 = proxy2597;
  assign M_W_Register2692_io_in_wb = proxy2703;
  assign proxy2706 = proxy2600;
  assign M_W_Register2692_io_in_rs1 = proxy2706;
  assign proxy2709 = proxy2603;
  assign M_W_Register2692_io_in_rs2 = proxy2709;
  assign proxy2712 = proxy2612;
  assign M_W_Register2692_io_in_PC_next = proxy2712;
  assign proxy2715 = M_W_Register2692_io_out_alu_result;
  assign proxy2718 = M_W_Register2692_io_out_mem_result;
  assign proxy2721 = M_W_Register2692_io_out_rd;
  assign proxy2724 = M_W_Register2692_io_out_wb;
  assign proxy2727 = M_W_Register2692_io_out_rs1;
  assign proxy2730 = M_W_Register2692_io_out_rs2;
  assign proxy2733 = M_W_Register2692_io_out_PC_next;
  assign proxy2764 = proxy2715;
  Write_Back Write_Back2765(.io_in_alu_result(Write_Back2765_io_in_alu_result), .io_in_mem_result(Write_Back2765_io_in_mem_result), .io_in_rd(Write_Back2765_io_in_rd), .io_in_wb(Write_Back2765_io_in_wb), .io_in_rs1(Write_Back2765_io_in_rs1), .io_in_rs2(Write_Back2765_io_in_rs2), .io_in_PC_next(Write_Back2765_io_in_PC_next), .io_out_write_data(Write_Back2765_io_out_write_data), .io_out_rd(Write_Back2765_io_out_rd), .io_out_wb(Write_Back2765_io_out_wb));
  assign Write_Back2765_io_in_alu_result = proxy2764;
  assign proxy2768 = proxy2718;
  assign Write_Back2765_io_in_mem_result = proxy2768;
  assign proxy2771 = proxy2721;
  assign Write_Back2765_io_in_rd = proxy2771;
  assign proxy2774 = proxy2724;
  assign Write_Back2765_io_in_wb = proxy2774;
  assign proxy2777 = proxy2727;
  assign Write_Back2765_io_in_rs1 = proxy2777;
  assign proxy2780 = proxy2730;
  assign Write_Back2765_io_in_rs2 = proxy2780;
  assign proxy2783 = proxy2733;
  assign Write_Back2765_io_in_PC_next = proxy2783;
  assign proxy2786 = Write_Back2765_io_out_write_data;
  assign proxy2789 = Write_Back2765_io_out_rd;
  assign proxy2792 = Write_Back2765_io_out_wb;
  assign proxy3048 = proxy1118;
  Forwarding Forwarding3049(.io_in_decode_src1(Forwarding3049_io_in_decode_src1), .io_in_decode_src2(Forwarding3049_io_in_decode_src2), .io_in_decode_csr_address(Forwarding3049_io_in_decode_csr_address), .io_in_execute_dest(Forwarding3049_io_in_execute_dest), .io_in_execute_wb(Forwarding3049_io_in_execute_wb), .io_in_execute_alu_result(Forwarding3049_io_in_execute_alu_result), .io_in_execute_PC_next(Forwarding3049_io_in_execute_PC_next), .io_in_execute_is_csr(Forwarding3049_io_in_execute_is_csr), .io_in_execute_csr_address(Forwarding3049_io_in_execute_csr_address), .io_in_execute_csr_result(Forwarding3049_io_in_execute_csr_result), .io_in_memory_dest(Forwarding3049_io_in_memory_dest), .io_in_memory_wb(Forwarding3049_io_in_memory_wb), .io_in_memory_alu_result(Forwarding3049_io_in_memory_alu_result), .io_in_memory_mem_data(Forwarding3049_io_in_memory_mem_data), .io_in_memory_PC_next(Forwarding3049_io_in_memory_PC_next), .io_in_memory_is_csr(Forwarding3049_io_in_memory_is_csr), .io_in_memory_csr_address(Forwarding3049_io_in_memory_csr_address), .io_in_memory_csr_result(Forwarding3049_io_in_memory_csr_result), .io_in_writeback_dest(Forwarding3049_io_in_writeback_dest), .io_in_writeback_wb(Forwarding3049_io_in_writeback_wb), .io_in_writeback_alu_result(Forwarding3049_io_in_writeback_alu_result), .io_in_writeback_mem_data(Forwarding3049_io_in_writeback_mem_data), .io_in_writeback_PC_next(Forwarding3049_io_in_writeback_PC_next), .io_out_src1_fwd(Forwarding3049_io_out_src1_fwd), .io_out_src1_fwd_data(Forwarding3049_io_out_src1_fwd_data), .io_out_src2_fwd(Forwarding3049_io_out_src2_fwd), .io_out_src2_fwd_data(Forwarding3049_io_out_src2_fwd_data), .io_out_csr_fwd(Forwarding3049_io_out_csr_fwd), .io_out_csr_fwd_data(Forwarding3049_io_out_csr_fwd_data), .io_out_fwd_stall(Forwarding3049_io_out_fwd_stall));
  assign Forwarding3049_io_in_decode_src1 = proxy3048;
  assign proxy3052 = proxy1124;
  assign Forwarding3049_io_in_decode_src2 = proxy3052;
  assign proxy3055 = proxy1103;
  assign Forwarding3049_io_in_decode_csr_address = proxy3055;
  assign proxy3058 = proxy1874;
  assign Forwarding3049_io_in_execute_dest = proxy3058;
  assign proxy3061 = proxy1877;
  assign Forwarding3049_io_in_execute_wb = proxy3061;
  assign proxy3064 = proxy1871;
  assign Forwarding3049_io_in_execute_alu_result = proxy3064;
  assign proxy3067 = proxy1910;
  assign Forwarding3049_io_in_execute_PC_next = proxy3067;
  assign proxy3070 = proxy1865;
  assign Forwarding3049_io_in_execute_is_csr = proxy3070;
  assign proxy3073 = proxy1862;
  assign Forwarding3049_io_in_execute_csr_address = proxy3073;
  assign proxy3076 = proxy1868;
  assign Forwarding3049_io_in_execute_csr_result = proxy3076;
  assign proxy3079 = proxy2594;
  assign Forwarding3049_io_in_memory_dest = proxy3079;
  assign proxy3082 = proxy2597;
  assign Forwarding3049_io_in_memory_wb = proxy3082;
  assign proxy3085 = proxy2588;
  assign Forwarding3049_io_in_memory_alu_result = proxy3085;
  assign proxy3088 = proxy2591;
  assign Forwarding3049_io_in_memory_mem_data = proxy3088;
  assign proxy3091 = proxy2612;
  assign Forwarding3049_io_in_memory_PC_next = proxy3091;
  assign proxy3094 = proxy2136;
  assign Forwarding3049_io_in_memory_is_csr = proxy3094;
  assign proxy3097 = proxy2133;
  assign Forwarding3049_io_in_memory_csr_address = proxy3097;
  assign proxy3100 = proxy2139;
  assign Forwarding3049_io_in_memory_csr_result = proxy3100;
  assign proxy3103 = proxy2721;
  assign Forwarding3049_io_in_writeback_dest = proxy3103;
  assign proxy3106 = proxy2724;
  assign Forwarding3049_io_in_writeback_wb = proxy3106;
  assign proxy3109 = proxy2715;
  assign Forwarding3049_io_in_writeback_alu_result = proxy3109;
  assign proxy3112 = proxy2718;
  assign Forwarding3049_io_in_writeback_mem_data = proxy3112;
  assign proxy3115 = proxy2733;
  assign Forwarding3049_io_in_writeback_PC_next = proxy3115;
  assign proxy3118 = Forwarding3049_io_out_src1_fwd;
  assign proxy3121 = Forwarding3049_io_out_src1_fwd_data;
  assign proxy3124 = Forwarding3049_io_out_src2_fwd;
  assign proxy3127 = Forwarding3049_io_out_src2_fwd_data;
  assign proxy3130 = Forwarding3049_io_out_csr_fwd;
  assign proxy3133 = Forwarding3049_io_out_csr_fwd_data;
  assign proxy3136 = Forwarding3049_io_out_fwd_stall;
  Interrupt_Handler Interrupt_Handler3154(.io_INTERRUPT_in_interrupt_id_data(Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_data), .io_INTERRUPT_in_interrupt_id_valid(Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_valid), .io_INTERRUPT_in_interrupt_id_ready(Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_ready), .io_out_interrupt(Interrupt_Handler3154_io_out_interrupt), .io_out_interrupt_pc(Interrupt_Handler3154_io_out_interrupt_pc));
  assign Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_data = io_INTERRUPT_in_interrupt_id_data;
  assign Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_valid = io_INTERRUPT_in_interrupt_id_valid;
  assign proxy3160 = Interrupt_Handler3154_io_INTERRUPT_in_interrupt_id_ready;
  assign proxy3163 = Interrupt_Handler3154_io_out_interrupt;
  assign proxy3166 = Interrupt_Handler3154_io_out_interrupt_pc;
  assign JTAG3500_clk = clk;
  assign JTAG3500_reset = reset;
  JTAG JTAG3500(.clk(JTAG3500_clk), .reset(JTAG3500_reset), .io_JTAG_JTAG_TAP_in_mode_select_data(JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_data), .io_JTAG_JTAG_TAP_in_mode_select_valid(JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_valid), .io_JTAG_JTAG_TAP_in_clock_data(JTAG3500_io_JTAG_JTAG_TAP_in_clock_data), .io_JTAG_JTAG_TAP_in_clock_valid(JTAG3500_io_JTAG_JTAG_TAP_in_clock_valid), .io_JTAG_JTAG_TAP_in_reset_data(JTAG3500_io_JTAG_JTAG_TAP_in_reset_data), .io_JTAG_JTAG_TAP_in_reset_valid(JTAG3500_io_JTAG_JTAG_TAP_in_reset_valid), .io_JTAG_in_data_data(JTAG3500_io_JTAG_in_data_data), .io_JTAG_in_data_valid(JTAG3500_io_JTAG_in_data_valid), .io_JTAG_out_data_ready(JTAG3500_io_JTAG_out_data_ready), .io_JTAG_JTAG_TAP_in_mode_select_ready(JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_ready), .io_JTAG_JTAG_TAP_in_clock_ready(JTAG3500_io_JTAG_JTAG_TAP_in_clock_ready), .io_JTAG_JTAG_TAP_in_reset_ready(JTAG3500_io_JTAG_JTAG_TAP_in_reset_ready), .io_JTAG_in_data_ready(JTAG3500_io_JTAG_in_data_ready), .io_JTAG_out_data_data(JTAG3500_io_JTAG_out_data_data), .io_JTAG_out_data_valid(JTAG3500_io_JTAG_out_data_valid));
  assign JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_data = io_jtag_JTAG_TAP_in_mode_select_data;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_valid = io_jtag_JTAG_TAP_in_mode_select_valid;
  assign proxy3508 = JTAG3500_io_JTAG_JTAG_TAP_in_mode_select_ready;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_clock_data = io_jtag_JTAG_TAP_in_clock_data;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_clock_valid = io_jtag_JTAG_TAP_in_clock_valid;
  assign proxy3517 = JTAG3500_io_JTAG_JTAG_TAP_in_clock_ready;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_reset_data = io_jtag_JTAG_TAP_in_reset_data;
  assign JTAG3500_io_JTAG_JTAG_TAP_in_reset_valid = io_jtag_JTAG_TAP_in_reset_valid;
  assign proxy3526 = JTAG3500_io_JTAG_JTAG_TAP_in_reset_ready;
  assign JTAG3500_io_JTAG_in_data_data = io_jtag_in_data_data;
  assign JTAG3500_io_JTAG_in_data_valid = io_jtag_in_data_valid;
  assign proxy3535 = JTAG3500_io_JTAG_in_data_ready;
  assign proxy3538 = JTAG3500_io_JTAG_out_data_data;
  assign proxy3541 = JTAG3500_io_JTAG_out_data_valid;
  assign JTAG3500_io_JTAG_out_data_ready = io_jtag_out_data_ready;
  assign proxy3606 = proxy1103;
  assign CSR_Handler3607_clk = clk;
  assign CSR_Handler3607_reset = reset;
  CSR_Handler CSR_Handler3607(.clk(CSR_Handler3607_clk), .reset(CSR_Handler3607_reset), .io_in_decode_csr_address(CSR_Handler3607_io_in_decode_csr_address), .io_in_mem_csr_address(CSR_Handler3607_io_in_mem_csr_address), .io_in_mem_is_csr(CSR_Handler3607_io_in_mem_is_csr), .io_in_mem_csr_result(CSR_Handler3607_io_in_mem_csr_result), .io_out_decode_csr_data(CSR_Handler3607_io_out_decode_csr_data));
  assign CSR_Handler3607_io_in_decode_csr_address = proxy3606;
  assign proxy3612 = proxy2133;
  assign CSR_Handler3607_io_in_mem_csr_address = proxy3612;
  assign proxy3615 = proxy2136;
  assign CSR_Handler3607_io_in_mem_is_csr = proxy3615;
  assign proxy3618 = proxy2139;
  assign CSR_Handler3607_io_in_mem_csr_result = proxy3618;
  assign proxy3621 = CSR_Handler3607_io_out_decode_csr_data;
  assign proxy3623 = proxy1151;
  assign orl3624 = proxy3623 || proxy1907;
  assign proxy3625 = orl3624;
  assign proxy3628 = proxy1907;
  assign eq3629 = proxy3628 == 1'h1;
  assign proxy3632 = proxy3136;
  assign eq3633 = proxy3632 == 1'h1;
  assign orl3635 = eq3633 || eq3629;
  assign proxy3636 = orl3635;

  assign io_IBUS_in_data_ready = io_IBUS_in_data_ready4;
  assign io_IBUS_out_address_data = io_IBUS_out_address_data7;
  assign io_IBUS_out_address_valid = io_IBUS_out_address_valid10;
  assign io_DBUS_in_data_ready = io_DBUS_in_data_ready16;
  assign io_DBUS_out_data_data = io_DBUS_out_data_data19;
  assign io_DBUS_out_data_valid = io_DBUS_out_data_valid22;
  assign io_DBUS_out_address_data = io_DBUS_out_address_data26;
  assign io_DBUS_out_address_valid = io_DBUS_out_address_valid29;
  assign io_DBUS_out_control_data = io_DBUS_out_control_data33;
  assign io_DBUS_out_control_valid = io_DBUS_out_control_valid36;
  assign io_INTERRUPT_in_interrupt_id_ready = io_INTERRUPT_in_interrupt_id_ready42;
  assign io_jtag_JTAG_TAP_in_mode_select_ready = io_jtag_JTAG_TAP_in_mode_select_ready47;
  assign io_jtag_JTAG_TAP_in_clock_ready = io_jtag_JTAG_TAP_in_clock_ready52;
  assign io_jtag_JTAG_TAP_in_reset_ready = io_jtag_JTAG_TAP_in_reset_ready57;
  assign io_jtag_in_data_ready = io_jtag_in_data_ready62;
  assign io_jtag_out_data_data = io_jtag_out_data_data65;
  assign io_jtag_out_data_valid = io_jtag_out_data_valid68;
  assign io_out_fwd_stall = io_out_fwd_stall72;
  assign io_out_branch_stall = io_out_branch_stall75;

endmodule
