`include "uvm_macros.svh"
import uvm_pkg::*;

`include "global_package.sv"
`include "serial_transaction.sv"
`include "serial_sequence.sv"
`include "serial_interface.sv"
`include "serial_driver.sv"
`include "serial_monitor.sv"
`include "serial_sequencer.sv"
`include "serial_agent.sv"
`include "serial_refmod.sv"
`include "serial_scorebd.sv"
`include "serial_env.sv"
`include "base_test.sv"
`include "serial_case0.sv"
`include "serial_case1.sv"
import global_package::*;
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
		run_test();
	end
	initial begin
		uvm_config_db#(virtual serial_interface)::set(null, "uvm_test_top.env.i_agt.drv", "input_if_1", input_if);
		uvm_config_db#(virtual serial_interface)::set(null, "uvm_test_top.env.i_agt.mon", "mon_if_1", input_if);
		uvm_config_db#(virtual serial_interface)::set(null, "uvm_test_top.env.o_agt.mon", "mon_if_1", output_if);
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
