//
//
//
// 2018/04/12
// Written by k0b0
// ScmOfRISCV.sv
// RISCV Pipline
//
//
// Ports:
// ================================================
// Name          I/O   SIZE   props
// ================================================
// clk             I      1   clock
// reset           I      1   reset
// ================================================
// 
//

// Uusing memory(FFs) for debug.
`define MEM_TEST


`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif


module RISCV_Pipline (input logic clk,
		      input logic reset,
	              output logic [`IMEM_ADDR_W-1:0] pc_out,
	              output logic [`DATA_W-1:0]      alu_out,
		      output logic [7:0]              ctrl_sig);

logic [`IMEM_ADDR_W-1:0] pc;
logic [`IMEM_ADDR_W-1:0] next_pc;
logic [`IMEM_ADDR_W-1:0] pc_br;
logic [`INST_W-1:0]      instruction;

logic [`OPCODE_W-1:0] opcode;
logic [`REG_W-1:0]    rd;
logic [`REG_W-1:0]    rs1;
logic [`REG_W-1:0]    rs2;
logic [4:0]           alu_ctrl_in;

logic [`DATA_W-1:0]    Readdata1;
logic [`DATA_W-1:0]    Readdata2;
logic [`DATA_W-1:0]    Writedata;
logic [`ALU_SEL_W-1:0] ALUctl;

logic [`DATA_W-1:0]    Immgen;
logic [`DATA_W-1:0]    RegOrConst;
logic [`DATA_W-1:0]    ALUOut;
logic [`DATA_W-1:0]    Dest_data;
logic [`DATA_W-1:0]    Dmem_dataread;

// logic [11:0]           imm;

logic                ALUSrc;
logic                MemtoReg;
logic                RegWrite;
logic                MemRead;
logic                MemWrite;
logic                Branch;
logic [`ALU_OP_W-1:0] ALUOp;

logic Zero_flg;

logic [7:0] Control_sigs; // Debug signals

// wire for Pipline Resister (IF/ID)
logic [`INST_W-1:0]      instruction_if_id;
logic [`IMEM_ADDR_W-1:0] pc_if_id; 

// wire for Pipline Resister (ID/EX)
logic [`IMEM_ADDR_W-1:0] pc_id_ex;
logic                    RegWrite_id_ex;
logic                    MemWrite_id_ex;
logic                    MemRead_id_ex;
logic                    Branch_id_ex;
logic [`ALU_OP_W-1:0]    ALUOp_id_ex; 
logic                    ALUSrc_id_ex;
logic [`DATA_W-1:0]      Readdata1_id_ex;
logic [`DATA_W-1:0]      Readdata2_id_ex;
logic [`DATA_W-1:0]      Immgen_id_ex;
logic [4:0]              alu_ctrl_in_id_ex ;
logic [`REG_W-1:0]       rd_id_ex;
logic                    MemtoReg_id_ex;
logic [`REG_W-1:0]       rs1_id_ex;
logic [`REG_W-1:0]       rs2_id_ex;

// wire for Pipline Resister (EX/MEM)
logic                    RegWrite_ex_mem;
logic                    MemWrite_ex_mem;
logic                    MemRead_ex_mem;
logic                    Branch_ex_mem;
logic [`IMEM_ADDR_W-1:0] pc_br_ex_mem;
logic                    Zero_flg_ex_mem;
logic [`DATA_W-1:0]      ALUOut_ex_mem;
//logic [`DATA_W-1:0]      Readdata2_ex_mem;
logic [`DATA_W-1:0]      forwardB_out_ex_mem;
logic [`REG_W-1:0]       rd_ex_mem;
logic                    MemtoReg_ex_mem;

