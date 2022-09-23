# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {AXI Parameters}]
  #Adding Group
  set S00_AXIS [ipgui::add_group $IPINST -name "S00 AXIS" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "C_S00_AXIS_TDATA_WIDTH" -parent ${S00_AXIS}
  ipgui::add_param $IPINST -name "C_S00_AXIS_TUSER_WIDTH" -parent ${S00_AXIS}
  ipgui::add_param $IPINST -name "C_S00_AXIS_FIFO_DEPTH" -parent ${S00_AXIS}

  #Adding Group
  set S01_AXIS [ipgui::add_group $IPINST -name "S01 AXIS" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "C_S01_AXIS_TDATA_WIDTH" -parent ${S01_AXIS}
  ipgui::add_param $IPINST -name "C_S01_AXIS_TUSER_WIDTH" -parent ${S01_AXIS}
  ipgui::add_param $IPINST -name "C_S01_AXIS_FIFO_DEPTH" -parent ${S01_AXIS}

  #Adding Group
  set M00_AXIS [ipgui::add_group $IPINST -name "M00 AXIS" -parent ${Page_0}]
  set C_M00_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${M00_AXIS}]
  set_property tooltip {Width of S_AXIS address bus.} ${C_M00_AXIS_TDATA_WIDTH}
  ipgui::add_param $IPINST -name "C_M00_AXIS_TUSER_WIDTH" -parent ${M00_AXIS}
  ipgui::add_param $IPINST -name "C_M00_AXIS_FIFO_DEPTH" -parent ${M00_AXIS}


  #Adding Page
  set Page_2 [ipgui::add_page $IPINST -name "Page 2" -display_name {Debug options}]
  ipgui::add_param $IPINST -name "C_S00_AXIS_DEBUG" -parent ${Page_2}
  ipgui::add_param $IPINST -name "C_S01_AXIS_DEBUG" -parent ${Page_2}
  ipgui::add_param $IPINST -name "C_M00_AXIS_DEBUG" -parent ${Page_2}
  ipgui::add_param $IPINST -name "C_PROC_FIFO_DEBUG" -parent ${Page_2}
  ipgui::add_param $IPINST -name "C_PROC_LOGIC_DEBUG" -parent ${Page_2}

  #Adding Page
  set Video_options [ipgui::add_page $IPINST -name "Video options"]
  ipgui::add_param $IPINST -name "C_PROC_DIFF_THRESHOLD" -parent ${Video_options}


}

