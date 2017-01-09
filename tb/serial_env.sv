`ifndef SERIAL_ENV
`define SERIAL_ENV
`include "serial_agent.sv"
`include "serial_refmod.sv"
`include "serial_transaction.sv"
`include "serial_scorebd.sv"
`include "serial_sequence.sv"
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
	endfunction
	extern virtual function void connect_phase(uvm_phase phase);
	extern  task main_phase(uvm_phase phase);	
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
	
task serial_env::main_phase(uvm_phase phase);
	serial_sequence seq;
	phase.raise_objection(this);
	seq = serial_sequence::type_id::create("seq");
	seq.start(i_agt.sqr);
	phase.drop_objection(this);
endtask


`endif	//SERIAL_ENV