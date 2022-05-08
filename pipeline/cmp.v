module cmp(
input   wire            cmp_sign_i,
input   wire    [31:0]  a_i,
input   wire    [31:0]  b_i,
output  wire    [1:0]   cmp_o   // cmp[1] �洢�Ƿ�С��,cmp[0] �洢�Ƿ����
);

wire    [32:0]  a_ext;
wire    [32:0]  b_ext;
wire    [32:0]  c_ext;

assign a_ext = {cmp_sign_i&a_i[31], a_i};
assign b_ext = {cmp_sign_i&b_i[31], b_i};
assign c_ext = a_ext - b_ext;
assign cmp_o[0] = ~|c_ext;
assign cmp_o[1] = c_ext[32];

endmodule
