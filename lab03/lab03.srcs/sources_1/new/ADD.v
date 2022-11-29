`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 22:51:35
// Design Name: 
// Module Name: ADD
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


module ADD(Fw, CFw, A, B, EN, CLK);
    input [31:0] A, B;
    input CLK, EN;
    output reg [31:0] Fw; //32位和
    wire [31:0] F;
    output reg CFw; //向最高位的进位信号
    wire CF;  

    reg C_1 = 0;
    always @(posedge CLK) begin
        case(EN)
            1 : begin Fw <= F; CFw <= CF; end
            0 : begin Fw <= 32'bz; CFw <= 4'bz; end
        endcase
    end

    addr_32bit addr_32bit_1(F, CF, A, B, C_1);
endmodule
