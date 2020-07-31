-- Registro de 4 bits
-- Utilizo: ffd.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_4b is
  generic(
    N: natural := 4
  );
  port(
    clk_m: in std_logic; -- Clock master
    rst_m: in std_logic; -- Reset master
    ena_m: in std_logic; -- Enable master
    D_reg: in std_logic_vector(N-1 downto 0); -- Entrada de 4 bits
    Q_reg: out std_logic_vector(N-1 downto 0) -- Entrada de 4 bits
  );
end;

architecture reg_4b_arq of reg_4b is
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
--              Arquitectura                --
----------------------------------------------
begin
  ffd_gen: for x in 0 to N-1 generate
    ffdx: ffd
      port map(
        clk_i =>  clk_m,
        rst_i =>  rst_m,
        ena_i =>  ena_m,
        D_i   =>  D_reg(x),
        Q_o   =>  D_reg(x)
      );
  end generate ffd_gen;
end;
