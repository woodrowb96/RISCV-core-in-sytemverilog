module tb_imm_gen();

logic [2:0] instruction_type;
logic [31:0] instruction;
logic [31:0] immediate;

immediate_gen  dut(.*);	//imm gen dut


parameter CYCLE = 100;




initial begin

	instruction_type = 3'b111;
	instruction[31] = 1'b0;
	instruction[30:20] = 11'b10111110001;
	instruction[19:0] = 'x;

	#CYCLE 
	instruction_type = 3'b000;
	instruction[31] = 1'b0;
	instruction[30:20] = 11'b10111110001;
	instruction[19:0] = 'x;

	#CYCLE 
	instruction_type = 3'b000;
	instruction[31] = 1'b1;
	instruction[30:20] = 11'b10111110001;;
	instruction[19:0] = 'x;

	#CYCLE 
	instruction_type = 3'b001;
	instruction[31] = 1'b1;
	instruction[30:25] = 6'b101001;
	instruction[24:12] = 'x;
	instruction[11:7] = 5'b10101;

	#CYCLE 
	instruction_type = 3'b001;
	instruction[31] = 1'b0;
	instruction[30:25] = 6'b101001;
	instruction[24:12] = 'x;
	instruction[11:7] = 5'b10101;
	instruction[6:0] = 'x;

	#CYCLE 
	instruction_type = 3'b010;
	instruction[31] = 1'b1;
	instruction[30:25] = 6'b101001;
	instruction[24:12] = 'x;
	instruction[11:8] = 5'b1001;
	instruction[6:0] = 'x;

	#CYCLE 
	instruction_type = 3'b010;
	instruction[31] = 1'b0;
	instruction[30:25] = 6'b101001;
	instruction[24:12] = 'x;
	instruction[11:8] = 5'b1001;
	instruction[6:0] = 'x;;

	#CYCLE 
	instruction_type = 3'b011;
	instruction[31:12] = 20'b11000000000000000001;
	instruction[11:0] = 'x;;

	#CYCLE 
	instruction_type = 3'b100;
	instruction[31] = 1'b0;
	instruction[30:25] = 6'b101001;
	instruction[24:21] = 4'b1001;
	instruction[20] = 1'b0;
	instruction[19:12] = 8'b10101001;
	instruction[11:0] = 'x;;;

	#CYCLE 
	instruction_type = 3'b100;
	instruction[31] = 1'b1;
	instruction[30:25] = 6'b101001;
	instruction[24:21] = 4'b1001;
	instruction[20] = 1'b0;
	instruction[19:12] = 8'b10101001;
	instruction[11:0] = 'x;

	
end

endmodule
