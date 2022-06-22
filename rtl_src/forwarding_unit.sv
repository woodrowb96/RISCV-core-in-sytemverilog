/*
this module detects if there are forwarding hazards in the data path and resolves them by 
	setting the forwarding select signals accordingly

forwarding haxarsds can occure when the instruction in ID tries to read data from the reg file that has not been written in yet 
	this data may  still in the EX,MEM or WB stage 
*/
import package_project_typedefs::*;

module forwarding_unit(
	input PipeLineSignal_5 reg_file_wr_addr,	//need to check to write addresses for inst in EX,MEM and WB
	input PipeLineSignal_5 reg_file_rd_addr_1,	//need to check rd addr for inst in ID
	input PipeLineSignal_5 reg_file_rd_addr_2,	
	input PipeLineSignal_1 reg_file_wr_en_cntrl,	//need to see if inst in EX,MEM or WB are writting data to reg file

	output ForwardingControl fwd_reg_file_rd_sel_1, 	//resolve hazards by selecting data to get forwarded by mux in data path
	output ForwardingControl fwd_reg_file_rd_sel_2 
	
);

//signals to indicate different forwarding hazards that can occure
logic ex_id_conflict_1;		//conf between rs1 in ID and rd in ex
logic mem_id_conflict_1;	//conf between rs1 in ID and rd in MEM
logic wb_id_conflict_1;		//conf between rs1 in ID and rd in WB

logic ex_id_conflict_2;		//conflicst for rs2
logic mem_id_conflict_2;
logic wb_id_conflict_2;

logic ex_id_hazard_1;	//a hazard only occurs if the instg in MEM,EX or WB is writting to reg file
logic mem_id_hazard_1;	// these conditionals check for that codition
logic wb_id_hazard_1;

logic ex_id_hazard_2;
logic mem_id_hazard_2;
logic wb_id_hazard_2;
	
	//check  if rd == rs1 in MEM,WB or ex
	assign ex_id_conflict_1 = (reg_file_wr_addr.EX != 5'd0) & (reg_file_wr_addr.EX == reg_file_rd_addr_1.ID);
	assign mem_id_conflict_1 = (reg_file_wr_addr.MEM != 5'd0) & (reg_file_wr_addr.MEM == reg_file_rd_addr_1.ID);
	assign wb_id_conflict_1 = (reg_file_wr_addr.WB != 5'd0) & (reg_file_wr_addr.WB == reg_file_rd_addr_1.ID);
	
	//do the same for rs2	
	assign ex_id_conflict_2 = (reg_file_wr_addr.EX != 5'd0) & (reg_file_wr_addr.EX == reg_file_rd_addr_2.ID);
	assign mem_id_conflict_2 = (reg_file_wr_addr.MEM != 5'd0) & (reg_file_wr_addr.MEM == reg_file_rd_addr_2.ID);
	assign wb_id_conflict_2 = (reg_file_wr_addr.WB != 5'd0) & (reg_file_wr_addr.WB == reg_file_rd_addr_2.ID);
	
	//check if inst in MEM , WB or EX are writting to reg file
	assign ex_id_hazard_1 = reg_file_wr_en_cntrl.EX & ex_id_conflict_1; 
	assign mem_id_hazard_1 = reg_file_wr_en_cntrl.MEM & mem_id_conflict_1; 
	assign wb_id_hazard_1 = reg_file_wr_en_cntrl.WB & wb_id_conflict_1; 
	
	assign ex_id_hazard_2 = reg_file_wr_en_cntrl.EX & ex_id_conflict_2; 
	assign mem_id_hazard_2 = reg_file_wr_en_cntrl.MEM & mem_id_conflict_2; 
	assign wb_id_hazard_2 = reg_file_wr_en_cntrl.WB & wb_id_conflict_2; 

	//check what hazards are occuring and select fwd data to resolve
	//hazard
	always_comb begin
		if(ex_id_hazard_1)	//ex_id hazard  has priority first
			fwd_reg_file_rd_sel_1 = EX_ID_FWD;
		else if(mem_id_hazard_1 && ~ex_id_hazard_1)	//mem_id hazard has next priority
			fwd_reg_file_rd_sel_1 = MEM_ID_FWD;
		else if(wb_id_hazard_1 && ~ex_id_hazard_1 && ~mem_id_hazard_1)	//mem wb hazard has leaast priority
			fwd_reg_file_rd_sel_1 = WB_ID_FWD;
		else 
			fwd_reg_file_rd_sel_1 = NO_FWD;
	
		//do the same for rs2
		if(ex_id_hazard_2)
			fwd_reg_file_rd_sel_2 = EX_ID_FWD;
		else if(mem_id_hazard_2 && ~ex_id_hazard_2)
			fwd_reg_file_rd_sel_2 = MEM_ID_FWD;
		else if(wb_id_hazard_2 && ~ex_id_hazard_2 && ~mem_id_hazard_2)
			fwd_reg_file_rd_sel_2 = WB_ID_FWD;
		else 
			fwd_reg_file_rd_sel_2 = NO_FWD;



	end

endmodule
