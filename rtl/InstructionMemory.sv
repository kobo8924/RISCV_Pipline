//
//
// 2018/04/13
// Written by k0b0
// InstructionMemory.sv
//
//
// Ports:
// ================================================
// Name          I/O   SIZE   props
// ================================================
// Readaddress     I      5
// Instruction     O     32
// ================================================
// 
//


`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif


module InstructionMemory (input  logic [`IMEM_ADDR_W-1:0] Readaddress,
			  output logic [`IMEM_W-1:0]      Instruction);


logic [`IMEM_W-1:0] imem [0:15];

initial 
begin
    $readmemb(`IMEM_FILE_PATH, imem);
end

assign Instruction = imem[Readaddress];

/*
always_comb
begin
    case(Readaddress)
	//                               fu7     rs2   rs1   fu3 rd    op
	5'd0  : Instruction = {12'b000000001111, 5'b00000, ADDI, 5'b00011, REG_IMM};  // addi r3,r0,15
	5'd1  : Instruction = {12'b000000000011, 5'b00000, ADDI, 5'b00010, REG_IMM};  // addi r2,r0,3
	5'd2  : Instruction = {7'b0100000, 5'b00010, 5'b00011, 3'b000, 5'b00100, REG_REG};// sub  r4,r3,r2
	5'd3  : Instruction = {7'b0000000, 5'b00011, 5'b00100, 3'b000, 5'b00101, REG_REG};// sub r5,r4,r3
                              // sw M[rs1 + offset] = x[rs2]
	5'd4  : Instruction = {7'b0000000, 5'b00101, 5'b000000, 3'b010, 5'b00001, 7'b0100011}; 
			      // ld x[rd] = M[x[rs1] + offset]
        5'd5  : Instruction = {12'b000000000001, 5'b00000, 3'b010, 5'b00110, 7'b0000011};
                              // add r8,r2,r6
	5'd6  : Instruction = {7'b0000000, 5'b00110, 5'b00010, 3'b000, 5'b01000, 7'b0110011}; 
	5'd7  : Instruction = `IMEM_W'd7;
	5'd8  : Instruction = `IMEM_W'd8;
	5'd9  : Instruction = `IMEM_W'd9;
	5'd10 : Instruction = `IMEM_W'd10;
	5'd11 : Instruction = `IMEM_W'd0;
	5'd12 : Instruction = `IMEM_W'd0;
	5'd13 : Instruction = `IMEM_W'd0;
	5'd14 : Instruction = `IMEM_W'd0;
	5'd15 : Instruction = `IMEM_W'd0;
	5'd16 : Instruction = `IMEM_W'd0;
	5'd17 : Instruction = `IMEM_W'd0;
	5'd18 : Instruction = `IMEM_W'd0;
	5'd19 : Instruction = `IMEM_W'd0;
	5'd20 : Instruction = `IMEM_W'd0;
	5'd21 : Instruction = `IMEM_W'd0;
	5'd22 : Instruction = `IMEM_W'd0;
	5'd23 : Instruction = `IMEM_W'd0;
	5'd24 : Instruction = `IMEM_W'd0;
	5'd25 : Instruction = `IMEM_W'd0;
	5'd26 : Instruction = `IMEM_W'd0;
	5'd27 : Instruction = `IMEM_W'd0;
	5'd28 : Instruction = `IMEM_W'd0;
	5'd20 : Instruction = `IMEM_W'd0;
	5'd30 : Instruction = `IMEM_W'd0;
	default: Instruction = `IMEM_W'd0;
    endcase
end
*/

endmodule
