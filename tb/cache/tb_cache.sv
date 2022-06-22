import package_project_typedefs::*;

module tb_cache();

logic clk; 
logic reset_n; 
CacheWrControl wr_en_in;
CacheRdControl rd_type_in;
CacheRdControl cache_rd_type;
logic [31:0] addr_in;
logic [31:0] wr_data_in;
logic [31:0] rd_data_out;

logic cache_stall;
CacheWrControl cache_wr_en;
logic [31:0] cache_addr;
logic [31:0] cache_wr_data;

logic [3:0] cache_miss;
logic [21:0] miss_tag;
logic [3:0] valid_data;

cache #(.CACHE_SIZE(1024)) dut(.*);	//cache device under test

parameter CYCLE = 100;


initial begin
	clk = 1;
	repeat (40) #(CYCLE/2) clk = ~clk;

	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd0;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_NO_RD;
	cache_addr = 32'd0;
	cache_wr_en = CACHE_NO_WR;
	cache_wr_data = 32'h11223344;

	#CYCLE	
	#0
	reset_n = 1'b0;

	#CYCLE	
	#0
	reset_n = 1'b1;	
	
	#CYCLE	
	#0
	reset_n = 1'b1;			//test not reading or writting
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd0;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_NO_RD;
	cache_addr = 32'd0;
	cache_wr_en = CACHE_NO_WR;
	cache_wr_data = 32'h11223344;

	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;	//cache_miss shoudl be 0000 since we are not rd or wr
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd0;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b1;		//control shoudl be given to cache_control
	cache_rd_type = CACHE_W_RD;	//test reading with cache control
	cache_addr = 32'd900;
	cache_wr_en = CACHE_B_WR;	//test writting
	cache_wr_data = 32'h11223344;

	
	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd0;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b1;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd900;
	cache_wr_en = CACHE_H_WR;	//test writting half word
	cache_wr_data = 32'h11223344;


	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd0;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b1;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd900;
	cache_wr_en = CACHE_W_WR;	//test writting word
	cache_wr_data = 32'h11223344;


	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd0;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b1;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;		//test missaligned rd and write
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd986;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;	//cache_control signals should no longer be contr cache
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_B_RD;	//test byte rd
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd1927;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;


	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_H_WR;		//test halfword write
	addr_in = 32'd1927;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_W_RD;
	wr_en_in = CACHE_H_WR;
	addr_in = 32'd2951;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;



	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_B_RD;
	wr_en_in = CACHE_W_WR;	//test word write
	addr_in = 32'd3975;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;


	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_NO_RD;
	wr_en_in = CACHE_H_WR;
	addr_in = 32'd4575;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;



	#CYCLE	
	#0
	reset_n = 1'b1;
	rd_type_in = CACHE_BU_RD;
	wr_en_in = CACHE_NO_WR;
	addr_in = 32'd5975;
	wr_data_in = 32'hAABBCCDD;
	cache_stall = 1'b0;	
	cache_rd_type = CACHE_W_RD;
	cache_addr = 32'd903;
	cache_wr_en = CACHE_W_WR;
	cache_wr_data = 32'hAABBCCDD;



end
endmodule
