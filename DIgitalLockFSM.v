module DigitalLockFSM (
	input clock, 
	input reset,
	input [3:0] KEY,

	output reg LOCKED,
	output reg ERROR,
	output reg [15:0] pass					//for simulation only
); 

//State-Machine Registers
reg [1:0] state;
reg [15:0] password;
reg [15:0] passVerify;
reg [15:0] passUnlock;
reg [1:0] freezeCount;

//States
localparam SET = 2'b00;
localparam VERIFY = 2'b01;
localparam UNLOCK = 2'b10;
localparam FREEZE = 2'b11;

always @ (posedge clock or posedge reset) begin

	if (reset) begin
		pass <= 16'b0;
		LOCKED <= 1'b0;
		password <= 16'b0;
		passVerify <= 16'b0;
		passUnlock <= 16'b0;
		freezeCount <= 2'b0;
		ERROR <= 1'b0;
		state <= SET;
	end else begin
		case(state)
			
		SET: begin									//unlocked state of the lock, allowes the user to set the password
			LOCKED <= 1'b0;
			if(password[3:0] == 4'b0) begin	//check if password has been set. If not begin setting it
				if(KEY) begin						//wait for key press
					password[3:0] <= KEY;			//load in first key for the combination
				end else begin
					state <= SET;
				end
			end else if (password[7:4] == 4'b0) begin 
				if(KEY) begin
					password[7:4] <= KEY;
				end else begin
					state <= SET;
				end 
			end else if (password[11:8] == 4'b0) begin 
				if(KEY) begin
					password[11:8] <= KEY;
				end else begin
					state <= SET;
				end 	
			end else if (password[15:12] == 4'b0) begin 
				if(KEY) begin
					password[15:12] <= KEY;
				end else begin
					state <= SET;
				end 
			end else begin
				pass <= password;
				state <= VERIFY;				//when the entire combination is set, go to next state
			end
		end
		
		VERIFY: begin		//combination must be typed in a second time and verified that it matches the first
			LOCKED <= 1'b0;
			if(passVerify[3:0] == 4'b0) begin	//check if passVerify  has been set. If not begin setting it
				if(KEY) begin						//wait for key press
					passVerify[3:0] <= KEY;			//load in first key for the combination
				end else begin
					state <= VERIFY;
				end
			end else if (passVerify[7:4] == 4'b0) begin 
				if(KEY) begin
					passVerify[7:4] <= KEY;
				end else begin
					state <= VERIFY;
				end 
			end else if (passVerify[11:8] == 4'b0) begin 
				if(KEY) begin
					passVerify[11:8] <= KEY;
				end else begin
					state <= VERIFY;
				end 	
			end else if (passVerify[15:12] == 4'b0) begin 
				if(KEY) begin
					passVerify[15:12] <= KEY;
				end else begin
					state <= VERIFY;
				end 
			end else if (password == passVerify) begin	//once passVerify is set, check if it matches the password
				ERROR <= 1'b0;										//clear error flag in case it got set
				passVerify <= 16'b0;								//clear passVerify
				state <= UNLOCK;									//go to next state
			end else begin											//else set the error flag high and try verify again
				ERROR <= 1'b1;
				passVerify <= 16'b0;								//clear passVerify so it can be set again
				state <= VERIFY;		
			end	
		end
		
		UNLOCK: begin									//lock is locked until a correct combination is typed in
			LOCKED <= 1'b1;							// set LOCKED flag high this time
			if(passUnlock[3:0] == 4'b0) begin	//check if passUnlock  has been set. If not begin setting it
				if(KEY) begin						//wait for key press
					passUnlock[3:0] <= KEY;			//load in first key for the combination
				end else begin
					state <= UNLOCK;
				end
			end else if (passUnlock[7:4] == 4'b0) begin 
				if(KEY) begin
					passUnlock[7:4] <= KEY;
				end else begin
					state <= UNLOCK;
				end 
			end else if (passUnlock[11:8] == 4'b0) begin 
				if(KEY) begin
					passUnlock[11:8] <= KEY;
				end else begin
					state <= UNLOCK;
				end 	
			end else if (passUnlock[15:12] == 4'b0) begin 
				if(KEY) begin
					passUnlock[15:12] <= KEY;
				end else begin
					state <= UNLOCK;
				end 
			end else if (password == passUnlock) begin	//once passUnlock is set, check if it matches the password
				password <= 16'b0;								//Clear password so it can be set again
				freezeCount <= 2'b0;							//clear freeze counter
				passUnlock <= 16'b0;								//clear passUnlock so it can be set again
				state <= SET;									// unlock the lock and go back to the SET state
			end else if (freezeCount < 3) begin								//else stay in this state until the right combination is typed				
				passUnlock <= 16'b0;								//clear passUnlock so it can be set again
				freezeCount <= freezeCount + 2'b1;
				state <= UNLOCK;
			end else begin
				state <= FREEZE;
			end
		end
		
		FREEZE: begin								//device frozen flagging both error and locked until it is hard reset
			LOCKED <= 1'b1;
			ERROR <= 1'b1;
			state <= FREEZE;
		end
		
		endcase
	end
end

endmodule
