library IEEE;
use IEEE.std_logic_1164.all;

entity BCD_counter_tb is
  generic(
    N: natural := 4
  );
end;

architecture BCD_counter_tb_arq of BCD_counter_tb is
component BCD_counter is
  generic(
    N: natural := 4
  );
  port(
    clk_m1: in std_logic; -- Clock master
    rst_m1: in std_logic; -- Reset master
    ena_m1: in std_logic; -- Enable master
    count: out std_logic_vector(N-1 downto 0); -- Cuenta
    max: out std_logic -- Cuenta maxima
  );
end component;

signal clk_tb: std_logic := '1';
signal rst_tb: std_logic := '1';
signal ena_tb: std_logic := '1';
signal count_tb: std_logic_vector(N-1 downto 0);
signal max_tb: std_logic;

begin
  clk_tb <= not clk_tb after 20 ns;
  rst_tb <= '0' after 80 ns; -- Me aseguro de que al menos
                            -- tarde mas de un ciclo de clk

  DUT: BCD_counter
    port map(
      clk_m1  =>  clk_tb,
      rst_m1  =>  rst_tb,
      ena_m1  =>  ena_tb,
      count   =>  count_tb,
      max     =>  max_tb
    );
end;
