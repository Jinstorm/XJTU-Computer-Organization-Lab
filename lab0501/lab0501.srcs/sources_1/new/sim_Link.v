`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/12 19:15:15
// Design Name: 
// Module Name: sim_Link
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

`define DATA_WIDTH 32
module sim_Link();
    parameter ADDR_SIZE = 5,      //寄存器地址的宽度
                Addr_Width = 8;
    reg CLK; //时钟信号
    reg [5:0] Op;   //指令选择
    reg WE3, R_W, Rstregfile;  //寄存器组的读写使能，存储器的RAM的读写使能 1读0写
    reg [ADDR_SIZE-1:0] RA1, RA2, WA3; // RA1-RS WA3-RT
    //reg [`DATA_WIDTH-1:0] WD3;    //要写入的数据
    reg [15:0] imm;   //立即数
    wire [`DATA_WIDTH-1:0] Out;    //RAm存储器的输出  

    reg Rst;  //RAM的复位信号
    reg CS; //使能/片选信号

    initial begin
        CLK = 0; WE3 = 1;  RA1 = 5'b00001; RA2 = 5'b00001; // RA2 = WA3即可，先lw再sw再lw看看是不是同一个值
        CS = 1; //WD3 = 32'hz;//12345678;
        imm = 16'h0000;
        WA3 = 5'b00010;
        Op = 6'b100011; 
        Rstregfile = 0;
        fork
            repeat(200) #5 CLK = ~CLK;
            //初始化Regfile和RAM
            #5 Rst = 1;
            #5 Rstregfile = 1;
            #10 Rst = 0;
            #10 Rstregfile = 0;
            //lw——向WA3 = 00010写入存储器中（RA1+imm）初始化的fffff值
            #25 WE3 = 1;
            #25 R_W = 1;
            //#25 WD3 = 32'h12345678;
            //sw——从寄存器组中的00001（RA2）读出初始化的数据0000_0001，写入存储器的位置（RA1+imm）
            #55 Op = 6'b101011;
            #55 RA2 = 5'b00010;
            #55 R_W = 0;
            #55 WE3 = 0;

            //lw——从存储器的（RA1+imm）位置读出刚刚写入的数据0000_0001，写入寄存器组中（WA3）。
            #105 Op = 6'b100011; 
            #105 WE3 = 1;
            #105 R_W = 1;

            //sw——从寄存器组中的00010（RA2）读出初始化的数据0000_0001，写入存储器的位置（RA1+imm）
            #155 RA2 = 5'b00001;
            #155 Op = 6'b101011;
            #155 R_W = 0;
            #155 WE3 = 0;
            //lw——从存储器的（RA1+imm）位置读出刚刚写入的数据0000_0001，写入寄存器组中（WA3）。
            #205 Op = 6'b100011; 
            #205 WE3 = 1;
            #205 R_W = 1;

            // //lw——从存储器的（RA1+imm）位置读出刚刚写入的数据0000_0001，写入寄存器组中（WA3）。
            // #255 Op = 6'b100011; 
            // #255 WD3 = 32'h12344321;
            // #255 WE3 = 1;
            // #255 R_W = 0;


        join

    end

    Link_RAM_RegFile Link_RAM_RegFile_1(CLK, Op, WE3, R_W, Rstregfile, RA1, RA2, WA3, imm, Out, Rst, CS);

endmodule
