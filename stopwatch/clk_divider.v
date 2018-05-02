`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:20 02/13/2018 
// Design Name: 
// Module Name:    clk_divider 
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
module clk_divider(clk, rst, two_Hz_clock, one_Hz_clock, faster_clock, blinking_clock
    );
	 
	 input clk;
	 input rst;
	 output two_Hz_clock;
	 output one_Hz_clock;
	 output faster_clock;
	 output blinking_clock;
	 
	 reg two_Hz_clock_reg;
	 reg one_Hz_clock_reg;
	 reg faster_clock_reg;
	 reg blinking_clock_reg;
	 
	 // each counter is 32 bits because ..... 
	 reg [31:0] two_hz_counter;
	 reg [31:0] one_hz_counter;
	 reg [31:0] faster_counter;
	 reg [31:0] blinking_counter;
	 
	 // to get from 100*10^6 to 2, we have to devide by 50*10^6, 
	 // but since the clock is changing for every rising edge of the master clock
	 //it is 2 time slower, so the actual div factor is 25*10^6
	 parameter two_Hz_clock_div = 25000000;
	 parameter one_Hz_clock_div = 50000000;
	 // set faster_clock is 600 Hz
	 parameter faster_clock_div = 83333; // 
	 
	//set blinking_clock is 3 Hz
	 parameter blinking_clock_div = 12500000;
	 
	 
	 // make the two Hz clock:
	 always @(posedge(rst) or posedge(clk))
	 begin
	    if(rst)
		 begin
			two_hz_counter <=0;
			two_Hz_clock_reg <=0;
		 end
		 
		 else if (two_hz_counter==two_Hz_clock_div-1)
		 begin
			two_hz_counter <=0;
			two_Hz_clock_reg <= ~two_Hz_clock; // flip the register
		 end
		 else // increment counter
		 begin
			two_hz_counter <= two_hz_counter+1;
			two_Hz_clock_reg <= two_Hz_clock; // keep the same clock			
		 end
	end
		 
		 // make the one Hz clock:
	 always @(posedge(rst) or posedge(clk))
	 begin
	    if(rst)
		 begin
			one_hz_counter <=0;
			one_Hz_clock_reg <=0;
		 end
		 
		 else if (one_hz_counter==one_Hz_clock_div-1)
		 begin
			one_hz_counter <=0;
			one_Hz_clock_reg <= ~one_Hz_clock; // flip the register
		 end
		 else // increment counter
		 begin
			one_hz_counter <= one_hz_counter+1;
			one_Hz_clock_reg <= one_Hz_clock; // keep the same clock			
		 end
		end
		 
		 // make the faster Hz clock:
	 always @(posedge(rst) or posedge(clk))
	 begin
	    if(rst)
		 begin
			faster_counter <=0;
			faster_clock_reg <=0;
		 end
		 
		 else if (faster_counter==faster_clock_div-1)
		 begin
			faster_counter <=0;
			faster_clock_reg <= ~faster_clock; // flip the register
		 end
		 else // increment counter
		 begin
			faster_counter <= faster_counter+1;
			faster_clock_reg <= faster_clock; // keep the same clock			
		 end
		end
		 
		 // make the two Hz clock:
	 always @(posedge(rst) or posedge(clk))
	 begin
	    if(rst)
		 begin
			blinking_counter <=0;
			blinking_clock_reg <=0;
		 end
		 
		 else if (blinking_counter==blinking_clock_div-1)
		 begin
			blinking_counter <=0;
			blinking_clock_reg <= ~blinking_clock; // flip the register
		 end
		 else // increment counter
		 begin
			blinking_counter <= blinking_counter+1;
			blinking_clock_reg <= blinking_clock; // keep the same clock			
		 end
		end
		 
		 assign two_Hz_clock=two_Hz_clock_reg;
		 assign one_Hz_clock=one_Hz_clock_reg;
		 assign faster_clock = faster_clock_reg;
		 assign blinking_clock= blinking_clock_reg;
	

endmodule
