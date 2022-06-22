module tb_control();

logic clk;
logic reset_n;
logic alu_sel_1;
logic alu_sel_2;
logic [3:0] mem_wr;
logic wb_sel;
logic reg_wr_sel;
logic [1:0] jump;
logic [2:0] branch;

logic [31:0] instruction;                
 
enum logic [3:0]{
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
	R = 3'b101}instruction_type;

enum logic [3:0] {
	ALU_ADD = 4'b0000,
	ALU_SUB = 4'b0001,
	ALU_SHIFT_L = 4'd2,
	ALU_SHIFT_RL = 4'd3,
	ALU_SHIFT_RA = 4'd11,
	ALU_SET_LT  = 4'd4,
	ALU_SET_LTU = 4'd5,
	ALU_XOR     = 4'd6,
	ALU_OR      = 4'd7,
	ALU_AND     = 4'd8,
	ALU_PASS_A  = 4'd9,
	ALU_PASS_B  = 4'd10}alu_op;


parameter DATA_MEM_NO_WR = 4'b0000;
parameter DATA_MEM_B_WR  = 4'b0001;
parameter DATA_MEM_H_WR  = 4'b0011;
parameter DATA_MEM_W_WR  = 4'b1111;

parameter BRANCH_NO = 2'd0;
parameter BRANCH_EQ = 2'd1;
parameter BRANCH_NE = 2'd2;
parameter BRANCH_LT = 2'd3;
parameter BRANCH_LTU = 2'd4;
parameter BRANCH_GE = 2'd5;
parameter BRANCH_GEU = 2'd6;


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
parameter M_SLL    = {7'bx,10'bx,3'b001,5'bx,7'b0110011};
parameter M_SLT    = {7'bx,10'bx,3'b010,5'bx,7'b0110011};
parameter M_SLTU   = {7'bx,10'bx,3'b011,5'bx,7'b0110011};
parameter M_XOR    = {7'bx,10'bx,3'b100,5'bx,7'b0110011};
parameter M_SRL    = {7'b0000000,10'bx,3'b101,5'bx,7'b0110011};
parameter M_SRA    = {7'b0100000,10'bx,3'b101,5'bx,7'b0110011};
parameter M_OR     = {7'bx,10'bx,3'b110,5'bx,7'b0110011};
parameter M_AND    = {7'bx,10'bx,3'b111,5'bx,7'b0110011};
parameter M_LUI    = {7'bx,10'bx,3'bx,5'bx,7'b0110111};
parameter M_BEQ    = {7'bx,10'bx,3'b000,5'bx,7'b1100011};
parameter M_BNE    = {7'bx,10'bx,3'b001,5'bx,7'b1100011};
parameter M_BLT    = {7'bx,10'bx,3'b100,5'bx,7'b1100011};
parameter M_BGE    = {7'bx,10'bx,3'b101,5'bx,7'b1100011};
parameter M_BLTU   = {7'bx,10'bx,3'b110,5'bx,7'b1100011};
parameter M_BGEU   = {7'bx,10'bx,3'b111,5'bx,7'b1100011};
parameter M_JALR   = {7'bx,10'bx,3'bx,5'bx,7'b1100111};
parameter M_JAL    = {7'bx,10'bx,3'd0,5'bx,7'b1101111};
parameter M_EM_CALL= {7'b000000,10'bx,3'b000,5'bx,7'b1110011};
parameter M_EBREAK = {7'b000001,10'bx,3'b000,5'bx,7'b1110011};                             

parameter OP_LOAD       = 7'b0000011;
parameter OP_FENCE      = 7'b0001111;
parameter OP_COMP_IMM   = 7'b0010011;
parameter OP_AUIPC      = 7'b0010111;
parameter OP_STORE      = 7'b0100011;
parameter OP_COMP_REG   = 7'b0110011;
parameter OP_LUI        = 7'b0110111;
parameter OP_BRANCH     = 7'b1100011;
parameter OP_JALR       = 7'b1100111;
parameter OP_JAL        = 7'b1101111;
parameter OP_SYSTEM     = 7'b1110011;

                                        
                                         
parameter CYCLE = 100; //clock cycle     
parameter MEM_DEPTH = 2048; // size of me,mory
integer i;
integer imm; 

logic [31:0] addr;

instruction_memory #(.INST_MEM_DEPTH(2048)) instruction_memory(.*); //read instrucion from inst memory then have control decode it

//instantiate data path 
control  dut(		//control dut
	.instruction_type({instruction_type}),
	.alu_op({alu_op}),
	.reg_file_wr({reg_file_wr}),
	.*);

//taskt to write a 4 byte value into instruction mem block ram at location
task write_inst_mem(integer location,integer value);

	{instruction_memory.block_ram_3.mem[location],
	instruction_memory.block_ram_2.mem[location],
	instruction_memory.block_ram_1.mem[location],
	instruction_memory.block_ram_0.mem[location]} = value; 

endtask
initial begin //clock ignal with period = CYCLE
	clk = 1; 
	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	write_inst_mem(0,M_LB);
	write_inst_mem(1,M_LH);
	write_inst_mem(2,M_LW);
	write_inst_mem(3,M_LBU);
	write_inst_mem(4,M_LHU);
	write_inst_mem(5,M_SLLI);
	write_inst_mem(6,M_SLTI);
	write_inst_mem(7,M_SLTIU);
	write_inst_mem(8,M_XORI);
	write_inst_mem(9,M_SRLI);
	write_inst_mem(10,M_SRAI);
	write_inst_mem(11,M_ORI);
	write_inst_mem(12,M_ANDI);
	write_inst_mem(13,M_LUI);
	write_inst_mem(14,M_AUIPC);
	write_inst_mem(15,M_SB);
	write_inst_mem(16,M_SH);
	write_inst_mem(17,M_SW);
	write_inst_mem(18,M_ADD);
	write_inst_mem(19,M_SUB);
	write_inst_mem(20,M_SLL);
	write_inst_mem(21,M_SLT);
	write_inst_mem(22,M_SLTU);
	write_inst_mem(23,M_XOR);
	write_inst_mem(24,M_SRL);
	write_inst_mem(25,M_SRA);
	write_inst_mem(26,M_OR);;
	write_inst_mem(27,M_AND);
	
	write_inst_mem(28,M_BEQ);
	write_inst_mem(29,M_BNE);
	write_inst_mem(30,M_BLT);
	write_inst_mem(31,M_BLTU);
	write_inst_mem(32,M_BGE);
	write_inst_mem(33,M_BGEU);
	
	write_inst_mem(34,M_JAL);
	write_inst_mem(35,M_JALR);
	#CYCLE
	addr = 32'd0;
	#CYCLE
	addr = 32'd4;
	#CYCLE
	addr = 32'd8;
	#CYCLE
	addr = 32'd12;
	#CYCLE
	addr = 32'd16;
	#CYCLE
	addr = 32'd20;
	#CYCLE
	addr = 32'd24;
	#CYCLE
	addr = 32'd28;
	#CYCLE
	addr = 32'd32;
	#CYCLE
	addr = 32'd36;
	#CYCLE
	addr = 32'd40;
	#CYCLE
	addr = 32'd44;
	#CYCLE
	addr = 32'd48;
	#CYCLE
	addr = 32'd52;
	#CYCLE
	addr = 32'd56;
	#CYCLE
	addr = 32'd60;
	#CYCLE
	addr = 32'd64;
	#CYCLE
	addr = 32'd68;
	#CYCLE
	addr = 32'd72;
	#CYCLE
	addr = 32'd76;
	#CYCLE
	addr = 32'd80;
	#CYCLE
	addr = 32'd84;
	#CYCLE
	addr = 32'd88;
	#CYCLE
	addr = 32'd92;
	#CYCLE
	addr = 32'd96;
	#CYCLE
	addr = 32'd100;
	#CYCLE
	addr = 32'd104;
	#CYCLE
	addr = 32'd108;
	#CYCLE
	addr = 32'd109;
	#CYCLE
	addr = 32'd110;
	#CYCLE
	addr = 32'd114;
	#CYCLE
	addr = 32'd118;
	#CYCLE
	addr = 32'd122;
	#CYCLE
	addr = 32'd126;
	#CYCLE
	addr = 32'd130;
	#CYCLE
	addr = 32'd134;
	#CYCLE
	addr = 32'd138;
	#CYCLE
	addr = 32'd142;




end

endmodule
