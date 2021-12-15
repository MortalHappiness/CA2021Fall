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

// ========================================

// PC
wire    [31:0]      pc_i;
wire    [31:0]      pc_o;

// Instruction
wire    [31:0]      instruction;
wire    [6:0]       funct7;
wire    [2:0]       funct3;
wire    [6:0]       opcode;
wire    [4:0]       RS1addr;
wire    [4:0]       RS2addr;
wire    [4:0]       RDaddr;

// Register file
wire    [31:0]      RS1data;
wire    [31:0]      RS2data;
wire    [31:0]      RDdata;

// Sign Extend
wire    [31:0]      SignExtend_o;

// Mux (One of ALU input)
wire    [31:0]      ALUInput2;

// ALU Control
wire    [2:0]       ALUCtrl;

// ALU
wire    [31:0]      ALUResult;

// Data Memory
wire    [31:0]      MemData_o;

// Control signals
wire                RegWrite;
wire                MemtoReg;
wire                MemRead;
wire                MemWrite;
wire    [1:0]       ALUOp;
wire                ALUSrc;

// Flush
wire                Flush;
assign Flush = 0;

// ========================================

// Instruction wire assignments
assign funct7 = instruction[31:25];
assign RS2addr = instruction[24:20];
assign RS1addr = instruction[19:15];
assign funct3 = instruction[14:12];
assign RDaddr = instruction[11:7];
assign opcode = instruction[6:0];

// ========================================
// Parameters

parameter OP_RTYPE = 7'b0110011;
parameter OP_ITYPE = 7'b0010011;
parameter OP_LOAD = 7'b0000011;
parameter OP_STORE = 7'b0100011;
parameter OP_BRANCH = 7'b1100011;

// ========================================

Control Control(
    .Op_i       (opcode),
    .RegWrite_o (RegWrite),
    .MemtoReg_o (MemtoReg),
    .MemRead_o  (MemRead),
    .MemWrite_o (MemWrite),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .Branch_o   ()
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
    .PCWrite_i  (1'b1),
    .pc_i       (pc_i),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instruction)
);

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .addr_i     (ALUResult),
    .MemRead_i  (MemRead),
    .MemWrite_i (MemWrite),
    .data_i     (RS2data),
    .data_o     (MemData_o)
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

MUX32 MUX_ALUInput(
    .data1_i    (RS2data),
    .data2_i    (SignExtend_o),
    .select_i   (ALUSrc),
    .data_o     (ALUInput2)
);

MUX32 MUX_RDdata(
    .data1_i    (ALUResult),
    .data2_i    (MemData_o),
    .select_i   (MemtoReg),
    .data_o     (RDdata)
);

Sign_Extend Sign_Extend(
    .data_i     (instruction),
    .data_o     (SignExtend_o)
);
  
ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (ALUInput2),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALUResult),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({funct7, funct3}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

Hazard_Detection Hazard_Detection(
    .Stall_o    ()
);

endmodule
