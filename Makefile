PRJ_DIR_ROOT = $(shell git rev-parse --show-toplevel)

# ------------------------------------------ PATHS
# ------------------------------------------ VARIABLES
# ------------------------------------------ TARGETS
compile_lab04:
	@ echo " "
	@ echo ----------------------------- Compiling Lab 04 -----------------------------
	@ bash ${PRJ_DIR_ROOT}/scripts/sim_lab04.sh
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

compile_lab03:
	@ echo " "
	@ echo ----------------------------- Compiling Lab 03 -----------------------------
	@ bash ${PRJ_DIR_ROOT}/scripts/sim_lab03.sh
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

compile_lab02:
	@ echo " "
	@ echo ----------------------------- Compiling Lab 02 -----------------------------
	@ bash ${PRJ_DIR_ROOT}/scripts/sim_lab02.sh
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

compile_lab01:
	@ echo " "
	@ echo ----------------------------- Compiling Lab 01 -----------------------------
	@ bash ${PRJ_DIR_ROOT}/scripts/sim_lab01.sh
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

install_iverilog:
	@ echo " "
	@ echo ------------------------- INSTALLING Icarus Verilog ------------------------
	@ bash ${PRJ_DIR_ROOT}/scripts/install_iverilog.sh
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

install_yosys:
	@ echo " "
	@ echo ------------------- INSTALLING Yosys Open SYnthesis Suite ------------------
	@ bash ${PRJ_DIR_ROOT}/scripts/install_yosys.sh
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "

clean_all:
	@ echo " "
	@ echo -------------------------- Cleaning all dump files -------------------------
	@ rm -rf \
	lab_*/*.ys \
	lab_*/*.vcd \
	lab_*/*.json \
	lab_*/*.v \
	lab_*/*.dot \
	lab_*/*.svg \
	lab_*/*.vvp
	@ echo ----------------------------------- DONE -----------------------------------
	@ echo " "