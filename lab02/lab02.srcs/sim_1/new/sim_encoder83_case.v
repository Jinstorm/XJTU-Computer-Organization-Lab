`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 15:45:34
// Design Name: 
// Module Name: sim_encoder83_case
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


module sim_encoder83_case();
    reg[7:0] I; //8位
    wire[3:1] Y_case, Y_precase;
    integer i;

    initial begin
        I = 1;
        for(i = 0; i < 7; i = i + 1) #10 I = I*2;
        #10 I = 128;
        while(I > 0) #5 I = I - 1;
    end

    encoder83_case encoder83_case_1(I, Y_case); // 编码器8-3
    pre_encoder83_case pre_encoder83_case_1(.I(I), .Y(Y_precase)); // 优先权编码器
endmodule
