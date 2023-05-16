library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity REGPB is
		Port ( entradaregpb : in std_logic_vector(7 downto 0);
				 salidaregpb : out std_logic_vector(7 downto 0);
				 escribirregpb : in std_logic;
				 clockregpb : in std_logic);
end REGPB;

architecture Comportamiento of REGPB is
	begin
		process(clockregpb)
			begin
				if clockregpb = '1' and clockregpb'event then
					if escribirregpb = '1' then
						salidaregpb <= entradaregpb;
					end if;
				end if;
		end process;
end Comportamiento;