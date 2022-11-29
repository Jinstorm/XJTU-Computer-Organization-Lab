    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 2021/11/07 17:33:18
    // Design Name: 
    // Module Name: D_ff
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


    module D_ff(Q, QN, D, EN, RST, CLK); //锁存器
        output reg Q, QN; // 状态信号Q，～Q
        input D;    // 激励信号
        input EN, RST, CLK;  //使能信号EN， 复位信号RST， 时钟信号CLK

        // 边沿敏感
        always @(posedge CLK) begin // 同步复位
        //always @ (posedge CLK, posedge RST) begin // 复位与CLK无关，异步复位
            if(RST) begin Q <= 1'b0; QN <= 1'b1; end
            else if(EN) begin Q <= D; QN <= ~D; end
        end
    endmodule
