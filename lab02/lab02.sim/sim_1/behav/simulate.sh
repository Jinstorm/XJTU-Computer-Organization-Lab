#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim sim_counterfor73_behav -key {Behavioral:sim_1:Functional:sim_counterfor73} -tclbatch sim_counterfor73.tcl -log simulate.log
