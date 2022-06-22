//disconect branch, zero and immediate from there
//modules in the data_path

module tb_instruction_memory();
logic clk;
logic [31:0] addr;
logic [31:0] instruction;

instruction_memory #(.INST_MEM_DEPTH(2048)) dut(.*);


parameter CYCLE = 100;
parameter im_depth = 512;
integer i;

initial begin

	for(i=0;i < im_depth;i=i+1) begin
		{dut.block_ram_3.mem[i],
		dut.block_ram_2.mem[i],
		dut.block_ram_1.mem[i],
		dut.block_ram_0.mem[i]} = i;
	end
end

initial begin
	clk = 1;
	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	
		
	#CYCLE
	#0
	addr = 32'd0;
	#CYCLE 
	#0
	addr = 32'd4;

	#(CYCLE*2)
	#0
	addr = 32'd5;
	
	#CYCLE
	#0
	addr = 32'd2044;

	#CYCLE 
	#0
	addr = 32'd2048;

	
end
endmodule
