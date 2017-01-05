`ifndef SERIAL_TRANSACTION
`define SERIAL_TRANSACTION
class serial_transaction extends uvm_sequence_item;
	rand bit[47:0]	dmac;
	rand bit[47:0]	smac;
	rand bit[15:0]	ether_type;
	rand byte		pload[];
	rand bit[31:0]	crc;
	
	constraint pload_cons{
		pload.size >=4;		//46
		pload.size <=10;	//1500
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
	
	extern function void print_data();
endclass

function void  serial_transaction::print_data();
	$display("dmac = %0h", dmac);
	$display("smac = %0h", smac);
	$display("ether_type = %0h", ether_type);
	for(int i=0; i<pload.size; i++) begin
		$display("pload = %0h", pload[i]);
	end
	$display("crc = %0h", crc);
endfunction
	


`endif	//SERIAL_TRANSACTION