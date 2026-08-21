#!/bin/tclsh

# Link: https://docs.amd.com/r/2021.2-English/ug895-vivado-system-level-design-entry/Creating-a-Project-Using-a-Tcl-Script
# Typical usage: vivado -mode tcl -source ./scripts/setup_prj_nexys_a7_100t.tcl

source ./scripts/color_func.tcl -notrace

# # set project name and FPGA (Basys 3)
set prj_name "basys3-sv-for-dessgn-and-verification"
set part "xc7a35tcpg236-1"
set board_part "digilentinc.com:basys3:part0:1.2"

# set language
set tb_lang "SystemVerilog"
set rtl_lang "SystemVerilog"
set default_lib "xil_defaultlib"

# for synthesis and implementation purposes
set top_module_rtl ""
# for testbench simulation purposes only
set top_module_tb ""

# create a new project
set prj_dir "./${prj_name}"
print_yellow "creating new project: ${prj_name}"
create_project -force $prj_name $prj_dir -part $part

# set the project parameters
print_yellow "setting project parameters"
set_property board_part $board_part [current_project]
set_property default_lib $default_lib [current_project]
set_property target_language $rtl_lang [current_project]
set_property simulator_language $tb_lang [current_project]

# add Verilog RTL source files to the project
print_yellow "adding RTL source files"
add_files -force -fileset sources_1 {
    ./lab_01/register.sv
}

# add TB source files to the project
print_yellow "adding TB source files"
add_files -force -fileset sim_1 {
    ./lab_01/tb_register.sv
}

# set RTL top module - for design and implementation purposes
print_yellow "setting RTL top module"
set_property top ${top_module_rtl} [current_fileset]
# set TB top module - for testbench simulation purposes
print_yellow "setting TB top module"
set_property top ${top_module_tb} [current_fileset]

# add constraint files to the project
# print_yellow "adding constraint files for IO, timing, etc"
# # top level IO constraints
# add_files -fileset constrs_1 ./constraints/io_basys3.xdc

# update to set top and file compile order
print_yellow "update compilation order"
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
update_compile_order -fileset constrs_1

# report compilation order
print_yellow "report compilation order"
report_compile_order -fileset sources_1
report_compile_order -fileset sim_1
report_compile_order -fileset constrs_1

# close the project
close_project

