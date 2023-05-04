LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
use work.all;

ENTITY interrupt_controller IS
	PORT (
		boot			: in std_logic;
		clk			: in std_logic;
		inta			: in std_logic;
		intr 			: out std_logic;
		key_intr 	: in std_logic;
		ps2_intr		: in std_logic;
		switch_intr	: in std_logic;
		timer_intr	: in std_logic;
		key_inta		: out std_logic;
		ps2_inta		: out std_logic;
		switch_inta	: out std_logic;
		timer_inta	: out std_logic;
		iid			: out std_logic_vector(7 downto 0)
	);
END interrupt_controller;

ARCHITECTURE Structure OF interrupt_controller IS

begin

	process (boot, clk) begin 
		if boot = '1' then
		else 
			if rising_edge(clk) then

				-- En el cas que inta = '1' posarem el iid al bus d'interrupcions i fem ack a la interrupcio
				if timer_intr = '1' and inta = '1' then		-- Interrupcio de timer
					timer_inta <= '1';
					iid <= x"00";
				elsif key_intr = '1' and inta = '1' then		-- Interrupcio de teclat
					key_inta <= '1';
					iid <= x"01";
				elsif switch_intr = '1' and inta = '1' then	-- Interrupcio de switch
					switch_inta <= '1';
					iid <= x"02";
				elsif ps2_intr = '1' and inta = '1' then		-- Interrupcio de ps2
					ps2_inta <= '1';
					iid <= x"03";
				
				-- Si no hi han interrupcions, acks = 0
				else
					timer_inta <= '0';
					key_inta <= '0';
					switch_inta <= '0';
					ps2_inta <= '0';
					iid <= x"FF";
				end if;
			end if;
		end if;
	end process;
	
	intr <= (key_intr or timer_intr) or (ps2_intr or switch_intr);
	
end structure;