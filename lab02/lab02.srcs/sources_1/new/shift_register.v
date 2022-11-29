`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 21:04:14
// Design Name: 
// Module Name: shift_register
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


module shift_register(S1, S0, D, Dsl, Dsr, Q, CLK, CR);
    parameter N = 4;        // 参数化位宽
    input S1, S0;           // 控制输入
    input Dsl, Dsr;         // 串行输入端
    input CLK, CR;          // 时钟及异步清零
    input [N-1:0] D;        // 并行置入端
    output [N-1:0] Q;       // 寄存器输出
    reg [N-1:0] Q;

    always @(posedge CLK or negedge CR)
        if(~CR)
            Q <= 0;
        else
            case({S1, S0})
                2'b00: Q <= Q;                  // 保持
                2'b01: Q <= {Dsr, Q[N-1:1]};    // 右移
                2'b10: Q <= {Q[N-2:0], Dsl};    // 左移
                2'b11: Q <= D;                  // 并行输入
            endcase
endmodule
