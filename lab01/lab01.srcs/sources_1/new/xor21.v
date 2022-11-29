`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 17:08:20
// Design Name: 
// Module Name: xor21
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


module xor21(D0, D1, Y);//二输入异或门

    input D0;
    input D1;
    output Y;

    wire D0, D1, T;
    assign Y = D0 ^ D1;

endmodule
