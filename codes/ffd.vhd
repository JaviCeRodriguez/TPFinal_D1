-- Flip Flop D con reset y enable

library IEEE;
use IEEE.std_logic_1164.all;

entity ffd is
	port(
		clk_i: in std_logic; -- Clock
		rst_i: in std_logic; -- Reset
		ena_i: in std_logic; -- Enable
		D_i: in std_logic; -- Dato
		Q_o: out std_logic -- Salida
	);
end;

architecture ffd_arq of ffd is
----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			if rst_i = '1' then
				Q_o <= '0';
			elsif ena_i = '1' then
				Q_o <= D_i;
			end if;
		end if;
	end process;
end;
