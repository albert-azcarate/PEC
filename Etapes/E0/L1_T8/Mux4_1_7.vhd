LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY Mux4_1_7 IS
 PORT( Control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 Bus0 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
 Bus1 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
 Bus2 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
 Bus3 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
 Salida : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END Mux4_1_7;
ARCHITECTURE Structure OF Mux4_1_7 IS
BEGIN
	with Control select
		Salida <= bus0 when "000",
					bus1 when "001",
					bus2 when "010",
					bus3 when "011",
					"0111111" when others;
END Structure;