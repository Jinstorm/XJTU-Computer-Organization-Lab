`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 17:40:18
// Design Name: 
// Module Name: sim_Dff
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


module sim_Dff();
    integer i;

    wire Q, QN; // 状态信号Q，～Q //不能用reg
    reg D;    // 激励信号
    reg EN, RST, CLK;  //使能信号EN， 复位信号RST

    initial begin
        D = 1; EN = 0; RST = 0;CLK = 0;
        fork
            repeat(20) #15 D = ~D;
            repeat(20) #20 EN = ~EN;
            repeat(20) #2 RST = ~RST;
            repeat(20) #8 CLK = ~CLK;
        join
    end

    D_ff D_ff_1(Q, QN, D, EN, RST, CLK); // D锁存器
endmodule
