`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/10 22:52:44
// Design Name: 
// Module Name: sim_ARMCPU
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


module sim_ARMCPU();
    reg CLK; //控制信号输入
    wire [63:0] WriteData, DataAdr;
    wire MemWrite, MemRead;
    //integer i;

    initial begin
        CLK = 0;
        fork
            repeat(100) #10 CLK = ~CLK;
        join
    end

    ARM_CPU_pipeline ARM_CPU_pipeline_1(CLK, WriteData, DataAdr, MemWrite, MemRead);
endmodule
