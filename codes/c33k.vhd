-- Contador de 33000 bits
-- Utilizo: ffd.vhd, reg_Nb.vhad, sum_Nb.vhd, sum_1b.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity c33k is
  generic(
    N: natural := 16
  );
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    Q_BCD: out std_logic; -- Reset para contador BCD (cBCD.vhd)
    Q_reg: out std_logic -- Enable para registro
  );
end;

architecture c33k_arq of C33k is
----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para incrementador
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para Q de registro
constant b_aux: std_logic_vector(N-1 downto 0):= "0000000000000001";
signal comp_aux: std_logic; -- Auxiliar de reset por comparador
signal comp1_aux: std_logic; -- Auxiliar de una parte de comparador
signal QBCD_aux: std_logic;

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  reg1: entity work.reg_Nb
    generic map(N => N)
    port map(
      clk_m => clk_i,
      rst_m => rst_aux,
      ena_m => ena_i,
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

    rst_aux <= comp_aux or rst_i; -- Reset
    comp1_aux <=  (Qreg_aux(15) and (not Qreg_aux(14)) and (not Qreg_aux(13)) and (not Qreg_aux(12))) and
                  ((not Qreg_aux(11)) and (not Qreg_aux(10)) and (not Qreg_aux(9)) and (not Qreg_aux(8))) and
                  (Qreg_aux(7) and Qreg_aux(6) and Qreg_aux(5) and (not Qreg_aux(4)));
    QBCD_aux <= not (Qreg_aux(3) and (not Qreg_aux(2)) and (not Qreg_aux(1)) and (not Qreg_aux(0)) and comp1_aux);
    Q_reg <=  ((not Qreg_aux(3)) and Qreg_aux(2) and Qreg_aux(1) and Qreg_aux(0) and comp1_aux) or
              ((not QBCD_aux) and comp1_aux);
    comp_aux <= not QBCD_aux;
    Q_BCD <= QBCD_aux;
end;
