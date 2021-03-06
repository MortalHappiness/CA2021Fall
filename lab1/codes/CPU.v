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
wire    [31:0]      IF_pc_o;
wire    [31:0]      ID_pc_o;

// Instruction
wire    [31:0]      IF_instruction;
wire    [31:0]      ID_instruction;
wire    [6:0]       ID_funct7;
wire    [2:0]       ID_funct3;
wire    [6:0]       ID_opcode;
wire    [4:0]       ID_RS1addr;
wire    [4:0]       ID_RS2addr;
wire    [4:0]       ID_RDaddr;
wire    [9:0]       ID_funct;
wire    [9:0]       EX_funct;
wire    [4:0]       EX_RS1addr;
wire    [4:0]       EX_RS2addr;
wire    [4:0]       EX_RDaddr;
wire    [4:0]       MEM_RDaddr;
wire    [4:0]       WB_RDaddr;

// Control signals
wire                ID_RegWrite;
wire                ID_MemtoReg;
wire                ID_MemRead;
wire                ID_MemWrite;
wire    [1:0]       ID_ALUOp;
wire                ID_ALUSrc;
wire                EX_RegWrite;
wire                EX_MemtoReg;
wire                EX_MemRead;
wire                EX_MemWrite;
wire    [1:0]       EX_ALUOp;
wire                EX_ALUSrc;
wire                MEM_RegWrite;
wire                MEM_MemtoReg;
wire                MEM_MemRead;
wire                MEM_MemWrite;
wire                WB_RegWrite;
wire                WB_MemtoReg;
wire                Branch;

// Register file
wire    [31:0]      ID_RS1data;
wire    [31:0]      ID_RS2data;
wire    [31:0]      EX_RS1data;
wire    [31:0]      EX_RS2data;
wire    [31:0]      MEM_RS2data;
wire    [31:0]      RDdata;

// Sign Extend
wire    [31:0]      ID_immediate;
wire    [31:0]      EX_immediate;

// ALU Input
wire    [31:0]      ALUInput1;
wire    [31:0]      ALUInput2;
wire    [31:0]      ALUInput_MUX_4_2_connect;

// ALU Control
wire    [2:0]       ALUCtrl;

// ALU
wire    [31:0]      EX_ALUResult;
wire    [31:0]      MEM_ALUResult;
wire    [31:0]      WB_ALUResult;

// Data Memory
wire    [31:0]      MEM_MemData;
wire    [31:0]      WB_MemData;

// Forwarding Unit
wire    [1:0]       ForwardA;
wire    [1:0]       ForwardB;

// Branch and Hazard Detection
wire                Flush;
wire    [31:0]      Branch_addr;
wire    [31:0]      pc_add_4;
wire                PCWrite;
wire                Stall;
wire                NoOp;

// ========================================
// Flush
assign Flush = (Branch && ID_RS1data == ID_RS2data);

// Instruction wire assignments
assign ID_funct7 = ID_instruction[31:25];
assign ID_RS2addr = ID_instruction[24:20];
assign ID_RS1addr = ID_instruction[19:15];
assign ID_funct3 = ID_instruction[14:12];
assign ID_RDaddr = ID_instruction[11:7];
assign ID_opcode = ID_instruction[6:0];
assign ID_funct = {ID_funct7, ID_funct3};

// ========================================
// Parameters

parameter OP_RTYPE = 7'b0110011;
parameter OP_ITYPE = 7'b0010011;
parameter OP_LOAD = 7'b0000011;
parameter OP_STORE = 7'b0100011;
parameter OP_BRANCH = 7'b1100011;

// ========================================
// Pipeline registers

IF_ID_Registers IF_ID_Registers(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .Stall_i        (Stall),
    .Flush_i        (Flush),
    .pc_o_i         (IF_pc_o),
    .instruction_i  (IF_instruction),
    .pc_o_o         (ID_pc_o),
    .instruction_o  (ID_instruction)
);

ID_EX_Registers ID_EX_Registers (
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (ID_RegWrite),
    .MemtoReg_i     (ID_MemtoReg),
    .MemRead_i      (ID_MemRead),
    .MemWrite_i     (ID_MemWrite),
    .ALUOp_i        (ID_ALUOp),
    .ALUSrc_i       (ID_ALUSrc),
    .RS1data_i      (ID_RS1data),
    .RS2data_i      (ID_RS2data),
    .immediate_i    (ID_immediate),
    .funct_i        (ID_funct),
    .RS1addr_i      (ID_RS1addr),
    .RS2addr_i      (ID_RS2addr),
    .RDaddr_i       (ID_RDaddr),
    .RegWrite_o     (EX_RegWrite),
    .MemtoReg_o     (EX_MemtoReg),
    .MemRead_o      (EX_MemRead),
    .MemWrite_o     (EX_MemWrite),
    .ALUOp_o        (EX_ALUOp),
    .ALUSrc_o       (EX_ALUSrc),
    .RS1data_o      (EX_RS1data),
    .RS2data_o      (EX_RS2data),
    .immediate_o    (EX_immediate),
    .funct_o        (EX_funct),
    .RS1addr_o      (EX_RS1addr),
    .RS2addr_o      (EX_RS2addr),
    .RDaddr_o       (EX_RDaddr)
);

