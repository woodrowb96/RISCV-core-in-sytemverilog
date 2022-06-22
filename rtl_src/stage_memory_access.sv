/*
 this module hold the memory access including 	
	data cache
 */
import package_project_typedefs::*;

module stage_memory_access #(parameter DATA_MEM_CACHE_SIZE = 1024)(

	input logic clk,
	input logic reset_n,

	input logic [31:0] data_mem_wr_data,	//data cache signals from data path
	input logic [31:0] data_mem_addr,
	input CacheWrControl data_mem_wr_en,
	input CacheRdControl data_mem_rd_type,

	input logic data_cache_stall,	//signals from cache_control
	input CacheWrControl data_cache_wr_en,
	input logic [31:0] data_cache_addr,
	input logic [31:0] data_cache_wr_data,

	output logic [31:0] data_mem_rd_data,	//output to data path and cache control
	output logic [3:0] data_cache_miss,
	output logic [21:0] data_cache_tag,
	output logic [3:0] data_cache_valid
);




		cache#(.CACHE_SIZE(DATA_MEM_CACHE_SIZE)) data_cache(
			.clk,
			.reset_n,
			.wr_en_in(data_mem_wr_en),
			.rd_type_in(data_mem_rd_type),
			.addr_in(data_mem_addr),
			.wr_data_in(data_mem_wr_data),
			.rd_data_out(data_mem_rd_data),
			.cache_stall(data_cache_stall),
			.cache_wr_en(data_cache_wr_en),
			.cache_addr(data_cache_addr),
			.cache_wr_data(data_cache_wr_data),
			.cache_miss(data_cache_miss),
			.miss_tag(data_cache_tag),
			.valid_data(data_cache_valid)

		);	
	


endmodule
