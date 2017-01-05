`ifndef SERIAL_ENV
`define SERIAL_ENV
`include "serial_driver.sv"

class serial_env extends uvm_env;
	serial_driver drv;
	
	function new(string name = "serial_env", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drv = serial_driver::type_id::create("drv", this);
	endfunction
	
	`uvm_component_utils(serial_env)
endclass

	
	


`endif	//SERIAL_ENV