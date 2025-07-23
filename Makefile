PRJ_DIR_ROOT = $(realpath .)

# ------------------------------------------ PATHS
DIR_BIN		:= ${PRJ_DIR_ROOT}/bin

# ------------------------------------------ VARIABLES
LAB_01_RTL	:= ./lab_01/register.sv
LAB_01_TB	:= ./lab_01/tb_register.sv
LAB_01_TOP	:= tb_register
WORKLIB		:= work

# ------------------------------------------ TARGETS

run_lab01:
	@ echo " "
	@ [[ -d ${DIR_BIN} ]] || mkdir ${DIR_BIN}
	@ echo ----------------------------- Simulating Lab 01 ----------------------------
	@ echo "reading all RTL file/s"
	@ exec xvlog -sv -v 0 --work $(WORKLIB) --incr --relax $(LAB_01_RTL)
	@ echo "reading all TB file/s"
	@ exec xvlog -sv -v 0 --work $(WORKLIB) --incr --relax $(LAB_01_TB)
	@ echo "elaborate the design"
	@ exec xelab $(LAB_01_TOP) -s $(LAB_01_TOP)_behav --incr --debug typical --relax --mt 8 -L \
		work -log $(DIR_BIN)/elaborate_$(LAB_01_TOP).log
	@ echo "simulate the design"
	@ exec xsim $(LAB_01_TOP)_behav -runall -ieeewarnings \
		-log $(DIR_BIN)/simulate_$(LAB_01_TOP).log -wdb $(DIR_BIN)/waveform_db_$(LAB_01_TOP).wdb
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

