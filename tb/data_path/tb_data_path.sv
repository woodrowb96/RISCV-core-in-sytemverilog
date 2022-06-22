module tb_data_path();

//input signals
logic clk;
logic reset_n;

//control signals

logic alu_sel_1;
logic alu_sel_2;
logic [3:0] mem_wr;
logic wb_sel;
logic [2:0] branch;

enum logic [3:0] {
REG_NO_WR = 4'b0000,
REG_B_WR  = 4'b0001,
REG_H_WR  = 4'b0011,
REG_W_WR  = 4'b0101,
REG_BU_WR = 4'b1001,
REG_HU_WR = 4'b1011}reg_file_wr;


enum logic [2:0] {
	I = 3'b000,
	S = 3'b001,
	B = 3'b010,
	U = 3'b011,
	J = 3'b100,
	R = 3'b101} instruction_type;
enum logic [3:0] {
	ADD = 4'b0000,
	SUB = 4'b0001} alu_op;

//output signal
logic [31:0] instruction;

parameter BRANCH_NO = 3'd0;
parameter BRANCH_EQ = 3'd1;
parameter BRANCH_NE = 3'd2;
parameter BRANCH_LT = 3'd3;
parameter BRANCH_LTU = 3'd4;
parameter BRANCH_GE = 3'd5;
parameter BRANCH_GEU = 3'd6;



parameter CYCLE = 100; //clock cycle
parameter MEM_DEPTH = 2048; // size of memory
integer i;
integer imm; 

//instantiate data path 
data_path #(.INST_MEM_DEPTH(MEM_DEPTH), .DATA_MEM_DEPTH(MEM_DEPTH)) dut(.*);

//taskt to write a 4 byte value into instruction mem block ram at location
task write_inst_mem(integer location,integer value);

	{dut.instruction_memory.block_ram_3.mem[location],
	dut.instruction_memory.block_ram_2.mem[location],
	dut.instruction_memory.block_ram_1.mem[location],
	dut.instruction_memory.block_ram_0.mem[location]} = value; 

endtask

//taskt to write a 4 byte value into instruction mem block ram at location
task write_data_mem(integer location,integer value);

	{dut.data_memory.block_ram_3.mem[location],
	dut.data_memory.block_ram_2.mem[location],
	dut.data_memory.block_ram_1.mem[location],
	dut.data_memory.block_ram_0.mem[location]} = value; 

endtask
//task to write a value into the register file at location
task write_reg_file(integer location, integer value);
	dut.register_file.reg_file[location] = value;
endtask


//initialiaze instr memory
initial begin	
	for(i=0;i < MEM_DEPTH/4;i=i+1) begin
		write_inst_mem(i,i*4); //each location hold value of pc that pints at location
	end
end

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end

initial begin

//	#10 //offset for hold time
	
	//initial values
	reset_n = 1; 
	instruction_type = I;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;
	
	/////TEST RESET////////////
	
	#(CYCLE) //locationd:pc = 0
	reset_n = 0;	
	

