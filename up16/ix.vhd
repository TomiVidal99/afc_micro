library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IX is
	Port ( entradaix : in std_logic_vector(15 downto 0);
			 salidaix  : out std_logic_vector(15 downto 0);
			 opselecix : in std_logic_vector(1 downto 0);
			 resetix   : in std_logic;
			 clockix   : in std_logic
			);
end IX;

architecture Comportamiento of IX is
	signal salidareg : std_logic_vector(15 downto 0);

	
	begin
		upcounter : process(clockix, resetix, opselecix, salidareg)
			begin
			if (rising_edge(clockix)) then
				if (resetix = '1') then 
				   salidareg <= X"0000"; 
				elsif opselecix = "10" then 				
					salidareg <= entradaix;
				elsif opselecix = "01" then
					salidareg <= salidareg + 1;
				end if;
			end if;
		end process upcounter;
		
	salidaix <= salidareg;

end architecture Comportamiento;