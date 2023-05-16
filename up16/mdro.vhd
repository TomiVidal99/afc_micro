library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MDRO is
		Port ( entradamdro : in std_logic_vector(15 downto 0);
				 salidamdro : out std_logic_vector(15 downto 0);
				 escribirmdro : in std_logic;
				 clockmdro : in std_logic);
end MDRO;

architecture Comportamiento of MDRO is
	begin
		process(clockmdro)
			begin
				if clockmdro = '1' and clockmdro'event then
					if escribirmdro = '1' then
						salidamdro <= entradamdro;
					end if;
				end if;
		end process;
end Comportamiento;