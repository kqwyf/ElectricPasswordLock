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


module Lock(out1,out2,sel,green,red,alarm,in);
    input [7:0] in;
    output [7:0] out1,out2,sel,alarm;
    output green,red;
    assign out2=out1;
    reg [2:0] step;
    reg [5:0] times;
    reg [13:0] left;
    reg [7:0] last;
    reg [2:0] p [3:0];//密码
    reg r_green,clk;
    
    reg inputing,changing,waiting,timing,alarming;
    assign alarm=alarming;
    assign out1=left/500;
    
    initial
    begin
        step<=0;
        times<=0;
        left<=2999;
        r_green<=0;
        
        inputing<=0;
        changing<=0;
        waiting<=0;
        timing<=0;
        alarming<=0;
        
        p[0]<=0;//初始密码
        p[1]<=0;
        p[2]<=0;
        p[3]<=0;
        
        last<=in;
        
        clk=0;
    end
    
    //时钟
    always #1000000 clk=~clk;
    
    //调用显示模块
    /*display d(8'b10000011,
              left/1000+1,
              0,0,0,0,0,
              times/10,
              times%10);*/
    
    //信号控制
    assign red=~r_green;
    assign green=r_green;
    assign alarm=alarming;
    
    //时序逻辑
    always @(posedge clk)
    begin
        if(timing) left=left-1;
        if(changing&&times==4) //修改密码完毕
        begin
            $display("changing finished.");
            r_green<=0;
            times=0;
            inputing<=0;
            changing<=0;
        end
        else if(inputing&&step==4) //输入密码正确
        begin
            $display("password right.");
            alarming<=0;
            r_green<=1;
            times=0;
            step=0;
            waiting=1;
            left=2999;
        end
        else if(in>last)
        begin
            if(!inputing)
            begin
                $display("start input.");
                timing<=1;
                left=2999;
                inputing<=1;
            end
            if(in[0]&&!last[0])
            begin
                if(waiting)
                begin
                    $display("changing start.");
                    changing=1;
                    waiting=0;
                    times=0;
                    left=0;
                    timing=0;
                end
                else
                begin
                    if(changing) p[times]=0;
                    else if(p[step]==0) step=step+1;
                    times<=times+1;
                end
            end
            else if(in[1]&&!last[1])
            begin
                if(changing) p[times]=1;
                else if(p[step]==1) step<=step+1;
                times<=times+1;
            end
            else if(in[2]&&!last[2])
            begin
                if(changing) p[times]=2;
                else if(p[step]==2) step<=step+1;
                times<=times+1;
            end
            else if(in[3]&&!last[3])
            begin
                if(changing) p[times]=3;
                else if(p[step]==3) step<=step+1;
                times<=times+1;
            end
            else if(in[4]&&!last[4])
            begin
                if(changing) p[times]=4;
                else if(p[step]==4) step<=step+1;
                times<=times+1;
            end
            else if(in[5]&&!last[5])
            begin
                if(changing) p[times]=5;
                else if(p[step]==5) step<=step+1;
                times<=times+1;
            end
            else if(in[6]&&!last[6])
            begin
                if(changing) p[times]=6;
                else if(p[step]==6) step<=step+1;
                times<=times+1;
            end
            else if(in[7]&&!last[7])
            begin
                if(changing) p[times]=7;
                else if(p[step]==7) step<=step+1;
                times<=times+1;
            end
        end
        last=in;
        if(timing&&left<500)
        begin
            if(waiting) //不修改密码
            begin
                $display("changing cancelled.");
                r_green<=0;
                waiting<=0;
                timing<=0;
                inputing<=0;
                times<=0;
            end
            else if(inputing) //输入密码超时
            begin
                $display("password timeout.");
                alarming<=1;
                inputing<=0;
                timing<=0;
                times<=0;
                step<=0;
                r_green<=0;
            end
        end
    end
endmodule