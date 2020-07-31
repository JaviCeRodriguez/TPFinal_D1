-- ADC Sigma Delta
-- Utilizo: ffd.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity ADC_sd is
  port(
    clk_m: in std_logic; -- Clock master
    rst_m: in std_logic; -- Reset master
    ena_m: in std_logic; -- Enable master
    D_vi: in std_logic; -- Pin D6 de FPGA
    Q_fb: out std_logic; -- Pin D5 de FPGA
    Q_proc: out std_logic -- Para bloque de procesamiento
  );
end;

architecture ADC_sd_arq of ADC_sd is
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

----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal Q_aux: std_logic; -- Cable auxiliar para Q de ffd

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  ffd0: ffd
    port map(
      clk_i =>  clk_m,
      rst_i =>  rst_m,
      ena_i =>  ena_m,
      D_i   =>  D_vi,
      Q_o   =>  Q_aux
    );
  Q_fb <= not Q_aux;
  Q_proc <= Q_aux;
end;
