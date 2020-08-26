----------------------------------------------------------------------------------
-- Modulo: 		Voltimetro_toplevel
-- Descripcion: Voltimetro implementado con un modulador sigma-delta
-- Autor: 		Electronica Digital I
--        		Universidad de San Martn - Escuela de Ciencia y Tecnologia
--
-- Fecha: 		18/08/20
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Voltimetro_toplevel is
	port(
		clk_i			: in std_logic;
		rst_i			: in std_logic;
		data_volt_in_i	: in std_logic;
		data_volt_out_o	: out std_logic;
		hs_o 			: out std_logic;
		vs_o 			: out std_logic;
		red_o 			: out std_logic;
		grn_o 			: out std_logic;
		blu_o 			: out std_logic
	);

	-- Mapeo de pines para el kit Arty A7-35
	attribute loc		: string;
	attribute iostandard: string;

	attribute loc 			of clk_i : signal is "E3";					-- reloj del sistema (100 MHz)
	attribute iostandard 	of clk_i : signal is "LVCMOS33";
	attribute loc 			of rst_i : signal is "D9";					-- senal de reset (boton 0)
	attribute iostandard 	of rst_i : signal is "LVCMOS33";

	-- Entradas simple
	attribute loc 			of data_volt_in_i: signal is "D4";			-- entrada
	attribute iostandard 	of data_volt_in_i: signal is "LVCMOS33";

	-- Salida realimentada
	attribute loc 			of data_volt_out_o: signal is "F3";			-- realimentacion
	attribute iostandard 	of data_volt_out_o: signal is "LVCMOS33";

	-- VGA
	attribute loc 			of hs_o  : signal is "D12";					-- sincronismo horizontal
	attribute iostandard 	of hs_o  : signal is "LVCMOS33";
	attribute loc 			of vs_o  : signal is "K16";					-- sincronismo vertical
	attribute iostandard 	of vs_o  : signal is "LVCMOS33";
	attribute loc 			of red_o : signal is "G13";					-- salida color rojo
	attribute iostandard 	of red_o : signal is "LVCMOS33";
	attribute loc 			of grn_o : signal is "B11";					-- salida color verde
	attribute iostandard 	of grn_o : signal is "LVCMOS33";
	attribute loc 			of blu_o : signal is "A11";					-- salida color azul
	attribute iostandard 	of blu_o : signal is "LVCMOS33";

end Voltimetro_toplevel;

architecture Voltimetro_toplevel_arq of Voltimetro_toplevel is

	-- Declaracion del componente voltimetro
	component Voltimetro is
		port(
			clk_i: in std_logic;
			rst_i: in std_logic;
			data_volt_in_i: in std_logic;
			data_volt_out_o: out std_logic;
			hs_o : out std_logic;
			vs_o : out std_logic;
			red_o : out std_logic;
			grn_o : out std_logic;
			blu_o : out std_logic
		);
	end component Voltimetro;

	-- Declaracion del compoente generador de reloj (MMCM - Mixed Mode Clock Manager)
	component clk_generator
		port (
			-- Clock in ports
			clk_i: in std_logic;
	  		-- Clock out ports
	  		clk_o: out std_logic
	 );
	end component;

	signal clk25MHz: std_logic;

begin

	-- Generador del reloj lento
	clk25MHz_gen : clk_generator
   		port map (
   			clk_i	=> clk_i,		-- reloj del sistema (100 MHz)
   			clk_o	=> clk25MHz		-- reloj generado (25 MHz)
 		);

	-- Instancia del bloque voltimetro
	inst_voltimetro: Voltimetro
		port map(
            clk_i			=> clk25MHz,
            rst_i			=> rst_i,
            data_volt_in_i	=> data_volt_in_i,
            data_volt_out_o	=> data_volt_out_o,
            hs_o			=> hs_o,
            vs_o			=> vs_o,
            red_o			=> red_o,
            grn_o			=> grn_o,
            blu_o			=> blu_o
        );

end Voltimetro_toplevel_arq;
