library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MUXMDRI is
Port ( entradamuxmdri0      : in std_logic_vector(15 downto 0);
		 entradamuxmdri1      : in std_logic_vector(15 downto 0);
		 salidamuxmdri        : out std_logic_vector(15 downto 0);
       selecmuxmdri         : in std_logic);
end MUXMDRI;


architecture Comportamiento of MUXMDRI is
	begin
		with  selecmuxmdri select
				salidamuxmdri <= entradamuxmdri0 when '0',
									entradamuxmdri1 when others;
	end Comportamiento;