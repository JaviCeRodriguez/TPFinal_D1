-- Repositorio para crear vector de datos

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;

package utils is
  -- Variable definida para declarar vectores de 4 bits
  type vectBCD is array (natural range <>) of std_logic_vector(3 downto 0);
end package;