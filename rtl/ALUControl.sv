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



module ALUControl(input  logic [3:0]            Inst,  // from {Instruction{30,14:12}}
                  input  logic [`ALU_OP_W-1:0]  ALUOp, // from Control
	          output logic [`ALU_SEL_W-1:0] ALUCtl); // To ALU

always_comb
begin
     casex ({ALUOp,Inst})
	 7'b000xxxx : ALUCtl = `ALU_ADD;  // add (ld, sd)
	 7'b001x000 : ALUCtl = `ALU_SUB;  // sub (beq)
	 7'b001x001 : ALUCtl = `ALU_BNE;  // bne
	 7'b001x100 : ALUCtl = `ALU_BLT;  // blt
	 7'b001x101 : ALUCtl = `ALU_BGE;  // bge
	 7'b001x110 : ALUCtl = `ALU_BLTU; // bltu
	 7'b001x111 : ALUCtl = `ALU_BGEU; // bgeu
	 7'b01x0000 : ALUCtl = `ALU_ADD;  // add (add)
	 7'b01x1000 : ALUCtl = `ALU_SUB;  // sub (sub)
	 7'b01x0111 : ALUCtl = `ALU_AND;  // and 
	 7'b01x0110 : ALUCtl = `ALU_OR;  // or  
         7'b01x0100 : ALUCtl = `ALU_XOR; // XOR  
         default   : ALUCtl = `ALU_SEL_W'b000000; // ERROR
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
