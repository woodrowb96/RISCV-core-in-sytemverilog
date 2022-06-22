/*
this module is the state machine that controls the cache miss and write back
	it is responsible for loading 1 word of data from ram into cache, during a miss 
	and writting back 1 word of data to ram whenecer a valid peice of data in cache is replaced

IDLE: state machine waits for a miss to accure
WRITE_BACK:state machine reads valid data from cache at miss address, and writes that data back to ram
READ_RAM: state machine reads new data from ram
UPDATE_CACHE:state_machien takes control of cache and writes the newly read data to it

loads and writes to ram are initiated by sending start signals to the ram_control_state machine 
	this module supplies the ram_control_state machine with the appropriate address and data needed for ram accesses

*/
import package_project_typedefs::*;

module cache_control_state_machine(
	input logic clk,
	input logic reset_n,

	input logic miss,	//miss is set whenever a miss occurs
	input logic valid,	//valid is set if data at miss address is valid,and needs to be written back to ram
	input logic[21:0] tag,	//tag of the valid data that is already in cache
	input logic[31:0] miss_addr,	//address of miss
	input logic[31:0] miss_rd_data,	//data beign read out of cache at miss address
	
	input logic ram_wr_done,	//output from ram_control to indicate all 1 word has been written to ram
	input logic ram_rd_done,	//output from ram_control to indicate all 1 word has been read from  ram
	input logic[31:0] ram_rd_data,	//1 word of data read from ram

	output logic ram_wr_start,	//used to tell ram_control to begin writting process
	output logic ram_rd_start,	//used to tell ram_control to begin reading process
	output logic[31:0] ram_wr_addr,	//address to be written in ram
	output logic[31:0] ram_rd_addr,	//addr to be read from in ram
	output logic[31:0] ram_wr_data,	//data to be written to ram

	output CacheWrControl cache_wr_en,	//used to enable writting to cache
	output CacheRdControl cache_rd_type,	//used to set how data is read from cache
	output logic[31:0] cache_addr,		//address by cache control to to access cache
	output logic[31:0] cache_wr_data	//data cache control wants to writte to cache


);

	enum logic[1:0] {
		IDLE,
		WRITE_BACK_RAM,
		READ_RAM,
		UPDATE_CACHE}present_state,next_state;

	always_ff @(posedge clk,negedge reset_n) //state register
		if(!reset_n) present_state <= IDLE;
		else present_state <= next_state;

	assign ram_rd_addr = miss_addr >> 1;	//ram is 16 bits wide,so divide miss addr by 2
	assign ram_wr_data = miss_rd_data;	//data written to ram is the data read from miss addr
	assign cache_rd_type = CACHE_W_RD;	//always read 1 word from cache
	assign cache_addr = miss_addr;		//cache access address is miss_address
	assign ram_wr_addr = {'0,tag,miss_addr[9:1]};	//use tag and miss addr to get addr of valid data in cache
		
	//output and next state logic 
	always_comb begin
		case(present_state)
			IDLE:begin //wait for miss
				ram_wr_start = 1'b0;	//dont wr or rd from ram
				ram_rd_start = 1'b0;
				cache_wr_en = CACHE_NO_WR;	//dont wr to cache
				cache_wr_data = ram_rd_data;

				if(miss & valid) next_state = WRITE_BACK_RAM; //if miss with valid data in cache, then write_back	
				else if(miss & ~valid) next_state = READ_RAM;	//if miss and no valid data,skip write back	
				else next_state = IDLE;
			end
			WRITE_BACK_RAM:begin	
				ram_wr_start = 1'b1;	//tell ram_control to write 32bits to ram
				ram_rd_start = 1'b0;
				cache_wr_en = CACHE_NO_WR;	
				cache_wr_data = ram_rd_data;

				if(ram_wr_done) next_state = READ_RAM; //once all 32bits have been written move to read new data from ram
				else next_state = WRITE_BACK_RAM;
			end
			READ_RAM:begin
				ram_wr_start = 1'b0;
				ram_rd_start = 1'b1;	//tell ram to read 32 bits 
				cache_wr_en = CACHE_NO_WR;
				cache_wr_data = ram_rd_data;

				if(ram_rd_done) next_state = UPDATE_CACHE;	//once all 32 bits have been read update cache
				else next_state = READ_RAM;
			end
			UPDATE_CACHE:begin
				ram_wr_start = 1'b0;	//not rd or wr to ram
				ram_rd_start = 1'b0;
				cache_wr_en = CACHE_W_WR;	//write 1 word to ram
				cache_wr_data = ram_rd_data;

				next_state = IDLE;	//go back to idle
			end
			default:begin
				ram_wr_start = 1'b0;
				ram_rd_start = 1'b0;
				cache_wr_en = CACHE_NO_WR;
				cache_wr_data = ram_rd_data;

				next_state = IDLE;
			end
		endcase
	end

endmodule
