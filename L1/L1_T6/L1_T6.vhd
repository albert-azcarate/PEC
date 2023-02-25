LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY L1_T6 IS
 PORT( SW : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END L1_T6;
ARCHITECTURE Structure OF L1_T6 IS
BEGIN
 HEX0 <= "1000000"	when SW = "0" else
			"1111001"	when SW = "1" else
			"0100100"	when SW = "10" else
			"0110000"	when SW = "11" else
			"0011001"	when SW = "100" else
			"0010010"	when SW = "101" else
			"0000010"	when SW = "110" else
			"1111000"	when SW = "111" else
			"0000000"	when SW = "1000" else
			"0010000"	when SW = "1001";
END Structure;