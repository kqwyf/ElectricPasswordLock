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
    wire w_start,stop,w_changing;
    reg [2:0] p[1:0];
    reg [2:0] step;
    reg [7:0] has;
    reg [5:0] times;
    reg start,changing;
    initial
    begin
        start<=0;
        step<=0;
        changing<=0;
        has<=8'b00000001;
        times<=0;
        p[0]<=0;
        p[1]<=0;
        p[2]<=0;
        p[3]<=0;
        red<=1;
        green<=0;
    end
    
    //倒计时芯片
    assign w_start=start;
    Timeoutt timer(w_start,stop);
    
    always @(green) red=!green;
    
    //判断输入，验证或修改密码
    always @(in,stop)
    begin
    if(start&&stop)
    begin
        start<=0;
        green<=0;
        $display("stop timing. password wrong.");
    end
    else
    if(!start)
    begin
        step<=0;
        times<=0;
        start<=1;
        $display("start timing.");
    end
    if(in[0])
    begin
        if(changing)
        begin
            p[times]<=0;
            has[0]=1;
            times<=times+1;
            $display("get a new password char.");
        end
        else if(step==4)//判断是否要修改密码
        begin
            step<=0;
            start<=0;
            changing<=1;
            #1 start=1;
        end
        else if(has[0]&&p[step]==0)
        begin
            $display("get a zero.");
            step<=step+1;
        end
    end
    else if(in[1])
    begin
        if(changing)
        begin
            p[times]<=1;
            has[1]=1;
            times<=times+1;
        end
        else if(has[1]&&p[step]==0) step<=step+1;
    end
    else if(in[2])
    begin
        if(changing)
        begin
            p[times]<=2;
            has[2]=1;
            times<=times+1;
        end
        else if(has[2]&&p[step]==0) step<=step+1;
    end
    else if(in[3])
    begin
        if(changing)
        begin
            p[times]<=3;
            has[3]=1;
            times<=times+1;
        end
        else if(has[3]&&p[step]==0) step<=step+1;
    end
    else if(in[4])
    begin
        if(changing)
        begin
            p[times]<=4;
            has[4]=1;
            times<=times+1;
        end
        else if(has[4]&&p[step]==0) step<=step+1;
    end
    else if(in[5])
    begin
        if(changing)
        begin
            p[times]<=5;
            has[5]=1;
            times<=times+1;
        end
        else if(has[5]&&p[step]==0) step<=step+1;
    end
    else if(in[6])
    begin
        if(changing)
        begin
            p[times]<=6;
            has[6]=1;
            times<=times+1;
        end
        else if(has[6]&&p[step]==0) step<=step+1;
    end
    else if(in[7])
    begin
        if(changing)
        begin
            p[times]<=7;
            has[7]=1;
            times<=times+1;
        end
        else if(has[7]&&p[step]==0) step<=step+1;
    end
    if(step==0&&times==4)
    begin
        start<=0;
        times<=0;
        changing<=0;
        green<=0;
        $display("new password finished.");
    end
    else if(step==4)
    begin
        start<=0;
        times<=0;
        green<=1;
        #1 start=1;
        $display("password right.");
    end
    end
endmodule

module Timeoutt(start,stop);
    input start;
    output stop;
    reg [2:0] counttime;
    reg [3:0] cnt;
    reg [3:0] cur;
    reg flag;
    initial flag=0;
    initial cnt=10;
    initial counttime=0;
    assign stop=!flag;
    always #100000000
    begin
        if(flag==1)
        begin
            if(counttime==0) counttime=5;
            if(cnt==cur)
            begin
                counttime<=counttime-1;
                if(counttime==0)
                    flag<=0;
            end
        end
        cnt=(cnt-1==0?cnt-1:10);
    end
    always @(start)
    begin
        flag=start;
        cur=cnt;
    end
endmodule