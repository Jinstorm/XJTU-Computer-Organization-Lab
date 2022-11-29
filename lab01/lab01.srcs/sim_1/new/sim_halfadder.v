`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 17:40:53
// Design Name: 
// Module Name: sim_halfadder
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


module sim_halfadder();
    reg D0, D1; //定义测试输入信号
    wire S, C;

    initial begin
        D0 = 0; D1 = 0; //顺序执行语句begin...end语句在0时刻开始，顺序执行
        #5 {D0, D1} = 2'b10; //位拼接赋值
        fork //并行语句块，语句并行执行
            repeat(5) #5 D0 = ~D0;
            repeat(5) #10 D1 = ~D1;
        join
    end
    initial fork
        repeat(10) #15 D0 = ~D0;
        repeat(10) #20 D1 = ~D1;
    join

    always begin    //always语句循环/重复执行
        #10 D0 = ~D0;
    end

    //实例化待测模块
    half_adder half_adder_1(D0, D1, S, C);
endmodule
