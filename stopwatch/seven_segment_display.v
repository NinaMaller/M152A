`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:10 02/15/2018 
// Design Name: 
// Module Name:    seven_segment_display 
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
module seven_segment_display(
 input [3:0] num, // number
 output [7:0] seg //corresponding segments to be illuminated
    );

reg [7:0] seven_seg;

always @ (*)
begin 
//seven_seg = 8'b10010010;

	if(num == 4'b0000)
		seven_seg = 8'b11000000;
	else if(num == 4'b0001)
		seven_seg = 8'b11111001;
	else if(num == 4'b0010)
		seven_seg = 8'b10100100;
	else if(num == 4'b0011)
		seven_seg = 8'b10110000;
	else if(num == 4'b0100)
		seven_seg = 8'b10011001;
	else if(num == 4'b0101)
		seven_seg = 8'b10010010;
	else if(num == 4'b0110)
		seven_seg = 8'b10000010;
	else if(num == 4'b0111)
		seven_seg = 8'b11111000;
	else if(num == 4'b1000)
		seven_seg = 8'b10000000;
	else if(num == 4'b1001)
		seven_seg = 8'b10010000;
	else
		seven_seg = 8'b11111111; //default: nothing is on 
		
end


assign seg = seven_seg;

endmodule

















