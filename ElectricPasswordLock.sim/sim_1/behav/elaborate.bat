@echo off
set xv_path=D:\\anzhuang\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 457a6902ef3d45cdb69415bd8cf96271 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot counter_behav xil_defaultlib.counter xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
