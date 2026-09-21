-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/lab3_GA.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/synchronizer.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/scanner.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/key_decoder.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/key_control.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/display_mux.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/digit_reg.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/debouncer.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/counter.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab3/fpga/Radiant/lab3_GA/source/impl_1/sevenseg_decoder.sv" 
"C:/Users/gmenendezdealencar/Downloads/digit_reg_tb.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top digit_reg_tb
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
-do "run 100 ns"
