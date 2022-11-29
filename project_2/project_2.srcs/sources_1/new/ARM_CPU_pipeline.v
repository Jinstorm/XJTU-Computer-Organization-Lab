`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/08 19:31:38
// Design Name: 
// Module Name: ARM_CPU_pipeline
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

`define DATA_WIDTH 64
`define ADDR_WIDTH 32


module RegFile //寄存器文件
    // RA1、RA2是数据读出的地址，RA3（WA3）是数据写入的地址，WD是写入的数据（32位）；
    // RD1和RD2是分别从A1A2读出的数据
    #(parameter ADDR_SIZE = 5)
    (input CLK, RegWrite,
    input [ADDR_SIZE-1:0] Readreg1, Readreg2, Writereg3,
    input [`DATA_WIDTH-1:0] WriteData3,
    output [`DATA_WIDTH-1:0] ReadData1, ReadData2);

    //寄存器文件
    reg [`DATA_WIDTH-1:0] rf[2 ** ADDR_SIZE-1:0];

    integer i;
    initial begin
        for(i = 0; i <= 31; i = i + 1) rf[i] = 64'h0000_0000_0000_0001;
        rf[15] = 64'h0000_0000_0000_0000;
    end

    //数据写入
    always@(posedge CLK)
        if (RegWrite) rf[Writereg3] <= WriteData3; 

    //数据读出
    assign ReadData1 = (Readreg1 != 31) ? rf[Readreg1] : 0;
    assign ReadData2 = (Readreg2 != 31) ? rf[Readreg2] : 0;
endmodule

// 右移两位
module SL2(
   input [`DATA_WIDTH-1: 0] in,
   output [`DATA_WIDTH-1: 0] out
   );
   assign out = {in[29: 0], 2'b00};
endmodule

// 相加(用于地址转移 和 PC+4)
module Adder(
   input wire [`DATA_WIDTH-1: 0] Op1, Op2,
   output wire [`DATA_WIDTH-1: 0] Out
   );
   assign Out = Op1 + Op2;
endmodule

// 多路选择器
module Mux2 //2选1
    #(parameter WIDTH = 8)
    (input [WIDTH-1:0] d0, d1,
    input select,
    output [WIDTH-1:0] y);

    assign y = select ? d1 : d0;
endmodule

module Mux4 //4选1
    #(parameter WIDTH = 8)
    (input [WIDTH-1:0] d0, d1, d2, d3,
    input [1:0] select,
    output reg [WIDTH-1:0] y);

    always @(*) begin
        case ({select[1], select[0]})
	        2'b00: y = d0;
	        2'b01: y = d1;
	        2'b10: y = d2;
	        2'b11: y = d3;
	        default: y = 2'bz;
	    endcase
    end
    //assign y = select ? d1 : d0;
endmodule

// 符号扩展
module SignExt( 
    input [`DATA_WIDTH/2-1:0] in,   //32位输入
    output reg [`DATA_WIDTH-1:0] out     //64位输出
    );
    always @(in) begin
        case({in[31],in[26]})
            2'b01: out <= { 38'b0, in[25:0] };  // B指令 Branch
            2'b10: out <= { 55'b0, in[20:12] }; // LDUR、STUR指令
            2'b11: out <= { 45'b0, in[23:5] };  // CBZ指令
            default: out <= 64'bz;
        endcase
    end
    //assign out = { {55 {in[20]} } , in[20:12]}; // out = { {32 {in[31]} } , in};
endmodule


// module PCreg(In, Out, EN, CLK); //指令暂存器
//     parameter WIDTH = 32;
//     input [WIDTH-1:0] In;
//     input CLK;
//     input EN;
//     output reg [WIDTH-1:0] Out;
    
//     //reg [WIDTH-1:0] mem; 

//     always@(CLK, EN)
//     begin
//         if(EN) Out <= In;
//     end
// endmodule

//CLK, MemWrite, DataAdr, WriteData, ReadData

