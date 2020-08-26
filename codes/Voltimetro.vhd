library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity Voltimetro is
	port(
		clk_i			: in std_logic;		-- Reloj
		rst_i			: in std_logic;		-- Reset general
--		ena_i			: in std_logic;		-- Habilitador general
		data_volt_in_i	: in std_logic;		-- Entrada de la sucesion de unos y ceros provenientes
											--del ffd de entrada. Se utiliza como habilitador del
											--contador BCD de 5 digitos.
		red_o			: out std_logic;	-- Salida del color rojo
		grn_o			: out std_logic;	-- Salida del color verde
		blu_o			: out std_logic;	-- Salida del color azul
		hs_o			: out std_logic;	-- Sicronismo horizontal
		vs_o			: out std_logic;	-- Sincronismo vertical
		data_volt_out_o	: out std_logic		-- Realimentacion ADC
		);
end;

architecture Voltimetro_arq of Voltimetro is
	signal enchufe1: std_logic;                     -- ADC/cOnes
	signal enchufe2: std_logic;                     -- c33k/Reg
	signal enchufe3: std_logic;                     -- c33k/cOnes
	signal enchufe4: vectBCD(4 downto 0);           -- cOnes/Reg
	signal enchufe5: vectBCD(4 downto 0);           -- Reg/Mux
	signal enchufe6: std_logic_vector(3 downto 0);  -- Mux/ROM
	signal enchufe7: std_logic_vector(9 downto 0);  -- VGA/MUX (pixel x)
	signal enchufe8: std_logic_vector(9 downto 0);  -- VGA/MUX (pixel y)
	signal enchufe9: std_logic;                     -- ROM/VGA
	signal ena_i: std_logic := '1';					-- Enable siempre seteado en 1

begin
	-- ADC SIGMA-DELTA
	ADC: entity work.ADC_sd
		port map(
			clk_i   => clk_i,
			rst_i   => rst_i,
			ena_i   => ena_i,
			D_vi    => data_volt_in_i,
			Q_fb	=> data_volt_out_o,
			Q_proc	=> enchufe1
		);

	-- CONTADOR DE UNOS
	contUnos: entity work.cOnes
		generic map(
			N => 5, -- 5 contadores BCD
			M => 4 -- Bits de registro p/contador
		)
		port map(
			clk_i => clk_i, -- Clock
			rst_i => enchufe3, -- Reset controlado por contador binario
			ena_i => enchufe1, -- Entrada del bloque de procesamiento y control
			BCD_o => enchufe4 -- Salida (entrada de registro)
		);

	-- CONTADOR BINARIO
	contBin: entity work.c33k
		generic map(
			N => 16 -- Bits del contador
		)
		port map(
			clk_i => clk_i, -- Clock
			rst_i => rst_i, -- Reset
			ena_i => ena_i, -- Enable
			Q_BCD => enchufe3, -- Reset de cOnes
			Q_reg => enchufe2 -- Enable de Registro
		);

	-- REGISTRO DE TENSION
	reg_gen: for x in 0 to 4 generate
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
			BCD0  => enchufe5(2), -- Desde aca ...
			point => "1010",
			BCD1  => enchufe5(3),
			BCD2  => enchufe5(4),
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
			clk_i   => clk_i,
			rst_i   => rst_i,
			red_i   => enchufe9,
			grn_i   => enchufe9,
			blu_i   => '1',
			hsync   => hs_o,
			vsync   => vs_o,
			red_o   => red_o,
			grn_o   => grn_o,
			blu_o   => blu_o,
			pixel_x => enchufe7,
			pixel_y => enchufe8
		);
end;
