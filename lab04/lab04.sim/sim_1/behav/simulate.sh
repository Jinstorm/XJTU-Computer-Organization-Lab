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
ExecStep $xv_path/bin/xsim sim_RAM4Kx32_behav -key {Behavioral:sim_1:Functional:sim_RAM4Kx32} -tclbatch sim_RAM4Kx32.tcl -log simulate.log
