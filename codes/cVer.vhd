-- Contador Vertical
-- Utilizo: ffd.vhd, reg_Nb.vhad, sum_Nb.vhd, sum_1b.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity cVer is
  generic(
    N: natural := 10 -- Bits del contador / Tamanio de registro
  );
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    max: out std_logic; -- Cuenta máxima (524)
    count: out std_logic_vector(N-1 downto 0) -- Cuenta (0 a 524)
  );
end;

architecture cVer_arq of cVer is
----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para incrementador
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para Q de registro
constant b_aux: std_logic_vector(N-1 downto 0):= "0000000001"; -- Para sumar 1 bit
signal comp_aux: std_logic; -- Auxiliar de comparar con 524 binario

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
        b => "1000001100", -- Comparo con 524
        s => comp_aux
    );
    
    count <= Qreg_aux;
    max <= comp_aux; -- Indico maxima cuenta
    rst_aux <= comp_aux or rst_i; -- Resetea si alguno es '1'

    -- comp_aux es 1 si Qreg_aux es 10 0000 1100
--    comp_aux <= Qreg_aux(9) and (not Qreg_aux(8)) and
--                (not Qreg_aux(7)) and (not Qreg_aux(6)) and (not Qreg_aux(5)) and (not Qreg_aux(4)) and
--                Qreg_aux(3) and Qreg_aux(2) and (not Qreg_aux(1)) and (not Qreg_aux(0));
end;
