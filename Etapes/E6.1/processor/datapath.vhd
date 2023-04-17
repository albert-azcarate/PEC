LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
          op 		 : IN  op_code_t;
          f        : IN  f_code_t;
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		  immed_or_reg : IN STD_LOGIC;
		  rd_io	 : IN std_LOGIC_VECTOR(15 DOWNTO 0);
		  wr_io	 : OUT std_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  alu_out_path  : out std_LOGIC_VECTOR(15 downto 0);
		  z  : OUT std_LOGIC);
END datapath;


ARCHITECTURE Structure OF datapath IS

	component regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
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
signal regbank_to_alu_a : std_logic_vector(15 downto 0);
signal input_y : std_logic_vector(15 downto 0);
signal immed_y : std_logic_vector(15 downto 0);
signal input_d : std_logic_vector(15 downto 0);
signal output_alu_or_mem : std_logic_vector(15 downto 0);
signal regbank_to_alu_b : std_logic_vector(15 downto 0);	 
	 
BEGIN

   register_bank : regfile port map (	clk => clk,
													wrd => wrd,
													d => input_d,
													addr_a => addr_a,
													addr_d => addr_d,
													a => regbank_to_alu_a,
													addr_b => addr_b,
													b => regbank_to_alu_b );
	
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
END Structure;