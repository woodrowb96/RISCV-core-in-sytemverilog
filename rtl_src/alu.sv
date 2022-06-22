import package_project_typedefs::*; //import enumerated typedefs

module alu(
	/////control signals/////	
	input AluControl alu_op, //4 bit control signal

	//// input signals/////
	input logic signed [31:0] in_a,  // 32 bit operand inputs
	input logic signed [31:0] in_b,  //both operands are treated as signed 
					 // for most alu operations
	
	//// output signals/////	
	output logic signed [31:0] result // 32 bit operation result
//	output logic zero // one bit zero output, set if result is 32'd0

);


logic [32:0] temp; //used for temp subtraction during signed set_lt comparison

	always_comb begin
		//result = result[31:0];
		
		temp = '0; // temp default is 0

		case(alu_op) //look at control signal and perform appropriate operation
			ALU_ADD:begin
				result = in_a + in_b;
			end
			ALU_SUB:begin
				result = in_a - in_b;
			end
			ALU_SHIFT_L:begin  // logical shift left
				result = in_a << in_b[4:0];
			end
			ALU_SHIFT_RL:begin //logical shift right
				result = in_a  >> in_b[4:0];
			end
			ALU_SHIFT_RA:begin // arithmetic shift right 
				result = in_a >>> in_b[4:0];
			end
			ALU_SET_LT:begin   //signed set if less than
			
				temp = in_a - in_b; // subtract in_a from in_b then look at result to 
						    // determine if in_a is less than in_b

				result = temp[32] ? 32'd1 : 32'd0;//look at overflow bit to determine if temp
								  //was negative or positive and set result
		 				       		  //accordingly				
			end
			ALU_SET_LTU:begin //unsigned set less than
				
				//cast in_a and in_b to unsigned, to get unsigned comparison 
				result = ($unsigned(in_a) < $unsigned(in_b)) ? 32'd1 : 32'd0;
			end
			ALU_XOR:begin
				result = in_a ^ in_b;
			end 
			ALU_OR:begin
				result = in_a | in_b;
			end
			ALU_AND:begin
				result = in_a & in_b;
			end
			ALU_PASS_A:begin //pass in_a through alu with no operation
				result = in_a;
			end
			ALU_PASS_B:begin // pass in_b through alu with no operation
				result = in_b;
			end
			ALU_PC_INC:begin // increment pc by 4
				result = in_a + 32'd4;
			end
			default:begin 
				result = 'x;
			end	
		endcase 

//		if(result == 33'd0) zero = 1'b1; // if result is zero output 1
//		else zero = 1'b0;		// else output 0

	end

endmodule
