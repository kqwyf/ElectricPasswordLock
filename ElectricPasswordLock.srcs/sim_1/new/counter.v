`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/18 19:55:36
// Design Name: 
// Module Name: counter
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


module counter();
  reg clk;
  wire ccc;
  wire [3:0] n;
  initial clk=0;
  assign ccc=clk;
  always #10 clk=~clk;
  qwer a(n[0],n[1],n[2],n[3],ccc);
endmodule