proc update_PARAM_VALUE.C_M00_AXIS_DEBUG { PARAM_VALUE.C_M00_AXIS_DEBUG } {
	# Procedure called to update C_M00_AXIS_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_DEBUG { PARAM_VALUE.C_M00_AXIS_DEBUG } {
	# Procedure called to validate C_M00_AXIS_DEBUG
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_FIFO_DEPTH { PARAM_VALUE.C_M00_AXIS_FIFO_DEPTH } {
	# Procedure called to update C_M00_AXIS_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_FIFO_DEPTH { PARAM_VALUE.C_M00_AXIS_FIFO_DEPTH } {
	# Procedure called to validate C_M00_AXIS_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TUSER_WIDTH { PARAM_VALUE.C_M00_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_M00_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TUSER_WIDTH { PARAM_VALUE.C_M00_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_PROC_DIFF_THRESHOLD { PARAM_VALUE.C_PROC_DIFF_THRESHOLD } {
	# Procedure called to update C_PROC_DIFF_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PROC_DIFF_THRESHOLD { PARAM_VALUE.C_PROC_DIFF_THRESHOLD } {
	# Procedure called to validate C_PROC_DIFF_THRESHOLD
	return true
}

proc update_PARAM_VALUE.C_PROC_FIFO_DEBUG { PARAM_VALUE.C_PROC_FIFO_DEBUG } {
	# Procedure called to update C_PROC_FIFO_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PROC_FIFO_DEBUG { PARAM_VALUE.C_PROC_FIFO_DEBUG } {
	# Procedure called to validate C_PROC_FIFO_DEBUG
	return true
}

proc update_PARAM_VALUE.C_PROC_LOGIC_DEBUG { PARAM_VALUE.C_PROC_LOGIC_DEBUG } {
	# Procedure called to update C_PROC_LOGIC_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PROC_LOGIC_DEBUG { PARAM_VALUE.C_PROC_LOGIC_DEBUG } {
	# Procedure called to validate C_PROC_LOGIC_DEBUG
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_DEBUG { PARAM_VALUE.C_S00_AXIS_DEBUG } {
	# Procedure called to update C_S00_AXIS_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_DEBUG { PARAM_VALUE.C_S00_AXIS_DEBUG } {
	# Procedure called to validate C_S00_AXIS_DEBUG
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_FIFO_DEPTH { PARAM_VALUE.C_S00_AXIS_FIFO_DEPTH } {
	# Procedure called to update C_S00_AXIS_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_FIFO_DEPTH { PARAM_VALUE.C_S00_AXIS_FIFO_DEPTH } {
	# Procedure called to validate C_S00_AXIS_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_S00_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXIS_DEBUG { PARAM_VALUE.C_S01_AXIS_DEBUG } {
	# Procedure called to update C_S01_AXIS_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXIS_DEBUG { PARAM_VALUE.C_S01_AXIS_DEBUG } {
	# Procedure called to validate C_S01_AXIS_DEBUG
	return true
}

proc update_PARAM_VALUE.C_S01_AXIS_FIFO_DEPTH { PARAM_VALUE.C_S01_AXIS_FIFO_DEPTH } {
	# Procedure called to update C_S01_AXIS_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXIS_FIFO_DEPTH { PARAM_VALUE.C_S01_AXIS_FIFO_DEPTH } {
	# Procedure called to validate C_S01_AXIS_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S01_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_S01_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S01_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_S01_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S01_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S01_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S01_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S01_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S01_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S01_AXIS_TDATA_WIDTH PARAM_VALUE.C_S01_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TUSER_WIDTH PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_S01_AXIS_TUSER_WIDTH PARAM_VALUE.C_S01_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TUSER_WIDTH PARAM_VALUE.C_M00_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_FIFO_DEPTH { MODELPARAM_VALUE.C_S00_AXIS_FIFO_DEPTH PARAM_VALUE.C_S00_AXIS_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_S00_AXIS_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_DEBUG { MODELPARAM_VALUE.C_S00_AXIS_DEBUG PARAM_VALUE.C_S00_AXIS_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_DEBUG}] ${MODELPARAM_VALUE.C_S00_AXIS_DEBUG}
}

proc update_MODELPARAM_VALUE.C_S01_AXIS_FIFO_DEPTH { MODELPARAM_VALUE.C_S01_AXIS_FIFO_DEPTH PARAM_VALUE.C_S01_AXIS_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXIS_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_S01_AXIS_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.C_S01_AXIS_DEBUG { MODELPARAM_VALUE.C_S01_AXIS_DEBUG PARAM_VALUE.C_S01_AXIS_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXIS_DEBUG}] ${MODELPARAM_VALUE.C_S01_AXIS_DEBUG}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_FIFO_DEPTH { MODELPARAM_VALUE.C_M00_AXIS_FIFO_DEPTH PARAM_VALUE.C_M00_AXIS_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_M00_AXIS_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_DEBUG { MODELPARAM_VALUE.C_M00_AXIS_DEBUG PARAM_VALUE.C_M00_AXIS_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_DEBUG}] ${MODELPARAM_VALUE.C_M00_AXIS_DEBUG}
}

proc update_MODELPARAM_VALUE.C_PROC_FIFO_DEBUG { MODELPARAM_VALUE.C_PROC_FIFO_DEBUG PARAM_VALUE.C_PROC_FIFO_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PROC_FIFO_DEBUG}] ${MODELPARAM_VALUE.C_PROC_FIFO_DEBUG}
}

proc update_MODELPARAM_VALUE.C_PROC_LOGIC_DEBUG { MODELPARAM_VALUE.C_PROC_LOGIC_DEBUG PARAM_VALUE.C_PROC_LOGIC_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PROC_LOGIC_DEBUG}] ${MODELPARAM_VALUE.C_PROC_LOGIC_DEBUG}
}

proc update_MODELPARAM_VALUE.C_PROC_DIFF_THRESHOLD { MODELPARAM_VALUE.C_PROC_DIFF_THRESHOLD PARAM_VALUE.C_PROC_DIFF_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PROC_DIFF_THRESHOLD}] ${MODELPARAM_VALUE.C_PROC_DIFF_THRESHOLD}
}

