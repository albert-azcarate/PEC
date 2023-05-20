LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
--use work.all;
use work.op_code.all;
use work.f_code.all;
use work.exc_code.all;

ENTITY unidad_control IS
	PORT (	boot			: IN  std_logic;
			clk				: IN  std_logic;
			z				: IN  std_logic;
			intr			: IN  std_logic;
			int_e			: IN  STD_LOGIC;
			div_z			: IN  STD_LOGIC;
			no_al			: IN  STD_LOGIC;
			pp_tlb_dx		: IN  STD_LOGIC;
			sys_priv_lvl	: IN  std_logic;
			exc_tlb			: IN  std_logic_vector(3 downto 0);	
			datard_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out			: IN  STD_LOGIC_VECTOR(15 downto 0);
			op				: OUT op_code_t;
			f				: OUT f_code_t;
			exc_code		: OUT exc_code_t;
			wrd				: OUT std_logic;
			wrd_s			: OUT std_logic;
			u_s				: OUT std_logic;
			ins_dad			: OUT std_logic;
			immed_x2		: OUT std_logic;
			wr_m			: OUT std_logic;
			ld_m			: OUT STD_LOGIC;
			word_byte		: OUT std_logic;
			immed_or_reg	: OUT std_logic;
			rd_in			: OUT std_logic;
			wr_out			: OUT std_logic;
			inta			: OUT STD_LOGIC;
			exca			: OUT STd_LOGIC;
			privilege_lvlz	: out std_LOGIC;
			estat_multi		: OUT std_logic_vector(1 downto 0);
			in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			int_type		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			TLB_Com			: out std_LOGIC_VECTOR(2 downto 0);
			addr_b			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			immed			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc				: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS
	
	component control_l is
	PORT (	ir				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			privilege_lvl_l : in  std_LOGIC;
			boot			: IN  STD_LOGIC;
			clk				: IN  STD_LOGIC;
			estat_multi		: IN  std_logic_vector(1 downto 0);
			op				: OUT op_code_t;
			f				: OUT f_code_t;
			wrd				: OUT STD_LOGIC;
			wrd_s			: OUT STD_LOGIC;
			u_s				: OUT STD_LOGIC;
			wr_m			: OUT STD_LOGIC;
			ld_m			: OUT STD_LOGIC;
			immed_x2		: OUT STD_LOGIC;
			word_byte		: OUT STD_LOGIC;
			immed_or_reg	: OUT STD_LOGIC;
			halt_cont		: OUT STD_LOGIC;
			rd_in			: OUT STD_LOGIC;
			call			: OUT std_LOGIC; --exc signal
			ill_ins			: OUT STD_LOGIC; --exc signal
			protect 		: OUT std_LOGIC; --exc signal		
			wr_out			: OUT STD_LOGIC;
			ldpc			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			TLB_Com			: out std_LOGIC_VECTOR(2 downto 0);
			int_type		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_io			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			immed			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			Instruccio		: OUT string(1 to 4); 	-- modelsim
			operacio		: OUT string(1 to 6)	-- modelsim
			);
	END component;
	
	
	component  multi is
	port (	clk			: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			interrupt	: IN  STD_LOGIC;
			wrd_l		: IN  STD_LOGIC;
			wrd_s_l		: IN  STD_LOGIC;
			u_s_l		: IN  STD_LOGIC;
			wr_m_l		: IN  STD_LOGIC;
			ld_m_l		: IN STD_LOGIC;
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
			sys_priv_lvl: IN  std_logic;
			immed_x2_l	: IN  STD_LOGIC;
			int_type_l	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			TLB_Com_l	: IN  std_LOGIC_VECTOR(2 downto 0);	
			ldpc_l		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_a_l	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			exc_tlb		: IN  std_logic_vector(3 downto 0);
			addr_io_l	: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			privilege_lvl : out std_LOGIC;
			wrd			: OUT STD_LOGIC;
			wrd_s		: OUT STD_LOGIC;
			u_s			: OUT STD_LOGIC;
			wr_m		: OUT STD_LOGIC;
			ld_m		: OUT STD_LOGIC;
			ldir		: OUT STD_LOGIC;
			ins_dad		: OUT STD_LOGIC;
			word_byte	: OUT STD_LOGIC;
			rd_in		: OUT STD_LOGIC;
			wr_out		: OUT STD_LOGIC;
			inta		: OUT STD_LOGIC;
			exca		: OUT STd_LOGIC;
			exc_code	: OUT exc_code_t;
			estat_out 	: OUT std_logic_vector(1 downto 0);
			int_type	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			TLB_Com		: OUT std_LOGIC_VECTOR(2 downto 0);
			ldpc		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_a		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	end component;



signal enable				: std_logic;
signal enable_sys			: std_logic;
signal user_sys				: std_logic;
signal word_mem				: std_logic;
signal read_mem				: std_logic;
signal word_byte_connection	: std_logic;
signal load_ins				: std_logic;
signal z_reg				: std_logic;
signal halt_conn			: std_logic;
signal ins_dad_conn			: std_logic;
signal wr_out_conn			: std_logic;
signal rd_in_conn			: std_logic;
signal int_a_conn			: std_logic;
signal ill_ins_conn			: std_logic;
signal immed_x2_conn		: std_logic;
signal f_out				: f_code_t;
signal op_out				: op_code_t;
signal regPC				: std_logic_vector(15 downto 0) := x"C000";
signal new_Pc				: std_logic_vector(15 downto 0) := x"0000";
signal ir_connection		: std_logic_vector(15 downto 0);
signal pc_mem				: std_logic_vector(15 downto 0);
signal new_ir				: std_logic_vector(15 downto 0);
signal ir_reg				: std_logic_vector(15 downto 0);
signal old_2_Pc				: std_logic_vector(15 downto 0);
signal despla				: std_logic_vector(15 downto 0);
signal addr_io_conn			: std_logic_vector(7 downto 0);
signal load_pc_connection	: std_logic_vector(2 downto 0);   
signal load_pc_out			: std_logic_vector(2 downto 0);
signal addr_a_conn			: std_logic_vector(2 downto 0);
signal in_d_conn			: std_logic_vector(1 downto 0);
signal int_type_conn		: std_logic_vector(1 downto 0);
signal int_type_out			: std_logic_vector(1 downto 0);
signal estat_conn			: std_logic_vector(1 downto 0);
signal TLB_Com_conn			: std_logic_vector(2 downto 0);

signal protect_conn: std_LOGIC := '0';
signal protect_conn_b: std_LOGIC := '0';
signal protect_pc:	std_logic := '0';
signal call_conn: std_LOGIC := '0';
signal privilege_lvl_conn : std_LOGIC := '0';

signal instruction			: string (1 to 4);	-- modelsim
signal operacio				: string (1 to 6);	-- modelsim

BEGIN

	-- Process per decidir el nou PC
	process (boot, load_pc_out, clk) begin
		if rising_edge(clk) then
			
			despla(15 downto 9) <= (others => datard_m(7));	-- Calculem el desplasament dels Branches
			despla(8 downto 0) <= datard_m(7 downto 0)&'0';	-- Extenem el signe per els Branches relatius i x2 per alinear-ho

			old_2_Pc <= regPC + 2;	-- Ens guardem el PC + 2 pels JALS i CALLS
			
			if boot = '1' then 				-- BOOT
				regPC <= x"C000";
			else
				if load_pc_out = "011" then  -- HALT
					regPC <= regPC;
					
				elsif load_pc_out = "101" then -- SYSTEM; Posem al PC el que en surt de la ALU(S5, @RSG).
					regPC <= alu_out;
				else						-- RUN
				
					if load_pc_out = "000" and ins_dad_conn = '1' then		-- RUN; ins_dad_conn fa de proxy de l'estat del multi
						regPC <= regPC + 2;
					elsif load_pc_out = "001" then							-- Cas JMP's
					
						if f_out = JMP_OP then					-- JMP;
							regPC <= alu_out;                   
						elsif z = '0' and f_out = JZ_OP then    -- JZ i saltem
							regPC <= alu_out;                   
						elsif z = '1' and f_out = JNZ_OP then   -- JNZ i saltem
							regPC <= alu_out;
						elsif f_out = JAL_OP then				-- JAL
							regPC <= alu_out;
						else									-- Else no saltem (pc <= pc + 2)
							regPC <= regPC + 2;
						end if;
					elsif load_pc_out = "010" then								-- Cas BZ's
					
						if z = '0' and f_out = BZ_OP then				-- BZ i saltem
							regPC <= regPC + 2 + despla;
						elsif z = '1' and f_out = BNZ_OP then				-- BNZ i saltem
							regPC <= regPC + 2 + despla;
						else											-- Else no saltem (pc <= pc + 2)
							regPC <= regPC + 2;						
						end if;
					elsif load_pc_out = "100" then						-- Cas RET
						if protect_conn_b = '0' then					
							regPC <= alu_out;				-- Si esten en mode systema	saltem
						else
							regPc <= regPC + 2;				-- Si estem en mode user no saltem ja que es protegida
						end if;
					elsif load_pc_out = "111" then						-- Cas CALLS
						regPC <= regPC;
					else						--- REVISAR (Inception)
						regPC <= regPC;
					end if;
				end if;
			end if;
			
		end if;
	end process;
	
	
	-- Process per decidir el seguent IR
	process (clk, load_ins, boot, load_pc_out) begin		
		protect_pc <= '0';
		
		if boot = '1' then 										--BOOT
			new_ir <= x"5000";
		else
			if load_pc_out /= "011" then						-- Cas RUN
			
				if regPC < x"c000" then	-- excepcio de instruccio pocha REVISAR
					protect_pc <= '1';
				end if;
			
				-- DECODE or JMP carreguem el Seguent IR el que ens ve de memoria; En cas de CALL, nomes ho fem en el cycle de system o ens entra merda a IR
				if protect_pc = '0' and (load_ins = '1' or (load_pc_out = "001" and (op_out /= JMP and f_out /= CALLS_OP)) or (op_out = JMP and f_out = CALLS_OP and load_pc_out = "101"))  then  
					new_ir <= datard_m ;
				elsif protect_pc = '0' then 	-- Cas FETCH, mantenim el IR per al DECODE 
					new_ir <= ir_reg;
				end if;
			else
				new_ir <= x"FFFF";								-- Cas HALT, ens quedem a HALT
			end if;
			
			
			
		end if;
		
		
		-- Actualitzem if rising edge
		if rising_edge(clk) then
			ir_reg <= new_ir;
			z_reg <= z; 
		end if;
	end process;
	
	-- Pasem les conexions de control a multi o asignem les sortides com toqui
	ins_dad <= ins_dad_conn;
	ir_connection <= ir_reg;
	protect_conn <= protect_conn_b or protect_pc;
	f <=  f_out;
	op <= op_out;
	int_type <= int_type_out;
	inta <= int_a_conn;
	immed_x2 <= immed_x2_conn;
	estat_multi <= estat_conn;
	
	-- pc es el signal que va al mux d'entrada del banc de registres. Sempre enviem regPC excepte quan es un JAL, CALL
	pc <= old_2_Pc when (load_pc_out = "001" and f_out = JAL_OP) or (op_out = JMP and f_out = CALLS_OP) else
		  regPC;-- RETI pilla el seguent regPC per despres torar

	pc_mem <= '0'&regPC(15 downto 1); --MODELSIM
  	 
	control_ins : control_l port map (	ir => ir_connection,
										clk => clk, 
										op => op_out,
										boot => boot,
										f => f_out,
										ldpc=> load_pc_connection,
										wrd => enable,
										wrd_s => enable_sys,
										u_s => user_sys,
										addr_b => addr_b,
										addr_d => addr_d,
										immed => immed,
										wr_m => word_mem,
										ld_m => read_mem,
										in_d => in_d,
										estat_multi => estat_conn,
										ill_ins => ill_ins_conn, --exc
										call => call_conn, --exc
										protect => protect_conn_b, --exc
										TLB_Com => TLB_Com_conn,
										privilege_lvl_l => sys_priv_lvl,
										immed_x2 => immed_x2_conn,
										word_byte => word_byte_connection,
										halt_cont => halt_conn,
										immed_or_reg => immed_or_reg,
										addr_io => addr_io_conn,
										rd_in => rd_in_conn,
										wr_out => wr_out_conn,
										int_type => int_type_conn,
										addr_a => addr_a_conn,
										Instruccio => Instruction			--modelsim
										);

	multi0 : multi port map (	clk => clk, 
								boot => boot,
								interrupt => intr,
								ldpc_l => load_pc_connection,
								wrd_l => enable,
								wrd_s_l => enable_sys,
								u_s_l => user_sys,
								int_e => int_e,
								estat_out => estat_conn,
								ill_ins_l => ill_ins_conn, --exc
								div_z => div_z,			--exc
								no_al => no_al,			--exc
								call_l => call_conn,    --exc
								protect_l => protect_conn, --exc
								TLB_Com_l => TLB_Com_conn,
								exc_tlb => exc_tlb,
								pp_tlb_d_l => pp_tlb_dx,
								wr_m_l => word_mem,
								ld_m_l => read_mem,
								privilege_lvl => privilege_lvl_conn,
								immed_x2_l => immed_x2_conn,
								sys_priv_lvl => sys_priv_lvl,
								addr_io_l => addr_io_conn,
								rd_in_l => rd_in_conn,
								wr_out_l => wr_out_conn,
								addr_a_l => addr_a_conn,
								int_type_l => int_type_conn,
								w_b => word_byte_connection,
								TLB_Com => TLB_Com,
								ldpc => load_pc_out,
								wrd => wrd,
								wrd_s => wrd_s,
								inta => int_a_conn,
								exca => exca,
								u_s => u_s, 
								wr_m => wr_m,
								ld_m => ld_m,
								ldir => load_ins,
								ins_dad => ins_dad_conn,
								word_byte => word_byte,
								halt_cont => halt_conn,
								addr_io => addr_io,
								rd_in => rd_in,
								wr_out => wr_out,
								addr_a => addr_a,
								exc_code => exc_code,
								int_type => int_type_out
								);
	privilege_lvlz <= sys_priv_lvl;

END Structure;