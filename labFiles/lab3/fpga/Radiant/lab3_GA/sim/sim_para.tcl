lappend auto_path "C:/lscc/radiant/2026.1/scripts/tcl/simulation"
package require simulation_generation
set ::bali::simulation::Para(DEVICEPM) {ice40tp}
set ::bali::simulation::Para(DEVICEFAMILYNAME) {iCE40UP}
set ::bali::simulation::Para(PROJECT) {sim}
set ::bali::simulation::Para(MDOFILE) {}
set ::bali::simulation::Para(PROJECTPATH) {C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/sim}
set ::bali::simulation::Para(FILELIST) {"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/lab3_GA.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/synchronizer.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/scanner.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/key_decoder.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/key_control.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/display_mux.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/digit_reg.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/debouncer.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/counter.sv" "C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/sevenseg_decoder.sv" "C:/Users/gmenendezdealencar/Downloads/digit_reg_tb.sv" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "" }
set ::bali::simulation::Para(COMPLIST) {"VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" }
set ::bali::simulation::Para(LANGSTDLIST) {"System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "System Verilog" "" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_ice40up}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {digit_reg_tb}
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