// 存储器RAM_4Kx64
module DMem(Data_Write, Data_Out, Addr, MemWrite, MemRead, CLK);
    parameter Addr_Width = 12;  //参数化地址线宽
    parameter Data_Width = `DATA_WIDTH;  //参数化数据线宽
    parameter SIZE = 2 ** Addr_Width; //参数化大小4K
    input [Data_Width-1:0] Data_Write; // 写入的数据
    output [Data_Width-1:0] Data_Out; // 读出的数据
    input [`DATA_WIDTH-1:0] Addr; //地址
    input MemWrite, MemRead;
    //input Rst;  //复位信号
    //input R_W; //1读_0写信号
    //input CS; //使能片选信号
    input CLK; //时钟信号

    reg [Data_Width-1:0] Data_Outtmp;
    assign Data_Out = Data_Outtmp;
    integer i; //临时变量。用于for循环
    reg [Data_Width-1:0] RAM [SIZE-1:0];  //4096*32的RAM

    initial begin
        for(i = 0; 
        i <= SIZE-1; i = i+1) RAM[i] = 64'h1111_1111_1111_1111; // 初始化
    end

    assign Data_Out = (MemRead) ? RAM[Addr] : 64'bz;

    //assign Data = (R_W) ? Data_i:32'bz; //z是高阻态，表示32位二进制高阻态
    always @(posedge CLK) begin //时钟同步
        case({MemWrite, MemRead})
            //4'b01 : Data_Outtmp <= RAM[Addr]; //读数据
            4'b10 : RAM[Addr] <= Data_Write; //写数据
            default: Data_Outtmp <= 64'bz; // 32
        endcase
    end
endmodule

// 指令存储器
module IMem(
    input [63:0] A,  // 地址(PC)64位
    output [31:0] RD); // 指令32位

    parameter IMEM_SIZE = 512; // 最多512条指令
    //指令寄存器
    reg [31:0] RAM[IMEM_SIZE-1:0];
    initial begin
        $readmemh("/home/jinstorm/IMem.txt", RAM);
    end
    assign RD = RAM[A>>2]; //指令输出
endmodule

