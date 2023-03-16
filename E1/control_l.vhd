LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          ldpc   : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END control_l;


ARCHITECTURE Structure OF control_l IS
BEGIN

   with ir select
		ldpc <= 	'0' when x"FFFF",
					'1' when others;
					
	with ir(15 downto 12) select 
		wrd <=	'1' when x"5", -- MOV
					'0' when others;
	
		
	immed(15 downto 8) <= (others => ir(7)); -- extenem singe
	immed(7 downto 0) <= ir(7 downto 0); -- copiem
		
	op <= ir(8);
	
	addr_a <= ir(11 downto 9);
	addr_d <= ir(11 downto 9);
		
END Structure;