LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
--use work.all;

ENTITY timer IS
	PORT (
		boot		: in std_logic;
		clk		: in std_logic; --20ns
		inta		: in std_logic;
		intr 		: out std_logic
	);
END timer;

ARCHITECTURE Structure OF timer IS
	signal count : integer;
	--signal count : std_logic_vector(23 downto 0) :=(others => '0');
	signal interrupt : std_logic := '0';
	
begin

	process(clk, boot) begin
		if rising_edge(clk) then
			if boot = '1' then -- Si estem a boot
				count <= 0;--(others => '0');
				interrupt <= '0';
			else -- RUN
				
				if count = 2500000 then --x"2625a0" then		-- Si 20ns, count = 0, intr = 1
						count <= 0;
						--count <= (others => '0');
						interrupt <= '1';
				else 									-- else count += 1
					count <= count + 1;
					if inta = '1' and interrupt = '1' then -- si hi ha una interrupcio i ack apaguem el int
						interrupt <= '0';
					else 
						interrupt <= interrupt;	
					end if;
				end if;
			end if;
		end if;
	end process;

	intr <= interrupt;
	
end structure;
