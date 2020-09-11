-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
-- Date        : Sun Aug 23 21:33:04 2020
-- Host        : DESKTOP-ARKS4GD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               z:/Facultad/Digital_1/TPFinal_D1/Voltimetro_JCR/Voltimetro_JCR.srcs/sources_1/ip/clk_generator/clk_generator_stub.vhdl
-- Design      : clk_generator
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35ticsg324-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_generator is
  Port ( 
    clk_o : out STD_LOGIC;
    clk_i : in STD_LOGIC
  );

end clk_generator;

architecture stub of clk_generator is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_o,clk_i";
begin
end;
