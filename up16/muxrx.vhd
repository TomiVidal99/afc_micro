library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MUXRX is
Port ( entradamuxrx0      : in std_logic_vector(15 downto 0);
		 entradamuxrx1      : in std_logic_vector(15 downto 0);
		 salidamuxrx        : out std_logic_vector(15 downto 0);
       selecmuxrx         : in std_logic);
end MUXRX;


architecture Comportamiento of MUXRX is
	begin
		with  selecmuxrx select
				salidamuxrx <= entradamuxrx0 when '0',
									entradamuxrx1 when others;
	end Comportamiento;