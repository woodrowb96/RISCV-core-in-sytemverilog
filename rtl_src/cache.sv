/*
this module is the cache 

data is stored in the cache from ram in word sized blocks, alligned to byte offset 00

each byte in a word is stored in one of four block rams instantiated bellow
	bytes with offset 00 always go in block 0
	bytes with offset 01 always go in block 1
			  10 always go in block 2
		          11 always go in block 3

all accessess are 1 word in length,but may be missaligned
	if any of those bytes is missing during a cache access
	the corresponding byte in the miss signal
	will go high and cache_control will handle the miss

while cache_control is handling a miss cache_control is takes control of cache control signals aways from data path

block tags and valid bits are updated whenever a new block is read in from ram

*/

import package_project_typedefs::*;

module cache #(parameter CACHE_SIZE = 1024) (	//CACH_SIZE in BYTES

	input logic clk,
	input logic reset_n,
	
	input CacheWrControl wr_en_in,  // write control signal
	input CacheRdControl rd_type_in,	

	input logic [31:0] addr_in, ///32 bit address were accessing 
	input logic [31:0] wr_data_in, /// 32 bit data that may be written to addr

	input logic cache_stall,	//1 if the cache is stalling the processor
	input CacheWrControl cache_wr_en,	//cache control signals
	input logic [31:0] cache_addr,
	input logic [31:0] cache_wr_data,
	
	output logic [3:0] cache_miss,	//1 bit is high for each byte missing from word access
	output logic [3:0] valid_data,	//1 bit is high for each valid byte in accessed word
	output logic [21:0] miss_tag,	//one tag for the word being accessed
	/// output signals///
	output logic [31:0] rd_data_out// 32 bit data that may be read from addr	
);


localparam BLOCK_DEPTH = CACHE_SIZE / 4;	//each block hold 1/4th of the total bytes

reg valid [BLOCK_DEPTH - 1:0];	//one valid bit per word in cache
reg [21:0] tag [BLOCK_DEPTH - 1:0];	//one tag per word in cache

integer i;	//integer for for loop

logic [31:0] addr_val;	//used addr,wr_data,wr_en when choosing between cache and data path control 
logic [31:0] wr_data;
logic [3:0] wr_en;
CacheRdControl rd_type;	

logic [31:0] rd_data;	//used to hold data read from blocks
logic [3:0] cache_hit;	//each bit is high if there is a hit for that byte
logic [3:0] miss;	//each bit is low if there is miss for that byte

CachSubBlockSignal_32 block_addr;	//address of each block 
CachSubBlockSignal_8 block_index;	//index we are accessing in each block
CachSubBlockSignal_22 block_tag;	//tag of each block 
CachSubBlockSignal_8 block_rd_data;	//1 byte being read from each block
CachSubBlockSignal_8 block_wr_data;	//1 byte written to a single block 
CachSubBlockSignal_1 block_wr_en;	//wr_en for each block 

CachSubBlockSignal_32 access_addr;	//these signals are set according to the address that the 
CachSubBlockSignal_8 access_index;	//data path is accessing, and stays the same regardless of
CachSubBlockSignal_22 access_tag;	//if the cache_control is controling the cache
CachSubBlockSignal_1 access_hit;


