`ifndef SERIAL_MONITOR
`define SERIAL_MONITOR
`include "serial_transaction.sv"
`include "global_package.sv"


class serial_monitor extends uvm_monitor;
	`uvm_component_utils(serial_monitor)
	uvm_analysis_port # (serial_transaction) ana_port;
	virtual serial_interface v_seri_if;
	
	function new(string name = "serial_monitor", uvm_component parent = null );
		super.new(name, parent);
		`uvm_info("serial_monitor", "new is called", UVM_LOW);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("serial_monitor", "build_phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual serial_interface)::get(this, "", "mon_if_1", v_seri_if))begin
			`uvm_fatal("serial_monitor", "virtual interface must be set for serial_interface");
		end
		ana_port = new("ana_port", this);
	endfunction
	
	extern  task main_phase(uvm_phase phase);
	extern  task collect_one_packet(serial_transaction ser_tr);
	
endclass

	
	
task serial_monitor::main_phase(uvm_phase phase);
	serial_transaction ser_tr;
	phase.raise_objection(this);
	while(1) begin
		ser_tr = new("ser_tr");
		collect_one_packet(ser_tr);
		ana_port.write(ser_tr);
	end
endtask

task serial_monitor::collect_one_packet(serial_transaction ser_tr);
	byte unsigned	data_q[$];
	byte unsigned	data_array[];
	logic[7:0]	data;
	logic 		valid=0;
	int 		data_size;
	int i=0;
	while(1) begin
		@(posedge v_seri_if.clk);
		if(v_seri_if.valid) break;
	end	
	`uvm_info("serial_monitor", "begin to collect one packet", UVM_LOW);
	while(v_seri_if.valid) begin
		data_q.push_back(v_seri_if.data);
		i++;
//		uvm_report_info("serial_monitor", $sformatf("v_seri_if.data=%h, i=%d", v_seri_if.data, i), UVM_LOW);
		@(posedge v_seri_if.clk);
	end
	uvm_report_info("serial_monitor", $sformatf("data_size=%d", data_q.size()), UVM_LOW);
	data_size = data_q.size();
	data_array = new[data_size];
	for(int i=0;i<data_size;i++) begin
		data_array[i] = data_q[i];
	end
	ser_tr.pload = new[data_size-18];
	data_size = ser_tr.unpack_bytes(data_array)/8;
	`uvm_info("serial_monitor", "end to collect one packet", UVM_LOW);
endtask
	
`endif	//SERIAL_MONITOR