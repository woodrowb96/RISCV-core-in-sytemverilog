/*
This predicts branch branch decision and target in the instruction fetch stage,before it has been calcuted in inst decode

branch decisions are predicted using a two bit saturation counter stored in the branch prediciton buffer
branch targets are predicted by storin the target addresses of a branch inst in the branch target buffer 
	this target is updated to the most recent target address whenever a branch inst is decoded in the ID stage
JAL and JALR target addresses are stored in a seperate jump target buffer

branch inst are mapped into the 8 deep buffers using bits 4:2 of there address

this module also looks at the correct branch decision and target that has been calulcated in instruction decode and determines if
the if there was an incorrect prediction

if an incorrect prediction has occured branch_redo is set
 
*/
import package_project_typedefs::*;

module branch_prediction_unit(

	input logic clk,
	input logic reset_n,

	input logic stall,	//stall signal from cache

	input PipeLineSignal_32 pc, //pc pipeline struct, used to access pc in inst fetch and inst decode stages
	input logic branch_decision,	//branch decision from instruction decode
	input PipeLineSignal_32 instruction,	//instruction pipeline struct, used to access instruction in inst fetch and inst decode
	input logic [31:0] branch_target_ID,	//branch target calculated in instruction decode stage
	
	output logic branch_prediction,		//branch prediction is 1 if branch is predicted to be taken, 0 if not
	output logic branch_redo,		//1 if a branch is needed to be redon
	output logic [31:0] branch_target_IF	//branch target prediction
);

