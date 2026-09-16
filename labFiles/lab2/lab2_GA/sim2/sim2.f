-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab2/lab2_GA/source/impl_1/lab2_GA.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab2/lab2_GA/source/impl_1/scanner.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab2/lab2_GA/source/impl_1/counter.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab2/lab2_GA/source/impl_1/sevenseg_decoder.sv" 
"C:/Users/gmenendezdealencar/Documents/GitHub/hmc-e155-portfolio/labFiles/lab2/fpga/sim/lab2_GA_tb.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top lab2_GA_tb
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
-do "run 100 ns"
