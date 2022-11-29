`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 15:01:40
// Design Name: 
// Module Name: addr_4bit
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


module addr_4bit(S, C3, A, B, C_1);
    input [3:0] A, B;   //四位被加数A和B
    input C_1;  //最低位的进位信号
    output [3:0] S; //四位和
    output C3;  //向最高位和=的进位信号
    wire C0, C1, C2;

    fulladder FA0(S[0], C0, A[0], B[0], C_1), //调用1位全加器
             FA1(S[1], C1, A[1], B[1], C0),
             FA2(S[2], C2, A[2], B[2], C1),
             FA3(S[3], C3, A[3], B[3], C2);

endmodule
