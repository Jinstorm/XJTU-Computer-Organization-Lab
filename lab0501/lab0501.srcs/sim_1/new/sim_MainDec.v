`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/14 21:08:38
// Design Name: 
// Module Name: sim_MainDec
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


module sim_MainDec();
    reg [5:0] Op;
    wire MemtoReg,MemWrite;
    wire Branch,ALUSrc;
    wire RegDst,RegWrite;
    wire ALUSrc;
    wire [1:0]ALUOp;
    initial begin
        Op=6'b000000; //R
        #100 Op=6'b100011; //lw(load)
        #100 Op=6'b000100; //BEQ
        #100 Op=6'b000010; //J
    end
MainDec MainDec_1(Op,MemtoReg,MemWrite,Branch,ALUSrc,RegDst,RegWrite,ALUSrc,ALUOp);

endmodule
