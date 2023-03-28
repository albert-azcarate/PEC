LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 alu_out   : IN  STD_LOGIC_VECTOR(15 downto 0);
			 z			  : IN std_LOGIC;
          op        : out op_code_t;
          f         : out  f_code_t;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 immed_or_reg : OUT STD_LOGIC);
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS


	component control_l IS
		PORT (ir     	 : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				op        : out  op_code_t;
				f         : out  f_code_t;
				ldpc      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				wrd       : OUT STD_LOGIC;
				addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				wr_m      : OUT STD_LOGIC;
				in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				immed_x2  : OUT STD_LOGIC;
				word_byte : OUT STD_LOGIC;
				immed_or_reg : OUT STD_LOGIC;
				halt_cont 		 : OUT  STD_LOGIC;
				instruccio:out string(1 to 4); --modelsim
				operacio	 :out string(1 to 6)); --modelsim
	end component;
	
	
	component multi is
		port	(clk      : IN  STD_LOGIC;
				boot      : IN  STD_LOGIC;
				ldpc_l    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				wrd_l     : IN  STD_LOGIC;
				wr_m_l    : IN  STD_LOGIC;
				w_b       : IN  STD_LOGIC;
				halt_cont 		 : IN  STD_LOGIC;
				ldpc      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				wrd       : OUT STD_LOGIC;
				wr_m      : OUT STD_LOGIC;
				ldir      : OUT STD_LOGIC;
				ins_dad   : OUT STD_LOGIC;
				word_byte : OUT STD_LOGIC);
	end component;

signal regPC : std_logic_vector(15 downto 0) := x"C000";
signal new_Pc : std_logic_vector(15 downto 0) := x"0000";
signal old_2_Pc : std_logic_vector(15 downto 0);
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
signal instruction : string (1 to 4); --modelsim
signal operacio : string (1 to 6);	--modelsim

BEGIN
	

	process (boot, load_pc_out, clk) begin
		if rising_edge(clk) then
			old_2_Pc <= regPC + 2;
			if boot = '1' then 				--BOOT
				new_Pc <= x"C000";
			else
				if load_pc_out = "11" then  --HALT
					new_Pc <= regPC;
				else
					if load_pc_out = "00" then
						new_Pc <= regPC + 2;		-- RUN
						
					elsif load_pc_out = "01" then	-- JMP's
						if f_out = JMP_OP then --JMP
							new_Pc <= alu_out;
						elsif z = '0' and f_out = JZ_OP then -- JZ
							new_Pc <= alu_out;
						elsif z = '1' and f_out = JNZ_OP then --JNZ
							new_Pc <= alu_out;
						elsif f_out = JAL_OP then--JAL
							new_Pc <= alu_out;
						else	
							new_Pc <= regPC + 2;	
						end if;
						
					elsif load_pc_out = "10" then	-- BZ's
						if z = '0' and f_out = BZ_OP then --BZ
							new_Pc <= regPC + 2 + (datard_m(7 downto 0)&'0');
						elsif z = '1' and f_out = BNZ_OP then --BNZ
							new_Pc <= regPC + 2 + (datard_m(7 downto 0)&'0');
						else 
							new_Pc <= regPC + 2;
						end if;
						
					else 
						new_Pc <= regPC; --Sha de cnaviar per el CALLS
					end if;
				end if;
			end if;
				
				regPC <= new_Pc; --estem asignant un registre a un registre empalmantlos? REVISAR
		end if;
	end process;

	process (clk, load_ins, boot, load_pc_out) begin		
		if boot = '1' then 				--BOOT
			new_ir <= x"C000";
		else
			if load_pc_out /= "11" then
				if load_ins = '1' then  	--DECODE
					new_ir <= datard_m ;
				else
					new_ir <= ir_reg;			--FETCH
				end if;
			else 
				new_ir <= x"FFFF";
			end if;
		end if;
			
		if rising_edge(clk) then
			ir_reg <= new_ir;
			z_reg <= z; 
		end if;
		
		
	end process;
  	 
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
												immed_or_reg => immed_or_reg);
	
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
									ins_dad => ins_dad,
									word_byte => word_byte,
									halt_cont => halt_conn);
	ir_connection <= ir_reg;
	pc <= old_2_Pc when load_pc_out = "01" and f_out = JAL_OP else regPC;
	f <=  f_out;
  
END Structure;