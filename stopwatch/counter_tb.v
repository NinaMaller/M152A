`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:00:03 02/26/2018
// Design Name:   counter
// Module Name:   /home/ise/lab3_nh/counter_tb.v
// Project Name:  lab3_nh
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module counter_tb;

	// Inputs
	reg clk;
	reg clk_1hz;
	reg clk_2hz;
	reg rst;
	reg pause;
	reg sel;
	reg adj;

	// Outputs
	wire [3:0] min_t_w;
	wire [3:0] min_o_w;
	wire [3:0] sec_t_w;
	wire [3:0] sec_o_w;

	// Instantiate the Unit Under Test (UUT)
	counter uut (
		.clk(clk), 
		.clk_1hz(clk_1hz), 
		.clk_2hz(clk_2hz), 
		.rst(rst), 
		.pause(pause), 
		.sel(sel), 
		.adj(adj), 
		.min_t_w(min_t_w), 
		.min_o_w(min_o_w), 
		.sec_t_w(sec_t_w), 
		.sec_o_w(sec_o_w)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clk_1hz = 0;
		clk_2hz = 0;
		rst = 1;
		pause = 0;
		sel = 1;
		adj = 0;

	 #10 rst =0;
	 
	 #100000
	 adj = 1;
	 sel = 1;
	 
	 #100000
	 adj = 1;
	 sel = 0;
	 
	 #200000;
	 $finish;
	 end
	 
	 always #1 clk = ~clk;
	 always #10 clk_1hz = ~clk_1hz;
	 always #20 clk_2hz = ~clk_2hz;
      
endmodule

