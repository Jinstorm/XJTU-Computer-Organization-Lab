`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 20:15:01
// Design Name: 
// Module Name: RAM_4Kx32_inout
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


module RAM_4Kx32_inout  //256*32bit
    #(parameter Addr_Width = 8,    //参数化地址线宽
                Data_Width = 32 ) // 参数化数据线宽
    (inout [Data_Width-1:0] Data,   //数据输出
    input [Addr_Width-1:0] Addr,    //地址数据
    input Rst,  //复位信号
    input R_W,  //读写信号
    input CS,   //使能/片选信号
    input CLK); //时钟信号

    wire [3:0] CS_i;    //片信号组
    Decoder24 Decoder24_1(CS_i, Addr[Addr_Width-1:Addr_Width-2]);   //24译码器生成片选信号
    
    // //inout类型接口输入输出控制—仿真模块
    //assign Data = (R_W) ? 32'bz:Data;
    //assign Data = (R_W) ? Data:32'bz;
    //字位扩展
    RAM_1Kx16_inout CSO_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[0], CLK),
                    CSO_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[0], CLK);
    RAM_1Kx16_inout CS1_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[1], CLK),
                    CS1_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[1], CLK);
    RAM_1Kx16_inout CS2_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[2], CLK),
                    CS2_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[2], CLK);
    RAM_1Kx16_inout CS3_H_16bit(Data[Data_Width-1:Data_Width/2], Addr[Addr_Width-3:0], Rst, R_W, CS_i[3], CLK),
                    CS3_L_16bit(Data[Data_Width/2-1:0], Addr[Addr_Width-3:0], Rst, R_W, CS_i[3], CLK);
    
    // assign Data = (R_W) ? Data_i:16'bz; //z是高阻态，表示16位二进制高阻态
    //     //always @(posedge CLK) begin //时钟同步
    // always @(*) begin   //异步
    //     casex({CS, Rst, R_W})
    //         4'bx1x : for(i = 0; i <= SIZE-1; i = i+1) RAM[i] = 0;
    //         // $readmemb("D:/ram_data_b.txt, RAM, 0, 1023"); //读取二进制数据文件
    //         // $readmemh("D:/ram_data_b.txt, RAM, 0, 1023"); //读取十六进制数据文件
    //         4'b101 : Data_i <= RAM[Addr]; //读数据
    //         4'b100 : RAM[Addr] <= Data; //写数据
    //         default : Data_i = 16'bz;
    //     endcase
    // end

endmodule
