--- ROM con caracteres almacenados

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM is
  port(
    fHor: in std_logic_vector(2 downto 0); -- Bits 9 downto 7 de pixel x
    fVer: in std_logic_vector(2 downto 0); -- Bits 9 downto 7 de pixel y
    Addr: in std_logic_vector(3 downto 0); -- Bus de datos del multiplexor
    sROM_o: out std_logic                  -- Salida serie de ROM
  );
end;

architecture ROM_arq of ROM is
signal AddrVer: std_logic_vector(6 downto 0);
type neo is array (0 to 95) of std_logic_vector(0 to 7);
-- El indice de pixChar es Addr unido a fVer (transformado a entero)
constant pixChar: neo := ("00000000",
                          "00111100", 
                          "01000110", 
                          "01001010", 
                          "01010010", 
                          "01100010", 
                          "00111100", 
                          "00000000", -- 0: 0000

                          "00000000", 
                          "00001000", 
                          "00011000", 
                          "00101000", 
                          "00001000", 
                          "00001000", 
                          "00111100", 
                          "00000000", -- 1: 0001

                          "00000000", 
                          "00111100", 
                          "01000010", 
                          "00000100", 
                          "00001000", 
                          "00110000", 
                          "01111110", 
                          "00000000", -- 2: 0010

                          "00000000", 
                          "01111100", 
                          "00000010", 
                          "00111110", 
                          "00000010", 
                          "00000010", 
                          "01111100", 
                          "00000000", -- 3: 0011

                          "00000000", 
                          "00001100", 
                          "00010100", 
                          "00100100", 
                          "01111110", 
                          "00000100", 
                          "00000100", 
                          "00000000", -- 4: 0100

                          "00000000", 
                          "01111100", 
                          "01000000", 
                          "01111100", 
                          "00000010", 
                          "00000010", 
                          "01111100", 
                          "00000000", -- 5: 0101

                          "00000000", 
                          "00111100", 
                          "01000000", 
                          "01111100", 
                          "01000010", 
                          "01000010", 
                          "00111100", 
                          "00000000", -- 6: 0110

                          "00000000", 
                          "01111110", 
                          "00000110", 
                          "00001000", 
                          "00010000", 
                          "00100000", 
                          "00100000", 
                          "00000000", -- 7: 0111

                          "00000000", 
                          "00111100", 
                          "01000010", 
                          "01111110", 
                          "01000010", 
                          "01000010", 
                          "00111100", 
                          "00000000", -- 8: 1000

                          "00000000", 
                          "00111100", 
                          "01000010", 
                          "01000010", 
                          "00111110", 
                          "00000010", 
                          "01111100", 
                          "00000000", -- 9: 1001

                          "00000000", 
                          "00000000", 
                          "00000000", 
                          "00000000", 
                          "00000000", 
                          "00011000", 
                          "00011000", 
                          "00000000", -- .: 1010

                          "00000000", 
                          "01000010", 
                          "01000010", 
                          "00100100", 
                          "00100100", 
                          "00011000", 
                          "00011000", 
                          "00000000"); -- V: 1011

begin
  AddrVer <= Addr & fVer; -- Uno los datos de Addr y fVer
  sROM_o <= pixChar(to_integer(unsigned(AddrVer)))(to_integer(unsigned(fHor))); -- Tomo un pixel (bit) de pixChar
end;
