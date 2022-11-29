`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 17:28:53
// Design Name: 
// Module Name: half_adder
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


module half_adder(input D0, D1,
    output S, C);

    wire Y1, Y2, Y3, Y4;

    nor11 nor11_1(D0, Y1); //~A
    nor11 nor11_2(D1, Y2); //~B

    and21 and21_1(Y1, D1, Y3),
          and21_2(D0, Y2, Y4);

    or21 or21_1(Y3, Y4, S);
    
    and21 and21_3(D0, D1, C);
    
endmodule
