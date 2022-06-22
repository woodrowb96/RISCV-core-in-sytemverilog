import package_project_typedefs::*;

module tb_forwarding_unit();

PipeLineSignal_5 reg_file_wr_addr;
PipeLineSignal_5 reg_file_rd_addr_1;
PipeLineSignal_5 reg_file_rd_addr_2;
PipeLineSignal_1 reg_file_wr_en_cntrl;

ForwardingControl fwd_reg_file_rd_sel_1;
ForwardingControl fwd_reg_file_rd_sel_2;
	
forwarding_unit dut(.*);	//forwarding unit under test


parameter CYCLE = 100;




initial begin
	reg_file_wr_en_cntrl.EX = 1'b0;	//no hazards since no inst are writting
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b0;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd0;	//but no conflict since rs != rd
	reg_file_rd_addr_2.ID = 5'd0;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b1;	//ex_ID hazard
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b0;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd0;
	reg_file_rd_addr_2.ID = 5'd0;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b1;	//MEM_ID hazard
	reg_file_wr_en_cntrl.WB = 1'b0;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd0;//but no conflict since rs != rd
	reg_file_rd_addr_2.ID = 5'd0;


	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b1;	//wb_id hazxard
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd0;//but no conflict since rs != rd
	reg_file_rd_addr_2.ID = 5'd0;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b1;	//ex hazard 
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b0;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;	// rd == rs
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b1;	//ex haz has priority
	reg_file_wr_en_cntrl.MEM = 1'b1;
	reg_file_wr_en_cntrl.WB = 1'b0;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b1;	//mem hazardg
	reg_file_wr_en_cntrl.WB = 1'b0;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b1;	//ex hazard has priority
	reg_file_wr_en_cntrl.MEM = 1'b1;
	reg_file_wr_en_cntrl.WB = 1'b1;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b1;	//mem hazard has priority
	reg_file_wr_en_cntrl.WB = 1'b1;
	reg_file_wr_addr.EX = 5'd0;
	reg_file_wr_addr.MEM = 5'd0;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b1;	//wb hazard
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b1;
	reg_file_wr_addr.EX = 5'd0;
	reg_file_wr_addr.MEM = 5'd0;
	reg_file_wr_addr.WB= 5'd0;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;	//no conflict rs != rd

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b1;
	reg_file_wr_en_cntrl.MEM = 1'b0;
	reg_file_wr_en_cntrl.WB = 1'b1;
	reg_file_wr_addr.EX = 5'd0;
	reg_file_wr_addr.MEM = 5'd0;
	reg_file_wr_addr.WB= 5'd0;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;

	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b1;
	reg_file_wr_en_cntrl.WB = 1'b1;
	reg_file_wr_addr.EX = 5'd0;
	reg_file_wr_addr.MEM = 5'd0;
	reg_file_wr_addr.WB= 5'd0;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;



	#CYCLE 
	reg_file_wr_en_cntrl.EX = 1'b0;
	reg_file_wr_en_cntrl.MEM = 1'b1;
	reg_file_wr_en_cntrl.WB = 1'b1;
	reg_file_wr_addr.EX = 5'd5;
	reg_file_wr_addr.MEM = 5'd5;
	reg_file_wr_addr.WB= 5'd5;
	reg_file_rd_addr_1.ID = 5'd5;
	reg_file_rd_addr_2.ID = 5'd5;


end

endmodule
