`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk,	//7-segment clock: 381.47Hz
	output wire gclk,    // game clcok
	output reg one_hz_clk   // 1Hz clock
	);

// 17-bit counter variable
reg [17:0] q;

//25-bit counter variable for gameclk
reg [25:0] gamecounter;


//28-bit counter variable for 1Hz clock
reg [28:0] seccounter;


// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1) begin
		q <= 0;
		gamecounter <=0;
		seccounter <= 0;
//		1hz_clk <= 0;
		end
	// increment counter by one
	else begin
      q <= q + 1;
		gamecounter <= gamecounter +1;
		seccounter <= seccounter +1;
		
		if(seccounter >= 29'd100000000) begin
			one_hz_clk <= 1;
			seccounter <= 0;
		end
		else begin
			one_hz_clk <= 0;			
		end
	end
end

// 50Mhz ÷ 2^17 = 381.47Hz
assign segclk = q[17];

// 50Mhz ÷ 2^1 = 25MHz
assign dclk = q[1];

//game clock 
assign gclk = gamecounter[19];

endmodule
