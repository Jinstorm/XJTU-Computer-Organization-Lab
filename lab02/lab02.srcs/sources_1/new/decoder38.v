`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 16:42:26
// Design Name: 
// Module Name: decoder38
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


module decoder38(A, Y);
    input [2:0]A;
    output reg[7:0] Y;
    integer i;

    always @(A) begin
        Y = 8'b1111_1111;
        for(i = 0; i <=7; i = i + 1)
            if(A == i) // ==逻辑相等 ===逻辑全等
                Y[i] = 0;
            else
                Y[i] = 1;

    end
endmodule
