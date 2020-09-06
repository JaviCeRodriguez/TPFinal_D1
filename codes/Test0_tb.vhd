-- Testbench para probar voltimetro sin parte analógica
-- (hay que sacar de la conexión el ADC y meter el generador de pulsos)

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;

entity Test0_tb is
end;

architecture Test0_tb_arq of Test0_tb is
component Test0 is
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    hs: out std_logic; -- Sincronismo horizontal
    vs: out std_logic; -- Sincronismo vertical
    red: out std_logic; -- Rojo
    green: out std_logic; -- Verde
    blue: out std_logic -- Azul
  );
end component;

signal clk_tb: std_logic := '1';
signal rst_tb: std_logic := '1';
signal ena_tb: std_logic := '1';
signal hs_tb: std_logic;
signal vs_tb: std_logic;
signal red_tb: std_logic;
signal green_tb: std_logic;
signal blue_tb: std_logic;

begin
  clk_tb <= not clk_tb after 1 ns; -- 20 ns
  rst_tb <= '0' after 4 ns; -- 200 ns

  DUT: Test0
    port map(
      clk_i => clk_tb,
      rst_i => rst_tb,
      ena_i => ena_tb,
      hs    => hs_tb,
      vs    => vs_tb,
      red   => red_tb,
      green => green_tb,
      blue  => blue_tb
    );
end;
