-- Contador BCD
-- Utilizo: ffd.vhd, reg_Nb.vhd, sum_Nb.vhd, sum_1b.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity BCD_counter is
  generic(
    N: natural := 4
  );
  port(
    clk_i: in std_logic; -- Clock master
    rst_i: in std_logic; -- Reset master
    ena_i: in std_logic; -- Enable master
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
signal andcomp: std_logic;
constant b_aux: std_logic_vector(N-1 downto 0):= "0001";

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  reg0: entity work.reg_Nb
    generic map(N => N)
    port map(
      clk_i => clk_i,
      rst_i => rst_aux,
      ena_i => ena_i,
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

  compNb0: entity work.comp_Nb
    generic map(N => N)
    port map(
      a => Qreg_aux,
      b => "1001", -- Comparo con 9
      s => comp_aux
    );
  rst_aux <= andcomp or rst_i; -- Reset
  andcomp <= comp_aux and ena_i;
  count <= Qreg_aux; -- Cuenta
  max <= comp_aux; -- Maxima cuenta

end;
