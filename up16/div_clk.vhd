library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_clk is
    Port (
        clock_in_div 		   : in  STD_LOGIC;
        clock_out_div	   	: out STD_LOGIC
    );
end div_clk;

architecture Behavioral of div_clk is
    signal temporal: STD_LOGIC := '0';
    signal counter : integer range 0 to 9 := 0;
begin
    frequency_divider: process (clock_in_div) begin
        if rising_edge(clock_in_div) then
            if (counter = 4) then
                temporal <= NOT(temporal);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clock_out_div <= temporal;
end Behavioral;