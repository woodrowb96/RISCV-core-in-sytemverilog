import package_project_typedefs::*;

module tb_hazard_detection();

PipeLineSignal_5 reg_file_wr_addr;
PipeLineSignal_5 reg_file_rd_addr_1;
PipeLineSignal_5 reg_file_rd_addr_2;
logic insert_nop;
RiscvOpcodes opcode;
	
hazard_detection dut(.*);


parameter CYCLE = 100;




initial begin
	opcode = OP_FENCE;	//no nop since inst is not load
	reg_file_wr_addr.ID = 5'd5;
	reg_file_rd_addr_1.IF = 5'd5;
	reg_file_rd_addr_2.IF = 5'd5;

	#CYCLE 
	opcode = OP_LOAD;
	reg_file_wr_addr.ID = 5'd5;
	reg_file_rd_addr_1.IF = 5'd6;	//no nop since rs != rd
	reg_file_rd_addr_2.IF = 5'd7;
	
	#CYCLE 
	opcode = OP_LOAD;
	reg_file_wr_addr.ID = 5'd5;
	reg_file_rd_addr_1.IF = 5'd5;	//nop
	reg_file_rd_addr_2.IF = 5'd7;
	

	#CYCLE 
	opcode = OP_LOAD;
	reg_file_wr_addr.ID = 5'd5;
	reg_file_rd_addr_1.IF = 5'd6;
	reg_file_rd_addr_2.IF = 5'd5;	//nop
	
	#CYCLE 
	opcode = OP_LOAD;
	reg_file_wr_addr.ID = 5'd5;
	reg_file_rd_addr_1.IF = 5'd5;
	reg_file_rd_addr_2.IF = 5'd5;	//nop
	
	#CYCLE 
	opcode = OP_LOAD;
	reg_file_wr_addr.ID = 5'd9;	//no nop
	reg_file_rd_addr_1.IF = 5'd5;
	reg_file_rd_addr_2.IF = 5'd5;
	



end

endmodule
