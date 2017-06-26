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
            out=8'b11111110;
        else if(w_in==9)
            out=8'b11110110;
endmodule

module display(clk,enable,number7,number6,number5,number4,number3,number2,number1,number0,w_out,w_sel);
    input [7:0] enable;
    input clk;
    input [3:0] number0,number1,number2,number3,number4,number5,number6,number7;
    output [7:0] w_out,w_sel;
    reg [2:0] i=0;
    reg [3:0] source=0;
    reg [7:0] sel=0;
    assign w_sel=sel;
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

module encoder83(in,out,yes);
    input [7:0] in;
    output [2:0] out;
    output yes;
    reg [2:0] out;
    assign yes=!(in==8'b00000000);
    
    always @(in)
    begin
        if(in==8'b00000000)
            out=0;
        else if(in==8'b00000001)
            out=0;
        else if(in==8'b00000010)
            out=1;
        else if(in==8'b00000100)
            out=2;
        else if(in==8'b00001000)
            out=3;
        else if(in==8'b00010000)
            out=4;
        else if(in==8'b00100000)
            out=5;
        else if(in==8'b01000000)
            out=6;
        else if(in==8'b10000000)
            out=7;
    end
    
endmodule

module memory(clk,in,stat,clr,out,t1,t0);
    input [2:0] in;
    input clk,stat,clr; //stat=0为输入密码，stat=1为修改密码
    output out;//标志输入结束
    output [3:0] t1,t0;
    
    reg [2:0] password [3:0];
    reg init=0;
    reg r_out=0;
    reg [2:0] step=0;
    reg [3:0] times1=0,times0=0;
    assign out=r_out;
    assign t1=times1;
    assign t0=times0;
    
    always @(clk,clr)
    begin
        if(clr)
        begin
            times0=0;
            times1=0;
            step=0;
        end
        else
        begin
        //可能的初始化
        if(!init) 
        begin
            init=1;
            password[0]=0;
            password[1]=0;
            password[2]=0;
            password[3]=0;
        end
        
        //清零step
        if(step==4) step=0;
        
        //记录按键次数
        if(times0==9)
        begin
            times0=0;
            times1=times1+1;
        end
        else times0=times0+1;
        
        //输入
        if(!stat)
        begin
            if(password[step]==in) step=step+1;
        end
        else if(step!=4)
        begin
            password[step]=in;
            step=step+1;
        end
        
        //判断是否输入结束
        if(step==4)
        begin
            r_out=1;
            times0=0;
            times1=0;
        end
        end
    end
endmodule

module CPU(clock,
           sel,
           green,
           red,
           alarm,
           n2,
           n3,
           n4,
           n5,
           n6,
           n7,
           in,
           memclk,
           memin,
           memstat,
           memclr,
           memfinish,
           CK
          );
    input [7:0] in;
    input CK;
    input memfinish;
    output [3:0] n2,n3,n4,n5,n6,n7;
    output [7:0] sel;
    output [2:0] memin;
    output memclk,memstat,memclr;
    output green,red,alarm,clock;
    
    //时序控制寄存器
    reg [17:0] CKn=0;
    reg [9:0] left=500;
    reg [3:0] lefttime=0;
    
    //状态寄存器
    reg [7:0] last;
    reg [7:0] select=8'b10000011;
    
    //信号发射寄存器
    reg r_green=0,clk=0;
    reg inputing=0,changing=0,waiting=0,timing=0,alarming=0;
    
    wire hasinput;
    
    //信号控制
    assign red=~r_green;
    assign green=r_green;
    assign alarm=alarming;
    assign clock=clk;
    
    //数码显示控制
    assign n7=lefttime;
    //assign Error.
    assign n6=8'b10011110;
    assign n5=8'b00001010;
    assign n4=8'b00001010;
    assign n3=8'b00111010;
    assign n2=8'b00001011;
    
    //时钟
    always @(posedge CK)
    begin
        if(CKn==100000)
        begin
            CKn=1;
            clk=~clk;
        end
        else CKn=CKn+1;
    end
    
    //编码
    encoder83(in^last,memin,hasinput);
    
    //时序逻辑
    always @(posedge clk)
    begin
        //计时
        if(timing)
        begin
            if(left==0)
            begin
                lefttime=lefttime-1;
                left=500;
            end
            else left=left-1;
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

module Lock(clk,in,CK,out,sel);
    input clk,CK;
    input [7:0] in;
    output [7:0] out,sel;
    
    wire clk,select,green,red,alarm,n2,n3,n4,n5,n6,n7,t0,t1,mclk,min,mstat,mclr,mfinish;
    
    CPU cpu(clk,
            select,
            green,
            red,
            alarm,
            n2,n3,n4,n5,n6,n7,
            in,
            mclk,min,mstat,mclr,mfinish,CK);
    memory mem(mclk,min,mstat,mclr,mfinish,t1,t0);
    display screen(clk,select,n7,n6,n5,n4,n3,n2,t1,t0,out,sel);
endmodule