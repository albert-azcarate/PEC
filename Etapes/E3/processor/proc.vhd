LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END proc;

ARCHITECTURE Structure OF proc IS

    component unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op 		  : out  op_code_t;
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
	 end component;
	 
	 component datapath IS
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
		  immed_or_reg: IN STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	 end component;
	 
	 
 signal	op_conn       :   op_code_t;
 signal	f_conn        :   f_code_t;
 signal  wrd_conn      :   STD_LOGIC;
 signal  addr_a_conn   :   STD_LOGIC_VECTOR(2 DOWNTO 0);
 signal  addr_b_conn   :   STD_LOGIC_VECTOR(2 DOWNTO 0);
 signal  addr_d_conn   :   STD_LOGIC_VECTOR(2 DOWNTO 0);
 signal  immed_conn    :   STD_LOGIC_VECTOR(15 DOWNTO 0);
 signal  immed_x2_conn :   STD_LOGIC;
 signal  ins_dad_conn  :   STD_LOGIC;
 signal  pc_conn       :   STD_LOGIC_VECTOR(15 DOWNTO 0);
 signal  in_d_conn     :   STD_LOGIC;
 signal  immed_or_reg_conn : STD_LOGIC;
 
BEGIN
	
	UC: unidad_control port map(	boot => boot,
											clk => clk,
											datard_m => datard_m,
											op => op_conn,
											f => f_conn,
											wrd => wrd_conn,
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
											immed_or_reg => immed_or_reg_conn);
	
	PATH: datapath port map(clk => clk,
									datard_m => datard_m,
									op => op_conn,
									f => f_conn,
									wrd => wrd_conn,
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
									immed_or_reg => immed_or_reg_conn);

END Structure;