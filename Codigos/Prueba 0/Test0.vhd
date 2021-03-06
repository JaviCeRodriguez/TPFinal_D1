-- Codigo para probar voltimetro sin parte analogica
-- Utilizo todos los códigos con el generador de pulsos (menos el ADC)
-- ATENCION: Hay leves diferencias con el código Voltimetro.vhd

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity Test0 is
	port(
		clk_i			: in std_logic;		-- Clock
		rst_i			: in std_logic;		-- Reset
		ena_i			: in std_logic;		-- Enable
		red_o			: out std_logic;	-- Salida del color rojo
		grn_o			: out std_logic;	-- Salida del color verde
		blu_o			: out std_logic;	-- Salida del color azul
		hs_o			: out std_logic;	-- Sicronismo horizontal
		vs_o			: out std_logic	-- Sincronismo vertical
		);
end;

architecture Test0_arq of Test0 is              -- In/Out
	signal enchufe1: std_logic;                     -- ADC/cOnes
	signal enchufe2: std_logic;                     -- c33k/Reg
	signal enchufe3: std_logic;                     -- c33k/cOnes
	signal enchufe4: vectBCD(6 downto 0);           -- cOnes/Rega
	signal enchufe5: vectBCD(6 downto 0);          	-- Reg/Mux
	signal enchufe6: std_logic_vector(3 downto 0);  -- Mux/ROM
	signal enchufe7: std_logic_vector(9 downto 0);  -- VGA/MUX (pixel x)
	signal enchufe8: std_logic_vector(9 downto 0);  -- VGA/MUX (pixel y)
	signal enchufe9: std_logic;                     -- ROM/VGA

begin
  -- ENTRADA DIGITALIZADA AL BLOQUE PRINCIPAL
  entrada: entity work.genPulsos_Voltimetro
    generic map(
      N => 4, -- Cantidad de 1's en el ciclo
      M => 4 -- Cantidad de 0's en el ciclo
    )
    port map(
      clk_i => clk_i, -- Clock
      sal_o => enchufe1 -- Al contador de 1's
    );

	-- CONTADOR DE UNOS
	contUnos: entity work.cOnes
		generic map(
			N => 7, -- 7 contadores BCD
			M => 4 	-- Bits de registro p/contador
		)
		port map(
			clk_i => clk_i, 	-- Clock
			rst_i => enchufe3, 	-- Reset controlado por contador binario
			ena_i => enchufe1, 	-- Entrada del bloque de procesamiento y control
			BCD_o => enchufe4 	-- Salida (entrada de registro)
		);

	-- CONTADOR BINARIO
	contBin: entity work.c33k
		generic map(
			N => 22 -- Bits del contador
		)
		port map(
			clk_i => clk_i,		-- Clock
			rst_i => rst_i, 	-- Reset
			ena_i => ena_i, 	-- Enable
			Q_BCD => enchufe3, 	-- Reset de cOnes
			Q_reg => enchufe2 	-- Enable de Registro
		);

	-- REGISTRO DE TENSION
	reg_gen: for x in 0 to 6 generate
		regNx: entity work.reg_Nb
			generic map(
				N => 4 -- Bits de de c/entrada del registro
			)
			port map(
				clk_i => clk_i, -- Clock
				rst_i => rst_i, -- Reset
				ena_i => enchufe2, -- Enable controlado por contador binario
				D_reg => enchufe4(x), -- Entradas del registro
				Q_reg => enchufe5(x) -- Salida hacia Mux
			);
	end generate reg_gen;

	-- MULTIPLEXOR
	muxBCD: entity work.mux
		port map(
			BCD0  => enchufe5(3), -- Desde aca ...
			point => "1010",
			BCD1  => enchufe5(5),
			BCD2  => enchufe5(6),
			volt  => "1011", -- hasta aca, datos entrantes del registro de tension
			sel   => enchufe7(9 downto 7), -- Pixel x de VGA
			F_o   => enchufe6 -- Salida hacia ROM
		);

	-- ROM
	ROMcito: entity work.ROM
		port map(
			fHor    => enchufe7(6 downto 4), -- Posicion X controlada por VGA
			fVer    => enchufe8(6 downto 4), -- Posicion Y controlada por VGA
			Addr    => enchufe6, -- Datos entrantes de MUX
			sROM_o  => enchufe9 -- Salida hacia VGA
		);

	-- VGA
	Monitor4K: entity work.VGA
		port map(
			clk_i   => clk_i,		-- Clock
			rst_i   => rst_i,		-- Reset
			red_i   => enchufe9,	-- Entrada rojo
			grn_i   => enchufe9,	-- Entrada verde
			blu_i   => '1',			-- Entrada azul
			hsync   => hs_o,		-- Sincronismo horizontal
			vsync   => vs_o,		-- Sincronismo vertical
			red_o   => red_o,		-- Salida rojo
			grn_o   => grn_o,		-- Salida verde
			blu_o   => blu_o,		-- Salida azul
			pixel_x => enchufe7,	-- Pixel x
			pixel_y => enchufe8		-- Pixel y
		);
end;
