-- Contador Vertical

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

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
signal rst_aux: std_logic; -- Auxiliar para Reset de registro
signal Dinc_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para incrementador
signal Qreg_aux: std_logic_vector(N-1 downto 0); -- Auxiliar para Q de registro
constant b_aux: std_logic_vector(N-1 downto 0):= "0000000001"; -- Para sumar 1 bit
signal comp_aux: std_logic; -- Auxiliar de comparar con 524 binario

begin
  reg1: entity work.reg_Nb
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
        a => Qreg_aux,      -- Salida reg
        b => "1000001100",  -- Comparo con 524
        s => comp_aux       -- Salida del comparador
    );
    
    count <= Qreg_aux;  -- Cuenta
    max <= comp_aux; -- Indico maxima cuenta
    rst_aux <= comp_aux or rst_i; -- Resetea si alguno es '1'
end;
