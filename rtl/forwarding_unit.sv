

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif
	
module forwarding_unit(input  [`REG_W-1:0] rs1_id_ex,
                       input  [`REG_W-1:0] rs2_id_ex,
		       input  [`REG_W-1:0] rd_ex_mem,
		       input               RegWrite_ex_mem,
		       input  [`REG_W-1:0] rd_mem_wb,
		       input               RegWrite_mem_wb,
		       output              forwarding_flg,
		       output [1:0]        forwardA,
		       output [1:0]        forwardB);

logic forwarding_flg_a;
logic forwarding_flg_b;

assign forwarding_flg = forwarding_flg_a | forwarding_flg_b;

always_comb
begin
    if((RegWrite_ex_mem) && 
       (rd_ex_mem != `REG_W'd0) && 
       (rd_ex_mem == rs1_id_ex))
       begin
	   forwardA = 2'b10;
           forwarding_flg_a = 1'b1;
       end
    else if ((RegWrite_mem_wb) && 
             (rd_mem_wb != `REG_W'd0) && 
	     !((RegWrite_ex_mem) && 
	     (rd_ex_mem != `REG_W'd0) && 
	     (rd_ex_mem == rs1_id_ex)) && 
	     (rd_mem_wb == rs1_id_ex))
	     begin
		 forwardA = 2'b01;
		 forwarding_flg_a = 1'b1;
	     end
	     else
	     begin
		 forwardA = 2'b00;
		 forwarding_flg_a = 1'b0;
	     end
end

// forwarding rs1(operand 2) 
always_comb
begin
    if((RegWrite_ex_mem) && 
       (rd_ex_mem != `REG_W'd0) && 
       (rd_ex_mem == rs2_id_ex))
    begin
	forwardB = 2'b10;
	forwarding_flg_b = 1'b1;
    end
    else if ((RegWrite_mem_wb) && 
             (rd_mem_wb != `REG_W'd0) && 
	   !((RegWrite_ex_mem) && 
	    (rd_ex_mem != `REG_W'd0) && 
	    (rd_ex_mem == rs2_id_ex)) && 
	    (rd_mem_wb == rs2_id_ex)) 
	    begin
		forwardB = 2'b01;
		forwarding_flg_b = 1'b1;
	    end
	    else
	    begin
		forwardB = 2'b00;
		forwarding_flg_b = 1'b0;
	    end
end


endmodule
