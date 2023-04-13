LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
			clk       		: IN  STD_LOGIC;
			datard_m  		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out   		: IN  STD_LOGIC_VECTOR(15 downto 0);
			z		  		: IN std_LOGIC;
			op        		: out op_code_t;
			f         		: out  f_code_t;
			wrd       		: OUT STD_LOGIC;
			addr_a    		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b    		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d    		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed     		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc        		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			ins_dad   		: OUT STD_LOGIC;
			in_d      		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			immed_x2  		: OUT STD_LOGIC;
			wr_m      		: OUT STD_LOGIC;
			word_byte 		: OUT STD_LOGIC;
			immed_or_reg 	: OUT STD_LOGIC;
			addr_io : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);--
			rd_in : OUT STD_LOGIC;--
			wr_out : OUT STD_LOGIC--
			);
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS
	
	component control_l is
	PORT( ir        		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			op 		  		: out op_code_t;
			f         		: out f_code_t;
			ldpc      		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd       		: OUT STD_LOGIC;
			addr_a    		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b    		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d    		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed     		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m      		: OUT STD_LOGIC;
			in_d      		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			immed_x2  		: OUT STD_LOGIC;
			word_byte 		: OUT STD_LOGIC;
			immed_or_reg 	: OUT STD_LOGIC;
			halt_cont	 	: out STD_LOGIC;
			Instruccio		: out string(1 to 4); -- modELSIM
			operacio		: out string(1 to 6);	--modELSIM
			addr_io : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			rd_in : OUT STD_LOGIC;
			wr_out : OUT STD_LOGIC
			);
	END component;
	
	
	component  multi is
    port(	clk      	: IN  STD_LOGIC;
			boot      	: IN  STD_LOGIC;
			ldpc_l    	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd_l     	: IN  STD_LOGIC;
			wr_m_l    	: IN  STD_LOGIC;
			w_b       	: IN  STD_LOGIC;
			halt_cont	: IN  STD_LOGIC;
			ldpc      	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd       	: OUT STD_LOGIC;
			wr_m      	: OUT STD_LOGIC;
			ldir      	: OUT STD_LOGIC;
			ins_dad   	: OUT STD_LOGIC;
			word_byte 	: OUT STD_LOGIC);
	end component;



signal regPC : std_logic_vector(15 downto 0) := x"C000";
signal new_Pc : std_logic_vector(15 downto 0) := x"0000";
signal old_2_Pc : std_logic_vector(15 downto 0);
signal pc_mem : std_logic_vector(15 downto 0);
signal load_pc_connection : std_logic_vector(1 downto 0);   
signal enable: std_LOGIC;
signal word_mem: std_LOGIC;
signal word_byte_connection: std_LOGIC;
signal load_pc_out: std_LOGIC_vector(1 downto 0);
signal load_ins: std_LOGIC;
signal ir_connection: std_logic_vector(15 downto 0);
signal ir_reg: std_logic_vector(15 downto 0);
signal new_ir: std_logic_vector(15 downto 0);
signal z_reg: std_LOGIC;
signal f_out : f_code_t;
signal halt_conn : std_logic;
signal ins_dad_conn : std_LOGIC;
signal despla : std_LOGIC_vector(15 downto 0);

signal instruction : string (1 to 4); --modelsim
signal operacio : string (1 to 6);	--modelsim

