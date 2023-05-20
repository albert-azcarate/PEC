LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.op_code.all;
use work.f_code.all;
use work.exc_code.all;
use work.all;

ENTITY datapath IS
	PORT (	clk				: IN  STD_LOGIC;
			boot			: IN  STD_LOGIC;
			wrd				: IN  STD_LOGIC;
			wrd_s			: IN  STD_LOGIC;
			u_s				: IN  STD_LOGIC;
			immed_x2		: IN  STD_LOGIC;
			ins_dad			: IN  STD_LOGIC;
			immed_or_reg	: IN  STD_LOGIC;
			intr			: IN  STD_LOGIC;
			inta			: IN  STD_LOGIC;
			exca			: IN  STd_LOGIC;
			privilege_lvl	: IN  std_LOGIC;
			op				: IN  op_code_t;
			f				: IN  f_code_t;
			exc_code		: IN  exc_code_t;
			in_d			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			int_type		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			datard_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			rd_io			: IN  std_LOGIC_VECTOR(15 DOWNTO 0);
			z				: OUT STD_LOGIC;
			int_e			: OUT STD_LOGIC;
			div_z			: OUT STD_LOGIC;
			sys_priv_lvl	: OUT  std_logic;
			wr_io			: OUT std_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out_path	: out std_LOGIC_VECTOR(15 downto 0)
			);
END datapath;


ARCHITECTURE Structure OF datapath IS


	
	component alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  op_code_t;
          f  : IN  f_code_t;
		  int : IN std_logic;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  z  : OUT std_logic;
		  div_z : OUT std_logic
		  );
	END component;
	
	component registers is
	PORT (	clk    		: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			wrd    		: IN  STD_LOGIC;
			wrd_s  		: IN  STD_LOGIC;
			u_s 		: IN  STD_LOGIC;
			intr		: IN  STD_LOGIC;
			inta		: IN  STD_LOGIC;
			exca		: IN  STd_LOGIC;
			privilege_lvl	: IN  std_LOGIC;
			exc_code	: IN  exc_code_t;
			int_type	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			d			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			PCup		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			int_e		: OUT STD_LOGIC;
			sys_priv_lvl: OUT std_logic;
			a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			b			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
	end component;
	


signal alu_out				: std_logic_vector(15 downto 0);
signal input_y				: std_logic_vector(15 downto 0);
signal immed_y				: std_logic_vector(15 downto 0);
signal input_d				: std_logic_vector(15 downto 0);
signal regbank_to_alu_a		: std_logic_vector(15 downto 0);
signal output_alu_or_mem	: std_logic_vector(15 downto 0);
signal regbank_to_alu_b		: std_logic_vector(15 downto 0);	
signal addr_m_buffer			: std_logic_vector(15 downto 0);	 
	 
BEGIN

	register_banks : registers port map (	clk => clk,
											boot => boot,
											wrd => wrd,
											wrd_s => wrd_s,
											u_s => u_s,
											d => input_d,
											addr_a => addr_a,
											addr_d => addr_d,
											a => regbank_to_alu_a,
											addr_b => addr_b,
											b => regbank_to_alu_b, 
											int_type => int_type,
											privilege_lvl => privilege_lvl,
											sys_priv_lvl => sys_priv_lvl,
											intr => intr,
											inta => inta,
											exca => exca,
											Pcup => pc,
											int_e => int_e,
											addr_m => addr_m_buffer,
											exc_code => exc_code
											);
	
	alu_unit : alu port map(x => regbank_to_alu_a,
							y => input_y,
							op => op,
							f => f,
							int => inta,
							w => alu_out,
							z => z,
							div_z => div_z
							);
		
	
	with immed_x2 select
		immed_y <= 	immed when '0',
					immed(14 downto 0)&'0' when others;
		
	with immed_or_reg select
		input_y <=	immed_y when '0',
					regbank_to_alu_b when others;
			
	with in_d select
		input_d <= 	alu_out when "00",
						datard_m when "01",
						pc when "10",
						rd_io when others;
						

	addr_m_buffer <= 	alu_out when ins_dad = '1' else
						pc;
								
	addr_m <= addr_m_buffer;

	data_wr <= regbank_to_alu_b;
	
	alu_out_path <= regbank_to_alu_a when exca = '1' or inta = '1' else alu_out; 

	wr_io <= regbank_to_alu_b;
	
	
END Structure;