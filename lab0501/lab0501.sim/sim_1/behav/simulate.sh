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
ExecStep $xv_path/bin/xsim sim_Link_behav -key {Behavioral:sim_1:Functional:sim_Link} -tclbatch sim_Link.tcl -log simulate.log
