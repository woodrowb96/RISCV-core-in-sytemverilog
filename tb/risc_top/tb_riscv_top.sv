import package_project_typedefs::*;

module tb_riscv_top();

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

//instantiate riscv core dut
riscv_top dut(.*);

task write_ram(integer word,integer value);
//	$display(word>>1);
	{dut.ram.mem[(word >> 1) + 1],
	dut.ram.mem[word >> 1]} = value; 

endtask
task read_ram(integer location);

	$display("NUM: %d ADDR: %d VAL: %d",location/2,location,$signed(dut.ram.mem[location >> 1][7:0])); 
	$display("NUM: %d ADDR: %d VAL: %d",location/2 + 1,location,$signed(dut.ram.mem[location >> 1][15:8])); 
	$display("NUM: %d ADDR: %d VAL: %d",location/2 + 2,location,$signed(dut.ram.mem[(location >> 1) + 1][7:0])); 
	$display("NUM: %d ADDR: %d VAL: %d",location/2 + 3,location,$signed(dut.ram.mem[(location >> 1) + 1][15:8])); 

endtask



task write_reg_file(integer location,integer value);

	{dut.riscv_core.data_path.instruction_decode.register_file.reg_file[location]} = value; 

endtask

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
	end
endtask

initial begin //clock signal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end





