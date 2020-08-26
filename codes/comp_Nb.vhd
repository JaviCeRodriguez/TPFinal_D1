library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Componente: Comparador
-- Obtengo un uno cuando dos entradas son iguales

entity comp_Nb is
	generic( -- doy un valor generico que puedo cambiar cuando lo use
		N: natural := 10
	);
	 
	port(
		a: in std_logic_vector(N-1 downto 0); -- primer numero a comparar
		b: in std_logic_vector(N-1 downto 0); -- segundo numero a comparar
		s: out std_logic -- si ambos numeros son iguales obtengo un uno
	);
end;

architecture comp_Nb_arq of comp_Nb is

    signal and_aux: std_logic_vector(N downto 0);
    signal xnor_aux: std_logic_vector(N-1 downto 0);
	
begin
--si son iguales dos numeros devuelve 1
	and_aux(0) <= '1';
	
	gene: for i in 0 to N-1 generate
		xnor_aux(i) <= a(i) xnor b(i); -- para cada bit obtengo un uno si los digitos son iguales
		and_aux(i+1) <= xnor_aux(i) and and_aux(i); -- si ya obtengo una posicion con distintos valores obtendre todo cero
	end generate;
	
	s <= and_aux(N); -- guardo el ultimo valor del and, si todos fueron unos, obtengo un uno
	
end;