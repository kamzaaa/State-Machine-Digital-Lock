`timescale 1 ns/100 ps
 
module DigitalLockFSM_tb;

// Parameter Declarations
localparam NUM_CYCLES = 150;       //Number of clock cycles to be simulated
localparam CLOCK_FREQ = 50000000; //Clock frequency (Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.

// Test Bench Generated Signals
reg  clock;
reg  reset;
reg [3:0] KEY;
 
wire LOCKED;
wire ERROR;
wire [15:0] pass;

// Device Under Test
DigitalLockFSM DigitalLockFSM_dut (
	.clock (clock),
	.reset (reset),
	.KEY (KEY),
	 
	.LOCKED (LOCKED),
	.ERROR (ERROR),
	.pass (pass)
);

// Test Bench Logic
initial begin

	//Print to console that the simulation has started. $time is the current sim time.
	$display("%d ns\tSimulation Started",$time);
	//Monitor changes to any values listed, and automatically print to the console 
   //when they change. There can only be one $monitor per simulation.
   $monitor("%d ns\tclock=%d\treset=%d\tKEY=%b\tLOCKED=%b\tERROR=%b\tpass=%b",$time,clock,reset,KEY,LOCKED,ERROR,pass);
	
	
	reset = 1'b1;                        //Start in reset.
   repeat(RST_CYCLES) @(posedge clock); //Wait for a couple of clocks
   reset = 1'b0;                        //Then clear the reset signal.
	
	//set state check
	$display("'State SET	test");
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
	
	if (pass == 15'b0001001001001000) begin							//check if password set
		$display("password Success!");
	end else begin
		$display("Error! pass %d != 0001001001001000 ", pass);
	end
	
	if (LOCKED == 1'b0) begin												//check if it lock stays unlocked
		$display("'State SET Success! Device stays unlocked");
	end else begin
		$display("State SET Error! 'LOCKED' flag %d != 0 ", LOCKED);
	end
	
	//verify state wrong combination check		
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
	
	//verify state, right combination check
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
	
	//unlock state check, wrong comb
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
	
	//unlock state check, right comb
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
