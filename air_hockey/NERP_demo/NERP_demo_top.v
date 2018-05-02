`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module NERP_demo_top(
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	input wire MISO,        // Master In Slave Out, Pin 3, Port JA
	input wire MISO2,       // Master In Slave Out, Pin 3, Port JD
	input cont,
	input pause,
	input difficulty,
	
//	output wire [6:0] seg,	//7-segment display LEDs
//	output wire [3:0] an,	//7-segment display anode enable
//	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
   output wire SS, 	      // Slave Select, Pin 1, Port JA
	output wire MOSI,       // Master Out Slave In, Pin 2, Port JA
	output wire SCLK,       // Serial Clock, Pin 4, Port JA
	output wire SS2, 	      // Slave Select, Pin 1, Port JD
	output wire MOSI2,       // Master Out Slave In, Pin 2, Port JD
	output wire SCLK2     // Serial Clock, Pin 4, Port JD
	);



// 7-segment clock interconnect
//wire segclk;

// VGA display clock interconnect
wire dclk;

// disable the 7-segment decimal points
//assign dp = 1;

// game clock
wire gclk;

wire [39:0] pl1_data;
wire [39:0] pl2_data;

wire gameclk;
wire sec;
wire clkRst;




//placeholder
wire clr2;
assign clr2=0;

PmodJSTK_Demo player1(
	 .CLK(clk),
    .RST(clr2) ,
    .MISO(MISO),
    .SS(SS),
    .MOSI(MOSI),
    .SCLK(SCLK),
	 .jstkData( pl1_data),
	 .sndRec(gameclk)
    );


PmodJSTK_Demo player2(
	 .CLK(clk),
    .RST(clr2) ,
    .MISO(MISO2),
    .SS(SS2),
    .MOSI(MOSI2),
    .SCLK(SCLK2),
	 .jstkData( pl2_data),
	 .sndRec(gameclk)
    );

// Transport variables between game and display modules
wire [20:0] pl1_hc;
wire [20:0] pl1_vc;

wire [20:0] pl2_hc;
wire [20:0] pl2_vc;

wire [20:0] ball_hc;
wire [20:0] ball_vc;

wire pl1_goal;
wire pl2_goal;
wire done;
//wire pause;
wire cont_valid;
wire restart_game;

wire clr_valid;
wire vga_diff;
assign vga_diff= difficulty;

game pingpong(.clk(gclk), 
	.pl1_data(pl1_data), 
	.pl2_data(pl2_data), 
	.pause(pause),
   .reset(clr_valid),
	.start_again(restart_game),
	.diff(vga_diff),
	//.pause_game(pause),
//	.new_game(new_game) , 
	.pl1_hc(pl1_hc), 
	.pl1_vc(pl1_vc), 
	.pl2_hc(pl2_hc), 
	.pl2_vc(pl2_vc), 
	.ball_hc(ball_hc), 
	.ball_vc(ball_vc),
	.pl1_goal(pl1_goal), 
	.pl2_goal(pl2_goal) , 
	.done(done)  //, .clkRst(clkRst)
);


// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr_valid),
	.segclk(segclk),
	.dclk(dclk),
	.gclk( gclk),
	.one_hz_clk(sec)
	);
	
	/*
// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(clr_valid),
	.seg(seg),
	.an(an)
	); */
/*
assign pl2_hc = pl2_hc + 144;
assign pl2_vc = pl2_vc + 31;
*/
// VGA controller


debouncer check_button( 
     .clk(clk),
	 .button(cont),
	 .button_valid(cont_valid)

);


debouncer check_clear( 
     .clk(clk),
	 .button(clr),
	 .button_valid(clr_valid)

);

vga640x480 U3(
	.dclk(dclk),
	.clr(clr_valid),
   .pl1_hc(pl1_hc),
	.pl1_vc(pl1_vc),
	.pl2_hc(pl2_hc),
	.pl2_vc(pl2_vc),
	.ball_hc(ball_hc),
	.ball_vc(ball_vc),
	.done(done),
	.pl1_goal(pl1_goal),
   .pl2_goal(pl2_goal),
	.cont(cont_valid),
	.difficulty(vga_diff),
//	.vga_diff(difficulty),
	.restart_game(restart_game),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
//	.new_game(new_game)
	);
	



endmodule


