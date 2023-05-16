library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity REGPA is
	Port ( entradaregpa : in std_logic_vector(7 downto 0);
			 selcoderegpa : in std_logic_vector(2 downto 0);
			 salidaregpa  : out std_logic_vector(7 downto 0);
			 opselecregpa : in std_logic_vector (2 downto 0);
			 salidacode   : out std_logic_vector (7 downto 0);
			 resetregpa   : in std_logic;
			 clockregpa   : in std_logic); 
	end REGPA;

	architecture Comportamiento of REGPA is

	signal salidacode_r, salidareg : std_logic_vector (7 downto 0);
	
	begin
	with selcoderegpa select
		salidacode_r <= 	X"01" when "000", --"00000001" bit 0
							X"02" when "001", --"00000010" bit 1
							X"04" when "010", --"00000100" bit 2
							X"08" when "011", --"00001000" bit 3
							X"10" when "100", --"00010000" bit 4
							X"20" when "101", --"00100000" bit 5
							X"40" when "110", --"01000000" bit 6
							X"80" when "111", --"10000000" bit 7
							X"01" when others;
						
	process (clockregpa, resetregpa, opselecregpa, entradaregpa, salidacode_r)
		begin						
			if (rising_edge(clockregpa)) then
				if (resetregpa = '1') then 
				   salidareg <= X"00"; 
				elsif opselecregpa = "010" then 				
					salidareg <= entradaregpa;
				elsif opselecregpa = "001" then
					salidareg <= salidareg + 1;
				elsif opselecregpa = "011" then
					salidareg <= salidareg - 1;
				elsif opselecregpa = "100" then
			      salidareg <= salidareg OR salidacode_r;
				elsif opselecregpa = "101" then
					salidareg <= salidareg AND ( NOT salidacode_r);
				end if;
			end if;
	end process;							
	salidaregpa <= salidareg;	
	salidacode <= salidacode_r;
end Comportamiento;
	
--Circuito de control de PORT A (configurado siempre como salida de 8 BITS)	