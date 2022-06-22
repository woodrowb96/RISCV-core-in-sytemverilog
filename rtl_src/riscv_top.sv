/*
this module is the projects top it contains the 
	riscv core
	ram
	
*/
module riscv_top(
	input logic clk,
	input logic reset_n

);

logic [15:0] ram_rd_data_in;	//ram signals
logic [15:0] ram_wr_data_out;
logic ram_wr_en;
logic [31:0] ram_rd_addr_out;
logic [31:0] ram_wr_addr_out;


	riscv_core riscv_core(		//core
		.clk,
		.reset_n,
		.ram_rd_data_in,
		.ram_wr_data_out,
		.ram_wr_en,
		.ram_rd_addr_out,
		.ram_wr_addr_out
	);

	//16x8192 block ram to serve as 4k of ram
	block_ram #(.WIDTH(16),.DEPTH(8192),.ADDR_WIDTH(32)) ram(
	.clk,
	.wr_data(ram_wr_data_out),
	.wr_addr(ram_wr_addr_out),
	.rd_addr(ram_rd_addr_out),
	.wr_en(ram_wr_en),
	.rd_data(ram_rd_data_in)
	);


endmodule
