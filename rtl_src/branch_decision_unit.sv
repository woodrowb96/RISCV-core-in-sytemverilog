/*
This module calculates the branch decision and branch target during the inst decode stage

The decision and target are sent to the branch prediction unit and are compared with their predictions to determin
if a no-op should be inserted and the branch redone 

*/
import package_project_typedefs::*;

module branch_decision_unit(
	input logic signed [31:0] reg_file_rd_data_1,	//data from the two reg file rd addreses
	input logic signed [31:0] reg_file_rd_data_2,

	input logic [31:0] pc, 		//pc of the branch used to calc target address
	input logic signed [31:0] immediate, 	//immediate used to calc target address

	input BranchControl branch_type, 	//branch control signal indicating the type of branch
	
	output logic branch_decision, 	//branch decision, 1 if branch is taken, 0 if not
	output logic [31:0] branch_target	//branch target address
);

logic [32:0] sub; //subtraction operation used to determin branch decision
logic [32:0] less_than_unsigned; //less than unsigned operation to determin branch decision

	assign sub = reg_file_rd_data_1 - reg_file_rd_data_2; 
	assign less_than_unsigned = ($unsigned(reg_file_rd_data_1) < $unsigned(reg_file_rd_data_2));

	always_comb begin
		case(branch_type) //look at branch_type and calc branch decision
			BRANCH_EQ:branch_decision = (sub == 33'b0);	 //check if sub is zero to determine eq condition
			BRANCH_NE:branch_decision = ~(sub == 33'b0);	 //check if sub is not zero to determine not eq condition
			BRANCH_LT:branch_decision = ~(sub[32] == 1'b0);		//check if sub is negative to determine lt condition
			BRANCH_GE:branch_decision = (sub[32] == 1'b0);		//check if sub is positive to determine greater than or eq 
			BRANCH_LTU:branch_decision = ~(less_than_unsigned== 1'b0);	//check if unsigned less is true
			BRANCH_GEU:branch_decision = (less_than_unsigned== 1'b0); 	//check if unsigned less than is not true
			JUMP_AL:branch_decision = 1'b1; 	//JAL branch decision is always true
			JUMP_ALR:branch_decision = 1'b1;	//JALR branch decision is always true
			default:branch_decision  = 1'b0;	//branch decision is always false for non jump or branch instructions
		endcase

		case(branch_type) //calc target address
			JUMP_ALR:branch_target = immediate + reg_file_rd_data_1; //use immediate and rs1 for JALR
			default:branch_target = immediate + pc;		//use immediate and PC for all other branch instructions
		endcase
	end

	

endmodule
