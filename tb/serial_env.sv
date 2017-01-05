`ifndef SERIAL_ENV
`define SERIAL_ENV
`include "serial_driver.sv"
`include "serial_monitor.sv"

class serial_env extends uvm_env;
	serial_driver drv;
	serial_monitor i_mon;
	serial_monitor o_mon;
	function new(string name = "serial_env", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drv = serial_driver::type_id::create("drv", this);
		i_mon = serial_monitor::type_id::create("i_mon", this);
		o_mon = serial_monitor::type_id::create("o_mon", this);
	endfunction
	
	`uvm_component_utils(serial_env)
endclass

	
	


`endif	//SERIAL_ENV