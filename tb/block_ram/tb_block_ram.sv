module tb_block_ram();

//input signals
logic clk;
logic reset_n;
logic [7:0] data_in;
logic [7:0] data_out;
logic wr_en;
logic [31:0] addr;

parameter CYCLE = 100; //clock cycle//instantiate data path 

block_ram #(.WIDTH(8), .DEPTH(8),.ADDR_WIDTH(32)) dut(.*);

task write_ram(integer location, integer value);
	dut.mem[location] = value;
endtask

integer i;
initial begin
	for(i = 0; i < 8;i = i + 1)
		write_ram(i,8'hFF);
end

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	
	wr_en = 0;
	data_in = 8'd0;
	addr = 8'd0;

/////test_writting///////////	
////mem should not get written until next clock cycle////
	#CYCLE //test writting to addr 0
	#0
	wr_en = 1;
	data_in = 8'h00;
	addr = 8'd0;


	#CYCLE //testing writing  when wr_en is not set
	#0
	wr_en = 0;
	data_in = 8'h01;
	addr = 8'd1

	#CYCLE //test writting when wr_en is set
	#0 
	wr_en = 1;
	data_in = 8'd1;
	addr = 8'd1;

	#CYCLE //test writting to another addr
	#0
	wr_en = 1;
	data_in = 8'd2;
	addr = 8'd2;
/////test reading/////
	#CYCLE 
	#0
	wr_en = 0;
	data_in = 8'd1;
	addr = 8'd0;

	#CYCLE 
	#0
	wr_en = 0;
	data_in = 8'd1;
	addr = 8'd1;

	#CYCLE 
	#0
	wr_en = 0;
	data_in = 8'd1;
	addr = 8'd2;



end
endmodule
