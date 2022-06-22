/*
 this module is the riscv cores data path

all five stages are in there own submodules
*/

import package_project_typedefs::*;

module data_path #(parameter INST_MEM_CACHE_SIZE = 1024,DATA_MEM_CACHE_SIZE= 1024) (
	//input signals
	input logic clk,  // main clk signal
	input logic reset_n, // active low async reset signal 
	
	input ImmGenControl instruction_type,	//data path control from control 
	input AluControl alu_op,		
	input logic reg_file_wr_en,
	input logic alu_sel_1,
	input logic alu_sel_2,
	input CacheWrControl data_mem_wr_en,
	input CacheRdControl data_mem_rd_type,
	input logic [1:0] write_back_sel,
	input BranchControl branch_type,
	input RiscvInstructions operation,

	input logic instruction_cache_stall,		//inst cache control from cache_control
	input CacheWrControl instruction_cache_wr_en,
	input logic [31:0] instruction_cache_addr,	
	input logic [31:0] instruction_cache_wr_data,	
	
	input logic data_cache_stall,		//data cache control form cache_control
	input CacheWrControl data_cache_wr_en,
	input CacheRdControl data_cache_rd_type,
	input logic [31:0] data_cache_addr,	
	input logic [31:0] data_cache_wr_data,	

	input ForwardingControl fwd_reg_file_rd_sel_1,	//control from forwarding unit
	input ForwardingControl fwd_reg_file_rd_sel_2,
	
	output logic [31:0] instruction_out,		//instruction output to control 
	
	output PipeLineSignal_5  reg_file_wr_addr,	//output to forwarding unit and hazard detection unit
	output PipeLineSignal_5 reg_file_rd_addr_1,reg_file_rd_addr_2,
	output PipeLineSignal_1 reg_file_wr_en_cntrl,
	
	input logic insert_nop,			//insert nop from hazard detection

	output logic [3:0] instruction_cache_miss,	//output to cache_control
	output logic [21:0] instruction_cache_tag,
	output logic [31:0] instruction_mem_addr_out,
	output logic [3:0] data_cache_miss,
	output logic [21:0] data_cache_tag,
	output logic [3:0] data_cache_valid,
	output logic [31:0] data_mem_addr_out,
	output logic [31:0] data_mem_rd_data_out

);


//pipelinesignals are structs with 5 signals, one for each stage in pipeline

PipeLineSignal_32  pc;	//program counter signal
PipeLineSignal_32  instruction;	//data of instruction pc pints to 
PipeLineSignal_32  write_back_data;	//data written back to registers
PipeLineSignal_32  branch_target;	//target address that branch is jumping to 
PipeLineSignal_32  reg_file_rd_data_1,reg_file_rd_data_2;	//data rd from reg file
PipeLineSignal_32  immediate;		//immediate generated for the instruction
PipeLineSignal_32  alu_result;		//result from alu
PipeLineSignal_32  data_mem_rd_data;	//data read from data memory
PipeLineSignal_1 branch_decision;	//branch decision calc in ID
logic branch_prediction;		//branch prediction in IF
logic branch_redo;			//high if a branch needs to be redon
PipeLineSignal_32 fwd_reg_file_rd_data_1, fwd_reg_file_rd_data_2;	//data forwarded during forwarding


//control signals
//control signals are read in from control in ID stage
PipeLineSignal_ImmGenCntrl instruction_type_cntrl;	
PipeLineSignal_AluCntrl alu_op_cntrl;
PipeLineSignal_1 alu_sel_1_cntrl,alu_sel_2_cntrl;
PipeLineSignal_CacheWrCntrl data_mem_wr_en_cntrl;
PipeLineSignal_CacheRdCntrl data_mem_rd_type_cntrl;
PipeLineSignal_2 write_back_sel_cntrl;
PipeLineSignal_BranchCntrl branch_type_cntrl;
PipeLineSignal_RiscvInst operation_cntrl;
PipeLineSignal_1 insert_nop_cntrl;

//cache signals
logic stall;	//1 if processor should be stalled
CacheWrControl instruction_cache_wr_en_stall_sel;	//used to disable inst cache during stall
CacheWrControl data_cache_wr_en_stall_sel;		//disable data cache during stall
logic reg_file_wr_en_stall_sel;			//used to disaple reg file during stall

