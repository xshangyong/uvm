`ifndef SERIAL_DRIVER__SV
`define SERIAL_DRIVER__SV
`include "serial_transaction.sv"

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
	for(int i=0; i<2; i++) begin
		ser_tr = new("ser_tr");
		assert(ser_tr.randomize() with {pload.size == 9;});
		drive_one_packet(ser_tr);
	end
   repeat(5) @(posedge v_seri_if.clk);
   phase.drop_objection(this);
endtask

task serial_driver::drive_one_packet(serial_transaction ser_tr);
	
	bit[47:0]	tmp_data;
	bit[7:0]	data_q[$];
	
	tmp_data = ser_tr.dmac;
	for(int i=0; i<6; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = (tmp_data >> 8);
	end
	
	tmp_data = ser_tr.smac;
	for(int i=0; i<6; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = (tmp_data >> 8);
	end
	
	tmp_data[15:0] = ser_tr.ether_type;
	for(int i=0; i<2; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = (tmp_data >> 8);
	end
	
	for(int i=0; i<ser_tr.pload.size; i++) begin
		data_q.push_back(ser_tr.pload[i][7:0]);
	end
	
	tmp_data[31:0] = ser_tr.crc;
	for(int i=0; i<4; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = (tmp_data >> 8);
	end
	
	`uvm_info("serial_driver", "begin to drive one packet", UVM_LOW);
	
	repeat(3) @(posedge v_seri_if.clk);
	
	while(data_q.size()>0)begin
		@(posedge v_seri_if.clk);
		v_seri_if.valid <= 1'b1;
		v_seri_if.data <= data_q.pop_front();		
	end
	@(posedge v_seri_if.clk);
	v_seri_if.valid <= 1'b0;
	`uvm_info("serial_driver", "end drive one packet", UVM_LOW);
endtask
	
`endif	//SERIAL_DRIVER__SV