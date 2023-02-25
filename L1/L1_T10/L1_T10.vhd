LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY L1_T10 IS
 PORT( CLOCK_50 : IN std_logic;
 HEX0 : OUT std_logic_vector(6 downto 0);
 HEX1 : OUT std_logic_vector(6 downto 0);
 HEX2 : OUT std_logic_vector(6 downto 0);
 HEX3 : OUT std_logic_vector(6 downto 0));
END L1_T10;

ARCHITECTURE Structure OF L1_T10 IS

	component BCD is 
	PORT(input : in std_logic_vector(15 downto 0);
		OUT_HEX0 : OUT std_logic_vector(6 downto 0);
		OUT_HEX1 : OUT std_logic_vector(6 downto 0);
		OUT_HEX2 : OUT std_logic_vector(6 downto 0);
		OUT_HEX3 : OUT std_logic_vector(6 downto 0));
	end component;
	
	component clock is
		generic(
			factor : integer := 1
		);
		PORT( CLOCK_50_in : IN std_logic;
		output : OUT std_logic);
	end component;


signal clock_count : std_logic_vector (25 downto 0) := "10111110101111000010000000";
signal number : std_logic_vector (15 downto 0) := x"0000";
signal is_second : std_logic := '0';
signal previous_second : std_logic := '0';
BEGIN
	
	
	clock_counter : clock generic map(factor => 10)
			port map (CLOCK_50_in => CLOCK_50, output => is_second);
	fake_bcd : BCD port map(input => number, out_HEX0 => HEX0, out_HEX1 => HEX1, out_HEX2 => HEX2, out_HEX3 => HEX3);
	
	process (is_second) begin
		if rising_edge(is_second)then
			number <= number + 1;
		end if;
		
--	if is_second = not previous_second then
--			number <= number + 1;
--		end if;
--		previous_second <= is_second;
	end process;
	
END Structure;