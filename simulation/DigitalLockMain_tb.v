`timescale 1 ns/100 ps
 
module DigitalLockMain_tb;

// Parameter Declarations
localparam NUM_CYCLES = 300;       //Number of clock cycles to be simulated
localparam CLOCK_FREQ = 50000000; //Clock frequency (Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.

// Test Bench Generated Signals
reg  clock;
reg  reset;
reg [3:0] KEY;
 
wire LOCKED;
wire ERROR;
wire [6:0] sevenSeg;

// Device Under Test
DigitalLockMain DigitalLockMain_dut (
	.clock (clock),
	.reset (reset),
	.KEY (KEY),
	 
	.LOCKED (LOCKED),
	.ERROR (ERROR),
	.sevenSeg (sevenSeg)
);

integer i;
// Test Bench Logic
initial begin

	//Print to console that the simulation has started. $time is the current sim time.
	$display("%d ns\tSimulation Started",$time);
	//Monitor changes to any values listed, and automatically print to the console 
   //when they change. There can only be one $monitor per simulation.
   $monitor("%d ns\tclock=%b\treset=%b\tKEY=%b\tLOCKED=%b\tERROR=%b\tsevenSeg=%b",$time,clock,reset,KEY,LOCKED,ERROR,sevenSeg);
	
	
	reset = 1'b1;                        //Start in reset.
   repeat(RST_CYCLES) @(posedge clock); //Wait for a couple of clocks
   reset = 1'b0;                        //Then clear the reset signal.
	
	//SET state check
	$display("'State SET	test");
	KEY = 4'b1000;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(2) @(posedge clock);
	
	if (sevenSeg == 7'b0000110) begin							//check if sevenSeg lights up correctly, if this case works then the rest can be checked manually in sim report
		$display("sevenSeg Success");
	end else begin
		$display("Error! sevenSeg %b != 0000110", sevenSeg);
	end
	
	repeat(3) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0010;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0001;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	
	if (LOCKED == 1'b0) begin												//check if the lock stays unlocked
		$display("'State SET Success! Device stays unlocked");
	end else begin
		$display("State SET Error! 'LOCKED' flag %d != 0 ", LOCKED);
	end
	
	//VERIFY state wrong combination check		
	$display("'State VERIFY test");
	KEY = 4'b0100;															//wrong combination on purpose
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b1000;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0001;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	if (ERROR == 1'b1) begin										//check if second combination input error gets flagged
		$display("'ERROR' flagging Success!");
	end else begin
		$display("Error! 'ERROR' flag %d != 1 ", ERROR);
	end
	
	//VERIFY state, right combination check
	KEY = 4'b1000;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0010;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0001;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	if (ERROR == 1'b0) begin													//check if error flag gets removed when right combination is input 
		$display("'ERROR' unflagging Success!");
	end else begin
		$display("Error! 'ERROR' flag %d != 0 ", ERROR);
	end
	
	if (LOCKED == 1'b1) begin													//check if the device gets locked after second input of the combination
		$display("State VERIFY success; Device gets locked!");
	end else begin
		$display("State VERIFY Error! 'LOCKED' flag %d != 1 ", LOCKED);
	end
	
	//UNLOCK state check, wrong comb
	$display("'State UNLOCK test");
	KEY = 4'b0001;																//wrong combination on purpose again
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	if (LOCKED == 1'b1) begin													//check if the device stays locked after wrong combination
		$display("'LOCKED' flagging Success!");
	end else begin
		$display("Error! 'LOCKED' flag %d != 1 ", LOCKED);
	end
	
	//UNLOCK state check, right comb
	KEY = 4'b1000;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0010;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0001;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	if (LOCKED == 1'b0) begin													//check if the device unlocks after the right combination
		$display("State UNLOCK success! Device is unlocked");
	end else begin
		$display("State UNLOCK Error! 'LOCKED' flag %d != 0 ", LOCKED);
	end
	
	//repeat combinations to get to UNLOCK state again so freezing can be tested
	//SET state
	$display("'SET state again");
	KEY = 4'b1000;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0010;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0001;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	//VERIFY state, right combination check
	$display("'VERIFY state again");
	KEY = 4'b1000;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0100;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0010;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	KEY = 4'b0001;
	repeat(1) @(posedge clock);
	KEY = 4'b0;
	
	repeat(5) @(posedge clock);
	
	//UNLOCK state
	$display("'UNLOCK state again");
	for (i = 0; i < 4; i = i + 1) begin
	$display("'wrong combination on purpose");
		KEY = 4'b0001;																//wrong combination on purpose again, repeated 4 times
		repeat(1) @(posedge clock);
		KEY = 4'b0;
		
		repeat(5) @(posedge clock);
		
		KEY = 4'b0100;
		repeat(1) @(posedge clock);
		KEY = 4'b0;
		
		repeat(5) @(posedge clock);
		
		KEY = 4'b0100;
		repeat(1) @(posedge clock);
		KEY = 4'b0;
		
		repeat(5) @(posedge clock);
		
		KEY = 4'b0100;
		repeat(1) @(posedge clock);
		KEY = 4'b0;
		
		repeat(5) @(posedge clock);
	end
	
	if (LOCKED == 1'b1 && ERROR == 1'b1) begin													//check if the devices freezes correctly
		$display("State FREEZE success! Device is locked and flagging error");
	end else begin
		$display("State FREEZE Error! locked flag = %b; error flag = %b", LOCKED,ERROR);
	end
	
	
	$stop;
	
end

//
// Reset Logic
//
//Clock generator + simulation time limit.
//
initial begin
    clock = 1'b0; //Initialise the clock to zero.
end
//Next we convert our clock period to nanoseconds and half it
//to work out how long we must delay for each half clock cycle
//Note how we convert the integer CLOCK_FREQ parameter it a real
real HALF_CLOCK_PERIOD = (1e9 / $itor(CLOCK_FREQ)) / 2.0;

//Now generate the clock
integer half_cycles = 0;
always begin
    //Generate the next half cycle of clock
    #(HALF_CLOCK_PERIOD);          //Delay for half a clock period.
    clock = ~clock;                //Toggle the clock
    half_cycles = half_cycles + 1; //Increment the counter
    //Check if we have simulated enough half clock cycles
    if (half_cycles == (2*NUM_CYCLES)) begin 
        //Once the number of cycles has been reached
		half_cycles = 0; 		   //Reset half cycles
		$display("%d ns\tSimulation Finished",$time); //Finished
        $stop;                     //Break the simulation
        //Note: We can continue the simualation after this breakpoint using 
        //"run -all", "run -continue" or "run ### ns" in modelsim.
    end
end

endmodule