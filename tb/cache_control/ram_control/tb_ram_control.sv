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

block_ram #(.WIDTH(16),.DEPTH(4096),.ADDR_WIDTH(32)) ram(
	.clk,
	.wr_data(ram_wr_data_out),
	.wr_addr(ram_wr_addr),
	.rd_addr(ram_rd_addr),
	.wr_en(ram_wr_en),
	.rd_data(ram_rd_data_in)
);

ram_control dut(.*);

parameter CYCLE = 100;


//taskt to write a 4 byte value into instruction mem block ram at location
/*task write_mem(integer location,integer value);
	{dut.block_ram_3.mem[location],
	dut.block_ram_2.mem[location],
	dut.block_ram_1.mem[location],
	dut.block_ram_0.mem[location]} = value; 
endtask
*/

initial begin
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
	ram_wr_start = 1'b1;	
	ram_rd_start = 1'b0;	
	ram_wr_addr_base = 32'd4086;	
	ram_wr_data_in = 32'hAABBCCDD;	
	ram_rd_addr_base = 32'd4086;	

	#CYCLE	
	#0
	ram_wr_start = 1'b0;	
	ram_rd_start = 1'b1;	
	ram_wr_addr_base = 32'd55;	
	ram_wr_data_in = 32'hAABBCCDD;	
	ram_rd_addr_base = 32'd4086;	


	
end
endmodule
