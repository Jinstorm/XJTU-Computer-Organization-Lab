`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/31 22:00:10
// Design Name: 
// Module Name: sim_fulladder
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


module sim_fulladder();
    reg A, B, Ci; //定义测试输入信号
    wire S, Co;

    initial begin
        A = 0; B = 0; Ci = 0;//顺序执行语句begin...end语句在0时刻开始，顺序执行
        #5 {A, B, Ci} = 3'b100; //位拼接赋值
        fork //并行语句块，语句并行执行
            repeat(5) #5 A = ~A;
            repeat(5) #10 B = ~B;
        join
    end
    initial fork
        repeat(10) #15 A = ~A;
        repeat(10) #20 Ci = ~Ci;
    join

    always begin    //always语句循环/重复执行
        #10 B = ~B;
    end

    //实例化待测模块
    full_adder_1 full_adder_1_1(A, B, Ci, S, Co);
endmodule
