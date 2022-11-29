`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 15:12:45
// Design Name: 
// Module Name: addr_32bit
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


module addr_32bit(S, C1, A, B, C_1);
    input [31:0] A, B;   //32位被加数A和B
    input C_1;  //最低位的进位信号
    output [31:0] S; //32位和
    output C1;  //向最高位和=的进位信号
    wire C0;

    addr_16bit FA16bit0(S[15:0], C0, A[15:0], B[15:0], C_1), //调用16位全加器
             FA16bit1(S[31:16], C1, A[31:16], B[31:16], C0);
    
endmodule
