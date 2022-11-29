`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 20:51:31
// Design Name: 
// Module Name: Decoder24
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decoder24(Y, A);
    input [1:0]A;
    output reg[3:0] Y;
    integer i;

    always @(A) begin
        Y = 4'b0000;
        for(i = 0; i <=3; i = i + 1)
            if(A == i) // ==逻辑相等 ===逻辑全等
                Y[i] = 1;
            else
                Y[i] = 0;
    end
endmodule
