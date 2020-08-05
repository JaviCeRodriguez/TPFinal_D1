-- Multiplexor de entradas de 4 bits para registro BCD

library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity mux is
  port(
    BCD0: in std_logic_vector(3 downto 0);
    point: in std_logic_vector(3 downto 0);
    BCD1: in std_logic_vector(3 downto 0);
    BCD2: in std_logic_vector(3 downto 0);
    volt: in std_logic_vector(3 downto 0);
    sel: in std_logic_vector(2 downto 0);
    F_o: out std_logic_vector(3 downto 0)
  );
end;

architecture mux_arq of mux is
----------------------------------------------
--                Seniales                  --
----------------------------------------------
signal pos: std_logic_vector(4 downto 0);
signal bus_m: vectBCD(4 downto 0); -- Para comparar entrada con la posicion del mux
signal bus_o: vectBCD(4 downto 0); -- Para conectar entrada con salida

----------------------------------------------
--              Arquitectura                --
----------------------------------------------
begin
  enchufe: for i in 0 to 4 generate
    bus_o(i) <= (bus_m(i)(3) and pos(i)) &
                (bus_m(i)(2) and pos(i)) &
                (bus_m(i)(1) and pos(i)) &
                (bus_m(i)(0) and pos(i));
  end generate enchufe;

  pos(0) <= not (sel(2) or sel(1) or sel(0));         -- 000: BCD0
  pos(1) <= (not sel(2)) and (not sel(1)) and sel(0); -- 001: point
  pos(2) <= (not sel(2)) and sel(1) and (not sel(0)); -- 010: BCD1
  pos(3) <= (not sel(2)) and sel(1) and sel(0);       -- 011: BCD2
  pos(4) <= sel(2) and (not sel(1)) and (not sel(0)); -- 100: volt

  bus_m(0) <= BCD0;
  bus_m(1) <= point;
  bus_m(2) <= BCD1;
  bus_m(3) <= BCD2;
  bus_m(4) <= volt;

  F_o <= bus_o(4) or bus_o(3) or bus_o(2) or bus_o(1) or bus_o(0);
end;
