# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcsg324-3

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/lalala/ElectricPasswordLock/ElectricPasswordLock.cache/wt [current_project]
set_property parent.project_path D:/lalala/ElectricPasswordLock/ElectricPasswordLock.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/lalala/ElectricPasswordLock/ElectricPasswordLock.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib D:/lalala/ElectricPasswordLock/ElectricPasswordLock.srcs/sources_1/new/Lock.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/lalala/ElectricPasswordLock/ElectricPasswordLock.srcs/constrs_1/new/c.xdc
set_property used_in_implementation false [get_files D:/lalala/ElectricPasswordLock/ElectricPasswordLock.srcs/constrs_1/new/c.xdc]


synth_design -top Lock -part xc7a35tcsg324-3


write_checkpoint -force -noxdef Lock.dcp

catch { report_utilization -file Lock_utilization_synth.rpt -pb Lock_utilization_synth.pb }
