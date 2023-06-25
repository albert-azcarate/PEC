LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

use work.op_code.all;
use work.f_code.all;


ENTITY alu_fp_cmp IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          eq  : OUT STD_LOGIC;
			 lt : OUT STD_LOGIC;
			 le: OUT STD_LOGIC
		  );
END alu_fp_cmp;


ARCHITECTURE Structure OF alu_fp_cmp IS

BEGIN

eq <= 	'0' when (x(14 downto 9) = "111111" and x(8 downto 0) /= "000000000") or (y(14 downto 9) = "111111" and y(8 downto 0) /= "000000000") else		-- NaN always false
		'1' when x = y else
		'1' when x(14 downto 0) = 0 and y(14 downto 0) = 0 else 
		'0';


lt <= 	'0' when (x(14 downto 9) = "111111" and x(8 downto 0) /= 0) or (y(14 downto 9) = "111111" and y(8 downto 0) /= 0) else 	-- NaN always false
		'0' when x = x"FE00" and y = x"FE00" else		-- -inf < x -> false if y = -inf
		'0' when x = x"7E00" and y = x"7E00" else
		'1' when (x(15) = '1' and y(15) = '0' and x /= 0 and  y /= 0) 
					or 
				   ((x(15) = '0' and y(15) = '0') and (x(14 downto 9) < y(14 downto 9))) or
					((x(15) = '0' and y(15) = '0') and (x(14 downto 9) = y(14 downto 9)) and (x(8 downto 0) < y(8 downto 0))) -- diff singe
					or
					((x(15) = '1' and y(15) = '1') and (x(14 downto 9) > y(14 downto 9))) or
					((x(15) = '1' and y(15) = '1') and (x(14 downto 9) = y(14 downto 9)) and (x(8 downto 0) > y(8 downto 0))) else 
		'0';
					
le <= 	'0' when (x(14 downto 9) = "111111" and x(8 downto 0) /= "000000000") or (y(14 downto 9) = "111111" and y(8 downto 0) /= "000000000") else		-- NaN always false
		'1' when x = y else
		'1' when x(14 downto 0) = 0 and y(14 downto 0) = 0 else 
		'1' when (x(15) = '1' and y(15) = '0' and x /= 0 and  y /= 0) 
					or 
					((x(15) = '0' and y(15) = '0') and (x(14 downto 9) < y(14 downto 9))) or
					(((x(15) = '0' and y(15) = '0') and (x(14 downto 9) = y(14 downto 9))) and (x(8 downto 0) <= y(8 downto 0))) -- diff singe
					or
					((x(15) = '1' and y(15) = '1') and (x(14 downto 9) > y(14 downto 9))) or
					((x(15) = '1' and y(15) = '1') and (x(14 downto 9) = y(14 downto 9)) and (x(8 downto 0) >= y(8 downto 0))) else
		'0';

END Structure;
