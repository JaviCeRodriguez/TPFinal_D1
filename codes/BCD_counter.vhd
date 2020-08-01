-- Contador BCD
-- Utilizo: ffd.vhd, reg_4b.vhd

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
    count: out std_logic_vector; -- Cuenta
    max: out std_logic -- Cuenta maxima
  );
end;

architecture BCD_counter_arq of BCD_counter is
----------------------------------------------
--              Componentes                 --
----------------------------------------------
component ffd -- Invoco codigo de Flip Flop D
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    D_i: in std_logic; -- Dato
    Q_o: out std_logic -- Salida
  );
end component;
component reg_4b
  port(
    clk_m: in std_logic; -- Clock master
    rst_m: in std_logic; -- Reset master
    ena_m: in std_logic; -- Enable master
    D_reg: in std_logic_vector(N-1 downto 0); -- Entrada de 4 bits
    Q_reg: out std_logic_vector(N-1 downto 0) -- Entrada de 4 bits
  );
end component;

----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar de salida "count"
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar de salida de incrementador
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal comp_aux: std_logic; -- Auxiliar para salida de comparador
signal increm: std_logic(N-1 downto 0); -- Incrementador
----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  reg0: reg_4b
    port map(
      clk_m => clk_m1,
      rst_m => rst_aux,
      ena_m => ena_m1,
      D_reg => Dinc_aux,
      Q_reg => Qreg_aux
    );

  rst_aux <= comp_aux or rst_m1; -- Reset
  increm <= std_logic_vector(unsigned(Qreg_aux) + 1); -- Incrementador
  comp_aux <= Qreg_aux(0) and (not Qreg_aux(1)) and (not Qreg_aux(2)) and Qreg_aux(3); -- Comparador
  count <= Qreg_aux; -- Cuenta
  max <= comp_aux; -- Maxima cuenta

end;
