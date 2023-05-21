------------------------ SET DE INSTRUCCIONES (36 EN TOTAL):
--		X"0000"  CLR  RX
--		X"0100"  INC  RX
--		X"0200"  LDI  RX
--		X"0300"  DEC  RX 
--		X"0400"  NOP
--		X"0500"  LDD  RX
--		X"0600"  STR  RX
--    X"0708"  RX <- RX + MEM 				selecalu <= "01000"
--    X"0709"  RX <- RX + MEM + Cin			selecalu <= "01001"
--    X"070A"  RX <- RX - MEM					selecalu <= "01010"
--    X"070B"  RX <- RX - MEM - Cin			selecalu <= "01011"
--    X"0711"  NOT RX  							selecalu <= "10001"
--    X"0712"  SWAP RX							selecalu <= "10010"
--    X"0713"  SLA  RX							selecalu <= "10011"
--    X"0714"  SRA  RX 							selecalu <= "10100"
--    X"0715"  SLL  RX							selecalu <= "10101"
--    X"0716"  SRL  RX							selecalu <= "10110"
--    X"0718"  RX <- RX AND MEM 				selecalu <= "11000"
--    X"0719"  RX <- RX NAND MEM				selecalu <= "11001"
--    X"071A"  RX <- RX OR MEM				selecalu <= "11010"
--    X"071B"  RX <- RX NOR MEM				selecalu <= "11011"
--    X"071C"  RX <- RX XOR MEM 				selecalu <= "11100"
--    X"071D"  RX <- RX XNOR MEM				selecalu <= "11101"
--		X"1000"	JMP PC  PC <-- (MEMCODE+1)
--		X"1100"  JMP PC IF ZERO
--		X"1200"  JMP PC IF CARRY
--		X"1300"  DEC RX IF NOT ZERO
--		X"0800"  STR RXL, PORT A
--		X"09X0"  BIT SET I, PORT A          selección de bit con IR(7 downto 5) 
--		X"0AX0"  BIT CLR I, PORT A				selección de bit con IR(7 downto 5)
--		X"0B00"  INC  PORT A
--		X"0C00"  DEC PORT A
--    X"0D00"  LDI RXH, PORT B
--    X"0EX0"  BTIJC, PORT B    				selección de bit con IR(7 downto 5)
--    X"0FX0"  BTIJS, PORT B     			selección de bit con IR(7 downto 5)
--    X"8000"  RST 
--
--    X"0900" A X"09E0" == B"0000 1001 XXX0 0000" ==> BIT SET I, PORT A 
--    X"0A00" A X"0AE0" == B"0000 1010 XXX0 0000" ==> BIT CLR I, PORT A 
--
--    X"0E00" A X"0EE0" == B"0000 1110 XXX0 0000" ==> BIT TEST I, JUMP IF CLR, PORT B 
--    X"0F00" A X"0FE0" == B"0000 1111 XXX0 0000" ==> BIT TEST I, JUMP IF SET, PORT B 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity up16 is

	Port (    clock_up16 	    : in std_logic;
		       reset_up16 	    : in std_logic;
			    PORT_A            : out std_logic_vector (15 downto 0);    
			    PORT_B            : in std_logic_vector (15 downto 0)
			);	 
	end up16;

architecture Comportamiento of up16 is

   --------   CONSTANTES PARA EL SET DE INSTRUCCIONES ----------------
	constant CLR_RX 					: std_logic_vector(15 downto 0) := X"0000";
	constant INC_RX 					: std_logic_vector(15 downto 0) := X"0100";
	constant LDI_RX 					: std_logic_vector(15 downto 0) := X"0200";	
	constant DEC_RX 					: std_logic_vector(15 downto 0) := X"0300";
	constant NOP	 					: std_logic_vector(15 downto 0) := X"0400";
	constant LDD_RX 					: std_logic_vector(15 downto 0) := X"0500";
	constant STR_RX 					: std_logic_vector(15 downto 0) := X"0600";	
	constant RX_PLUS_MEM          : std_logic_vector(15 downto 0) := X"0708";
	constant RX_PLUS_MEM_PLUS_C   : std_logic_vector(15 downto 0) := X"0709";	
	constant RX_MINUS_MEM         : std_logic_vector(15 downto 0) := X"070A";
	constant RX_MINUS_MEM_MINUS_C : std_logic_vector(15 downto 0) := X"070B";	
	constant NOT_RX       			: std_logic_vector(15 downto 0) := X"0711";
	constant SWAP_RX        		: std_logic_vector(15 downto 0) := X"0712";
	constant SLA_RX         		: std_logic_vector(15 downto 0) := X"0713";
	constant SRA_RX         		: std_logic_vector(15 downto 0) := X"0714";
	constant SLL_RX         		: std_logic_vector(15 downto 0) := X"0715";
	constant SRL_RX         		: std_logic_vector(15 downto 0) := X"0716";
	constant RX_AND_MEM     		: std_logic_vector(15 downto 0) := X"0718";
	constant RX_NAND_MEM    		: std_logic_vector(15 downto 0) := X"0719";
	constant RX_OR_MEM     			: std_logic_vector(15 downto 0) := X"071A";
	constant RX_NOR_MEM     		: std_logic_vector(15 downto 0) := X"071B";	
	constant RX_XOR_MEM     		: std_logic_vector(15 downto 0) := X"071C";
	constant RX_XNOR_MEM    		: std_logic_vector(15 downto 0) := X"071D";	
