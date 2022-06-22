//contains all typedefs used in project

package package_project_typedefs;
	typedef enum logic [3:0] { // alu control operations
		ALU_ADD      = 4'd0,
		ALU_SUB      = 4'd1,
		ALU_SHIFT_L  = 4'd2,
		ALU_SHIFT_RL = 4'd3,
		ALU_SHIFT_RA = 4'd11,
		ALU_SET_LT   = 4'd4,
		ALU_SET_LTU  = 4'd5,
		ALU_XOR      = 4'd6,
		ALU_OR       = 4'd7,
		ALU_AND      = 4'd8,
		ALU_PASS_A   = 4'd9,
		ALU_PASS_B   = 4'd10,
		ALU_PC_INC   = 4'd12}AluControl;

	typedef enum logic [2:0] { // different instruction types used by immediate generation
		I = 3'b000,	
		S = 3'b001,
		B = 3'b010,
		U = 3'b011,
		J = 3'b100,
		R = 3'b101}ImmGenControl;

	typedef enum logic [3:0] { 	//different cache rd control modes
		CACHE_NO_RD = 4'b0000,
		CACHE_B_RD  = 4'b0001,
		CACHE_H_RD  = 4'b0011,
		CACHE_W_RD  = 4'b0101,
		CACHE_BU_RD = 4'b1001,
		CACHE_HU_RD = 4'b1011}CacheRdControl;


	typedef enum logic [3:0]  { 	//diff cache write control modes
		CACHE_NO_WR = 4'b0000,
		CACHE_B_WR  = 4'b0001,
		CACHE_H_WR  = 4'b0011,
		CACHE_W_WR  = 4'b1111}CacheWrControl;


	typedef enum logic [3:0] {	//different branch types, including jumps
		NO_JUMP_BRANCH = 4'd0,
		BRANCH_EQ      = 4'd1,
		BRANCH_NE      = 4'd2,
		BRANCH_LT      = 4'd3,
		BRANCH_LTU     = 4'd4,
		BRANCH_GE      = 4'd5,
		BRANCH_GEU     = 4'd6,
		JUMP_AL        = 4'd7,
		JUMP_ALR       = 4'd8}BranchControl;

	typedef enum logic [1:0] {	//output control from forwarding unit
		NO_FWD     = 2'd0,
		EX_ID_FWD  = 2'd1,
		MEM_ID_FWD = 2'd2,
		WB_ID_FWD  = 2'd3}ForwardingControl;


	typedef enum logic [5:0] { //different RISCV instructions
		LB     = 6'd0,
		LH     = 6'd1,
		LW     = 6'd2,
		LBU    = 6'd3,
		LHU    = 6'd4,
		FENCE  = 6'd5,
		ADDI   = 6'd6,
		SLLI   = 6'd7,
		SLTI   = 6'd8,
		SLTIU  = 6'd9,
		XORI   = 6'd10,
		SRLI   = 6'd11,
		SRAI   = 6'd12,
		ORI    = 6'd13,
		ANDI   = 6'd14,
		AUIPC  = 6'd15,
		SB     = 6'd16,
		SH     = 6'd17,
		SW     = 6'd18,
		ADD    = 6'd19,
		SUB    = 6'd20,
		SLL    = 6'd21,
		SLT    = 6'd22,
		SLTU   = 6'd23,
		XOR    = 6'd24,
		SRL    = 6'd25,
		SRA    = 6'd26,
		OR     = 6'd27,
		AND    = 6'd28,
		LUI    = 6'd29,
		BEQ    = 6'd30,
		BNE    = 6'd31,
		BLT    = 6'd32,
		BGE    = 6'd33,
		BLTU   = 6'd34,
		BGEU   = 6'd35,
		JALR   = 6'd36,
		JAL    = 6'd37,
		ECALL  = 6'd38,
		EBREAK = 6'd39,
		ERROR  = 6'd40,
		NOP = 6'd41} RiscvInstructions;

	typedef enum logic [6:0] { //different riscv opcodes
		OP_LOAD       = 7'b0000011,
		OP_FENCE      = 7'b0001111,
		OP_COMP_IMM   = 7'b0010011,
		OP_AUIPC      = 7'b0010111,
		OP_STORE      = 7'b0100011,
		OP_COMP_REG   = 7'b0110011,
		OP_LUI        = 7'b0110111,
		OP_BRANCH     = 7'b1100011,
		OP_JALR       = 7'b1100111,
		OP_JAL        = 7'b1101111,
		OP_SYSTEM     = 7'b1110011}RiscvOpcodes;

	/////////////structs used to connect signals throughout pipeline///// 
	typedef struct {  
		logic [31:0] IF; //signal in instruction fetch
		logic [31:0] ID; //signal in inst decode
		logic [31:0] EX; //signal in execute
		logic [31:0] MEM;//signal in mem access
		logic [31:0] WB; // signal in write back
	} PipeLineSignal_32;  //signals are 32 bit logic

	typedef struct {
		logic [4:0] IF;
		logic [4:0] ID;
		logic [4:0] EX;
		logic [4:0] MEM;
		logic [4:0] WB;
	} PipeLineSignal_5; //signals are 5 bit logic

	typedef struct {
		logic [1:0] IF;
		logic [1:0] ID;
		logic [1:0] EX;
		logic [1:0] MEM;
		logic [1:0] WB;
	} PipeLineSignal_2;//signals are 2 bit logic



	typedef struct {
		logic  IF;
		logic  ID;
		logic  EX;
		logic  MEM;
		logic  WB;
	} PipeLineSignal_1; //1bib logic

	typedef struct {
		AluControl IF;
		AluControl ID;
		AluControl EX;
		AluControl MEM;
		AluControl WB;
	} PipeLineSignal_AluCntrl;  //alu control signal

	typedef struct {
		ImmGenControl IF;
		ImmGenControl ID;
		ImmGenControl EX;
		ImmGenControl MEM;
		ImmGenControl WB;
	} PipeLineSignal_ImmGenCntrl; //imm gen control signal	

	typedef struct {
		CacheRdControl IF;
		CacheRdControl ID;
		CacheRdControl EX;
		CacheRdControl MEM;
		CacheRdControl WB;
	} PipeLineSignal_CacheRdCntrl;

	typedef struct {
		CacheWrControl IF;
		CacheWrControl ID;
		CacheWrControl EX;
		CacheWrControl MEM;
		CacheWrControl WB;
	} PipeLineSignal_CacheWrCntrl;

	typedef struct {
		BranchControl IF;
		BranchControl ID;
		BranchControl EX;
		BranchControl MEM;
		BranchControl WB;
	} PipeLineSignal_BranchCntrl;

	typedef struct {
		RiscvInstructions IF;
		RiscvInstructions ID;
		RiscvInstructions EX;
		RiscvInstructions MEM;
		RiscvInstructions WB;
	} PipeLineSignal_RiscvInst;

	typedef struct {
		RiscvOpcodes IF;
		RiscvOpcodes ID;
		RiscvOpcodes EX;
		RiscvOpcodes MEM;
		RiscvOpcodes WB;	
	}PipeLineSignal_RiscvOpcodes;

	////structs used in the cache/////
	typedef struct {
		logic [31:0] ZERO;
		logic [31:0] ONE;
		logic [31:0] TWO;
		logic [31:0] THREE;
	}CachSubBlockSignal_32;

	typedef struct {
		logic [21:0] ZERO;
		logic [21:0] ONE;
		logic [21:0] TWO;
		logic [21:0] THREE;
	}CachSubBlockSignal_22;

	typedef struct {
		logic [7:0] ZERO;
		logic [7:0] ONE;
		logic [7:0] TWO;
		logic [7:0] THREE;
	}CachSubBlockSignal_8;



	typedef struct {
		logic  ZERO;
		logic  ONE;
		logic  TWO;
		logic THREE;
	}CachSubBlockSignal_1;


//////parameters used for tesbenches with machine code for diff riscv
//instructions


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
parameter M_NOP    = {7'b0000000,10'd0,3'b000,5'd0,7'b0110011};
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
 

endpackage

