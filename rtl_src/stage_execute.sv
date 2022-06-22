/*
 this module contains the execute stage including 
	alu

it also has the muxes to sel alu inputs
 */

import package_project_typedefs::*;

module stage_execute(
	input logic clk,
	input logic reset_n,

	input logic [31:0] pc,	//program counter
	
	input logic alu_sel_1,	//alu signals
	input logic alu_sel_2,
	input logic [31:0] reg_file_rd_data_1,
	input logic [31:0] reg_file_rd_data_2,
	input logic [31:0] immediate,
	input AluControl alu_op,
	

	output logic [31:0] alu_result	//alu result
//	output logic  zero
);

logic [31:0] alu_in_a;	//input to alu
logic [31:0] alu_in_b;


	
	always_comb begin	//sel appropriate input based on control
		case(alu_sel_1)
			0:alu_in_a = reg_file_rd_data_1;
			1:alu_in_a = pc;
			default:alu_in_a = 'x;
		endcase
		
		case(alu_sel_2)
			0:alu_in_b = reg_file_rd_data_2;
			1:alu_in_b = immediate;
			default:alu_in_b = 'x;
		endcase
	end

	//alu
	alu alu(
		.alu_op(alu_op),
		.in_a(alu_in_a),
		.in_b(alu_in_b),
		.result(alu_result)
//		.zero
	);

endmodule
