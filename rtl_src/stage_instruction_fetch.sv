/*
 this module contains the instruction fetch inscluding 
	PC
	instruction cache
this module is also resposible for 
	choosing appropriate pc during branches
	stalling the pc during stalls
	decoding inst rs1, rs2 for hazard detection
 */

import package_project_typedefs::*;

module stage_instruction_fetch #(parameter INST_MEM_CACHE_SIZE = 1024) (
	input logic clk,
	input logic reset_n,
	
	input logic branch_decision,	//bracn signals
	input logic [31:0] branch_target,
	input logic insert_nop,
	input logic stall,
	input logic branch_redo,

	input logic instruction_cache_stall,	//inst cache signals
	input [31:0] instruction_cache_addr,
	input [31:0] instruction_cache_wr_data,
	input CacheWrControl instruction_cache_wr_en,
	
	output logic [31:0] pc,			
	output logic [31:0] instruction,
	output logic [4:0] reg_file_rd_addr_1,	//rd addresses for hazard detetion
	output logic [4:0] reg_file_rd_addr_2,

	output logic [3:0] instruction_cache_miss,	//inst cache miss signals
	output logic [21:0] instruction_cache_tag
);
	
logic [31:0] pc_next;
logic [31:0] instruction_rd;
	
	assign pc_next = (branch_decision | branch_redo) ? branch_target : pc + 32'd4;	//during branch redo or brach choose branch target
	
	always_ff @(posedge clk, negedge reset_n) begin
		if(!reset_n) pc <= 32'd0;	//reset to addr 0
		else if(insert_nop | stall ) pc <= pc; 	//during stall stay at same pc
		else pc <= pc_next;	//else go to next pc
	end

	cache #(.CACHE_SIZE(INST_MEM_CACHE_SIZE)) instruction_cache(
		.clk,
		.reset_n,
		.addr_in(pc),
		.wr_en_in(CACHE_NO_WR),
		.rd_type_in(CACHE_W_RD),
		.wr_data_in(),
		.cache_stall(instruction_cache_stall),
		.cache_wr_en(instruction_cache_wr_en),
		.cache_addr(instruction_cache_addr),
		.cache_wr_data(instruction_cache_wr_data),
		.cache_miss(instruction_cache_miss),
		.valid_data(),
		.rd_data_out(instruction),
		.miss_tag(instruction_cache_tag)
	);
	

	always_comb begin	//decode source registers
		reg_file_rd_addr_1 = instruction[19:15];
		reg_file_rd_addr_2 = instruction[24:20];
	end


endmodule 
