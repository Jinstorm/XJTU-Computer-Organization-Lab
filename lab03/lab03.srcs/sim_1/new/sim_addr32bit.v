`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 15:15:40
// Design Name: 
// Module Name: sim_addr32bit
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


module sim_addr32bit();
    reg [31:0] A, B; //定义测试输入信号
    reg Ci;
    wire [31:0] S;
    wire Co;
    initial begin
        A = 0; B = 0; Ci = 0;//顺序执行语句begin...end语句在0时刻开始，顺序执行
        #5 {A, B} = 32'b00000000000000000000000000000000; //位拼接赋值
        fork //并行语句块，语句并行执行
            repeat(50) #5 Ci = ~Ci;
            repeat(50) #6 B = B + 10;
            repeat(50) #6 A = A + 10;
            #30 A = 32'b11111111111111111111110110111101;
            #30 B = 32'b00000000000000000000001001000010;
            #30 Ci = 1;
        join
    end

    // initial fork
    //     repeat(10) #15 A = ~A;
    //     repeat(10) #20 Ci = ~Ci;
    // join
    // always begin    //always语句循环/重复执行
    //     #10 B = ~B;
    // end
    //实例化待测模块
    addr_32bit addr_32bit_1(S, Co, A, B, Ci);
endmodule
