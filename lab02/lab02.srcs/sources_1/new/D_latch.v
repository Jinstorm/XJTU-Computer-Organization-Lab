`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 17:09:55
// Design Name: 
// Module Name: D_latch
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


module D_latch(Q, QN, D, EN, RST); //锁存器
    output reg Q, QN; // 状态信号Q，～Q
    input D;    // 激励信号
    input EN, RST;  //使能信号EN， 复位信号RST

    always @(EN, RST, D) begin
        if(RST) begin // 复位优先
        //阻塞赋值语句，顺序执行
            Q = 0;
            QN = 1;
        end
        else if(EN) begin // 使能有效，赋值
        //非阻塞赋值语句，并行执行
            Q <= D;
            QN <= ~D;
        end
    end
endmodule
