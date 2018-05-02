`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:39 02/15/2018 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer( 
	input clk,
	input button,
	output button_valid	
);

reg [15:0] count;
reg inst_vld;


   
   always @ (posedge clk) begin
     if (button == 0)
       begin
          count <=0;
          inst_vld <=0;
       end
     else
       begin
          count <= count +1;
          if(count == 16'hffff) begin
            count <=0;
          inst_vld <=1;
          end
       end
   end
 


assign button_valid = inst_vld;    

endmodule