typedef enum logic[1:0]{	//saturation counter states
	STRONG_NOT_TAKE = 2'b00,
	WEAK_NOT_TAKE   = 2'b01,
	WEAK_TAKE       = 2'b10,
	STRONG_TAKE     = 2'b11}BranchPredictionState;

logic [1:0] branch_pred_buffer [7:0]; //branch prediction buffer to hold prediction states

logic [31:0] branch_target_buffer [7:0]; //branch target buffer to hold target address prediction
logic [31:0] jump_target_buffer [7:0];	//jump

logic wrong_take_prediction;	//used to hold condition when branch was taken,when it shoudl not have been taken
logic wrong_not_take_prediction;	//used to hold  condition where branch was not taken,when it should have been taken
logic wrong_target_jump;		//used to hold condition when branch jumped to the wrong target
logic wrong_target_branch;		//used to hold condition when branch jumped to the wrong target

PipeLineSignal_RiscvOpcodes opcode;	//struct to hold opcode of instructions in inst fetch, and inst decode stages

logic [2:0] rd_addr_IF;		//address to read buffer info for branches in inst fetch 
logic [2:0] rd_addr_ID;		//address to read buffer info for branches in inst decode
logic [2:0]  wr_addr_ID;	//addr to write buffer information for branch in inst decode

BranchPredictionState state_IF;		//prediction state of branch in inst fetch 
BranchPredictionState state_ID;		//prediction state of branch in inst decode	

integer i; // integer used to move through for loop

	assign rd_addr_IF = pc.IF[4:2];	//bits 4:2 are used to map inst to location in buffer
	assign rd_addr_ID = pc.ID[4:2];
	assign wr_addr_ID = pc.ID[4:2];

	assign opcode.IF = RiscvOpcodes'(instruction.IF[6:0]);	//pick out opcode from instruction
	assign opcode.ID = RiscvOpcodes'(instruction.ID[6:0]);

	assign state_IF = BranchPredictionState'(branch_pred_buffer[rd_addr_IF]);	//read current states from prediction buffer
	assign state_ID = BranchPredictionState'(branch_pred_buffer[rd_addr_ID]);


	always_comb begin	//determine branch prediction 
		if((opcode.IF == OP_BRANCH)) //if  instruction is a branch need to look at current state to determine prediction
			if((state_IF == STRONG_TAKE) || (state_IF == WEAK_TAKE)) branch_prediction = 1'b1;	
			else branch_prediction = 1'b0;
		else if (opcode.IF == OP_JALR) branch_prediction = 1'b1;	//jump instructions are always taken
		else if(opcode.IF == OP_JAL) branch_prediction = 1'b1;
		else branch_prediction = 1'b0; 		//if inst is not a jump or branch do not take
	end
		
	//update prediction buffer	
	always_ff @(posedge clk,negedge reset_n) 
		if(!reset_n) for(i=0;i<8;i=i+1) branch_pred_buffer[i] <= WEAK_NOT_TAKE;	//during reset, reset states to weak_not_take
		else if((opcode.ID == OP_BRANCH) & ~stall)  begin //
			if(branch_decision == 1'b1) begin	//if branch was taken increment counter unless we are in top state
				if(state_ID != STRONG_TAKE) 
					branch_pred_buffer[wr_addr_ID] <= state_ID + 2'd1;
			end else begin	//if branch was not taken decrement counter unless we are in bottom state 
				if(state_ID != STRONG_NOT_TAKE)
					branch_pred_buffer[wr_addr_ID] <= state_ID - 2'd1;
			end
		end


	//if branch decision is not take, but we predicted had predicted take	
	assign wrong_take_prediction = ~branch_decision && ((state_ID == STRONG_TAKE) || (state_ID == WEAK_TAKE));

	//if branch decision is take, but we predicted not take
	assign wrong_not_take_prediction = branch_decision && ((state_ID == STRONG_NOT_TAKE) || (state_ID == WEAK_NOT_TAKE));

	//if we predicted take, but the target calculated in instruction
	//decode does not equal the target that was predicted in inst fetch
	assign wrong_target_branch = (branch_target_ID != branch_target_buffer[rd_addr_ID]) && ((state_ID == STRONG_TAKE) || (state_ID == WEAK_TAKE));
	
	//if a jump inst jumped to the wrong target
	assign wrong_target_jump = (branch_target_ID != jump_target_buffer[rd_addr_ID]);

	//determine if a branch needs to be redone and what target address
	//needs to be output
	always_comb begin
		if(wrong_take_prediction && (opcode.ID == OP_BRANCH))begin	//if we took when we were not supposed to

			branch_target_IF = pc.ID + 32'd4;	//need to jump to inst after branch in memory
			branch_redo = 1'b1; 			//branch redo is set

		end else if(wrong_not_take_prediction && (opcode.ID == OP_BRANCH)) begin // id we did not take when we were supposed to
			
			branch_target_IF = branch_target_ID;	//jump to the calculated target address
			branch_redo = 1'b1;		//redo branch

		end else if(wrong_target_branch && (opcode.ID == OP_BRANCH)) begin//if we branched to wrong targert

			branch_target_IF = branch_target_ID;	//jump to calculated target
			branch_redo = 1'b1;		//redo branch
		
		end else if(wrong_target_jump && ((opcode.ID == OP_JAL) || (opcode.ID == OP_JALR))) begin//if we jumped to wrong targert

			branch_target_IF = branch_target_ID;	//jump to calculated target
			branch_redo = 1'b1;		//redo branch
					
		end else if((opcode.IF == OP_JALR) || (opcode.IF == OP_JAL)) begin//if there is no redo in ID,and jump is in IF
		
			branch_redo = 1'b0;
			branch_target_IF = jump_target_buffer[rd_addr_IF];	//jump to addr in jump target buffer
		
		end else begin			// if none of the above is true
			branch_redo = 1'b0;	//dont redo branch
			branch_target_IF = branch_target_buffer[rd_addr_IF];	//target is read out from target buffer
		end
				
	end

	//update target address buffer
	always_ff @(posedge clk,negedge reset_n) begin
		if(!reset_n)for(i=0;i<8;i=i+1)begin	//at reset all targets point to 0
			 branch_target_buffer[i] <= 32'd0;
			 jump_target_buffer[i] <= 32'd0;
		end else if(~stall) begin		//if processor is not stalled

			//look at inst in ID to det if target is updated
			if(opcode.ID == OP_BRANCH)  begin	//update branch target, if inst is branch
				branch_target_buffer[wr_addr_ID] <= branch_target_ID;	
			end else if((opcode.ID == OP_JALR) || (opcode.ID == OP_JAL))  begin	//update jump target if inst is jump
				jump_target_buffer[wr_addr_ID] <= branch_target_ID;
			end
		end
	end
		

endmodule
