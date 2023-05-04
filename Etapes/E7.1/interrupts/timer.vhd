LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
use work.all;

ENTITY timer IS
	PORT (
		boot		: in std_logic;
		clk		: in std_logic; --20ns
		inta		: in std_logic;
		intr 		: out std_logic
	);
END timer;

ARCHITECTURE Structure OF timer IS

	signal count : std_logic_vector(9 downto 0) :=(others => '0');
	signal interrupt : std_logic := '0';
	
begin

	process(clk, boot) begin
		if boot = '0' then
			if rising_edge(clk) then
				interrupt <= interrupt;
				if interrupt = '0' then --si no hi ha una interrupció previa i les tractes diferent: actualitzem el status i informem que hi ha una interrupció
					if count < x"03E8" then
						count <= count + 1;
					else 
						interrupt <= '1';
						count <= (others => '0');
					end if;
				else --si hi ha una interrupció i ack enviem la dada i apaguem el int
					if inta = '1' then
						interrupt <= '0';
					end if;
				end if;
				
			end if;
		end if;
	end process;

	intr <= interrupt;
	
end structure;
