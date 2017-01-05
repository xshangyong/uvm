`ifndef SERIAL_TRANSACTION
`define SERIAL_TRANSACTION
class serial_transaction extends uvm_sequence_item;
	rand bit[47:0]	dmac;
	rand bit[47:0]	smac;
	rand bit[15:0]	ether_type;
	rand byte		pload[];
	rand bit[31:0]	crc;
	
	constraint pload_cons{
		pload.size >=46;
		pload.size <=1500;
	}
	
	function bit[31:0]	calc_crc();
		return 0;
	endfunction
	
	function void post_randomize();
		crc = calc_crc();	
	endfunction
	
	`uvm_object_utils(serial_transaction);
	
	function new(string name = "serial_transaction");
		super.new(name);
	endfunction
	
endclass

	
	


`endif	//SERIAL_TRANSACTION