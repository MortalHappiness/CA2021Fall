module Control
(
    NoOp_i,
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
input               NoOp_i;
input   [6:0]       Op_i;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              Branch_o;

assign RegWrite_o = ~NoOp_i && ~(Op_i == CPU.OP_STORE || Op_i == CPU.OP_BRANCH);
assign MemtoReg_o = ~NoOp_i && ~(Op_i == CPU.OP_RTYPE || Op_i == CPU.OP_ITYPE);
assign MemRead_o = ~NoOp_i && (Op_i == CPU.OP_LOAD);
assign MemWrite_o = ~NoOp_i && (Op_i == CPU.OP_STORE);
assign ALUOp_o = 
    (NoOp_i) ? 2'b00 :
    (Op_i == CPU.OP_RTYPE) ? ALU_Control.ALUOp_RType :
    (Op_i == CPU.OP_ITYPE) ? ALU_Control.ALUOp_IType :
    (Op_i == CPU.OP_BRANCH) ? ALU_Control.ALUOp_Subtract :
    ALU_Control.ALUOp_Add;
assign ALUSrc_o = ~NoOp_i && ~(Op_i == CPU.OP_RTYPE || Op_i == CPU.OP_BRANCH);
assign Branch_o = ~NoOp_i && (Op_i == CPU.OP_BRANCH);

endmodule