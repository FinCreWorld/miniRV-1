module adder(
input   [1 :0]  op, // op[1] = 1 ��ʾ������op[0] = 1 ��ʾ�з��ż���
input   [31:0]  a,
input   [31:0]  b,
output  [31:0]  c,  // ������
output          lt  // �ȽϽ��
);

wire    [32:0]  a_ext;
wire    [32:0]  b_ext;
wire    [32:0]  c_ext;

assign a_ext = {op[0]&a[31], a};
assign b_ext = {op[0]&b[31], b};
assign c_ext = a_ext + (op[1] ? (~b_ext + 1) : b_ext);
assign c = c_ext[31:0];
assign lt = c_ext[32];

endmodule