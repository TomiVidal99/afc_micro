library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MAR16 is
		Port ( entradamar : in std_logic_vector(15 downto 0);
				 salidamar : out std_logic_vector(15 downto 0);
				 escribirmar : in std_logic;
				 clockmar : in std_logic);
end MAR16;

architecture Comportamiento of MAR16 is
	begin
		process(clockmar)
			begin
				if clockmar = '1' and clockmar'event then
					if escribirmar = '1' then
						salidamar <= entradamar;
					end if;
				end if;
		end process;
end Comportamiento;