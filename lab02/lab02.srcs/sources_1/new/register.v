`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 17:46:51
// Design Name: 
// Module Name: register
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


module register(Q, D, OE, CLK);
    parameter N = 8;
    output reg [N-1:0] Q; // 输出Q
    input [N:1] D;
    input OE, CLK;  //三态输出

    //CLK，OE边沿敏感触发
    always @ (posedge CLK or posedge OE)
        if (OE) Q <= 8'bzzzz_zzzz; // 使能无效输出高阻态
        else Q <= D;    //存入和读出数据
endmodule
