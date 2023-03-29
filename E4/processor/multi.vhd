library ieee;
USE ieee.std_logic_1164.all;

entity multi is
    port(	clk      : IN  STD_LOGIC;
			boot      : IN  STD_LOGIC;
			ldpc_l    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd_l     : IN  STD_LOGIC;
			wr_m_l    : IN  STD_LOGIC;
			w_b       : IN  STD_LOGIC;
			halt_cont : IN  STD_LOGIC;
			ldpc      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd       : OUT STD_LOGIC;
			wr_m      : OUT STD_LOGIC;
			ldir      : OUT STD_LOGIC;
			ins_dad   : OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
end entity;

architecture Structure of multi is

signal estat : std_logic := '0';
	 
begin
	-- Actualitzacio de l'estat
	process (clk) begin
		if rising_edge(clk) then 
			if boot = '0' then			-- Si estem a RUN
				estat <= not estat;
			else 						-- Si estem a BOOT
				if halt_cont = '1' then	-- REVISAR aixo
					estat <= '1';		
				else					
					estat <= '0';
				end if;
			end if;
		end if;
	end process;
	
	-- HALT quan ens diuen de parar, ldpc_l quan estem a DECODE, else RUN
	ldpc <= "11" when estat = '0' and halt_cont = '1' else 
			ldpc_l when estat = '1' else "00"; 

	-- 	En DECODE pasem la dada
	with estat select
		word_byte <=  	'0' when '0',
						w_b when others;
						
	-- 	En DECODE pasem la dada
	with estat select
		wr_m <=  '0' when '0',
					wr_m_l when others;
					
	-- 	En DECODE pasem la dada				
	with estat select
		wrd <=  '0' when '0',
				wrd_l when others;
	
	-- ldir indica si carreguem el Instruction register amb la dad de memoria (carreguem en estat fetch)
	ldir <= not estat;
	
	-- inc_dad indica que posem al bus, si instruccions(0) o dades(1)
	ins_dad <= estat;
	 
end Structure;
