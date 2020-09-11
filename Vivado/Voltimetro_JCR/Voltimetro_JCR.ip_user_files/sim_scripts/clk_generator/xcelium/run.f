-makelib xcelium_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../Voltimetro_JCR.srcs/sources_1/ip/clk_generator/clk_generator_clk_wiz.v" \
  "../../../../Voltimetro_JCR.srcs/sources_1/ip/clk_generator/clk_generator.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

