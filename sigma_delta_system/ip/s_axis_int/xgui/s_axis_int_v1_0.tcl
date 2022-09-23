# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Parameters}]
  ipgui::add_param $IPINST -name "C_S_AXIS_DEBUG" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_FIFO_ALMOST_EMPTY_TH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_FIFO_ALMOST_FULL_TH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_FIFO_DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIS_TUSER_WIDTH" -parent ${Page_0}

  #Adding Page
  set FIFO_PORTS [ipgui::add_page $IPINST -name "FIFO PORTS"]
  ipgui::add_param $IPINST -name "HAS_FIFO_NOT_ALMOST_FULL" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_NOT_ALMOST_EMPTY" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_NOT_EMPTY" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_NOT_FULL" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_ALMOST_EMPTY" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_EMPTY" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_ALMOST_FULL" -parent ${FIFO_PORTS}
  ipgui::add_param $IPINST -name "HAS_FIFO_FULL" -parent ${FIFO_PORTS}


}

proc update_PARAM_VALUE.C_S_AXIS_DEBUG { PARAM_VALUE.C_S_AXIS_DEBUG } {
	# Procedure called to update C_S_AXIS_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_DEBUG { PARAM_VALUE.C_S_AXIS_DEBUG } {
	# Procedure called to validate C_S_AXIS_DEBUG
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH { PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH } {
	# Procedure called to update C_S_AXIS_FIFO_ALMOST_EMPTY_TH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH { PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH } {
	# Procedure called to validate C_S_AXIS_FIFO_ALMOST_EMPTY_TH
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH { PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH } {
	# Procedure called to update C_S_AXIS_FIFO_ALMOST_FULL_TH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH { PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH } {
	# Procedure called to validate C_S_AXIS_FIFO_ALMOST_FULL_TH
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_FIFO_DEPTH { PARAM_VALUE.C_S_AXIS_FIFO_DEPTH } {
	# Procedure called to update C_S_AXIS_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_FIFO_DEPTH { PARAM_VALUE.C_S_AXIS_FIFO_DEPTH } {
	# Procedure called to validate C_S_AXIS_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_S_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_S_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_ALMOST_EMPTY { PARAM_VALUE.HAS_FIFO_ALMOST_EMPTY } {
	# Procedure called to update HAS_FIFO_ALMOST_EMPTY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_ALMOST_EMPTY { PARAM_VALUE.HAS_FIFO_ALMOST_EMPTY } {
	# Procedure called to validate HAS_FIFO_ALMOST_EMPTY
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_ALMOST_FULL { PARAM_VALUE.HAS_FIFO_ALMOST_FULL } {
	# Procedure called to update HAS_FIFO_ALMOST_FULL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_ALMOST_FULL { PARAM_VALUE.HAS_FIFO_ALMOST_FULL } {
	# Procedure called to validate HAS_FIFO_ALMOST_FULL
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_EMPTY { PARAM_VALUE.HAS_FIFO_EMPTY } {
	# Procedure called to update HAS_FIFO_EMPTY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_EMPTY { PARAM_VALUE.HAS_FIFO_EMPTY } {
	# Procedure called to validate HAS_FIFO_EMPTY
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_FULL { PARAM_VALUE.HAS_FIFO_FULL } {
	# Procedure called to update HAS_FIFO_FULL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_FULL { PARAM_VALUE.HAS_FIFO_FULL } {
	# Procedure called to validate HAS_FIFO_FULL
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_NOT_ALMOST_EMPTY { PARAM_VALUE.HAS_FIFO_NOT_ALMOST_EMPTY } {
	# Procedure called to update HAS_FIFO_NOT_ALMOST_EMPTY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_NOT_ALMOST_EMPTY { PARAM_VALUE.HAS_FIFO_NOT_ALMOST_EMPTY } {
	# Procedure called to validate HAS_FIFO_NOT_ALMOST_EMPTY
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_NOT_ALMOST_FULL { PARAM_VALUE.HAS_FIFO_NOT_ALMOST_FULL } {
	# Procedure called to update HAS_FIFO_NOT_ALMOST_FULL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_NOT_ALMOST_FULL { PARAM_VALUE.HAS_FIFO_NOT_ALMOST_FULL } {
	# Procedure called to validate HAS_FIFO_NOT_ALMOST_FULL
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_NOT_EMPTY { PARAM_VALUE.HAS_FIFO_NOT_EMPTY } {
	# Procedure called to update HAS_FIFO_NOT_EMPTY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_NOT_EMPTY { PARAM_VALUE.HAS_FIFO_NOT_EMPTY } {
	# Procedure called to validate HAS_FIFO_NOT_EMPTY
	return true
}

proc update_PARAM_VALUE.HAS_FIFO_NOT_FULL { PARAM_VALUE.HAS_FIFO_NOT_FULL } {
	# Procedure called to update HAS_FIFO_NOT_FULL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_FIFO_NOT_FULL { PARAM_VALUE.HAS_FIFO_NOT_FULL } {
	# Procedure called to validate HAS_FIFO_NOT_FULL
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXIS_FIFO_DEPTH { MODELPARAM_VALUE.C_S_AXIS_FIFO_DEPTH PARAM_VALUE.C_S_AXIS_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_S_AXIS_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH { MODELPARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH}] ${MODELPARAM_VALUE.C_S_AXIS_FIFO_ALMOST_FULL_TH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH { MODELPARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH}] ${MODELPARAM_VALUE.C_S_AXIS_FIFO_ALMOST_EMPTY_TH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_DEBUG { MODELPARAM_VALUE.C_S_AXIS_DEBUG PARAM_VALUE.C_S_AXIS_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_DEBUG}] ${MODELPARAM_VALUE.C_S_AXIS_DEBUG}
}

