`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:20:22 03/08/2018 
// Design Name: 
// Module Name:    game 
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
/*
check that goals work, able to pause and reset, 
then adee the option for difficulty.

*/


//////////////////////////////////////////////////////////////////////////////////
module game(
		input wire clk,
		input wire [39:0] pl1_data,
		input wire [39:0] pl2_data,
		input wire pause,
		input wire reset,
		input start_again,
		input diff,
	//	input wire speed,
	//   input new_game,
		
		output reg [20:0] pl1_hc,
		output reg [20:0] pl1_vc,
		output reg [20:0] pl2_hc,
		output reg [20:0] pl2_vc,
		output reg [20:0] ball_hc,
		output reg [20:0] ball_vc,
		output reg pl1_goal, // 1 or 0
		output reg pl2_goal, // 1 or 0
		output reg done
    );
//	 reg
//	 done = 0;
	 reg [2:0] pl_speed = 3'b001; // later make this equal to input speed
	 reg [2:0] speed_h;  //= 3'b001; //speed;
	 reg [2:0] speed_v; //= 3'b001;//speed;
	 reg [1:0] direction = 0; // 0 1 2 3
	 reg [2:0] speed; // = 3'b001; // speed of players

	 // adjust difficutly\
	 
//	 assign speed_h = (diff == 1) ? 3'b010:3'b001;
	// assign speed_v = (diff == 1) ? 3'b010:3'b001;
	 /*
	 
	 if(difficulty == 1) begin
	 	speed_h = 3'b010;
	 	speed_v = 3'b010;
	 end */

	 /*
	 reg [2:0] pl_speed = 0; // later make this equal to input speed
	 reg [2:0] ball_speed = 0; // later make this 1.5*input speed
	 reg [2:0] speed_h = 0; //speed;
	 reg [2:0] speed = 0; //speed;
	 reg [2:0] speed_v = 0;//speed;
	 */
//	 reg paused;
	 
	parameter hbp = 144; 	// end of horizontal back porch
	parameter hfp = 784; 	// beginning of horizontal front porch
	parameter vbp = 31; 		// end of vertical back porch
	parameter vfp = 511; 	// beginning of vertical front porch

	 /* initial locations and set scores to 0: */
	initial begin
	 	pl1_hc = 25 + hbp; // 15 + 10
	 	pl1_vc = 200 + vbp; //240 - 40
	 	pl2_hc = 605 + hbp; //640 - 25 - 10 
	 	pl2_vc = 200 + vbp;
	 	ball_hc = 306 + hbp; // 320 - 15 
	 	ball_vc = 226 + vbp; // 240 - 15
	 	pl1_goal = 0;
	 	pl2_goal = 0;
	 	done = 0;
	 //  speed_h = (diff == 1) ? 3'b010:3'b001;
	  // speed_v = (diff == 1) ? 3'b010:3'b001;
	  speed_h = 3'b001;
	  speed_v = 3'b001;
	  speed = 3'b001;
	 end

	 /* game mode: */
	 
	 
	 always @(posedge clk or posedge reset) begin
	 	 if(reset == 1) begin
			pl1_hc <= 25 + hbp; // 15 + 10
			pl1_vc <= 200 + vbp; //240 - 40
			pl2_hc <= 605 + hbp; //640 - 25 - 10 
			pl2_vc <= 200 + vbp;
			ball_hc <= 306 + hbp; // 320 - 15 
			ball_vc <= 226 + vbp; // 240 - 15
			pl1_goal <= 0;
			pl2_goal <= 0;
			done <= 0;
			 //we still dont have diff
			speed_h <= 3'b001;
	      speed_v <= 3'b001;
			speed <= 3'b001;
		end
		
		else if(start_again == 1 && done == 1)begin
			pl1_hc <= 25 + hbp; // 15 + 10
			pl1_vc <= 200 + vbp; //240 - 40
			pl2_hc <= 605 + hbp; //640 - 25 - 10 
			pl2_vc <= 200 + vbp;
			ball_hc <= 306 + hbp; // 320 - 15 
			ball_vc <= 226 + vbp; // 240 - 15
			pl1_goal <= 0;
			pl2_goal <= 0;
			done <= 0;
			speed_h <= (diff == 1) ? 3'b010:3'b001;
			speed_v <= (diff == 1) ? 3'b010:3'b001;
			speed <= (diff == 1) ? 3'b010:3'b001;
		end
 
	
		else if (pause == 0) 
		begin
		//define ball movement:
		// 0 = NE
		// 1 = NW
		// 2 = SW
		// 3 = SE

		if(ball_hc > hbp && ball_hc < hfp && ball_vc > vbp && ball_vc < vfp)
		begin
			if(direction == 0) begin // going up to the left
				ball_hc <= ball_hc - speed_h;
				ball_vc <= ball_vc - speed_v;
			end
			
			else if(direction == 1) begin //going up to the right
				ball_hc <= ball_hc + speed_h;
				ball_vc <= ball_vc - speed_v;
			end
			else if(direction == 2) begin // going down to the right
				ball_hc <= ball_hc + speed_h;
				ball_vc <= ball_vc + speed_v;
			end
			else if(direction == 3) begin // going down to the left
				ball_hc <= ball_hc - speed_h;
				ball_vc <= ball_vc + speed_v;
			end
			else begin
				ball_hc <= ball_hc - speed_h;
				ball_vc <= ball_vc - speed_v;
			end
		end

		// controller:
		if(ball_vc < 15+vbp) begin // || ball_vc == 15+vbp) begin// hit the top 
			if(direction == 1)
				direction = 2;
			else if(direction == 0)
				direction = 3;
		end
		if(ball_vc > 435+vbp) begin // || ball_vc == 435+vbp) begin // hit the bottom
			if(direction == 2)
				direction = 1;
			else if(direction == 3)
				direction = 0;
		end
		if(ball_hc < 15+hbp ||
		(ball_hc > pl1_hc && ball_hc < pl1_hc+10 && ball_vc > pl1_vc-30 && ball_vc < pl1_vc+80)) begin // hit left wall
			if(direction == 3)
				direction = 2;
			else if (direction == 0)
				direction = 1;
		end
		if(ball_hc > 595+hbp || 
		(ball_hc+30 > pl2_hc && ball_hc+30 < pl2_hc +10 && ball_vc > pl2_vc-30 && ball_vc < pl2_vc+80 ))begin // hit right wall
			if(direction == 2)
				direction = 3;
			else if (direction == 1)
				direction = 0;
		end


		//define player 1 movement:
		
		//check if go left
		if(pl1_hc > 15+hbp && {pl1_data[25:24], pl1_data[39:32]} > 700)
			pl1_hc <= pl1_hc - speed; //307
		//check if go right
		if(pl1_hc < 305+hbp && {pl1_data[25:24], pl1_data[39:32]} < 300)
			pl1_hc <= pl1_hc + speed; // 13 instead of 14
		//check if go down	
		if(pl1_vc < 385+vbp && {pl1_data[9:8], pl1_data[23:16]} > 700)
			pl1_vc <= pl1_vc + speed;
		//check if go up	
		if(pl1_vc > 15+vbp && {pl1_data[9:8], pl1_data[23:16]} < 300)
			pl1_vc <= pl1_vc - speed;
		
		//define player 2 movement:
		
		//check if go left
				//check if go left
		if(pl2_hc > 325+hbp && {pl2_data[25:24], pl2_data[39:32]} > 700)
			pl2_hc <= pl2_hc - speed; //307
		//check if go right
		if( pl2_hc <615+hbp && {pl2_data[25:24], pl2_data[39:32]} < 300)
			pl2_hc <= pl2_hc + speed; // 13 instead of 14
		//check if go down	
		if( pl2_vc <385+vbp && {pl2_data[9:8], pl2_data[23:16]} > 700)
			pl2_vc <= pl2_vc + speed;
		//check if go up	
		if(pl2_vc > 15+vbp && {pl2_data[9:8], pl2_data[23:16]} < 300)
			pl2_vc <= pl2_vc - speed;
			

		// ******* CHANGE GOAL TO 240 += 60
		// ******* SO FROM 180 TO 300
	
		// if ball gets into pl1's goal
		// player 2 gets score incremented and gets the point
		if(ball_hc < 16+hbp && ball_vc > 180+vbp && ball_vc < 270+vbp) begin
			pl2_goal <= 1;
		end
		
		// if ball get into pl2's goal
		if(ball_hc > 594+hbp && ball_vc > 180+vbp && ball_vc < 270+vbp ) begin
			pl1_goal <= 1;
		end
		
		// if one hits, the round ends
		if(pl1_goal == 1 || pl2_goal == 1) begin
			// set done equal to 1, so we move to the nxt window
			 speed_h <= 0;
			 speed_v <= 0;
			done <= 1;
		end
		
		
	 
	 end // if pause == 0 end
	 else // so pause == 1
	 	begin
	 		//ball should remain in the same place
	 			ball_hc <= ball_hc;
				ball_vc <= ball_vc;
				//player 1 remains in the same place
				pl1_hc <= pl1_hc;
				pl1_vc <= pl1_vc;
				//player 2 remains in the same place
				pl2_hc <= pl2_hc;
				pl2_vc <= pl2_vc;

	 	end
	 
	 
	 end // end of always block
	 


endmodule























