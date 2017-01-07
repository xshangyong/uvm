`ifndef SERIAL_REFMOD
`define SERIAL_REFMOD

class serial_refmod extends uvm_component;
	
	uvm_blocking_get_port # (serial_transaction) get_port;
	uvm_analysis_port # (serial_transaction) ana_port;
	
	extern function new(string name = "serial_refmod", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	`uvm_component_utils(serial_refmod)
endclass

	function serial_refmod::new(string name = "serial_refmod", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void serial_refmod::build_phase(uvm_phase phase);
		super.build_phase(phase);
		get_port = new("get_port", this);
		ana_port = new("ana_port", this);
	
	endfunction
	
	task serial_refmod::main_phase(uvm_phase phase);
		serial_transaction 	tr;
		serial_transaction	new_tr;
		super.main_phase(phase);
		while(1)begin
			get_port.get(tr);
			new_tr = new("new_tr");
			new_tr.my_copy(tr);
			`uvm_info("serial_refmod", "get one transacion, copy and print it:", UVM_LOW);
			new_tr.print_data();
			ana_port.write(new_tr);
		end
	endtask
`endif	//SERIAL_REFMOD