/////INSTRUCTION FETCH///////
	
	assign	stall = (instruction_cache_stall) | data_cache_stall;	//stall processor if data or inst cache are stalled
	
	always_comb
		if(instruction_cache_stall ) instruction_cache_wr_en_stall_sel = instruction_cache_wr_en;
		else if(data_cache_stall) instruction_cache_wr_en_stall_sel = CACHE_NO_WR;		//disable inst cache during data stall
		else instruction_cache_wr_en_stall_sel = instruction_cache_wr_en;

	//IF stage with inst cache and pc
	stage_instruction_fetch #(.INST_MEM_CACHE_SIZE(INST_MEM_CACHE_SIZE)) instruction_fetch(	
		.clk,
		.reset_n,
		.branch_decision(branch_prediction),
		.branch_target(branch_target.IF),
		.insert_nop(insert_nop_cntrl.ID),
		.stall,
		.branch_redo,
		.pc(pc.IF),
		.instruction(instruction.IF),
		.instruction_cache_stall,
		.instruction_cache_wr_en(instruction_cache_wr_en_stall_sel),
		.instruction_cache_addr,
		.instruction_cache_wr_data,
		.reg_file_rd_addr_1(reg_file_rd_addr_1.IF),
		.reg_file_rd_addr_2(reg_file_rd_addr_2.IF),
		.instruction_cache_miss,
		.instruction_cache_tag
	);

	//branch prediction unit
	branch_prediction_unit branch_prediction_unit(
		.clk,
		.reset_n,
		.pc,
		.stall,
		.branch_decision(branch_decision.ID),
		.instruction,
		.branch_target_ID(branch_target.ID),
		.branch_prediction,
		.branch_redo,
		.branch_target_IF(branch_target.IF)
	);

	assign instruction_mem_addr_out = pc.IF;	//inst cache access address out to cache_control
	
	always_ff @(posedge clk) begin		//  IF:ID flip flop
	
		if(!stall) begin	//if stall disaple ff	
			if(insert_nop_cntrl.ID || branch_redo) instruction.ID <= M_NOP; //insert nop when hazard or redoing branch
			else instruction.ID <= instruction.IF;		
	
			pc.ID <= pc.IF;
			reg_file_rd_addr_1.ID <= reg_file_rd_addr_1.IF;	
			reg_file_rd_addr_2.ID <= reg_file_rd_addr_2.IF;		
		end
	end	



////INSTRUCTION DECODE///////

	//signals to and from control originate in ID stage
	assign instruction_out = instruction.ID;	
	assign instruction_type_cntrl.ID = instruction_type;
	assign alu_op_cntrl.ID = alu_op;		
	assign reg_file_wr_en_cntrl.ID = reg_file_wr_en;
	assign alu_sel_1_cntrl.ID =  alu_sel_1;
	assign alu_sel_2_cntrl.ID = alu_sel_2;
	assign data_mem_wr_en_cntrl.ID = data_mem_wr_en;
	assign data_mem_rd_type_cntrl.ID = data_mem_rd_type;
	assign write_back_sel_cntrl.ID = write_back_sel;
	assign branch_type_cntrl.ID = branch_type;
	assign operation_cntrl.ID = operation;
	assign insert_nop_cntrl.ID = insert_nop;

	always_comb
		if(stall) reg_file_wr_en_stall_sel = 1'b0;	//if stall disable reg file write
		else reg_file_wr_en_stall_sel = reg_file_wr_en_cntrl.WB;
	
	//inst decode with reg file and  immediate gen 	
	stage_instruction_decode instruction_decode(
		.clk,
		.reset_n,
		.pc(pc.ID),	
		.instruction(instruction.ID),
		.reg_file_wr_addr_in(reg_file_wr_addr.WB),
		.fwd_reg_file_rd_sel_1(fwd_reg_file_rd_sel_1),
		.fwd_reg_file_rd_sel_2(fwd_reg_file_rd_sel_2),
		.alu_result,
		.write_back_data,
		.branch_type(branch_type_cntrl.ID),
		.instruction_type(instruction_type_cntrl.ID),
		.reg_file_wr_en(reg_file_wr_en_stall_sel),
		.reg_file_wr_addr_out(reg_file_wr_addr.ID),
		.fwd_reg_file_rd_data_1(fwd_reg_file_rd_data_1.ID),
		.fwd_reg_file_rd_data_2(fwd_reg_file_rd_data_2.ID),
		.immediate(immediate.ID),
		.branch_decision(branch_decision.ID),
		.branch_target(branch_target.ID)
	);	

	always_ff @(posedge clk) begin	//  ID:EX ff
	

		if(!stall) begin
			pc.EX <= pc.ID;				//data path signals
			reg_file_wr_addr.EX <= reg_file_wr_addr.ID;
			fwd_reg_file_rd_data_1.EX <= fwd_reg_file_rd_data_1.ID;
			fwd_reg_file_rd_data_2.EX <= fwd_reg_file_rd_data_2.ID;
			immediate.EX <= immediate.ID;

	
			branch_type_cntrl.EX <= branch_type_cntrl.ID;		//move control through pipeline
			alu_sel_1_cntrl.EX <= alu_sel_1_cntrl.ID; 
			alu_sel_2_cntrl.EX <= alu_sel_2_cntrl.ID; 
			alu_op_cntrl.EX <= alu_op_cntrl.ID; 
			data_mem_wr_en_cntrl.EX <= data_mem_wr_en_cntrl.ID;
			data_mem_rd_type_cntrl.EX <= data_mem_rd_type_cntrl.ID;
			write_back_sel_cntrl.EX <= write_back_sel_cntrl.ID;
			reg_file_wr_en_cntrl.EX <= reg_file_wr_en_cntrl.ID;
	
			operation_cntrl.EX <= operation_cntrl.ID;
		end
	end

