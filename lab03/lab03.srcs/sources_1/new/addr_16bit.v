`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 15:06:29
// Design Name: 
// Module Name: addr_16bit
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


module addr_16bit(S, C3, A, B, C_1);
    input [15:0] A, B;   //16位被加数A和B
    input C_1;  //最低位的进位信号
    output [15:0] S; //16位和
    output C3;  //向最高位和=的进位信号
    wire C0, C1, C2;

    addr_4bit FA4bit0(S[3:0], C0, A[3:0], B[3:0], C_1), //调用4位全加器
             FA4bit1(S[7:4], C1, A[7:4], B[7:4], C0),
             FA4bit2(S[11:8], C2, A[11:8], B[11:8], C1),
             FA4bit3(S[15:12], C3, A[15:12], B[15:12], C2);
endmodule
