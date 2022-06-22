import package_project_typedefs::*;

module stage_write_back(
	input logic clk,
	input logic reset_n,

	input logic [31:0]  data_mem_rd_data,	
	input logic [31:0]  alu_result,	
	input logic [1:0] write_back_sel,
	input logic [31:0] pc,
	
	output logic [31:0]  write_back_data	
);


	always_comb begin
		case(write_back_sel)
			0:write_back_data = data_mem_rd_data;
			1:write_back_data = alu_result;
			2:write_back_data = pc + 31'd4;
			default:write_back_data =  'x;
		endcase	
	end


endmodule
