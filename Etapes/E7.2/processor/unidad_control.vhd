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
			datard_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out			: IN  STD_LOGIC_VECTOR(15 downto 0);
			op				: OUT op_code_t;
			f				: OUT f_code_t;
			wrd				: OUT std_logic;
			wrd_s			: OUT std_logic;
			u_s				: OUT std_logic;
			ins_dad			: OUT std_logic;
			immed_x2		: OUT std_logic;
			wr_m			: OUT std_logic;
			word_byte		: OUT std_logic;
			immed_or_reg	: OUT std_logic;
			rd_in			: OUT std_logic;
			wr_out			: OUT std_logic;
			inta			: OUT STD_LOGIC;
			exca		: OUT STd_LOGIC;
			in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			int_type		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			exc_code		: OUT exc_code_t;
			immed			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc				: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_io			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS
	
	component control_l is
	PORT (	ir				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			op				: OUT op_code_t;
			f				: OUT f_code_t;
			wrd				: OUT STD_LOGIC;
			wrd_s			: OUT STD_LOGIC;
			u_s				: OUT STD_LOGIC;
			wr_m			: OUT STD_LOGIC;
			immed_x2		: OUT STD_LOGIC;
			word_byte		: OUT STD_LOGIC;
			immed_or_reg	: OUT STD_LOGIC;
			halt_cont		: OUT STD_LOGIC;
			rd_in			: OUT STD_LOGIC;
			ill_ins			: OUT STD_LOGIC;
			wr_out			: OUT STD_LOGIC;
			ldpc			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
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
			w_b			: IN  STD_LOGIC;
			halt_cont	: IN  STD_LOGIC;
			rd_in_l		: IN  STD_LOGIC;
			wr_out_l	: IN  STD_LOGIC;
			int_e		: IN  STD_LOGIC;
			div_z		: IN  STD_LOGIC;
			no_al		: IN  STD_LOGIC;
			ill_ins_l	: IN STD_LOGIC;
			ldpc_l		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			in_d_l		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
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
			inta		: OUT STD_LOGIC;
			exca		: OUT STd_LOGIC;
			int_type	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ldpc		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_a		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			exc_code	: OUT exc_code_t;
			addr_io		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	end component;



signal enable				: std_logic;
signal enable_sys			: std_logic;
signal user_sys				: std_logic;
signal word_mem				: std_logic;
signal word_byte_connection	: std_logic;
signal load_ins				: std_logic;
signal z_reg				: std_logic;
signal halt_conn			: std_logic;
signal ins_dad_conn			: std_logic;
signal wr_out_conn			: std_logic;
signal rd_in_conn			: std_logic;
signal int_a_conn			: std_logic;
signal ill_ins_conn			: std_logic;
signal f_out				: f_code_t;
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



signal instruction			: string (1 to 4);	-- modelsim
signal operacio				: string (1 to 6);	-- modelsim

BEGIN

	-- Process per decidir el nou PC
	process (boot, load_pc_out, clk) begin
		if rising_edge(clk) then
			
			despla(15 downto 9) <= (others => datard_m(7));	-- Calculem el desplaÃ¯Â¿Â½ament dels Branches
			despla(8 downto 0) <= datard_m(7 downto 0)&'0';	-- Extenem el signe per els Branches relatius i x2 per alinear-ho

			old_2_Pc <= regPC + 2;	-- Ens guardem el PC + 2 pels JALS
			
			if boot = '1' then 				-- BOOT; REVISAR plantejar la idea de passar boot als registres i posarlos a 0 en Boot, si no, ens emplenem de merda si fem toggle-untoggle per fer tests
				regPC <= x"C000";
			else
				if load_pc_out = "011" then  -- HALT
					regPC <= regPC;
					
				elsif load_pc_out = "101" then -- SYSTEM; Posem al PC el que en surt de la ALU(S5, @RSG)
					regPC <= alu_out;
				else						-- RUN
				
					if load_pc_out = "000" and ins_dad_conn = '1' then		-- RUN; ins_dad_conn fa de proxy de l'estat del multi
						if regPC < x"FFFE" then
							regPC <= regPC + 2;
						else 
							regPC <= regPC;		-- REVISAR, aixo hauria de ser un HALT
						end if;
					elsif load_pc_out = "001" then							-- Cas JMP's
						if f_out = JMP_OP and alu_out >= x"C000" and alu_out < x"FFFE" then 					-- JMP; alu_out >= x"C000" i alu_out < x"FFFE" per evitar que saltem a la ROM
							regPC <= alu_out;																			-- alu_out < FFFE perque si no el seguent PC + 2 fa overflow
						elsif z = '0' and f_out = JZ_OP and alu_out >= x"C000" and alu_out < x"FFFE" then 		-- JZ i saltem
							regPC <= alu_out;																			-- REVISAR s'ha de mira si la adressa es aligned?
						elsif z = '1' and f_out = JNZ_OP and alu_out >= x"C000" and alu_out < x"FFFE" then 	-- JNZ i saltem
							regPC <= alu_out;	
						elsif f_out = JAL_OP and alu_out >= x"C000" and alu_out < x"FFFE" then							-- JAL
							regPC <= alu_out;
						else												-- Else no saltem (pc <= pc + 2)
							if regPC < x"FFFE" then
								regPC <= regPC + 2;
							else 
								regPC <= regPC;	-- REVISAR, aixo hauria de ser un HALT
							end if;
						end if;
						
					elsif load_pc_out = "010" then							-- Cas BZ's
						if z = '0' and f_out = BZ_OP and (regPC + 2 + despla) >= x"C000" and (regPC + 2 + despla) < x"FFFE" then 					-- BZ i saltem
							regPC <= regPC + 2 + despla;																								-- @ < FFFE perque si no el seguent PC + 2 fa overflow
						elsif z = '1' and f_out = BNZ_OP and (regPC + 2 + despla) >= x"C000" and (regPC + 2 + despla) < x"FFFE" then 				-- BNZ i saltem
							regPC <= regPC + 2 +  despla;
						elsif regPC + 2 < x"FFFE" then																									-- Else no saltem (pc <= pc + 2)
							regPC <= regPC + 2;
						else
							regPC <= regPC; 	-- aixo ha de ser un HALT REVISAR
						end if;
							
					elsif load_pc_out = "100" and alu_out >= x"C000" and alu_out < x"FFFE" then	-- Cas RET; alu_out < FFFE perque si no el seguent PC + 2 fa overflow
						regPC <= alu_out;

					else 
						regPC <= regPC;	-- aixo ha de ser un HALT REVISAR
					end if;
				end if;
			end if;
			
		end if;
	end process;
	
	
	-- Process per decidir el seguent IR
	process (clk, load_ins, boot) begin		
		if boot = '1' then 										--BOOT
			new_ir <= x"5000";
		else
			if load_pc_out /= "011" then		-- Cas RUN
				if load_ins = '1' or load_pc_out = "001"  then  	-- DECODE or JMP carreguem a ir el que ens ve de memoria
					new_ir <= datard_m ;
				else											-- Cas FETCH 
					if regPC < x"fffe" then
						new_ir <= ir_reg;							-- Ens quedem igual
					else
						new_ir <= x"FFFF";							-- FETCH amb un PC invalid
					end if;
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
	f <=  f_out;
	int_type <= int_type_out;
	inta <= int_a_conn;
	in_d <= in_d_conn;
	
	-- pc es el signal que va al mux d'entrada del banc de registres. Sempre enviem regPC excepte quan es un JAL
	pc <= old_2_Pc when load_pc_out = "001" and f_out = JAL_OP else
		  regPC;-- RETI pilla el seguent regPC per despres torar


	pc_mem <= '0'&regPC(15 downto 1); --MODELSIM
  	 
	control_ins : control_l port map (	ir => ir_connection,
										op => op,
										f => f_out,
										ldpc=> load_pc_connection,
										wrd => enable,
										wrd_s => enable_sys,
										u_s => user_sys,
										addr_b => addr_b,
										addr_d => addr_d,
										immed => immed,
										wr_m => word_mem,
										in_d => in_d_conn,
										ill_ins => ill_ins_conn,
										immed_x2 => immed_x2,
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
								ill_ins_l => ill_ins_conn,
								div_z => div_z,
								no_al => no_al,
								wr_m_l => word_mem,
								in_d_l => in_d_conn,
								addr_io_l => addr_io_conn,
								rd_in_l => rd_in_conn,
								wr_out_l => wr_out_conn,
								addr_a_l => addr_a_conn,
								int_type_l => int_type_conn,
								w_b => word_byte_connection,
								ldpc => load_pc_out,
								wrd => wrd,
								wrd_s => wrd_s,
								inta => int_a_conn,
								exca => exca,
								u_s => u_s, 
								wr_m => wr_m,
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


END Structure;