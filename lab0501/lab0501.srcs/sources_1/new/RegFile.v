`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/12 15:19:09
// Design Name: 
// Module Name: RegFile
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
module RegFile //寄存器文件
    // A1A2是数据读出的地址，A3（WA3）是数据写入的地址，WD是写入的数据（32位）；
    // RD1和RD2是分别从A1A2读出的数据
    #(parameter ADDR_SIZE = 5)
    (input CLK, WE3, Rst,
    input [ADDR_SIZE-1:0] RA1, RA2, WA3,
    input [`DATA_WIDTH-1:0] WD3,
    output [`DATA_WIDTH-1:0] RD1, RD2);

    //寄存器文件
    reg [`DATA_WIDTH-1:0] rf[9:0];//reg [`DATA_WIDTH-1:0] rf[2 ** ADDR_SIZE-1:0];

    integer i; //临时变量。用于for循环
    // integer j;
    //for(i=0; i <= 9; i=i+1) rf[i] = 0;

    //assign WD3 = (WE3) ? WD3 : 32'bz; 
    //数据写入
    always@(posedge CLK)
        begin
            if(Rst) for(i = 0; i <= 9; i = i + 1) rf[i] = 32'h1234_5678;
            else if (WE3) rf[WA3] <= WD3; 
        end
    //数据读出
    assign RD1 = (RA1 != 0) ? rf[RA1] : 0;
    assign RD2 = (RA2 != 0) ? rf[RA2] : 0;

endmodule
