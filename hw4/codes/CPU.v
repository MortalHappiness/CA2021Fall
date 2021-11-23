module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// Data Types
wire    [31:0]      pc_i;
wire    [31:0]      pc_o;
wire    [31:0]      instruction;
wire    [1:0]       ALUOp;
wire                ALUSrc;
wire                RegWrite;
wire    [6:0]       funct7;
wire    [2:0]       funct3;
wire    [6:0]       opcode;
wire    [4:0]       RS1addr;
wire    [4:0]       RS2addr;
wire    [4:0]       RDaddr;
wire    [31:0]      RS1data;
wire    [31:0]      RS2data;
wire    [31:0]      RDdata;
wire    [31:0]      SignExtend_o;
wire    [31:0]      Mux_o;
wire    [2:0]       ALUCtrl;

assign funct7 = instruction[31:25];
assign RS2addr = instruction[24:20];
assign RS1addr = instruction[19:15];
assign funct3 = instruction[14:12];
assign RDaddr = instruction[11:7];
assign opcode = instruction[6:0];

Control Control(
    .Op_i       (opcode),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite)
);

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (4),
    .data_o     (pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_i),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instruction)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (RS1addr),
    .RS2addr_i   (RS2addr),
    .RDaddr_i   (RDaddr), 
    .RDdata_i   (RDdata),
    .RegWrite_i (RegWrite), 
    .RS1data_o   (RS1data), 
    .RS2data_o   (RS2data) 
);

MUX32 MUX_ALUSrc(
    .data1_i    (RS2data),
    .data2_i    (SignExtend_o),
    .select_i   (ALUSrc),
    .data_o     (Mux_o)
);

Sign_Extend Sign_Extend(
    .data_i     (instruction[31:20]),
    .data_o     (SignExtend_o)
);
  
ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (Mux_o),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (RDdata),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({funct7, funct3}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

endmodule

