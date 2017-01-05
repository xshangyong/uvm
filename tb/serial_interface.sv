`ifndef SERIAL_INTERFACE__SV
`define SERIAL_INTERFACE__SV

interface serial_interface(	input clk, 
							input rst_n);
	logic[7:0]	data;						
	logic 		valid;
endinterface	
							
`endif  //SERIAL_INTERFACE__SV