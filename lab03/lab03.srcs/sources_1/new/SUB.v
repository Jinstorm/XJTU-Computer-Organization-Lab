`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 10:03:55
// Design Name: 
// Module Name: SUB
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


module SUB(Fw, CF, A, B, EN, CLK);
    input [31:0] A, B;
    input CLK, EN;
    output reg [31:0] Fw; //32位和
    //reg F, Fw;
    //wire [31:0] F;
    output reg CF;

    always @(posedge CLK) begin
        case(EN)
            1 : begin if(A>B) begin Fw <= A - B; CF <= 0; end
                      else if(A<B) begin Fw <= A - B; CF <= 1; end
                      else begin Fw <= 32'bz; CF <= 4'bz; end 
                end
            0 : begin Fw <= 32'bz; CF <= 4'bz; end
        endcase
    end
    
endmodule