--------------             NUEVAS INSTRUCCIONES           ------------------
	constant STR_RX_PORTA			: std_logic_vector(15 downto 0) := X"0800";
	constant INC_PORTA				: std_logic_vector(15 downto 0) := X"0B00";
	constant DEC_PORTA 				: std_logic_vector(15 downto 0) := X"0C00";	
	constant LDI_RXL_PORTB			: std_logic_vector(15 downto 0) := X"0D00";	
----------------------------------------------------------------------------
----------------------------------------------------------------------------
	constant JMP_PC 					: std_logic_vector(15 downto 0) := X"1000";
	constant JMP_PC_IF_Z				: std_logic_vector(15 downto 0) := X"1100";
	constant JMP_PC_IF_C 			: std_logic_vector(15 downto 0) := X"1200";
	constant DEC_RX_IF_NZ 			: std_logic_vector(15 downto 0) := X"1300";	
	constant RST 						: std_logic_vector(15 downto 0) := X"8000";
--------------             NUEVAS INSTRUCCIONES           ------------------
   constant BSI_0_PORTA				: std_logic_vector (15 downto 0) := X"0900";
   constant BSI_1_PORTA				: std_logic_vector (15 downto 0) := X"0920";	
   constant BSI_2_PORTA				: std_logic_vector (15 downto 0) := X"0940";
   constant BSI_3_PORTA				: std_logic_vector (15 downto 0) := X"0960";
   constant BSI_4_PORTA				: std_logic_vector (15 downto 0) := X"0980";
   constant BSI_5_PORTA				: std_logic_vector (15 downto 0) := X"09A0";   
   constant BSI_6_PORTA				: std_logic_vector (15 downto 0) := X"09C0";	
   constant BSI_7_PORTA				: std_logic_vector (15 downto 0) := X"09E0";
----------------------------------------------------------------------------	
   constant BCI_0_PORTA				: std_logic_vector (15 downto 0) := X"0A00";
   constant BCI_1_PORTA				: std_logic_vector (15 downto 0) := X"0A20";	
   constant BCI_2_PORTA				: std_logic_vector (15 downto 0) := X"0A40";
   constant BCI_3_PORTA				: std_logic_vector (15 downto 0) := X"0A60";
   constant BCI_4_PORTA				: std_logic_vector (15 downto 0) := X"0A80";
   constant BCI_5_PORTA				: std_logic_vector (15 downto 0) := X"0AA0";   
   constant BCI_6_PORTA				: std_logic_vector (15 downto 0) := X"0AC0";	
   constant BCI_7_PORTA				: std_logic_vector (15 downto 0) := X"0AE0";
   --------------------------------------------------------------------------
   constant BTJIC_0_PORTB  		: std_logic_vector (15 downto 0) := X"0E00";
   constant BTJIC_1_PORTB  		: std_logic_vector (15 downto 0) := X"0E20";
   constant BTJIC_2_PORTB  		: std_logic_vector (15 downto 0) := X"0E40";
   constant BTJIC_3_PORTB  		: std_logic_vector (15 downto 0) := X"0E60";
   constant BTJIC_4_PORTB  		: std_logic_vector (15 downto 0) := X"0E80";
   constant BTJIC_5_PORTB  		: std_logic_vector (15 downto 0) := X"0EA0";
   constant BTJIC_6_PORTB  		: std_logic_vector (15 downto 0) := X"0EC0";
   constant BTJIC_7_PORTB  		: std_logic_vector (15 downto 0) := X"0EE0";
	--------------------------------------------------------------------------
   constant BTJIS_0_PORTB  		: std_logic_vector (15 downto 0) := X"0F00";
   constant BTJIS_1_PORTB  		: std_logic_vector (15 downto 0) := X"0F20";
   constant BTJIS_2_PORTB  		: std_logic_vector (15 downto 0) := X"0F40";
   constant BTJIS_3_PORTB  		: std_logic_vector (15 downto 0) := X"0F60";
   constant BTJIS_4_PORTB  		: std_logic_vector (15 downto 0) := X"0F80";
   constant BTJIS_5_PORTB  		: std_logic_vector (15 downto 0) := X"0FA0";
   constant BTJIS_6_PORTB  		: std_logic_vector (15 downto 0) := X"0FC0";
   constant BTJIS_7_PORTB  		: std_logic_vector (15 downto 0) := X"0FE0";

	component PC16R
		Port ( entradapc : in std_logic_vector(15 downto 0);
			    salidapc  : out std_logic_vector(15 downto 0);
			    opselecpc : in std_logic_vector(1 downto 0);
				 resetpc   : in std_logic; 
			    clockpc   : in std_logic
				 );
	end component;

	component RAM
	PORT   (
		clock				: IN  std_logic;
		data				: IN  std_logic_vector(15 DOWNTO 0);
		address			: IN  std_logic_vector(11 DOWNTO 0);
		wren				: IN  std_logic;
		q					: OUT std_logic_vector(15 DOWNTO 0)
	);
  end component;

	component DIV_CLK
	PORT   (  clock_in_div      : in  STD_LOGIC;
             clock_out_div     : out STD_LOGIC
	        );
  end component;

	component MAR16
		Port ( entradamar   : in std_logic_vector(15 downto 0);
				 salidamar    : out std_logic_vector(15 downto 0);
				 escribirmar  : in std_logic;
				 clockmar	  : in std_logic);
	end component;
  
	component MDRO
		Port ( entradamdro  : in std_logic_vector(15 downto 0);
				 salidamdro   : out std_logic_vector(15 downto 0);
				 escribirmdro : in std_logic;
				 clockmdro	  : in std_logic);
	end component;  
  
	component MDRI
			Port ( entradamdri   : in std_logic_vector(15 downto 0);
				 salidamdri       : out std_logic_vector(15 downto 0);
				 escribirmdri     : in std_logic;
				 clockmdri        : in std_logic);
	end component; 

	component RX
	Port ( entradarx : in std_logic_vector(15 downto 0);
			 salidarx  : out std_logic_vector(15 downto 0);
			 opselecrx : in std_logic_vector(1 downto 0);
			 resetrx   : in std_logic;
			 clockrx   : in std_logic);
   end component;

	component IR
			Port ( entradair   : in std_logic_vector(15 downto 0);
				 salidair    	 : out std_logic_vector(15 downto 0);
				 escribirir     : in std_logic;
				 clockir        : in std_logic);
	end component; 

	component MUXMAR 
   Port ( entradamuxmar0      : in std_logic_vector(15 downto 0);
		    entradamuxmar1      : in std_logic_vector(15 downto 0);
		    salidamuxmar        : out std_logic_vector(15 downto 0);
          selecmuxmar         : in std_logic);
	end component; 

	component ALUR
		Port ( entradaalua      : in std_logic_vector(15 downto 0);
				 entradaalub      : in std_logic_vector(15 downto 0);
		       salidaalu        : out std_logic_vector(15 downto 0);
             selecalu         : in std_logic_vector (4 downto 0);
		       escribiralu      : in std_logic;
	      	 clockalu         : in std_logic; 
	      	 carryinalu       : in std_logic;
	      	 carryoutalu      : out std_logic);
	end component;

	component MUXRX
		Port ( entradamuxrx0      : in std_logic_vector(15 downto 0);
		       entradamuxrx1      : in std_logic_vector(15 downto 0);
		       salidamuxrx        : out std_logic_vector(15 downto 0);
             selecmuxrx         : in std_logic);
	end component;

	component CCR
	Port ( entradaccr : in std_logic_vector (16 downto 0);
			 salidaccr : out std_logic_vector(4 downto 0);
			 escribirccr : in std_logic;
			 clockccr : in std_logic;
			 resetccr : in std_logic);
	end component;

	component REGPA
	Port ( entradaregpa : in std_logic_vector(15 downto 0);
			 selcoderegpa : in std_logic_vector(3 downto 0);
			 salidaregpa  : out std_logic_vector(15 downto 0);
			 opselecregpa : in std_logic_vector (2 downto 0);
			 salidacode   : out std_logic_vector (15 downto 0);			 
			 resetregpa   : in std_logic;
			 clockregpa   : in std_logic); 
	end component;	

	component MUXMDRI
