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
          op        : out op_code_t;
          f         : out  f_code_t;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
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
				ldpc      : OUT STD_LOGIC;
				wrd       : OUT STD_LOGIC;
				addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				wr_m      : OUT STD_LOGIC;
				in_d      : OUT STD_LOGIC;
				immed_x2  : OUT STD_LOGIC;
				word_byte : OUT STD_LOGIC;
				immed_or_reg : OUT STD_LOGIC;
				instruccio:out string(1 to 4);
				operacio	 :out string(1 to 6));
	end component;
	
	
	component multi is
		port	(clk      : IN  STD_LOGIC;
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
	end component;

signal regPC : std_logic_vector(15 downto 0) := x"C000";
signal new_Pc : std_logic_vector(15 downto 0) := x"0000";
signal load_pc_connection : std_logic;   
signal enable: std_LOGIC;
signal word_mem: std_LOGIC;
signal word_byte_connection: std_LOGIC;
signal load_pc_out: std_LOGIC;
signal load_ins: std_LOGIC;
signal ir_connection: std_logic_vector(15 downto 0);
signal ir_reg: std_logic_vector(15 downto 0);
signal new_ir: std_logic_vector(15 downto 0);
signal instruction : string (1 to 4);
signal operacio : string (1 to 6);
BEGIN
	

	process (boot, load_pc_out, clk) begin
		if boot = '1' then 				--BOOT
			new_Pc <= x"C000";
		else
			if load_pc_out = '0' then  --HALT
				new_Pc <= regPC;
			else
				new_Pc <= regPC + 2;		-- RUN
			end if;
		end if;
			
		if rising_edge(clk) then
			regPC <= new_Pc;
		end if;
	end process;

	process (clk, load_ins, boot) begin		
		if boot = '1' then 				--BOOT
			new_ir <= x"C000";
		else
			if load_ins = '1' then  	--DECODE
				new_ir <= datard_m ;
			else
				new_ir <= ir_reg;			--FETCH
			end if;
		end if;
			
		if rising_edge(clk) then
			ir_reg <= new_ir;
		end if;
		
		
	end process;
  	 
	control_ins : control_l port map(ir => ir_connection,
												op => op,
												f => f,
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
												Instruccio => Instruction,
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
									word_byte => word_byte);
	ir_connection <= ir_reg;
	pc <= regPC;
  
END Structure;