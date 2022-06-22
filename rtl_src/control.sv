/*
 this decodes instruction in ID stage and set appropriate control signal for data path 
 */

import package_project_typedefs::*;
module control(

	///input signals////
	input logic [31:0] instruction, //32 bit inst to be decoded
	
	//output logic ////
	output ImmGenControl instruction_type,	//control to immediate genertator
	output CacheRdControl data_mem_rd_type, //register file wr control 
	output logic reg_file_wr_en, //register file wr control 
	output AluControl alu_op, // alu operation
	output logic alu_sel_1,	//selec in_a to alu
	output logic alu_sel_2, // sel what value goes to alu
	output CacheWrControl data_mem_wr_en, //data mem wr control 
	output logic [1:0] write_back_sel, //sel what value is written back to reg file
	output BranchControl branch_type, // indicate branch_type instruction
	output RiscvInstructions operation,	//riscv operation that instruction encodes
	output RiscvOpcodes opcode	//opcode of instrucion
);

logic [2:0] funct_3; 	//instruction f3 field
logic [6:0] funct_7;  	//f7 field
logic [4:0] rd,rs_1,rs_2;	//rd rs1 and rs2 fields of instruction	
logic nop_condition;	//check if inst is a nop


assign funct_3 = instruction[14:12];	//pick out fields from instructions	
assign funct_7 = instruction[31:25];
assign opcode = RiscvOpcodes'(instruction[6:0]);
assign rd = instruction[11:7];
assign rs_1 = instruction[19:15];
assign rs_2 = instruction[24:20];


