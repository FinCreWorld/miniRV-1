module top(
    input           clk,
    input           rst_n,
    output          debug_wb_have_inst,   // WB�׶��Ƿ���ָ�� (�Ե�����CPU����flag��Ϊ1)
    output  [31:0]  debug_wb_pc,          // WB�׶ε�PC (��wb_have_inst=0�������Ϊ����ֵ)
    output          debug_wb_ena,         // WB�׶εļĴ���дʹ�� (��wb_have_inst=0�������Ϊ����ֵ)
    output  [4:0]   debug_wb_reg,         // WB�׶�д��ļĴ����� (��wb_ena��wb_have_inst=0�������Ϊ����ֵ)
    output  [31:0]  debug_wb_value        // WB�׶�д��Ĵ�����ֵ (��wb_ena��wb_have_inst=0�������Ϊ����ֵ)
);

/*
 *  �����ź�
 */
 
// ȡָ��Ԫ
wire    [1:0]   npc_op; // ѡ�� npc ��һ��ָ��ĸ�ʽ
// ��ָ��Ԫ
wire            rf_we;  // �Ƿ��� rf д��
wire    [2:0]   sext_op;// sext ����������չ��ģʽ
wire    [2:0]   wd_sel; // mux_5_1 ѡ��
wire            alub_sel;// ѡ�� alu B �˿ڵ�����
// ִ�е�Ԫ
wire            lt;     // С���ź�
wire            eq;     // �����ź�
wire    [5:0]   alu_op; // ѡ�� alu ���㷽ʽ
// �洢��Ԫ
wire            dram_we;// �����Ƿ��� dmem д��
wire    [1:0]   mask_op;// ���� dmem ����������ݸ�ʽ
wire            sign;   // �����Ƿ�� dmem �ж����޷�����

/*
 *  �����ź�
 */
 
// ȡָ��Ԫ
wire    [31:0]  pc4_w;  // pc + 4
wire    [31:0]  pcimm_w;// pc + imm
wire    [31:0]  inst_w; // inst
// ��ָ��Ԫ
wire    [31:0]  rD1_w;  // rf ��һ�����
wire    [31:0]  rD2_w;  // rf �ڶ������
wire    [31:0]  ext_w;  // sext ��չ���������
// ִ�е�Ԫ
wire    [31:0]  alu_c_w;// alu c
wire    [31:0]  rd_w;   // dmem �Ķ�������     


assign  debug_wb_have_inst = 1'b1;
assign  debug_wb_pc = pc4_w - 32'd4;
assign  debug_wb_ena = rf_we;
assign  debug_wb_reg = inst_w[11:7];


ifetch top_ifetch(
    .clk_i  (clk),
    .rst_i  (~rst_n),
    .npc_op (npc_op),
    .ra_i   (rD1_w),
    .imm_i  (ext_w),
    .pc4_o  (pc4_w),
    .inst_o (inst_w),
    .pcimm_o(pcimm_w)
);

idecode top_idecode(
    .clk_i      (clk),
    .rst_i      (~rst_n),
    .rf_we_i    (rf_we),
    .sext_op_i  (sext_op),
    .wd_sel_i   (wd_sel),
    .inst_i     (inst_w),
    .pc4_i      (pc4_w),
    .alu_c_i    (alu_c_w),
    .dram_rd_i  (rd_w),
    .pcimm_i    (pcimm_w),
    .ext_o      (ext_w),
    .rD1_o      (rD1_w),
    .rD2_o      (rD2_w),
    .debug_wb_value(debug_wb_value)
);

dmem top_dmem(
    .rst_i(~rst_n),
    .clk_i(clk),
    .dram_we_i(dram_we),
    .sign_i(sign),
    .mask_op_i(mask_op),
    .addr_i(alu_c_w),
    .data_i(rD2_w),
    .rd_o(rd_w)
);

execute top_execute(
    .rst_i      (~rst_n),
    .alub_sel_i (alub_sel),
    .alu_op_i   (alu_op),
    .A_i        (rD1_w),
    .rD2_i      (rD2_w),
    .ext_i      (ext_w),
    .C_o        (alu_c_w),
    .eq_o       (eq),
    .lt_o       (lt)
);

control top_control(
    .rst_i(~rst_n),
    .inst_i(inst_w),
    .lt_i(lt),
    .eq_i(eq),
    .npc_op_o(npc_op),
    .rf_we_o(rf_we),
    .sext_op_o(sext_op),
    .wd_sel_o(wd_sel),
    .alub_sel_o(alub_sel),
    .alu_op_o(alu_op),
    .dram_we_o(dram_we),
    .mask_op_o(mask_op),
    .sign_o(sign)
 );
endmodule
