library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity REGPA is
	Port ( entradaregpa : in std_logic_vector(15 downto 0);
			 selcoderegpa : in std_logic_vector(3 downto 0);
			 salidaregpa  : out std_logic_vector(15 downto 0);
			 opselecregpa : in std_logic_vector (2 downto 0);
			 salidacode   : out std_logic_vector (15 downto 0);
			 resetregpa   : in std_logic;
			 clockregpa   : in std_logic); 
	end REGPA;

	architecture Comportamiento of REGPA is

	signal salidacode_r, salidareg : std_logic_vector (15 downto 0);
	
	begin
	with selcoderegpa select
		salidacode_r <= 	X"0001" when "0000", --"00000001" bit 0
							X"0002" when "0001", --"0000000000000010" bit 1
							X"0004" when "0010", --"0000000000000100" bit 2
							X"0008" when "0011", --"0000000000001000" bit 3
							X"0010" when "0100", --"0000000000010000" bit 4
							X"0020" when "0101", --"0000000000100000" bit 5
							X"0040" when "0110", --"0000000001000000" bit 6
							X"0080" when "0111", --"0000000010000000" bit 7
							X"0100" when "1000", --"0000000100000000" bit 8
							X"0200" when "1001", --"0000001000000000" bit 9
							X"0400" when "1010", --"0000010000000000" bit 10
							X"0800" when "1011", --"0000100000000000" bit 11
							X"1000" when "1100", --"0001000000000000" bit 12
							X"2000" when "1101", --"0010000000000000" bit 13
							X"4000" when "1110", --"0100000000000000" bit 14
							X"8000" when "1111", --"1000000000000000" bit 15
							X"0001" when others;
						
	process (clockregpa, resetregpa, opselecregpa, entradaregpa, salidacode_r)
		begin						
			if (rising_edge(clockregpa)) then
				if (resetregpa = '1') then 
				   salidareg <= X"0000"; 
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
