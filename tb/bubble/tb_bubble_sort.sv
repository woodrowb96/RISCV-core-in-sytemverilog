import package_project_typedefs::*;

module tb_bubble_sort();

//input signals
logic clk;
logic reset_n;

parameter M_LB     = {7'bx,10'bx,3'b000,5'bx,7'b0000011};
parameter M_LH     = {7'bx,10'bx,3'b001,5'bx,7'b0000011};
parameter M_LW     = {7'bx,10'bx,3'b010,5'bx,7'b0000011};
parameter M_LBU    = {7'bx,10'bx,3'b100,5'bx,7'b0000011};
parameter M_LHU    = {7'bx,10'bx,3'b101,5'bx,7'b0000011};
parameter M_FENCE  = {7'bx,10'bx,3'bx,5'bx,7'b0001111};
parameter M_ADDI   = {7'bx,10'bx,3'b000,5'bx,7'b0010011};
parameter M_SLLI   = {7'bx,10'bx,3'b001,5'bx,7'b0010011};
parameter M_SLTI   = {7'bx,10'bx,3'b010,5'bx,7'b0010011};
parameter M_SLTIU  = {7'bx,10'bx,3'b011,5'bx,7'b0010011};
parameter M_XORI   = {7'bx,10'bx,3'b100,5'bx,7'b0010011};
parameter M_SRLI   = {7'b0000000,10'bx,3'b101,5'bx,7'b0010011};
parameter M_SRAI   = {7'b0100000,10'bx,3'b101,5'bx,7'b0010011};
parameter M_ORI    = {7'bx,10'bx,3'b110,5'bx,7'b0010011};
parameter M_ANDI   = {7'bx,10'bx,3'b111,5'bx,7'b0010011};
parameter M_AUIPC  = {7'bx,10'bx,3'bx,5'bx,7'b0010111};
parameter M_SB     = {7'bx,10'bx,3'b000,5'bx,7'b0100011};
parameter M_SH     = {7'bx,10'bx,3'b001,5'bx,7'b0100011};
parameter M_SW     = {7'bx,10'bx,3'b010,5'bx,7'b0100011}; 
parameter M_ADD    = {7'b0000000,10'bx,3'b000,5'bx,7'b0110011};
parameter M_SUB    = {7'b0100000,10'bx,3'b000,5'bx,7'b0110011};
parameter M_SLL    = {7'd0,10'bx,3'b001,5'bx,7'b0110011};
parameter M_SLT    = {7'b0,10'bx,3'b010,5'bx,7'b0110011};
parameter M_SLTU   = {7'd0,10'bx,3'b011,5'bx,7'b0110011};
parameter M_XOR    = {7'd0,10'bx,3'b100,5'bx,7'b0110011};
parameter M_SRL    = {7'b0000000,10'bx,3'b101,5'bx,7'b0110011};
parameter M_SRA    = {7'b0100000,10'bx,3'b101,5'bx,7'b0110011};
parameter M_OR     = {7'd0,10'bx,3'b110,5'bx,7'b0110011};
parameter M_AND    = {7'd0,10'bx,3'b111,5'bx,7'b0110011};
parameter M_LUI    = {7'bx,10'bx,3'bx,5'bx,7'b0110111};
parameter M_BEQ    = {7'bx,10'bx,3'b000,5'bx,7'b1100011};
parameter M_BNE    = {7'bx,10'bx,3'b001,5'bx,7'b1100011};
parameter M_BLT    = {7'bx,10'bx,3'b100,5'bx,7'b1100011};
parameter M_BGE    = {7'bx,10'bx,3'b101,5'bx,7'b1100011};
parameter M_BLTU   = {7'bx,10'bx,3'b110,5'bx,7'b1100011};
parameter M_BGEU   = {7'bx,10'bx,3'b111,5'bx,7'b1100011};
parameter M_JALR   = {7'bx,10'bx,3'd0,5'bx,7'b1100111};
parameter M_JAL    = {7'bx,10'bx,3'bx,5'bx,7'b1101111};
parameter M_EM_CALL= {7'b000000,10'bx,3'b000,5'bx,7'b1110011};
parameter M_EBREAK = {7'b000001,10'bx,3'b000,5'bx,7'b1110011};                             
                                        
parameter CYCLE = 100; //clock cycle     
parameter RAM_DEPTH = 8192;

integer i;
integer imm; 
logic [31:0] machine_code;

//instantiate data path 
riscv_top dut(.*);

task write_ram(integer word,integer value);

	{dut.ram.mem[(word >> 1) + 1],
	dut.ram.mem[word >> 1]} = value; 

endtask
task read_ram(integer location);

	$display("NUM: %d ADDR: %d VAL: %d",location/4,location,$signed({dut.ram.mem[(location >> 1) + 1],
							dut.ram.mem[location >> 1]})); 


endtask



task write_reg_file(integer location,integer value);

	{dut.riscv_core.data_path.instruction_decode.register_file.reg_file[location]} = value; 

endtask
initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end


//initialiaze instr memory
initial begin	
	for(i=0;i < (RAM_DEPTH * 2);i=i+1) begin
	//	write_ram(i,i*4); //each location hold value of pc that pints at location
	end
end

task prog_inst_mem_i(integer location,integer inst,integer immediate,integer rs_1,integer rs_d);
	machine_code = inst;
	machine_code[31:20] = immediate;
	machine_code[19:15] = rs_1;
	machine_code[11:7] = rs_d;
	write_ram(location*4,machine_code);
endtask

task prog_inst_mem_u(integer location,integer inst,integer immediate,integer rs_d);
	machine_code = inst;
	machine_code[31:12] = immediate;
	machine_code[11:7] = rs_d;
	write_ram(location*4,machine_code);
endtask

task prog_inst_mem_s(integer location,integer inst,integer immediate,integer rs_2,integer rs_1);
	machine_code = inst;
	machine_code[31:25] = immediate[11:5];
	machine_code[11:7] = immediate[4:0];
	machine_code[24:20] = rs_2;
	machine_code[19:15] = rs_1;
	write_ram(location*4,machine_code);
endtask

task prog_inst_mem_b(integer location,integer inst,integer immediate,integer rs_2,integer rs_1);
	machine_code = inst;
	machine_code[31] = immediate[12];
	machine_code[30:25] = immediate[10:5];
	machine_code[24:20] = rs_2;
	machine_code[19:15] = rs_1;
	machine_code[11:8] = immediate[4:1];
	machine_code[7] = immediate[11];
	write_ram(location*4,machine_code);
endtask

task prog_inst_mem_r(integer location,integer inst,integer rs_2,integer rs_1,integer rs_d);
	machine_code = inst;
	machine_code[24:20] = rs_2;
	machine_code[19:15] = rs_1;
	machine_code[11:7] = rs_d;
	write_ram(location*4,machine_code);
endtask

task prog_inst_mem_j(integer location,integer inst,integer immediate,integer rs_d);
	
	machine_code = inst;
	machine_code[31] = immediate[20];
	machine_code[30:21] = immediate[10:1];
	machine_code[20] = immediate[11];
	machine_code[19:12] = immediate[19:12];
	machine_code[11:7] = rs_d;
	write_ram(location*4,machine_code);
endtask



reg[31:0] a;
integer seed,j;

integer length = 12'd400;
integer address = 12'd300;
initial begin
/*4j	
	static integer length = 12'd6;
	static integer address = 12'd2020;
*/	
	for(j= 0; j<length;j = j+ 1)begin
		a = $random;	
	//	$display(a);
		write_ram(address + (4*j),a);	
	end
/*
	write_data_mem(505,2009);
	write_data_mem(506,-2001);
	write_data_mem(507,2007);
	write_data_mem(508,2007);
	write_data_mem(509,2003);
	write_data_mem(510,2010);	
*/

	prog_inst_mem_i(0,M_ADDI,address,5'd0,5'd3);
	prog_inst_mem_i(1,M_ADDI,address,5'd0,5'd13);
	prog_inst_mem_i(2,M_ADDI,address,5'd0,5'd14);
	prog_inst_mem_i(3,M_ADDI,length,5'd0,5'd4);
	prog_inst_mem_i(4,M_ADDI,length,5'd0,5'd8);
	prog_inst_mem_i(5,M_ADDI,length,5'd0,5'd12);
	prog_inst_mem_i(6,M_ADDI,12'd1,5'd0,5'd11);
	prog_inst_mem_i(7,M_ADDI,12'd2,5'd0,5'd17);
	
	prog_inst_mem_i(8,M_LW,12'd0,5'd3,5'd5);
	prog_inst_mem_i(9,M_LW,12'd4,5'd13,5'd6);
	prog_inst_mem_b(10,M_BLT,12'd20,5'd5,5'd6);
	prog_inst_mem_i(11,M_ADDI,12'd4,5'd13,5'd13);
	prog_inst_mem_i(12,M_ADDI,-12'd1,5'd4,5'd4);
	prog_inst_mem_b(13,M_BEQ,12'd24,5'd4,5'd11);
	prog_inst_mem_j(14,M_JAL,-12'd24,5'd0);

	prog_inst_mem_r(15,M_ADD,5'd0,5'd6,5'd7);
	prog_inst_mem_s(16,M_SW,12'd4,5'd5,5'd13);
	prog_inst_mem_s(17,M_SW,12'd0,5'd7,5'd3);
	prog_inst_mem_j(18,M_JAL,-12'd40,5'd0);

	prog_inst_mem_i(19,M_ADDI,12'd4,5'd3,5'd3);
	prog_inst_mem_r(20,M_ADD,5'd0,5'd3,5'd13);
	prog_inst_mem_i(21,M_ADDI,-12'd1,5'd8,5'd4);
	prog_inst_mem_i(22,M_ADDI,-12'd1,5'd8,5'd8);
	prog_inst_mem_b(23,M_BEQ,12'd8,5'd11,5'd8);
	prog_inst_mem_j(24,M_JAL,-12'd64,5'd0);


	prog_inst_mem_j(25,M_JAL,12'd0,5'd0);
end

task force_write_back;
	integer word;
	integer value;
	logic [21:0] tag;
	logic [7:0] index;
	integer valid;		
	integer location;		

	for(i=0;i<256;i=i+1)begin

		valid = dut.riscv_core.data_path.memory_access.data_cache.valid[i];
		tag = dut.riscv_core.data_path.memory_access.data_cache.tag[i];
		index = i[7:0];
		location = {tag,index,2'b00};
		value = {dut.riscv_core.data_path.memory_access.data_cache.block_ram_3.mem[i],
			dut.riscv_core.data_path.memory_access.data_cache.block_ram_2.mem[i],
			dut.riscv_core.data_path.memory_access.data_cache.block_ram_1.mem[i],
			dut.riscv_core.data_path.memory_access.data_cache.block_ram_0.mem[i]};
		
		if(valid) write_ram(location,value);
//		$display(tag);	
//		$display(index);	
//		$display(location);	
//		$display(value);	
	//	{dut.riscv_core.data_path.instruction_decode.register_file.reg_file[location]} = value; 
	end
endtask

initial begin

	for(j= 0; j<length;j = j+ 1)begin		
		read_ram(address + (4*j));	
	end
	reset_n = 1;
	#CYCLE

	reset_n = 0;
	#CYCLE
	reset_n = 1;
	
//	#(CYCLE*68360)
	#(CYCLE*2900000)
	
	$display("SORTED");


	force_write_back();

	for(j= 0; j<length;j = j+ 1)begin		
		read_ram(address + (4*j));	
	end
end

endmodule
