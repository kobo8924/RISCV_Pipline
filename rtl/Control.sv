//
// Control.sv (Decode to Instruction.)
// 2018/04/19
//
//
// Ports:
// ================================================
// Name                  I/O   SIZE   props
// ================================================
// Instruction_opcode     I     7     OPCODE
// ALUSrc                 O     1
// MemtoReg               O     1
// RegWrite               O     1
// MemRead                O     1
// MemWrite               O     1
// Branch                 O     1
// ALUOp                  O     3
// ================================================
// 
//

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif

module Control (input  logic [`OPCODE_W-1:0] Instruction_opcode,
	        output logic                 ALUSrc,
		output logic                 MemtoReg,
	        output logic                 RegWrite,
	        output logic                 MemRead,
	        output logic                 MemWrite,
	        output logic                 Branch,
	        output logic [`ALU_OP_W-1:0] ALUOp);

logic [8:0] Control_sigs;

// Decode instruction
always_comb
begin
    casex(Instruction_opcode)
     `OPCODE_W'b0110011 : Control_sigs = 9'b001000010; // R-format
     `OPCODE_W'b0010011 : Control_sigs = 9'b101000011; // Imm
     `OPCODE_W'b0000011 : Control_sigs = 9'b111100000; // ld
     `OPCODE_W'b0100011 : Control_sigs = 9'b1x0010000; // sd
     `OPCODE_W'b1100011 : Control_sigs = 9'b0x0001001; // beq
                default : Control_sigs = 9'b000000000; // Error
    endcase
end


assign {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} = Control_sigs;

endmodule
