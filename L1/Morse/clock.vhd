-- Rellotge amb periode 1 segon, amb el generic es pot reduir o augmentar la frequencia
-- Input: Senyal de rellotge -> 1 bit
-- Output: Senyal periodica -> 1 bit

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY clock IS
	generic(
		factor : integer := 1
	);
	PORT( CLOCK_50_in : IN std_logic;
			CLOCK_output : OUT std_logic);
END clock;



ARCHITECTURE Structure OF clock IS

constant frequencia : integer := (50000000/factor)/2;
signal clock_count : integer := frequencia;
signal internal_clock: STD_logic := '0';

BEGIN

	process (CLOCK_50_in) begin
		if rising_edge(CLOCK_50_in) then
			if clock_count = 0 then
				clock_count <= frequencia;
				internal_clock <= not internal_clock ;
			else
				clock_count <= clock_count - 1;
			end if;
		end if;
	end process;

	CLOCK_output <=internal_clock;
	
END Structure;