/*
this module holds the register file

writes to reg  file are synchronous

reads are asynch

*/
import package_project_typedefs::*;

module register_file #(parameter WIDTH=32, DEPTH=32, ADDR_WIDTH = 5) (
	
	//////control signals////
	input logic reg_file_wr_en,  //write control signal

	/////input signals/////
	input logic clk,
	input logic [ADDR_WIDTH-1:0] rd_addr_1, // two 5 bit addresses for reading
	input logic [ADDR_WIDTH-1:0] rd_addr_2,
	input logic [ADDR_WIDTH-1:0] wr_addr,  // 5 bit address for writing
	input logic [WIDTH-1:0] data_in, // 32 bit write data

	///////output signals//////
	output logic [WIDTH-1:0] rd_data_1, //two 32 bit data signals from
	output logic [WIDTH-1:0] rd_data_2  //read redigsters
);

reg [WIDTH-1:0] reg_file [DEPTH-1:0];

	always_ff @(posedge clk) begin
		reg_file[0] <= 32'd0;	//x0 always holds 0
	
		if(reg_file_wr_en && wr_addr != 5'd0) begin	//if enabled synchrounous write
			reg_file[wr_addr] <= data_in;
		end
	end

	always_comb begin	//asynch read
		rd_data_1 = reg_file[rd_addr_1];
		rd_data_2 = reg_file[rd_addr_2];
	end

endmodule
