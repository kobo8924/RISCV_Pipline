//
// 2018/03/24
// ALU.sv
// writen by k0b0
//
// 
// Ports:
// =========================================================
// Name          I/O   SIZE   props
// ALUctl          I      6 
// A               I     32
// B               I     32
// ALU_Out         O     32
// Zero            O      1
// =========================================================
//

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif

module ALU (input  logic        [`ALU_SEL_W-1:0] ALUctl, 
            input  logic signed [`DATA_W-1:0]    A, B, 
            output logic        [`DATA_W-1:0]    ALUOut, 
            output                               Zero);

//logic [`DATA_W-1:0] OUTsig;


//assign ALUOut = OUTsig;

assign Zero = (ALUOut_tmp == 0);


always_comb
begin
    case(ALUctl)
	`ALU_AND   : ALUOut <= A & B;
	`ALU_OR    : ALUOut <= A | B;
	`ALU_XOR   : ALUOut <= A ^ B;
	`ALU_ADD   : ALUOut <= A + B;
	`ALU_SUB   : ALUOut <= A - B;
	
	/* Branch Instruction */
	`ALU_BNE   : ALUOut <= ~(A != B);
	`ALU_BLT   : ALUOut <= ~(A < B);
	`ALU_BGE   : ALUOut <= ~(A >= B);
	`ALU_BLTU  : ALUOut <= $unsigned(~(A < B));
	`ALU_BGEU  : ALUOut <= $unsigned(~(A >= B));

	`ALU_SLL   : ALUOut <= A << B[4:0];
	`ALU_SLT   : ALUOut <= (A < B);
	`ALU_SLTU  : ALUOut <= $unsigned(A < B);
	`ALU_SRL   : ALUOut <= A[4:0] >> B;
	`ALU_SRA   : ALUOut <= A[4:0] >>> B;

	/* RV32IM */
      //`ALU_MUL    : ALUOut_tmp[] <= ;
      //`ALU_MULH   : ALUOut_tmp[] <= ;
      //`ALU_MULHSU : ALUOut_tmp[] <= ;
      //`ALU_MULHU  : ALUOut_tmp[] <= ;
      //`ALU_DIV    : ALUOut_tmp[] <= ;
      //`ALU_DIVU   : ALUOut_tmp[] <= ;
      //`ALU_REM    : ALUOut_tmp[] <= ;
      //`ALU_REMU   : ALUOut_tmp[] <= ;
	default     : ALUOut   <= 0;
    endcase
end

endmodule
