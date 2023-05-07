LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use work.all;


ENTITY interruptores IS
	PORT (
		boot		: in std_logic;
		clk		: in std_logic;
		inta		: in std_logic;
		switches	: in std_logic_vector(7 downto 0);
		intr 		: out std_logic;
		rd_switch : out std_logic_vector(7 downto 0)
	);
END interruptores;

ARCHITECTURE Structure OF interruptores IS

	signal actual_state : std_logic_vector(7 downto 0) := x"00";
	signal interrupt : std_logic := '0';
	
begin

	process(clk, boot) begin
		if boot = '0' then
			if rising_edge(clk) then
				interrupt <= interrupt;
				if interrupt = '0' and actual_state /= switches then --si no hi ha una interrupció previa i les tractes diferent: actualitzem el status i informem que hi ha una interrupció
					actual_state <= switches;
					interrupt <= '1';
				elsif interrupt = '1' then --si hi ha una interrupció i ack enviem la dada i apaguem el int
					if inta = '1' then
						interrupt <= '0';
						rd_switch <= switches;
					else
						rd_switch <= x"00";
					end if;
					
					
				end if;
				
			end if;
		end if;
	end process;

	intr <= interrupt;
	
end structure;
