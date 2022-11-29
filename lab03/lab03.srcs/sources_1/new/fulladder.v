`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 14:51:23
// Design Name: 
// Module Name: fulladder
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


module fulladder(S, Co, A, B, Ci);
    input A, B, Ci; //被加数A， 加数B， 低位进位Ci
    output S, Co; //和S， 向高位进位Co
    wire S1, D1, D2;
    halfadder HA1(S1, D1, A, B);
    halfadder HA2(.A(S1), .B(Ci), .S(S), .C(D2));
    or G1(Co, D2, D1); // 调用底层标准或门，调用顺序，先输出，后输入
endmodule
