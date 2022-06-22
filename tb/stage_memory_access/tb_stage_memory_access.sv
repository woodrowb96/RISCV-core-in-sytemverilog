import package_project_typedefs::*;

module tb_stage_memory_access();

//input signals
logic clk;
logic reset_n;

logic [31:0] reg_file_wr_addr_in;
logic [31:0] reg_file_wr_addr_out;
logic zero;
logic [31:0] data_mem_wr_data,data_mem_rd_data;
JumpBranchControl jump_branch_signal;
DataMemWrControl data_mem_wr_en;
logic [31:0] jump_branch_addr_in;
logic [31:0] jump_branch_addr_out;
logic [31:0] alu_result_in;
logic [31:0] alu_result_out;
logic pc_sel;

parameter CYCLE = 100; //clock cycle     

integer i;

//instantiate data pat
stage_memory_access dut(.*);

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end

initial begin

	reset_n = 1;

	data_mem_wr_data = 32'd500;
	alu_result_in = 32'd0;
	zero = 1'b0;
	jump_branch_signal = JUMP_BRANCH_NO;
	data_mem_wr_en = DATA_MEM_NO_WR;

	#CYCLE
	#0
	reset_n = 0;	
	
	data_mem_wr_data = 32'd500;
	alu_result_in = 32'd0;
	zero = 1'b0;
	jump_branch_signal = BRANCH_EQ;
	data_mem_wr_en = DATA_MEM_W_WR;

	#CYCLE
	#0
	reset_n = 0;	
	
	data_mem_wr_data = 32'd550;
	alu_result_in = 32'd1;
	zero = 1'b0;
	jump_branch_signal = BRANCH_NE;
	data_mem_wr_en = DATA_MEM_W_WR;

	#CYCLE
	#0
	reset_n = 0;	
	
	data_mem_wr_data = 32'd600;
	alu_result_in = 32'd1;
	zero = 1'b0;
	jump_branch_signal = JUMP_ALR;
	data_mem_wr_en = DATA_MEM_W_WR;




end

endmodule
