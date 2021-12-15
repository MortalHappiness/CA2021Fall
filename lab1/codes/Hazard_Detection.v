module Hazard_Detection
(
    ID_RS1addr_i,
    ID_RS2addr_i,
    EX_MemRead_i,
    EX_RDaddr_i,
    PCWrite_o,
    Stall_o,
    NoOp_o
);

input   [4:0]       ID_RS1addr_i;
input   [4:0]       ID_RS2addr_i;
input               EX_MemRead_i;
input   [4:0]       EX_RDaddr_i;
output              PCWrite_o;
output              Stall_o;
output              NoOp_o;

assign Stall_o = (EX_MemRead_i &&
    ((EX_RDaddr_i == ID_RS1addr_i) ||
    (EX_RDaddr_i == ID_RS2addr_i)));
assign PCWrite_o = ~Stall_o;
assign NoOp_o = Stall_o;

endmodule