////////EXECUTE////////////////
		

	//execute stage with ALU
	stage_execute execute(
		.clk,
		.reset_n,
		.pc(pc.EX),
		.alu_sel_1(alu_sel_1_cntrl.EX),
		.alu_sel_2(alu_sel_2_cntrl.EX),
		.reg_file_rd_data_1(fwd_reg_file_rd_data_1.EX),
		.reg_file_rd_data_2(fwd_reg_file_rd_data_2.EX),
		.immediate(immediate.EX),
		.alu_op(alu_op_cntrl.EX),
		.alu_result(alu_result.EX)
	);

	always_ff @(posedge clk) begin		//  EX:MEM ff
		
		if(!stall) begin
			alu_result.MEM <= alu_result.EX;
			fwd_reg_file_rd_data_2.MEM <= fwd_reg_file_rd_data_2.EX;
			reg_file_wr_addr.MEM <= reg_file_wr_addr.EX;
			pc.MEM <= pc.EX;
				
		
			branch_type_cntrl.MEM <= branch_type_cntrl.EX;
			data_mem_wr_en_cntrl.MEM <= data_mem_wr_en_cntrl.EX;
			data_mem_rd_type_cntrl.MEM <= data_mem_rd_type_cntrl.EX;
			write_back_sel_cntrl.MEM <= write_back_sel_cntrl.EX;	
			reg_file_wr_en_cntrl.MEM <= reg_file_wr_en_cntrl.EX;
		
				
			operation_cntrl.MEM <= operation_cntrl.EX;
		end
	end

//////MEMORY ACCESS//////

	always_comb 
		if(instruction_cache_stall) data_cache_wr_en_stall_sel = CACHE_NO_WR;	//disable data cache durin inst cache stall
		else if(data_cache_stall) data_cache_wr_en_stall_sel = data_cache_wr_en;
		else data_cache_wr_en_stall_sel = data_cache_wr_en;
	
	//mem access with data cache
	stage_memory_access #(.DATA_MEM_CACHE_SIZE(DATA_MEM_CACHE_SIZE)) memory_access(
		.clk,
		.reset_n,
		.data_mem_addr(alu_result.MEM),
		.data_mem_wr_data(fwd_reg_file_rd_data_2.MEM),
		.data_mem_wr_en(data_mem_wr_en_cntrl.MEM),
		.data_mem_rd_type(data_mem_rd_type_cntrl.MEM),
		.data_mem_rd_data(data_mem_rd_data.MEM),
		.data_cache_stall,
		.data_cache_wr_en(data_cache_wr_en_stall_sel),
		.data_cache_addr,
		.data_cache_wr_data,
		.data_cache_miss,
		.data_cache_tag,
		.data_cache_valid
	);

	assign data_mem_addr_out  = alu_result.MEM;		//output to cache_control
	assign data_mem_rd_data_out = data_mem_rd_data.MEM;

	always_comb
		case(write_back_sel_cntrl.MEM)		//select what is being written back
			0:write_back_data.MEM = data_mem_rd_data.MEM;
			1:write_back_data.MEM = alu_result.MEM;
			//2:write_back_data.MEM = pc.MEM + 32'd4;
			default:write_back_data.MEM = 'x;
		endcase

	always_ff @(posedge clk) begin	// MEM : WB ff
		
		if(!stall) begin
			reg_file_wr_addr.WB <= reg_file_wr_addr.MEM;
			alu_result.WB <= alu_result.MEM;		
			write_back_data.WB <= write_back_data.MEM;

			write_back_sel_cntrl.WB <= write_back_sel_cntrl.MEM;		
			reg_file_wr_en_cntrl.WB <= reg_file_wr_en_cntrl.MEM;
		
			
			operation_cntrl.WB <= operation_cntrl.MEM;
		end
	end
///////WRITE BACK//////


endmodule
