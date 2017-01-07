`ifndef SERIAL_AGENT
`define SERIAL_AGENT
`include "serial_driver.sv"
`include "serial_monitor.sv"

class serial_agent extends uvm_agent;
	serial_driver drv;
	serial_monitor mon;
	uvm_analysis_port # (serial_transaction) ana_port;
	function new(string name = "serial_agent", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	
	
	`uvm_component_utils(serial_agent)
endclass

function void serial_agent::build_phase(uvm_phase phase);	
	super.build_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		drv = serial_driver::type_id::create("drv", this);
	end
	mon = serial_monitor::type_id::create("mon", this);
endfunction
function void serial_agent::connect_phase(uvm_phase phase);	
	super.connect_phase(phase);
	ana_port = mon.ana_port;
endfunction

`endif	//SERIAL_AGENT