`ifndef SERIAL_BASE_TEST
`define SERIAL_BASE_TEST
class base_test extends uvm_test;
	serial_env env;
	
	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	`uvm_component_utils(base_test)
	
endclass

	function void base_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = serial_env::type_id::create("env", this);
		uvm_config_db # (uvm_object_wrapper)::set(this, 
												"env.i_agt.sqr.main_phase", 
												"default_sequence", 
												serial_sequence::type_id::get());
	endfunction
	
	function void base_test::report_phase(uvm_phase phase);
		uvm_report_server server;
		int err_num;
		super.report_phase(phase);
		server = get_report_server();
		err_num = server.get_severity_count(UVM_ERROR);
		if(err_num != 0) begin
			$display("test case fail");
		end
		else begin
			$display("test case pass");
		end
	endfunction
`endif	//SERIAL_BASE_TEST