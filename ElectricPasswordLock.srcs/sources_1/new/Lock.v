`timescale 1ns / 1ns
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

module translator(w_in,w_out);
    input [3:0] w_in;
    output [7:0] w_out;
    reg [7:0] out;
  
    assign w_out=out;
    always @(w_in)
        if(w_in==0)
            out=8'b11111100;
        else if(w_in==1)
            out=8'b01100000;
        else if(w_in==2)
            out=8'b11011010;
        else if(w_in==3)
            out=8'b11110010;
        else if(w_in==4)
            out=8'b01100110;
        else if(w_in==5)
            out=8'b10110110;
        else if(w_in==6)
            out=8'b10111110;  
        else if(w_in==7)
            out=8'b11100000; 
        else if(w_in==8)
            out=8'b11111111;
        else if(w_in==9)
            out=8'b11110111;
endmodule

module display(clk,enable,number0,number1,number2,number3,number4,number5,number6,number7,w_out,w_sel);
    input [7:0] enable;
    input clk;
    input [3:0] number0,number1,number2,number3,number4,number5,number6,number7;
    output [7:0] w_out,w_sel;
    reg [2:0] i;
    reg [3:0] source;
    reg [7:0] sel;
    assign w_sel=sel;
    initial i=0;
    initial sel=0;
    initial source=0;
    translator t(source,w_out);
    always @(posedge clk)
    begin
        sel=8'b00000000;
        sel[i]=enable[i];
        if(i==0)
            source=number0;
        else if(i==1)
            source=number1;
        else if(i==2)
            source=number2;
        else if(i==3)
            source=number3;
        else if(i==4)
            source=number4;
        else if(i==5)
            source=number5;
        else if(i==6)
            source=number6;
        else if(i==7)
            source=number7;
        i=i+1;
    end
endmodule

module Lock(out1,out2,sel,green,red,alarm,in,CK);
    input [7:0] in;
    input CK;
    output [7:0] out1,out2,sel;
    output green,red,alarm;
    assign out2=out1;
    reg [2:0] step=0;
    reg [17:0] CKn=0;
    reg [3:0] times1,times0;
    reg [9:0] left=500;
    reg [3:0] lefttime=5;
    reg [7:0] last;
    reg [2:0] p [3:0];//密码
    reg r_green=0,clk,init=0;
    wire [3:0] w_times0,w_times1;
    assign w_times0=times0;
    assign w_times1=times1;
    
    reg inputing=0,changing=0,waiting=0,timing=0,alarming=0;
    assign alarm=alarming;
    
    //时钟
    always @(posedge CK)
    begin
        CKn=CKn+1;
        if(CK==100000)
        begin
            CKn=0;
            clk=~clk;
        end
    end
    
    //调用显示模块
    display d(clk,
              8'b10000011,
              lefttime,
              0,0,0,0,0,
              w_times1,
              w_times0,
              out1,sel);
    
    //信号控制
    assign red=~r_green;
    assign green=r_green;
    assign alarm=alarming;
    
    //时序逻辑
    always @(posedge clk)
    begin
        if(!init)
        begin
            init=1;
            p[0]=0;
            p[1]=0;
            p[2]=0;
            p[3]=0;
            last=in;
        end
        if(timing)
        begin
            left=left-1;
            if(left==0)
            begin
                lefttime=lefttime-1;
                left=500;
            end
        end
        if(changing&&times0==4) //修改密码完毕
        begin
            $display("changing finished.");
            r_green<=0;
            times0=0;
            times1=0;
            inputing<=0;
            changing<=0;
        end
        else if(inputing&&step==4) //输入密码正确
        begin
            $display("password right.");
            alarming<=0;
            r_green<=1;
            times0=0;
            times1=0;
            step=0;
            waiting=1;
            lefttime=5;
            left=500;
        end
        else if(in>last)
        begin
            if(!inputing)
            begin
                $display("start input.");
                timing<=1;
                lefttime<=5;
                left=500;
                inputing<=1;
            end
            if(in[0]&&!last[0])
            begin
                if(waiting)
                begin
                    $display("changing start.");
                    changing=1;
                    waiting=0;
                    times0=0;
                    times1=0;
                    lefttime=0;
                    timing=0;
                end
                else
                begin
                    if(changing) p[times0]=0;
                    else if(p[step]==0) step=step+1;
                    if(times0<9) times0<=times0+1;
                    else
                    begin
                        times0=0;
                        times1=times1+1;
                    end
                end
            end
            else if(in[1]&&!last[1])
            begin
                if(changing) p[times0]=1;
                else if(p[step]==1) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
            else if(in[2]&&!last[2])
            begin
                if(changing) p[times0]=2;
                else if(p[step]==2) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
            else if(in[3]&&!last[3])
            begin
                if(changing) p[times0]=3;
                else if(p[step]==3) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
            else if(in[4]&&!last[4])
            begin
                if(changing) p[times0]=4;
                else if(p[step]==4) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
            else if(in[5]&&!last[5])
            begin
                if(changing) p[times0]=5;
                else if(p[step]==5) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
            else if(in[6]&&!last[6])
            begin
                if(changing) p[times0]=6;
                else if(p[step]==6) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
            else if(in[7]&&!last[7])
            begin
                if(changing) p[times0]=7;
                else if(p[step]==7) step<=step+1;
                if(times0<9) times0<=times0+1;
                else
                begin
                    times0=0;
                    times1=times1+1;
                end
            end
        end
        last=in;
        if(timing&&lefttime==0)
        begin
            if(waiting) //不修改密码
            begin
                $display("changing cancelled.");
                r_green<=0;
                waiting<=0;
                timing<=0;
                inputing<=0;
                times0=0;
                times1=0;
            end
            else if(inputing) //输入密码超时
            begin
                $display("password timeout.");
                alarming<=1;
                inputing<=0;
                timing<=0;
                times0=0;
                times1=0;
                step<=0;
                r_green<=0;
            end
        end
    end
endmodule