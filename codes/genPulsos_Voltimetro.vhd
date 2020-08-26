--
--	N=2 y M=1  ('1' durante dos ciclos de reloj y '0' durante un ciclo de reloj)
--        _   _   _   _   _   _   _
--	clk	_| |_| |_| |_| |_| |_| |_| |_
--        _______     _______     _______
--  sal _|       |___|       |___|
--

library IEEE;
use IEEE.std_logic_1164.all;

entity genPulsos_Voltimetro is
	generic(
		N: natural := 4;	-- cantidad de '1' en el ciclo
		M: natural := 2		-- cantidad de '0' en el ciclo
	);
  port(
		clk_i: in std_logic;
    sal_o: out std_logic
  );
end;

architecture genPulsos_Voltimetro_arq of genPulsos_Voltimetro is

begin
	aaa: process(clk_i)
		variable unos, ceros: natural := 0;
	begin
		if rising_edge(clk_i) then
			if unos < N then
				unos := unos + 1;
				sal_o <= '1';
			else
				if ceros < M-1 then
					ceros := ceros + 1;
					sal_o <= '0';
				else
					unos := 0;
					ceros := 0;
					sal_o <= '0';
				end if;
			end if;

		end if;
	end process;

end;
