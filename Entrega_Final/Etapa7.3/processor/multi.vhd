library ieee;
USE ieee.std_logic_1164.all;
use work.exc_code.all;

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
			int_e		: IN  STD_LOGIC;
			div_z		: IN  STD_LOGIC; --exc signal
			no_al		: IN  STD_LOGIC; --exc signal
			ill_ins_l	: IN  STD_LOGIC; --exc signal
			call_l		: IN  std_LOGIC; --exc signal
			protect_l 	: IN  std_LOGIC; --exc signal	
			pp_tlb_d_l	: in  std_LOGIC; --exc signal
			immed_x2_l	: IN  STD_LOGIC;
			sys_priv_lvl: IN  std_logic;
			EXC_info 	: IN  STD_LOGIC_Vector(15 downto 0); --VECTOR que indica les excepcions
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
			inta		: OUT STd_LOGIC;
			exca		: OUT STd_LOGIC;
			ldpc		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			int_type	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			estat_out	: OUT std_logic_vector(1 downto 0);
			exc_code	: OUT exc_code_t;
			privilege_lvl : out std_logic;
			addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
end entity;

architecture Structure of multi is

signal estat : std_logic_vector(1 downto 0) := "00";
signal exc_code_b : exc_code_t := no_exc_c;
signal exc_code_reg : exc_code_t;
signal priv_level : std_logic;
signal privilege_lvl_b : std_logic;
signal acces_mem_b : std_logic;
signal ill_ins_b : std_logic;
signal pp_tlb_b : std_logic;

component exc is
	port(	clk 		: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			no_al		: IN  STD_LOGIC;--
			ill_ins		: IN  STD_LOGIC;--
			interrupt	: IN  STD_LOGIC;--
			div_z		: IN  STD_LOGIC;--
			acces_mem	: IN  STD_LOGIC;--
			pp_tlb_d : IN  STD_LOGIC;--
			protect : IN  STD_LOGIC;		--
			call	: IN  STD_LOGIC;		 --
			exc_code	: OUT exc_code_t
			);
end component;

	 
begin
	-- Actualitzacio de l'estat
	process (clk, exc_code_b) begin
		if rising_edge(clk) then 
			if boot = '0' then			-- Si estem a RUN
				inta <= '0';
				exca <= '0';
				
				if halt_cont = '1' then	-- Si HALT -> HALT
						estat <= "11";
				
				-- excepcio de instruccio pocha REVISAR
				elsif (exc_code_b = no_al_c or exc_code_b = protec_c) and estat = "00" then			-- A la Rutina de no_al si es una instruccio fem pc-1 i reexecutem
					estat <= "10";
					exca <= '1';
				elsif exc_code_b /= no_exc_c and exc_code_b /= interrupt_c and estat = "01" then	-- Si salta una excepcio en Decode
					estat <= "10";
					exca <= '1';
				elsif interrupt = '1' and estat = "01" and int_e = '1' then	-- Si hi ha interrup en Decode i estan enable ens podem en estat SYSTEM
					estat <= "10"; 
					inta <= '1';
				else
					if halt_cont = '1' then	-- Si HALT -> HALT
						estat <= "11";
					elsif estat = "00" then -- Si estem a FETCH -> DECODE
						estat <= "01";
					elsif estat = "01" then -- Si estem a DECODE -> FETCH
						estat <= "00";
					else 					-- Si estem en SYSTEM -> FETCH
						estat <= "00";
					end if;
				end if;
			else 						-- Si estem a BOOT
				estat <= "00";
			end if;
		end if;
	end process;
	
	-- HALT quan ens diuen de parar, ldpc_l quan estem a DECODE, else RUN
	ldpc <= "011" when estat = "00" and halt_cont = '1' else -- pot ser estat 01?
			ldpc_l when estat = "01" else 
			"101" when estat = "10" else -- SYSTEM
			"011" when estat = "11" else
			"000"; 
			
	estat_out <= estat;

