import package_project_typedefs::*;

module tb_branch_decision();

//input signals
logic clk;
logic reset_n;

logic [31:0] reg_file_rd_data_1;
logic [31:0] reg_file_rd_data_2;
logic [31:0] immediate;
logic [31:0] pc;
BranchControl branch_type;
logic branch_decision;
logic [31:0] branch_target;

parameter CYCLE = 100; //clock cycle     

integer i;

//instantiate data pat
branch_decision_unit dut(.*);

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end

initial begin

	//branch_decision should be 0 for non branch inst
	branch_type = NO_JUMP_BRANCH; 
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;
	immediate = 32'd20;	
	pc = 32'd100;			//target shoudl be imm + pc = 120
	#CYCLE

	branch_type = BRANCH_EQ;  	
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;
	
	#CYCLE
	branch_type = BRANCH_EQ;
	reg_file_rd_data_1 = 32'd6;
	reg_file_rd_data_2 = 32'd5;
	
	#CYCLE
	branch_type = BRANCH_NE;
	reg_file_rd_data_1 = 32'd6;
	reg_file_rd_data_2 = 32'd5;
	
	#CYCLE
	branch_type = BRANCH_NE;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;

	#CYCLE
	branch_type = BRANCH_LT;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_LT;
	reg_file_rd_data_1 = -32'd6;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_LT;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd6;

	#CYCLE
	branch_type = BRANCH_GE;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_GE;
	reg_file_rd_data_1 = 32'd6;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_GE;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd6;
	
	#CYCLE
	branch_type = BRANCH_LTU;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_LTU;	//ltu should be false even though lt for these same operands would be true
	reg_file_rd_data_1 = -32'd6;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_LTU;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = -32'd6;
		
	#CYCLE
	branch_type = BRANCH_GEU;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_GEU;
	reg_file_rd_data_1 = -32'd6;
	reg_file_rd_data_2 = 32'd5;
	#CYCLE
	branch_type = BRANCH_GEU;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = -32'd6;
	#CYCLE
	branch_type = JUMP_AL;
	reg_file_rd_data_1 = 32'd5;
	reg_file_rd_data_2 = -32'd6;
	#CYCLE
	branch_type = JUMP_ALR;
	reg_file_rd_data_1 = 32'd5;	//target shoudl be rs1 + imm = 25
	reg_file_rd_data_2 = -32'd6;
	
	
end

endmodule
