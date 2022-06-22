import package_project_typedefs::*;

module tb_alu();

AluControl alu_op;
logic [31:0] in_a;
logic [31:0] in_b;
logic [31:0] result;
logic zero;

alu  dut(.*);

parameter CYCLE = 100;

initial begin

	alu_op = ALU_ADD;
	in_a = 32'd0;
	in_b = 32'd0;
	
	#CYCLE 
	alu_op = ALU_ADD;
	in_a = 32'd1;
	in_b = 32'd0;

	#CYCLE 
	
	alu_op = ALU_ADD;
	in_a = 32'd1;
	in_b = -32'd2;
	
	#CYCLE 
	alu_op = ALU_ADD;
	in_a = 32'hFFFFFFFF;
	in_b = 32'hFFFFFFFF;
	
	#CYCLE
	alu_op = ALU_SUB;
	in_a = 32'd0;
	in_b = 32'd0;
	
	#CYCLE 
	alu_op = ALU_SUB;
	in_a = 32'd1;
	in_b = 32'd0;

	#CYCLE 
	
	alu_op = ALU_SUB;
	in_a = 32'd1;
	in_b = -32'd2;
	
	#CYCLE 
	alu_op = ALU_SUB;
	in_a = 32'h00000000;
	in_b = 32'hFFFFFFFF;

	#CYCLE 
	alu_op = ALU_SHIFT_L;
	in_a = 32'hFDCDEF1F;
	in_b = {27'd0,5'd16};

	#CYCLE 
	alu_op = ALU_SHIFT_RL;
	in_a = 32'hFDCDEF1F;
	in_b = {27'd0,5'd16};

	#CYCLE 
	alu_op = ALU_SHIFT_RA;
	in_a = 32'hFDCDEF1F;
	in_b = {2'b01,25'd0,5'd16};

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = 32'd1;
	in_b = 32'd5;

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = 32'd1;
	in_b = 32'd0;

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = 32'd1;
	in_b = -32'd5;

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = -32'd5;
	in_b = 32'd0;

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = -32'd5;
	in_b = -32'd1;

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = -32'd5;
	in_b = -32'd34;

	#CYCLE 
	alu_op = ALU_SET_LT;
	in_a = 32'h5;
	in_b = 32'h5;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = 32'h5;
	in_b = 32'h5;


	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = 32'd1;
	in_b = 32'd5;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = 32'd1;
	in_b = 32'd0;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = 32'd1;
	in_b = -32'd5;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = -32'd5;
	in_b = 32'd0;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = -32'd5;
	in_b = -32'd1;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = -32'd5;
	in_b = -32'd34;

	#CYCLE 
	alu_op = ALU_SET_LTU;
	in_a = 32'hFF0000FF;
	in_b = 32'hFFFF0F00;

	#CYCLE 
	alu_op = ALU_XOR;
	in_a = 32'hFF0000FF;
	in_b = 32'hFFFF0F00;
	
	#CYCLE 
	alu_op = ALU_OR;
	in_a = 32'hFF0000FF;
	in_b = 32'hFFFF0F00;
	
	#CYCLE 
	alu_op = ALU_AND;
	in_a = 32'hFF0000FF;
	in_b = 32'hFFFF0F00;
	
	#CYCLE 
	alu_op = ALU_PASS_A;
	in_a = 32'hAAAAAAAA;
	in_b = 32'hBBBBBBBB;

	#CYCLE 
	alu_op = ALU_PASS_B;
	in_a = 32'hAAAAAAAA;
	in_b = 32'hBBBBBBBB;
	#CYCLE 
	alu_op = ALU_PC_INC;
	in_a = 32'd0;
	in_b = 32'hBBBBBBBB;





end

endmodule
