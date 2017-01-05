`include "uvm_macros.svh"

import uvm_pkg::*;

`include "serial_driver.sv"
`include "serial_interface.sv"
`include "serial_env.sv"

module top_tb;
	
	reg 		clk;
	reg			rst_n;
	reg[7:0]	rxd;
	reg			rx_dv;
	wire[7:0]	txd;
	wire		tx_en;
	
	serial_interface	input_if(clk, rst_n);
	serial_interface	output_if(clk, rst_n);
	
	
	dut inst_dut(
			.clk	(clk			),
			.rst_n	(rst_n			),
			.rxd	(input_if.data	),
			.rx_dv	(input_if.valid	),
			.txd	(output_if.data	),
			.tx_en	(output_if.valid)
	);
	
	initial begin
		uvm_config_db#(virtual serial_interface)::set(null, "uvm_test_top.drv", "input_if_1", input_if);
		uvm_config_db#(virtual serial_interface)::set(null, "uvm_test_top.i_mon", "mon_if_1", input_if);
		uvm_config_db#(virtual serial_interface)::set(null, "uvm_test_top.o_mon", "mon_if_1", output_if);
		run_test("serial_env");
	end
	
	
	initial begin
		clk = 0;
		forever begin
			#100ns clk = ~clk;
		end
	end
	
	initial begin
		rst_n = 1'b0;
		#300ns;
		rst_n = 1'b1;
	end
endmodule
