@echo off
set xv_path=D:\\anzhuang\\Vivado\\2016.4\\bin
call %xv_path%/xsim counter_behav -key {Behavioral:sim_1:Functional:counter} -tclbatch counter.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
