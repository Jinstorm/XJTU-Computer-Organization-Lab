`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 20:41:30
// Design Name: 
// Module Name: sim_RAM4Kx32
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


module sim_RAM4Kx32();
    parameter Addr_Width = 8;  //参数化地址线宽
    parameter Data_Width = 32;  //参数化数据线宽
    parameter SIZE = 2 ** Addr_Width; //参数化大小1024
    reg [Data_Width-1:0] Dataw; //数据，输入输出类型

    wire [Data_Width-1:0] Data; //数据，输入输出类型

    
    reg [Addr_Width-1:0] Addr; //地址
    reg Rst;  //复位信号
    reg R_W; //1读_0写信号
    reg CS; //使能片选信号
    reg CLK; //时钟信号

    //assign Data = R_W ? Dataw:32'bz;
    assign Data = (R_W) ? 32'bz:Dataw;//32'hFFFF_FFF1;

    initial begin
        Rst = 1; R_W = 0;  CLK = 0; Addr = 12'b0000_0000_0000; CS = 1;
        Dataw = 32'h1234_5678;
        fork
            #10 Rst = 0;
            //#10 CS = 1;
            #300 Rst = 1;
            #310 Rst = 0;
            repeat(500) #3 CLK = ~CLK;
            repeat(40) #15 R_W = ~R_W;
            repeat(40) #15 Addr = 12'b0000_0000_0000;
            repeat(20) #100 Addr = 12'b0000_0000_0000;
            repeat(20) #40 Addr = 12'b0000_0000_0001;
            repeat(20) #30 Addr = 12'b0000_0000_0011;
            repeat(20) #20 Addr = 12'b0000_0000_0101;
            repeat(20) #25 Addr = 12'b0000_0000_0111;
            repeat(20) #15 Addr = 12'b0000_0000_1001;
        join
    end
    
    RAM_4Kx32_inout RAM_4Kx32_inout_r(Data, Addr, Rst, R_W, CS, CLK); 

endmodule