Port ( entradamuxmdri0      : in std_logic_vector(15 downto 0);
		 entradamuxmdri1      : in std_logic_vector(15 downto 0);
		 salidamuxmdri        : out std_logic_vector(15 downto 0);
       selecmuxmdri         : in std_logic);	
	end component;

   component REGPB
		Port ( entradaregpb : in std_logic_vector(15 downto 0);
				 salidaregpb : out std_logic_vector(15 downto 0);
				 escribirregpb : in std_logic;
				 clockregpb : in std_logic);	
		end component;

   constant cero : std_logic_vector (7 downto 0):= X"00";
	
	signal estado, proximoestado  	   : integer;

   signal   entradapc : std_logic_vector(15 downto 0);
	signal	salidapc  : std_logic_vector(15 downto 0);
	signal   opselecpc : std_logic_vector(1 downto 0);
	signal   resetpc   : std_logic; 
	signal   clockpc   : std_logic;
	
	signal q										: std_logic_vector (15 downto 0);
	signal data									: std_logic_vector (15 downto 0);
	signal address 	 						: std_logic_vector (11 downto 0); 
	signal wren						         : std_logic;	
	signal clock					         : std_logic;

   signal clock_in_div						: std_logic;
   signal clock_out_div						: std_logic;	

	signal resetrx							   : std_logic;
	signal opselecrx 			 				: std_logic_vector (1 downto 0);
	signal entradarx			 				: std_logic_vector (15 downto 0);
	signal salidarx 			 				: std_logic_vector (15 downto 0);	
	signal clockrx				            : std_logic;	
	
	signal entradamar		 		    		: std_logic_vector (15 downto 0);
	signal salidamar 			 				: std_logic_vector (15 downto 0);	
	signal escribirmar			         : std_logic;
	signal clockmar				         : std_logic;
	
	signal entradamdro	 		    		: std_logic_vector (15 downto 0);
	signal salidamdro 		 				: std_logic_vector (15 downto 0);	
	signal escribirmdro			         : std_logic;	
	signal clockmdro				         : std_logic;
	
	signal entradamdri	 		    		: std_logic_vector (15 downto 0);
	signal salidamdri 		 				: std_logic_vector (15 downto 0);	
	signal escribirmdri			         : std_logic;		
	signal clockmdri				         : std_logic;
	
	signal entradair	 		      		: std_logic_vector (15 downto 0);
	signal salidair 		 			   	: std_logic_vector (15 downto 0);	
	signal escribirir			            : std_logic;			
	signal clockir				     		   : std_logic;		

	signal entradamuxmar0 		    		: std_logic_vector (15 downto 0);
	signal entradamuxmar1	 				: std_logic_vector (15 downto 0);	
	signal salidamuxmar 		 				: std_logic_vector (15 downto 0);		
	signal selecmuxmar			         : std_logic;			

	signal entradaalua 		      		: std_logic_vector (15 downto 0);
	signal entradaalub 		    	   	: std_logic_vector (15 downto 0);
	signal salidaalu 		       		   : std_logic_vector (15 downto 0);
	signal selecalu					      : std_logic_vector (4 downto 0);
	signal clockalu				         : std_logic;
	signal escribiralu			         : std_logic;	
	signal carryinalu	 			         : std_logic;
	signal carryoutalu   			      : std_logic;	

	signal entradamuxrx0      				: std_logic_vector(15 downto 0);
	signal entradamuxrx1      				: std_logic_vector(15 downto 0);
	signal salidamuxrx      				: std_logic_vector(15 downto 0);
	signal selecmuxrx							: std_logic;

	signal entradaccr 						: std_logic_vector (16 downto 0);
	signal salidaccr 							: std_logic_vector(4 downto 0);
	signal escribirccr 						: std_logic;
	signal clockccr 							: std_logic;
	signal resetccr 							: std_logic;	

	signal entradaregpa 						: std_logic_vector(15 downto 0);
	signal selcoderegpa 						: std_logic_vector(3 downto 0);
	signal salidaregpa  						: std_logic_vector(15 downto 0);
	signal salidacode                   : std_logic_vector (15 downto 0); 
	signal opselecregpa 						: std_logic_vector (2 downto 0);
	signal resetregpa   						: std_logic;
	signal clockregpa   						: std_logic;	
	
	signal entradamuxmdri0 					:  std_logic_vector(15 downto 0);
	signal entradamuxmdri1 					:  std_logic_vector(15 downto 0);
	signal salidamuxmdri   					:  std_logic_vector(15 downto 0);
	signal selecmuxmdri    					:  std_logic;		
	
   signal entradaregpb 						: std_logic_vector(15 downto 0);
	signal salidaregpb 						: std_logic_vector(15 downto 0);
	signal escribirregpb 					: std_logic;
	signal clockregpb 						: std_logic;	
	
	signal state_cu                     : std_logic_vector (7 downto 0);
   signal zero                         : std_logic;
	signal carryout                     : std_logic; 
	signal result_and                   : std_logic_vector (7 downto 0);
	
	begin
	
	U01 : PC16R port map ( entradapc => entradapc,
								 salidapc => salidapc,
	                      opselecpc => opselecpc, 
								 resetpc => resetpc,
								 clockpc => clockpc);
				
	U02  : RAM port map 	( clock => clock, 
	                       data => data,	
								  address => address, 
								  wren => wren,	
								  q => q);

	U03 : DIV_CLK  port map 	(clock_in_div => clock_in_div ,
	                               clock_out_div => clock_out_div);

	U04 : MAR16 port map (entradamar => entradamar, 
	                      salidamar => salidamar, 
								 escribirmar => escribirmar, 
								 clockmar => clockmar);			

	U05 : MDRO port map (entradamdro => entradamdro, 
	                     salidamdro => salidamdro, 
								escribirmdro => escribirmdro, 
								clockmdro => clockmdro);			
	
	U06 : MDRI port map (entradamdri => entradamdri, 
	                     salidamdri => salidamdri, 
								escribirmdri => escribirmdri, 
								clockmdri => clockmdri);			

	U07 : RX port map ( entradarx => entradarx, 
	                    salidarx => salidarx, 
							  opselecrx => opselecrx, 
							  resetrx =>  resetrx,
							  clockrx => clockrx);
	
	U08 : IR port map ( entradair => entradair, 
	                    salidair => salidair, 
							  escribirir => escribirir, 
							  clockir => clockir);				

   U09 : MUXMAR port map (  entradamuxmar0, entradamuxmar1, salidamuxmar, 
                            selecmuxmar); 

   U10 : ALUR   port map (entradaalua, entradaalub, salidaalu, selecalu, escribiralu,
                          clockalu, carryinalu, carryoutalu);
	
	U11 : MUXRX  port map (entradamuxrx0, entradamuxrx1, salidamuxrx,       
                          selecmuxrx);	

	U12 : CCR    port map ( entradaccr, salidaccr, escribirccr, clockccr, resetccr);							 

	U13 : REGPA port map (entradaregpa, selcoderegpa, salidaregpa, opselecregpa, 
	                      salidacode, resetregpa, clockregpa); 

	U14 : MUXMDRI port map (entradamuxmdri0, entradamuxmdri1, salidamuxmdri,  
	                        selecmuxmdri);	
	
	U15 : REGPB  port map (entradaregpb, salidaregpb, escribirregpb,
				              clockregpb); 
	
	process(estado, clock_out_div, salidair)
		begin
				selecmuxrx <= '0';		--Direcciona salida MDRI hacia entrada de RX
				selecmuxmar <= '0';		
				wren <= '0';
				resetpc <= '0';
				opselecpc <= "00";
				resetrx <= '0';
				escribirir <= '0';
				escribirmar <= '0';
				escribirmdri <= '0';
				escribirmdro <= '0';
			   escribiralu <= '0';
				escribirccr <= '0';
				resetccr <= '0';
				selecmuxmdri <= '0';    --Direcciona salida de RAM a entrada a MDRI
				escribirregpb <= '0';
				opselecregpa <= "000";
				resetregpa <= '0';
				
			if reset_up16 = '0' then
			   wren <= '0';
				selecmuxmar <= '0';				
				resetpc <= '0';
				opselecrx <= "00";		
				estado <= 0;
			elsif clock_out_div = '1' and clock_out_div'event then
				estado <= proximoestado;
			end if;		
				
		case estado is
			when 0 =>     