-- Sempre en Decode passem la dada; sha de mirar que fer en interrupcio, el estat SYSTEM "10"


	with estat select
		word_byte <=  	'0' when "00",
						'0' when "10",
						'0' when "11",
						w_b when others;
						
	with estat select
		wr_m <=	'0' when "00",
				'0' when "10",
				'0' when "11",
				wr_m_l when others;
								
	with estat select
		wrd <=  '0' when "00",
				'0' when "10",
				'0' when "11",
				wrd_l when others;
			
	with estat select
		wrd_s <=  	'0' when "00",
					'0' when "10",
					'0' when "11",
					wrd_s_l when others;
			
	with estat select
		int_type <=	"11" when "00",	-- "11" es no interrupcio
					"11" when "10",
					"11" when "11",
					int_type_l when others;
		
	with estat select
		u_s <=  '0' when "00",
				'1' when "10",
				'0' when "11",
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
					'0' when "11",
					rd_in_l when others;
				
	with estat select
		wr_out <=  	'0' when "00",
					'0' when "10",
					'0' when "11",
					wr_out_l when others;
	
	-- ldir indica si carreguem el Instruction register amb la dad de memoria (carreguem en estat fetch)
	ldir <= '1' when estat = "00" else 
			'0' when estat = "10" else
			'0' when estat = "11" else
			'0';
	
	-- ins_dad indica que posem al bus, si instruccions(0) o dades(1)
	ins_dad <= 	'0' when estat = "00" else 
				'0' when estat = "10" else
				'1' when estat = "11" else
				'1';
	
	
	
	
	
	-----------------------------
	----- Control Excecions -----
	-----------------------------
	
	privilege_lvl <= sys_priv_lvl;
	-- privilege_lvl <= priv_level;
	-- Ens guardem el codi d'excepcio quan no sigui No_exception i no estiguem a Boot per evitar un ill_ins al bootar
	process (exc_code_b, boot, ldpc_l, clk) begin
		if rising_edge(clk) then
			if boot = '1' then						-- Boot
				exc_code <= no_exc_c;
				priv_level <= '1';
			--elsif (exc_code_b /= no_exc_c and sys_priv_lvl = '0') or exc_code_b = call_c then		-- Exc /= no_exc
			elsif exc_code_b /= no_exc_c  then		-- Exc /= no_exc
				exc_code <= exc_code_b;
				
				-- Si hi ha excepcio i li fem cas posem priv_level = 1. En cas de no_al o protec(REVISAR) pot saltar en estat 00
				if (exc_code_b /= no_exc_c and exc_code_b /= interrupt_c and estat = "01") or ((exc_code_b = no_al_c or exc_code_b = protec_c) and estat = "00") then 
					priv_level <= '1';
				end if;
				
			elsif ldpc_l = "100" then 		-- Si es un RETI borrem la el codi de interupcio i priv_level = 0 
				priv_level <= '0';
				exc_code <= no_exc_c;
			elsif interrupt = '1' and estat = "01" and int_e = '1' then		-- Si entrem a una interrupcio priv_level = 1
				priv_level <= '1';
			end if;
			
		end if;
	end process;
	
	ill_ins_b <= '1' when call_l = '1' and sys_priv_lvl = '1' else ill_ins_l;
	--ill_ins_b <= '1' when call_l = '1' and priv_lvl = '1' else ill_ins_l;
	-- Marquem que accedim a memoria en FETCH, en immed_x2 = 1 en ST i LB
	acces_mem_b <= '1' when estat = "00" or (estat = "01" and immed_x2_l = '1') else '0';
	
	-- Marquem que accedim a pagina protegida en DECODE, ST/B i LB/B
	pp_tlb_b <= pp_tlb_d_l when estat = "01" and (immed_x2_l = '1' or w_b = '1') else '0';

				
	exception_controller : exc port map(	clk			=> clk,
											boot 		=> boot,
											ill_ins 	=> ill_ins_b,
											no_al		=> no_al,
											div_z		=> div_z,
											interrupt	=> interrupt,
											acces_mem	=> acces_mem_b,
											pp_tlb_d => pp_tlb_b,			
											protect => protect_l,
											call	=> call_l,
											exc_code	=> exc_code_b
											);
								
								
end Structure;
