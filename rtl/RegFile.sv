//
// Registers.sv
//
//
// Ports:
// ================================================
// Name            I/O   SIZE   props
// ================================================
// Readregister1     I      5  
// Readregister2     I      5  
// Writeregister     I      5
// RegWrite          I      1   WriteEnable
// Writedata         I     32
// REaddata1         O     32
// REaddata2         O     32
// ================================================
// 
//

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif



module RegFile   (input                clk,
                  input                reset,
                  input  [`REG_W-1:0]  Readregister1, // Read Register Address1
                  input  [`REG_W-1:0]  Readregister2, // Read Register Address2
                  input  [`REG_W-1:0]  Writeregister, // Write Register Address
                  input                RegWrite,      // Write Enable
                  input  [`DATA_W-1:0] Writedata,     // Write Data
	          output [`DATA_W-1:0] Readdata1,     // Read Data 1
	          output [`DATA_W-1:0] Readdata2);    // Read Data 2


logic [31:0] reg_file [0:31] ;

/*
integer i;
initial
begin
    for(i = 0; i < 32; i = i + 1) 
	reg_file[i] = 0;
end
*/

always_ff @(negedge clk or posedge reset)
begin
    if(reset)
    begin
	integer i;
	for(i = 0; i < 32; i = i + 1) 
	    reg_file[i] = 0;
    end
    else if((RegWrite) && (Writeregister != 1'b0))
	reg_file[Writeregister] <= Writedata;
end

assign Readdata1 = reg_file[Readregister1];
assign Readdata2 = reg_file[Readregister2];

endmodule
