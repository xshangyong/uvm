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
	bit[7:0]	data_q[$];
	int 	psize;
	while(1) begin
		@(posedge v_seri_if.clk) begin
			if(v_seri_if.valid) begin
				break;
			end
		end
	end
		
	`uvm_info("serial_monitor", "begin to collect one packet", UVM_LOW);
	
	while(v_seri_if.valid) begin
		data_q.push_back(v_seri_if.data);
		@(posedge v_seri_if.clk);
	end
	ser_tr.pload=new[data_q.size-18];

	for(int i=0; i<6; i++) begin
		ser_tr.dmac = {ser_tr.dmac[39:0], data_q.pop_front()};
	end

	for(int i=0; i<6; i++) begin
		ser_tr.smac = {ser_tr.smac[39:0], data_q.pop_front()};
	end

	for(int i=0; i<2; i++) begin	
		ser_tr.ether_type = {ser_tr.ether_type[7:0], data_q.pop_front()};
	end
	
	for(int i=0; i<ser_tr.pload.size; i++) begin	
		ser_tr.pload[i] = data_q.pop_front();
	end

	for(int i=0; i<4; i++) begin	
		ser_tr.crc = {ser_tr.crc[23:0], data_q.pop_front()};
	end

	`uvm_info("serial_monitor", "end collect one packet", UVM_LOW);
	ser_tr.print_data();
endtask
	
`endif	//SERIAL_MONITOR