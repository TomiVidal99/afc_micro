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

  component REGPA
	  Port ( entradaregpa : in std_logic_vector(15 downto 0);
			 selcoderegpa : in std_logic_vector(3 downto 0);
			 salidaregpa  : out std_logic_vector(15 downto 0);
			 opselecregpa : in std_logic_vector (2 downto 0);
			 salidacode   : out std_logic_vector (15 downto 0);
			 resetregpa   : in std_logic;
			 clockregpa   : in std_logic); 
  end component;

  signal clk_50Mhz: std_logic := '0'; -- señal de reloj de 50 Mhz como la que tiene la placa
  signal PORT_A: std_logic_vector(15 downto 0) := X"0000";
  signal resetregpa: std_logic := '0';
  --signal clk100Hz: std_logic := '0';
  --signal entradaregpa : std_logic_vector(15 downto 0) := "0000000010000000";
	--signal selcoderegpa : std_logic_vector(3 downto 0) := "0000";
	--signal salidaregpa  : std_logic_vector(15 downto 0) := X"0000";
	--signal opselecregpa : std_logic_vector (2 downto 0) := "010";
	--signal salidacode   : std_logic_vector (15 downto 0) := X"0000";

begin

  UUT: up16 port map (
    clock_up16 => clk_50Mhz,
    reset_up16 => resetregpa,
    PORT_A => PORT_A,
    PORT_B => X"0000"
  );

 -- UUT: REGPA port map (
 --   entradaregpa => entradaregpa,
 --   selcoderegpa => selcoderegpa,
 --   salidaregpa => salidaregpa,
 --   opselecregpa => opselecregpa,
 --   salidacode => salidacode,
 --   resetregpa => resetregpa,
 --   clockregpa => clk100Hz
 -- );

  -- Señal de reloj
  clk_50Mhz <= not clk_50Mhz after 10 ns;
  --clk100Hz <= not clk100Hz after 5 ms;

  -- Generacion de estimulos
  estimulos:
  process is
  begin

    resetregpa <= '0';
    wait for 100 ns; -- despues de 1 ciclo de reloj
    resetregpa <= '1';

--    selcoderegpa <= "0111";
--    wait for 20 ms;
--
--    selcoderegpa <= "1111";

    wait;
 
  end process;

end A1;
