module tb_register_file();

logic clk; 
logic  reg_file_wr_en;
logic [4:0] rd_addr_1;
logic [4:0] rd_addr_2;
logic [4:0] wr_addr;
logic [31:0] rd_data_2;
logic [31:0] rd_data_1;
logic [31:0] data_in;


register_file  dut(.*);


parameter CYCLE = 100;

//task to write a value into the register file at location
task write_reg_file(integer location, integer value);
	dut.register_file.reg_file[location] = value;
endtask

initial begin
	clk = 1;
	repeat (40) #(CYCLE/2) clk = ~clk;

	forever #(CYCLE/2) clk = ~clk;
end

initial begin

	reg_file_wr_en = 1'b0;
	wr_addr = 32'd0;
	data_in = 32'd1;
	rd_addr_1 = 32'd0;
	rd_addr_2 = 32'd0;


	write_reg_file(1,1);
	write_reg_file(2,2);
	
	#(CYCLE) //test reading from x1,x2
	reg_file_wr_en =  1'b0;
	wr_addr = 32'd0;
	data_in = 32'd1;
	rd_addr_1 = 32'd1;
	rd_addr_2 = 32'd2;
	
	#CYCLE 
	#0
	reg_file_wr_en = 1'b1 ;
	wr_addr = 32'd3;
	data_in = 32'd3;
	rd_addr_1 = 32'd3;
	rd_addr_2 = 32'd4;
	
	#CYCLE
	#0
	reg_file_wr_en = 1'b1 ;
	wr_addr = 32'd4;
	data_in = 32'h0000F0F0;
	rd_addr_1 = 32'd1;
	rd_addr_2 = 32'd1;
	
	#CYCLE
	#0
	reg_file_wr_en = 1'b1 ;
	wr_addr = 32'd5;
	data_in = 32'h0000F0F0;
	rd_addr_1 = 32'd1;
	rd_addr_2 = 32'd1;
	
	#CYCLE
	#0
	reg_file_wr_en = 1'b1 ;
	wr_addr = 32'd6;
	data_in = 32'h000000F0;
	rd_addr_1 = 32'd1;
	rd_addr_2 = 32'd1;
	
	#CYCLE
	#0
	reg_file_wr_en = 1'b1 ;
	wr_addr = 32'd7;
	data_in = 32'h000000F0;
	rd_addr_1 = 32'd1;
	rd_addr_2 = 32'd1;
	
	#CYCLE
	#0 
	reg_file_wr_en =  1'b0;
	wr_addr = 32'd2;
	data_in = 32'd2;
	rd_addr_1 = 32'd2;
	rd_addr_2 = 32'd2;


		
end
endmodule
