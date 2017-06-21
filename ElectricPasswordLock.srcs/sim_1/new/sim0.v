`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/20 16:53:05
// Design Name: 
// Module Name: sim0
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


module sim0();
    reg [7:0] in;
    wire green,red,alarm;
    wire [7:0] out1,out2,sel;
    Lock l(out1,out2,sel,green,red,alarm,in);
    initial
    begin
        in=0;
        //input wrong
        #10000000 in[2]=1;
        #10000000 in[2]=0;
        #10000000 in[0]=1;
        #10000000 in[0]=0;
        //wait
        //alarm
        //reinput
        #47000000000
        in[0]=1;
        #5000000 in[0]=0;
        #5000000 in[0]=1;
        #5000000 in[0]=0;
        #5000000 in[0]=1;
        #5000000 in[0]=0;
        #5000000 in[0]=1;
        #5000000 in[0]=0;
    end
endmodule
