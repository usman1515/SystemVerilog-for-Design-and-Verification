PRJ_DIR_ROOT = $(realpath .)

# ------------------------------------------ PATHS
DIR_BIN		:= ${PRJ_DIR_ROOT}/bin

# ------------------------------------------ VARIABLES
WORKLIB		:= work

LAB_01_RTL	:= ./lab_01/register.sv
LAB_01_TB	:= ./lab_01/tb_register.sv
LAB_01_TOP	:= tb_register

LAB_02_RTL	:= ./lab_02/multiplexor.sv
LAB_02_TB	:= ./lab_02/tb_multiplexor.sv
LAB_02_TOP	:= tb_multiplexor

# ------------------------------------------ TARGETS

run_lab_vivado:
	@echo ""
	@mkdir -p $(DIR_BIN)
	@echo ----------------------------- Simulating $(TOP) ----------------------------
	@echo "reading all RTL file/s"
	@xvlog -sv -v 0 --work $(WORKLIB) --incr --relax $(RTL)
	@echo "reading all TB file/s"
	@xvlog -sv -v 0 --work $(WORKLIB) --incr --relax $(TB)
	@echo "elaborate the design"
	@xelab $(TOP) -s $(TOP)_behav --incr --debug typical --relax --mt 8 -L $(WORKLIB) \
		-log $(DIR_BIN)/elaborate_$(TOP).log
	@echo "simulate the design"
	@xsim $(TOP)_behav -runall -ieeewarnings \
		-log $(DIR_BIN)/simulate_$(TOP).log \
		-wdb $(DIR_BIN)/waveform_db_$(TOP).wdb
	@echo ----------------------------------- DONE -----------------------------------
	@echo ""





run_lab01:
	RTL=$(LAB_01_RTL) TB=$(LAB_01_TB) TOP=$(LAB_01_TOP) make run_lab_vivado

run_lab02:
	RTL=$(LAB_02_RTL) TB=$(LAB_02_TB) TOP=$(LAB_02_TOP) make run_lab_vivado
