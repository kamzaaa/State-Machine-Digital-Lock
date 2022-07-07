module DigitalLockMain (
	input clock, 
	input reset,
	input [3:0] KEY,

	output LOCKED,
	output ERROR,
	output [6:0] sevenSeg
); 

wire [3:0] KEYsync;

NBitSynchroniser #(
	.WIDTH (4),
	.LENGTH (2)
) syncInput (
	.asyncIn (KEY),
	.clock (clock),
	.syncOut (KEYsync)
);

DigitalLockFSM FSM (
	.clock (clock), 
	.reset (reset),
	.KEY (KEYsync),

	.LOCKED (LOCKED),
	.ERROR (ERROR)
	//.pass	//unused in final module
);

KeyTo7Segment Disp7Seg (
	.KEY (KEYsync),
	
	.sevenSeg (sevenSeg)
);

endmodule
