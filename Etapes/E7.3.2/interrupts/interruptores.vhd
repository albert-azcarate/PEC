LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use work.all;


ENTITY interruptores IS
	PORT (
		boot		: in std_logic;
		clk		: in std_logic;
		inta		: in std_logic;
		switches	: in std_logic_vector(8 downto 0);
		intr 		: out std_logic;
		rd_switch : out std_logic_vector(8 downto 0)
	);
END interruptores;

ARCHITECTURE Structure OF interruptores IS

	signal actual_state : std_logic_vector(8 downto 0) := "000000000";
	signal interrupt : std_logic := '0';
	
begin

	process(clk, boot, switches) begin
		if rising_edge(clk) then
			if boot = '1' then -- Si estem a boot
				actual_state <= "000000000";
				interrupt <= '0';
			else -- RUN
				interrupt <= interrupt;
				
				if actual_state /= switches then -- actualitzem el status i informem que hi ha una interrupciÃƒÂ³
					actual_state <= switches;
					interrupt <= '1';
					if inta = '1' then -- si hi ha una interrupcio i ack enviem la dada i apaguem el int
						interrupt <= '0';
						rd_switch <= actual_state;
					else
						rd_switch <= "000000000";
					end if;
				end if;
				
			end if;
			
		end if;
	end process;

	intr <= interrupt;
	
end structure;
