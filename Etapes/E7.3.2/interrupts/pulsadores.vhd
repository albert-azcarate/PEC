LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use work.all;


ENTITY pulsadores IS
	PORT (
		boot		: in std_logic;
		clk		: in std_logic;
		inta		: in std_logic;
		keys		: in std_logic_vector(3 downto 0);
		intr 		: out std_logic;
		read_key : out std_logic_vector(3 downto 0)
	);
END pulsadores;

ARCHITECTURE Structure OF pulsadores IS

	signal actual_state : std_logic_vector(3 downto 0) := x"0";
	signal interrupt : std_logic := '0';
	
begin

	process(clk, boot, keys, inta) begin
		if rising_edge(clk) then
			if boot = '1' then -- Si estem a boot
				actual_state <= keys;
				interrupt <= '0';
			else -- RUN
				interrupt <= interrupt;
				
				if inta = '0' and interrupt = '0' then
					if actual_state /= keys then 	-- actualitzem el status i informem que hi ha una interrupcio
						actual_state <= keys;
						interrupt <= '1';
					end if;
				elsif inta = '1' then
					interrupt <= '0';				-- si hi ha un ack apaguem int
				end if;
			
			end if;
		end if;
	end process;

	intr <= interrupt;
	read_key <= actual_state;
	
end structure;
