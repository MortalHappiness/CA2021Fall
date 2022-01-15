module ALU_Control
(
    funct_i, 
    ALUOp_i,
    ALUCtrl_o
);

// Ports
input   [9:0]       funct_i;
input   [1:0]       ALUOp_i;
output  [2:0]       ALUCtrl_o;

wire    [6:0]       funct7;
wire    [2:0]       funct3;

parameter ALUOp_Add = 2'b00;
parameter ALUOp_Subtract = 2'b01;
parameter ALUOp_RType = 2'b10;
parameter ALUOp_IType = 2'b11;

assign {funct7, funct3} = funct_i;

assign ALUCtrl_o = 
    (ALUOp_i == ALUOp_Add) ? ALU.ALU_ADD :
    (ALUOp_i == ALUOp_Subtract) ? ALU.ALU_SUB :
    (ALUOp_i == ALUOp_RType && funct7 == 7'b0000000 && funct3 == 3'b111) ? ALU.ALU_AND :
    (ALUOp_i == ALUOp_RType && funct7 == 7'b0000000 && funct3 == 3'b100) ? ALU.ALU_XOR :
    (ALUOp_i == ALUOp_RType && funct7 == 7'b0000000 && funct3 == 3'b001) ? ALU.ALU_SLL :
    (ALUOp_i == ALUOp_RType && funct7 == 7'b0000000 && funct3 == 3'b000) ? ALU.ALU_ADD :
    (ALUOp_i == ALUOp_RType && funct7 == 7'b0100000 && funct3 == 3'b000) ? ALU.ALU_SUB :
    (ALUOp_i == ALUOp_RType && funct7 == 7'b0000001 && funct3 == 3'b000) ? ALU.ALU_MUL :
    (ALUOp_i == ALUOp_IType && funct3 == 3'b000) ? ALU.ALU_ADD :
    (ALUOp_i == ALUOp_IType && funct7 == 7'b0100000 && funct3 == 3'b101) ? ALU.ALU_SRA :
    0; // Default case

endmodule