initial begin
	write_ram(0,32'hABFA0CFB);	
	write_ram(1,32'h123456F0);	
	
	prog_inst_mem_i(0,M_LB,12'd0,5'd0,5'd1);	//test loads
	prog_inst_mem_i(1,M_LBU,12'd0,5'd0,5'd2);
	prog_inst_mem_i(2,M_LH,12'd0,5'd0,5'd3);
	prog_inst_mem_i(3,M_LHU,12'd0,5'd0,5'd4);
	prog_inst_mem_i(4,M_LW,12'd0,5'd0,5'd5);
	prog_inst_mem_i(5,M_LB,12'd1,5'd0,5'd6);	//test missaligned loads
	prog_inst_mem_i(6,M_LBU,12'd1,5'd0,5'd7);
	prog_inst_mem_i(7,M_LH,12'd3,5'd0,5'd8);
	prog_inst_mem_i(8,M_LHU,12'd3,5'd0,5'd9);
	prog_inst_mem_i(9,M_LW,12'd3,5'd0,5'd10);

	prog_inst_mem_i(10,M_ADDI,12'h0DB,5'd0,5'd11);	//test immediate comp
	prog_inst_mem_i(11,M_SLLI,12'd16,5'd11,5'd12);
	write_reg_file(13,-57);
	prog_inst_mem_i(12,M_SLTI,-12'd56,5'd13,5'd13);
	write_reg_file(14,-57);
	prog_inst_mem_i(13,M_SLTI,-12'd58,5'd14,5'd14);
	write_reg_file(15,-1);
	prog_inst_mem_i(14,M_SLTIU,-12'd58,5'd15,5'd15);
	write_reg_file(16,-58);
	prog_inst_mem_i(15,M_SLTIU,-12'd1,5'd16,5'd16);
	write_reg_file(17,32'hF0FFFFF0);
	prog_inst_mem_i(16,M_XORI,12'hF0F,5'd17,5'd17);
	prog_inst_mem_i(17,M_SRLI,{7'b0000000,5'd16},5'd12,5'd18);
	write_reg_file(19,32'hF000BCF0);
	prog_inst_mem_i(18,M_SRAI,{7'b0100000,5'd4},5'd19,5'd19);
	write_reg_file(20,32'h0000BCF0);
	prog_inst_mem_i(19,M_SRAI,{7'b0100000,5'd4},5'd20,5'd20);
	write_reg_file(21,32'hFFFF0501);
	prog_inst_mem_i(20,M_ORI,12'h0F0,5'd21,5'd21);
	write_reg_file(22,32'hFFFF0501);
	prog_inst_mem_i(21,M_ANDI,12'h0FF,5'd22,5'd22);
	
	prog_inst_mem_u(22,M_LUI,20'hFABCD,5'd23);	//lui
	prog_inst_mem_u(23,M_AUIPC,20'h000F,5'd24);	//auipc

	prog_inst_mem_s(24,M_SB,12'd2036,5'd24,5'd0);	//test stores
	prog_inst_mem_i(25,M_LB,12'd2036,5'd0,5'd25);

	prog_inst_mem_s(26,M_SH,12'd2040,5'd24,5'd0);
	prog_inst_mem_i(27,M_LH,12'd2040,5'd0,5'd26);
	
	prog_inst_mem_s(28,M_SW,12'd2044,5'd10,5'd0);
	prog_inst_mem_i(29,M_LW,12'd2044,5'd0,5'd27);
	
	write_reg_file(28,32'd5);
	write_reg_file(29,-32'd3);
	prog_inst_mem_r(30,M_ADD,5'd28,5'd29,5'd30);	//test register comp
	prog_inst_mem_r(31,M_SUB,5'd29,5'd28,5'd31);
	prog_inst_mem_r(32,M_SLL,5'd31,5'd27,5'd27);;
	prog_inst_mem_r(33,M_SLT,5'd26,5'd27,5'd1);
	prog_inst_mem_r(34,M_SLTU,5'd26,5'd27,5'd2);
	prog_inst_mem_r(35,M_XOR,5'd19,5'd23,5'd3);
	prog_inst_mem_r(36,M_SRL,5'd31,5'd19,5'd4);
	prog_inst_mem_r(37,M_SRA,5'd31,5'd19,5'd5);
	prog_inst_mem_r(38,M_OR,5'd23,5'd19,5'd6);
	prog_inst_mem_r(39,M_AND,5'd23,5'd19,5'd7);
	
	prog_inst_mem_b(40,M_BEQ,12'd120,5'd31,5'd30);	//dont take
	prog_inst_mem_b(41,M_BEQ,12'd120,5'd22,5'd2);	//take

	prog_inst_mem_b(71,M_BNE,12'd100,5'd22,5'd2);	//dont take
	prog_inst_mem_b(72,M_BNE,-12'd120,5'd31,5'd2);	//take


	prog_inst_mem_b(42,M_BLT,12'd120,5'd21,5'd25);	//dont take
	prog_inst_mem_b(43,M_BLT,12'd120,5'd31,5'd31);	//dont  take
	prog_inst_mem_b(44,M_BLT,12'd116,5'd31,5'd28);	//take
	
	prog_inst_mem_b(73,M_BLTU,-12'd120,5'd25,5'd21);	//dont take 
	prog_inst_mem_b(74,M_BLTU,-12'd120,5'd25,5'd25);	//dont take
	prog_inst_mem_b(75,M_BLTU,-12'd120,5'd21,5'd25);	//take

	prog_inst_mem_b(45,M_BGE,12'd120,5'd25,5'd21);	//dont take
	prog_inst_mem_b(46,M_BGE,12'd120,5'd21,5'd21);	//take 
	prog_inst_mem_b(76,M_BGE,-12'd116,5'd21,5'd25);	//take

	prog_inst_mem_b(47,M_BGEU,12'd120,5'd21,5'd25);	//dont take
	prog_inst_mem_b(48,M_BGEU,12'd120,5'd21,5'd21);	// take
	prog_inst_mem_b(78,M_BGEU,-12'd112,5'd25,5'd21);	//dont take
	
	prog_inst_mem_j(50,M_JAL,20'd500,5'd1);		//jump
	prog_inst_mem_i(175,M_JALR,12'd0,5'd1,5'd0);	//return from jump using return reg
	
end

initial begin

	reset_n = 1;
	#CYCLE

	reset_n = 0;
	#CYCLE
	reset_n = 1;

	#(CYCLE*750)
	force_write_back();
end

endmodule
