`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/14 21:07:17
// Design Name: 
// Module Name: MainDec
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


//MIPS处理器 控制单元 主译码器
module MainDec( //主译码器
    input [5:0] Op,
    output MemToReg, MemWrite,
    output Branch, ALUSrc,
    output RegDst, RegWrite,
    output Jump,
    output [1:0] ALUOp
    );

    reg [8:0] Controls;

    assign {RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = Controls;

    always@(*)
        case(Op)
            6'b000000: Controls <= 9'b110000010;
            6'b100011: Controls <= 9'b101001000; //LW
            6'b101011: Controls <= 9'b001010000; //SW
            6'b000100: Controls <= 9'b000100001;
            6'b001000: Controls <= 9'b101000000;
            6'b000010: Controls <= 9'b000000100;
            default:   Controls <= 9'bxxxxxxxxx;
        endcase
endmodule
