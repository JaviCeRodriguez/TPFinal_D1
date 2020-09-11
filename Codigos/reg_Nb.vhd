-- Registro de 4 bits

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_Nb is
  generic(
    N: natural := 4
  );
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    D_reg: in std_logic_vector(N-1 downto 0); -- Entrada de 4 bits
    Q_reg: out std_logic_vector(N-1 downto 0) -- Entrada de 4 bits
  );
end;

architecture reg_Nb_arq of reg_Nb is
component ffd -- Invoco codigo de Flip Flop D
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    D_i: in std_logic; -- Dato
    Q_o: out std_logic -- Salida
  );
end component;

begin
  ffd_gen: for x in 0 to N-1 generate -- Genero registros de 4 bits
    ffdx: ffd
      port map(
        clk_i =>  clk_i,    -- Clock
        rst_i =>  rst_i,    -- Reset
        ena_i =>  ena_i,    -- Enable
        D_i   =>  D_reg(x), -- D
        Q_o   =>  Q_reg(x)  -- Q
      );
  end generate ffd_gen;
end;
