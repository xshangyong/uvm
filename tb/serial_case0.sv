`ifndef SERIAL_CASE0
`define SERIAL_CASE0

class case0_sequence extends serial_sequence;
	serial_transaction tranc;
   function  new(string name= "case0_sequence");
      super.new(name);
   endfunction 
	virtual task body();
		if(starting_phase != null)begin
			starting_phase.raise_objection(this);
		end
		repeat(4) begin
			`uvm_do(tranc)
		end
		#100;
		if(starting_phase != null)begin
			starting_phase.drop_objection(this);
		end
	endtask
   `uvm_object_utils(case0_sequence)
endclass


class serial_case0 extends base_test;
	function new(string name = "serial_case0", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	extern virtual function void build_phase(uvm_phase phase);
	`uvm_component_utils(serial_case0)
endclass

function void serial_case0:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db#(uvm_object_wrapper)::set(this,
											"env.i_agt.sqr.main_phase",
											"default_sequence",
											case0_sequence::type_id::get());
endfunction

`endif	//SERIAL_CASE0