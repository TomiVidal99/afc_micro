library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PC16R is
	Port ( entradapc : in std_logic_vector(15 downto 0);
			 salidapc  : out std_logic_vector(15 downto 0);
			 opselecpc : in std_logic_vector(1 downto 0);
			 resetpc   : in std_logic;
			 clockpc   : in std_logic
			);
end PC16R;

architecture Comportamiento of PC16R is
	signal salidareg : std_logic_vector(15 downto 0);

	
	begin
		upcounter : process(clockpc, resetpc, opselecpc, salidareg)
			begin
			if (rising_edge(clockpc)) then
				if (resetpc = '1') then 
				   salidareg <= X"0000"; 
				elsif opselecpc = "10" then 				
					salidareg <= entradapc;
				elsif opselecpc = "01" then
					salidareg <= salidareg + 1;
				end if;
			end if;
		end process upcounter;
		
	salidapc <= salidareg;

end architecture Comportamiento;