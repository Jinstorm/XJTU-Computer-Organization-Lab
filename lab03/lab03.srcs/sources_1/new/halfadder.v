`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 14:47:34
// Design Name: 
// Module Name: halfadder
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


module halfadder(S, C, A, B);
    input A, B; //被加数A，加数B
    output S, C; //和S，进位C
    xor(S, A, B); //调用门级别=电路，实例名可省，调用顺序；先输出，后输入
    and(C, A, B);
endmodule
