import package_project_typedefs::*;

module tb_execute();

//input signals
logic clk;
logic reset_n;

logic [31:0] pc;
logic alu_sel_1,alu_sel_2;
logic [31:0] reg_file_rd_data_1,reg_file_rd_data_2;
logic [31:0] immediate;
AluControl alu_op;


logic [31:0] alu_result;
 
parameter CYCLE = 100; //clock cycle     

integer i;

//instantiate data pat
stage_execute dut(.*);

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	
	//test muxes
	reset_n = 1;
	alu_sel_1 = 0;
	alu_sel_2 = 0;
	alu_op = ALU_ADD;
	reg_file_rd_data_1 = 31'd5;
	reg_file_rd_data_2  = 31'd6;
	immediate = 31'd200;
	pc = 31'd500;
	
	#CYCLE
	#0
	reset_n = 0;	


	reset_n = 1;
	alu_sel_1 = 1;
	alu_sel_2 = 1;
	alu_op = ALU_ADD;
	reg_file_rd_data_1 = 31'd5;
	reg_file_rd_data_2  = 31'd6;
	immediate = 31'd200;
	pc = 31'd500;
end

endmodule
