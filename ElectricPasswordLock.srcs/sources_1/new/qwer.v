`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/18 19:19:54
// Design Name: 
// Module Name: qwer
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


module qwer(n0,n1,n2,n3,clk);
    input clk;
    output n0,n1,n2,n3;
    reg [3:0] number;
    initial number=0;
    always @(posedge clk)
    begin
        if(number<2)
            number=number+1;
    end
    assign n0=number[0];
    assign n1=number[1];
    assign n2=number[2];
    assign n3=number[3];
endmodule;
