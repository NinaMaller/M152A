`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:57 02/20/2018 
// Design Name: 
// Module Name:    stopwatch 
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
module stopwatch(
	input clk,
	input rst,
	input pause,
	input sel,
	input adj,
	output reg [7:0] seven_segment,
	output reg [3:0] anode
);

wire [3:0] min_t ; // minute tens
wire [3:0] min_o ; // minute  ones
wire [3:0] sec_t ; // second tens
wire [3:0] sec_o ; // second ones

wire [7:0] seg_min_t;
wire [7:0] seg_min_o;
wire [7:0] seg_sec_t;
wire [7:0] seg_sec_o;
wire [7:0] blank_digit;


wire two_Hz_clk_wire;
wire one_Hz_clk_wire;
wire faster_clk_wire;
wire blinking_clk_wire;

wire pause_button_valid, rst_button_valid;

  debouncer check_rst(
	.clk(clk),
	.button(rst),
	.button_valid(rst_button_valid)
	);
//assign rst_button_valid = rst;

debouncer check_pause(
	.clk(clk),
	.button(pause),
	.button_valid(pause_button_valid)
	);

clk_divider clk_div(
	.clk(clk),
	.rst(rst_button_valid),
	.two_Hz_clock(two_Hz_clk_wire),
	.one_Hz_clock(one_Hz_clk_wire),
	.faster_clock(faster_clk_wire),
	.blinking_clock(blinking_clk_wire)
	);

counter time_count(
	.clk(clk),
	.clk_1hz(one_Hz_clk_wire),
	.clk_2hz(two_Hz_clk_wire),
	.rst(rst_button_valid),
	.pause(pause_button_valid),
	.sel(sel),
	.adj(adj),
	.min_t_w(min_t),
	.min_o_w(min_o),
	.sec_t_w(sec_t),
	.sec_o_w(sec_o)
	);

seven_segment_display dis_min_t(
	.num(min_t),
	.seg(seg_min_t)
	);

seven_segment_display dis_min_o(
	.num(min_o),
	.seg(seg_min_o)
	);

seven_segment_display dis_sec_t(
	.num(sec_t),
	.seg(seg_sec_t)
	);

seven_segment_display dis_sec_o(
	.num(sec_o),
	.seg(seg_sec_o)
	);


seven_segment_display dis_blank(
	.num(4'b1111),
	.seg(blank_digit)
	);

	

reg [1:0] a = 2'b00;
//wire [3:0] anode;
//wire [6:0] seven_segment;




always @(posedge (faster_clk_wire)) begin
	// blinking mode
	if (adj == 1) begin
		// select minutes
		if (sel==0)begin
			if (a==0) begin
				anode <= 4'b0111;
				if(blinking_clk_wire) begin
					seven_segment <= seg_min_t;
				end

				else begin
					seven_segment <= blank_digit;
				end
				a <= 2'b01;
			end

			else if (a == 2'b01) begin
				anode <= 4'b1011;
				if (blinking_clk_wire) begin
					seven_segment <= seg_min_o;
				end
				else begin
					seven_segment <= blank_digit;
				end
				a <= 2'b10;
			end

			else if (a == 2'b10) begin
               		anode <= 4'b1101;
					seven_segment <= seg_sec_t;
					a <= 2'b11;		
			end
           
            else begin
            		anode <= 4'b1110;
					seven_segment <= seg_sec_o;
					a <= 2'b00;
            end
		end

		else begin  // sel ==1, choose second mode
			if (a ==0) begin
					anode <= 4'b0111;
					seven_segment <= seg_min_t;
					a <= 2'b01; // 01
			end

			else if (a==2'b01) begin
					anode <= 4'b1011;
					seven_segment <= seg_min_o;
					a <= 2'b10; // 10
			end

			else if (a == 2'b10) begin
				anode <= 4'b1101;
				if (blinking_clk_wire) begin
					seven_segment <= seg_sec_t;
				end

				else begin
					seven_segment <= blank_digit;
				end
                a <= 2'b11;

			end

			else if(a == 2'b11) begin
				anode <= 4'b1110;
				if (blinking_clk_wire) begin
					seven_segment <= seg_sec_o;
				end

				else begin
					seven_segment <= blank_digit;
				end
				a <= 2'b00;
			end
		end
	end


//regular modle
else  begin
/*
anode <= 4'b0111;;
seven_segment <= 8'b10010010;
end
*/

if(a == 0) begin
	anode <= 4'b0111;
	seven_segment <= seg_min_t;
//	seven_segment <= 8'b11000000;
	a <= 2'b01; // 01
end 

else if(a == 2'b01) begin
	anode <= 4'b1011;
	seven_segment <= seg_min_o;
	//seven_segment <= 8'b11000000;
	a <= 2'b10; // 10
end

else if(a == 2'b10) begin
	anode <= 4'b1101;
	seven_segment <= seg_sec_t;
	//seven_segment <= 8'b11000000;
	a <= 2'b11;
end

else begin // if(a == 2'b11) begin
	anode <= 4'b1110;
	seven_segment <= seg_sec_o;
//	seven_segment <= 8'b11000000;
	a <= 2'b00;
end  
end
end

endmodule



