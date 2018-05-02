`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:26:26 02/26/2018
// Design Name:   stopwatch
// Module Name:   /home/ise/lab3_nh/tb.v
// Project Name:  lab3_nh
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: stopwatch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk;
	reg rst;
	reg pause;
	reg sel;
	reg adj;

	// Outputs
	wire [7:0] seven_segment;
	wire [3:0] anode;

	// Instantiate the Unit Under Test (UUT)
	stopwatch uut (
		.clk(clk), 
		.rst(rst), 
		.pause(pause), 
		.sel(sel), 
		.adj(adj), 
		.seven_segment(seven_segment), 
		.anode(anode)
	);

	initial begin
		// Initialize Inputs
		
		rst = 1;
		#100
		clk = 0;
		pause = 0;
		sel = 0;
		adj = 0;
		rst=0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
		always begin
		#10 clk = ~clk;
	end

	initial begin
		// Add stimulus here
		#150 rst = 1;
		#10 rst = 0;
		// regular clock mode
		adj = 0;
		
		#200
		
		// positive adj mode, minutes
		adj = 1;	
		sel = 0;
		#200 
		
		// positive adj mode, seconds
		sel = 1;
		#200
		
		// negative adj mode, minutes
//		adj = 2;
//		sel = 0;
//		#200
		
		// negative adj mode, seconds
//		sel = 1;
//		#200
		
		pause = 1;
		#200
		
		pause = 0;
		rst = 1;
		#10
		rst = 0;
		adj = 0;
		sel = 0;
		#400000; $finish;
	end
      
endmodule

