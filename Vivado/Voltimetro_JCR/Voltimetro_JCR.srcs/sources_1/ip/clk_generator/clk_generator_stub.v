// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Sun Aug 23 21:33:04 2020
// Host        : DESKTOP-ARKS4GD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               z:/Facultad/Digital_1/TPFinal_D1/Voltimetro_JCR/Voltimetro_JCR.srcs/sources_1/ip/clk_generator/clk_generator_stub.v
// Design      : clk_generator
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_generator(clk_o, clk_i)
/* synthesis syn_black_box black_box_pad_pin="clk_o,clk_i" */;
  output clk_o;
  input clk_i;
endmodule
