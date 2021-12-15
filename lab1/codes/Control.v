module Control
(
    Op_i, 
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Branch_o
);

// Ports
input   [6:0]       Op_i;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              Branch_o;

assign RegWrite_o = (Op_i == CPU.OP_STORE || Op_i == CPU.OP_BRANCH) ? 0 : 1;
assign MemtoReg_o = (Op_i == CPU.OP_RTYPE || Op_i == CPU.OP_ITYPE) ? 0 : 1;
assign MemRead_o = (Op_i == CPU.OP_LOAD) ? 1 : 0;
assign MemWrite_o = (Op_i == CPU.OP_STORE) ? 1 : 0;
assign ALUOp_o = 
    (Op_i == CPU.OP_RTYPE) ? ALU_Control.ALUOp_RType :
    (Op_i == CPU.OP_ITYPE) ? ALU_Control.ALUOp_IType :
    (Op_i == CPU.OP_BRANCH) ? ALU_Control.ALUOp_Subtract :
    ALU_Control.ALUOp_Add;
assign ALUSrc_o = (Op_i == CPU.OP_RTYPE || Op_i == CPU.OP_BRANCH) ? 0 : 1;
assign Branch_o = (Op_i == CPU.OP_BRANCH) ? 1 : 0;

endmodule