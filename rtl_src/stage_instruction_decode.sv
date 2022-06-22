/*
 this module holds the inst decode stage including 
	reg_file
	immediate gen
	branch_decision unit

it also holds the muxes used to select forwarding 
 */

import package_project_typedefs::*;

module stage_instruction_decode (
	input logic clk,
	input logic reset_n,

	input logic [31:0] pc,	
	input logic [31:0] instruction,
	input logic [4:0] reg_file_wr_addr_in,		//wr addrs of inst coming in from WB

	//forwarded data coming from EX,MEM and WB stages
	input ForwardingControl fwd_reg_file_rd_sel_1,	//forwarded data select
	input ForwardingControl fwd_reg_file_rd_sel_2,	
	input PipeLineSignal_32 alu_result,		
	input PipeLineSignal_32 write_back_data,	
	input logic reg_file_wr_en,
	input ImmGenControl instruction_type,

	input BranchControl branch_type,	

	output logic [4:0] reg_file_wr_addr_out,	//wr addr of inst leaving ID
	output logic [31:0] fwd_reg_file_rd_data_1,
	output logic [31:0] fwd_reg_file_rd_data_2,
	output logic [31:0] immediate,
	output logic [31:0] branch_target,	//branch signals
	output logic  branch_decision
);
 

	logic [31:0] reg_file_rd_data_1;	//data read from reg files
	logic [31:0] reg_file_rd_data_2;


	assign reg_file_wr_addr_out = instruction[11:7];	//write address of instruction leaving ID

	register_file register_file(
		.clk,
		.reg_file_wr_en,
		.rd_addr_1(instruction[19:15]),
		.rd_addr_2(instruction[24:20]),
		.wr_addr(reg_file_wr_addr_in),
		.data_in(write_back_data.WB),
		.rd_data_1(reg_file_rd_data_1),
		.rd_data_2(reg_file_rd_data_2)
	);

	immediate_gen immediate_gen(
		.instruction_type,
		.instruction,
		.immediate
	);

	always_comb begin 	//select what data to forward to instruction
		case(fwd_reg_file_rd_sel_1)
			NO_FWD:fwd_reg_file_rd_data_1 = reg_file_rd_data_1;	//no fwd: let reg_rd_data pass
			EX_ID_FWD:fwd_reg_file_rd_data_1 = alu_result.EX;	//fwd alu result
			MEM_ID_FWD:fwd_reg_file_rd_data_1  = write_back_data.MEM;	//fwd write back from MEM
			WB_ID_FWD:fwd_reg_file_rd_data_1  = write_back_data.WB;		//fwd write back from WB
			default:fwd_reg_file_rd_data_1 = 'x;
		endcase

		case(fwd_reg_file_rd_sel_2)
			NO_FWD:fwd_reg_file_rd_data_2  = reg_file_rd_data_2;
			EX_ID_FWD:fwd_reg_file_rd_data_2 = alu_result.EX;
			MEM_ID_FWD:fwd_reg_file_rd_data_2 = write_back_data.MEM;
			WB_ID_FWD:fwd_reg_file_rd_data_2 = write_back_data.WB;
			default:fwd_reg_file_rd_data_2 = 'x;
		endcase
	end


	branch_decision_unit branch_decision_unit(
		.reg_file_rd_data_1(fwd_reg_file_rd_data_1),
		.reg_file_rd_data_2(fwd_reg_file_rd_data_2),
		.pc,
		.immediate(immediate),
		.branch_type,
		.branch_decision,
		.branch_target
	);
	
	

endmodule