--				selecmuxmar <= '0';			
--          wren <= '0';		
				resetpc <= '1';
--				opselecpc <= "00";
--				resetrx <= '0';				
				opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"00";
   			proximoestado <= 1;

			when 1 =>	
--				selecmuxmar <= '0';			
--          wren <= '0';				
				resetpc <= '0';
--				opselecpc <= "00";
--				resetrx <= '0';								
--				opselecrx <= "00";
--				escribirir <= '0';
				escribirmar <= '1';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"01";				
   			proximoestado <= 2;

			when 2 =>
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				resetrx <= '0';				
--				opselecrx <= "00";
--				escribirir <= '0';
				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"02";				
				proximoestado <= 3;
			
			when 3 =>  
--				selecmuxmar <= '0';			
--          wren <= '0';	     		
--				opselecpc <= "00";
--				resetrx <= '0';				
--				opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"03";				
				proximoestado <= 4;
				
			when 4 =>  
--				selecmuxmar <= '0';			
--          wren <= '0';	     		
--				opselecpc <= "00";
--				resetrx <= '0';				
--				opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"04";				
				proximoestado <= 5;				

			when 5 =>  
--				selecmuxmar <= '0';			
--          wren <= '0';	     		
--				opselecpc <= "00";
--				resetrx <= '0';				
--				opselecrx <= "00";
				escribirir <= '1';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"05";				
				proximoestado <= 6;
				
			when 6 =>  
