-- Test bench de el port de salida A.

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_regpa is
end entity;

architecture A1 of tb_regpa is

  component up16
    Port (
      clock_up16    : in std_logic;
      reset_up16    : in std_logic;
      PORT_A        : out std_logic_vector (15 downto 0);
      PORT_B        : in std_logic_vector (15 downto 0)
    );
  end component;

  signal clk_50Mhz: std_logic := '0'; -- señal de reloj de 50 Mhz como la que tiene la placa
  signal reset: std_logic := '0';
  signal PORT_A: std_logic_vector(15 downto 0) := X"0000";

begin

  UUT: up16 port map (
    clock_up16 => clk_50Mhz,
    reset_up16 => reset,
    PORT_A => PORT_A,
    PORT_B => X"0000"
  );

  -- Señal de reloj
  clk_50Mhz <= not clk_50Mhz after 10 ns;

  -- Generacion de estimulos
  estimulos:
  process is
  begin
  
    reset <= '0';
    wait for 20 ns; -- despues de 1 ciclo de reloj
    reset <= '1';

    wait;
 
  end process;

end A1;
