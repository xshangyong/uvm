`ifndef SERIAL_ENV
`define SERIAL_ENV
`include "serial_agent.sv"
class serial_env extends uvm_env;
	serial_agent i_agt;
	serial_agent o_agt;
	
	function new(string name = "serial_env", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		i_agt = serial_agent::type_id::create("i_agt", this);
		o_agt = serial_agent::type_id::create("o_agt", this);
		i_agt.is_active = UVM_ACTIVE;
		o_agt.is_active = UVM_PASSIVE;
	endfunction
	
	`uvm_component_utils(serial_env)
endclass

	
	


`endif	//SERIAL_ENV