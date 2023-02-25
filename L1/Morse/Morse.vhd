-- 
-- Input: Rellotge -> 1 bit; Swicthes -> 3 bits; Botons -> 2 bits
-- Output: Leds verds i vermells -> 2 busos de 1 bit; 4 7-Segments -> 4 busos de 7 bits  

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.EstatsMorse.all;

entity Morse is

-- generics


-- ports
	PORT( CLOCK_50  : IN STD_LOGIC;
			SW        : IN STD_LOGIC_VECTOR  (2 DOWNTO 0);
			KEY		 : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
			LEDR		 : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
			LEDG		 : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
			HEX0 		 : OUT std_logic_vector(6 downto 0));
		
end entity morse;

architecture Structure of morse is

-- constants

-- components
	
	component clock is
		generic(
			factor : integer := 1
		);
		PORT( CLOCK_50_in : IN std_logic;
			CLOCK_output : OUT std_logic);
	end component;
	
	component driver7Segmentos4in IS
		port( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
				bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	end component;
	
	component ConversorMorse is
		PORT(	lletra : IN std_logic_vector (3 downto 0);
				inici : IN std_logic;
				clock : IN std_logic;
				reset : IN std_logic; 
				ended : OUT std_logic;
				puls : OUT std_logic_vector (0 downto 0));
	end component;
	

-- variables
signal is_second : std_logic := '0';

signal switch : std_logic_vector(3 DOWNTO 0) := "0000";
signal estat : estatsmorse_t := IDLE; -- 00 idle 01 start 10 working 11 reset
signal px_estat : std_logic_vector(1 downto 0) := "00";
signal inici_morse : std_logic := '0';
signal reset_morse : std_logic := '0';
signal ended_morse : std_logic;

begin
	
	
	-- mapping

	
	
	-- clock frequencia 0.5
	switch(2 downto 0) <= SW;
	clock_counter : 	clock generic map(factor => 2)
							port map (CLOCK_50_in => CLOCK_50, CLOCK_output => is_second);
	-- 7 segments 						
	segment : driver7Segmentos4in port map(codigoCaracter => switch ,bitsCaracter => HEX0);
	
	-- Morse conversor
	conv_morse : ConversorMorse port map(lletra => switch, inici => inici_morse, clock => is_second,  reset => reset_morse, ended => ended_morse , puls => LEDR);
	
	-- estat
	process (is_second, KEY) begin
		if rising_edge(is_second) then
			-- posada a 0
			inici_morse <= '0';
			px_estat <= IDLE;
			reset_morse <= '0';
			
			-- Podem eliminar l'estat RESET si anem directe a idle i posem reset_morse <= '1' aleshores
			-- Podem eliminar l'estat START si anem directe a working i posem inici_morse <= '1' aleshores
			
			if KEY(0) = '1' then -- Si reset
				px_estat <= RESET ;
				reset_morse <= '1';
				
			elsif estat = RESET then -- Si l'anterior cicle estavem en reset
				px_estat <= IDLE;
				
			elsif estat = START then -- si estavem al cicle inicial
				px_estat <= WORKING;
				inici_morse <= '1';
				
			elsif estat = WORKING and ended_morse = '1' then -- si estem a work i hem acabat, idle
				px_estat <= IDLE;
				-- reset_morse <= '1'; -- maybe
			
			elsif estat = WORKING then -- si estavem a working i no hem acabat, working
				px_estat <= WORKING;
			
			elsif estat = IDLE and KEY(1) = '1' then -- else si key(1) i estem en idle
				px_estat <= START;
				
			end if;
		end if;
	end process;
	
	estat <= px_estat;
	LEDG(0) <= not (estat(1) or estat(0)); 


end Structure;