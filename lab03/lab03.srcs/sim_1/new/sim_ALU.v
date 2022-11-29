`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 16:35:14
// Design Name: 
// Module Name: sim_ALU
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


module sim_ALU();
    parameter SIZE = 32;
    reg [SIZE-1:0] A, B; //定义测试输入信号
    reg [3:0] OP;
    reg CLK;
    wire [SIZE-1:0] F;
    wire CF;
    initial begin
        OP = 4'b0000; B = 32'hfffffff9; A = 32'h00000003; CLK = 0;
        fork
            repeat(100) #5 OP = (OP + 1) % 8;
            repeat(200) #3 CLK = ~CLK;
            #300 A = 32'hfffffff7;
        join

    end

    ALU ALU_1(F, CF, A, B, OP, CLK);

endmodule
