/*
 this module holds the riscv core including
	data_path
	control
	forwarding unit
	hazard detection unit
	cache_control

*/

import package_project_typedefs::*;

module riscv_core(
	input logic clk,
	input logic reset_n,
		
	input logic [15:0] ram_rd_data_in,	//data out and in to ram
	output logic [15:0] ram_wr_data_out,
	output logic ram_wr_en,
	output logic [31:0] ram_rd_addr_out,
	output logic [31:0] ram_wr_addr_out
);

logic [31:0] instruction;

ImmGenControl instruction_type;	//data path control signals
logic reg_file_wr_en;
AluControl alu_op;
logic alu_sel_1;
logic alu_sel_2;
CacheWrControl data_mem_wr_en;
CacheRdControl data_mem_rd_type;
logic [1:0] write_back_sel;
BranchControl branch_type;
RiscvInstructions operation;
RiscvOpcodes opcode;
logic insert_nop;

logic instruction_cache_stall;	//inst cache signals
CacheWrControl instruction_cache_wr_en;
logic [31:0] instruction_cache_wr_data;
logic [31:0] instruction_cache_addr;
logic [3:0] instruction_cache_miss;
logic [21:0] instruction_cache_tag;
	
logic data_cache_stall;	//data cache signals
CacheWrControl cache_wr_en;
CacheRdControl cache_rd_type;
logic [31:0] cache_addr;
logic [31:0] cache_wr_data;
logic [3:0] data_cache_miss;
logic [21:0] data_cache_tag;
logic [3:0] data_cache_valid;

PipeLineSignal_5 reg_file_wr_addr;	//fwding signals
PipeLineSignal_5 reg_file_rd_addr_1,reg_file_rd_addr_2;
PipeLineSignal_1 reg_file_wr_en_cntrl;
ForwardingControl fwd_reg_file_rd_sel_1,fwd_reg_file_rd_sel_2;

logic [31:0] instruction_mem_addr_cache;	//cache_control signals
logic [31:0] data_mem_addr_cache;
logic [31:0] data_mem_rd_data_cache;
logic branch_redo;

//////////control////////
control control(
	.instruction,
	.instruction_type,
	.reg_file_wr_en,
	.alu_op,
	.alu_sel_1,
	.alu_sel_2,
	.data_mem_wr_en,
	.data_mem_rd_type,
	.write_back_sel,
	.branch_type,
	.opcode,
	.operation
	
);

//forarding unit//
forwarding_unit forwarding_unit(
	.reg_file_wr_addr,
	.reg_file_rd_addr_1,
	.reg_file_rd_addr_2,
	.reg_file_wr_en_cntrl,
	.fwd_reg_file_rd_sel_1,
	.fwd_reg_file_rd_sel_2
);

///hazard detect unit///
hazard_detection hazard_detection(
	.reg_file_wr_addr,
	.reg_file_rd_addr_1,
	.reg_file_rd_addr_2,
	.opcode,
	.insert_nop
);

///cache control ////
cache_control cache_control(
	.clk,
	.reset_n,
	.instruction_cache_miss,
	.instruction_cache_tag,
	.instruction_mem_addr(instruction_mem_addr_cache),
	.data_cache_miss,
	.data_cache_tag,
	.data_cache_valid,
	.data_mem_addr(data_mem_addr_cache),
	.data_mem_rd_data(data_mem_rd_data_cache),
	.data_cache_stall,
	.cache_wr_en,
	.cache_rd_type,
	.cache_addr,
	.cache_wr_data,
	.instruction_cache_stall,
	.ram_rd_data_in,
	.ram_wr_en,
	.ram_wr_data_out,
	.ram_rd_addr_out,
	.ram_wr_addr_out
);

////////data path/////////
data_path #(.INST_MEM_CACHE_SIZE(1024), .DATA_MEM_CACHE_SIZE(1024))data_path(
	.clk,
	.reset_n,
	.instruction_type,
	.reg_file_wr_en,
	.alu_op,	
	.alu_sel_1,
	.alu_sel_2,
	.data_mem_wr_en,
	.data_mem_rd_type,
	.write_back_sel,
	.branch_type,
	.instruction_cache_stall,
	.instruction_cache_wr_en(cache_wr_en),
	.instruction_cache_addr(cache_addr),
	.instruction_cache_wr_data(cache_wr_data),
	.data_cache_stall,
	.data_cache_wr_en(cache_wr_en),
	.data_cache_rd_type(cache_rd_type),
	.data_cache_addr(cache_addr),
	.data_cache_wr_data(cache_wr_data),
	.operation,
	.instruction_out(instruction),

	.reg_file_wr_addr,
	.reg_file_rd_addr_1,
	.reg_file_rd_addr_2,
	.reg_file_wr_en_cntrl,
	.fwd_reg_file_rd_sel_1,
	.fwd_reg_file_rd_sel_2,
	.insert_nop,
	.instruction_cache_miss,
	.instruction_cache_tag,
	.data_cache_miss,
	.data_cache_tag,
	.data_cache_valid,
	
	.instruction_mem_addr_out(instruction_mem_addr_cache),
	
	.data_mem_addr_out(data_mem_addr_cache),
	.data_mem_rd_data_out(data_mem_rd_data_cache)

);
endmodule
