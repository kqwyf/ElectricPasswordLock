`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/19 15:05:49
// Design Name: 
// Module Name: Lock
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


module Lock(out1,out2,sel,green,red,in);
    input [7:0] in;
    output [7:0] out1,out2,sel;
    output green,red;
    assign out2=out1;
    reg [2:0] step;
    reg [5:0] times;
    reg [13:0] left;
    reg r_green,clk;
    initial
    begin
        step<=0;
        times<=0;
        left<=4999;
        r_green<=0;
        clk=0;
        forever #1000000 clk=~clk; //时钟
    end
    
    //调用显示模块
    display d(8'b10000011,
              left/1000+1,
              0,0,0,0,0,
              times/10,
              times%10);
    
    //信号灯控制
    assign red=~r_green;
    assign green=r_green;
    
    //时序逻辑
    always @(posedge clk)
    begin
        
    end
endmodule