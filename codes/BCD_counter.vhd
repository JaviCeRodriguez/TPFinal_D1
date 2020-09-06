-- Contador BCD

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

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
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar de salida "count"
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para Incrementador
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal comp_aux: std_logic; -- Auxiliar para salida de comparador
signal andcomp: std_logic;
constant b_aux: std_logic_vector(N-1 downto 0):= "0001";

begin
  reg0: entity work.reg_Nb
    generic map(N => N)
    port map(
      clk_i => clk_i,     -- Clock
      rst_i => rst_aux,   -- Reset
      ena_i => ena_i,     -- Enable
      D_reg => Dinc_aux,  -- Entrada reg
      Q_reg => Qreg_aux   -- Salida reg
    );

  sumNb0: entity work.sum_Nb
    generic map(N => N)
    port map(
      a_i => Qreg_aux,    -- Salida reg
      b_i => b_aux,       -- 1
      c_i => '0',         -- Carry de entrada
      s_o => Dinc_aux,    -- Salida reg + 1
      c_o => open         -- Carry de salida
    );

  compNb0: entity work.comp_Nb
    generic map(N => N)
    port map(
      a => Qreg_aux,  -- Salida reg
      b => "1001",    -- Comparo con 9
      s => comp_aux   -- Salida del comparador
    );
  rst_aux <= andcomp or rst_i;    -- Reset
  andcomp <= comp_aux and ena_i;  -- AND entre comparador y enable
  count <= Qreg_aux;              -- Cuenta
  max <= comp_aux;                -- Maxima cuenta

end;
