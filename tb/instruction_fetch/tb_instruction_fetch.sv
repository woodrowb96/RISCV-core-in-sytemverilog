module tb_instruction_fetch();

//input signals
logic clk;
logic reset_n;

logic jump_branch_condition;
logic [31:0] jump_branch_address;
logic [31:0] pc;
logic [31:0] instruction;

              
parameter CYCLE = 100; //clock cycle     
parameter MEM_DEPTH = 2048;

integer i;
integer imm; 
logic [31:0] machine_code;

//instantiate data path 
instruction_fetch dut(.*);

//taskt to write a 4 byte value into instruction mem block ram at location
task write_inst_mem(integer location,integer value);

	{dut.instruction_memory.block_ram_3.mem[location],
	dut.instruction_memory.block_ram_2.mem[location],
	dut.instruction_memory.block_ram_1.mem[location],
	dut.instruction_memory.block_ram_0.mem[location]} = value; 

endtask

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end


//initialiaze instr memory
initial begin	
	for(i=0;i < MEM_DEPTH/4;i=i+1) begin
		write_inst_mem(i,i*4); //each location hold value of pc that pints at location
	end
end

initial begin

	reset_n = 1;
	jump_branch_condition = 1'b0;
	jump_branch_address = 32'd444;

	#CYCLE
	#0

	reset_n = 0;
	#CYCLE
	#0

	reset_n = 1;
	
	#(CYCLE*2)
	#0

	jump_branch_condition = 1'b1;
	
	#CYCLE
	#0

	jump_branch_condition = 1'b1;
	jump_branch_address = 32'd112;

	
	#CYCLE
	#0

	jump_branch_condition = 1'b0;
	jump_branch_address = 32'd250;
end

endmodule
