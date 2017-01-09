`ifndef SERIAL_SEQUENCER
`define SERIAL_SEQUENCER

class serial_sequencer extends uvm_sequencer # (serial_transaction);
	function new(string name = "serial_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction	
	`uvm_component_utils(serial_sequencer)
endclass
`endif	//SERIAL_SEQUENCER