--				selecmuxmar <= '0';			
--          wren <= '0';	     		
--				opselecpc <= "00";
--				resetrx <= '0';				
--				opselecrx <= "00";
				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"06";				
				proximoestado <= 7;
			
			when 7 =>			 		--Decodifico las instrucciones
				if (salidair = RST) then proximoestado <= 0;
				elsif (salidair = JMP_PC or salidair = JMP_PC_IF_Z or salidair = JMP_PC_IF_C) or 
				(salidair >= BTJIC_0_PORTB and salidair <= BTJIC_7_PORTB) or 
				(salidair >= BTJIS_0_PORTB and salidair <= BTJIS_7_PORTB)	
				then proximoestado <= 16;
				else	proximoestado <= 100;
				end if;
				state_cu <= X"07";			
			
		  when 100 =>
            resetccr <= '1';
		      state_cu <= X"64";  
		      proximoestado <= 101;		 

		  when 101 =>
		      resetccr <= '0'; 
		      state_cu <= X"65"; 		    
      	   proximoestado <= 102;
		
		 when 102 =>
		      if (salidair = LDI_RX or salidair = LDD_RX or salidair = STR_RX) then proximoestado <= 16;
			   
				
				else proximoestado <= 8;
			   end if;	
		      state_cu <= X"65"; 		    

			when 8 =>		--SALTA AQUI SI INSTRUCCION ES SOLO MODIFICAR "RX"	
				if     (salidair = INC_RX) then proximoestado <= 9; --INC RX								
				elsif  (salidair = CLR_RX) then proximoestado <= 10; 	 --CLR RX								
				elsif  (salidair = DEC_RX) then proximoestado <= 11; --DEC RX
				elsif  (salidair = NOP)  then proximoestado <= 12;
				elsif (salidair = NOT_RX or salidair = SWAP_RX or salidair = SLA_RX or
				salidair = SRA_RX or salidair = SLL_RX or salidair = SRL_RX) then 
			   proximoestado <= 36;
			   elsif (salidair = RX_PLUS_MEM or salidair = RX_PLUS_MEM_PLUS_C or 
				salidair = RX_MINUS_MEM or salidair = RX_MINUS_MEM_MINUS_C or 
				salidair = RX_AND_MEM or salidair = RX_NAND_MEM or 
				salidair = RX_OR_MEM or salidair = RX_NOR_MEM or salidair = RX_XOR_MEM or
				salidair = RX_XNOR_MEM) then proximoestado <= 16;--APROVECHO PARTE DE LA RUTINA				
																				 --DE LDD_RX Y STR_RX				
				elsif (salidair = DEC_RX_IF_NZ) then proximoestado <= 44; --DEC RX IF NOT ZERO	
				--BIT SET, PORT A.
				elsif (salidair >= BSI_0_PORTA and salidair <= BSI_7_PORTA) then proximoestado <= 110;					
				--BIT CLR, PORT A.
				elsif (salidair >= BCI_0_PORTA and salidair <= BCI_7_PORTA) then proximoestado <= 111;	
				--STR RXL, PORT A
				elsif (salidair = STR_RX_PORTA) then proximoestado <= 112;
				--INC PORT A
				elsif (salidair = INC_PORTA) then proximoestado <= 113;
				--DEC PORT A
				elsif (salidair = DEC_PORTA) then proximoestado <= 114;
				elsif (salidair = LDI_RXL_PORTB) then proximoestado <= 120;				
				end if;						                         
    			state_cu <= X"08";		

			when 9 =>               --INC "RX"
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				resetrx <= '0';				
				opselecrx <= "01";
--				escribirir <= '1';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"09";				
				proximoestado <= 14;

			when 10 =>              --CLR "RX"
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "01";
				resetrx <= '1';				
				opselecrx <= "10";
--				escribirir <= '1';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"0A";				
				proximoestado <= 13;

			when 11 =>              --DEC "RX"
--				selecmuxmar <= '0';
--          wren <= '0';				
--				opselecpc <= "00";
--				resetrx <= '0';				
				opselecrx <= "11";
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"0B";				
				proximoestado <= 14;				
				
			when 12 => 
--				selecmuxmar <= '0';
--          wren <= '0';				
--				opselecpc <= "00";
--				resetrx <= '0';				
--				opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"0C";				
				proximoestado <= 14;				

			when 13 =>             --VIENE DE LA RUTINA DE CLR "RX"
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
				resetrx <= '0';	  --BAJO LA LINEA DE RESET DE "RX"			
