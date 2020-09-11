-- Comparador de N bits

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity comp_Nb is
	generic(N: natural := 10);
	port(
		a: in std_logic_vector(N-1 downto 0); 	-- Primer numero a comparar
		b: in std_logic_vector(N-1 downto 0); 	-- Segundo numero a comparar
		s: out std_logic 						-- Si ambos numeros son iguales, obtengo un uno
	);
end;

architecture comp_Nb_arq of comp_Nb is
    signal and_aux: std_logic_vector(N downto 0);
    signal xnor_aux: std_logic_vector(N-1 downto 0);
	
begin
	gene: for i in 0 to N-1 generate
		xnor_aux(i) <= a(i) xnor b(i); -- para cada bit obtengo un uno si los digitos son iguales
		and_aux(i+1) <= xnor_aux(i) and and_aux(i); -- si ya obtengo una posicion con distintos valores obtendre todo cero
	end generate;
	and_aux(0) <= '1';
	s <= and_aux(N); -- Guardo el ultimo valor de compuerta AND
	
end;