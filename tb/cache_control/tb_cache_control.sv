import package_project_typedefs::*;

module tb_cache_control();

logic clk; 
logic reset_n; 
logic [3:0] instruction_cache_miss;
logic [21:0] instruction_cache_tag;
logic [31:0] instruction_mem_addr;

logic [3:0] data_cache_miss;
logic [21:0] data_cache_tag;
logic [3:0] data_cache_valid;
logic [31:0] data_mem_addr;
logic [31:0] data_mem_rd_data;

logic data_cache_stall;
logic instruction_cache_stall;
CacheWrControl cache_wr_en;
CacheRdControl cache_rd_type;
logic [31:0] cache_addr;
logic [31:0] cache_wr_data;

logic [15:0] ram_rd_data_in;
logic [15:0] ram_wr_data_out;
logic ram_wr_en;
logic [31:0] ram_wr_addr_out;
logic [31:0] ram_rd_addr_out;

cache_control dut(.*);		//cache_control dut we are testing


block_ram #(.WIDTH(16),.DEPTH(4096),.ADDR_WIDTH(32)) ram(	//16x4096 ram cache_control accessses
	.clk,
	.wr_data(ram_wr_data_out),
	.wr_addr(ram_wr_addr_out),
	.rd_addr(ram_rd_addr_out),
	.wr_en(ram_wr_en),
	.rd_data(ram_rd_data_in)
);

logic [31:0] instruction;
CacheWrControl instruction_cache_wr_en;
always_comb begin
	if(instruction_cache_stall) instruction_cache_wr_en = cache_wr_en;
	else if(data_cache_stall) instruction_cache_wr_en = CACHE_NO_WR;	//dont write to inst cache during data stall
	else instruction_cache_wr_en = cache_wr_en;
end
cache instruction_cache(	//instantiate instruction cache
	.clk,
	.reset_n,
	.addr_in(instruction_mem_addr),
	.wr_en_in(CACHE_NO_WR),
	.rd_type_in(CACHE_W_RD),
	.wr_data_in(),
	.cache_stall(instruction_cache_stall),
	.cache_wr_en(instruction_cache_wr_en),
	.cache_addr,
	.cache_wr_data,
	.cache_miss(instruction_cache_miss),
	.valid_data(),
	.rd_data_out(instruction),
	.miss_tag(instruction_cache_tag)
);

CacheWrControl data_mem_wr_en;
CacheRdControl data_mem_rd_type;
logic [31:0] data_mem_wr_data;

CacheWrControl data_cache_wr_en;
always_comb begin
	if(instruction_cache_stall) data_cache_wr_en = CACHE_NO_WR;	//dont write to data_cache during inst stall
	else if(data_cache_stall) data_cache_wr_en = cache_wr_en;
	else data_cache_wr_en = cache_wr_en;
end
cache data_cache(		//data cache
	.clk,
	.reset_n,
	.addr_in(data_mem_addr),
	.wr_en_in(data_mem_wr_en),
	.rd_type_in(data_mem_rd_type),
	.wr_data_in(data_mem_wr_data),
	.cache_stall(data_cache_stall),
	.cache_wr_en(data_cache_wr_en),
	.cache_addr,
	.cache_wr_data,
	.cache_miss(data_cache_miss),
	.valid_data(data_cache_valid),
	.rd_data_out(data_mem_rd_data),
	.miss_tag(data_cache_tag)
);


parameter CYCLE = 100;



task write_ram(integer location,integer value); //write 32 bits of data to ram
	{ram.mem[(location >> 1) + 1],
	ram.mem[location >> 1]} = value;
endtask


initial begin
	clk = 1;
	repeat (40) #(CYCLE/2) clk = ~clk;

	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	write_ram(0,32'hAABBCCDD);
	write_ram(3072,32'h11223344);
	//write_ram(2624,32'hCCBBFFAA);
	
end
initial begin
		
	reset_n = 1'b1;
		
	instruction_mem_addr = 32'd0;

	data_mem_addr = 32'd1601;
	data_mem_wr_en = CACHE_NO_WR;
	data_mem_rd_type = CACHE_NO_RD;
	data_mem_wr_data = 32'h00998811;

	#(CYCLE * 1/4)	
	#0
	reset_n = 1'b0;

	#CYCLE	
	#0
	reset_n = 1'b1;	
	
	instruction_mem_addr = 32'd0;	//shoudl handle instruction miss first

	data_mem_addr = 32'd1601;
	data_mem_wr_en = CACHE_W_WR;
	data_mem_rd_type = CACHE_B_RD;	//then handle one data misses at 1600 and another at 1604
					//there is no valid data so there
					//should be no write back
	data_mem_wr_data = 32'hAA998811;	 


	#(CYCLE	* 24)
	#0
	instruction_mem_addr = 32'd3072;	//handle inst miss first

	data_mem_addr = 32'd2627;		//there should be miss, and the previous data should bo written back to ram
	data_mem_wr_en = CACHE_B_WR;
	data_mem_rd_type = CACHE_NO_RD;
	data_mem_wr_data = 32'h009988DD;


	#(CYCLE	* 24)
	#0
	instruction_mem_addr = 32'd3072;

	data_mem_addr = 32'd2627;
	data_mem_wr_en = CACHE_B_WR;
	data_mem_rd_type = CACHE_W_RD;	//there should be another data miss
	data_mem_wr_data = 32'h009988DD;




end
endmodule
