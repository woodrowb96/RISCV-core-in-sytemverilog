module block_ram #(parameter WIDTH=8, DEPTH=128, ADDR_WIDTH=8 )(
	input logic clk,
	input logic [WIDTH-1:0] wr_data, //data written in
	input logic [ADDR_WIDTH-1:0] wr_addr, // address of rds and wrs
	input logic [ADDR_WIDTH-1:0] rd_addr, // address of rds and wrs
	input logic wr_en,  //active high write enable signal
	output logic [WIDTH-1:0] rd_data  //data read out
);
	
	reg [WIDTH-1:0] mem [DEPTH-1:0];  //WIDTH x DEPTH sized block ram
	
	reg [7:0] rd_reg;
	always_ff @(posedge clk)begin //synchronous write to addr
		if(wr_en)
			mem[wr_addr] <= wr_data;
	end

	always_comb begin // asynch read from addr
		rd_data = mem[rd_addr];
	end
endmodule
