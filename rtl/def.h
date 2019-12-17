//
// def.h
//
//
// Ports:
// ================================================
// Name          I/O   SIZE   props
// ================================================
// ================================================
// 
//
//
//

`define IMEM_FILE_PATH "/home/k0b0/fpga/ScmOfRISCV_Pipline/rtl/imem.dat"
`define DMEM_FILE_PATH "/home/k0b0/fpga/ScmOfRISCV_Pipline/rtl/dmem.dat"


`define INST_W 32

`define DATA_W 64

`define FUNCT_3_W 3

`define OPCODE_W 7        // Width of opcode

`define DMEM_ADDRESS_W 64 // Width of DMEM Address
//`define DMEM_ADDRESS_W 4 // Width of DMEM Address

`define IMEM_ADDR_W 5     // Width of Instruction Memory Address
`define IMEM_W 32         // Width of Instruction Memory Word

`define ALU_OP_W 3

`define REG_W 5           // Width of RF Address

`define ALU_SEL_W 6       // Width of ALU_SEL

// ALU OPcode
`define ALU_AND  `ALU_SEL_W'b000000
`define ALU_OR   `ALU_SEL_W'b000001
`define ALU_ADD  `ALU_SEL_W'b000010
`define ALU_SUB  `ALU_SEL_W'b000110
`define ALU_XOR  `ALU_SEL_W'b000111

// `define ALU_LD_SD  `ALU_SEL_W'b000010


// `define ALU_BEQ  `ALU_SEL_W'b000110
`define ALU_BNE  `ALU_SEL_W'b001000
`define ALU_BLT  `ALU_SEL_W'b001001
`define ALU_BGE  `ALU_SEL_W'b001010
`define ALU_BLTU `ALU_SEL_W'b001011
`define ALU_BGEU `ALU_SEL_W'b001100

`define ALU_SLL  `ALU_SEL_W'b001101
`define ALU_SLT  `ALU_SEL_W'b001110
`define ALU_SLTU `ALU_SEL_W'b001111
`define ALU_SRL  `ALU_SEL_W'b010000
`define ALU_SRA  `ALU_SEL_W'b010001

`define ALU_LB   `ALU_SEL_W'b010010
`define ALU_LH   `ALU_SEL_W'b010011
`define ALU_LW   `ALU_SEL_W'b010100
`define ALU_LBU  `ALU_SEL_W'b010101
`define ALU_LHU  `ALU_SEL_W'b010110

//`define ALU_CMP `ALU_SEL_W'b000111
//`define ALU_NOR `ALU_SEL_W'b001010

// RV32M Standard Extension
`define ALU_MUL    `ALU_SEL_W'b010111
`define ALU_MULH   `ALU_SEL_W'b011000
`define ALU_MULHSU `ALU_SEL_W'b011001
`define ALU_MULHU  `ALU_SEL_W'b011010
`define ALU_DIV    `ALU_SEL_W'b011011
`define ALU_DIVU   `ALU_SEL_W'b011100
`define ALU_REM    `ALU_SEL_W'b011101
`define ALU_REMU   `ALU_SEL_W'b011110

//============================================
// test_code parameter for instruction memory.
//============================================

// Regr-Imm
parameter REG_IMM = `OPCODE_W'b0010011;

parameter ADDI  = `FUNCT_3_W'b000;
parameter SLTI  = `FUNCT_3_W'b010;
parameter SLTIU = `FUNCT_3_W'b011;
parameter XORI  = `FUNCT_3_W'b100;
parameter ORI   = `FUNCT_3_W'b110;
parameter ANDI  = `FUNCT_3_W'b111;


// Reg-Reg
parameter REG_REG=`OPCODE_W'b0110011;


