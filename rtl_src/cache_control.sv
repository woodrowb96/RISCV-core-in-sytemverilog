/*
this module is used to hold all control logic used to update cache and access ram
	cache_control_state_machine and ram_control are submodules of this module

this module stalls the processor whenever an inst_cache adn data_cache misses 

instructions missess are handeled first fallowed by data misses

while a miss is being handled the processor is stalled and the cache_control is given control of caches

cache blocks are always alligned
	so a miss at byte 01 will cause the word starting at byte 00 to be read into cache
*/

import package_project_typedefs::*;

module cache_control(
	input logic clk,
	input logic reset_n,
	
	input [3:0] instruction_cache_miss, //each bit correspods to miss at each byte of 32 bit data	
	input [21:0] instruction_cache_tag,	//tag of miss	
	input logic [31:0] instruction_mem_addr,	//addr of miss


	input [3:0] data_cache_miss,	//1 if data cache miss	
	input [21:0] data_cache_tag,	//tag of miss
	input [3:0] data_cache_valid,		//indicates if data at miss_addr is valid
	input logic [31:0] data_mem_addr,	//addr of miss	
	input logic [31:0] data_mem_rd_data,	//data beign read from miss addr in cache	

	input logic [15:0] ram_rd_data_in,	//data read from  ram

	output logic data_cache_stall, //1 if stall is due to data_cache miss	
	output logic instruction_cache_stall,	//1 if stall is due to inst cache miss
	
	output CacheWrControl cache_wr_en,	//control signals to cache	
	output CacheRdControl cache_rd_type,
	output logic [31:0] cache_addr,	
	output logic [31:0] cache_wr_data,	
	
	output logic [15:0] ram_wr_data_out,	//control signals to ram
	output logic ram_wr_en,
	output logic [31:0] ram_rd_addr_out,
	output logic [31:0] ram_wr_addr_out

);

	logic [3:0] missed_bytes;	//1 if byte is a miss
	logic [3:0] valid_bytes;	//1 if data at byte is validg
	logic miss;		//set if a miss has occured
	logic [21:0] tag;	//tag at miss address
	logic valid;		//if miss has valid data
	logic [31:0] miss_addr_base;	//addr of first byte of miss
	logic [31:0] miss_addr;		//addr of miss that is being handles
	logic [31:0] miss_rd_data;	//data read from cache at miss_addr

	logic ram_wr_done;	//signals to and from cache_state_machien and ram_control
	logic ram_wr_start;
	logic ram_rd_done;
	logic ram_rd_start;
	logic [31:0] ram_rd_data;
	logic [31:0] ram_wr_addr;
	logic [31:0] ram_rd_addr;
	logic [31:0] ram_wr_data;

	always_comb begin
		if(|instruction_cache_miss)begin	//handle inst cache miss first
			missed_bytes = instruction_cache_miss;	//look at bytes in inst miss
			tag = instruction_cache_tag;	//tag is from inst miss
			valid_bytes = 4'b0000;		//never need to write back from inst cache
			miss_addr_base = instruction_mem_addr;		//get addr of first byte
			miss_rd_data = 32'd0; 	//dont ever need to read from inst cache
				
			instruction_cache_stall = 1'b1;		//stall processor
			data_cache_stall = 1'b1;		//stall data_cache 

		end else if(|data_cache_miss) begin	//handle data cache next
			missed_bytes = data_cache_miss;	//select info from data cache
			tag = data_cache_tag;
			valid_bytes = data_cache_valid;
			miss_addr_base = data_mem_addr;
			miss_rd_data = data_mem_rd_data;

			instruction_cache_stall = 1'b0;	//no inst miss
			data_cache_stall = 1'b1;	//stall due to data miss

		end else begin			//if no miss then dont stall 
			missed_bytes = 4'b0000;
			tag = 'x;
			valid_bytes = 4'b0000;
			miss_addr_base = 'x;
			miss_rd_data = 'x;

			instruction_cache_stall = 1'b0;	
			data_cache_stall = 1'b0;	
		end

		//for missaligned reads there may be multiple words missing in
		//data cache, during one access
		//look at 1st two bits of first byte to deterime how many
		//misses need to be handles	
		case(miss_addr_base[1:0]) //look at address 
			2'b00:begin
				//if 1st byte is alligned then there can only
				//be one miss
				miss = missed_bytes[0];	//look at byte 0 to detrmine miss
				valid = valid_bytes[0];
				miss_addr = miss_addr_base;	
			end
			2'b01:begin
				if(missed_bytes[0])begin
					miss = missed_bytes[0];		//look at 1st byte to determin first miss
					valid = valid_bytes[0];
					miss_addr = miss_addr_base - 32'd1; //1st miss is starts 1 byte back	
				end else begin
					miss = missed_bytes[3];		//there may be another word missing starting at byte 3
					valid = valid_bytes[3];
					miss_addr = miss_addr_base + 32'd3;	//2nd miss starts 3 bytes from first byte	
				end
			end
			2'b10:begin
				if(missed_bytes[0])begin
					miss = missed_bytes[0];
					valid = valid_bytes[0];
					miss_addr = miss_addr_base - 32'd2;			
				end else begin
					miss = missed_bytes[2];		//second miss might start at byte 2
					valid = valid_bytes[2];
					miss_addr = miss_addr_base + 32'd2;		
				end
			end
			2'b11:begin
				if(missed_bytes[0])begin
					miss = missed_bytes[0];
					valid = valid_bytes[0];
					miss_addr = miss_addr_base - 32'd3;			
				end else begin
					miss = missed_bytes[1];		//second miss may start at byte 1
					valid = valid_bytes[1];
					miss_addr = miss_addr_base + 32'd1;			
				end
			end
			default:begin
				miss = 'x;
				valid = 'x;
				miss_addr = 'x;
			end
		endcase		
	end

	cache_control_state_machine cache_control_state_machine(
		.clk,
		.reset_n,
		.miss,
		.valid,
		.tag,
		.miss_addr,
		.miss_rd_data,
		.ram_wr_done,
		.ram_rd_done,
		.ram_rd_data,
		.ram_wr_start,
		.ram_rd_start,
		.ram_wr_addr,
		.ram_rd_addr,
		.ram_wr_data,
		.cache_wr_en,
		.cache_rd_type,
		.cache_addr,
		.cache_wr_data
	);

	ram_control ram_control(
		.clk,
		.reset_n,
		.ram_wr_start,
		.ram_rd_start,
		.ram_wr_addr_base(ram_wr_addr),
		.ram_wr_data_in(ram_wr_data),
		.ram_rd_addr_base(ram_rd_addr),
		.ram_rd_data_in,

		.ram_wr_done,
		.ram_rd_done,
		.ram_rd_data_out(ram_rd_data),
		.ram_wr_data_out,
		.ram_wr_en,
		.ram_rd_addr(ram_rd_addr_out),
		.ram_wr_addr(ram_wr_addr_out)
	);



endmodule
