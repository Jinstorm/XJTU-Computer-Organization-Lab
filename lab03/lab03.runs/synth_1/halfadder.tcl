# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/jinstorm/vivado/lab03/lab03.cache/wt [current_project]
set_property parent.project_path /home/jinstorm/vivado/lab03/lab03.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib /home/jinstorm/vivado/lab03/lab03.srcs/sources_1/new/halfadder.v
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top halfadder -part xc7a35tcpg236-1


write_checkpoint -force -noxdef halfadder.dcp

catch { report_utilization -file halfadder_utilization_synth.rpt -pb halfadder_utilization_synth.pb }
