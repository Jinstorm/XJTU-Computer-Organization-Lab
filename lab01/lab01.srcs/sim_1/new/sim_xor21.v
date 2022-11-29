`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 17:10:03
// Design Name: 
// Module Name: sim_xor21
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


module sim_xor21;
    reg D0, D1;
    wire Y;

    initial begin //顺序语句块begin...end，语句在0时刻开始，顺序执行
        D0 = 0; D1 = 0;     //初始值
        #10 D0 = 1; D1 = 0; //测试值 #10——隔10ns
        #10 D0 = 0; D1 = 1;
        #10 D0 = 1; D1 = 1;
        #10 D0 = 0; D1 = 0;

    end

    xor21 xor21t(D0, D1, Y);    //实例化待测对象
endmodule