--    		opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"0D";				
				proximoestado <= 14;	

			when 14 => 
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				resetrx <= '0';				
				opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"0E";				
				proximoestado <= 15;

			when 15 =>                --INC PC16R
--				selecmuxmar <= '0';			
--          wren <= '0';				
				opselecpc <= "01";
--				resetrx <= '0';				
--				opselecrx <= "00";
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"0F";				
				proximoestado <= 1;

			when 16 => 		--VIENE DE DETECCION DE "LDI_RX" O "LDD_RX" O "STR_RX" O
			               -- JMP_PC, JMP_PC_IF_Z, JMP_PC_IF_C O O JUMP TEST PORT_B	 
			               --YA QUE TENGO QUE LEER AL MENOS DOS VECES LA RAM 
--				selecmuxmar <= '0';								
--          wren <= '0';				
				opselecpc <= "01";    
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				proximoestado <= 17;
				state_cu <= X"10";	

			when 17 =>				
--				selecmuxmar <= '0';			
--          wren <= '0';				
				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';    
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				proximoestado <= 18;
				state_cu <= X"11";		

			when 18 =>				
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
				escribirmar <= '1';
--				escribirmdri <= '0';  
--				escribirmdro <= '0';
				proximoestado <= 19;
				state_cu <= X"12";					
	
			when 19 =>				
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";   
--				resetrx <= '0'; 
--				escribirir <= '0';
				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				proximoestado <= 20;
				state_cu <= X"13";					
				
			when 20 =>				
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";    
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '1';
--				escribirmdro <= '0';
				proximoestado <= 21;   
				state_cu <= X"14";					

			when 21 => 
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"15";				
				proximoestado <= 22;				
--          HASTA AQUI SE TIENE EL SEGUNDO OPERANDO QUE PUEDE SER UN DATO
--          (LDI RX)O PUEDE SER UNA POSICION DE MEMORIA (LDD_RX O STR_RX
            --U OPERACIONES ENTRE RX Y MEMORIA DE DATOS O SALTOS)  O JUMP TEST PORT_B				

			when 22 => 		
				if (salidair = LDI_RX) then proximoestado <= 23; 
				elsif (salidair = LDD_RX or salidair = STR_RX or
				salidair = RX_PLUS_MEM or salidair = RX_PLUS_MEM_PLUS_C or 
				salidair = RX_MINUS_MEM or salidair = RX_MINUS_MEM_MINUS_C or 
				salidair = RX_AND_MEM or salidair = RX_NAND_MEM or 
				salidair = RX_OR_MEM or salidair = RX_NOR_MEM or 
				salidair = RX_XOR_MEM or salidair = RX_XNOR_MEM) then proximoestado <= 25;
				elsif (salidair = JMP_PC or salidair = JMP_PC_IF_Z or 
				salidair = JMP_PC_IF_C) then proximoestado <= 47;
				elsif (salidair >= BTJIC_0_PORTB and salidair <= BTJIC_7_PORTB) or 
				(salidair >= BTJIS_0_PORTB and salidair <= BTJIS_7_PORTB) then proximoestado <= 130;
				end if;
				state_cu <= X"16";				

			when 23 =>      --SALTA DESDE LDI_RX O PARA COMPLETAR LDD_RX
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
				opselecrx <= "10";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"17";				
				proximoestado <= 24;	
		
			when 24 => 
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '1';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"18";				
				proximoestado <= 15;	

-- Para las instrucciones (LDD_RX y STR_RX) y operaciones entre RX y MEM, hay que 
-- direccionar la memoria RAM para leer o escribir.
-- Hay que poner selecmuxmar en "1" para que contenido de MDRI sea la nueva direccion 
-- de la RAM de datos y dejarlo asi hasta completar la operacion.
-- Luego se debe hacer una eleccion:
-- Si la instruccion es 0500, hay que leer su contenido y cargarlo en RX.
-- Si son operaciones entre RX y MEM, hay saltar a la rutina de atencion de operaciones
-- solo con RX (NOT_RX, SWAP_RX, ETC.).
-- Si la instruccion es 0600, hay que escribir su contenido con el valor de RX.	
-- Finalmente se debe volver a poner selecmuxmar = "0" y saltar a estado.
		
			when 25 => 
				selecmuxmar <= '1';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"19";				
				proximoestado <= 26;	

			when 26 => 
				selecmuxmar <= '1';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
				escribirmar <= '1';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"1A";				
				proximoestado <= 27;	
				
			when 27 => 
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"1B";				
				proximoestado <= 28;		
	
			when 28 =>        		--SE PRESELECCIONA EMTRADA MAR CON SALIDA PC16R
				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"1C";				
				proximoestado <= 29;	

-- Debo decidir si leo o escribo a la memoria RAM
-- APROVECHO TAMBIEN PARA SALTAR SI LAS INSTRUCCIONES SON OPERACIONES ENTRE RX Y MEM
-- U OPERACIONES DE SALTO				
			when 29 =>
				if (salidair = LDD_RX) then proximoestado <= 30;
				elsif (salidair = RX_PLUS_MEM or salidair = RX_PLUS_MEM_PLUS_C or 
				salidair = RX_MINUS_MEM or salidair = RX_MINUS_MEM_MINUS_C or 
				salidair = RX_AND_MEM or salidair = RX_NAND_MEM or 
				salidair = RX_OR_MEM or salidair = RX_NOR_MEM or salidair = RX_XOR_MEM or
				salidair = RX_XNOR_MEM) then proximoestado <= 42;
				else proximoestado <= 32; --Aqui si es STR_RX
				end if;					
				state_cu <= X"1D";
				
