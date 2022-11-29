`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 15:36:39
// Design Name: 
// Module Name: sim_and21
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


module sim_and21;
    reg D0, D1; // 定义测试输入信号
    wire Y; // 输出

    // initial语句只执行一次，用于仿真时变量初始化，生成激励波形
    initial begin //顺序语句块begin...end，语句在0时刻开始，顺序执行
        D0 = 0; D1 = 0;     // 初始化赋值
        #10 D0 = 1; D1 = 0; // 测试值 #10——隔10ns
        #10 D0 = 0; D1 = 1;
        #10 D0 = 1; D1 = 1;
        #10 D0 = 0; D1 = 0;

    end
    // 实例化待测模块
    and21 and21t(D0, D1, Y);    //实例化待测对象

endmodule
