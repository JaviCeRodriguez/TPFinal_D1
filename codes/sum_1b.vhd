-- Sumador de 1 bit

library IEEE;
use IEEE.std_logic_1164.all;

entity sum_1b is
  port(
    a_i: in std_logic; -- Entrada A
    b_i: in std_logic; -- Entrada B
    c_i: in std_logic; -- Entrada Carry
    s_o: out std_logic; -- Suma de A+B
    c_o: out std_logic -- Salida Carry
  );
end;

architecture sumb_1b_arq of sum_1b is
begin
  s_o <= a_i xor b_i xor c_i;
  c_o <= (a_i and b_i) or (a_i and c_i) or (b_i and c_i);
end;
