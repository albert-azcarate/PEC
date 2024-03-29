library ieee;
USE ieee.std_logic_1164.all;

entity multi is
	port (	clk			: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			interrupt	: IN  STD_LOGIC;
			wrd_l		: IN  STD_LOGIC;
			wrd_s_l		: IN  STD_LOGIC;
			u_s_l		: IN  STD_LOGIC;
			wr_m_l		: IN  STD_LOGIC;
			w_b			: IN  STD_LOGIC;
			halt_cont	: IN  STD_LOGIC;
			rd_in_l		: IN  STD_LOGIC;
			wr_out_l	: IN  STD_LOGIC;
			int_e		: IN STD_LOGIC;
			ldpc_l		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			int_type_l	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a_l	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io_l	: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			wrd			: OUT STD_LOGIC;
			wrd_s		: OUT STD_LOGIC;
			u_s			: OUT STD_LOGIC;
			wr_m		: OUT STD_LOGIC;
			ldir		: OUT STD_LOGIC;
			ins_dad		: OUT STD_LOGIC;
			word_byte	: OUT STD_LOGIC;
			rd_in		: OUT STD_LOGIC;
			wr_out		: OUT STD_LOGIC;
			inta			: OUT STd_LOGIC;
			ldpc		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			int_type	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a		: OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
end entity;

architecture Structure of multi is

signal estat : std_logic_vector(1 downto 0) := "00";
	 
begin
	-- Actualitzacio de l'estat
	process (clk) begin
		if rising_edge(clk) then 
			if boot = '0' then			-- Si estem a RUN
				inta <= '0';
			
				if interrupt = '1' and estat = "01" and int_e = '1' then	-- Si hi ha interrup ens podem en estat interrupcio
					estat <= "10"; 
					inta <= '1';
				else
					if estat = "00" then -- Si estem a FETCH -> DECODE
						estat <= "01";
					elsif estat = "01" then -- Si estem a DECODE -> FETCH
						estat <= "00";
					else 					-- Si estem en SYSTEM -> FETCH
						estat <= "00";
					end if;
				end if;
			else 						-- Si estem a BOOT
				if halt_cont = '1' then	-- REVISAR aixo
					estat <= "01";		
				else					
					estat <= "00";
				end if;
			end if;
		end if;
	end process;
	
	-- HALT quan ens diuen de parar, ldpc_l quan estem a DECODE, else RUN
	ldpc <= "011" when estat = "00" and halt_cont = '1' else 
			ldpc_l when estat = "01" else 
			"101" when estat = "10" else -- SYSTEM
			"000"; 

-- Sempre en Decode passem la dada; sha de mirar que fer en interrupcio, el estat SYSTEM "10"


	with estat select
		word_byte <=  	'0' when "00",
							'0' when "10",
						w_b when others;
						
	with estat select
		wr_m <=  '0' when "00",
					'0' when "10",
					wr_m_l when others;
								
	with estat select
		wrd <=  '0' when "00",
				'0' when "10",
				wrd_l when others;
			
	with estat select
		wrd_s <=  	'0' when "00",
					'0' when "10",
					wrd_s_l when others;
			
	with estat select
		int_type <=	"11" when "00",	-- "11" es no interrupcio
					"11" when "10",
					int_type_l when others;
		
	with estat select
		u_s <=  '0' when "00",
				'1' when "10",
				u_s_l when others;
		
	with estat select -- En Fetch deixem el addr_io previ per facilitar la lectura
		addr_io <=  x"00" when "10",
					addr_io_l when others;
					
					
	with estat select
		addr_a <=  "101" when "10",
					addr_a_l when others;
				
	with estat select
		rd_in <=  	'0' when "00",
					'0' when "10",
					rd_in_l when others;
				
	with estat select
		wr_out <=  	'0' when "00",
					'0' when "10",
					wr_out_l when others;
	
	-- ldir indica si carreguem el Instruction register amb la dad de memoria (carreguem en estat fetch)
	ldir <= '1' when estat = "00" else 
			'0' when estat = "10" else
			'0';
	
	-- ins_dad indica que posem al bus, si instruccions(0) o dades(1)
	ins_dad <= 	'0' when estat = "00" else 
				'0' when estat = "10" else
				'1';
	 
end Structure;
