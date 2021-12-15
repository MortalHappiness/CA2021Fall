module IF_ID_Registers
(
    clk_i,
    rst_i,
    instruction_i,
    instruction_o
);

input                   clk_i;
input                   rst_i;
input       [31:0]      instruction_i;
output reg  [31:0]      instruction_o;

always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        instruction_o <= 32'b0;
    end
    else begin
        instruction_o <= instruction_i;
    end
end

endmodule

module ID_EX_Registers
(
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    immediate_i,
    funct_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    immediate_o,
    funct_o,
    RDaddr_o
);

input                   clk_i;
input                   rst_i;
input                   RegWrite_i;
input                   MemtoReg_i;
input                   MemRead_i;
input                   MemWrite_i;
input       [1:0]       ALUOp_i;
input                   ALUSrc_i;
input       [31:0]      RS1data_i;
input       [31:0]      RS2data_i;
input       [31:0]      immediate_i;
input       [9:0]       funct_i;
input       [4:0]       RDaddr_i;
output reg              RegWrite_o;
output reg              MemtoReg_o;
output reg              MemRead_o;
output reg              MemWrite_o;
output reg  [1:0]       ALUOp_o;
output reg              ALUSrc_o;
output reg  [31:0]      RS1data_o;
output reg  [31:0]      RS2data_o;
output reg  [31:0]      immediate_o;
output reg  [9:0]       funct_o;
output reg  [4:0]       RDaddr_o;

always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALUOp_o <= 2'b0;
        ALUSrc_o <= 1'b0;
        RS1data_o <= 32'b0;
        RS2data_o <= 32'b0;
        immediate_o <= 32'b0;
        funct_o <= 10'b0;
        RDaddr_o <= 5'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        immediate_o <= immediate_i;
        funct_o <= funct_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule


module EX_MEM_Registers
(
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUResult_i,
    RS2data_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUResult_o,
    RS2data_o,
    RDaddr_o
);

input                   clk_i;
input                   rst_i;
input                   RegWrite_i;
input                   MemtoReg_i;
input                   MemRead_i;
input                   MemWrite_i;
input       [31:0]      ALUResult_i;
input       [31:0]      RS2data_i;
input       [4:0]       RDaddr_i;
output reg              RegWrite_o;
output reg              MemtoReg_o;
output reg              MemRead_o;
output reg              MemWrite_o;
output reg  [31:0]      ALUResult_o;
output reg  [31:0]      RS2data_o;
output reg  [4:0]       RDaddr_o;

always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALUResult_o <= 32'b0;
        RS2data_o <= 32'b0;
        RDaddr_o <= 5'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUResult_o <= ALUResult_i;
        RS2data_o <= RS2data_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule

module MEM_WB_Registers
(
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    MemData_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    ALUResult_o,
    MemData_o,
    RDaddr_o
);

input                   clk_i;
input                   rst_i;
input                   RegWrite_i;
input                   MemtoReg_i;
input       [31:0]      ALUResult_i;
input       [31:0]      MemData_i;
input       [4:0]       RDaddr_i;
output reg              RegWrite_o;
output reg              MemtoReg_o;
output reg  [31:0]      ALUResult_o;
output reg  [31:0]      MemData_o;
output reg  [4:0]       RDaddr_o;

always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        ALUResult_o <= 32'b0;
        MemData_o <= 32'b0;
        RDaddr_o <= 5'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALUResult_o <= ALUResult_i;
        MemData_o <= MemData_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule
