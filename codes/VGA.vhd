-- Generadora de sincronismo (VGA)
-- Utilizo: ffd.vhd, cHor.vhd, cVer.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VGA is
  generic(
    N: natural := 10 -- Bits de contadores y otros
  );
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; --Reset
    red_i: in std_logic; -- Entrada para rojo
    grn_i: in std_logic; -- Entrada para verde
    blu_i: in std_logic; -- Entrada para azul
    hsync: out std_logic; -- Sincronismo horizontal
    vsync: out std_logic; -- Sincronismo vertical
    red_o: out std_logic; -- Salida para rojo
    grn_o: out std_logic; -- Salida para verde
    blu_o: out std_logic; -- Salida para azul
    pixel_x: out std_logic_vector(9 downto 0); -- Posicion horizontal
    pixel_y: out std_logic_vector(9 downto 0) -- Posicion vertical
  );
end;

architecture VGA_arq of VGA is
signal maxEna: std_logic; -- Enable para vertical
signal cHori: std_logic_vector(N-1 downto 0); -- Entrada comparadores / Salida pixel_x
signal cVert: std_logic_vector(N-1 downto 0); -- Entrada comparadores / Salida pixel_y
signal rstH_aux, rstV_aux: std_logic; -- Salidas de OR para reset de ffd
signal compEnaH, compRstH: std_logic; -- Salidas de comparadores para horizontal
signal compEnaV, compRstV: std_logic; -- Salidas de comparadores para vertical
signal vidH, vidV: std_logic; -- Vidon de horizontal y vertical
signal vidon: std_logic; -- Vidon auxiliar

begin
  -- HORIZONTAL
  -- Pulso ascendente: 656 pixeles
  -- Pulso descendente: 751 pixeles
  pixel_x <= cHori;
  rstH_aux <= rst_i or compRstH;
  -- Contador (Hasta 800)
    contH: entity work.cHor
    generic map (N => N)
    port map(
      clk_i => clk_i, -- Clock del sistema
      rst_i => rst_i, -- Reset del sistema
      ena_i => '1', -- Enable siempre activo
      max   => maxEna, -- Enable para vertical
      count => cHori -- Entrada comparadores / Salida pixel_x
    );
  -- Flip Flop D
    ffdH: entity work.ffd
    port map(
      clk_i =>  clk_i,
      rst_i =>  rstH_aux, -- Salida de OR
      ena_i =>  compEnaH, -- Salida de comparador
      D_i   =>  '1', -- D siempre en 1
      Q_o   =>  hsync -- Sincronismo horizontal
    );
  -- Comparadores de pulsos asc y desc de hsync (harcodeados)
    compNb0: entity work.comp_Nb
    generic map(N => N)
    port map(
        a => cHori,
        b => "1010010000", -- Comparo con 656
        s => compEnaH
    );
    compNb1: entity work.comp_Nb
      generic map(N => N)
      port map(
          a => cHori,
          b => "1011101111", -- Comparo con 752-1
          s => compRstH
      );

  -- VERTICAL
  -- Pulso ascendente: 490 lineas (1 1110 1010)
  -- Pulso descendente: 492 lineas (1 1110 1100)
    pixel_y <= cVert;
    rstV_aux <= rst_i or compRstV;
  -- Contador (Hasta 522)
    contV: entity work.cVer
      generic map (N => N)
      port map(
        clk_i => clk_i,
        rst_i => rst_i,
        ena_i => maxEna,
        max   => open,
        count => cVert -- Entrada comparadores / Salida pixel_y
      );
  -- Flip Flop D
    ffdV: entity work.ffd
      port map(
        clk_i =>  clk_i,
        rst_i =>  rstV_aux, -- Salida de OR
        ena_i =>  compEnaV, -- Salida de comparador
        D_i   =>  '1', -- D siempre en 1
        Q_o   =>  vsync -- Sincronismo vertical
      );
  -- Comparadores de pulsos asc y desc de vsync (harcodeados)
    compNb2: entity work.comp_Nb
        generic map(N => N)
        port map(
            a => cVert,
            b => "0111101010", -- Comparo con 490
            s => compEnaV
        );
    compNb3: entity work.comp_Nb
        generic map(N => N)
        port map(
            a => cVert,
            b => "0111101011", -- Comparo con 492-1
            s => compRstV
        );

  -- VIDON
  vidon <= vidH and vidV; -- Si vidH y vidV son '1', activo vidon
  -- Vidon Horizontal
  vidH <= not cHori(9) or (not cHori(8) and not cHori(7));
--  vidH <= cHori(9) and (not cHori(8)) and
--          cHori(7) and (not cHori(6)) and (not cHori(5)) and (not cHori(4)) and
--          (not cHori(3)) and (not cHori(2)) and (not cHori(1)) and (not cHori(0));
  -- Vidon Vertical
  vidV <= not cVert(8) and cVert(7);
--  vidV <= (not cVert(9)) and cVert(8) and
--          cVert(7) and cVert(6) and cVert(5) and (not cVert(4)) and
--          (not cHori(3)) and (not cHori(2)) and (not cHori(1)) and (not cHori(0));

  -- RGB OUT
  red_o <= red_i and vidon;
  blu_o <= blu_i and vidon;
  grn_o <= grn_i and vidon;
end;
