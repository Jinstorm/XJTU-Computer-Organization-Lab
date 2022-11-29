`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 16:06:32
// Design Name: 
// Module Name: sim_and61
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


module sim_and61();
    reg D0, D1, D2, D3, D4, D5; //定义测试输入信号
    wire Y;
    // initial语句只执行一次，用于仿真时变量初始化，生成激励波形
    initial begin
        D0 = 0; D1 = 0; D2 = 0; D3 = 0; D4 = 0; D5 = 0; //顺序执行语句begin...end语句在0时刻开始，顺序执行
        #5 {D0, D1, D2, D3, D4, D5} = 6'b100000; //位拼接赋值
        fork //并行语句块，语句并行执行
            repeat(5) #5 D1 = ~D1;
            repeat(5) #10 D2 = ~D2;
        join
    end
    initial fork    // 并行语句块，从0时刻开始，语句并行执行
        repeat(10) #15 D3 = ~D3;
        repeat(10) #20 D4 = ~D4;
    join
    always begin    //always语句循环/重复执行
        #10 D5 = ~D5;
    end

    //实例化待测模块
    and61 and61_1(D0, D1, D2, D3, D4, D5, Y);
endmodule
