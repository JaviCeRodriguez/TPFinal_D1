library IEEE;
use IEEE.std_logic_1164.all;

entity c33k_tb is
  generic(
    N: natural := 16
  );
end;

architecture c33k_tb_arq of c33k_tb is
component c33k is
  generic(
    N: natural := 16
  );
  port(
    clk_i: in std_logic; -- Clock
    rst_i: in std_logic; -- Reset
    ena_i: in std_logic; -- Enable
    Q_BCD: out std_logic; -- Reset para contador BCD (cBCD.vhd)
    Q_reg: out std_logic -- Enable para registro
  );
end component;

signal clk_tb: std_logic := '1';
signal rst_tb: std_logic := '1';
signal ena_tb: std_logic := '1';
signal Q_BCD_tb: std_logic;
signal Q_reg_tb: std_logic;

begin
  clk_tb <= not clk_tb after 20 ns;
  rst_tb <= '0' after 80 ns; -- Me aseguro de que al menos
                            -- tarde mas de un ciclo de clk

  DUT: c33k
    port map(
      clk_i  =>  clk_tb,
      rst_i  =>  rst_tb,
      ena_i  =>  ena_tb,
      Q_BCD  =>  Q_BCD_tb,
      Q_reg  =>  Q_reg_tb
    );
end;
