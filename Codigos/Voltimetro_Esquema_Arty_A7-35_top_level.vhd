----------------------------------------------------------------------------------
-- Modulo: 		Voltimetro_toplevel
-- Descripcion: Voltimetro implementado con un modulador sigma-delta
-- Autor: 		Electronica Digital I
--        		Universidad de San Martn - Escuela de Ciencia y Tecnologia
--
-- Fecha: 		18/08/20
----------------------------------------------------------------------------------

-- Alumno: Javier Ceferino Rodriguez
-- Mail: jcrodriguez@estudiantes.unsam.edu.ar
-- Periodo: 1° Cuatrimestre 2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Voltimetro_toplevel is
	port(
		clk_i			: in std_logic;		-- Clock
		rst_i			: in std_logic;		-- Reset
		data_volt_in_i	: in std_logic;		-- Señal de entrada
		data_volt_out_o	: out std_logic;	-- Señal de realimentación
		hs_o 			: out std_logic;	-- Sincronismo horizontal
		vs_o 			: out std_logic;	-- Sincronismo vertical
		red_o 			: out std_logic;	-- Rojo
		grn_o 			: out std_logic;	-- Verde
		blu_o 			: out std_logic		-- Azul
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
			clk_i: in std_logic;				-- Clock
			rst_i: in std_logic;				-- Reset
			data_volt_in_i: in std_logic;		-- Señal de entrada
			data_volt_out_o: out std_logic;		-- Señal de realimentación
			hs_o : out std_logic;				-- Sincronismo horizontal
			vs_o : out std_logic;				-- Sincronismo vertical
			red_o : out std_logic;				-- Rojo
			grn_o : out std_logic;				-- Verde
			blu_o : out std_logic				-- Azul
		);
	end component Voltimetro;

	-- Declaracion del compoente generador de reloj (MMCM - Mixed Mode Clock Manager)
	-- Para este componente, es necesario agregar en Vivado el Clocking Wizard desde IP Catalog
	component clk_generator
		port (
			-- Clock in ports
			clk_i: in std_logic;				-- Clock de entrada (100 MHz)
	  		-- Clock out ports
	  		clk_o: out std_logic				-- Clock de salida (25 MHz)
	 );
	end component;

	signal clk25MHz: std_logic;

begin
	-- Generador del reloj lento
	clk25MHz_gen : clk_generator
   		port map (
   			clk_i	=> clk_i,					-- Clock del sistema (100 MHz)
   			clk_o	=> clk25MHz					-- Clock generado (25 MHz)
 		);

	-- Instancia del bloque voltimetro
	inst_voltimetro: Voltimetro
		port map(
            clk_i			=> clk25MHz,		-- Clock generado
            rst_i			=> rst_i,			-- Reset
            data_volt_in_i	=> data_volt_in_i,	-- Señal de entrada
            data_volt_out_o	=> data_volt_out_o,	-- Señal de realimentación
            hs_o			=> hs_o,			-- Sincronismo horizontal
            vs_o			=> vs_o,			-- Sincronismo vertical
            red_o			=> red_o,			-- Rojo
            grn_o			=> grn_o,			-- Verde
            blu_o			=> blu_o			-- Azul
        );

end Voltimetro_toplevel_arq;
