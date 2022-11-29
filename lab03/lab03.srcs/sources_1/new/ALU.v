`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/14 16:00:44
// Design Name: 
// Module Name: ALU
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


module ALU(F, CF, A, B, OP, CLK);
    parameter SIZE = 32; //运算位数
    input [3:0] OP; //运算操作
    input [SIZE-1:0] A; //左运算数
    input [SIZE-1:0] B; //右运算数
    input CLK;
    output [SIZE-1:0] F; //运算结果
    output CF;      //进借位标志位
    reg [SIZE-1:0] F;
    reg C;//, CF;

    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_XOR = 4'b0010;
    parameter ALU_NOR = 4'b0011;
    parameter ALU_ADD = 4'b0100;
    parameter ALU_SUB = 4'b0101;
    parameter ALU_SLT = 4'b0110;
    parameter ALU_SLL = 4'b0111;

    wire [7:0] EN;
    wire [SIZE-1:0] Fw, Fa, CFw;
    assign CFw = CF;

    assign Fa = A & B; //按位与

    always@(*)
    begin
        C = 0;
        //CF = C; //进位借位标志
        case(OP)
            ALU_AND: begin F = Fa; end     // 按位与
            ALU_OR: begin F = A|B; end     // 按位或
            ALU_XOR: begin F = A^B; end     // 按位异或
            ALU_NOR: begin F = ~(A|B); end  // 按位或非
            // 4'b0100: begin {C, F} = A + B; end  // 加法
            // ALU_SUB: begin F = A - B; end  // 减法
            ALU_SLT: begin F = A < B; end   // A<B则F=1
            ALU_SLL: begin F = B << A; end  // 将B左移A位
            default: begin F = Fw;  end
        endcase
    end

    Decoder38 decoder38_1(OP[2:0], EN);

    ADD add_1(Fw, CF, A, B, EN[4], CLK);

    SUB sub_1(Fw, CF, A, B, EN[5], CLK);

    // SLT slt_1(Fw, A, B, EN[6], CLK);

    // SLL sll_1(Fw, A, B, EN[7], CLK);

endmodule


    // always@(*)
    // begin
    //     C = 0;
    //     case(OP)
    //         4'b0000: begin F = A&B; end     // 按位与
    //         4'b0001: begin F = A|B; end     // 按位或
    //         4'b0010: begin F = A^B; end     // 按位异或
    //         4'b0011: begin F = ~(A|B); end  // 按位或非
    //         4'b0100: begin {C, F} = A + B; end  // 加法
    //         4'b0101: begin {C, F} = A - B; end  // 减法
    //         4'b0110: begin F = A < B; end   // A<B则F=1
    //         4'b0111: begin F = B << A; end  // 将B左移A位
    //     endcase
    //     ZF = F == 0; //F全为0，则ZF=1
    //     CF = C; //进位借位标志
    //     OF = A[SIZE]^B[SIZE]^F[SIZE]^C; //溢出标志公式
    //     SF = F[SIZE];   //符号标志公式
    //     PF = ~^F;   //奇偶标志，F有奇数个1，PF为1
    // end

    // parameter ALU_AND = 4'b0000;
    // parameter ALU_OR  = 4'b0001;
    // parameter ALU_XOR = 4'b0010;
    // parameter ALU_NOR = 4'b0011;
    // parameter ALU_ADD = 4'b0100;
    // parameter ALU_SUB = 4'b0101;
    // parameter ALU_SLT = 4'b0110;
    // parameter ALU_SLL = 4'b0111;

    // wire [7:0] EN;
    // wire [SIZE-1:0] Fw, Fa;

    // Decoder38 decoder38_1(OP[2:0], EN);

    // ADD add_1(Fw, CF, A, B, EN[4], CLK);

    // SUB sub_1(Fw, CF, A, B, EN[5], CLK);

    // SLT slt_1(Fw, A, B, EN[6], CLK);

    // SLL sll_1(Fw, A, B, EN[7], CLK);