// 控制单元 主译码器
module MainDec( //主译码器
    input [10:0] Op,
    output MemToReg, MemWrite, MemRead,
    output Branch, ALUSrc,
    output Reg2Loc, RegWrite,
    //output Jump,
    output [1:0] ALUOp
    );
    //MainDec MainDec_1(Opcode, MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUOp);
    reg [8:0] Controls;
    assign {Reg2Loc, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = Controls;

    always@(*)
        casex(Op)
            11'b10001010000: Controls <= 9'b000100010;    //R-format //b10001010000 AND
            11'b10001011000: Controls <= 9'b000100010;    //R-format //b10001010000 ADD
            11'b11001011000: Controls <= 9'b000100010;    //R-format SUB
            
            11'b11111000010: Controls <= 9'bx11110000;    //LDUR
            11'b11111000000: Controls <= 9'b11x001000;    //STUR
            11'b10110100xxx: Controls <= 9'b100000101;    //CBZ (Branch == 1 & Zero == 1)
            11'b000101xxxxx: Controls <= 9'b100000110;    //B
            default:   Controls <= 9'bzzzzzzzzz;
        endcase
endmodule


//控制单元 ALU译码器
module ALUDec( //ALU译码器
    input [10:0] Opcode,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl
    );
    always@(*)
        case(ALUOp)
            2'b00: ALUControl <= 4'b0010; // ADD (LDUR\STUR)
            2'b01: ALUControl <= 4'b0111; // PASSB(CBZ)
            2'b10: 
                begin
                    casex(Opcode)
                        11'b10001010000: ALUControl <= 4'b0000; //AND
                        11'b10101010000: ALUControl <= 4'b0001; //OR
                        11'b10001011000: ALUControl <= 4'b0010; //ADD
                        11'b11001011000: ALUControl <= 4'b0110; //SUB
                        11'b000101xxxxx: ALUControl <= 4'b1110; //B
                        // //11'b00000000000: ALUControl <= 4'b0111; //PASSB ?
                        // 11'b00000000000: ALUControl <= 4'b1100; //NOR ?
                        default: ALUControl <= 4'bzzzz; //???
                    endcase
                end
            default: ALUControl <= 4'bzzzz;
        endcase
endmodule

// 算术逻辑运算单元ALU
module ALU(F, A, B, OP, Zero);
    parameter SIZE = `DATA_WIDTH; //运算位数
    input [3:0] OP; //运算操作
    input [SIZE-1:0] A; //左运算数
    input [SIZE-1:0] B; //右运算数
    //input CLK;
    output [SIZE-1:0] F; //运算结果
    //output CF;      //进借位标志位
    output reg Zero; //0标志位
    reg [SIZE-1:0] F;
    reg C;//, CF;

    parameter ALU_AND = 4'b0000; //opcode:10001010000
    parameter ALU_OR  = 4'b0001; //opcode:10101010000
    parameter ALU_ADD = 4'b0010; //opcode:10001011000 xxxxxxxxxxx
    parameter ALU_SUB = 4'b0110; //opcode:11001011000
    parameter ALU_PASSB = 4'b0111; //opcode:xxxxxxxxxxx
    parameter ALU_Zero = 4'b1110;
    parameter ALU_NOR = 4'b1100; //opcode:

    always@(*)
    begin
        C = 0;
        case(OP)
            ALU_AND: begin F = A & B; end     // 按位与
            ALU_OR: begin F = A | B; end     // 按位或
            ALU_ADD: begin {C, F} = A + B; end  // 加法
            ALU_SUB: begin F = A - B; end  // 减法
            ALU_PASSB: begin F = B; end   // F = B
            ALU_Zero: begin F = 64'h0000_0000_0000_0000; Zero = 1; end
            ALU_NOR: begin F = ~ (A | B); end  // 按位或非
            default: begin F = 64'bz;  end 
        endcase
        if (F == 64'h0000_0000_0000_0000) Zero <= 1; // 32
        else Zero <= 0;
    end
endmodule


// 控制单元
// Controller: Opcode,     MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUControl
module Controller(
    input [10:0] Opcode,
    //input Zero,
    output MemToReg, MemWrite, MemRead,
    output Branch, ALUSrc,
    output Reg2Loc, RegWrite,
    output [3:0] ALUControl
    );
    wire [1:0] ALUOp;
    //wire Branch;
    //主译码器
    MainDec MainDec_1(Opcode, MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUOp);
    //ALU译码器
    ALUDec ALUDec_1(Opcode, ALUOp, ALUControl);
    //assign PCSrc = Branch & Zero;
endmodule

module PCreg(In, Out, PCWrite, CLK); // PC 64位指令地址
    parameter WIDTH = `DATA_WIDTH; //6;
    input [WIDTH-1:0] In;
    input CLK;
    input PCWrite;
    output [WIDTH-1:0] Out;

    reg [WIDTH-1:0] Outtmp;
    assign Out = Outtmp;
    initial begin
        Outtmp = 64'b0;
    end

    always@(posedge CLK)
    begin
        if(PCWrite) Outtmp <= In;
        //if(In != 64'bX) Outtmp <= In;
    end
endmodule

// // 寄存器
// module register(Q, D, OE, CLK);
//     parameter N = 8;
//     output reg [N-1:0] Q; // 输出Q
//     input [N:1] D;
//     input OE, CLK;  //三态输出

//     //CLK，OE边沿敏感触发
//     always @ (posedge CLK or posedge OE)
//         if (OE) Q <= 8'bzzzz_zzzz; // 使能无效输出高阻态
//         else Q <= D;    //存入和读出数据
// endmodule


// Opcode, MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUOp
// 暂存器IF/ID、ID/EX、EX/MEM、MEM/WB
// 寄存器IF/ID
module RegIFID(Q, D, IF_ID_Write, IF_ID_flush, CLK);
    parameter N = 96; // 64PC+32指令
    output reg [N-1:0] Q; // 输出Q(96)
    input [N-1:0] D;  // 输入
    input IF_ID_Write, IF_ID_flush;
    input CLK;

    //CLK边沿敏感触发
    always @ (posedge CLK) begin
        //if (OE) Q <= 8'bzzzz_zzzz; // 使能无效输出高阻态
        //else Q <= D;    //存入和读出数据
        if(IF_ID_Write) Q <= D;     //写入
        if(IF_ID_flush) Q <= 96'b0; //清空
    end
endmodule

// 寄存器RegID/EX
module RegIDEX(RegWrite_o, MemToReg_o, Branch_o, MemRead_o, MemWrite_o, ALUControl_o, ALUSrc_o, PC_o, ReadData1_o, ReadData2_o, Sig_o, Instr_o, 
                CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUControl, ALUSrc, PC, ReadData1, ReadData2, Sigimm, Instr);
    // parameter N = 239; // 2+3+5+32+64+64+64+5
    // output reg [N-1:0] Q; // 输出Q()
    output reg RegWrite_o, MemToReg_o, Branch_o, MemRead_o, MemWrite_o, ALUSrc_o;
    output reg [3:0] ALUControl_o;
    output reg [`DATA_WIDTH-1:0] PC_o;
    output reg [`DATA_WIDTH-1:0] ReadData1_o, ReadData2_o;
    output reg [`DATA_WIDTH-1:0] Instr_o, Sig_o;

    input CLK;
    input RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUSrc;
    input [3:0] ALUControl;
    input [`DATA_WIDTH-1:0] PC;
    input [`DATA_WIDTH-1:0] ReadData1, ReadData2;
    input [`DATA_WIDTH-1:0] Instr, Sigimm;

    //wire [N-1:0] TmpQ;
    //CLK边沿敏感触发
    always @ (posedge CLK)
    begin
        RegWrite_o <= RegWrite;
        MemToReg_o <= MemToReg;
        Branch_o <= Branch;
        MemRead_o <= MemRead;
        MemWrite_o <= MemWrite;
        ALUControl_o <= ALUControl;
        ALUSrc_o <= ALUSrc;
        PC_o <= PC;
        ReadData1_o <= ReadData1;
        ReadData2_o <= ReadData2;
        Sig_o <= Sigimm;
        Instr_o <= Instr;
    end
        //Q <= TmpQ;
    //assign TmpQ = {RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUControl, ALUSrc, PC, ReadData1, ReadData2, Instr};
endmodule


// 寄存器RegEX/MEM
module RegEXMEM(RegWrite_o, MemToReg_o, PCSrc, MemRead_o, MemWrite_o, PC_o, ALUResult_o, ReadData2_o, Instr_o, 
                CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, PC, Zero, ALUResult, ReadData2, Instr);
    // parameter N = 171; // 2+3+32+1+64+64+5
    // output reg [N-1:0] Q; // 输出Q
    output reg RegWrite_o, MemToReg_o, PCSrc, MemRead_o, MemWrite_o;//, Zero_o;
    output reg [`DATA_WIDTH-1:0] PC_o;
    output reg [`DATA_WIDTH-1:0] ALUResult_o, ReadData2_o;
    output reg [4:0] Instr_o;

    input CLK; 
    input RegWrite, MemToReg, Branch, MemRead, MemWrite, Zero;
    input [`DATA_WIDTH-1:0] PC;
    input [`DATA_WIDTH-1:0] ALUResult, ReadData2;
    input [4:0] Instr;

    initial begin
        PCSrc = 0;
    end

    //wire [N-1:0] TmpQ;
    //CLK边沿敏感触发
    always @ (posedge CLK)
    begin
        RegWrite_o <= RegWrite;
        MemToReg_o <= MemToReg;
        //Branch_o <= Branch;
        if((Branch & Zero) == 1'b1) PCSrc <= Branch & Zero;
        else PCSrc <= 0;
        MemRead_o <= MemRead;
        MemWrite_o <= MemWrite;
        //Zero_o <= Zero;
        PC_o <= PC;
        ALUResult_o <= ALUResult;
        ReadData2_o <= ReadData2;
        Instr_o <= Instr;
    end
        //Q <= TmpQ;
    //assign TmpQ = {RegWrite, MemToReg, Branch, MemRead, MemWrite, PC, Zero, ALUResult, ReadData2, Instr};
endmodule


// 寄存器RegMEM/WB
module RegMEMWB(RegWrite_o, MemToReg_o, ALUResult_o, ReadData_o, Instr_o,
                CLK, RegWrite, MemToReg, ReadData, ALUResult, Instr);
    // parameter N = 135; // 2+64+64+5
    // output reg [N-1:0] Q; // 输出Q
    output reg RegWrite_o, MemToReg_o;
    output reg [`DATA_WIDTH-1:0] ALUResult_o, ReadData_o;
    output reg [4:0] Instr_o;

    input CLK;
    input RegWrite, MemToReg;
    input [`DATA_WIDTH-1:0] ALUResult, ReadData;
    input [4:0] Instr;

    //wire [N-1:0] TmpQ;

    //CLK边沿敏感触发
    always @ (posedge CLK)
    begin
        RegWrite_o <= RegWrite;
        MemToReg_o <= MemToReg;
        ALUResult_o <= ALUResult;
        ReadData_o <= ReadData;
        Instr_o <= Instr;
    end
        //Q <= TmpQ;
    //assign TmpQ = {RegWrite, MemToReg, ReadData, ALUResult, Instr};
endmodule


module forwardunit(RegWrite_MEM_WB,RegWrite_EX_MEM,RdAddr_MEM_WB,										
                    RdAddr_EX_MEM,RnAddr_ID_EX,RmAddr_ID_EX,										
                   ForwardA, ForwardB);										
                   										
input RegWrite_EX_MEM,RegWrite_MEM_WB;										
input [4:0] RdAddr_MEM_WB,RdAddr_EX_MEM,RnAddr_ID_EX,RmAddr_ID_EX;										
output reg [1:0] ForwardA, ForwardB;										
    initial begin										
        ForwardA <= 2'b00;										
        ForwardB <= 2'b00;										
    end										
    										
    always @(*) begin										
        ForwardA = 2'b00;										
        ForwardB = 2'b00;										
        //EX HAZARD										
        if(RegWrite_EX_MEM										
            && (RdAddr_EX_MEM != 31)										
            && (RdAddr_EX_MEM == RnAddr_ID_EX)) ForwardA = 2'b10;										
        if(RegWrite_EX_MEM										
                && (RdAddr_EX_MEM != 31)										
                && (RdAddr_EX_MEM == RmAddr_ID_EX)) ForwardB = 2'b10;										
        										
        //MEM HAZARD										
        if(RegWrite_MEM_WB										
            && (RdAddr_MEM_WB != 31)										
            && !(RegWrite_EX_MEM && (RdAddr_EX_MEM != 31)										
                    && (RdAddr_EX_MEM != RnAddr_ID_EX))										
            && (RdAddr_MEM_WB == RnAddr_ID_EX)) ForwardA = 2'b01;										
        if(RegWrite_MEM_WB										
            && (RdAddr_MEM_WB != 31)										
            && !(RegWrite_EX_MEM && (RdAddr_EX_MEM != 31)										
                    && (RdAddr_EX_MEM != RmAddr_ID_EX))										
            && (RdAddr_MEM_WB == RmAddr_ID_EX)) ForwardB = 2'b01;        										
    end										
endmodule


module HazardDetectUnit(MemRead_ID_EX,RdAddr_ID_EX,RnAddr_IF_ID,RmAddr_IF_ID,opcode,					
                        PCWrite,CUStall,IF_IDWrite,ifBranch,resetEXMEM,IF_ID_flush,PCSrc);					
input [4:0] RdAddr_ID_EX,RnAddr_IF_ID,RmAddr_IF_ID;					
input [10:0] opcode;					
input MemRead_ID_EX,ifBranch;					
output reg PCWrite,CUStall,IF_IDWrite,resetEXMEM,IF_ID_flush,PCSrc;					
    initial begin					
        PCWrite <= 1;					
        CUStall <= 0;					
        IF_IDWrite <= 1;					
        resetEXMEM <= 0;					
        IF_ID_flush <= 0;					
        PCSrc <= 0;					
    end					
    always @(*) begin					
        PCWrite = 1;					
        CUStall = 0;					
        IF_IDWrite = 1;    					
        resetEXMEM = 0;					
        IF_ID_flush = 0;       					
        PCSrc = 0; 					
        if (MemRead_ID_EX					
            && (opcode != 1986)					
            && ((RdAddr_ID_EX == RnAddr_IF_ID)					
                || (RdAddr_ID_EX == RmAddr_IF_ID))) begin					
                    $display(RdAddr_ID_EX, RmAddr_IF_ID);					
                    PCWrite <= 0;					
                    CUStall <= 1;					
                    IF_IDWrite <= 0;					
        end      					
        if (ifBranch) begin					
            resetEXMEM <= 1;					
            CUStall <= 1;					
            IF_ID_flush <= 1;					
            PCSrc <= 1;					
        end					
    end					
endmodule	

// 暂存器的输出结构
// parameter N = 38; // 32指令+32PC {PC, Instr}
// parameter N = 213; // 2+3+3+6+32+32+32+11+5 {RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUOp, ALUSrc, PC, ReadData1, ReadData2, Instr}
// parameter N = 81; // 2+3+6+1+32+32+5 {RegWrite, MemToReg, Branch, MemRead, MemWrite, PC, Zero, ALUResult, ReadData2, Instr}
// parameter N = 71; // 2+32+32+5 {RegWrite, MemToReg, ReadData, ALUResult, Instr}

// RegIDEX(RegWrite_o, MemToReg_o, Branch_o, MemRead_o, MemWrite_o, ALUControl_o, ALUSrc_o, PC_o, ReadData1_o, ReadData2_o, Instr_o, 
//                CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUControl, ALUSrc, PC, ReadData1, ReadData2, Instr);
// RegEXMEM(RegWrite_o, MemToReg_o, Branch_o, MemRead_o, MemWrite_o, Zero_o, PC_o, ALUResult_o, ReadData2_o, Instr_o, 
//                CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, PC, Zero, ALUResult, ReadData2, Instr);
// RegMEMWB(RegWrite_o, MemToReg_o, ALUResult_o, ReadData_o, Instr_o,
//                CLK, RegWrite, MemToReg, ReadData, ALUResult, Instr);

// 数据通路
// DataPath(CLK, Instr, ReadData, PC, ALUResult_o, ReadData2_o, MemRead_o2, MemWrite_o2)
module DataPath(
    input CLK,
    //input [`DATA_WIDTH-1:0] PC_1,
    input [31:0] Instr,      // 指令存储器的地址输入
    input [`DATA_WIDTH-1:0] ReadData,   // 存储器读出的数据
    output [`DATA_WIDTH-1:0] PC,    // 下一条指令的地址
    output [`DATA_WIDTH-1:0] ALUResult_o, ReadData2_o2, // ALUResult_o:存储器写入的地址，ReadData2_o： 存储器写入的数据
    output MemRead_o2, MemWrite_o2 // 存储器的读和写的信号
    );

    wire [4:0] WriteReg;
    wire [`DATA_WIDTH-1:0] PCNext, PCNextBr, PCPlus4, PCBranch;
    wire [`DATA_WIDTH-1:0] SignImm, SignImmSh;
    wire [`DATA_WIDTH-1:0] SrcA, SrcB;
    wire [`DATA_WIDTH-1:0] Result;

    //wire [37:0] D;
    wire MemToReg, MemWrite, MemRead, PCSrc, ALUSrc, Reg2Loc, RegWrite, Branch;
    wire Zero;
    wire [3:0] ALUControl;

    // 暂存器
    wire [95:0] Q1; // 64PC+32指令 {PC, Instr}
    // wire [238:0] Q2; // 2+3+5+32+64+64+64+5  {RegWrite, MemToReg, Branch, MemRead, MemWrite,    ALUControl, ALUSrc, ReadData1, ReadData2, Instr}
    // wire [170:0] Q3; // 2+3+32+1+64+64+5  {RegWrite, MemToReg, Branch, MemRead, MemWrite,       PC, Zero, ALUResult, ReadData2, Instr}
    // wire [134:0] Q4; // 2+64+64+5         {RegWrite, MemToReg, ReadData, ALUResult, Instr}
    
    wire RegWrite_o, MemToReg_o, Branch_o1, MemRead_o, MemWrite_o, ALUSrc_o;
    wire [`DATA_WIDTH-1:0] ReadData1, ReadData2, ReadData1_o, ReadData2_o, Sig, Instr_o; //
    wire [3:0] ALUControl_o;
    wire [`DATA_WIDTH-1:0] PC_o;

    wire [`DATA_WIDTH-1:0] PC_EXMEM, PC_EXMEM_o;
    wire RegWrite_oEX, MemToReg_o2, Branch_o2, Zero_o; // MemRead_o2， MemWrite_o2
    wire [`DATA_WIDTH-1:0] ALUResult, Instr_o2; // ALUResult_o  ReadData2_o2

    wire RegWrite_o3, MemToReg_o3;
    wire [`DATA_WIDTH-1:0] ALUResult_o3, ReadData_o, Instr_o3;

    wire PCWrite,IF_ID_Write,CUStall,resetEXMEM,IF_ID_flush,ifBranch;
    wire [10:0] CU_o, mux_CUStall_o;

    // wire [1:0] WB_C,WB_EX,WB_MEM;
    // //Rn和Rm在EX阶段地址线
    // wire [4:0] RnAddr_EX,RmAddr_EX;
    // //写回地址（Rt(sdur指令）和Rd的地址）
    // wire [4:0] wb_addr_EX,wb_addr_MEM,wb_addr_WB;
    //forwarding选择信号
    wire [1:0] fwdA,fwdB;
    wire [`DATA_WIDTH-1:0] ALU_op1, fwdB_out;
    wire [4:0] mux_resetEXMEM_o;

    Mux2 mux_resetEXMEM({RegWrite_o, MemToReg_o, Branch_o1, MemRead_o, MemWrite_o}, 5'b0, resetEXMEM, mux_resetEXMEM_o);

    // Controller: Opcode,     MemToReg, MemWrite, MemRead, PCSrc, ALUSrc, Reg2Loc, RegWrite, ALUControl
    
    // 暂存寄存器IF/ID、ID/EX、EX/MEM、MEM/WB:
    RegIFID RegIFID_1(Q1, {PC, Instr}, IF_ID_Write, IF_ID_flush, CLK); //RegIFID(Q, D, CLK);
    Controller Controller_1(Q1[31:21], MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUControl);// Controller Controller_1(Instr[31:21], MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUControl);

    // RegIDEX RegIDEX_1(Q2, CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUOp, ALUSrc, Q1[37:34], SrcA, WriteData, Q1[4:0]);//RegIDEX RegIDEX_1(Q2, CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUOp, ALUSrc, PC, SrcA, WriteData, Instr[4:0]);
    RegIDEX RegIDEX_1(RegWrite_o, MemToReg_o, Branch_o1, MemRead_o, MemWrite_o, ALUControl_o, ALUSrc_o, PC_o, ReadData1_o, ReadData2_o, Sig, Instr_o, 
                CLK, mux_CUStall_o[4:4], mux_CUStall_o[10:10], mux_CUStall_o[7:7], mux_CUStall_o[8:8], mux_CUStall_o[9:9], mux_CUStall_o[3:0], mux_CUStall_o[6:6], Q1[95:32], ReadData1, ReadData2, SignImm, Q1[31:0]); // 完成

    // RegEXMEM RegEXMEM_1(Q3, CLK, RegWrite, MemToReg, Branch, MemRead, MemWrite, PC, Zero, ALUOut, WriteData, Instr[4:0]);
    RegEXMEM RegEXMEM_1(RegWrite_oEX, MemToReg_o2, ifBranch, MemRead_o2, MemWrite_o2, PC_EXMEM_o, ALUResult_o, ReadData2_o2, Instr_o2[4:0], 
                CLK, mux_resetEXMEM_o[4:4], mux_resetEXMEM_o[3:3], mux_resetEXMEM_o[2:2], mux_resetEXMEM_o[1:1], mux_resetEXMEM_o[0:0], PC_EXMEM, Zero, ALUResult, fwdB_out, Instr_o[4:0]);//ReadData2_o, Instr_o[4:0]);
    
    // RegMEMWB RegMEMWB_1(Q4, CLK, RegWrite, MemToReg, ReadData, ALUOut, Instr[4:0]);
    RegMEMWB RegMEMWB_1(RegWrite_o3, MemToReg_o3, ALUResult_o3, ReadData_o, Instr_o3[4:0],
                CLK, RegWrite_oEX, MemToReg_o2, ReadData, ALUResult_o, Instr_o2[4:0]);

    //assign PCSrc = Branch_o2 & Zero_o;
    //                                                                              [4:4]       [3:0]
    Mux2 #(11) mux_CUStall({MemToReg, MemWrite, MemRead, Branch, ALUSrc, Reg2Loc, RegWrite, ALUControl}, 8'b0, CUStall, mux_CUStall_o);
    HazardDetectUnit hdu(MemRead_o, Instr_o[4:0], Q1[9:5], Q1[20:16], Q1[31:21],
                    PCWrite, CUStall, IF_ID_Write, ifBranch, resetEXMEM, IF_ID_flush, PCSrc);



    //IMem IMem_1(PCreg, Instr);
    forwardunit fwdu(RegWrite_o3, RegWrite_oEX, Instr_o3[4:0], Instr_o2[4:0], Instr_o[9:5], Instr_o[20:16], fwdA, fwdB); // RnAddr_EX, RmAddr_EX, fwdA, fwdB);
    // module Mux4 //4选1
    // #(parameter WIDTH = 8)
    // (input [WIDTH-1:0] d0, d1, d2, d3,
    // input [1:0] select,
    // output reg [WIDTH-1:0] y);
    
    
    // Mux4 的选择信号00 01 10 11
    Mux4 #(64)  ALU_A_Mux4(ReadData1_o, Result, ALUResult_o, 64'bx, fwdA, ALU_op1);
    Mux4 #(64)  ALU_B_Mux4(ReadData2_o, Result, ALUResult_o, 64'bx, fwdB, fwdB_out);


    // next PC wire
    PCreg       PCReg(PCNext, PC, PCWrite, CLK); // PC暂存器   // PCreg #(64) PCReg(PCNext, PC, CLK); // PC暂存器
    Adder       PCadd_1(PC, 64'b100, PCPlus4); // PC+4
    SL2         ImmSh(Sig, SignImmSh); // SL2         ImmSh(SignImm, SignImmSh);  // 符号扩展后左移2位
    Adder       PCadd_2(PC_o, SignImmSh, PC_EXMEM); // PC和左移结果相加?(还是PC+4)
    // Mux2 #(32)  PCBrMux(PCPlus4, PCBranch, PCSrc, PCNextBr);
    Mux2 #(64)  PCMux(PCPlus4, PC_EXMEM_o, PCSrc, PCNext);    // 0选第一个操作数，1选第二个操作数

    // register file wire
                //RegFile:CLK, RegWrite, Readreg1, Readreg2, Writereg3, WriteData3, ReadData1, ReadData2
    RegFile     RegFile_1(CLK, RegWrite_o3, Q1[9:5], WriteReg, Instr_o3[4:0], Result, ReadData1, ReadData2); // RegFile     RegFile_1(CLK, RegWrite, Instr[9:5], WriteReg, Instr[4:0], Result, SrcA, WriteData);

    Mux2 #(5)   WRMux(Q1[20:16], Q1[4:0], mux_CUStall_o[5:5], WriteReg); // RegFile输入端的多路选择器
    Mux2 #(64)  ResMux(ALUResult_o3, ReadData_o, MemToReg_o3, Result); // Memory输出端的多路选择
    SignExt     SignExt_1(Q1[31:0], SignImm);

    // ALU wire 
    //???????????????SrcBMux的选择信号1和0
    Mux2 #(64)  SrcBMux(fwdB_out, Sig, ALUSrc_o, SrcB); // 符号扩展和寄存器组 ReadData2 二选一
    ALU         ALU(ALUResult, ALU_op1, SrcB, ALUControl_o, Zero); // ALU(F, A, B, OP, Zero)
endmodule

// ///////////
// // ARM处理器
// module CPU_ARM(
//     input CLK, Reset,
//     output [`ADDR_WIDTH-1:0] PC,
//     input [`DATA_WIDTH-1:0] Instr, //指令
//     output MemWrite, MemRead,  //存储器写控制信号
//     output [`ADDR_WIDTH-1:0] ALUOut, //ALU结果输出
//     output [`DATA_WIDTH-1:0] WriteData, //数据写出
//     input [`DATA_WIDTH-1:0] ReadData); //数据读入

//     wire MemToReg, ALUSrc, Reg2Loc, RegWrite, PCSrc, Zero;
//     wire [2:0] ALUControl;
//     //控制器
//     // Opcode, Zero, MemToReg, MemWrite, MemRead, PCSrc, ALUSrc, Reg2Loc, RegWrite, ALUControl
//     Controller Controller_1(Instr[31:21], Zero, MemToReg, MemWrite, MemRead, PCSrc, ALUSrc, Reg2Loc, RegWrite, ALUControl);
//     //数据通路
//     // CLK, MemToReg, PCSrc, ALUSrc, Reg2Loc, RegWrite, ALUControl,   Zero, PC, Instr, ALUOut, WriteData, ReadData
//     DataPath DataPath_1(CLK, MemToReg, PCSrc, ALUSrc, Reg2Loc, RegWrite, ALUControl, Zero, PC, Instr, ALUOut, WriteData, ReadData);
// endmodule

module ARM_CPU_pipeline(
    input CLK,   //时钟信号
    output wire [`DATA_WIDTH-1:0] WriteData, //数据写入
    output [`DATA_WIDTH-1:0] DataAdr,  //数据地址
    output MemWrite, MemRead);

    wire [`DATA_WIDTH-1:0] PC; //PC
    wire [31:0] Instr; //指令
    wire [`DATA_WIDTH-1:0] ReadData; //数据读出
    reg [`DATA_WIDTH-1:0] PCreg, PCreg2;

    initial begin
        PCreg <= 64'b0;
    end
    //assign PC = PCreg;
    //assign PCtmp = PC;

    //实例化存储器和存储器
    //DataPath DataPath_1(CLK, MemToReg, PCSrc, ALUSrc, Reg2Loc, RegWrite, ALUControl, Zero, PC, Instr, ALUOut, WriteData, ReadData);
    //DataPath(CLK, Instr, ReadData, PC, ALUResult_o, ReadData2_o, MemRead_o2, MemWrite_o2)
    DataPath DataPath_1(CLK, Instr, ReadData, PC, DataAdr, WriteData, MemRead, MemWrite);
    IMem IMem_1(PC, Instr);
    DMem DMem_1(WriteData, ReadData, DataAdr, MemWrite, MemRead, CLK);  
    // DMem(Data_Write, Data_Out, Addr, MemWrite, MemRead, CLK);
endmodule



// // 带指令存储器、数据存储器的 ARM CPU
// module CPU_ARM_IMem_DMem(
//     input CLK, Reset,   //时钟信号，复位信号
//     output [`DATA_WIDTH-1:0] WriteData, //数据写出
//     output [`DATA_WIDTH-1:0] DataAdr,  //数据地址
//     output MemWrite, MemRead);
    
//     wire [`DATA_WIDTH-1:0] PC; //PC
//     wire [`DATA_WIDTH-1:0] Instr; //指令
//     wire [`DATA_WIDTH-1:0] ReadData; //数据读入

//     //实例化存储器和存储器
//     CPU_ARM CPU_ARM_1(CLK, Reset, PC, Instr, MemWrite, MemRead, DataAdr, WriteData, ReadData);
//     IMem IMem_1(PC, Instr);
//     DMem DMem_1(WriteData, ReadData, DataAdr, MemWrite, MemRead, CLK);
//     //DMem: Data_Write, Data_Out, Addr, MemWrite, MemRead, CLK
// endmodule