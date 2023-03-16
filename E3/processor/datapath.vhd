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
          in_d     : IN  STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END datapath;


ARCHITECTURE Structure OF datapath IS


	component regfile is 
		PORT (clk    : IN  STD_LOGIC;
				wrd    : IN  STD_LOGIC;
				d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;
	
	component alu is
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				op : IN  op_code_t;
				f  : IN  f_code_t;
				w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;
		

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	 
signal alu_out : std_logic_vector(15 downto 0);
signal regbank_to_alu : std_logic_vector(15 downto 0);
signal input_y : std_logic_vector(15 downto 0);
signal input_d : std_logic_vector(15 downto 0);
signal output_alu_or_mem : std_logic_vector(15 downto 0);
	 
	 
BEGIN

   register_bank : regfile port map (	clk => clk,
													wrd => wrd,
													d => input_d,
													addr_a => addr_a,
													addr_d => addr_d,
													a => regbank_to_alu,
													addr_b => addr_b,
													b => data_wr );
	
	alu_unit : alu port map(x => regbank_to_alu,
									y => input_y,
									op => op,
									f => f,
									w => alu_out);
	 
	with immed_x2 select
		input_y <= 	immed when '0',
						immed(14 downto 0)&'0' when others;
			
	with in_d select
		input_d <= 	alu_out when '0',
						datard_m when others;
						
	with ins_dad select
		addr_m <= 	alu_out when '1',
						pc when others;
	 
END Structure;