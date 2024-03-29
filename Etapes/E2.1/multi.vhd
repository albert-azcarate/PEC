library ieee;
USE ieee.std_logic_1164.all;

entity multi is
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC);
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados

signal estat : std_logic := '0';
	 
begin

	process (clk) begin
		if rising_edge(clk) then
			if boot = '0' then
				estat <= not estat;
			else 
				estat <= '0';
			end if;
		end if;
	end process;
	
	
   with estat select
		ldpc <=  '0' when '0',
					ldpc_l when others;
					
	with estat select
		word_byte <=  	'0' when '0',
							w_b when others;
	
	with estat select
		wr_m <=  '0' when '0',
					wr_m_l when others;
					
	with estat select
		wrd <=  '0' when '0', --,
					wrd_l when others;
					
	ldir <= not estat;
	ins_dad <= estat;
	 
end Structure;
