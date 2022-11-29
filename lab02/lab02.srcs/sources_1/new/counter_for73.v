`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/08 09:38:07
// Design Name: 
// Module Name: counter_for73
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

// 使用同步置位异步清零的74LS161(四位二进制)级联构成73进制计数器
module counter_for73(CEP, CET, PE1, PE2, CLK, D1, D2, TC1, TC2, Q1, Q2, CR);//, CR1, CR2);
    parameter N = 4;
    parameter M = 16;
    input CEP, CET, PE1, PE2, CLK, CR;//, CR1, CR2; //控制信号输入(功能选择、PE=0同步置位、时钟、清零)
    input [N-1:0] D1, D2;    // 并行数据输入
    output TC1, TC2;      //进位输出 //
    output [N-1:0] Q1, Q2;   //数据输出

    wire CRA; // 用于判断计数终止进位
    // wire tmpTC1, tmpTC2, tmpQ1, tmpQ2;
    // assign tmpTC1 = TC1;
    // assign tmpTC2 = TC2;
    // assign tmpQ1 = Q1;
    // assign tmpQ2 = Q2;

    assign CRA = Q1[0:0] & Q1[3:3] & Q2[2:2]; //计数值为73时清零
    // CR和CRA任何一个为低电平都要清零
    wire reset = ~(CRA | ~CR);

    counter74x161 counter74x161_1(CEP, CET, PE1, CLK, reset, D1, TC1, Q1);
    counter74x161 counter74x161_2(TC1, TC1, PE2, CLK, reset, D2, TC2, Q2);

endmodule


    // assign CR1 = CRA; 
    // assign CR2 = CRA;

    // wire [3:0] and1, and2, and3;
    // wire tmp1, tmp2, tmp3, CRA;
    // // 按位与
    // assign and1 = Q1 & 4'b0001;
    // assign and2 = Q1 & 4'b1000;
    // assign and3 = Q2 & 4'b0100;
    // // 逻辑与
    // assign tmp1 = and1 && 4'b0000;
    // assign tmp2 = and2 && 4'b0000;
    // assign tmp3 = and3 && 4'b0000;


    // assign CRA = tmp1 && tmp2 && tmp3;  
    // assign CRA = CR1; 
    // assign CRA = CR2;








    // wire CE; //中间变量
    // assign CE = CEP & CET;  // CE = 1时，计数器计数

    // always @(posedge CLK, negedge CR1, negedge CR2)
    //     if(~CR1) begin Q1 <= 0;  end
    //     else if (~CR2) begin Q2 <= 0; TC2 = 0; end      //异步清零
    //     else if (D1 == 4'b1001 & D2 == 4'b0100) begin Q1 <= 0; Q2 <= 0; end //计数归零
    //     else if (~PE) begin Q1 <= D1; Q2 <= D2; end     //同步装入数据
    //     else if (CE) begin
    //         if(Q1 == M-1) begin
    //             Q2 <= Q2 + 1;
    //             Q1 <= 0;
    //         end
    //         else Q1 <= Q1 + 1;
    //     end
    //     else begin Q1 <= Q1; Q2 <= Q2; end //输出保持