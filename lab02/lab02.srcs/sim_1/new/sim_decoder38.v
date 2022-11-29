`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 16:49:05
// Design Name: 
// Module Name: sim_decoder38
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


module sim_decoder38();
    reg[2:0] I; //3位
    wire[7:0] Y_case;
    integer i;

    initial begin
        I = 1;
        for(i = 0; i < 2; i = i + 1) #10 I = I*2;
        #10 I = 4;
        while(I > 0) #5 I = I - 1;
    end

    decoder38 decoder38_1(I, Y_case); // 3-8译码器
    
endmodule
