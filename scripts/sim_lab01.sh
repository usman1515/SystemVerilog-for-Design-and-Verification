#!/bin/bash

# file and module names
DIR_DAY_N='lab_01'                      # folder name
FILENAME_RTL_TOP='register'             # file name rtl top module
FILENAME_TB_TOP='tb_register'           # file name tb top
FILENAME_VVP='register'                 # file name output vvp
FILENAME_SYNTH='lab_01_synth'           # file name yosys sim script
FILENAME_NETLIST='netlist_register'     # file name yosys generated netlist

# path of yosys script for day N
PATH_SYNTH_FILE=${DIR_DAY_N}/${FILENAME_SYNTH}.ys

# clean previous dump files
rm -rf ${DIR_DAY_N}/*.ys ${DIR_DAY_N}/netlist_*.sv ${DIR_DAY_N}/*.dot \
${DIR_DAY_N}/*.vcd ${DIR_DAY_N}/*.vvp

echo -e "\n\n"
# =============================================== Icarus Verilog
# compile and sim rtl and tb using iverilog
iverilog -o ${DIR_DAY_N}/${FILENAME_VVP}.vvp \
-Wall -Winfloop -gno-shared-loop-index -g2012 \
${DIR_DAY_N}/${FILENAME_RTL_TOP}.sv ${DIR_DAY_N}/${FILENAME_TB_TOP}.sv

# simulate tb
vvp ${DIR_DAY_N}/${FILENAME_VVP}.vvp

echo -e "\n\n"
# =============================================== Synthesize design using yosys
echo -n "Synthesize design using Yosys (Press Y/N): "
read opt
if [[ $opt == 'Y' ]] || [[ $opt == 'y' ]]
then
    echo -e "\n-------------------------- Synthesizing Lab 1 RTL --------------------------"

    touch ${PATH_SYNTH_FILE}
    # ----- create script for yosys sim
    # read design file
    echo "read -sv ${DIR_DAY_N}/${FILENAME_RTL_TOP}.sv" > ${PATH_SYNTH_FILE}
    # elaborate design hierarchy
    echo "hierarchy -check -auto-top" >> ${PATH_SYNTH_FILE}
    # coarse synthesis
    echo "flatten" >> ${PATH_SYNTH_FILE}
    echo "proc; opt_expr; opt_clean" >> ${PATH_SYNTH_FILE}
    echo "check; opt -nodffe -nosdff" >> ${PATH_SYNTH_FILE}
    echo "fsm; opt" >> ${PATH_SYNTH_FILE}
    echo "wreduce" >> ${PATH_SYNTH_FILE}
    echo "peepopt; opt_clean" >> ${PATH_SYNTH_FILE}
    echo "techmap" >> ${PATH_SYNTH_FILE}
    echo "alumacc" >> ${PATH_SYNTH_FILE}
    echo "share; opt" >> ${PATH_SYNTH_FILE}
    echo "memory -nomap; opt_clean" >> ${PATH_SYNTH_FILE}
    # fine synthesis
    echo "opt -fast -full" >> ${PATH_SYNTH_FILE}
    echo "memory_map; opt -full" >> ${PATH_SYNTH_FILE}
    echo "techmap; opt -fast" >> ${PATH_SYNTH_FILE}
    echo "abc -fast; opt -fast" >> ${PATH_SYNTH_FILE}
    # check
    echo "clean" >> ${PATH_SYNTH_FILE}
    # write netlist to new verilog file
    echo "write_verilog ${DIR_DAY_N}/${FILENAME_NETLIST}.v" >> ${PATH_SYNTH_FILE}
    # write netlist to new json file
    echo "json -aig -o ${DIR_DAY_N}/${FILENAME_NETLIST}.json" >> ${PATH_SYNTH_FILE}
    # display design netlist using svg
    echo "show -format svg -viewer eog -stretch -width -colors 10000 -signed -prefix ${DIR_DAY_N}/${FILENAME_RTL_TOP}" >> ${PATH_SYNTH_FILE}
    # display stats
    echo "stat -tech cmos -width" >> ${PATH_SYNTH_FILE}

    # run yosys
    yosys ${PATH_SYNTH_FILE}
    echo -e "\n"
else
    echo "NOT synthesizing design"
fi