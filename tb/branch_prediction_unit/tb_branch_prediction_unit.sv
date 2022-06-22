import package_project_typedefs::*;

module tb_branch_prediction_unit();

//input signals
logic clk;
logic reset_n;

logic stall;

PipeLineSignal_32 pc;
PipeLineSignal_32 instruction;
logic branch_decision;
logic branch_prediction;
logic [31:0] branch_target_ID;

logic branch_redo;
logic [31:0] branch_target_IF;

parameter CYCLE = 100; //clock cycle     

integer i;

//instantiate data pat
branch_prediction_unit dut(.*);

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end


initial begin
	

	pc.IF= 32'd0;	
	pc.ID= 32'd0;	
	instruction.IF = M_ADD;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b0;	
	branch_target_ID = 32'd0;
	stall = 1'b0;
	reset_n = 1'b1;	
	#CYCLE
	#0
	reset_n = 1'b0;	
//////////////////////

	#CYCLE	//test not taking branch 
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd4;	
	pc.ID= 32'd0;	
	instruction.IF = M_BEQ;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b0;	
	branch_target_ID = 32'd27;

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_BEQ;	
	branch_decision = 1'b0;	
	branch_target_ID = 32'd27;

	//prediction state shoudl be 0, and we never shoudl have predicted
	//a take
//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test not taking branch twice in a row
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_BEQ;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b0;	
	branch_target_ID = 32'd27;

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_BEQ;	
	branch_decision = 1'b1;	
	branch_target_ID = 32'd27;
		
	//prediction state should still be zero
//////////////////////
	#CYCLE		//test taking branch 
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_BEQ;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//prediction shoudl be zero
	branch_target_ID = 32'd27;

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_BEQ;	
	branch_decision = 1'b1;		//branch redo should be set
	branch_target_ID = 32'd30;

	//state should be 1
//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test taking branch second time
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_BEQ;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;	
	branch_target_ID = 32'd0;

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_BEQ;	
	branch_decision = 1'b1;		//branch redo shoudl be set	
	branch_target_ID = 32'd37;

	//state should be 2
//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test taking branch thid time
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_BEQ;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;	
	branch_target_ID = 32'd0;

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_BEQ;	
	branch_decision = 1'b1;		//branch redo should not be set	
	branch_target_ID = 32'd37;

	//state should be 3

//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jal second time
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_JAL;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd20; //predicted target should be zero

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_JAL;	
	branch_decision = 1'b1;		//branch redo shoudl be set	
	branch_target_ID = 32'd20;	//branch target should be updated
//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jal second time
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_JAL;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd20; //predicted target should be 20

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_ADD;	
	instruction.ID = M_JAL;	
	branch_decision = 1'b1;		//branch redo should not be set	
	branch_target_ID = 32'd20;	



//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jal second time
	pc.IF= 32'd4;	
	pc.ID= 32'd0;	
	instruction.IF = M_JAL;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd20; //predicted target should be zero

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd4;	
	instruction.IF = M_JAL;	
	instruction.ID = M_JAL;	
	branch_decision = 1'b1;		//branch redo shoudl be set	
	branch_target_ID = 32'd20;	//branch target should be updated



//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jalr
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_JALR;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd99; //predicted target should be 20

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd8;	
	instruction.IF = M_ADD;	
	instruction.ID = M_JALR;	
	branch_decision = 1'b1;		//branch redo shoudl be set	
	branch_target_ID = 32'd99;	//branch target should be updated


//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jalr
	pc.IF= 32'd4;	
	pc.ID= 32'd8;	
	instruction.IF = M_JALR;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd99; //predicted target should be 99

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd8;	
	pc.ID= 32'd8;	
	instruction.IF = M_ADD;	
	instruction.ID = M_JALR;	
	branch_decision = 1'b1;		//branch redo should not be set	
	branch_target_ID = 32'd99;	//branch target should be updated


//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jalr
	pc.IF= 32'd20;	
	pc.ID= 32'd8;	
	instruction.IF = M_BGE;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd99; //predicted target should be 99

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd4;	
	pc.ID= 32'd20;	
	instruction.IF = M_JALR;	
	instruction.ID = M_BGE;	
	branch_decision = 1'b1;		//branch redo should not be set	
	branch_target_ID = 32'd99;	//branch target should be updated

//////////////////////
	#CYCLE
	#0
	reset_n = 1'b1;		//test jalr
	pc.IF= 32'd20;	
	pc.ID= 32'd8;	
	instruction.IF = M_BGE;	
	instruction.ID = M_ADD;	
	branch_decision = 1'b1;		//predicted decision should be 1
	branch_target_ID = 32'd99; //predicted target should be 99

	#CYCLE
	#0
	reset_n = 1'b1;	
	pc.IF= 32'd4;	
	pc.ID= 32'd20;	
	instruction.IF = M_JALR;	
	instruction.ID = M_BGE;	
	branch_decision = 1'b1;		//branch redo should not be set	
	branch_target_ID = 32'd99;	//branch target should be updated















end

endmodule
