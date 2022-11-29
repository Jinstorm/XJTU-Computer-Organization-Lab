`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 15:36:37
// Design Name: 
// Module Name: encoder83_case
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


module encoder83_case(I, Y); //8-3编码器，case实现
    input I;
    output Y;
    wire[7:0] I; //8位
    reg[3:1] Y;

    always @(I) begin
        case(I)
            8'b0000_0001 : Y = 3'b000;
            8'b0000_0010 : Y = 3'b001;
            8'b0000_0100 : Y = 3'b010;
            8'b0000_1000 : Y = 3'b011;
            8'b0001_0000 : Y = 3'b100;
            8'b0010_0000 : Y = 3'b101;
            8'b0100_0000 : Y = 3'b110;
            8'b1000_0000 : Y = 3'b111;

        endcase
    end
endmodule
