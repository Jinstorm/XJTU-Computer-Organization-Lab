`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 22:30:18
// Design Name: 
// Module Name: sim_counter74x161
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


module sim_counter74x161();
    parameter N = 4;
    reg CEP, CET, PE, CLK, CR; //控制信号输入
    reg [N-1:0] D;    // 并行数据输入
    wire TC;      //进位输出 //不能用reg
    wire [N-1:0] Q;   //数据输出 //不能用reg

    integer i;

    initial begin
        CEP = 0; CET = 0; PE = 1; D = 4'b1100; CLK = 0; CR = 0;
        fork
            #25 CR = 1;
            #70 CR=0;
            # 90 CR = 1;
            #40 PE = 0;
            # 60 PE = 1;
            //for(i = 0; i < 100; i = i + 1) #10 D = D + 1;
            repeat(100) #10 CLK = ~CLK;
            # 30 CEP = 1;
            # 35 CET = 1;
        join
        
    end

    counter74x161 counter74x161_1(CEP, CET, PE, CLK, CR, D, TC, Q);
endmodule