--       RUTINA PARA LDD_RX 
			when 30 =>             
--      		selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"1E";				
				proximoestado <= 31;									

			when 31 => 
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"1F";				
				proximoestado <= 23;		 --APROVECHO PARTE DE LA INSTRUCCION LDI_RX			


			when 32 =>      --SALTO DESDE ESTADO "29" PARA ESCRIBIR RAM DE DATOS
--				selecmuxmar <= '0';			
--            wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
				escribirmdro <= '1';
				state_cu <= X"20";				
				proximoestado <= 33;

			when 33 =>               
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
				escribirmdro <= '0';
				state_cu <= X"21";				
				proximoestado <= 34;

			when 34 =>               
--				selecmuxmar <= '0';			
				wren <= '1';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"22";				
				proximoestado <= 35;

			when 35 =>               
--				selecmuxmar <= '0';			
            wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"23";				
				proximoestado <= 15;  --SALTO PARA INCREMENTAR SALIDA PC16R 

			when 36 =>   
			   escribiralu <= '1';
--          selecaulu <= "00000";
--          selecmuxrx <= '0';			
--				selecmuxmar <= '0';			
--				wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"24";				
				proximoestado <= 37;				

			when 37 =>   
			   escribiralu <= '0';			
--          selecaulu <= "00000";
            selecmuxrx <= '1';			
--				selecmuxmar <= '0';			
--				wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"25";				
	         proximoestado <= 38; 			
				
			when 38 =>   
            selecmuxrx <= '1';			
--				selecmuxmar <= '0';			
--				wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"26";				
				proximoestado <= 39;

			when 39 =>   
--          selecaulu <= "00000";
            selecmuxrx <= '1';			
--				selecmuxmar <= '0';			
--				wren <= '0';				
--				opselecpc <= "00";
				opselecrx <= "10";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"27";				
				proximoestado <= 40;
				
			when 40 =>   
--          selecalu <= "00000";
            selecmuxrx <= '1';			
--				selecmuxmar <= '0';			
--				wren <= '0';				
--				opselecpc <= "00";
				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"28";				
				proximoestado <= 41;				

			when 41 =>   
--          selecalu <= "00000";
            selecmuxrx <= '0';			
--				selecmuxmar <= '0';			
--				wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"29";				
				proximoestado <= 52;	--TERMINA RUTINAS OPERACIONES CON ALU			

			when 42 =>             
--      		selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"2A";				
				proximoestado <= 43;									

			when 43 => 
--				selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
				escribirmdri <= '0';
--				escribirmdro <= '0';
				state_cu <= X"2B";				
				proximoestado <= 36;	
				
			when 52 =>
				escribirccr <= '1';
--      		selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"34";				
				proximoestado <= 53;				
		
			when 53 =>
			   escribirccr <= '0';
--      		selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"35";				
				proximoestado <= 15;												
											
											
			when 44 =>      --Salta si "1300" (DEC RX IF NOT ZERO)
				if (salidarx = X"0000") then proximoestado <= 52; --A escribir CCR
				else proximoestado <= 45; --Salta para decrementar RX porque no es cero.
				end if;
				state_cu <= X"2C";											

			when 45 =>             
--      		selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
				opselecrx <= "11";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"2D";				
				proximoestado <= 46;		

			when 46 =>             
--      		selecmuxmar <= '0';			
--          wren <= '0';				
--				opselecpc <= "00";
				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				state_cu <= X"2E";				
				proximoestado <= 44;				

			when 47 =>	--HASTA AQUI SE LLEGA SI LAS INSTRUCCIONES SON DE SALTO
			            --CON MDRI CARGADO CON LA POSIBLE NUEVA DIRECCION DE PROG.
				if (salidair = JMP_PC) then proximoestado <= 48;
				elsif (salidair = JMP_PC_IF_Z) then proximoestado <= 50;
				elsif (salidair = JMP_PC_IF_C) then proximoestado <= 51;
				else proximoestado <= 1;
				end if;					
				state_cu <= X"2F";								

   		when 48 => 			
--      		selecmuxmar <= '0';			
--          wren <= '0';				
				opselecpc <= "10";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				proximoestado <= 49;
				state_cu <= X"30";	

			when 49 => 			
--      		selecmuxmar <= '0';			
--          wren <= '0';				
				opselecpc <= "00";
--				opselecrx <= "00";
--				resetrx <= '0'; 
--				escribirir <= '0';
--				escribirmar <= '0';
--				escribirmdri <= '1';
--				escribirmdro <= '0';
				proximoestado <= 1;
				state_cu <= X"31";
			
   	when 50 =>
			if  (zero = '1' or salidarx = X"0000") then proximoestado <= 48;
			else proximoestado <= 15;
			end if;
			state_cu <= X"32";

		when 51 =>
			if  carryout = '1' then proximoestado <= 48;
			else proximoestado <= 15;
			end if;
			state_cu <= X"33";

		when 110 =>                --Atiende BIT SET de PORT_A 
--				escribirregpb <= '0';
            opselecregpa <= "100";
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 115;			
				state_cu <= X"6E";		

		when 111 =>                --Atiende BIT CLR de PORT_A 
--				escribirregpb <= '0';
            opselecregpa <= "101";
--            resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 115;					
				state_cu <= X"6F";	
				
		when 112 =>                --Atiende STR RXL, PORT A
--				escribirregpb <= '0';
            opselecregpa <= "010";
