LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.all;

ENTITY registers IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
		  wrd_s  : IN  STD_LOGIC;
		  u_s 	 : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		  );
END registers;

ARCHITECTURE Structure OF registers IS

component regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		  );
	END component;

component sysregfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		  );
	END component;

signal a_user : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal a_sys : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
	
	register_bank : regfile port map (	clk => clk,
										wrd => wrd,
										d => d,
										addr_a => addr_a,
										addr_d => addr_d,
										a => a_user,
										addr_b => addr_b,
										b => b 
										);

	sys_register_bank : sysregfile port map (	clk => clk,
												wrd => wrd_s,
												d => d,
												addr_a => addr_a,
												addr_d => addr_d,
												a => a_sys
												);

	a <= a_user when u_s = '0' else a_sys;
	
END Structure;