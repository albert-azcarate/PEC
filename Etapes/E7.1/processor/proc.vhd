LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY proc IS
	PORT (clk	   : IN  STD_LOGIC;
		  boot	  : IN  STD_LOGIC;
		  datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  addr_m	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  wr_m	  : OUT STD_LOGIC;
		  word_byte : OUT STD_LOGIC;
			addr_io 		: out std_logic_vector(7 downto 0);
			wr_io 		: out std_logic_vector(15 downto 0);
			rd_io 		: in std_logic_vector(15 downto 0);
			wr_out 		: out std_logic;
			rd_in 		: out std_logic;

			SW 			: in std_logic_vector(7 downto 0);
			reg_debug   : out    std_logic_vector(15 downto 0);
			--inta		: IN std_logic;
			--intr		: IN std_logic
			 );
END proc;

ARCHITECTURE Structure OF proc IS

	component unidad_control IS
	PORT (	boot			: IN  STD_LOGIC;
			clk				: IN  STD_LOGIC;
			z				: IN  std_LOGIC;
			datard_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out			: IN  STD_LOGIC_VECTOR(15 downto 0);
			op				: out op_code_t;
			f				: out f_code_t;
			wrd				: OUT STD_LOGIC;
			wrd_s			: OUT STD_LOGIC;
			u_s				: OUT STD_LOGIC;
			ins_dad			: OUT STD_LOGIC;
			immed_x2		: OUT STD_LOGIC;
			wr_m			: OUT STD_LOGIC;
			word_byte		: OUT STD_LOGIC;
			immed_or_reg	: OUT STD_LOGIC;
			rd_in			: OUT STD_LOGIC;
			wr_out			: OUT STD_LOGIC;
			in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			int_type		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc				: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_io			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	END component;
 
	component datapath IS
	PORT (	clk				: IN  STD_LOGIC;
			wrd				: IN  STD_LOGIC;
			wrd_s			: IN  STD_LOGIC;
			u_s				: IN  STD_LOGIC;
			immed_x2		: IN  STD_LOGIC;
			ins_dad			: IN  STD_LOGIC;
			immed_or_reg	: IN  STD_LOGIC;
			op				: IN  op_code_t;
			f				: IN  f_code_t;
			addr_a			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			datard_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			in_d			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			rd_io			: IN  std_LOGIC_VECTOR(15 DOWNTO 0);
			int_type		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			z				: OUT std_LOGIC;
			wr_io			: OUT std_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out_path	: out std_LOGIC_VECTOR(15 downto 0);

			SW 				: in std_logic_vector(7 downto 0);
			reg_debug   : OUT    std_logic_vector(15 downto 0)
			);
			 
	END component;

	 
signal	op_conn				: op_code_t;
signal	f_conn				: f_code_t;
signal wrd_conn				: STD_LOGIC;
signal immed_x2_conn		: STD_LOGIC;
signal ins_dad_conn			: STD_LOGIC;
signal immed_or_reg_conn	: STD_LOGIC;
signal z_conn				: STD_LOGIC;
signal wrd_s_conn			: STD_LOGIC;
signal u_s_conn				: STD_LOGIC;
signal in_d_conn			: STD_LOGIC_VECTOR(1 DOWNTO 0);
signal int_type_conn				: STD_LOGIC_VECTOR(1 DOWNTO 0);
signal addr_a_conn			: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal addr_b_conn			: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal addr_d_conn			: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal immed_conn			: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal pc_conn				: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal alu_out_conn			: STD_LOGIC_VECTOR(15 downto 0);

BEGIN
	
	UC: unidad_control port map(	boot => boot,
											clk => clk,
											datard_m => datard_m,
											alu_out => alu_out_conn,
											op => op_conn,
											f => f_conn,
											wrd => wrd_conn,
											wrd_s => wrd_s_conn,
											u_s => u_s_conn,
											addr_a => addr_a_conn,
											addr_b => addr_b_conn,
											addr_d => addr_d_conn,
											immed => immed_conn,
											pc => pc_conn,
											ins_dad => ins_dad_conn,
											in_d => in_d_conn,
											immed_x2 => immed_x2_conn,
											wr_m => wr_m,
											word_byte => word_byte,
											immed_or_reg => immed_or_reg_conn,
											z => z_conn,
											addr_io => addr_io,
											rd_in => rd_in,
											wr_out => wr_out,
											int_type => int_type_conn
											);
	
	PATH: datapath port map(clk => clk,
									datard_m => datard_m,
									op => op_conn,
									f => f_conn,
									wrd => wrd_conn,
									wrd_s => wrd_s_conn,
									u_s => u_s_conn,
									addr_a => addr_a_conn,
									addr_b => addr_b_conn,
									addr_d => addr_d_conn,
									immed => immed_conn, 
									pc => pc_conn, 
									ins_dad => ins_dad_conn, 
									in_d => in_d_conn, 
									immed_x2 => immed_x2_conn,
									data_wr => data_wr, 
									addr_m => addr_m,
									immed_or_reg => immed_or_reg_conn,
									alu_out_path => alu_out_conn,
									z => z_conn,
									rd_io	=> rd_io,
									wr_io => wr_io,
									int_type => int_type_conn
									);

END Structure;