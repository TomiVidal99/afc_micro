library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CCR is
		Port ( entradaccr : in std_logic_vector (16 downto 0);
				 salidaccr : out std_logic_vector(4 downto 0);
				 escribirccr : in std_logic;
				 clockccr : in std_logic;
				 resetccr : in std_logic
				);
end CCR;

architecture Comportamiento of CCR is

   signal temp :  std_logic_vector (4 downto 0) := "00000";

	begin
		process(clockccr)
			begin
				if clockccr = '1' and clockccr'event then
				   if resetccr = '1' then  temp <= "00000"; 
					elsif escribirccr = '1' then
						if entradaccr (15 downto 0) = X"0000" then temp(0) <= '1';
						else temp(0) <= '0';
						end if;
						if entradaccr (16) = '1' then temp(1) <= '1';
						else temp(1) <= '0';
						end if;
					end if;
				end if;
		end process;
		
		salidaccr <= temp;
		
end Comportamiento;