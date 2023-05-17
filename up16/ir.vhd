library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IR is
		Port ( entradair : in std_logic_vector(15 downto 0);
				 salidair : out std_logic_vector(15 downto 0);
				 escribirir : in std_logic;
				 clockir : in std_logic);
end IR;

architecture Comportamiento of IR is
	begin
		process(clockir)
			begin
				if clockir = '1' and clockir'event then
					if escribirir = '1' then
						salidair <= entradair;
					end if;
				end if;
		end process;
end Comportamiento;