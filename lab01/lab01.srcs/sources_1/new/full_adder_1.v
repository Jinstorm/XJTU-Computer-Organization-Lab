`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 21:52:23
// Design Name: 
// Module Name: full_adder_1
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


module full_adder_1(input A, B, Ci,
    output S, Co);

    wire Y1, Y2, Y3, Y4;

    half_adder half_adder1(.D0(A), .D1(B), .S(Y1), .C(Y2)),
               half_adder2(Ci, Y1, S, Y3);
    or21 or21_1(Y2, Y3, Co);

endmodule
