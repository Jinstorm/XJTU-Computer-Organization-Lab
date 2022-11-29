`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 17:21:53
// Design Name: 
// Module Name: full_adder1
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


module full_adder1input A1, B1, C1,
    output S2, C2);

    wire Y1, Y2, Y3, Y4;

    and21 and21_1(D0, D1, Y1),
          and21_2(D2, D3, Y2),
          and21_3(D4, D5, Y3),
          and21_4(Y1, Y2, Y4),
          and21_5(.D0(Y3), .Y(Y), .D1(Y4));
endmodule
