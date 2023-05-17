library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALUR is
Port ( entradaalua      : in std_logic_vector(15 downto 0);
		 entradaalub      : in std_logic_vector(15 downto 0);
		 salidaalu        : out std_logic_vector(15 downto 0);
       selecalu         : in std_logic_vector (4 downto 0);
		 escribiralu      : in std_logic;
		 clockalu         : in std_logic;
		 carryinalu       : in std_logic;
		 carryoutalu      : out std_logic
	 );
end ALUR;

architecture Comportamiento of ALUR is

	signal swapa, logica  : std_logic_vector (15 downto 0);
	signal aritme         : std_logic_vector (16 downto 0);
	signal carry_out      : std_logic;
	signal entradaaluar   : std_logic_vector (15 downto 0);
	signal entradaalubr   : std_logic_vector (15 downto 0);

	begin	
	
	swapa (7 downto 0) <= entradaaluar (15 downto 8);
	swapa (15 downto 8) <= entradaaluar (7 downto 0);	

	
		process(clockalu)
			begin
				if clockalu = '1' and clockalu'event then
					if escribiralu = '1' then
						entradaaluar <= entradaalua;
						entradaalubr <= entradaalub;						
					end if;
				end if;
		end process;	
	
	
	with selecalu (3 downto 0) select	
		aritme <= '0'&entradaaluar 							      	when "0000",
		          '0'&entradaalubr 							       	when "0001",
					 '0'&entradaaluar + entradaalubr 			      when "1000",
					 '0'&entradaaluar + entradaalubr + carryinalu   when "1001",					 
					 '0'&entradaaluar - entradaalubr 			      when "1010",					 
					 '0'&entradaaluar - entradaalubr - carryinalu   when "1011",	
     	          '0'&entradaaluar                               when others;
	
	with selecalu (3 downto 0) select	
		logica <= entradaaluar                                   when "0000",
		          NOT entradaaluar                               when "0001",
					 swapa												      when "0010",
					 entradaaluar(14 downto 0)&'0'					   when "0011", --shift ari.a izq.
					 '0'& entradaaluar(15 downto 1)					   when "0100", --shift ari.a der.
					 entradaaluar(14 downto 0)&(entradaaluar(15))	when "0101", --shift lóg.a izq.
					 (entradaaluar(0))& entradaaluar(15 downto 1)	when "0110", --shift lóg.a der.
					  entradaaluar AND  entradaalubr   				   when "1000",  
					  entradaaluar NAND entradaalubr   				   when "1001",	 
					  entradaaluar OR   entradaalubr   				   when "1010",   
					  entradaaluar NOR  entradaalubr   				   when "1011",	 					 
					  entradaaluar XOR  entradaalubr   		         when "1100", --or-exclusiva				 		
					  entradaaluar XNOR entradaalubr   	            when "1101", --nor-exclusiva 
					  entradaaluar                                  when others;	

    with selecalu (4) select
			salidaalu <= aritme(15 downto 0) when '0',
		                logica when '1',
		                entradaaluar when others; 	

   with selecalu(4) select 							 
		carry_out <= aritme(16) when '0',
		            '0' when others;	
	
	carryoutalu <= carry_out;
	
	end Comportamiento;