set_property SRC_FILE_INFO {cfile:z:/Facultad/Digital_1/TPFinal_D1/Voltimetro_JCR/Voltimetro_JCR.srcs/sources_1/ip/clk_generator/clk_generator.xdc rfile:../../../Voltimetro_JCR.srcs/sources_1/ip/clk_generator/clk_generator.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_i]] 0.1
