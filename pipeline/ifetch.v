module ifetch(
input   wire            clk_i,
input   wire            rst_n_i,
input   wire            keep_pc_i,  // ���� pc ֵ�������ı�
input   wire    [31:0]  immra_i,     // pc + ra
input   wire    [31:0]  pcimm_i,    // pc + imm
input   wire    [1:0]   jump_i,     // ��ת�����ź�
output  wire    [31:0]  inst_o,     // ָ��
output  reg     [31:0]  pc_o        // pc ֵ
);

wire    [31:0]  mux2in;
wire    [31:0]  pc2a;

assign  mux2in = jump_i[1] ? immra_i : (jump_i[0] ? pcimm_i : pc2a + 32'd4);


always@(*) pc_o = pc2a;

pc  ifetch_pc(
.clk_i(clk_i),
.rst_n_i(rst_n_i),
.keep_pc_i(keep_pc_i),
.in(mux2in),
.pc_o(pc2a)
);

inst_mem ifetch_dm(
.a(pc2a[15:2]),
.spo(inst_o)
);

endmodule