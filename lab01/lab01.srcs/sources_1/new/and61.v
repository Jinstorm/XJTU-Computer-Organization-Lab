`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 15:55:08
// Design Name: 
// Module Name: and61
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


module and61(
    input D0, D1, D2, D3, D4, D5,
    output Y);

    wire Y1, Y2, Y3, Y4; // 中间变量
    // 结构化描述，底层模块实例调用
    and21 and21_1(D0, D1, Y1), // 按接口顺序调用
          and21_2(D2, D3, Y2),
          and21_3(D4, D5, Y3),
          and21_4(Y1, Y2, Y4),
          and21_5(.D0(Y3), .Y(Y), .D1(Y4)); // 按接口名调用

endmodule
