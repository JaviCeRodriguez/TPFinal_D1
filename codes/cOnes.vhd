-- Contador de unos
-- Utilizo: ffd.vhd, reg_Nb, BCD_counter.vhd, sum_Nb.vhd, sum_1b.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity cOnes is
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
end;

architecture cOnes_arq of cOnes is
----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal ena_aux: std_logic_vector (N downto 0);
signal max_aux: std_logic_vector (N-1 downto 0);

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  cOnes_gen: for i in 0 to N-1 generate
    BCD_counterN: entity work.BCD_counter
      generic map(N => M)
      port map(
        clk_i  => clk_i,
        rst_i  => rst_i,
        ena_i  => ena_aux(i),
        count  => BCD_o(i),
        max    => max_aux(i)
      );
    ena_aux(i+1) <= ena_aux(i) and max_aux(i);
  end generate;
  ena_aux(0) <= ena_i;
end;
