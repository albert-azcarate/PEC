LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY L1_T9 IS
 PORT( CLOCK_50 : IN std_logic;
 HEX0 : OUT std_logic_vector(6 downto 0));
END L1_T9;

ARCHITECTURE Structure OF L1_T9 IS

	component driver7Segmentos4in is 
		PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	end component;

signal clock_count : std_logic_vector (24 downto 0) := (others => '0');
signal number : std_logic_vector (3 downto 0) := "0000";

BEGIN
	process (CLOCK_50) begin
		if rising_edge(CLOCK_50) then
			clock_count  <= clock_count + 1;
			if clock_count = x"1FFFFFF" then
				number <= number + 1;
				if number >= "1001" then
					number <= "0000";
				end if;
			end if;
		end if;
	end process;

	D0: driver7Segmentos4in port map(codigoCaracter => number , bitsCaracter => HEX0);
	
END Structure;