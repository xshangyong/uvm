`ifndef SERIAL_SCOREBD
`define SERIAL_SCOREBD
`include "serial_transaction.sv"
class serial_scorebd extends uvm_scoreboard;
	serial_transaction expect_queue[$];
	uvm_blocking_get_port # (serial_transaction) exp_port;
	uvm_blocking_get_port # (serial_transaction) act_port;
	`uvm_component_utils(serial_scorebd)
	
	extern function new(string name = "serial_scorebd", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
endclass

	function serial_scorebd::new(string name = "serial_scorebd", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void serial_scorebd::build_phase(uvm_phase phase);
		super.build_phase(phase);
		exp_port = new("exp_port", this);
		act_port = new("act_port", this);
		
	endfunction
	
	task serial_scorebd::main_phase(uvm_phase phase);
		serial_transaction	get_expect, get_actual, tmp_tran;
		bit result;
		super.main_phase(phase);
		while(1)begin
			exp_port.get(get_expect);
			expect_queue.push_back(get_expect);
		end
		
		while(1)begin
			act_port.get(get_actual);
			if(expect_queue.size() > 0) begin
				tmp_tran = expect_queue.pop_front();
				result = get_actual.compare_all(tmp_tran);
				if(result) begin
					`uvm_info("serial_scorebd", "Compare SUCCESSFULLY", UVM_LOW);
				end
				else begin
				   `uvm_error("serial_scorebd", "Compare FAILED");
				   $display("the expect pkt is");
				   tmp_tran.print_data();
				   $display("the actual pkt is");
				   get_actual.print_data();
				end
			end
			else begin
				`uvm_error("serial_scorebd", "get actural pkt while expect pck queue is empty");
				$display("the unexpected pkt is");
				get_actual.print_data();
			end
		end
	endtask
`endif	//SERIAL_SCOREBD