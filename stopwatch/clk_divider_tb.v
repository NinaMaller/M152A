`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:15 02/20/2018 
// Design Name: 
// Module Name:    clk_divider_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_divider_tb;
	 //input
	 reg clk;
	 reg rst;
	 //output
	 wire two_hz_clock;
	 wire one_hz_clock;
	 wire faster_clock;
	 wire blinking_clock;
	 
	 clk_divider uut(
	 .clk(clk),
	 .rst(rst),
	 .two_Hz_clock(two_hz_clock),
	 .one_Hz_clock(one_hz_clock),
	 .faster_clock(faster_clock),
	 .blinking_clock(blinking_clock)
	 );
	 
	 initial begin
	 clk = 0;
	 rst =1;
	 
	 #5
	 rst =0;
	 end
	 
	 always #1 clk = ~clk;

endmodule
