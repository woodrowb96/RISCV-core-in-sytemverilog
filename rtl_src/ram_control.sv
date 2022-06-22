/*
state machine used to read amd write 32 bits to a 16bit wide ram module

reading/writting starts when ram_wr_start/ram_rd_start is set 

when reading/writting is done ram_control sets ram_rd_done/ram_wr_done for one clk cycle
*/
module ram_control(
	input logic clk, 
	input logic reset_n,

	input logic ram_wr_start,  //from cache_control to indicate begining of  writting process
	input logic ram_rd_start,  //from cache_control to indicate begining of reading process

	input logic [31:0] ram_wr_addr_base, //addr of lowest 16bits of 32bits needed to be written
	input logic [31:0] ram_wr_data_in, //32bits of data to be written to ram
	input logic [31:0] ram_rd_addr_base, //addr of lowest 16bits of 32bits to be read out of ram
	input logic [15:0] ram_rd_data_in, // 16bits read out of ram during one clk cycle

	output logic ram_wr_done,	 //set at end of wr proccess to indicate all 32bits have been written
	output logic ram_rd_done,	//set at end of rd proccess to indicate 32bits have been read from ram

	output logic [31:0] ram_rd_data_out, //32bits of data read in from ram

	output logic [15:0] ram_wr_data_out, //16bits of data that is written out to ram each clk cycle
	output logic ram_wr_en,			//enable signal sent to ram to enable writting
	output logic [31:0] ram_rd_addr,	//address of location in ram where we are currently reading from
	output logic [31:0] ram_wr_addr	//address of location in ram where we are currently writting to
);

enum logic [1:0] { 	//reading proccess states
	RD_IDLE,
	RD_1,
	RD_2,
	RD_DONE}rd_present_state,rd_present_next;
enum logic [1:0] { 	//writting process states
	WR_IDLE,
	WR_1,
	WR_2,
	WR_DONE}wr_present_state,wr_present_next;

logic ram_rd_shift; //set by rd state machine to enable shifting in of data from ram

	always_ff @(posedge clk, negedge reset_n) begin//state register, asysnch active low reset
		if(!reset_n)  begin //on reset go to idle 
			rd_present_state <= RD_IDLE; 
			wr_present_state <= WR_IDLE;
		end else begin
			rd_present_state <= rd_present_next;
			wr_present_state <= wr_present_next;
		end
	end

	always_ff @(posedge clk) begin //if enabled shift 16bits in from ram each clk cycle
		
		//16 bits are shifted in and combined to get all 32bits of
		//rd data from ram
		if(ram_rd_shift) ram_rd_data_out <= {ram_rd_data_in,ram_rd_data_out[31:16]};
	end

	//////read state machine//////
	always_comb begin //next state and output logic
		case(rd_present_state)
			RD_IDLE:begin //when idle do not read in new data
				ram_rd_done = 1'b0;
				ram_rd_addr = ram_rd_addr_base;
				ram_rd_shift = 1'b0; //do not shift data in
			
				//if ram_rd_start go to RD_1 and start reading	
				rd_present_next = ram_rd_start ? RD_1 : RD_IDLE; 
			end
			RD_1:begin //read first 16 bits in from ram
		
				ram_rd_done = 1'b0;	 //read is not done yet
				ram_rd_addr = ram_rd_addr_base; 	//read bottom 16 bits from ram
				ram_rd_shift = 1'b1; 	// shift bits in
				
				rd_present_next = RD_2; 	//move to next state
			end
			RD_2:begin //read top 16 bits in
				
				ram_rd_done = 1'b0; 	//not done yet
				ram_rd_addr = ram_rd_addr_base + 32'd1; 	//move to addr of top 16bits
				ram_rd_shift = 1'b1; 	//shift enabled
				
				rd_present_next =  RD_DONE; //move to done
			end
			RD_DONE:begin //indicate valid read data for one cycle

				ram_rd_done = 1'b1; 	//reading is now done
				ram_rd_addr = ram_rd_addr_base + 32'd1;
				ram_rd_shift = 1'b0; 	// no longer shifting in data
				
				rd_present_next =  RD_IDLE; //move to done
			end
			default:begin
				ram_rd_done = 1'b1;
				ram_rd_addr = 'x;
				ram_rd_shift = 1'b0;
				
				rd_present_next = RD_IDLE; 
			end
		endcase

		/////writting state machine////
		case(wr_present_state)
			WR_IDLE:begin //nothing is written out during idle
			
				ram_wr_done = 1'b0;
				ram_wr_en = 1'b0; //ram_wr_en is not set
				ram_wr_data_out = ram_wr_data_in[15:0];
				ram_wr_addr = ram_wr_addr_base;
					
				////if ram_wr_start go to WR_1 to start
				//writting to ram
				wr_present_next = ram_wr_start ? WR_1 : WR_IDLE; 
			end
			WR_1:begin //write out lowest 16bits to ram
		
				ram_wr_done = 1'b0;
				ram_wr_en = 1'b1; // set to enable writting
				ram_wr_data_out = ram_wr_data_in[15:0]; //write lowest 16bits
				ram_wr_addr = ram_wr_addr_base;
				
				wr_present_next = WR_2; //move to next state

			end
			WR_2:begin // write top 16bits to ram

				ram_wr_done = 1'b0;
				ram_wr_en = 1'b1; // set to enable writting

				ram_wr_data_out = ram_wr_data_in[31:16]; //write out top 16bits
				ram_wr_addr = ram_wr_addr_base + 32'd1; //write to addr of top 16bits
				
				wr_present_next =  WR_DONE; //move to done
			end
			WR_DONE:begin //inditcate succesfull write for one cycle

				ram_wr_done = 1'b1; //set to indicate write is finished
				ram_wr_en = 1'b0;	// no longer writting out to ram
				ram_wr_data_out = ram_wr_data_in[15:0];
				ram_wr_addr = ram_wr_addr_base + 32'd1;
				
				wr_present_next =  WR_IDLE; //go to idle 
			end
			default:begin
				ram_wr_done = 1'b1;
				ram_wr_en = 1'b0;
				ram_wr_data_out = ram_wr_data_in[15:0];
				ram_wr_addr = 'x;
				
				wr_present_next = WR_IDLE; 
			end
		endcase

	

		
	end

endmodule
