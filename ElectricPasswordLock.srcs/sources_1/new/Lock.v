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
    wire start,stop,change,reset,changing;
    reg [2:0] p[1:0];
    reg [1:0] step;
    reg [7:0] has;
    reg [5:0] times;
    reg r_start,r_change,r_reset;
    initial
    begin
        r_start=0;
        r_change=0;
        r_reset=0;
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
    
    assign changing=r_reset&&r_change;
    
    //倒计时芯片
    assign start=r_start;
    assign change=r_change;
    assign reset=r_reset;
    Timeout timer(start,change,reset,stop);
    
    //当输入时开始计时
    always @(posedge in)
    begin
        times=times+1;
        r_start=1;
    end
    
    //判断输入，验证或修改密码
    always @(posedge in[0])
        if(changing)
        begin
            p[times]=0;
            times=times+1;
        end
        else if(step==4) r_reset=1; //判断是否要修改密码
        else if(has[0]&&p[step]==0) step=step+1;
    always @(posedge in[1])
        if(changing)
        begin
            p[times]=1;
            times=times+1;
        end
        else if(has[1]&&p[step]==0) step=step+1;
    always @(posedge in[2])
        if(changing)
        begin
            p[times]=2;
            times=times+1;
        end
        else if(has[2]&&p[step]==0) step=step+1;
    always @(posedge in[3])
        if(changing)
        begin
            p[times]=3;
            times=times+1;
        end
        else if(has[3]&&p[step]==0) step=step+1;
    always @(posedge in[4])
        if(changing)
        begin
            p[times]=4;
            times=times+1;
        end
        else if(has[4]&&p[step]==0) step=step+1;
    always @(posedge in[5])
        if(changing)
        begin
            p[times]=5;
            times=times+1;
        end
        else if(has[5]&&p[step]==0) step=step+1;
    always @(posedge in[6])
        if(changing)
        begin
            p[times]=6;
            times=times+1;
        end
        else if(has[6]&&p[step]==0) step=step+1;
    always @(posedge in[7])
        if(changing)
        begin
            p[times]=7;
            times=times+1;
        end
        else if(has[7]&&p[step]==0) step=step+1;
    
    //判断密码输入是否结束
    always @(step)
        if(step==4) r_reset=1;
    
    //判断修改密码是否结束
    always @(times)
        if(times==4)
        begin
            r_start<=0;
            r_change<=0;
            r_reset<=0;
            times<=0;
            red<=1;
            green<=0;
        end
    
    //倒计时结束
    always @(posedge stop)
    begin
        if(changing);
        else if(step==4) r_change<=1;
        else r_change<=0;
        step<=0;
        times<=0;
        r_start<=0;
        r_reset<=0;
        if(step==4) red<=0;
        else red<=1;
        green<=~red;
    end
endmodule

module Timeoutt(start,change,reset,stop);
    input start;
    input change;
    input reset;
    output stop;
    reg flag;
    initial flag=0;
    reg[2:0] counttime;
    initial {counttime[0],counttime[1],counttime[2]}= 3'b101;
    always @ (posedge reset)
    begin
        flag=0;
    end
    assign stop=~flag;
    always @ (posedge start)
    begin
        flag=1;
        counttime=3'b101;
    end
    always #1000000000
    begin
      if(flag==1)
      begin
        counttime=counttime-1;
        if(counttime==0)
            flag=0;
       end
    end
    always @ (posedge change) 
    begin
        flag=1;
        counttime=3'b101;
    end
    always  #1000000000
    begin
       if(flag==1)
       begin
         counttime=counttime-1;
         if(counttime==0)
             flag=0;
       end
    end 

endmodule