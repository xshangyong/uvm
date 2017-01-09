`ifndef SERIAL_SEQUENCE
`define SERIAL_SEQUENCE
`include "serial_transaction.sv"
class serial_sequence extends uvm_sequence # (serial_transaction);
	serial_transaction trans;
	function new(string name = "serial_sequence");
		super.new(name);
	endfunction	
	virtual task body();
		if(starting_phase != null) begin
			starting_phase.raise_objection(this);
		end		
		repeat(2) begin
			`uvm_do(trans);
		end
		#1000;
		if(starting_phase != null) begin
			starting_phase.drop_objection(this);
		end

	endtask
	`uvm_object_utils(serial_sequence)
endclass
`endif	//SERIAL_SEQUENCE