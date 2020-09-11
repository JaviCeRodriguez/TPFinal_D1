-- ADC Sigma Delta

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;

entity ADC_sd is
  port(
    clk_i: in std_logic;  -- Clock
    rst_i: in std_logic;  -- Reset
    ena_i: in std_logic;  -- Enable
    D_vi: in std_logic;   -- Señal de entrada
    Q_fb: out std_logic;  -- Realimentacion
    Q_proc: out std_logic -- Bloque de procesamiento
  );
end;

architecture ADC_sd_arq of ADC_sd is
component ffd -- Invoco codigo de Flip Flop D
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    D_i: in std_logic; -- Dato
    Q_o: out std_logic -- Salida
  );
end component;

signal Q_aux: std_logic; -- Cable auxiliar para Q de ffd

begin
  ffd0: ffd
    port map(
      clk_i =>  clk_i,
      rst_i =>  rst_i,
      ena_i =>  ena_i,
      D_i   =>  D_vi,
      Q_o   =>  Q_aux
    );
  Q_fb <= not Q_aux;
  Q_proc <= Q_aux;
end;
