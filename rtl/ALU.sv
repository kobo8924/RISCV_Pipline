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

logic [`DATA_W*2-1:0] ALUOut_tmp;

//assign ALUOut = OUTsig;

assign Zero = (ALUOut_tmp == 64'd0);


//assign ALUOut = ALUOut_tmp[`DATA_W-1:0];

assign ALUOut = (ALUctl == `ALU_MUL)    ? ALUOut_tmp[31:0]:
                (ALUctl == `ALU_MULH)   ? ALUOut_tmp[63:32]:
                (ALUctl == `ALU_MULHSU) ? ALUOut_tmp[63:32]:
		(ALUctl == `ALU_MULHU)  ? ALUOut_tmp[63:32]:ALUOut_tmp[31:0];

always_comb
begin
    case(ALUctl)
	`ALU_AND   : ALUOut_tmp <= {`DATA_W'd0, (A & B)};
	`ALU_OR    : ALUOut_tmp <= {`DATA_W'd0, (A | B)};
	`ALU_XOR   : ALUOut_tmp <= {`DATA_W'd0, (A ^ B)};
	`ALU_ADD   : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_SUB   : ALUOut_tmp <= {`DATA_W'd0, (A - B)};

	`ALU_LB    : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_LH    : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_LW    : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_LBU   : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_LHU   : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	
	`ALU_SB    : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_SH    : ALUOut_tmp <= {`DATA_W'd0, (A + B)};
	`ALU_SW    : ALUOut_tmp <= {`DATA_W'd0, (A + B)};

	/* Branch Instruction */
	/* In this processor, an inverter is added because the zero flag is
	 * a branch condition. */
	`ALU_BNE   : ALUOut_tmp <= ~(A != B);
	`ALU_BLT   : ALUOut_tmp <= ~(A < B);
	`ALU_BGE   : ALUOut_tmp <= ~(A >= B);
	`ALU_BLTU  : ALUOut_tmp <= $unsigned(~(A < B));
	`ALU_BGEU  : ALUOut_tmp <= $unsigned(~(A >= B));

	`ALU_SLL   : ALUOut_tmp <= A << B[4:0];
	`ALU_SLT   : ALUOut_tmp <= (A < B);
	`ALU_SLTU  : ALUOut_tmp <= $unsigned(A < B);
	`ALU_SRL   : ALUOut_tmp <= A[4:0] >> B;
	`ALU_SRA   : ALUOut_tmp <= A[4:0] >>> B;

	/* RV32IM */
        `ALU_MUL    : ALUOut_tmp   <= A * B;
        `ALU_MULH   : ALUOut_tmp   <= A * B;
        `ALU_MULHSU : ALUOut_tmp   <= A * $unsigned(B);
        `ALU_MULHU  : ALUOut_tmp   <= $unsigned(A * B);
        `ALU_DIV    : ALUOut_tmp   <= {`DATA_W'd0, (A / B)};
        `ALU_DIVU   : ALUOut_tmp   <= {`DATA_W'd0, $unsigned(A / B)};
        `ALU_REM    : ALUOut_tmp   <= {`DATA_W'd0, (A % B)};
        `ALU_REMU   : ALUOut_tmp   <= {`DATA_W'd0, $unsigned(A % B)};
	default     : ALUOut_tmp   <= 64'd0;
    endcase
end

endmodule
