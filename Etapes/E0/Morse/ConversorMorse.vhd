-- Conversor de lletra a pulsos de morse
-- Input: lletra a escriure -> 4 bits; bit d'inici d'escriptura -> 1 bit; senyal de rellotge -> 1 bit
-- Output: Puls unic a LEDR -> 1 bits

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY ConversorMorse IS

-- generics


-- ports
	PORT(	lletra : IN std_logic_vector (3 downto 0);
			inici : IN std_logic;
			clock : IN std_logic;
			reset : IN std_logic;
			ended : OUT std_logic;
			puls : OUT std_logic_vector (0 downto 0));
			
END ConversorMorse;

ARCHITECTURE Structure OF ConversorMorse IS

-- constants

-- components

-- variables
signal caracter_decode : std_logic_vector (12 downto 0) := (others => 'Z');
signal caracter_reg : std_logic_vector (12 downto 0) := (others => '0');
signal next_caracter : std_logic_vector (12 downto 0) := (others => '0');
signal next_puls : std_logic_vector (0 downto 0) := "0";
signal next_ended : std_logic := '0';

BEGIN
	
	process (clock) begin
		if rising_edge(clock) then
			next_ended <= '0';
			next_puls(0) <= '0';
			
			-- if reset puls a 0 i tot a Z
			if reset = '1' then
				next_puls(0) <= '0';
				next_caracter <= (others => 'Z');
				
			-- if not reset
			else
				-- si el bit de major pes es Z hem acabat
				if caracter_reg(12) = 'Z' then
					next_ended <= '1';
					next_puls(0) <= '0'; -- apagem el led i no fem shift_left
					next_caracter <= (others => 'Z');
					
				-- si el bit de major pes no es Z encara estem imprimint
				else
					next_puls(0) <= caracter_reg(12); -- asignar valor del bit de major pes al LEDR
					next_caracter <= caracter_reg(11 downto 0) & '0'; -- shift_left per tindre al seguent cicle el bit adient
				end if;
			end if;
		end if;
	end process;
	
	-- Decodificar lletra
	with lletra select
			caracter_decode <= 	"10111ZZZZZZ0Z" when "0000", -- a
										"1110101010ZZZ" when "0001", -- b
										"111010111010Z" when "0010", -- c
										"11101010ZZZZZ" when "0011", -- d
										"10ZZZZZZZZZZZ" when "0100", -- e
										"1010111010ZZZ" when "0101", -- f
										"1110111010ZZZ" when "0110", -- g
										"10101010ZZZZZ" when "0111", -- h
										"ZZZZZZZZZZZZZ" when others; -- -
							
	-- Escollir lletra inicial o seguent caracter
	with inici select
		caracter_reg <= 	caracter_decode when '1',
								next_caracter when others;
	-- Asignar led				
	puls <= next_puls;
	ended <= next_ended;
	
END Structure;