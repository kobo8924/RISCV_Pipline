/* clk_divider_0.v */
/* 50MHz -> 1Hz */
module clk_divider(input   clk, rst, sw, stop,
                   output reg divid_clk);

reg [25:0] cnt;

wire cntend = (cnt==26'd24_999_999);
logic start_program;

// push sw 
always @(posedge sw, posedge rst)
begin
    if(rst)
	start_program <= 1'b0;
    else
	start_program <= 1'b1;
	end
	
    

always @(posedge clk or posedge rst)
begin
    if(rst)
        cnt <= 26'd0;
    else if(cntend)
        cnt <= 26'd0;
    else
        cnt <= cnt + 26'd1;
end

always @(posedge clk or posedge rst ) 
begin
    if(rst)
        divid_clk <= 1'b0;
    else if(cntend)
	divid_clk <= ~(divid_clk) & start_program & ~(stop);
end

endmodule
