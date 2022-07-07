//Hex to 7 segnment display conversion

module KeyTo7Segment (

	input [3:0] KEY,
	output reg [6:0] sevenSeg
	
);


	always @ * begin 

		case (KEY)
			
			//modified hexTo7Segment module to fit the spec; when key1000(d8) is input display 1, key0100(d4) display 2, key0010(d2) display 3, key 0001(d1) display 4
			4'h1: sevenSeg = 7'b1100110;
			4'h2: sevenSeg = 7'b1001111;
			4'h4: sevenSeg = 7'b1011011;
			4'h8: sevenSeg = 7'b0000110;
			
			default sevenSeg = 7'b0000000; //default value
			
		endcase 
		
	end
	
endmodule
