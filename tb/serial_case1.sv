`ifndef SERIAL_CASE01
`define SERIAL_CASE01

class case1_sequence extends serial_sequence;
	serial_transaction tranc;
   function  new(string name= "case1_sequence");
      super.new(name);
   endfunction 
	virtual task body();
		if(starting_phase != null)begin
			starting_phase.raise_objection(this);
		end
		repeat(5) begin
			`uvm_do_with(tranc, {tranc.pload.size() == 5;})
		end
		#100;
		if(starting_phase != null)begin
			starting_phase.drop_objection(this);
		end
	endtask
   `uvm_object_utils(case1_sequence)
endclass


class serial_case1 extends base_test;
	function new(string name = "serial_case1", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	extern virtual function void build_phase(uvm_phase phase);
	`uvm_component_utils(serial_case1)
endclass

function void serial_case1:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db#(uvm_object_wrapper)::set(this,
											"env.i_agt.sqr.main_phase",
											"default_sequence",
											case1_sequence::type_id::get());
endfunction

`endif	//SERIAL_CASE01