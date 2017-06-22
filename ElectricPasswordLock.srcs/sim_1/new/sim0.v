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
    wire [7:0] w_in,w_out1,w_out2,sel;
    wire green,red,alarm;
    assign w_in=in;
    Lock l(w_out1,w_out2,sel,green,red,alarm,w_in);
    initial
    begin
        in=0;
        #10000000 in[0]=1;
        #10000000 in[0]=0;
        #10000000 in[0]=1;
        #10000000 in[0]=0;
        #10000000 in[0]=1;
        #10000000 in[0]=0;
        #10000000 in[0]=1;
        #10000000 in[0]=0;
    end
endmodule
