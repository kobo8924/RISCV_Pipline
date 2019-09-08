// 2018/08/19
// DataMemory.sv 
// Written by k0b0
//
//
//
//
// Ports:
// ================================================
// Name          I/O   SIZE   props
// ================================================
// clk             I      1   clock
// MemWrite        I      1   WriteEnable
// Address         I     64
// Writedata       I     64
// Readdata        O     64
// ================================================
// 
//

`ifndef DEF_HEADDER
    `include "def.h"
    `define DEF_HEADDER
`endif

module DataMemory (input                        clk,
	           input                        MemWrite,
	           input  [`DATA_W-1:0]         Address,
	           input  [`DATA_W-1:0]         Writedata,
	           output [`DATA_W-1:0]         Readdata);

logic [`DATA_W-1:0] dmem [0:31] ;

integer i;
initial
begin
    for(i=0; i<32; i=i+1)
	dmem[i] = `DATA_W'd0;
end

always_ff @(negedge clk)
begin
    if(MemWrite) 
	dmem[Address] <= Writedata;
end

assign Readdata = dmem[Address];

endmodule
