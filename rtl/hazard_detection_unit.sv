/*-------------------------------
--  FILE NAME : hazard_detection_unit.sv
--  TYPE      : 
--  FUNCTION  : hazard_detection
--  edit      : 2019/09/01
--  Author    :
--  Rev,Date  :
--            :
-------------------------------*/

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif

module hazard_detection_unit(input              MemRead_id_ex,
                             input [`REG_W-1:0] rd_id_ex,
			     input [`REG_W-1:0] rs1_if_id,
			     input [`REG_W-1:0] rs2_if_id,
			     output             hazard_flg,
			     output             mux_ctrl,
			     output             if_id_write,
			     output             pc_write);

always_comb
begin
    if((MemRead_id_ex) && ((rd_id_ex == rs1_if_id) || (rd_id_ex == rs2_if_id)))
    begin
	mux_ctrl    <= 1'b0;
        if_id_write <= 1'b0;
        pc_write    <= 1'b0;
	hazard_flg  <= 1'b1;
    end
    else
    begin
	mux_ctrl    <= 1'b1;
        if_id_write <= 1'b1;
        pc_write    <= 1'b1;
	hazard_flg  <= 1'b0;
    end
end


/*
always_comb
begin
    if((MemRead_id_ex) && 
	((rd_id_ex == rs1_if_id) || (rd_id_ex == rs2_if_id)))
    begin
	mux_ctrl <= 1'b0;
        if_id_write <= 1'b0;
        pc_write <= 1'b0;
    end
    else
    begin
	mux_ctrl <= 1'b1;
        if_id_write <= 1'b1;
        pc_write <= 1'b1;
    end
end
*/
      
endmodule