// wire for Pipline Resister (MEM/WB)
logic               RegWrite_mem_wb;
logic [`DATA_W-1:0] Dmem_dataread_mem_wb ;
logic [`DATA_W-1:0] ALUOut_mem_wb;
logic [`REG_W-1:0]  rd_mem_wb;
logic               MemtoReg_mem_wb;

// forwarding
logic [`DATA_W-1:0] forwardA_out;
logic [`DATA_W-1:0] forwardB_out;
logic [1:0]         forwardA;
logic [1:0]         forwardB;

// hazard detection unit
logic mux_ctrl_write_sig;
logic RegWrite_mux_out;
logic MemWrite_mux_out;
logic if_id_write;
logic pc_write;

// Debug signal
logic MemWrite_dug;
logic forwarding_flg;
logic hazard_flg;

/********************************************
 *
 * IF Stage  
 *
 *******************************************/

assign next_pc = (!(Zero_flg_ex_mem & Branch_ex_mem))? (pc+1) : pc_br_ex_mem;

// PC
always_ff @(posedge clk, posedge reset)
begin
    if(reset) 
	pc <= 0;
    else if(pc_write)      
	pc <= next_pc ;
end


// parameter ADRESS = 5, INSTRUCTION = 32
// [ADRESS-1:0]      Readaddress
// [INSTRUCTION-1:0] Instruction
/*
InstructionMemory InstructionMemory_0(.Readaddress (pc),
                                      .Instruction (instruction));
*/

// IMEM Generated by IP catalog.
Inst_mem Inst_mem_0(.address({5'd0, pc}), 
                    .clock(clk), 
		    .data(32'd0), 
		    .wren(1'b0), 
		    .q(instruction));

// IF/ID Pipline Register
always_ff @(posedge clk, posedge reset)
begin
    if(reset) 
    begin
	instruction_if_id <= 0;
	pc_if_id          <= 0;
    end
    else if(if_id_write)      
    begin
	instruction_if_id <= instruction;
	pc_if_id          <= pc ;
    end
end

//assign instruction_if_id = instruction;

/********************************************
 *
 * ID Stage  
 *
 *******************************************/

// instruction is from the module InstructionMemory output signals.
assign opcode = instruction_if_id[6:0];
assign rd     = instruction_if_id[11:7];
assign rs1    = instruction_if_id[19:15];
assign rs2    = instruction_if_id[24:20];

/* hazard detection unit */
hazard_detection_unit hdu0(.MemRead_id_ex (MemRead_id_ex),
                           .rd_id_ex      (rd_id_ex),
			   .rs1_if_id     (rs1),
			   .rs2_if_id     (rs2),
			   .hazard_flg    (hazard_flg),
			   .mux_ctrl      (mux_ctrl_write_sig),
			   .if_id_write   (if_id_write),
		           .pc_write      (pc_write));

/* Control of hazard detection unit */
assign RegWrite_mux_out = (mux_ctrl_write_sig) ? RegWrite:1'b0;
assign MemWrite_mux_out = (mux_ctrl_write_sig) ? MemWrite:1'b0;

//assign RegWrite_mux_out = RegWrite;
//assign MemWrite_mux_out = MemWrite;




// [6:0] Instruction_opcode
//       ALUSrc
//       MemtoReg
//       RegWrite
//       MemRead
//       MemWrite
//       Branch
//       ALUOp
Control Control_0(.Instruction_opcode (opcode),
                  .ALUSrc             (ALUSrc),
	          .MemtoReg           (MemtoReg),
	          .RegWrite           (RegWrite),
	          .MemRead            (MemRead),
	          .MemWrite           (MemWrite),
	          .Branch             (Branch),
	          .ALUOp              (ALUOp));

// #(parameter REG_W=5, DATA_W=64)
//              clk
// [REG_W-1:0]  Readregister1, // Read Register Address1
// [REG_W-1:0]  Readregister2, // Read Register Address2
// [REG_W-1:0]  Writeregister, // Write Register Address
//              RegWrite,      // Write Enable
// [DATA_W-1:0] Writedata,     // Write Data
// [DATA_W-1:0] Readdata1,     // Read Data 1
// [DATA_W-1:0] Readdata2);    // Read Data 2
//
RegFile Registers_0(.clk           (clk),
                    .reset         (reset),
   	            .Readregister1 (rs1),
		    .Readregister2 (rs2),
		    .Writeregister (rd_mem_wb),
		    .RegWrite      (RegWrite_mem_wb),
		    .Writedata     (Dest_data),
		    .Readdata1     (Readdata1),
		    .Readdata2     (Readdata2));


// ImmGen
// Select immedeate by OPCODE.
ImmGen ImmGen_0 (.Inst   (instruction_if_id), 
                 .Opcode (opcode),
                 .Imm    (Immgen));



// funct7[30] and funct3.
assign alu_ctrl_in = {instruction_if_id[30],     // funct7[5]
                      instruction_if_id[25],     // funct7[0]
                      instruction_if_id[14:12]}; // funct3

// ID/EX Pipline Register
always_ff @(posedge clk, posedge reset)
begin
    if(reset) 
    begin
	pc_id_ex          <= 0;
	RegWrite_id_ex    <= 0;
	MemWrite_id_ex    <= 0;
	MemRead_id_ex     <= 0;
	Branch_id_ex      <= 0;
	ALUOp_id_ex       <= 0;
	ALUSrc_id_ex      <= 0;
	Readdata1_id_ex   <= 0;
	Readdata2_id_ex   <= 0;
	Immgen_id_ex      <= 0;
	alu_ctrl_in_id_ex <= 0;
	rd_id_ex          <= 0;
	MemtoReg_id_ex    <= 0;
	rs1_id_ex         <= 0;
	rs2_id_ex         <= 0;
    end
    else
    begin
	pc_id_ex          <= pc_if_id;
	RegWrite_id_ex    <= RegWrite_mux_out;
	MemWrite_id_ex    <= MemWrite_mux_out;
	MemRead_id_ex     <= MemRead;
	Branch_id_ex      <= Branch;
	ALUOp_id_ex       <= ALUOp;
	ALUSrc_id_ex      <= ALUSrc;
	Readdata1_id_ex   <= Readdata1;
	Readdata2_id_ex   <= Readdata2;
	Immgen_id_ex      <= Immgen;
	alu_ctrl_in_id_ex <= alu_ctrl_in;
	rd_id_ex          <= rd;
	MemtoReg_id_ex    <= MemtoReg;
	rs1_id_ex         <= rs1;
	rs2_id_ex         <= rs2;
    end
end

/********************************************
 *
 * EX Stage  
 *
 *******************************************/

assign pc_br = pc_id_ex + (Immgen_id_ex << 1);

// MUX
// ALUSrc == 0 : Readdata2
// ALUSrc == 1 : Immgen
assign  RegOrConst = (!ALUSrc_id_ex) ? forwardB_out:Immgen_id_ex;

// Forwarding A mux
assign forwardA_out = (forwardA == 2'b01) ? Dest_data:
                      (forwardA == 2'b10) ? ALUOut_ex_mem:Readdata1_id_ex;

// Forwarding B mux
assign forwardB_out = (forwardB == 2'b01) ? Dest_data:
                      (forwardB == 2'b10) ? ALUOut_ex_mem:Readdata2_id_ex;


// [3:0] ALUctl
// [63:0] A, B
// [63:0] ALUOut
//        Zero
ALU ALU_0(.ALUctl (ALUctl),
	  .A      (forwardA_out),
	  .B      (RegOrConst),
	  .ALUOut (ALUOut),
	  .Zero   (Zero_flg));

// [3:0] Inst (from {Instruction{30,14:12}})
// [1:0] AUUOp (from Control)
// [3:0] ALUCtl (To ALU)
ALUControl ALUControl_0(.Inst   (alu_ctrl_in_id_ex),
                        .ALUOp  (ALUOp_id_ex),
		        .ALUCtl (ALUctl));

// Forwarding Unit
forwarding_unit fu0(.rs1_id_ex       (rs1_id_ex),
                    .rs2_id_ex       (rs2_id_ex),
		    .rd_ex_mem       (rd_ex_mem),
		    .RegWrite_ex_mem (RegWrite_ex_mem),
		    .rd_mem_wb       (rd_mem_wb),
		    .RegWrite_mem_wb (RegWrite_mem_wb),
		    .forwarding_flg  (forwarding_flg),
		    .forwardA        (forwardA),
	            .forwardB        (forwardB));


// EX/MEM Pipline Register
always_ff @(posedge clk, posedge reset)
begin
    if(reset) 
    begin
	RegWrite_ex_mem     <= 0;
	MemWrite_ex_mem     <= 0;
	MemRead_ex_mem      <= 0;
	Branch_ex_mem       <= 0;
	pc_br_ex_mem        <= 0;
	Zero_flg_ex_mem     <= 0;
	ALUOut_ex_mem       <= 0;
	// Readdata2_ex_mem <= 0;
	forwardB_out_ex_mem <= 0;
	rd_ex_mem           <= 0;
	MemtoReg_ex_mem     <= 0;
    end
    else
    begin
	RegWrite_ex_mem     <= RegWrite_id_ex;
	MemWrite_ex_mem     <= MemWrite_id_ex;
	MemRead_ex_mem      <= MemRead_id_ex;
	Branch_ex_mem       <= Branch_id_ex;
	pc_br_ex_mem        <= pc_br;
	Zero_flg_ex_mem     <= Zero_flg;
	ALUOut_ex_mem       <= ALUOut;
	// Readdata2_ex_mem <= Readdata2_id_ex;
	forwardB_out_ex_mem <= forwardB_out;
	rd_ex_mem           <= rd_id_ex;
	MemtoReg_ex_mem     <= MemtoReg_id_ex;
    end
end

/********************************************
 *
 * MA Stage  
 *
 *******************************************/

// #(parameter N = 64, M = 64)
//            clk,
//    	      MemWrite,
//    [N-1:0] Address,
//    [M-1:0] Writedata,
//    [M-1:0] Readdata);
//
//
`ifdef MEM_TEST
    DataMemory DMEM_0(.clk       (clk),
	              .MemWrite  (MemWrite_ex_mem),
	              .Address   ({56'd0, ALUOut_ex_mem[7:0]}),
	              .Writedata (forwardB_out_ex_mem),
	              .Readdata  (Dmem_dataread));

`else
    /* Single Port RAM, Generated by Quartus prime */
    Data_mem DMEM_0(.address ({56'd0, ALUOut_ex_mem[7:0]}),
                    .clock   (clk),
             	    .data    (forwardB_out_ex_mem),
		    .wren    (MemWrite_ex_mem),
		    .q       (Dmem_dataread));
`endif


// assign Dmem_dataread_mem_wb = Dmem_dataread;

// MEM/WB Pipline Register
always_ff @(posedge clk, posedge reset)
begin
    if(reset) 
    begin
	RegWrite_mem_wb      <= 0;
	Dmem_dataread_mem_wb <= 0;
	ALUOut_mem_wb        <= 0;
	rd_mem_wb            <= 0;
	MemtoReg_mem_wb      <= 0;
	MemWrite_dug         <= 0;
    end
    else
    begin
	RegWrite_mem_wb      <= RegWrite_ex_mem;
	Dmem_dataread_mem_wb <= Dmem_dataread;
	ALUOut_mem_wb        <= ALUOut_ex_mem;
	rd_mem_wb            <= rd_ex_mem;
	MemtoReg_mem_wb      <= MemtoReg_ex_mem;

	// debug signal
	MemWrite_dug         <= MemWrite_ex_mem;
    end
end

/********************************************
 *
 * WB Stage  
 *
 *******************************************/


// MUX
assign Dest_data = (MemtoReg_mem_wb)? Dmem_dataread_mem_wb:ALUOut_mem_wb;

/********************************************
 *
 * Debug Signals
 *
 *******************************************/
assign pc_out = pc;

assign Control_sigs = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};

//assign alu_out = ALUOut;
assign alu_out = Dest_data;
//assign alu_out = Dmem_dataread;

// Ctrl signal
//assign ctrl_sig = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};

//assign ctrl_sig = {RegWrite_mem_wb, MemWrite_dug, forwarding_flg, hazard_flg, forwardB_out_ex_mem[3:0]};

assign ctrl_sig = {2'd0, hazard_flg, forwarding_flg, 2'd0,RegWrite_mem_wb, MemWrite_dug};
//assign ctrl_sig = {2'd0, forwardB, Immgen_id_ex[3:0]};

//assign ctrl_sig = {};

endmodule
