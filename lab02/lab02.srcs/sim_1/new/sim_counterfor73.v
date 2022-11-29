`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/08 10:23:31
// Design Name: 
// Module Name: sim_counterfor73
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


module sim_counterfor73();
    parameter N = 4;
    reg CEP, CET, PE1, PE2, CLK, CR;//, CR1, CR2; //控制信号输入(功能选择、PE=0同步置位、时钟、清零)
    reg [N-1:0] D1, D2;    // 并行数据输入
    wire TC1, TC2;      //进位输出 //TC1没用
    wire [N-1:0] Q1, Q2;   //数据输出

    initial begin
        CEP = 0; CET = 0; PE1 = 0; PE2 = 0;D1 = 4'b0100; D2 = 4'b0000; CLK = 0; CR = 1;// CR1 = 0; CR2 = 0;
        fork
            repeat(1000) #5 CLK = ~CLK;
            # 20 CR = 0;
            # 40 CR = 1;
            # 30 CEP = 1;
            # 35 CET = 1;
            # 40 PE1 = 1; #40 PE2 = 1;
        join
        
    end
    counter_for73 counter_for73_1(CEP, CET, PE1, PE2, CLK, D1, D2, TC1, TC2, Q1, Q2, CR);//, CR1, CR2);
endmodule
