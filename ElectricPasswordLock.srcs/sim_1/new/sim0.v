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
    wire [7:0] w_in;
    wire green,red;
    assign w_in=in;
    Lock l(w_in,green,red);
    initial
    begin
        in=0;
        #10 in[0]=1;
        #10 in[0]=0;
        #10 in[0]=1;
        #10 in[0]=0;
        #10 in[0]=1;
        #10 in[0]=0;
        #10 in[0]=1;
        #10 in[0]=0;
    end
endmodule
