-- Contador BCD
-- Utilizo: ffd.vhd, reg_Nb.vhd, sum_Nb.vhd, sum_1b.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity BCD_counter is
  generic(
    N: natural := 4
  );
  port(
    clk_m1: in std_logic; -- Clock master
    rst_m1: in std_logic; -- Reset master
    ena_m1: in std_logic; -- Enable master
    count: out std_logic_vector(N-1 downto 0); -- Cuenta
    max: out std_logic -- Cuenta maxima
  );
end;

architecture BCD_counter_arq of BCD_counter is
----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar de salida "count"
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para Incrementador
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal comp_aux: std_logic; -- Auxiliar para salida de comparador
constant b_aux: std_logic_vector(N-1 downto 0):= "0001";

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  reg0: entity work.reg_Nb
    generic map(N => N)
    port map(
      clk_m => clk_m1,
      rst_m => rst_aux,
      ena_m => ena_m1,
      D_reg => Dinc_aux,
      Q_reg => Qreg_aux
    );

  sumNb0: entity work.sum_Nb
    generic map(N => N)
    port map(
      a_i => Qreg_aux,
      b_i => b_aux,
      c_i => '0',
      s_o => Dinc_aux,
      c_o => open
    );

  rst_aux <= comp_aux or rst_m1; -- Reset
  comp_aux <= Qreg_aux(0) and (not Qreg_aux(1)) and (not Qreg_aux(2)) and Qreg_aux(3); -- Comparador
  count <= Qreg_aux; -- Cuenta
  max <= comp_aux; -- Maxima cuenta

end;
