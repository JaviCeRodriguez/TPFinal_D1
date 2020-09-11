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
    clk_i			: in std_logic;		-- Clock
		rst_i			: in std_logic;		-- Reset
		ena_i			: in std_logic;		-- Enable
		red_o			: out std_logic;	-- Salida del color rojo
		grn_o			: out std_logic;	-- Salida del color verde
		blu_o			: out std_logic;	-- Salida del color azul
		hs_o			: out std_logic;	-- Sicronismo horizontal
		vs_o			: out std_logic	-- Sincronismo vertical
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
      hs_o    => hs_tb,
      vs_o    => vs_tb,
      red_o  => red_tb,
      grn_o => green_tb,
      blu_o  => blue_tb
    );
end;
