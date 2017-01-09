`ifndef SERIAL_DRIVER__SV
`define SERIAL_DRIVER__SV
`include "serial_transaction.sv"
`include "global_package.sv"

import global_package::*;
class serial_driver extends uvm_driver;
	`uvm_component_utils(serial_driver)
	
	virtual serial_interface v_seri_if;
	
	function new(string name = "serial_driver", uvm_component parent = null );
		super.new(name, parent);
		`uvm_info("serial_driver", "new is called", UVM_LOW);
	endfunction	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("serial_driver", "build_phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual serial_interface)::get(this, "", "input_if_1", v_seri_if))begin
			`uvm_fatal("serial_driver", "virtual interface must be set for serial_interface");
		end
	endfunction
	
	extern  task main_phase(uvm_phase phase);
	extern  task drive_one_packet(serial_transaction ser_tr);
	
endclass

	
	
task serial_driver::main_phase(uvm_phase phase);
	serial_transaction ser_tr;
	phase.raise_objection(this);
	v_seri_if.data <= 8'b0;
	v_seri_if.valid <= 1'b0;
	while(!v_seri_if.rst_n)
		@(posedge v_seri_if.clk);
	repeat(PACKAGE_DRIVE_NUM)begin
		ser_tr = new("ser_tr");
		assert(ser_tr.randomize());  // with {ser_tr.pload.size==5;}
		drive_one_packet(ser_tr);
	end
   repeat(5) @(posedge v_seri_if.clk);
   phase.drop_objection(this);
endtask

task serial_driver::drive_one_packet(serial_transaction ser_tr);
	
	byte unsigned data_q[];
	int data_size;
	int i;
	data_size = ser_tr.pack_bytes(data_q) / 8;
	`uvm_info("serial_driver", "begin to drive one packet", UVM_LOW);
	$display("driver, data_size = %d", data_size);
	repeat(3) @(posedge v_seri_if.clk);
	for(i=0;i<data_size;i++) begin
		@(posedge v_seri_if.clk);
		v_seri_if.valid <= 1'b1;
		v_seri_if.data <= data_q[i];		
	end
	uvm_report_info("serial_monitor", $sformatf("driver, data sent i = %d", i), UVM_LOW);
	@(posedge v_seri_if.clk);
	v_seri_if.valid <= 1'b0;
	`uvm_info("serial_driver", "end drive one packet", UVM_LOW);
endtask
	
`endif	//SERIAL_DRIVER__SV