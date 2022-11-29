`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 21:48:24
// Design Name: 
// Module Name: counter74x161
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


module counter74x161(CEP, CET, PE, CLK, CR, D, TC, Q);
    parameter N = 4;
    parameter M = 16;
    input CEP, CET, PE, CLK, CR; //控制信号输入
    input [N-1:0] D;    // 并行数据输入
    output reg TC;      //进位输出
    output reg [N-1:0] Q;   //数据输出

    wire CE; //中间变量
    assign CE = CEP & CET;  // CE = 1时，计数器计数
    always @(posedge CLK, negedge CR)
        if(~CR) begin Q <= 0; TC = 0;end //清零
        else if(~PE) Q <= D;        // PE=0,同步装入数据
        else if(CE && TC == 1) TC <= 0;
        else if(CE) begin           //计数
            if(Q == M-1) begin
                TC <= 1;        //进位输出
                Q <= 0;         //计数归零
            end
            else Q <= Q + 1;    //计数
        end
        else Q <= Q;            // 输出保持
    
endmodule
