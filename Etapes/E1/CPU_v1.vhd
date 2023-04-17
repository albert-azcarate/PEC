-- 
-- Input: ->  bits
-- Output: ->  bits

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;


ENTITY CPU_v1 IS

-- generics


-- ports
	PORT(	CLOCK_50 : in  STD_LOGIC;
			LEDR : OUT std_logic_vector (2 downto 0);
			KEY : IN std_logic_vector ( 0 downto 0);
			SW  : IN STD_LOGIC_VECTOR  (2 DOWNTO 0));
			
END CPU_v1;

ARCHITECTURE Structure OF CPU_v1 IS

-- constants

-- components
	component clock is
		generic(
			factor : integer := 1
		);
		PORT( CLOCK_50_in : IN std_logic;
				CLOCK_output : OUT std_logic);
	end component;

	
-- variables
signal is_second : std_logic;

BEGIN
	
	-- mapping
	clock_counter : clock generic map(factor => 2)
						port map (CLOCK_50_in => CLOCK_50, CLOCK_output => is_second);			
			
	
	
END Structure;