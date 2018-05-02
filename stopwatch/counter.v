`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:54 02/13/2018 
// Design Name: 
// Module Name:    counter 
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
module counter (
	 input clk,
    input clk_1hz,
    input clk_2hz,
    input rst, 
    input pause, 
    input sel, 
    input adj,
	 output wire [3:0] min_t_w, // minute tens, wire
	 output wire [3:0] min_o_w, // minute  ones, wire
  	 output wire [3:0] sec_t_w, // second tens
	 output wire [3:0] sec_o_w // second ones
);

//declare sregs and initialize to 0
reg [3:0] min_t = 0; // minute tens
reg [3:0] min_o = 0; // minute  ones
reg [3:0] sec_t = 0; // second tens
reg [3:0] sec_o = 0; // second ones

//reg this_clock;
//wire    current_clock;

wire clock;

assign clock = (adj == 0) ? clk_1hz : clk_2hz;

reg paused=0;
reg pause_pressed = 0;

always @ (posedge clk) begin // or posedge pause
  if (pause && pause_pressed == 0) begin
    paused <= ~paused;
	 pause_pressed <= 1;
  end 
  else if(~pause && pause_pressed == 1) begin
 //   paused <= paused;
	  pause_pressed <= 0;
  end
  
end


// reset counter whenever reset is high\
always @ (posedge clock or posedge rst )

begin
    if(rst) // rst == 1
        begin
            min_t <= 0; // minute tens
            min_o <= 0; // minute  ones
            sec_t <= 0; // second tens
            sec_o <= 0; // second ones
        end
    else 
        if (adj == 1'b0 && ~paused) begin
            // normal clock
            if (sec_o != 9) begin
                sec_o <= sec_o+1;
            end 
				else // the sec_o == 9 
				begin //then
                sec_o <= 0; // reset sec_o
                if (sec_t != 5) begin // if sec_t not maximum
                    sec_t <= sec_t + 1; // increment second tens
                end 
					 else begin // sec_t is equal to 5
                    sec_t <= 0; // reset it to zero
                    if (min_o != 9) begin // if the minutes tens != maximum
                        min_o <= min_o + 1; // increment minutes ones
                    end 
						  else begin // minutes ones = maximum
                        min_o <= 0; // reset minute ones to zero
                        if (min_t != 9) begin // if minutes tens are not maximum
                            min_t <= min_t + 1; // increment minutes tens
                        end
								else begin // minutes ten is equal to maximum
                            min_t <= 0; // reset them to zero
                        end
                    end
					  end
             end
         end
  //   end 
  
		  else if (adj == 1'b1 && sel == 1'b1 && ~paused) begin
            // increment minute
            if(sec_t == 5) begin // if we reached maximum minutes 99
                 if (sec_o ==9) begin // reset minutes to 00
                    sec_o <= 0;
                    sec_t <= 0;
                end 
					 else begin
						sec_o <= sec_o +1;
					 end
            end
				else begin // min_t != 9
					if(sec_o == 9) begin // if ones in minutes reached max 9
						sec_o <= 0;
						sec_t <= sec_t + 1;
					end
				   else if(sec_o != 9) begin // else, increment min
                    sec_o <= sec_o +1;
               end
           end
        end
  
		  else if (adj == 1'b1 && sel == 1'b0 && ~paused) begin
            // increment minute
            if(min_t == 9) begin // if we reached maximum minutes 99
                 if (min_o ==9) begin // reset minutes to 00
                    min_o <= 0;
                    min_t <= 0;
                end 
					 else begin
						min_o <= min_o +1;
					 end
            end
				else begin // min_t != 9
					if(min_o == 9) begin // if ones in minutes reached max 9
						min_o <= 0;
						min_t <= min_t + 1;
					end
				   else if(min_o != 9) begin // else, increment min
                    min_o <= min_o +1;
               end
           end
        end 
		  
	/*	  else if(paused) begin
				pause_pressed <= 0;
		  end
		*/
		  
		  
		/*  
        else if (adj == 1'b1 && sel == 1'b1 && ~paused) begin
            // increment second
				if(sec_t == 5 && sec_o == 0) begin
						sec_o <= 0;
                  sec_t <= 0;
				end
            if(sec_t == 5) begin // if we reached maximum second 59
              //  if(sec_o == 0) begin
					//		sec_o <= sec_o +1;
               //end
					 if (sec_o == 9) begin // reset minutes to 00
                    sec_o <= 0;
                    sec_t <= 0;
                 end 
					  
		//			 else begin
		//			  sec_o <= sec_o + 1;
		//			  end
					 // else begin  //if(sec_o != 9 )begin
						
            end 
				else begin
					if(sec_o == 9) begin // if ones in seconds reached max 9
						sec_o <= 0;
						sec_t <= sec_t + 1;
					end
			//	end
					else begin //(sec_o != 9)
					// begin // else, increment min
                    sec_o <= sec_o +1;
                end
          end
		end
		*/
end

/*
// pause the clock
always @ (posedge clk or posedge rst )
begin
    if(pause) // pause == 1
        begin
            min_t <= min_t; // minute tens
            min_o <= min_o; // minute  ones
            sec_t <= sec_t; // second tens
            sec_o <= sec_o; // second ones
        end
    else // pause == 0
        begin
            
        end
        
end
*/



/*
always @ (posedge clk or posedge rst) 
    begin
        if(adjust)
            begin
                this_clock = adjust_clock;
            end
        else // adjust = 0
            begin
                this_clock = clk;
            end
    end

    assign current_clock = this_clock;

*/


assign min_t_w = min_t; // minute tens
assign min_o_w = min_o; // minute  ones
assign sec_t_w = sec_t; // second tens
assign sec_o_w = sec_o; // second ones

/*
assign min_t_w = 4'b0001; // minute tens
assign min_o_w = 4'b0010; // minute  ones
assign sec_t_w = 4'b0011; // second tens
assign sec_o_w = 4'b0100; // second ones
*/

endmodule
