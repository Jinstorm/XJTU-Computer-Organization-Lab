`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 15:11:56
// Design Name: 
// Module Name: and21
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


module and21(D0, D1, Y);//二输入与门

    input D0;
    input D1;
    output Y;

    wire D0, D1, Y;
    assign Y = D0 & D1;

endmodule
