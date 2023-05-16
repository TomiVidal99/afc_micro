library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rx is
	Port ( entradarx : in std_logic_vector(15 downto 0);
			 salidarx  : out std_logic_vector(15 downto 0);
			 opselecrx : in std_logic_vector(1 downto 0);
			 resetrx   : in std_logic;
			 clockrx   : in std_logic
			);
end rx;

architecture Comportamiento of rx is
	signal salidareg : std_logic_vector(15 downto 0);

	
	begin
		upcounter : process(clockrx, resetrx, opselecrx, salidareg)
			begin
			if clockrx = '1' and clockrx'event then
				if (resetrx = '1') then 
				   salidareg <= X"0000"; 
				elsif opselecrx = "10" then 				
					salidareg <= entradarx;
				elsif opselecrx = "01" then
					salidareg <= salidareg + 1;
				elsif opselecrx = "11" then
					salidareg <= salidareg - 1;
				end if;
			end if;
		end process upcounter;
		
	salidarx <= salidareg;

end architecture Comportamiento;