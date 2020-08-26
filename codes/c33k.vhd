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
signal QBCD_aux: std_logic;

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  reg1: entity work.reg_Nb
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
      b => "1000000011101000", -- Comparo con 33000
      s => QBCD_aux
    );

  compNb1: entity work.comp_Nb
    generic map(N => N)
    port map(
      a => Qreg_aux,
      b => "1000000011100111", -- Comparo con 32999
      s => Q_reg
    );
    Q_BCD <= QBCD_aux;
    rst_aux <= QBCD_aux or rst_i; -- Reset
end;
