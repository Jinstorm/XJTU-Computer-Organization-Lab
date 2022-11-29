`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 15:16:15
// Design Name: 
// Module Name: RAM_1Kx16_inout
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


module RAM_1Kx16_inout(Data, Addr, Rst, R_W, CS, CLK);
    parameter Addr_Width = 6;  //参数化地址线宽
    parameter Data_Width = 16;  //参数化数据线宽
    parameter SIZE = 2 ** Addr_Width; //参数化大小1024
    inout [Data_Width-1:0] Data; //数据，输入输出类型
    input [Addr_Width-1:0] Addr; //地址
    input Rst;  //复位信号
    input R_W; //1读_0写信号
    input CS; //使能片选信号
    input CLK; //时钟信号

    //RAM的数据线是双向的，地址线是单向的
    integer i; //临时变量。用于for循环
    reg [Data_Width-1:0] Data_i;

    reg [Data_Width-1:0] RAM [SIZE-1:0];  //1024*16的RAM

    assign Data = (R_W) ? Data_i:16'bz; //z是高阻态，表示16位二进制高阻态
    always @(posedge CLK) begin //时钟同步
    //always @(*) begin   //异步
        casex({CS, Rst, R_W})
            4'bx1x : for(i=0; i <= SIZE-1; i=i+1) RAM[i] = 16'h1111;
            // $readmemb("D:/ram_data_b.txt, RAM, 0, 1023"); //读取二进制数据文件
            // $readmemh("D:/ram_data_b.txt, RAM, 0, 1023"); //读取十六进制数据文件
            4'b101 : Data_i <= RAM[Addr]; //读数据
            4'b100 : RAM[Addr] <= Data; //写数据
            default: Data_i = 16'bz;
        endcase
    end

endmodule