EX_MEM_Registers EX_MEM_Registers (
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (EX_RegWrite),
    .MemtoReg_i     (EX_MemtoReg),
    .MemRead_i      (EX_MemRead),
    .MemWrite_i     (EX_MemWrite),
    .ALUResult_i    (EX_ALUResult),
    .RS2data_i      (ALUInput_MUX_4_2_connect),
    .RDaddr_i       (EX_RDaddr),
    .RegWrite_o     (MEM_RegWrite),
    .MemtoReg_o     (MEM_MemtoReg),
    .MemRead_o      (MEM_MemRead),
    .MemWrite_o     (MEM_MemWrite),
    .ALUResult_o    (MEM_ALUResult),
    .RS2data_o      (MEM_RS2data),
    .RDaddr_o       (MEM_RDaddr)
);

MEM_WB_Registers MEM_WB_Registers (
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (MEM_RegWrite),
    .MemtoReg_i     (MEM_MemtoReg),
    .ALUResult_i    (MEM_ALUResult),
    .MemData_i      (MEM_MemData),
    .RDaddr_i       (MEM_RDaddr),
    .RegWrite_o     (WB_RegWrite),
    .MemtoReg_o     (WB_MemtoReg),
    .ALUResult_o    (WB_ALUResult),
    .MemData_o      (WB_MemData),
    .RDaddr_o       (WB_RDaddr)
);

// ========================================
// IF stage components

MUX2 MUX2_pc_i(
    .data1_i    (pc_add_4),
    .data2_i    (Branch_addr),
    .select_i   (Flush),
    .data_o     (pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (pc_i),
    .pc_o       (IF_pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (IF_pc_o), 
    .instr_o    (IF_instruction)
);

Adder Add_PC(
    .data1_i   (IF_pc_o),
    .data2_i   (4),
    .data_o     (pc_add_4)
);

// ========================================
// ID stage components

Control Control(
    .NoOp_i     (NoOp),
    .Op_i       (ID_opcode),
    .RegWrite_o (ID_RegWrite),
    .MemtoReg_o (ID_MemtoReg),
    .MemRead_o  (ID_MemRead),
    .MemWrite_o (ID_MemWrite),
    .ALUOp_o    (ID_ALUOp),
    .ALUSrc_o   (ID_ALUSrc),
    .Branch_o   (Branch)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (ID_RS1addr),
    .RS2addr_i   (ID_RS2addr),
    .RDaddr_i   (WB_RDaddr), 
    .RDdata_i   (RDdata),
    .RegWrite_i (WB_RegWrite), 
    .RS1data_o   (ID_RS1data), 
    .RS2data_o   (ID_RS2data) 
);

Sign_Extend Imm_Gen(
    .data_i     (ID_instruction),
    .data_o     (ID_immediate)
);

Adder Branch_addr_adder(
    .data1_i    (ID_immediate << 1),
    .data2_i    (ID_pc_o),
    .data_o     (Branch_addr)
);
  
// ========================================
// EX stage components

MUX4 MUX4_ALUInput1(
    .data1_i    (EX_RS1data),
    .data2_i    (RDdata),
    .data3_i    (MEM_ALUResult),
    .data4_i    (),
    .select_i   (ForwardA),
    .data_o     (ALUInput1)
);

MUX4 MUX4_ALUInput2(
    .data1_i    (EX_RS2data),
    .data2_i    (RDdata),
    .data3_i    (MEM_ALUResult),
    .data4_i    (),
    .select_i   (ForwardB),
    .data_o     (ALUInput_MUX_4_2_connect)
);

MUX2 MUX2_ALUInput2(
    .data1_i    (ALUInput_MUX_4_2_connect),
    .data2_i    (EX_immediate),
    .select_i   (EX_ALUSrc),
    .data_o     (ALUInput2)
);

ALU_Control ALU_Control(
    .funct_i    (EX_funct),
    .ALUOp_i    (EX_ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

ALU ALU(
    .data1_i    (ALUInput1),
    .data2_i    (ALUInput2),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (EX_ALUResult),
    .Zero_o     ()
);

// ========================================
// MEM stage components

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .addr_i     (MEM_ALUResult),
    .MemRead_i  (MEM_MemRead),
    .MemWrite_i (MEM_MemWrite),
    .data_i     (MEM_RS2data),
    .data_o     (MEM_MemData)
);

// ========================================
// WB stage components

MUX2 MUX2_RDdata(
    .data1_i    (WB_ALUResult),
    .data2_i    (WB_MemData),
    .select_i   (WB_MemtoReg),
    .data_o     (RDdata)
);

// ========================================
// Forwarding Unit

Forwarding_Unit Forwarding_Unit(
    .EX_RS1addr_i   (EX_RS1addr),
    .EX_RS2addr_i   (EX_RS2addr),
    .MEM_RegWrite_i (MEM_RegWrite),
    .MEM_RDaddr_i   (MEM_RDaddr),
    .WB_RegWrite_i  (WB_RegWrite),
    .WB_RDaddr_i    (WB_RDaddr),
    .ForwardA_o     (ForwardA),
    .ForwardB_o     (ForwardB)
);

// ========================================
// Hazard Detection

Hazard_Detection Hazard_Detection(
    .ID_RS1addr_i   (ID_RS1addr),
    .ID_RS2addr_i   (ID_RS2addr),
    .EX_MemRead_i   (EX_MemRead),
    .EX_RDaddr_i    (EX_RDaddr),
    .PCWrite_o      (PCWrite),
    .Stall_o        (Stall),
    .NoOp_o         (NoOp)
);

endmodule
