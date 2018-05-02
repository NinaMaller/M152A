`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    00:30:38 03/19/2013
// Design Name:
// Module Name:    vga640x480
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
/*
stuff I changed:
- goal sizes
- borders at top and bottom
- cube is now a ball
- more lines in the middle

*/
//
//////////////////////////////////////////////////////////////////////////////////
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input [20:0] pl1_hc,
	input [20:0] pl1_vc,
	input [20:0] pl2_hc,
	input [20:0] pl2_vc,
	input [20:0] ball_hc,
	input [20:0] ball_vc,
	input done,
	input pl1_goal,
   input pl2_goal,
	input cont,
	input difficulty,

	output reg diff,
	output wire restart_game,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
//	output reg new_game
	);



// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

parameter PL1_NUM_X = 80;
parameter PL1_NUM_Y = 0;
parameter PL2_NUM_X = 400;
parameter PL2_NUM_Y = 0;

parameter SEG_LEN = 160;
parameter SEG_WID = 16;

parameter WINNER_R = 3'b0;
parameter WINNER_G = 3'b111;
parameter WINNER_B = 2'b0;
parameter LOSER_R = 3'b111;
parameter LOSER_G = 3'b0;
parameter LOSER_B = 2'b0;

//reg rst = 0;

reg [3:0] final_pl1;
reg [3:0] final_pl2;

reg pl1_goal_d;
reg pl2_goal_d;

always @(posedge dclk or posedge clr) begin
	if (clr) begin
		final_pl1 <= 0;
		final_pl2 <= 0;
		pl1_goal_d <= 0;
		pl2_goal_d <= 0;
	end
   else begin
		pl1_goal_d <= pl1_goal;
		pl2_goal_d <= pl2_goal;

		if (!pl1_goal_d && pl1_goal) begin
			final_pl1 <= final_pl1 + 1;
		end
		if (!pl2_goal_d && pl2_goal) begin
			final_pl2 <= final_pl2 + 1;
		end
	end
end


reg in_game_mode = 1;
//back to game window
//reg new_game=0;
assign restart_game = cont;

// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end

	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

wire SEG1_1 = hc >= PL1_NUM_X + hbp
		   && hc <= PL1_NUM_X + SEG_WID + hbp
		   && vc >= PL1_NUM_Y + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_LEN + vbp + 113;
wire SEG2_1 = hc >= PL1_NUM_X + hbp
		   && hc <= PL1_NUM_X + SEG_WID + hbp
		   && vc >= PL1_NUM_Y + SEG_LEN + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_LEN*2 + vbp+113;
wire SEG3_1 = hc >= PL1_NUM_X + SEG_LEN + hbp
		   && hc <= PL1_NUM_X + SEG_LEN + SEG_WID + hbp
		   && vc >= PL1_NUM_Y + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_LEN + vbp+113;
wire SEG4_1 = hc >= PL1_NUM_X + SEG_LEN + hbp
		   && hc <= PL1_NUM_X + SEG_LEN + SEG_WID + hbp
		   && vc >= PL1_NUM_Y + SEG_LEN + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_LEN*2 + vbp+113;
wire SEG5_1 = hc >= PL1_NUM_X + hbp
		   && hc <= PL1_NUM_X + SEG_LEN +SEG_WID + hbp
		   && vc >= PL1_NUM_Y + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_WID + vbp + 113;
wire SEG6_1 = hc >= PL1_NUM_X + hbp
		   && hc <= PL1_NUM_X + SEG_LEN +SEG_WID + hbp
		   && vc >= PL1_NUM_Y + SEG_LEN + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_LEN + SEG_WID + vbp + 113;
wire SEG7_1 = hc >= PL1_NUM_X + hbp
		   && hc <= PL1_NUM_X + SEG_LEN + SEG_WID + hbp
		   && vc >= PL1_NUM_Y + SEG_LEN*2 + vbp + 113
		   && vc <= PL1_NUM_Y + SEG_LEN*2 + SEG_WID + vbp + 113;

wire SEG1_2 = hc >= PL2_NUM_X + hbp
		   && hc <= PL2_NUM_X + SEG_WID + hbp
		   && vc >= PL2_NUM_Y + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_LEN + vbp + 113;
wire SEG2_2 = hc >= PL2_NUM_X + hbp
		   && hc <= PL2_NUM_X + SEG_WID + hbp
		   && vc >= PL2_NUM_Y + SEG_LEN + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_LEN*2 + vbp+113;
wire SEG3_2 = hc >= PL2_NUM_X + SEG_LEN + hbp
		   && hc <= PL2_NUM_X + SEG_LEN + SEG_WID + hbp
		   && vc >= PL2_NUM_Y + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_LEN + vbp+113;
wire SEG4_2 = hc >= PL2_NUM_X + SEG_LEN + hbp
		   && hc <= PL2_NUM_X + SEG_LEN + SEG_WID + hbp
		   && vc >= PL2_NUM_Y + SEG_LEN + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_LEN*2 + vbp+113;
wire SEG5_2 = hc >= PL2_NUM_X + hbp
		   && hc <= PL2_NUM_X + SEG_LEN +SEG_WID + hbp
		   && vc >= PL2_NUM_Y + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_WID + vbp + 113;
wire SEG6_2 = hc >= PL2_NUM_X + hbp
		   && hc <= PL2_NUM_X + SEG_LEN +SEG_WID + hbp
		   && vc >= PL2_NUM_Y + SEG_LEN + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_LEN + SEG_WID + vbp + 113;
wire SEG7_2 = hc >= PL2_NUM_X + hbp
		   && hc <= PL2_NUM_X + SEG_LEN +SEG_WID + hbp
		   && vc >= PL2_NUM_Y + SEG_LEN*2 + vbp + 113
		   && vc <= PL2_NUM_Y + SEG_LEN*2 + SEG_WID + vbp + 113;

// wire SEG1_2 = hc >=PL2_NUM_X+hbp && hc<=10+hbp && vc>= PL2_NUM_Y+vbp && vc <=55+vbp;
// wire SEG2_2 = hc >=PL2_NUM_X+hbp && hc <=10+hbp && vc>= 55+vbp && vc <= 105+vbp;
// wire SEG3_2 = hc >=55+hbp && hc <= 60+hbp && vc >= PL2_NUM_Y+vbp && vc <=55+vbp;
// wire SEG4_2 = hc >=55+hbp && hc <= 60+hbp && vc >= 55+vbp && vc <= 105+vbp;
// wire SEG5_2 = hc >=PL2_NUM_X+hbp && hc <=60+hbp && vc >=PL2_NUM_Y+vbp && vc <=10+vbp;
// wire SEG6_2 = hc >=PL2_NUM_X+hbp && hc <=60+hbp && vc >=55+vbp && vc <=60+vbp;
// wire SEG7_2 = hc >=PL2_NUM_X+hbp && hc <=60+hbp && vc >=105+vbp && vc <= 110+vbp;

reg PL1_NUM_OUTPUT;
reg PL2_NUM_OUTPUT;

always @ (*) begin
	case(final_pl1)
		4'b1111: PL1_NUM_OUTPUT = 0 ; //Nothing
		4'b0000: PL1_NUM_OUTPUT = SEG1_1 || SEG2_1 || SEG3_1 || SEG4_1 || SEG5_1 || SEG7_1; //0
		4'b0001: PL1_NUM_OUTPUT = SEG3_1 || SEG4_1; //1
		4'b0010: PL1_NUM_OUTPUT = SEG5_1 || SEG3_1 || SEG6_1 || SEG2_1 || SEG7_1; //2
		4'b0011: PL1_NUM_OUTPUT = SEG5_1 || SEG3_1 || SEG6_1 || SEG4_1 || SEG7_1; //3
		4'b0100: PL1_NUM_OUTPUT = SEG1_1 || SEG6_1 || SEG3_1 || SEG4_1; //4
		4'b0101: PL1_NUM_OUTPUT = SEG5_1 || SEG1_1 || SEG6_1 || SEG4_1 || SEG7_1; //5
		4'b0110: PL1_NUM_OUTPUT = SEG5_1 || SEG1_1 || SEG2_1 || SEG7_1 || SEG4_1 || SEG6_1; //6
		4'b0111: PL1_NUM_OUTPUT = SEG5_1 || SEG3_1 || SEG4_1; //7
		4'b1000: PL1_NUM_OUTPUT = SEG1_1 || SEG2_1 || SEG3_1 || SEG4_1 || SEG5_1 || SEG6_1 || SEG7_1; //8
		4'b1001: PL1_NUM_OUTPUT = SEG6_1 || SEG1_1 || SEG5_1 || SEG3_1 || SEG4_1; //9
		default: PL1_NUM_OUTPUT = 0; // default is not needed as we covered all cases
	endcase
end

always @ (*) begin
	case(final_pl2)
		4'b1111: PL2_NUM_OUTPUT = 0 ; //Nothing
		4'b0000: PL2_NUM_OUTPUT = SEG1_2 || SEG2_2 || SEG3_2 || SEG4_2 || SEG5_2 || SEG7_2; //0
		4'b0001: PL2_NUM_OUTPUT = SEG3_2 || SEG4_2; //1
		4'b0010: PL2_NUM_OUTPUT = SEG5_2 || SEG3_2 || SEG6_2 || SEG2_2 || SEG7_2; //2
		4'b0011: PL2_NUM_OUTPUT = SEG5_2 || SEG3_2 || SEG6_2 || SEG4_2 || SEG7_2; //3
		4'b0100: PL2_NUM_OUTPUT = SEG1_2 || SEG6_2 || SEG3_2 || SEG4_2; //4
		4'b0101: PL2_NUM_OUTPUT = SEG5_2 || SEG1_2 || SEG6_2 || SEG4_2 || SEG7_2; //5
		4'b0110: PL2_NUM_OUTPUT = SEG5_2 || SEG1_2 || SEG2_2 || SEG7_2 || SEG4_2 || SEG6_2; //6
		4'b0111: PL2_NUM_OUTPUT = SEG5_2 || SEG3_2 || SEG4_2; //7
		4'b1000: PL2_NUM_OUTPUT = SEG1_2 || SEG2_2 || SEG3_2 || SEG4_2 || SEG5_2 || SEG6_2 || SEG7_2; //8
		4'b1001: PL2_NUM_OUTPUT = SEG6_2 || SEG1_2 || SEG5_2 || SEG3_2 || SEG4_2; //9
		default: PL2_NUM_OUTPUT = 0; // default is not needed as we covered all cases
	endcase
end

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
// switch to game mode:
if(cont == 1 && in_game_mode == 0) begin
	in_game_mode = 1;
end

if(in_game_mode == 1)
	 diff = difficulty;
if(in_game_mode == 0)
		diff = diff;
/*else // if in score mode
	assign diff = difficulty;
*/
if(done == 0 || in_game_mode == 1) begin
	if(done == 1)
		in_game_mode = 0;
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp)
	begin
		// goal of each player is 240 +- 60 = 180 to 300
		//if( (hc < hbp+20) && (vc < 220 || vc > 260))
		if(hc < hbp + 15 && vc < vbp+180 ||
		    hc < hbp + 15 && vc > vbp+300 ||
			hc > hfp - 15 && vc < vbp+180 ||
			hc > hfp - 15 && vc > vbp+300 ||
			vc < vbp+15 || vc > vbp+465)
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b11;
		end

		// draw the ball:
	//	else if((vc == ball_vc && vc < (ball_vc + 30)) && (hc >=  ball_hc && hc < ( ball_hc + 30))) begin
/*		else if(vc == ball_vc || hc ==  ball_hc || vc == ball_vc+30 || hc == ball_hc+30) begin

				red = 3'b111;
				green = 3'b000;
				blue = 2'b11;
			end */
	// origin of ball at: hbp+ball_hc+15 and vbp+ball_vc+15
	// to draw a ball we need: x*x + y*y < 15*15
	// double check vertical side:
		else if( (hc-15-ball_hc)*(hc-15-ball_hc) + (vc-15-ball_vc)*(vc-15-ball_vc) < 15*15 )
			begin
				if((hc-15-ball_hc)*(hc-15-ball_hc) + (vc-15-ball_vc)*(vc-15-ball_vc) < 10*10 ) 
				begin
				/*	if((hc-15-ball_hc)*(hc-15-ball_hc) + (vc-15-ball_vc)*(vc-15-ball_vc) < 5*5 ) 
					begin // draw inner ball
						red = 3'b000;
						green = 3'b000;
						blue = 2'b11;
					end 
					else begin */ // draw middle ring
						red = 3'b111;
						green = 3'b000;
						blue = 2'b11;
					end
			else begin // draw outter ball
				red = 3'b000;
				green = 3'b000;
				blue = 2'b11;
			end
		end 
	//end

		else
		begin
		// This is the allowed zone for player 1:
		if (hc >= hbp && hc < (hbp+315))
		begin
			if((vc >= pl1_vc && vc < (pl1_vc + 80)) && (hc >= pl1_hc && hc < (pl1_hc + 10)))
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
			else
				begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
		end

		else if (hc >= (hbp+315) && hc < (hbp+325))
		begin // make the spaces between the rectangles in the middle
			if ((vc >= (vbp) && vc < (vbp+10)) || 
				(vc >= (vbp+35) && vc < (vbp+45)) ||
			  	(vc >= (vbp+70) && vc < (vbp+80)) ||
			  	(vc >= (vbp+105) && vc < (vbp+115)) ||
				(vc >= (vbp+140) && vc < (vbp+150)) ||
				(vc >= (vbp+175) && vc < (vbp+185)) ||
				(vc >= (vbp+210) && vc < (vbp+220)) ||
				(vc >= (vbp+245) && vc < (vbp+255)) ||
				(vc >= (vbp+280) && vc < (vbp+290)) || 
				(vc >= (vbp+315) && vc < (vbp+325)) ||
				(vc >= (vbp+350) && vc < (vbp+360)) ||
				(vc >= (vbp+385) && vc < (vbp+395)) ||
				(vc >= (vbp+420) && vc < (vbp+430)) ||
				(vc >= (vbp+455) && vc < (vbp+465)) ) 
				begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
			else
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
		end

		// this is the allowed zone for player 2:
		else if (hc >= (hbp+325) && hc < (hbp+640))
		begin
			if((vc >= pl2_vc && vc < (pl2_vc + 80)) && ((hc >= pl2_hc && hc < (pl2_hc + 10))))
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
			else
				begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
		end
	end



	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
 // end for if rst == 1

end // end of if statement



/* ***********************
**************************
SCORE WINDOW ************/


else if (done == 1) begin
	in_game_mode = 0;
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp) begin
		if (PL1_NUM_OUTPUT) begin
			// display player1 score number
			red   = (pl1_goal) ? WINNER_R : LOSER_R;
			green = (pl1_goal) ? WINNER_G : LOSER_G;
			blue  = (pl1_goal) ? WINNER_B : LOSER_B;
		end else if (PL2_NUM_OUTPUT) begin
			// display player2 score number
			red   = (pl2_goal) ? WINNER_R : LOSER_R;
			green = (pl2_goal) ? WINNER_G : LOSER_G;
			blue  = (pl2_goal) ? WINNER_B : LOSER_B;
		end else begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end else begin
		// outside the video range
		red = 0;
		green = 0;
		blue = 0;
	end
        /*
        //display 0
		if(final_pl1==0) begin
			if(SEG1_1 || SEG2_1 || SEG3_1 || SEG4_1 || SEG5_1 || SEG7_1 || SEG1_2) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
			end else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
		end

      //display 1
       else if (final_pl1==1) begin
         	if ( SEG3_1 || SEG4_1)
         	begin
         		red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
         	end
			end

       //display 2
       	else if(final_pl1==2) begin
       	  	if ( SEG5_1 || SEG3_1 || SEG6_1 || SEG2_1 || SEG7_1)
         	begin
         	red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
         	end
			end

       // display 3
          else if (final_pl1==3) begin
       	   if( SEG5_1 || SEG3_1 || SEG6_1 || SEG4_1 || SEG7_1)
       	   begin
       	       red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
			end

       // display 4
          else if (final_pl1==4) begin
       	   if( SEG1_1 || SEG6_1 || SEG3_1 || SEG4_1)
       	   begin
       	       red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
			end


       // display 5
          else if (final_pl1==5) begin
       	   if( SEG5_1 || SEG1_1 || SEG6_1 || SEG4_1 || SEG7_1)
       	   begin
       	       red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
				end


       	// display 6
          else if (final_pl1==6) begin
       	   if( SEG5_1 || SEG1_1 || SEG2_1 || SEG7_1 || SEG4_1 || SEG6_1)
       	   begin
       	       red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
       	   end

       // display 7
          else if (final_pl1==7) begin
       	   if( SEG5_1 || SEG3_1 || SEG4_1)
       	   begin
       	       red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
			end

       // display 8
          else if (final_pl1==8) begin
       	   if( SEG1_1 || SEG2_1 || SEG3_1 || SEG4_1 || SEG5_1 || SEG6_1 || SEG7_1)
       	   begin
       	       red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
			end

       // display 9
         else if (final_pl1==9) begin
       	   if( SEG6_1 || SEG1_1 || SEG5_1 || SEG3_1 || SEG4_1)
       	   begin
         	    red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
       	   end
			end
            */

	// we're outside number range so display black
/*	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end */

end // end for if done==0


end // end for always block

/*
always @(posedge dclk) begin
if(cont) begin
new_game=1;
end
else
new_game=0;
end
*/

endmodule
