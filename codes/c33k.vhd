-- Contador de 3 300 000 bits

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;

entity c33k is
  generic(
    N: natural := 16
  );
  port(
    clk_i: in std_logic;  -- Clock
    rst_i: in std_logic;  -- Reset
    ena_i: in std_logic;  -- Enable
    Q_BCD: out std_logic; -- Reset para contador de unos
    Q_reg: out std_logic  -- Enable para registro
  );
end;

architecture c33k_arq of C33k is
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para incrementador
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para Q de registro
constant b_aux: std_logic_vector(N-1 downto 0):= "0000000000000000000001";
signal QBCD_aux: std_logic;

begin
  reg1: entity work.reg_Nb
    generic map(N => N)
    port map(
      clk_i => clk_i,       -- Clock
      rst_i => rst_aux,     -- Reset
      ena_i => ena_i,       -- Enable
      D_reg => Dinc_aux,    -- Entrada reg
      Q_reg => Qreg_aux     -- Salida reg
    );

  sumNb0: entity work.sum_Nb
    generic map(N => N)
    port map(
      a_i => Qreg_aux,      -- Salida reg
      b_i => b_aux,         -- 1
      c_i => '0',           -- Carry de entrada
      s_o => Dinc_aux,      -- Salida reg + 1
      c_o => open           -- Carry de salida
    );

  compNb0: entity work.comp_Nb
    generic map(N => N)
    port map(
      a => Qreg_aux,                  -- Salida reg
      b => "1100100101101010100000",  -- Comparo con 3300000
      s => QBCD_aux                   -- Salida del comparador
    );

  compNb1: entity work.comp_Nb
    generic map(N => N)
    port map(
      a => Qreg_aux,                  -- Salida reg
      b => "1100100101101010011111",  -- Comparo con 3299999
      s => Q_reg                      -- Salida del comparador
    );
    Q_BCD <= QBCD_aux;            -- Salida del comparador
    rst_aux <= QBCD_aux or rst_i; -- Reset
end;
