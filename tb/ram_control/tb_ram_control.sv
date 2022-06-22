import package_project_typedefs::*;

module tb_ram_control();

logic clk; 
logic reset_n; 
logic ram_wr_start;
logic ram_rd_start;
logic [31:0] ram_wr_addr_base;
logic [31:0] ram_wr_data_in;
logic [31:0] ram_rd_addr_base;
logic [15:0] ram_rd_data_in;

logic ram_wr_done;
logic ram_rd_done;
logic [31:0] ram_rd_data_out;
logic [15:0] ram_wr_data_out;
logic ram_wr_en;
logic [31:0] ram_rd_addr;
logic [31:0] ram_wr_addr;

//instantiate ram to test ram_control
block_ram #(.WIDTH(16),.DEPTH(4096),.ADDR_WIDTH(32)) ram(
	.clk,
	.wr_data(ram_wr_data_out),
	.wr_addr(ram_wr_addr),
	.rd_addr(ram_rd_addr),
	.wr_en(ram_wr_en),
	.rd_data(ram_rd_data_in)
);


///instantiate ram_control module to test
ram_control dut(.*);

parameter CYCLE = 100;

initial begin //clock signal
	clk = 1;
	repeat (40) #(CYCLE/2) clk = ~clk;

	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	
	reset_n = 1'b1;

	ram_wr_start = 1'b0;	
	ram_rd_start = 1'b0;	
	ram_wr_addr_base = 32'd4086;	
	ram_wr_data_in = 32'hAABBCCDD;	
	ram_rd_addr_base = 32'd4086;	
	
	#CYCLE	
	#0
	reset_n = 1'b0;

	#CYCLE	
	#0
	reset_n = 1'b1;	
	
	#CYCLE	
	#0
	//set ram writting process
	ram_wr_start = 1'b1;	
	ram_rd_start = 1'b0;	
	ram_wr_addr_base = 32'd4086; 
	ram_wr_data_in = 32'hAABBCCDD;	
	ram_rd_addr_base = 32'd4086;

	//AABB should be written to addr 4087		
	//CCDD should be written to addr 4086


	////test reading process
	#(CYCLE	* 4)
	#0
	ram_wr_start = 1'b0;	
	ram_rd_start = 1'b1;	
	ram_wr_addr_base = 32'd55;	
	ram_wr_data_in = 32'hAABBCCDD;	
	ram_rd_addr_base = 32'd4086;	
	
	///should read AABBCCDD from 4086

	
end
endmodule
