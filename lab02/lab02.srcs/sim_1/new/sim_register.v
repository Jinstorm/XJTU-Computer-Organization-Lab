`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 20:22:25
// Design Name: 
// Module Name: sim_register
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


module sim_register();
    integer i;

    wire[7:0] Q; // 状态信号Q，～Q //不能用reg
    reg[7:0] D;    // 激励信号
    reg OE, CLK;  //使能信号EN， 复位信号RST

    initial begin
        D = 8'b1000_1001; OE = 0; CLK = 0;
        fork
            #150 D = ~D;
            repeat(20) #5 OE = ~OE;
            repeat(20) #10
            
             CLK = ~CLK;
        join
    end


    register register_1(Q, D, OE, CLK);
endmodule
