lappend auto_path "C:/lscc/radiant/2026.1/scripts/tcl/simulation"
package require simulation_generation
set ::bali::simulation::Para(DEVICEPM) {ice40tp}
set ::bali::simulation::Para(DEVICEFAMILYNAME) {iCE40UP}
set ::bali::simulation::Para(PROJECT) {testbench}
set ::bali::simulation::Para(MDOFILE) {}
set ::bali::simulation::Para(PROJECTPATH) {U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/Lattice/lab7_GA/testbench}
set ::bali::simulation::Para(FILELIST) {"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/addroundkey.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_core.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_ctrl.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_datapath.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_spi.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/galoismult.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/input_to_state.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/keyexpand.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/lab7_GA.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/mixcolumn.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/mixcolumns.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/sbox_sync.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/shiftrows.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/state_to_output.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/subbytes.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/synchronizer.sv" "U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/sim/aes_spi_tb.sv" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "" }
set ::bali::simulation::Para(COMPLIST) {"VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" }
set ::bali::simulation::Para(LANGSTDLIST) {"System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_ice40up}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {testbench_aes_spi}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {VERILOG}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(INSTALLATIONPATH) {C:/lscc/radiant/2026.1}
set ::bali::simulation::Para(MEMPATH) {}
set ::bali::simulation::Para(UDOLIST) {}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(SIMULATIONTIME)  {100}
set ::bali::simulation::Para(SIMULATIONTIMEUNIT)  {ns}
set ::bali::simulation::Para(SIMULATION_RESOLUTION)  {default}
set ::bali::simulation::Para(NOGUI) {0}
set ::bali::simulation::Para(ISRTL)  {1}
set ::bali::simulation::Para(ISQRUNCLEAN)  {1}
set ::bali::simulation::Para(HDLPARAMETERS) {}
set ::bali::simulation::Para(AUTOORDER)  {1}
set ::bali::simulation::Para(PERMISSIVE)  {0}
set ::bali::simulation::Para(OPTIMIZATION_DEBUG)  {1}
::bali::simulation::QuestaSim_Q_Run
