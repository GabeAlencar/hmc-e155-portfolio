-L work
-reflib pmi_work
-reflib ovi_ice40up


"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/addroundkey.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_core.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_ctrl.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_datapath.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/aes_spi.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/galoismult.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/input_to_state.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/keyexpand.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/lab7_GA.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/mixcolumn.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/mixcolumns.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/sbox_sync.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/shiftrows.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/state_to_output.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/subbytes.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/src/synchronizer.sv" 
"U:/home/gabe/hmc-e155-portfolio/labFiles/lab7/fpga/sim/aes_spi_tb.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top testbench_aes_spi
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
-do "run 100 ns"
