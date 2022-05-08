module execute(
    input   wire            rst_i,      // ��λ�ź�
    input   wire            alub_sel_i,   // ѡ�� ALU B �˿ڵ�����
    input   wire    [5:0]   alu_op_i,     // ѡ�� ALU ������ģʽ������� ALU
    input   wire    [31:0]  A_i,          // ALU A �˿�����
    input   wire    [31:0]  rD2_i,        // �Ĵ����� rD2 �����
    input   wire    [31:0]  ext_i,        // ����������չ�ź�
    output  wire    [31:0]  C_o,          // ALU C �˿����
    output  wire            eq_o,         // ALU ������������ȣ�ǰ��Ϊ���� A-B��
    output  wire            lt_o          // ALU ������˿� A < B��ǰ��Ϊ���� A-B��
    );
    
alu execute_alu (
    .rst_i      (rst_i),
    .alu_op_i   (alu_op_i),
    .A_i        (A_i),
    .B_i        (alub_sel_i ? ext_i : rD2_i),
    .C_o        (C_o),
    .eq_o       (eq_o),
    .lt_o       (lt_o)
);
    
endmodule
