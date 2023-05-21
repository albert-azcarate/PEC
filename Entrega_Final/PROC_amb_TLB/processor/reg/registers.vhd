LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.exc_code.all;

ENTITY registers IS
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
			sys_priv_lvl: OUT std_logic;
			int_e		: OUT STD_LOGIC;
			a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			b			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
END registers;

ARCHITECTURE Structure OF registers IS

component regfile IS
    PORT (clk    : IN  STD_LOGIC;
		  boot		: IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END component;

component sysregfile IS
    PORT (	clk			: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			wrd			: IN  STD_LOGIC;
			intr		: IN  STD_LOGIC;	
			inta		: IN  STD_LOGIC;
			exca		: IN  STd_LOGIC;
			priv_lvl	: IN  std_LOGIC;
			exc_code	: IN  exc_code_t;
		  	int_type	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			d			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0); --from REGfile std
			PCup		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			int_e 		: OUT STD_LOGIC;
			sys_priv_lvl: OUT std_logic;
			a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
	END component;

signal a_user : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal a_sys : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
	
	sys_register_bank : sysregfile port map (	clk => clk,
												boot => boot,
												wrd => wrd_s,
												d => d,
												addr_a => addr_a,
												addr_d => addr_d,
												int_type => int_type,
												a => a_sys,
												intr => intr,
												inta => inta,
												exca => exca,
												PCup => PCup,
												priv_lvl => privilege_lvl,
												sys_priv_lvl => sys_priv_lvl,
												int_e => int_e,
												addr_m => addr_m,
												exc_code => exc_code
												);
	
	register_bank : regfile port map (	clk => clk,
										boot => boot,
										wrd => wrd,
										d => d,
										addr_a => addr_a,
										addr_d => addr_d,
										a => a_user,
										addr_b => addr_b,
										b => b
										);

	

	a <= a_user when u_s = '0' else a_sys;
	
END Structure;