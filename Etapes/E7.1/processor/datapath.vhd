LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY datapath IS
	PORT (	clk				: IN  STD_LOGIC;
			wrd				: IN  STD_LOGIC;
			wrd_s			: IN  STD_LOGIC;
			u_s				: IN  STD_LOGIC;
			immed_x2		: IN  STD_LOGIC;
			ins_dad			: IN  STD_LOGIC;
			immed_or_reg	: IN  STD_LOGIC;
			intr 				: IN std_logic;
		  inta		: IN STD_LOGIC;
			op				: IN  op_code_t;
			f				: IN  f_code_t;
			addr_a			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			datard_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			in_d			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			int_type		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			rd_io			: IN  std_LOGIC_VECTOR(15 DOWNTO 0);
			z				: OUT std_LOGIC;
			int_e		: OUT STD_LOGIC;
			wr_io			: OUT std_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out_path	: out std_LOGIC_VECTOR(15 downto 0);
			SW 			: in std_logic_vector(7 downto 0);	
			reg_debug   : out    std_logic_vector(15 downto 0);
			);
END datapath;


ARCHITECTURE Structure OF datapath IS


	COMPONENT registers IS
    PORT (clk    	: IN  STD_LOGIC;
          wrd    	: IN  STD_LOGIC;
		  wrd_s  	: IN  STD_LOGIC;
		  u_s 	 	: IN  STD_LOGIC;
          d      	: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a 	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b 	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d 	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  int_type	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  addr_debug : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  debug 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		  );
	END component;

	
	component alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  op_code_t;
          f  : IN  f_code_t;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  z  : OUT std_logic);
	END component;


signal alu_out : std_logic_vector(15 downto 0);
signal input_y : std_logic_vector(15 downto 0);
signal immed_y : std_logic_vector(15 downto 0);
signal input_d : std_logic_vector(15 downto 0);
signal regbank_to_alu_a : std_logic_vector(15 downto 0);
signal output_alu_or_mem : std_logic_vector(15 downto 0);
signal regbank_to_alu_b : std_logic_vector(15 downto 0);	 
	 
BEGIN

	register_banks : registers port map (	clk => clk,
											wrd => wrd,
											wrd_s => wrd_s,
											u_s => u_s,
											d => input_d,
											addr_a => addr_a,
											addr_d => addr_d,
											a => regbank_to_alu_a,
											addr_b => addr_b,
											b => regbank_to_alu_b, 
<<<<<<< HEAD:E7.1/processor/datapath.vhd
											int_type => int_type,
											intr => intr,
											inta => inta,
											Pcup => pc,
											int_e => int_e
=======
											int_type => int_type,
											debug => regbank_debug
>>>>>>> 6ffa200d9039d8eda8607a90260c725afc38b373:Etapes/E7.1/processor/datapath.vhd
											);
	
	alu_unit : alu port map(x => regbank_to_alu_a,
							y => input_y,
							op => op,
							f => f,
							w => alu_out,
							z => z);
		
	
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
						
	with ins_dad select
		addr_m <= 	alu_out when '1',
						pc when others;
						
	data_wr <= regbank_to_alu_b;
	
	alu_out_path <= alu_out; 
	 
	wr_io <= regbank_to_alu_b;

	-- assign addr_debug based on which swicth(7 downto 0) is toggled
	addr_debug <=	"000" when SW = "00000001" else
					"001" when SW = "00000010" else
					"010" when SW = "00000100" else
					"011" when SW = "00001000" else
					"100" when SW = "00010000" else
					"101" when SW = "00100000" else
					"110" when SW = "01000000" else
					"111" when SW = "10000000" else
					"000";


	reg_debug <= regbank_debug;
END Structure;