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

	process(clk, boot, switches, inta) begin
		if rising_edge(clk) then
			if boot = '1' then -- Si estem a boot
				actual_state <= switches;
				interrupt <= '0';
			else -- RUN
				interrupt <= interrupt;
				if inta = '0' and interrupt = '0' then
					if actual_state /= switches then 	-- actualitzem el status i informem que hi ha una interrupcio
						actual_state <= switches;		-- guardem l'estat actual
						interrupt <= '1';
					end if;
				elsif inta = '1' then
					interrupt <= '0'; 					-- si hi ha un ack apaguem int
				end if;
			end if;
		end if;
	end process;
	
	rd_switch <= switches;
	intr <= interrupt;
	
end structure;
