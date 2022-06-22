import package_project_typedefs::*;

module tb_data_memory();

logic clk; 
DataMemWrControl mem_wr;
logic [31:0] addr_in;
logic [31:0] wr_data;
logic [31:0] rd_data;

data_memory #(.DATA_MEM_DEPTH(512)) dut(.*);


parameter CYCLE = 100;


//taskt to write a 4 byte value into instruction mem block ram at location
task write_mem(integer location,integer value);
	{dut.block_ram_3.mem[location],
	dut.block_ram_2.mem[location],
	dut.block_ram_1.mem[location],
	dut.block_ram_0.mem[location]} = value; 
endtask


initial begin
	clk = 1;
	repeat (40) #(CYCLE/2) clk = ~clk;

	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	
	write_mem(0,0);
	write_mem(1,32'hAABBCCDD);
	write_mem(2,32'h00112233);

	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd0;	
	wr_data = 32'd0;	
	
	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd4;	
	wr_data = 32'd0;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd5;	
	wr_data = 32'd0;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd6;	
	wr_data = 32'd0;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd7;	
	wr_data = 32'd0;	


	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd8;	
	wr_data = 32'd0;	




	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd12;	
	wr_data = 32'hFFBBAAEE;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd12;	
	wr_data = 32'h88119966;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd12;	
	wr_data = 32'hBB119966;	




	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd13;	
	wr_data = 32'hAABBCCDD;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd13;	
	wr_data = 32'hAABBCCDD;
	
	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd14;	
	wr_data = 32'h77448866;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd14;	
	wr_data = 32'hAABBCCDD;
	
	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd15;	
	wr_data = 32'hBBDDAACC;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd15;	
	wr_data = 32'hAABBCCDD;


	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd16;	
	wr_data = 32'hABCDEFAB;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd16;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_B_WR;
	addr_in = 32'd16;	
	wr_data = 32'h11223344;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd16;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_H_WR;
	addr_in = 32'd16;	
	wr_data = 32'h11223344;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd16;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd16;	
	wr_data = 32'h11223344;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd16;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_B_WR;
	addr_in = 32'd17;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd17;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_H_WR;
	addr_in = 32'd17;	
	wr_data = 32'hAABBCCDD;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd17;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd17;	
	wr_data = 32'hAABBCCDD;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd17;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_B_WR;
	addr_in = 32'd18;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd18;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_H_WR;
	addr_in = 32'd18;	
	wr_data = 32'h11223344;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd18;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd18;	
	wr_data = 32'h11223344;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd18;	
	wr_data = 32'h11223344;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_B_WR;
	addr_in = 32'd19;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd19;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_H_WR;
	addr_in = 32'd19;	
	wr_data = 32'hAABBCCDD;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd19;	
	wr_data = 32'hAABBCCDD;

	#CYCLE	
	#0
	mem_wr = DATA_MEM_W_WR;
	addr_in = 32'd19;	
	wr_data = 32'hAABBCCDD;	

	#CYCLE	
	#0
	mem_wr = DATA_MEM_NO_WR;
	addr_in = 32'd19;	
	wr_data = 32'hAABBCCDD;





end
endmodule
