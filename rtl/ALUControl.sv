//
// 2018/03/27
// ALUControl.sv
// Written by k0b0 
//
//
//
// Ports:
// ================================================
// Name          I/O   SIZE   props
// ================================================
// Inst            I      4   {funct7Of1bit, funct3}
// ALUOp           I      3
// ALUCtl          O      6
// ================================================
// 
//

/**
*
* ALUOp is Number of type of operation.
* RV32I have 11 type operation and 41 instructions.
*
**/

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif



module ALUControl(input  logic [4:0]            Inst,  // from {Instruction{30, 25, 14:12}}
                  input  logic [`ALU_OP_W-1:0]  ALUOp, // from Control
	          output logic [`ALU_SEL_W-1:0] ALUCtl); // To ALU

always_comb
begin
     casex ({ALUOp,Inst})
	 7'b000x0xxx : ALUCtl = `ALU_ADD;  // add (ld, sd)

	 7'b001x0000 : ALUCtl = `ALU_SUB;  // sub (beq)
	 7'b001x0001 : ALUCtl = `ALU_BNE;  // bne
	 7'b001x0100 : ALUCtl = `ALU_BLT;  // blt
	 7'b001x0101 : ALUCtl = `ALU_BGE;  // bge
	 7'b001x0110 : ALUCtl = `ALU_BLTU; // bltu
	 7'b001x0111 : ALUCtl = `ALU_BGEU; // bgeu

	 7'b01x00000 : ALUCtl = `ALU_ADD;  // add (add)
	 7'b01x10000 : ALUCtl = `ALU_SUB;  // sub (sub)
	 7'b01x00001 : ALUCtl = `ALU_SLL;  // sll
	 7'b01x00010 : ALUCtl = `ALU_SLT;  // slt
	 7'b01x00011 : ALUCtl = `ALU_SLTU; // sltu
         7'b01x00100 : ALUCtl = `ALU_XOR;  // xor  
	 7'b01x00101 : ALUCtl = `ALU_SRL;  // srl
	 7'b01x10101 : ALUCtl = `ALU_SRA;  // sra
	 7'b01x00110 : ALUCtl = `ALU_OR;   // or  
	 7'b01x00111 : ALUCtl = `ALU_AND;  // and 
         default    : ALUCtl = `ALU_SEL_W'b000000; // ERROR
     endcase
end

/*
always_comb
begin
    casex ({ALUOp,Inst})
     6'b00xxxx : ALUCtl = `ALU_ADD;  // ADD (LD, SD)
     6'b01xxxx : ALUCtl = `ALU_SUB;  // SUB (BEQ)
     6'b100000 : ALUCtl = `ALU_ADD;  // ADD (ADD)
     6'b101000 : ALUCtl = `ALU_SUB;  // SUB (SUB)
     6'b100111 : ALUCtl = `ALU_AND;  // AND
     6'b100110 : ALUCtl = `ALU_OR;   // OR  
     6'b100100 : ALUCtl = `ALU_XOR;  // XOR  

     6'b110000 : ALUCtl = `ALU_ADDI; // ADDI  
     6'b110100 : ALUCtl = `ALU_XORI; // XORI  
     6'b110110 : ALUCtl = `ALU_ORI;  // ORI  
     6'b110111 : ALUCtl = `ALU_ANDI; // ANDI  
     default   : ALUCtl = `ALU_SEL_W'b000000; // ERROR
    endcase
end
*/

endmodule
