-- Testbench para probar contador de unos

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity cOnes_tb is
  generic(
    N: natural := 5; -- 5 Contadores BCD
    M: natural := 4 -- Bits de registro para c/ Contador
  );
end;

architecture cOnes_tb_arq of cOnes_tb is
component cOnes is
  generic(
    N: natural := 5; -- 5 Contadores BCD
    M: natural := 4 -- Bits de registro para c/ Contador
  );
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset controlado por c33k.vhdl
    ena_i: in std_logic; -- Entrada para contar unos
    BCD_o: out vectBCD(N-1 downto 0) -- Salida de c/ Contador
  );
end component;

signal clk_tb: std_logic := '1';
signal rst_tb: std_logic := '1';
signal ena_tb: std_logic := '1';
signal BCD_o_tb: vectBCD(N-1 downto 0);

begin
  clk_tb <= not clk_tb after 20 ns;
  rst_tb <= '0' after 80 ns; -- Me aseguro de que al menos
                            -- tarde mas de un ciclo de clk

  DUT: cOnes
    port map(
      clk_i => clk_tb,
      rst_i => rst_tb,
      ena_i => ena_tb,
      BCD_o => BCD_o_tb
    );
end;
