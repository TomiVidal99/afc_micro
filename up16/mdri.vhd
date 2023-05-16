library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MDRI is
		Port ( entradamdri : in std_logic_vector(15 downto 0);
				 salidamdri : out std_logic_vector(15 downto 0);
				 escribirmdri : in std_logic;
				 clockmdri : in std_logic);
end MDRI;

architecture Comportamiento of MDRI is
	begin
		process(clockmdri)
			begin
				if clockmdri = '1' and clockmdri'event then
					if escribirmdri = '1' then
						salidamdri <= entradamdri;
					end if;
				end if;
		end process;
end Comportamiento;