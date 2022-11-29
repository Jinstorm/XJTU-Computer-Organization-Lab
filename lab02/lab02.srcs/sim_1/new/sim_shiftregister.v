`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 21:25:54
// Design Name: 
// Module Name: sim_shiftregister
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


module sim_shiftregister();
    integer i;

    wire[3:0] Q; // 状态信号Q，～Q //不能用reg
    reg[3:0] D;    // 激励信号
    reg S1, S0, Dsl, Dsr, CLK, CR;  //使能信号EN， 复位信号RST

    initial begin
        D = 4'b0101; Dsl = 0; Dsr = 1; CR = 0; CLK = 0; S1 = 1; S0 = 1;
        fork
            #12 CR = ~CR;
            repeat(100) #8 CLK = ~CLK;
            repeat(20) #120 S1 = ~S1;
            repeat(20) #60 S0 = ~S0;
        join
    end

    shift_register shift_register_1(S1, S0, D, Dsl, Dsr, Q, CLK, CR);

endmodule
