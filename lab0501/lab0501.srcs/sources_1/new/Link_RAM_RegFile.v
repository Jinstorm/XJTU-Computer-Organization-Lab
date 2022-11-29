`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/12 16:36:24
// Design Name: 
// Module Name: Link_RAM_RegFile
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
module Link_RAM_RegFile
    #(parameter ADDR_SIZE = 5,      //寄存器地址的宽度
                Addr_Width = 8)     //存储器地址的线宽
    (input CLK, //时钟信号
    input [5:0] Op,   //指令选择
    input WE3, R_W, Rst_regfile,  //寄存器组的读写使能，存储器的RAM的读写使能 1读0写
    input [ADDR_SIZE-1:0] RA1, RA2, WA3, // RA1-RS WA3-RT
    //input [`DATA_WIDTH-1:0] WD3,    //要写入的数据
    input [15:0] imm,   //立即数
    output [`DATA_WIDTH-1:0] Out,    //RAM存储器的输出  

    input Rst,  //RAM的复位信号
    input [3:0] CS  //使能/片选信号
    );
    wire [`DATA_WIDTH-1:0] WD3;

    wire [`DATA_WIDTH-1:0] RD1, RD2;
    reg [Addr_Width-1:0] Addr;  //存储器的地址输入
    //reg [`DATA_WIDTH-1:0] A;// = 32'b0;
    wire [31:0] F;
    wire Zero;
    reg [3:0] OPALU = 4'b0100;  //加法选择信号
    wire [`DATA_WIDTH-1:0] B;

    assign WD3 = (WE3) ? Out : 32'bz; //assign WD3 = Data;
    assign Out = (R_W) ? 32'bz : RD2;

    // always@(*)
    //     begin
    //         //assign Data = (R_W) ? 32'bz:Data;
    //         case(Op)
    //             6'b100011: begin rw <= 1; Data = Outreg;  end  //LW OPALU = 4'b0100;  WD3tmp <= Data;
    //             6'b101011: begin rw <= 0; end
    //             //     rw = 0; Data = 32'bz;
    //             //     if (rw == 0)
    //             //         begin Data <= RD2; end
    //             //     end    //SW OPALU <= 0100; 
    //         endcase
    //     end

    SignExt SignExt_1(imm, B); // yes
    ALU ALU_1(F, RD1, B, OPALU, CLK, Zero); //F = RD1 运算 B， OPALU——选择信号 !RD1

    RAM_4Kx32_inout RAM_4Kx32_inout_r(Out, F[7:0], Rst, R_W, CS, CLK); // !F
    
    RegFile RegFile_1(CLK, WE3, Rst_regfile, RA1, RA2, WA3, WD3, RD1, RD2);  // !OUT——Data       //这里的RD1没有输出应该是因为Reg里都是空的.
    //读写使能，寄存器RA1地址，寄存器RA2地址，要写入的寄存器的地址，WD3(Data)要写入的数据，RD1输出1，RD2输出2

endmodule

module PCreg(In, Out, EN, CLK); //指令暂存器
    parameter WIDTH = 32;
    input [WIDTH-1:0] In;
    input CLK;
    input EN;
    output reg [WIDTH-1:0] Out;
    
    //reg [WIDTH-1:0] mem; 

    always@(CLK, EN)
    begin
        if(EN) Out <= In;
    end
endmodule

module Tmpreg(In, Out, CLK);
    parameter WIDTH = 32;
    input [WIDTH-1:0] In;
    input CLK;
    output reg [WIDTH-1:0] Out;
    
    //reg [WIDTH-1:0] mem; 

    always@(CLK)
    begin
        Out <= In;
    end
endmodule


module Mux2 //2选1
    #(parameter WIDTH = 8)
    (input [WIDTH-1:0] d0, d1,
    input select,
    output [WIDTH-1:0] y);

    assign y = select ? d1 : d0;
endmodule

module ALU(F, A, B, OP, CLK, Zero);
    parameter SIZE = 32; //运算位数
    input [3:0] OP; //运算操作
    input [SIZE-1:0] A; //左运算数
    input [SIZE-1:0] B; //右运算数
    input CLK;
    output [SIZE-1:0] F; //运算结果
    //output CF;      //进借位标志位
    output reg Zero; //0标志位
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

    //wire [7:0] EN;
    wire [SIZE-1:0] Fw, Fa;

    assign Fa = A & B; //按位与

    always@(*)
    begin
        C = 0;
        case(OP)
            ALU_AND: begin F = Fa; end     // 按位与
            ALU_OR: begin F = A|B; end     // 按位或
            ALU_XOR: begin F = A^B; end     // 按位异或
            ALU_NOR: begin F = ~(A|B); end  // 按位或非
            ALU_ADD: begin {C, F} = A + B; end  // 加法
            ALU_SUB: begin F = A - B; end  // 减法
            ALU_SLT: begin F = A < B; end   // A<B则F=1
            ALU_SLL: begin F = B << A; end  // 将B左移A位
            default: begin F = Fw;  end
        endcase
        if (F == 32'h00000000) Zero = 0;
    end

endmodule

module SignExt( //符号扩展
    input [`DATA_WIDTH/2-1:0] in,   //16位输入
    output [`DATA_WIDTH-1:0] out     //32位输出
    );
    assign out = {{16{in[15]}},in};
endmodule

