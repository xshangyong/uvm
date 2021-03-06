`ifndef SERIAL_ENV
`define SERIAL_ENV
class serial_env extends uvm_env;
	serial_agent i_agt;
	serial_agent o_agt;
	serial_refmod	 inst_ref_mod;
	serial_scorebd	 inst_scb;
	uvm_tlm_analysis_fifo # (serial_transaction) agt_mdl_fifo;
	uvm_tlm_analysis_fifo # (serial_transaction) mdl_scb_fifo;
	uvm_tlm_analysis_fifo # (serial_transaction) agt_scb_fifo;
	function new(string name = "serial_env", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt_mdl_fifo = new("agt_mdl_fifo", this);
		mdl_scb_fifo = new("mdl_scb_fifo", this);
		agt_scb_fifo = new("agt_scb_fifo", this);
		i_agt = serial_agent::type_id::create("i_agt", this);
		o_agt = serial_agent::type_id::create("o_agt", this);
		inst_ref_mod = serial_refmod::type_id::create("inst_ref_mod", this);
		inst_scb = serial_scorebd::type_id::create("inst_scb", this);
		i_agt.is_active = UVM_ACTIVE;
		o_agt.is_active = UVM_PASSIVE;
//		uvm_config_db # (uvm_object_wrapper)::set(this, "i_agt.sqr.main_phase", "default_sequence", serial_sequence::type_id::get());
	
	endfunction
	extern virtual function void connect_phase(uvm_phase phase);
	`uvm_component_utils(serial_env)
endclass

function void serial_env::connect_phase(uvm_phase phase);	
	super.connect_phase(phase);
	i_agt.ana_port.connect(agt_mdl_fifo.analysis_export);
	inst_ref_mod.get_port.connect(agt_mdl_fifo.blocking_get_export);
	 
	inst_ref_mod.ana_port.connect(mdl_scb_fifo.analysis_export);
	inst_scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
	
	o_agt.ana_port.connect(agt_scb_fifo.analysis_export);
	inst_scb.act_port.connect(agt_scb_fifo.blocking_get_export);
endfunction
	


`endif	//SERIAL_ENV