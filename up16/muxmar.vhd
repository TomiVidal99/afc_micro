library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MUXMAR is
Port ( entradamuxmar0      : in std_logic_vector(15 downto 0);
		 entradamuxmar1      : in std_logic_vector(15 downto 0);
		 salidamuxmar        : out std_logic_vector(15 downto 0);
       selecmuxmar         : in std_logic);
end MUXMAR;


architecture Comportamiento of MUXMAR is
	begin
		with  selecmuxmar select
				salidamuxmar <= entradamuxmar0 when '0',
									entradamuxmar1 when others;
	end Comportamiento;