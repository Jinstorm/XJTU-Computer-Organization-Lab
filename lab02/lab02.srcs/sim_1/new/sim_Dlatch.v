`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 17:16:11
// Design Name: 
// Module Name: sim_Dlatch
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


module sim_Dlatch();
    // reg[2:0] I; //3位
    // wire[7:0] Y_case;
    integer i;

    wire Q, QN; // 状态信号Q，～Q //不能用reg
    reg D;    // 激励信号
    reg EN, RST;  //使能信号EN， 复位信号RST

    initial begin
        D = 1; EN = 0; RST = 0;
        fork
            repeat(20) #15 D = ~D;
            repeat(20) #5 EN = ~EN;
            repeat(20) #2 RST = ~RST;
        join
    end

    D_latch D_latch_1(Q, QN, D, EN, RST); // D锁存器
endmodule
