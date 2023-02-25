LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY L1_T8 IS
	 PORT( KEY : IN std_logic_vector(0 downto 0);
	 SW : IN std_logic_vector(0 downto 0);
	 HEX0 : OUT std_logic_vector(6 downto 0);
	 HEX1 : OUT std_logic_vector(6 downto 0);
	 HEX2 : OUT std_logic_vector(6 downto 0);
	 HEX3 : OUT std_logic_vector(6 downto 0);
	 LEDR : OUT std_logic_vector(2 downto 0));
END L1_T8;

ARCHITECTURE Structure OF L1_T8 IS
BEGIN
	
END Structure;