module Sign_Extend
(
    data_i, 
    data_o
);

// Ports
input   [31:0]      data_i;
output  [31:0]      data_o;

wire    [6:0]       funct7;
wire    [2:0]       funct3;
wire    [6:0]       opcode;
wire    [4:0]       RS1addr;
wire    [4:0]       RS2addr;
wire    [4:0]       RDaddr;

assign funct7 = data_i[31:25];
assign RS2addr = data_i[24:20];
assign RS1addr = data_i[19:15];
assign funct3 = data_i[14:12];
assign RDaddr = data_i[11:7];
assign opcode = data_i[6:0];

assign data_o =
    (opcode == CPU.OP_STORE) ? {{20{funct7[6]}}, funct7, RDaddr}:
    (opcode == CPU.OP_BRANCH) ? {{20{funct7[6]}}, RDaddr[0], funct7[5:0], RDaddr[4:1], 1'b0}:
    {{20{funct7[6]}}, funct7, RS2addr};

endmodule