	////////TEST DONT TAKE BRANCH////////
	write_reg_file(1,2);
	write_inst_mem(4/4,{7'd0,5'd1,20'd0}); 
	
	#(CYCLE) //location:pc = 4
	reset_n = 1;
	
	instruction_type = R; //instruction is B type
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD; //addind x0 to x1 so zero should not be set by alu
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = '1; //branch is set

		

	//////////TEST BRANCH FORWARDS/////////////
	
	imm = 12'd2028; //imm used to branch forward to pc=pc+2028
	
	//program mem location 8 with imm usiing B type instruction
	//both source registers for ALU point at register x0
	write_inst_mem(8/4,{imm[12],imm[10:5],5'd0,5'd0,3'd0,imm[4:1],imm[11],7'd0}); 
			
	#(CYCLE)//location:pc = 8
	
	instruction_type = B; //instruction is B type
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD; //addind x0 to x0 so zero should be set by alu
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = '1; //branch is set

	
	#CYCLE //location:pc = 2036
		
	//should have jumped forward to location pc = 2036
	instruction_type = I;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;


	////////TEST BRANCH BACKWARDS////////
		
	imm = -12'd2028; //immediate used to jump backwards to location pc=pc-2028
	
	//program B type instruction with imm  to jump backwards
	//alu source register point to register x0
	write_inst_mem(2040/4,{imm[12],imm[10:5],5'd0,5'd0,3'd0,imm[4:1],imm[11],7'd0}); 	
	
	#(CYCLE)//location:pc = 2040
	
	instruction_type = B;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD; //adding x0 to x0 so zero should be set 
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = '1; //branch is set
	
	#CYCLE//location:pc = 12

	//should have jumped to location pc=12	
	instruction_type = I;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;

	////////TEST REG FILE READ///////
		
	write_reg_file(1,1); //write 1 to x1
	write_reg_file(2,2); //write 2 to x2
	
	//read from x1, x2 
	write_inst_mem(16/4,{7'd0,5'd2,5'd1,3'd0,5'd0,7'd0}); //R type inst
	
	#(CYCLE)//location:pc = 16
		
	//should read x1=1 and x2=2 from reg file
	instruction_type = R;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD; 
	alu_sel_1 = '0;
	alu_sel_2 = '0;
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;
	
	////////TEST ALU OPERATION USING BOTH REGISTERS///////
			
	//read from x1, x2 
	write_inst_mem(20/4,{7'd0,5'd2,5'd1,3'd0,5'd0,7'd0}); //R type inst
	
	#(CYCLE)//location:pc = 20
		
	//ALU resulst should be 3
	instruction_type = R;
	reg_file_wr =REG_NO_WR ;
	alu_op = ADD;//add values from reg file x1 and x2 
	alu_sel_1 = '0;
	alu_sel_2 = '0; //sel regfile as second input to ALU
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;

	////////TEST ALU OPERATION USING REG AND IMMEDIATE///////
			
	imm = -12'd3; //imm should be -3
	//read from reg x1
	write_inst_mem(24/4,{imm,5'd1,3'd0,5'd0,7'd0}); //I type inst with imm and sourve reg set
	
	#(CYCLE)//location:pc = 24
		
	//ALU resulst should be -2
	instruction_type = I;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//add values from reg file x1 and imm 
	alu_sel_1 = '1;
	alu_sel_2 = '1; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;



	////////TEST DATA MEMORY READ///////
		
	write_data_mem(0,0);	
	imm = 12'd0; //imm should be 0
	//read from reg x0
	write_inst_mem(28/4,{imm,5'd0,3'd0,5'd0,7'd0}); //I type inst with imm and sourve reg set
	
	#(CYCLE)//location:pc = 28
		
	//data_memory rd_data should be 1
	instruction_type = I;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '1; //sel imm as second input to alu
	mem_wr = 0;
	wb_sel = '0;
	branch = BRANCH_NO;


	////////TEST DATA MEMORY READ///////
		
	write_reg_file(1,4);
	write_reg_file(2,8);
	//read from reg x0
	write_inst_mem(32/4,{7'd0,5'd1,5'd0,3'd0,5'd0,7'd0}); //I type inst with imm and sourve reg set
	
	#(CYCLE)//location:pc = 32

	#0
	//should write 1 into data memory location 1
	instruction_type = R;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '0; //sel imm as second input to alu
	mem_wr = '1;
	wb_sel = '0;
	branch = BRANCH_NO;
		
	//read from reg x0
	write_inst_mem(36/4,{7'd0,5'd2,5'd0,3'd0,5'd0,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = R;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '0; //sel imm as second input to alu
	mem_wr = '1;
	wb_sel = '0;
	branch = BRANCH_NO;



	////////TEST WRITE BACK from ALU///////
		
	write_reg_file(1,-77);
	//read from reg x0
	write_inst_mem(40/4,{7'd0,5'd1,5'd0,3'd0,5'd3,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = R;
	reg_file_wr = REG_W_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '0; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '1;
	branch = BRANCH_NO;


	////////TEST WRITE BACK from memory///////
		
	//read from reg x0
	write_inst_mem(44/4,{7'd0,5'd0,5'd0,3'd0,5'd4,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = R;
	reg_file_wr =REG_W_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '0; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;




	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = R;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '0; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;

///////////////////////////////



	write_reg_file(5,15);
	write_reg_file(6,32'hFC5560FB);
	//read from reg x0
	write_inst_mem(52/4,{7'd0,5'd6,5'd5,3'd0,5'd0,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = S;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '1; //sel imm as second input to alu
	mem_wr = '1;
	wb_sel = '0;
	branch = BRANCH_NO;

	//write_reg_file(1,15);
	//write_reg_file(2,32'h000000FB);
	//read from reg x0
	write_inst_mem(56/4,{7'd0,5'd0,5'd5,3'd0,5'd30,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = I;
	reg_file_wr = REG_B_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '1; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;


	write_inst_mem(60/4,{7'd0,5'd0,5'd5,3'd0,5'd31,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = I;
	reg_file_wr = REG_BU_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '1; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;

//	write_inst_mem(60/4,{7'd0,5'd1,5'd0,3'd0,5'd8,7'd0}); //I type inst with imm and sourve reg se
	
	#(CYCLE)//location:pc = 28
	#0		
	//should write 1into data memory location 1
	instruction_type = R;
	reg_file_wr = REG_NO_WR ;
	alu_op = ADD;//ALU res should be 0, used as addr for data mem 
	alu_sel_1 = '0;
	alu_sel_2 = '1; //sel imm as second input to alu
	mem_wr = '0;
	wb_sel = '0;
	branch = BRANCH_NO;




end

endmodule
