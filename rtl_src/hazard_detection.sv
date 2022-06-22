/*
this module detects if there is a hazard in data path
	and sets insert nop to stall data path for 1 instruction

there is a hazard when a inst in ID tries to read from reg file, before a previous load instruction has read data
	from data memory to write into reg file
	this happens when a load is still in EX stage

these hazards are detected while LOAD inst is in ID and inst accessing reg file is in IF
*/
import package_project_typedefs::*;

module hazard_detection(
	input PipeLineSignal_5 reg_file_wr_addr,	//check rd  address of inst in ID
	input PipeLineSignal_5 reg_file_rd_addr_1,	//check rs1 and rs2 of inst in IF 
	input PipeLineSignal_5 reg_file_rd_addr_2,

	input RiscvOpcodes opcode,	//check if inst in ID has  opcode LOAD

	output logic insert_nop	//1 if nop is to be inserted
	
);
logic rd_1_conflict;	//conflics for each read addr in reg file
logic rd_2_conflict;

	//conflicts when rd in IF and write in ID  addresses are equal
	assign rd_1_conflict = reg_file_wr_addr.ID == reg_file_rd_addr_1.IF;
	assign rd_2_conflict = reg_file_wr_addr.ID == reg_file_rd_addr_2.IF;
	
	always_comb
		if((opcode == OP_LOAD ) && (rd_1_conflict || rd_2_conflict)) insert_nop = 1'b1;	//if inst in ex is LOAD and conflict insert nop
		else	insert_nop = 1'b0;		//else no nop

endmodule
