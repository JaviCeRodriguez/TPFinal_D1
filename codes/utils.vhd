-- Repositorio para crear vector de datos

library IEEE;
use IEEE.std_logic_1164.all;

package utils is
  type vectBCD is array (natural range <>) of std_logic_vector(3 downto 0);
end package;