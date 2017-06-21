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
    reg [2:0] p [1:0];//密码
    reg r_green,clk;
    
    reg inputing,changing,waiting,timing,alarming;
    assign alarm=alarming;
    
    initial
    begin
        step<=0;
        times<=0;
        left<=4999;
        r_green<=0;
        
        inputing<=0;
        changing<=0;
        waiting<=0;
        timing<=0;
        
        p[0]<=0;//初始密码
        p[1]<=0;
        p[2]<=0;
        p[3]<=0;
        
        last=in;
        
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
        if(timing) left=left-1;
        if(changing&&times==4) //修改密码完毕
        begin
            r_green<=0;
            times<=0;
            inputing<=0;
            changing<=0;
        end
        else if(waiting) //确认是否修改
        begin
            if(in!=last) //按任意键
            begin
                changing<=1;
                times<=0;
                left<=0;
                timing=0;
            end
        end
        else if(inputing&&step==4) //输入密码正确
        begin
            alarming<=0;
            r_green<=1;
            times<=0;
            step<=0;
            waiting<=1;
            left<=4999;
        end
        else if(in!=last)
        begin
            if(!inputing)
            begin
                timing<=1;
                inputing<=1;
            end
            if(in[0]!=last[0])
            begin
                if(changing) p[times]=0;
                else if(p[step]==0) step<=step+1;
            end
            else if(in[i]!=last[i])
            begin
                if(changing) p[times]=i;
                else if(p[step]==i) step<=step+1;
            end
            times<=times+1;
            last=in;
        end
        if(timing&&left==0)
        begin
            if(waiting)
            begin
                r_green<=0;
                waiting<=0;
                timing<=0;
                inputing<=0;
                times<=0;
            end
            else if(inputing)
            begin
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