module Control
(
    Op_i, 
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    Branch_o
);

// Ports
input   [6:0]       Op_i;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;
output              Branch_o;

assign ALUOp_o = (Op_i[5] == 1) ? 2'b10 : 2'b11;
assign ALUSrc_o = ~Op_i[5];
assign RegWrite_o = 1;
assign Branch_o = 0;

endmodule