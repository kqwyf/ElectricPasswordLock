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


module Lock(in,green,red);
    input [7:0] in;
    output green,red;
    reg green,red;
    wire start,stop,change;
    reg [2:0] p[1:0];
    reg [1:0] step;
    reg [7:0] has;
    reg [5:0] times;
    reg r_start,r_change;
    initial
    begin
        r_start=0;
        r_change=0;
        step=0;
        has=8'b00000001;
        times=0;
        p[0]=0;
        p[1]=0;
        p[2]=0;
        p[3]=0;
        red=1;
        green=0;
    end
    
    //倒计时芯片
    assign start=r_start;
    assign change=r_change;
    Timeout timer(start,change,stop);
    
    //当输入时开始计时
    always @(posedge in)
        r_start=1;
    
    //判断输入
    always @(posedge in[0])
        if(step==4) 
        else if(has[0]&&p[step]==0) step=step+1;
    always @(posedge in[1])
        if(has[1]&&p[step]==0) step=step+1;
    always @(posedge in[2])
        if(has[2]&&p[step]==0) step=step+1;
    always @(posedge in[3])
        if(has[3]&&p[step]==0) step=step+1;
    always @(posedge in[4])
        if(has[4]&&p[step]==0) step=step+1;
    always @(posedge in[5])
        if(has[5]&&p[step]==0) step=step+1;
    always @(posedge in[6])
        if(has[6]&&p[step]==0) step=step+1;
    always @(posedge in[7])
        if(has[7]&&p[step]==0) step=step+1;
    
    always @(step)
        if(step==4)
        begin
            green=1;
            red=0;
        end
    
    //倒计时结束
    always @(stop)
    begin
        if(stop==1)
        begin
            r_start=0;
            r_change=0;
            step=0;
            has=8'b00000001;
            times=0;
            p[0]=0;
            p[1]=0;
            p[2]=0;
            p[3]=0;
            red=1;
            green=0;
        end
    end
        
endmodule
module Timeout(start,change,stop);
    input start,change;
    output stop;
endmodule