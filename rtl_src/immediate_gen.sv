/*
 this module generates immediates from the instruction based on inst type

*/

import package_project_typedefs::*;

module immediate_gen(
	
	//input logic 
	input ImmGenControl instruction_type,	
	//inptu signals////
	input logic [31:0] instruction, // 12 bit data to be sign extended
	
	//output signals //
	output logic [31:0] immediate /// 32 bit sign extended data
);

	always_comb begin
		case(instruction_type)	//check inst type and gen immediate
			I:begin
				immediate[31:11] = {21{instruction[31]}};	//sign extend
				immediate[10:0] = instruction[30:20];
			end
			S:begin
				immediate[31:11] = {21{instruction[31]}};	//sign extend
				immediate[10:5] = instruction[30:25];
				immediate[4:0] = instruction[11:7];
			end
			B:begin
	
				immediate[31:12] = {20{instruction[31]}};	//sign extend
				immediate[11] = instruction[7];
				immediate[10:5] = instruction[30:25];
				immediate[4:1] = instruction[11:8];
				immediate[0] = '0;
			end
			U:begin
				immediate[31:12] = instruction[31:12];	
				immediate[11:0] = '0;
			end
			J:begin
				immediate[31:20] = {12{instruction[31]}};	//sign extend
				immediate[19:12] = instruction[19:12];
				immediate[11] = instruction[20];
				immediate[10:5] = instruction[30:25];
				immediate[4:1] = instruction[24:21];
				immediate[0] = '0;
			end
			default:begin
				immediate = 'x ;
			end
		endcase
	end

endmodule
