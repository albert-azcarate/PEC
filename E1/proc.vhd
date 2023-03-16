LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (boot     : IN  STD_LOGIC;
          clk      : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END proc;


ARCHITECTURE Structure OF proc IS

	component unidad_control is 
		PORT (boot   : IN  STD_LOGIC;
         clk    : IN  STD_LOGIC;
         ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
         op     : OUT STD_LOGIC;
         wrd    : OUT STD_LOGIC;
         addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
         pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;
	 	
	component datapath is
		PORT (clk    : IN STD_LOGIC;
			op     : IN STD_LOGIC;
			wrd    : IN STD_LOGIC;
			addr_a : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed  : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;

signal op_code : std_logic;
signal enable : std_logic;
signal address_a : std_logic_vector(2 downto 0) := (others => '0');
signal address_d : std_logic_vector(2 downto 0):= (others => '0');
signal imm_int : std_logic_vector(15 downto 0):= (others => '0');


	

BEGIN

	unidadcontrol : unidad_control port map (boot => boot, clk => clk, ir => datard_m, op => op_code, wrd => enable, addr_a => address_a, addr_d => address_d, immed => imm_int, pc => addr_m);
	
	data_path : datapath port map (clk => clk, op => op_code, wrd => enable, addr_a => address_a, addr_d => address_d, immed => imm_int);
	 

END Structure;