//a nop is encoded as an ADD inst that rds and writes to x0 in reg file
assign nop_condition = (rd == 5'd0) & (rs_1 == 5'd0) & (rs_2 == 5'd0);

always_comb begin 
	case(opcode)	//use opcode f3 and f7 to determin operation
		OP_LOAD:
		begin
			if     (funct_3 == 3'b000) operation = LB;
			else if(funct_3 == 3'b001) operation = LH;
			else if(funct_3 == 3'b010) operation = LW;
			else if(funct_3 == 3'b100) operation = LBU;
			else if(funct_3 == 3'b101) operation = LHU;
			else                       operation = ERROR;
		end
		OP_FENCE:		           operation = FENCE;
		OP_COMP_IMM:
		begin
			if     (funct_3 == 3'b000) operation = ADDI;
			else if(funct_3 == 3'b001) operation = SLLI;
			else if(funct_3 == 3'b010) operation = SLTI;
			else if(funct_3 == 3'b011) operation = SLTIU;
			else if(funct_3 == 3'b100) operation = XORI;
			else if(funct_3 == 3'b101) operation = funct_7[5] ? SRAI : SRLI;
			else if(funct_3 == 3'b110) operation = ORI;
			else if(funct_3 == 3'b111) operation = ANDI;
			else                       operation = ERROR;
		end
		OP_AUIPC:                          operation = AUIPC;
		OP_STORE:
		begin
			if     (funct_3 == 3'b000) operation = SB;
			else if(funct_3 == 3'b001) operation = SH;
			else if(funct_3 == 3'b010) operation = SW;
			else                       operation = ERROR;
		end
		OP_COMP_REG:
		begin
			if     (funct_3 == 3'b000)begin
				if(funct_7[5]) operation = SUB;
				else if(~funct_7[5] && nop_condition)  operation = NOP; //an add may be nop
				else 					operation = ADD;
			end
			else if(funct_3 == 3'b001) operation = SLL;
			else if(funct_3 == 3'b010) operation = SLT;
			else if(funct_3 == 3'b011) operation = SLTU;
			else if(funct_3 == 3'b100) operation = XOR;
			else if(funct_3 == 3'b101) operation = funct_7[5] ? SRA : SRL;
			else if(funct_3 == 3'b110) operation = OR;
			else if(funct_3 == 3'b111) operation = AND;
			else                       operation = ERROR;
		end
		OP_LUI:                            operation = LUI;
		OP_BRANCH:
		begin
			if     (funct_3 == 3'b000) operation = BEQ;
			else if(funct_3 == 3'b001) operation = BNE;
			else if(funct_3 == 3'b100) operation = BLT;
			else if(funct_3 == 3'b101) operation = BGE;
			else if(funct_3 == 3'b110) operation = BLTU;
			else if(funct_3 == 3'b111) operation = BGEU;
			else                       operation = ERROR;
		end
		OP_JALR:                           operation = JALR;
		OP_JAL:                            operation = JAL;
		OP_SYSTEM:                         operation = funct_7[0] ? EBREAK : ECALL;
		default:operation = ERROR;
	endcase 

	case(operation)	//set control depending on the operation
		LB:begin
			instruction_type = I;
			data_mem_rd_type = CACHE_B_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
		end
		LH: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_H_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
		end 
		LW: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
		end
		LBU: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_BU_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
		end
		LHU:  begin
			instruction_type = I;
			data_mem_rd_type = CACHE_HU_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		FENCE: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		ADDI: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SLLI:begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SHIFT_L;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SLTI:  begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SET_LT;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SLTIU: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SET_LTU;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		XORI: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_XOR;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SRLI:begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SHIFT_RL;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SRAI:begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SHIFT_RA;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		ORI: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_OR;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		ANDI: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_W_RD;;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_AND;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		AUIPC: begin
			instruction_type = U;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b1;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SB:begin
			instruction_type = S;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_B_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SH:begin
			instruction_type = S;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_H_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SW:begin
			instruction_type = S;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_W_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		ADD:begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		NOP:begin
			instruction_type = R;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SUB:begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SUB;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SLL: begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SHIFT_L;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SLT:  begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SET_LT;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SLTU: begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SET_LTU;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end 
		XOR: begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_XOR;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end 
		SRL:begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SHIFT_RL;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		SRA:begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_SHIFT_RA;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		OR:  begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_OR;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		AND:  begin
			instruction_type = R;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_AND;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		LUI:  begin
			instruction_type = U;
			data_mem_rd_type = CACHE_W_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_PASS_B;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = NO_JUMP_BRANCH;	
			 
		end 
		BEQ: begin
			instruction_type = B;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_SUB;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = BRANCH_EQ;	
			 
		end
		BNE:  begin
			instruction_type = B;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_SUB;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = BRANCH_NE;	
			 
		end
		BLT: begin
			instruction_type = B;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_SET_LT;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = BRANCH_LT;	
			 
		end
		BGE: begin
			instruction_type = B;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_SET_LT;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = BRANCH_GE;	
			 
		end
		BLTU: begin
			instruction_type = B;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_SET_LTU;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = BRANCH_LTU;	
			 
		end
		BGEU: begin
			instruction_type = B;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_SET_LTU;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = BRANCH_GEU;	
			 
		end
		JALR:  begin
			instruction_type = I;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_PC_INC;
			alu_sel_1 = 1'b1;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = JUMP_ALR;	
			 
		end
		JAL:  begin
			instruction_type = J;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b1;
			alu_op = ALU_PC_INC;
			alu_sel_1 = 1'b1;
			alu_sel_2 = 1'b1;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd1;
			branch_type = JUMP_AL;	
			 
		end
		ECALL: begin
			instruction_type = I;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		EBREAK:begin
			instruction_type = I;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		ERROR:  begin
			instruction_type = I;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
		default:begin
			instruction_type = I;
			data_mem_rd_type = CACHE_NO_RD;
			reg_file_wr_en = 1'b0;
			alu_op = ALU_ADD;
			alu_sel_1 = 1'b0;
			alu_sel_2 = 1'b0;
			data_mem_wr_en = CACHE_NO_WR;
			write_back_sel = 2'd0;
			branch_type = NO_JUMP_BRANCH;	
			 
		end
	endcase 
end


endmodule