CachSubBlockSignal_32 byte_addr;	//used to hold address of each byte offset from first byte


	//calculate block addresses based on block offest
	always_comb begin
		if(cache_stall)begin	//if cache is stalled, then control should come from cache_control signals
			addr_val = cache_addr;	
			rd_type = CACHE_W_RD;
			wr_en = cache_wr_en;
			wr_data = cache_wr_data;
		end else begin		//else control comes from data path signals
			addr_val = addr_in; 
			rd_type = rd_type_in;
			wr_en = wr_en_in;
			wr_data = wr_data_in;
		end

		byte_addr.ZERO = addr_val + 32'd0;	//get address of each byte in memory
		byte_addr.ONE = addr_val + 32'd1;
		byte_addr.TWO = addr_val + 32'd2;
		byte_addr.THREE = addr_val + 32'd3;

		case(addr_val[1:0])	//look at byte offsett of base address and which blocks byte addresses shoudl go to
			2'b00:begin
				block_addr.ZERO = byte_addr.ZERO;
				block_addr.ONE = byte_addr.ONE;
				block_addr.TWO = byte_addr.TWO;
				block_addr.THREE = byte_addr.THREE;

				//rearange data read from blocks depending on
				//byte offset	
				rd_data = {block_rd_data.THREE,block_rd_data.TWO,block_rd_data.ONE,block_rd_data.ZERO};
			
				//rearange datawritten to blocks depending on
				//the byte offset 
				{block_wr_data.THREE,block_wr_data.TWO,block_wr_data.ONE,block_wr_data.ZERO} = wr_data;

				//rearang wich blocks are enabled 
				//based on byte offset
				block_wr_en.ZERO = wr_en[0];
				block_wr_en.ONE = wr_en[1];
				block_wr_en.TWO = wr_en[2];
				block_wr_en.THREE = wr_en[3];


			end	
			2'b01:begin	//if word being accessed is missaligned by 1 byte
				block_addr.ZERO = byte_addr.THREE;
				block_addr.ONE = byte_addr.ZERO;
				block_addr.TWO = byte_addr.ONE;
				block_addr.THREE = byte_addr.TWO;
				
				rd_data = {block_rd_data.ZERO,block_rd_data.THREE,block_rd_data.TWO,block_rd_data.ONE};

				{block_wr_data.ZERO,block_wr_data.THREE,block_wr_data.TWO,block_wr_data.ONE} = wr_data;
	
				block_wr_en.ZERO = wr_en[3];
				block_wr_en.ONE = wr_en[0];
				block_wr_en.TWO = wr_en[1];
				block_wr_en.THREE = wr_en[2];	
			
			end		
			2'b10:begin	//if word is missaligned by 2 bytes
				block_addr.ZERO = byte_addr.TWO;
				block_addr.ONE = byte_addr.THREE;
				block_addr.TWO = byte_addr.ZERO;
				block_addr.THREE = byte_addr.ONE;
				
				rd_data = {block_rd_data.ONE,block_rd_data.ZERO,block_rd_data.THREE,block_rd_data.TWO};	
		
				{block_wr_data.ONE,block_wr_data.ZERO,block_wr_data.THREE,block_wr_data.TWO} = wr_data;	

				block_wr_en.ZERO = wr_en[2];
				block_wr_en.ONE = wr_en[3];
				block_wr_en.TWO = wr_en[0];
				block_wr_en.THREE = wr_en[1];


			end		
			2'b11:begin	//if word is missalignes  by 3 bytes
				block_addr.ZERO = byte_addr.ONE;
				block_addr.ONE = byte_addr.TWO;
				block_addr.TWO = byte_addr.THREE;
				block_addr.THREE = byte_addr.ZERO;
				
				rd_data = {block_rd_data.TWO,block_rd_data.ONE,block_rd_data.ZERO,block_rd_data.THREE};		
				{block_wr_data.TWO,block_wr_data.ONE,block_wr_data.ZERO,block_wr_data.THREE} = wr_data;			
				
				block_wr_en.ZERO = wr_en[1];
				block_wr_en.ONE = wr_en[2];
				block_wr_en.TWO = wr_en[3];
				block_wr_en.THREE = wr_en[0];
			end			
			default:begin
				block_addr.ZERO = 'x;
				block_addr.ONE = 'x;
				block_addr.TWO = 'x;
				block_addr.THREE = 'x;
				
				rd_data = 'x;	

				{block_wr_data.TWO,block_wr_data.ONE,block_wr_data.ZERO,block_wr_data.THREE} = 'x;	

				block_wr_en.ZERO = 'x;
				block_wr_en.ONE = 'x;
				block_wr_en.TWO = 'x;
				block_wr_en.THREE = 'x;

			end 	

		endcase

			//get index of the word in  cache that each byte
			//belongs to 
			block_index.ZERO = block_addr.ZERO[9:2];	
			block_index.ONE = block_addr.ONE[9:2];	
			block_index.TWO = block_addr.TWO[9:2];	
			block_index.THREE = block_addr.THREE[9:2];	
			
			//get tag of the word in  cache that each byte belongs
			//to
			block_tag.ZERO = block_addr.ZERO[31:10];	
			block_tag.ONE = block_addr.ONE[31:10];	
			block_tag.TWO = block_addr.TWO[31:10];	
			block_tag.THREE = block_addr.THREE[31:10];	

			//miss tag sent to cache_control is always from first
			//block in cache 
			miss_tag = tag[block_index.ZERO];

			/*****get the other miss data from addr that data path is accessing******/	

			access_addr.ZERO = addr_in + 32'd0;	//get byte addresses of all bytes acced by data path
			access_addr.ONE = addr_in + 32'd1;
			access_addr.TWO = addr_in + 32'd2;
			access_addr.THREE = addr_in + 32'd3;
		
			access_index.ZERO = access_addr.ZERO[9:2];	//get there indexes
			access_index.ONE = access_addr.ONE[9:2];	
			access_index.TWO = access_addr.TWO[9:2];	
			access_index.THREE = access_addr.THREE[9:2];	
			
			access_tag.ZERO = access_addr.ZERO[31:10];	//get there tags
			access_tag.ONE = access_addr.ONE[31:10];	
			access_tag.TWO = access_addr.TWO[31:10];	
			access_tag.THREE = access_addr.THREE[31:10];	

			//check if each byte is a hit or not
			access_hit.ZERO = (tag[access_index.ZERO] == access_tag.ZERO) & valid[access_index.ZERO];
			access_hit.ONE = (tag[access_index.ONE] == access_tag.ONE) & valid[access_index.ONE];
			access_hit.TWO = (tag[access_index.TWO] == access_tag.TWO) & valid[access_index.TWO];
			access_hit.THREE = (tag[access_index.THREE] == access_tag.THREE) & valid[access_index.THREE];

			//miss is inverse of all hits	
			miss = ~{access_hit.THREE,access_hit.TWO,access_hit.ONE,access_hit.ZERO};
			
			//get valid bit of each byte
			valid_data = {valid[access_index.THREE],valid[access_index.TWO],valid[access_index.ONE],valid[access_index.ZERO]};			

		case(rd_type_in) //use rd_type and write enable to determin if there is a miss for each byte
			CACHE_B_RD:begin
	
				cache_miss = (miss & wr_en_in) | (miss & 4'b0001);
			end
			CACHE_H_RD:begin
				
				cache_miss = (miss & wr_en_in) | (miss & 4'b0011);
				
			end
			CACHE_W_RD:begin
				
				cache_miss = (miss & wr_en_in) | (miss & 4'b1111);
			end
			CACHE_BU_RD:begin
			
				cache_miss = (miss & wr_en_in) | (miss & 4'b0001);
			end
			CACHE_HU_RD:begin
				
				cache_miss = (miss & wr_en_in) | (miss & 4'b0011);
			end
			default:begin
				cache_miss = miss & wr_en_in;
			end
		endcase	

	
		case(rd_type) 	//use rd_type to form the data being read out 
			CACHE_B_RD:begin
				rd_data_out[31:8] = {(24){rd_data[7]}}; //sign extend
				rd_data_out[7:0] = rd_data[7:0];
	
			end
			CACHE_H_RD:begin
				rd_data_out[31:16] = {(16){rd_data[15]}};	//sign extend
				rd_data_out[15:0] = rd_data[15:0];
				
			end
			CACHE_W_RD:begin
				rd_data_out = rd_data;
			end
			CACHE_BU_RD:begin
				rd_data_out[31:8] = {(24){1'b0}};	//fill with 0s
				rd_data_out[7:0] = rd_data[7:0];
			end
			CACHE_HU_RD:begin
				rd_data_out[31:16] = {(16){1'b0}};	//fill with 0s
				rd_data_out[15:0] = rd_data[15:0];
			end
			default:begin
				rd_data_out = 'x;
			end
		endcase
	end	


	//write valid and tag data
	always_ff @(posedge clk,negedge reset_n) begin
		if(!reset_n) for(i=0;i<BLOCK_DEPTH;i=i+1)begin	//at reset reset all valids to 0
			 valid[i] <= 1'b0;
		end else begin
			if(block_wr_en.ZERO) begin 	//when writting a word in, update valid and tag
				valid[block_index.ZERO] <= 1'b1;	
				tag[block_index.ZERO] <= block_tag.ZERO;
			end
		end 
	end
		

	//instantiate 4 8x(cache_depth/4) block rams to servee as cache 
	block_ram #(.WIDTH(8), .DEPTH(BLOCK_DEPTH), .ADDR_WIDTH(8) ) block_ram_0(
		.clk,
		.wr_addr(block_index.ZERO),
		.rd_addr(block_index.ZERO), 
		.wr_data(block_wr_data.ZERO), 
		.rd_data(block_rd_data.ZERO), 
		.wr_en(block_wr_en.ZERO) 
	);
	block_ram #(.WIDTH(8), .DEPTH(BLOCK_DEPTH), .ADDR_WIDTH(8) ) block_ram_1(
		.clk,
		.wr_addr(block_index.ONE), 
		.rd_addr(block_index.ONE), 
		.wr_data(block_wr_data.ONE),
		.rd_data(block_rd_data.ONE), 
		.wr_en(block_wr_en.ONE) 
	);
	block_ram #(.WIDTH(8), .DEPTH(BLOCK_DEPTH), .ADDR_WIDTH(8) ) block_ram_2(
		.clk,
		.wr_addr(block_index.TWO),
		.rd_addr(block_index.TWO), 
		.wr_data(block_wr_data.TWO),
		.rd_data(block_rd_data.TWO), 
		.wr_en(block_wr_en.TWO) 
	);
	block_ram #(.WIDTH(8), .DEPTH(BLOCK_DEPTH), .ADDR_WIDTH(8) ) block_ram_3(
		.clk,
		.wr_addr(block_index.THREE),
		.rd_addr(block_index.THREE),
		.wr_data(block_wr_data.THREE),
		.rd_data(block_rd_data.THREE),
		.wr_en(block_wr_en.THREE) 
	);

endmodule