BEGIN

	process (boot, load_pc_out, clk) begin
		if rising_edge(clk) then
			
			despla(15 downto 9) <= (others => datard_m(7));
			despla(8 downto 0) <= datard_m(7 downto 0)&'0';
			old_2_Pc <= regPC + 2;	-- Ens guardem el PC + 2 pels JALS
			
			if boot = '1' then 				-- BOOT
				regPC <= x"C000";
			else
				if load_pc_out = "11" then  -- HALT
					regPC <= regPC;
				else						-- RUN
				
					if load_pc_out = "00" and ins_dad_conn = '1' then		-- RUN
						if regPC < x"FFFE" then
							regPC <= regPC + 2;
						else 
							regPC <= regPC;
						end if;
					elsif load_pc_out = "01" then							-- Cas JMP's
						if f_out = JMP_OP then 								-- JMP
							regPC <= alu_out;	
						elsif z = '0' and f_out = JZ_OP and alu_out >= x"C000" and alu_out <= x"FFFE" then 		-- JZ i saltem
							regPC <= alu_out;	
						elsif z = '1' and f_out = JNZ_OP and alu_out >= x"C000" and alu_out <= x"FFFE" then 	-- JNZ i saltem
							regPC <= alu_out;	
						elsif f_out = JAL_OP and alu_out >= x"C000" and alu_out <= x"FFFE" then							-- JAL
							regPC <= alu_out;
						else												-- Else no saltem (pc <= pc + 2)
							if regPC < x"FFFE" then
								regPC <= regPC + 2;
							else 
								regPC <= regPC;
							end if;
						end if;
						
					elsif load_pc_out = "10" then							-- Cas BZ's
						if z = '0' and f_out = BZ_OP and (regPC + 2 + despla) >= x"C000" and (regPC + 2 + despla) <= x"FFFE" then 					-- BZ i saltem
							regPC <= regPC + 2 + despla;
						elsif z = '1' and f_out = BNZ_OP and (regPC + 2 + despla) >= x"C000" and (regPC + 2 + despla) <= x"FFFE" then 				-- BNZ i saltem
							regPC <= regPC + 2 +  despla;
						elsif regPC + 2 < x"FFFE" then																									-- Else no saltem (pc <= pc + 2)
							regPC <= regPC + 2;
						else
							regPC <= regPC; 	-- aixo ha de ser un HALT
						end if;
							
					else 													-- REVISAR de que serveix aquest else, ja que no entrem aqui mai
						regPC <= regPC;
					end if;
				end if;
			end if;
			
		end if;
	end process;
	
	

	process (clk, load_ins, boot) begin		
		if boot = '1' then 										--BOOT
			new_ir <= x"C000";
		else
			if load_pc_out /= "11" then							-- Cas RUN
				if load_ins = '1' or load_pc_out = "01"  then  	-- DECODE or JMP carreguem a ir el que ens ve de memoria
					new_ir <= datard_m ;
				else											-- Cas FETCH
					new_ir <= ir_reg;							-- Ens quedem igual
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
	
	-- pc es el signal que va al mux d'entrada del banc de registres. Sempre enviem regPC excepte quan es un JAL; REVISAR si no pot ser asignat normal ja que nomes fem servir pc quan es JAL
	pc <= old_2_Pc when load_pc_out = "01" and f_out = JAL_OP else regPC;
	pc_mem <= '0'&regPC(15 downto 1); --MODELSIM
  	 
	control_ins : control_l port map(ir => ir_connection,
												op => op,
												f => f_out,
												ldpc=> load_pc_connection,
												wrd => enable,
												addr_a => addr_a, 
												addr_b => addr_b,
												addr_d => addr_d,
												immed => immed,
												wr_m => word_mem,
												in_d => in_d,
												immed_x2 => immed_x2,
												word_byte => word_byte_connection,
												halt_cont => halt_conn,
												Instruccio => Instruction,			--modelsim
												immed_or_reg => immed_or_reg,
												addr_io => addr_io,
												rd_in => rd_in,
												wr_out => wr_out
												);
	
	multi0 : multi port map(clk => clk, 
									boot => boot,
									ldpc_l => load_pc_connection,
									wrd_l => enable,
									wr_m_l => word_mem,
									w_b => word_byte_connection,
									ldpc => load_pc_out,
									wrd => wrd, 
									wr_m => wr_m,
									ldir => load_ins,
									ins_dad => ins_dad_conn,
									word_byte => word_byte,
									halt_cont => halt_conn);
									

END Structure;