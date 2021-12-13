module ALU
(
    data1_i, 
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

// Ports
input   signed[31:0]      data1_i;
input   signed[31:0]      data2_i;
input   [2:0]             ALUCtrl_i;
output  signed[31:0]      data_o;
output                    Zero_o;

parameter ALU_AND = 3'd1;
parameter ALU_XOR = 3'd2;
parameter ALU_SLL = 3'd3;
parameter ALU_ADD = 3'd4;
parameter ALU_SUB = 3'd5;
parameter ALU_MUL = 3'd6;
parameter ALU_SRA = 3'd7;

assign data_o = 
    (ALUCtrl_i == ALU_AND) ? (data1_i & data2_i) :
    (ALUCtrl_i == ALU_XOR) ? (data1_i ^ data2_i) :
    (ALUCtrl_i == ALU_SLL) ? (data1_i << data2_i) :
    (ALUCtrl_i == ALU_ADD) ? (data1_i + data2_i) :
    (ALUCtrl_i == ALU_SUB) ? (data1_i - data2_i) :
    (ALUCtrl_i == ALU_MUL) ? (data1_i * data2_i) :
    (ALUCtrl_i == ALU_SRA) ? (data1_i >>> data2_i[4:0]) :
    0; // Default case
assign Zero_o = (ALUCtrl_i == ALU_SUB && data1_i == data2_i) ? 1 : 0;

endmodule