--            resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 115;					
				state_cu <= X"70";					
			
			when 113 =>                --Atiende INC, PORT A
--				escribirregpb <= '0';
            opselecregpa <= "001";
--           resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 115;			
				state_cu <= X"71";	

			when 114 =>                --Atiende DEC, PORT A
--				escribirregpb <= '0';
            opselecregpa <= "011";
--           resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 115;			
				state_cu <= X"72";					

			when 115 =>	
--				escribirregpb <= '0';
            opselecregpa <= "000";
--            resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 15;					
				state_cu <= X"73";					


			when 120 =>                --Atiende LDI_RXL_PORTB
				escribirregpb <= '1';   --ESCRIBE REGPB 
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 121;					
				state_cu <= X"78";				
			
			when 121 =>        
				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '1';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 122;					
				state_cu <= X"79";			
	
			when 122 =>					
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
				selecmuxmdri <= '1';		--DIRECCIONA SALIDA "REGPB" HACIA ENTRADA DE "MDRI"		  		
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 123;					
				state_cu <= X"7A";				

			when 123 =>        
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
				selecmuxmdri <= '1';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
				escribirmdri <= '1';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 124;					
				state_cu <= X"7B";					
			

			when 124 =>					
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 125;					
				state_cu <= X"7C";				

			when 125 =>        
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
				opselecrx <= "10";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 126;					
				state_cu <= X"7D";				

			when 126 =>        
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 127;					
				state_cu <= X"7E";				

			when 127 =>        
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 15;					
				state_cu <= X"7F";				

			when 130 =>              --COMIENZO RUTINAS DE TEST BIT SET/RESET PORT_B
				escribirregpb <= '1';   --ESCRIBE REGPB 
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';		
				proximoestado <= 131;	
				state_cu <= X"82";				
			
			
			when 131 =>
				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '1';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
				proximoestado <= 132;
				state_cu <= X"83";	

			when 132 =>	
				if (salidair >= BTJIC_0_PORTB and salidair <= BTJIC_7_PORTB) then
			   proximoestado <= 133; 	
				else proximoestado <= 134;
				end if;			
				state_cu <= X"84";

			when 133 =>                --Atiende TEST BIT I, SKIP IF CLR de PORT_B 
				result_and <= salidacode(7 downto 0) and salidaregpb(7 downto 0);
				if (result_and = cero) then proximoestado <= 48; --Carga nuevo valor de PC
				else proximoestado <= 15;		--Incrementar PC  --> volver a state 1)			
				end if;
				state_cu <= X"85";		

			when 134 =>                --Atiende TEST BIT I, SKIP IF CLR de PORT_B
				result_and <= salidacode(7 downto 0) and salidaregpb(7 downto 0);
				if (result_and = cero) then proximoestado <= 15;				
				else proximoestado <= 48; --Carga nuevo valor de PC
				end if;
				state_cu <= X"86";		        
			
  		when others => null;
		end case;		
	end process;	

	process (salidair)
		begin
			if salidair(0) = '0' then carryinalu <= '0';
			else carryinalu <= carryout;
			end if;
	end process;
	
		clock_in_div <= clock_up16;
		clock <= clock_out_div;
		clockpc <= clock_out_div;		
		clockmar <= clock_out_div;
		clockmdro <= clock_out_div;
		clockmdri <= clock_out_div;
		clockrx <= clock_out_div;	
	   clockir <= clock_out_div;	
		clockalu <= clock_out_div;
		clockccr <= clock_out_div;
		clockregpa <= clock_out_div;
		clockregpb <= clock_out_div;
		entradamuxmar0 <= salidapc;
		entradamuxmar1 <= salidamdri;
		entradamar <= salidamuxmar;		
		address <= salidamar (11 downto 0);
		entradarx <= salidamuxrx;
		entradaalua <= salidarx;
		entradaalub <= salidamdri;
		entradamuxrx0 <= salidamdri;
		entradamuxrx1 <= salidaalu;
		entradair <= salidamdri;
		entradapc <= salidamdri;
		entradamdro <= salidarx;
		selecalu <= salidair(4 downto 0);
		data <= salidamdro;
		entradaccr(15 downto 0) <= salidarx;
		entradaccr (16) <= carryoutalu;
		zero <= salidaccr(0);
		carryout <= salidaccr(1);
		entradamuxmdri0 <= q; 
		entradamuxmdri1 <= salidaregpb;
		entradaregpb <= PORT_B;
		entradamdri <= salidamuxmdri;
		entradaregpa <= salidarx;
		selcoderegpa <= salidair(7 downto 4); --REGPA recibe el codigo de bit desde IR		
		PORT_A <= salidaregpa;
end Comportamiento;

--    EN VHDL, EN VEZ DE USAR LA "X" DE DONT'CARE SE DEBE EMPLEAR EL SIGNO "-". 


----   MODELO DE ESTADO DE MAQUINA PARA COPIAR ------------------
--			when  =>        
--				escribirregpb <= '0';    
--          opselecregpa <= "000";
--          resetregpa <= '0';
--				resetregpa <= '0';
--				selecmuxmdri <= '0';			
--				selecalu <= "00000";	
--				selecmuxrx <= '0';
--				selecmuxmar <= '0';
--				resetpc <= '0';		      
--				opselecpc <= "00";
--				escribirmar <= '0';				
--				resetrx <= '0';
--				opselecrx <= "00";				
--				escribirmdri <= '0';
--				escribirmdro <= '0';
--				escribirir <= '0'; 				
--				wren <= '0';
--				proximoestado <= ;				
--				state_cu <= X"";	

