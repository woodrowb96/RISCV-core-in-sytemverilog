import package_project_typedefs::*;

module tb_instruction_decode();

//input signals
logic clk;
logic reset_n;

logic [31:0] pc_in;
logic [31:0] pc_out;
logic [31:0] pc_jump_return_addr;
logic [31:0] instruction;
logic [31:0] write_back_data;

logic reg_file_wr_sel;

ImmGenControl instruction_type;
RegFileWrControl reg_file_wr_en;

logic [4:0] reg_file_wr_addr_in;
logic [4:0] reg_file_wr_addr_out;
logic [31:0] reg_file_rd_data_1;
logic [31:0] reg_file_rd_data_2;
logic [31:0] immediate;

              
parameter CYCLE = 100; //clock cycle     

integer i;

//instantiate data path 
instruction_decode dut(.*);

//taskt to write a 4 byte value into instruction mem block ram at location
task write_reg_file(integer location,integer value);

	dut.register_file.reg_file[location]  =  value; 

endtask

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end


//initialiaze instr memory
initial begin	
	for(i=0;i < 32;i=i+1) begin
		write_reg_file(i,i); //each location hold value of pc that pints at location
	end
end

logic [4:0] rd_addr_1_set;
logic [4:0] rd_addr_2_set;
logic [4:0] wr_addr_set;
	
assign instruction = {{7'b1111111,rd_addr_2_set},rd_addr_1_set,3'dx,wr_addr_set,7'dx};
initial begin

	reset_n = 1;
	
	rd_addr_1_set = 5'd0;
 	rd_addr_2_set = 5'd0;
 	wr_addr_set = 5'd0;
	pc_jump_return_addr = 32'd112;
	write_back_data = 32'd1000;
	reg_file_wr_addr_in = 1'b0;
	reg_file_wr_sel = 1'b0;
	reg_file_wr_en = REG_NO_WR;
	instruction_type = I;

	#CYCLE
	#0

	rd_addr_1_set = 5'd1;
 	rd_addr_2_set = 5'd2;
 	wr_addr_set = 5'd1;
	pc_jump_return_addr = 32'd112;
	write_back_data = 32'd1000;
	reg_file_wr_addr_in = 1'b0;
	reg_file_wr_sel = 1'b0;
	reg_file_wr_en = REG_NO_WR;
	instruction_type = I;
	#CYCLE
	#0

	rd_addr_1_set = 5'd1;
 	rd_addr_2_set = 5'd3;
 	wr_addr_set = 5'd31;
	pc_jump_return_addr = 32'd112;
	write_back_data = 32'd1000;
	reg_file_wr_addr_in = 5'd1;
	reg_file_wr_sel = 1'b0;
	reg_file_wr_en = REG_W_WR;
	instruction_type = I;
	
	#CYCLE
	#0

	rd_addr_1_set = 5'd1;
 	rd_addr_2_set = 5'd3;
 	wr_addr_set = 5'd31;
	pc_jump_return_addr = 32'd112;
	write_back_data = 32'd1000;
	reg_file_wr_addr_in = 5'd1;
	reg_file_wr_sel = 1'b1;
	reg_file_wr_en = REG_W_WR;
	instruction_type = I;
	
	#CYCLE
	#0

	rd_addr_1_set = 5'd1;
 	rd_addr_2_set = 5'd3;
 	wr_addr_set = 5'd31;
	pc_jump_return_addr = 32'd112;
	write_back_data = 32'd1000;
	reg_file_wr_addr_in = 5'd0;
	reg_file_wr_sel = 1'b1;
	reg_file_wr_en = REG_W_WR;
	instruction_type = I;
	
	
end

endmodule
